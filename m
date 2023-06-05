Return-Path: <netdev+bounces-8009-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7C03D722674
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 14:54:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DDEEA1C20ACA
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 12:54:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5557F18C1C;
	Mon,  5 Jun 2023 12:54:50 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 404B618C12
	for <netdev@vger.kernel.org>; Mon,  5 Jun 2023 12:54:50 +0000 (UTC)
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DEF51113;
	Mon,  5 Jun 2023 05:54:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1685969679; x=1717505679;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=a+Tn4FBYo0QLrStvlRhVV+bb1iI8O3ndmJkkVSEip2g=;
  b=UrrUXL2U0aZ/WMYl2TJe4L43Ci0uiIw0ckuebDEMyk9b1eYP6uiGyDm1
   QZRIV5jHc+n3XRaeYEk9uhNAYpdU2xGvA9w52JKjIivntKsEBbxQD2gtz
   qLodBXgsC8Dy07GEB+uZMJN37HwXju2ZVRXY/bIs1nLrGaza64xOwcBJQ
   G29brtYJmJpxPcnYi7M52et78zAPQL+akRqBoScTHRNyJDz4lM9jDd8g1
   1LasS3xwWpcnIVFa5nO4dqBT6YxnWjGudYhHeJTwJ377WKs6Krxz7FUhu
   trA+KDCqek4yAFVl+Y/jpwvIaP/209vgvOlQBUweu+/2y2F8ZCCq5d+yY
   Q==;
X-IronPort-AV: E=Sophos;i="6.00,217,1681196400"; 
   d="scan'208";a="155562864"
X-Amp-Result: SKIPPED(no attachment in message)
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 05 Jun 2023 05:54:38 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Mon, 5 Jun 2023 05:54:37 -0700
Received: from [10.159.245.112] (10.10.115.15) by chn-vm-ex04.mchp-main.com
 (10.10.85.152) with Microsoft SMTP Server id 15.1.2507.21 via Frontend
 Transport; Mon, 5 Jun 2023 05:54:25 -0700
Message-ID: <bf0ab4e0-7e0b-3fb6-f54e-d75acb54ce5e@microchip.com>
Date: Mon, 5 Jun 2023 14:54:18 +0200
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH 03/21] dt-bindings: usb: generic-ehci: Document
 clock-names property
Content-Language: en-US
To: Conor Dooley <conor@kernel.org>, Varshini Rajendran
	<varshini.rajendran@microchip.com>
CC: <tglx@linutronix.de>, <maz@kernel.org>, <robh+dt@kernel.org>,
	<krzysztof.kozlowski+dt@linaro.org>, <conor+dt@kernel.org>,
	<alexandre.belloni@bootlin.com>, <claudiu.beznea@microchip.com>,
	<davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
	<pabeni@redhat.com>, <gregkh@linuxfoundation.org>, <linux@armlinux.org.uk>,
	<mturquette@baylibre.com>, <sboyd@kernel.org>, <sre@kernel.org>,
	<broonie@kernel.org>, <arnd@arndb.de>, <gregory.clement@bootlin.com>,
	<sudeep.holla@arm.com>, <balamanikandan.gunasundar@microchip.com>,
	<mihai.sain@microchip.com>, <linux-kernel@vger.kernel.org>,
	<devicetree@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
	<netdev@vger.kernel.org>, <linux-usb@vger.kernel.org>,
	<linux-clk@vger.kernel.org>, <linux-pm@vger.kernel.org>,
	<Hari.PrasathGE@microchip.com>, <cristian.birsan@microchip.com>,
	<durai.manickamkr@microchip.com>, <manikandan.m@microchip.com>,
	<dharma.b@microchip.com>, <nayabbasha.sayed@microchip.com>,
	<balakrishnan.s@microchip.com>
References: <20230603200243.243878-1-varshini.rajendran@microchip.com>
 <20230603200243.243878-4-varshini.rajendran@microchip.com>
 <20230603-skincare-ideology-bfbc3fd384c5@spud>
From: Nicolas Ferre <nicolas.ferre@microchip.com>
Organization: microchip
In-Reply-To: <20230603-skincare-ideology-bfbc3fd384c5@spud>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
	RCVD_IN_DNSWL_MED,SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 03/06/2023 at 23:15, Conor Dooley wrote:
> Hey Varshini,
> 
> On Sun, Jun 04, 2023 at 01:32:25AM +0530, Varshini Rajendran wrote:
>> Document the property clock-names in the schema.
>>
>> It fixes the dtbs_warning,
> s/dtbs_warning/dtbs_check warning/?
> 
>> 'clock-names' does not match any of the regexes: 'pinctrl-[0-9]+'
> Does this fix a warning currently in the tree, or fix a warning
> introduced by some patches in this series? (Or both?)

Our USB DT pattern is the same on all our newer SoC, to it mustn't be 
introduced by the addition of this one.

Best regards,
   Nicolas

>> Signed-off-by: Varshini Rajendran<varshini.rajendran@microchip.com>
>> ---
>>   Documentation/devicetree/bindings/usb/generic-ehci.yaml | 4 ++++
>>   1 file changed, 4 insertions(+)
>>
>> diff --git a/Documentation/devicetree/bindings/usb/generic-ehci.yaml b/Documentation/devicetree/bindings/usb/generic-ehci.yaml
>> index 7e486cc6cfb8..542ac26960fc 100644
>> --- a/Documentation/devicetree/bindings/usb/generic-ehci.yaml
>> +++ b/Documentation/devicetree/bindings/usb/generic-ehci.yaml
>> @@ -102,6 +102,10 @@ properties:
>>           - if a USB DRD channel: first clock should be host and second
>>             one should be peripheral
>>   
>> +  clock-names:
>> +    minItems: 1
>> +    maxItems: 4
>> +
>>     power-domains:
>>       maxItems: 1
>>   
>> -- 
>> 2.25.1

-- 
Nicolas Ferre


