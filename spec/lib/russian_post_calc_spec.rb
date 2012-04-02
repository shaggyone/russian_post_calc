# coding: UTF-8
require 'spec_helper'

describe RussianPostCalc do

  describe "::calculate_delivery_price" do
    let(:from_index)     { "190000" }
    let(:to_index)       { "660000" }
    let(:weight)         { 2.5 }
    let(:declared_value) { 500 }

    let(:response_body) { "<div id='content'>Доставка Почтой России: 171.9 руб. Контрольный срок: 11* дн.</div>" }

    subject { Calc.calculate_delivery_price from_index, to_index, weight, declared_value }

    before :each do
      FakeWeb.register_uri :post, "http://russianpostcalc.ru/", :body => response_body
    end

    it "Parses calculation results correctly" do
      subject.should be == 171.9
    end

    context "Error during calculation" do
      let(:response_body) { "<div id='content'><div class='errors'><ul><li>Error text</li></ul></div></div>" }

      it "parses and rises error correctly" do
        expect { subject }.to raise_error "Error text"
      end

    end

  end

end
