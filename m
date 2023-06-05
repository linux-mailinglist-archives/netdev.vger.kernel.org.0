Return-Path: <netdev+bounces-7981-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 9AA7072253C
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 14:08:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id F39FD2810FA
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 12:08:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 07EE6182A4;
	Mon,  5 Jun 2023 12:08:22 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F039E525E
	for <netdev@vger.kernel.org>; Mon,  5 Jun 2023 12:08:21 +0000 (UTC)
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66E6B92;
	Mon,  5 Jun 2023 05:08:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1685966901; x=1717502901;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=dQT6oVcoi6OibIBbA3hTG2i3vMqElgYwkRHP4oreT70=;
  b=Jy9z2fXDE2qtQ1lqdFjdSSv3OFFyUsvnrDAtls8Lz7O+vre+hby6wRkb
   2eg8yY1nJdM3WDrNHMwdbYK7oxxIMCYD4ihvxIyOHM2tS441oGoXrHVcu
   SS4dQs2a3WOapQ+NrPC61tcGW9gNEHhnvA20BLNl3fqcjBe9U6rTJUPKS
   lHQu1lNA2pkYLeXve66pfzLyGvUxaurrkQDe6HUL9nDb5SsTa8bxx6wli
   0bAALD/ykGl0iENyxunBdInRUkaZr7Oti9OIQ1MESnCMTUEmcsbPquKaL
   hKFt/9c7QZZXEyBPYPWhX+sMJm/HASBa3v7x8mMl9K0V211OR5bow1g/a
   w==;
X-IronPort-AV: E=Sophos;i="6.00,217,1681196400"; 
   d="scan'208";a="214645686"
X-Amp-Result: SKIPPED(no attachment in message)
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 05 Jun 2023 05:08:19 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Mon, 5 Jun 2023 05:07:46 -0700
Received: from [10.159.245.112] (10.10.115.15) by chn-vm-ex01.mchp-main.com
 (10.10.85.143) with Microsoft SMTP Server id 15.1.2507.21 via Frontend
 Transport; Mon, 5 Jun 2023 05:07:39 -0700
Message-ID: <3e262485-bf5f-1a98-e399-e02add3eaa89@microchip.com>
Date: Mon, 5 Jun 2023 14:07:32 +0200
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH 21/21] net: macb: add support for gmac to sam9x7
Content-Language: en-US
To: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>, Varshini Rajendran
	<varshini.rajendran@microchip.com>, <tglx@linutronix.de>, <maz@kernel.org>,
	<robh+dt@kernel.org>, <krzysztof.kozlowski+dt@linaro.org>,
	<conor+dt@kernel.org>, <alexandre.belloni@bootlin.com>,
	<claudiu.beznea@microchip.com>, <davem@davemloft.net>, <edumazet@google.com>,
	<kuba@kernel.org>, <pabeni@redhat.com>, <gregkh@linuxfoundation.org>,
	<linux@armlinux.org.uk>, <mturquette@baylibre.com>, <sboyd@kernel.org>,
	<sre@kernel.org>, <broonie@kernel.org>, <arnd@arndb.de>,
	<gregory.clement@bootlin.com>, <sudeep.holla@arm.com>,
	<balamanikandan.gunasundar@microchip.com>, <mihai.sain@microchip.com>,
	<linux-kernel@vger.kernel.org>, <devicetree@vger.kernel.org>,
	<linux-arm-kernel@lists.infradead.org>, <netdev@vger.kernel.org>,
	<linux-usb@vger.kernel.org>, <linux-clk@vger.kernel.org>,
	<linux-pm@vger.kernel.org>
CC: <Hari.PrasathGE@microchip.com>, <cristian.birsan@microchip.com>,
	<durai.manickamkr@microchip.com>, <manikandan.m@microchip.com>,
	<dharma.b@microchip.com>, <nayabbasha.sayed@microchip.com>,
	<balakrishnan.s@microchip.com>
References: <20230603200243.243878-1-varshini.rajendran@microchip.com>
 <20230603200243.243878-22-varshini.rajendran@microchip.com>
 <be3716e0-383f-e79a-b441-c606c0e049df@linaro.org>
From: Nicolas Ferre <nicolas.ferre@microchip.com>
Organization: microchip
In-Reply-To: <be3716e0-383f-e79a-b441-c606c0e049df@linaro.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
	RCVD_IN_DNSWL_MED,SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 05/06/2023 at 08:42, Krzysztof Kozlowski wrote:
> EXTERNAL EMAIL: Do not click links or open attachments unless you know the content is safe
> 
> On 03/06/2023 22:02, Varshini Rajendran wrote:
>> From: Nicolas Ferre <nicolas.ferre@microchip.com>
>>
>> Add support for GMAC in sam9x7 SoC family
>>
>> Signed-off-by: Varshini Rajendran <varshini.rajendran@microchip.com>
>> Signed-off-by: Nicolas Ferre <nicolas.ferre@microchip.com>
>> ---
>>   drivers/net/ethernet/cadence/macb_main.c | 1 +
>>   1 file changed, 1 insertion(+)
>>
>> diff --git a/drivers/net/ethernet/cadence/macb_main.c b/drivers/net/ethernet/cadence/macb_main.c
>> index 29a1199dad14..609c8e9305ba 100644
>> --- a/drivers/net/ethernet/cadence/macb_main.c
>> +++ b/drivers/net/ethernet/cadence/macb_main.c
>> @@ -4913,6 +4913,7 @@ static const struct of_device_id macb_dt_ids[] = {
>>        { .compatible = "microchip,mpfs-macb", .data = &mpfs_config },
>>        { .compatible = "microchip,sama7g5-gem", .data = &sama7g5_gem_config },
>>        { .compatible = "microchip,sama7g5-emac", .data = &sama7g5_emac_config },
>> +     { .compatible = "microchip,sam9x7-gem", .data = &sama7g5_gem_config },
> 
> These are compatible, aren't they? Why do you need new entry?

The hardware itself is different, even if the new features are not 
supported yet in the macb driver.
The macb driver will certainly evolve in order to add these features so 
we decided to match a new compatible string all the way to the driver.

Best regards,
   Nicolas


-- 
Nicolas Ferre


