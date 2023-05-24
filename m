Return-Path: <netdev+bounces-4885-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 95F3770EFB0
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 09:42:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id F1B4B281204
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 07:42:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3D9CB8479;
	Wed, 24 May 2023 07:42:26 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EAD88467
	for <netdev@vger.kernel.org>; Wed, 24 May 2023 07:42:26 +0000 (UTC)
Received: from sender4-op-o10.zoho.com (sender4-op-o10.zoho.com [136.143.188.10])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2FAC1A4;
	Wed, 24 May 2023 00:42:18 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1684914092; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=aKxvFDvhB4Kb4q7WHYCzmGiJUnx499T9hNTbQT49YsO5DtSfhxxDXFrIcz1JD4vRCr8TKos78852opVSGsGND3eIg42TZjO8tn8J1FpM7O03UK4dQ+3f1UF1t6mQ9OoVqmhPShUSAsoXQALsUv2y1w9VKZKb7K0Kes3Rp6zxecc=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1684914092; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
	bh=MR0O682RfrFBNse1p8Ql+KZ1F8A1Rs1HR/Xijg/qsHo=; 
	b=KPARimPIC8bQ0XGSJKJodyslgvqqwIbSgjURvmHDqIvxxz/7EGT7v3FUZhGtJqhkbMi20R7aCqwLSujGVW0r9QRHuNm/mDd24zGH7fgQZNUJIcxJVVU/C2rDH9xjC5CyrcgxfB8htLQO6wKw1wFZm631v1LuJZiuVttPiiV5IdE=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=arinc9.com;
	spf=pass  smtp.mailfrom=arinc.unal@arinc9.com;
	dmarc=pass header.from=<arinc.unal@arinc9.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1684914092;
	s=zmail; d=arinc9.com; i=arinc.unal@arinc9.com;
	h=Message-ID:Date:Date:MIME-Version:Subject:Subject:To:To:Cc:Cc:References:From:From:In-Reply-To:Content-Type:Content-Transfer-Encoding:Message-Id:Reply-To;
	bh=MR0O682RfrFBNse1p8Ql+KZ1F8A1Rs1HR/Xijg/qsHo=;
	b=SdPuQP3V8HGpH/WOY38f44060GfQW1hFNzUyzqQnbk3V8q3oEWQS1aBWVS3jISpG
	ztEzUpa3KEcr7aUgp1t7PDKQHvRELaJQFwgzzhHithXUhHqIEP0+ulaf1ZmwKcNAx6h
	dhKdTXctBbWqqYz7cXsYRfBwrKo5kNysEMZ/RDUA=
Received: from [10.10.10.217] (149.91.1.15 [149.91.1.15]) by mx.zohomail.com
	with SMTPS id 1684914089227639.5522627095868; Wed, 24 May 2023 00:41:29 -0700 (PDT)
Message-ID: <a01fb61e-790d-9fae-6537-5556a11b56d8@arinc9.com>
Date: Wed, 24 May 2023 10:41:06 +0300
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH net-next 02/30] net: dsa: mt7530: use p5_interface_select
 as data type for p5_intf_sel
To: Andrew Lunn <andrew@lunn.ch>
Cc: Sean Wang <sean.wang@mediatek.com>, Landen Chao
 <Landen.Chao@mediatek.com>, DENG Qingfang <dqfext@gmail.com>,
 Daniel Golle <daniel@makrotopia.org>, Florian Fainelli
 <f.fainelli@gmail.com>, Vladimir Oltean <olteanv@gmail.com>,
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
 Matthias Brugger <matthias.bgg@gmail.com>,
 AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
 Russell King <linux@armlinux.org.uk>,
 Richard van Schagen <richard@routerhints.com>,
 Richard van Schagen <vschagen@cs.com>,
 Frank Wunderlich <frank-w@public-files.de>,
 Bartel Eerdekens <bartel.eerdekens@constell8.be>, erkin.bozoglu@xeront.com,
 mithat.guner@xeront.com, netdev@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 linux-mediatek@lists.infradead.org
References: <20230522121532.86610-1-arinc.unal@arinc9.com>
 <20230522121532.86610-3-arinc.unal@arinc9.com>
 <8f73b826-5a1e-462d-91e4-5c518751c1ee@lunn.ch>
Content-Language: en-US
From: =?UTF-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>
In-Reply-To: <8f73b826-5a1e-462d-91e4-5c518751c1ee@lunn.ch>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ZohoMailClient: External
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 24.05.2023 02:31, Andrew Lunn wrote:
> On Mon, May 22, 2023 at 03:15:04PM +0300, arinc9.unal@gmail.com wrote:
>> From: Arınç ÜNAL <arinc.unal@arinc9.com>
>>
>> Use the p5_interface_select enumeration as the data type for the
>> p5_intf_sel field. This ensures p5_intf_sel can only take the values
>> defined in the p5_interface_select enumeration.
>>
>> Signed-off-by: Arınç ÜNAL <arinc.unal@arinc9.com>
>> Acked-by: Daniel Golle <daniel@makrotopia.org>
>> ---
>>   drivers/net/dsa/mt7530.h | 4 ++--
>>   1 file changed, 2 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/net/dsa/mt7530.h b/drivers/net/dsa/mt7530.h
>> index 845f5dd16d83..415d8ea07472 100644
>> --- a/drivers/net/dsa/mt7530.h
>> +++ b/drivers/net/dsa/mt7530.h
>> @@ -675,7 +675,7 @@ struct mt7530_port {
>>   
>>   /* Port 5 interface select definitions */
>>   enum p5_interface_select {
>> -	P5_DISABLED = 0,
>> +	P5_DISABLED,
> 
> Is this change important in this context? Maybe add something to the
> commit message about it?

Not important, the first element in the enum is given value 0 so this is
merely a style change. I will mention it on the patch log, thanks.

Arınç

