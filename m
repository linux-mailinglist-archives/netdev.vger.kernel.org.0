Return-Path: <netdev+bounces-7980-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6426E72252E
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 14:03:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1F51E281148
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 12:03:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6370218018;
	Mon,  5 Jun 2023 12:03:26 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55D7A11C9B
	for <netdev@vger.kernel.org>; Mon,  5 Jun 2023 12:03:26 +0000 (UTC)
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E8FBDF;
	Mon,  5 Jun 2023 05:03:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1685966602; x=1717502602;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=zsidaSn1i/iv5LQiieaPSxJTMyknvoIIzx4eM0WTWl8=;
  b=l3q8VVdSdp7sfLHWfSZ223lbjTU6+feHJDHf24bvS+W+hipE8yfQ+Fva
   aWT54+dZ+EYlBPjMR/MAfAldwB/7Jelktn6rErU1CI8xJQuQ51JTnehtV
   IaYYV2hz5QyB5HBkDujhivPUWNOIbBP6Q1ZPKGtuRk0f5n6/aZYOC9s8H
   UTz6JUD5Jywsi38pyJqgtJ/YUrLSFfuhM01WiGJjI9w3JbfffWNNbhB1b
   l5oRFobtSWtEhVr96RR6Sjv0+JcBoAueScBN42iWbzypMm27qgqgQF6mE
   tA8gFcIivi++7LVWRtUag1REypSogt1KDUcBrphVVeNEdYZT5yE1LZDXm
   Q==;
X-IronPort-AV: E=Sophos;i="6.00,217,1681196400"; 
   d="scan'208";a="216845804"
X-Amp-Result: SKIPPED(no attachment in message)
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 05 Jun 2023 05:03:21 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Mon, 5 Jun 2023 05:03:16 -0700
Received: from [10.159.245.112] (10.10.115.15) by chn-vm-ex01.mchp-main.com
 (10.10.85.143) with Microsoft SMTP Server id 15.1.2507.21 via Frontend
 Transport; Mon, 5 Jun 2023 05:03:09 -0700
Message-ID: <27d2e946-0f81-40e7-43f9-00369883f68b@microchip.com>
Date: Mon, 5 Jun 2023 14:03:02 +0200
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH 01/21] dt-bindings: microchip: atmel,at91rm9200-tcb: add
 sam9x60 compatible
Content-Language: en-US
To: Arnd Bergmann <arnd@arndb.de>, Krzysztof Kozlowski
	<krzysztof.kozlowski@linaro.org>, Varshini Rajendran
	<varshini.rajendran@microchip.com>, Thomas Gleixner <tglx@linutronix.de>,
	Marc Zyngier <maz@kernel.org>, Rob Herring <robh+dt@kernel.org>,
	<krzysztof.kozlowski+dt@linaro.org>, Conor Dooley <conor+dt@kernel.org>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>, Claudiu Beznea
	<claudiu.beznea@microchip.com>, "David S . Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, "Paolo
 Abeni" <pabeni@redhat.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Russell King <linux@armlinux.org.uk>, Michael Turquette
	<mturquette@baylibre.com>, Stephen Boyd <sboyd@kernel.org>, Sebastian Reichel
	<sre@kernel.org>, Mark Brown <broonie@kernel.org>, Gregory Clement
	<gregory.clement@bootlin.com>, Sudeep Holla <sudeep.holla@arm.com>,
	Balamanikandan Gunasundar <balamanikandan.gunasundar@microchip.com>,
	Mihai.Sain <mihai.sain@microchip.com>, <linux-kernel@vger.kernel.org>,
	<devicetree@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>, Netdev
	<netdev@vger.kernel.org>, <linux-usb@vger.kernel.org>,
	<linux-clk@vger.kernel.org>, <linux-pm@vger.kernel.org>
CC: <Hari.PrasathGE@microchip.com>, <cristian.birsan@microchip.com>,
	<durai.manickamkr@microchip.com>, <manikandan.m@microchip.com>,
	<dharma.b@microchip.com>, <nayabbasha.sayed@microchip.com>,
	<balakrishnan.s@microchip.com>
References: <20230603200243.243878-1-varshini.rajendran@microchip.com>
 <20230603200243.243878-2-varshini.rajendran@microchip.com>
 <c72f45ec-c185-8676-b31c-ec48cd46278c@linaro.org>
 <d95d37f5-5bef-43a9-b319-0bbe0ac366b4@app.fastmail.com>
From: Nicolas Ferre <nicolas.ferre@microchip.com>
Organization: microchip
In-Reply-To: <d95d37f5-5bef-43a9-b319-0bbe0ac366b4@app.fastmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
	RCVD_IN_DNSWL_MED,SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 05/06/2023 at 09:04, Arnd Bergmann wrote:
> On Mon, Jun 5, 2023, at 08:35, Krzysztof Kozlowski wrote:
>> On 03/06/2023 22:02, Varshini Rajendran wrote:
>>> Add sam9x60 compatible string support in the schema file
>>>
>>> Signed-off-by: Varshini Rajendran <varshini.rajendran@microchip.com>
>>> ---
>>>   .../devicetree/bindings/soc/microchip/atmel,at91rm9200-tcb.yaml  | 1 +
>>>   1 file changed, 1 insertion(+)
>>>
>>> diff --git a/Documentation/devicetree/bindings/soc/microchip/atmel,at91rm9200-tcb.yaml b/Documentation/devicetree/bindings/soc/microchip/atmel,at91rm9200-tcb.yaml
>>> index a46411149571..c70c77a5e8e5 100644
>>> --- a/Documentation/devicetree/bindings/soc/microchip/atmel,at91rm9200-tcb.yaml
>>> +++ b/Documentation/devicetree/bindings/soc/microchip/atmel,at91rm9200-tcb.yaml
>>> @@ -20,6 +20,7 @@ properties:
>>>             - atmel,at91rm9200-tcb
>>>             - atmel,at91sam9x5-tcb
>>>             - atmel,sama5d2-tcb
>>> +          - microchip,sam9x60-tcb
>>
>> No wildcards.
> 
> sam9x60 is the actual name of the chip, it's no wildcard. For sam9x70,
> sam9x72 and sam9x75, I think using sam9x7 as the compatible string
> is probably fine, as long as they are actually the same chip. Again,
> the 'x' in there is not a wildcard but part of the name.

Yes, exactly Arnd, for those two SoC, 'x' is not a wildcard.

Best regards,
   Nicolas


-- 
Nicolas Ferre


