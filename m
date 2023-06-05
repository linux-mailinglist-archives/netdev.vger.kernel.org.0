Return-Path: <netdev+bounces-7989-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1DCF072260D
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 14:38:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0A74A1C20B65
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 12:38:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BB5EF6FC3;
	Mon,  5 Jun 2023 12:38:01 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB01F6D19
	for <netdev@vger.kernel.org>; Mon,  5 Jun 2023 12:38:01 +0000 (UTC)
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FD0BE8;
	Mon,  5 Jun 2023 05:37:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1685968659; x=1717504659;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=3qZ9HUtKkrRCZ6pttiD0fABhp7XxMD/NZypAKra7/nI=;
  b=zmW1Kfnz/9WtSOdbRyawwHs2gtEfcqGeiDRpMbQBIJ2tXpjm5EVKXcak
   Y18LYJvj6suBFaecX5AM5hePEvHNJdha+12pOP9NIqqYeHGoOuJiuNIs2
   Mep7Dl3Y6irMvPZvYyDQXbzBy8CB3Qk5SF+cwSkm/YAzEonZiI+9JiR4t
   EzT7E5e53ItTOnfLZz10DaBATcqmPDjvHqOeBsp+S0KHeAutJqjXcXAI5
   sTwWxt6TRtDKrQ76exmV8u7lueTj1eCed5fB2HGtpPQ5m9MllG85pmJ2+
   baYFWNB93/LCMk+OSAs1myPFyCqGoYz8ZtvdnYGlwKJG7NGS4Ot837LVR
   Q==;
X-IronPort-AV: E=Sophos;i="6.00,217,1681196400"; 
   d="scan'208";a="216851473"
X-Amp-Result: SKIPPED(no attachment in message)
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 05 Jun 2023 05:37:35 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Mon, 5 Jun 2023 05:37:29 -0700
Received: from [10.159.245.112] (10.10.115.15) by chn-vm-ex02.mchp-main.com
 (10.10.85.144) with Microsoft SMTP Server id 15.1.2507.21 via Frontend
 Transport; Mon, 5 Jun 2023 05:37:23 -0700
Message-ID: <add5e49e-8416-ba9f-819a-da944938c05f@microchip.com>
Date: Mon, 5 Jun 2023 14:37:16 +0200
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH 15/21] dt-bindings: irqchip/atmel-aic5: Add support for
 sam9x7 aic
Content-Language: en-US
To: Conor Dooley <conor@kernel.org>, Arnd Bergmann <arnd@arndb.de>
CC: Varshini Rajendran <varshini.rajendran@microchip.com>, Thomas Gleixner
	<tglx@linutronix.de>, Marc Zyngier <maz@kernel.org>, Rob Herring
	<robh+dt@kernel.org>, <krzysztof.kozlowski+dt@linaro.org>, Conor Dooley
	<conor+dt@kernel.org>, Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Claudiu Beznea <claudiu.beznea@microchip.com>, "David S . Miller"
	<davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, Jakub Kicinski
	<kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, Greg Kroah-Hartman
	<gregkh@linuxfoundation.org>, Russell King <linux@armlinux.org.uk>, "Michael
 Turquette" <mturquette@baylibre.com>, Stephen Boyd <sboyd@kernel.org>,
	Sebastian Reichel <sre@kernel.org>, Mark Brown <broonie@kernel.org>, "Gregory
 Clement" <gregory.clement@bootlin.com>, Sudeep Holla <sudeep.holla@arm.com>,
	Balamanikandan Gunasundar <balamanikandan.gunasundar@microchip.com>,
	<mihai.sain@microchip.com>, <linux-kernel@vger.kernel.org>,
	<devicetree@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>, Netdev
	<netdev@vger.kernel.org>, <linux-usb@vger.kernel.org>,
	<linux-clk@vger.kernel.org>, <linux-pm@vger.kernel.org>,
	<Hari.PrasathGE@microchip.com>, <cristian.birsan@microchip.com>,
	<durai.manickamkr@microchip.com>, <manikandan.m@microchip.com>,
	<dharma.b@microchip.com>, <nayabbasha.sayed@microchip.com>,
	<balakrishnan.s@microchip.com>
References: <20230603200243.243878-1-varshini.rajendran@microchip.com>
 <20230603200243.243878-16-varshini.rajendran@microchip.com>
 <20230603-fervor-kilowatt-662c84b94853@spud>
 <20230603-sanded-blunderer-73cdd7c290c1@spud>
 <4d3694b3-8728-42c1-8497-ae38134db37c@app.fastmail.com>
 <20230604-cohesive-unmoving-032da3272620@spud>
From: Nicolas Ferre <nicolas.ferre@microchip.com>
Organization: microchip
In-Reply-To: <20230604-cohesive-unmoving-032da3272620@spud>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
	RCVD_IN_DNSWL_MED,SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Arnd, Conor,

On 04/06/2023 at 23:08, Conor Dooley wrote:
> On Sun, Jun 04, 2023 at 11:49:48AM +0200, Arnd Bergmann wrote:
>> On Sat, Jun 3, 2023, at 23:23, Conor Dooley wrote:
>>> On Sat, Jun 03, 2023 at 10:19:50PM +0100, Conor Dooley wrote:
>>>> Hey Varshini,
>>>>
>>>> On Sun, Jun 04, 2023 at 01:32:37AM +0530, Varshini Rajendran wrote:
>>>>> Document the support added for the Advanced interrupt controller(AIC)
>>>>> chip in the sam9x7 soc family
>>>> Please do not add new family based compatibles, but rather use per-soc
>>>> compatibles instead.
>>> These things leave me penally confused. Afaiu, sam9x60 is a particular
> s/penally/perennially/
> 
>>> SoC. sam9x7 is actually a family, containing sam9x70, sam9x72 and
>>> sam9x75. It would appear to me that each should have its own compatible,
>>> no?
>> I think the usual way this works is that the sam9x7 refers to the
>> SoC design as in what is actually part of the chip, whereas the 70,
>> 72 and 75 models are variants that have a certain subset of the
>> features enabled.

Yes, That's the case.
>> If that is the case here, then referring to the on-chip parts by
>> the sam9x7 name makes sense, and this is similar to what we do
>> on TI AM-series chips.

This is what we did for most of our SoCs families, indeed.

> If it is the case that what differentiates them is having bits chopped
> off, and there's no implementation differences that seems fair.

Ok, thanks.

>> There is a remaining risk that a there would be a future
>> sam9x71/73/74/76/... product based on a new chip that uses
>> incompatible devices, but at that point we can still use the
>> more specific model number to identify those without being
>> ambiguous. 

This is exactly what we did for sama5d29 which is not the same silicon 
vs. the other members of the sama5d2 family. We used the more specify 
sama5d29 sub-string for describing the changing parts (CAN-FD and Ethernet).

>> The same thing can of course happen when a SoC
>> vendor reuses a specific name of a prior product with an update
>> chip that has software visible changes.
>>
>> I'd just leave this up to Varshini and the other at91 maintainers
>> here, provided they understand the exact risks.

Yep, I understand the risk and will try to review the compatibility 
strings that would need more precise description (maybe PMC or AIC).

> Ye, seems fair to me. Nicolas/Claudiu etc, is there a convention to use
> the "0" model as the compatible (like the 9x60 did) or have "random"
> things been done so far?

sam9x60 was a single SoC, not a member of a "family", so there was no 
meaning of the "0" here. Moreover, the "0" ones are usually not the 
subset, if it even exists.
So far, we used the silicon string to define the compatibility string, 
adding a more precise string for hardware of family members that needed 
it (as mentioned above for sama5d29).

>> It's different for the parts that are listed as just sam9x60
>> compatible in the DT, I think those clearly need to have sam9x7
>> in the compatible list, but could have the sam9x60 identifier
>> as a fallback if the hardware is compatible.
> Aye.

Yep, agreed.

Thanks for your help. Best regards,
   Nicolas

-- 
Nicolas Ferre


