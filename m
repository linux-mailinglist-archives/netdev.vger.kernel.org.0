Return-Path: <netdev+bounces-7739-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 7DB80721584
	for <lists+netdev@lfdr.de>; Sun,  4 Jun 2023 10:07:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A806E1C20AE7
	for <lists+netdev@lfdr.de>; Sun,  4 Jun 2023 08:07:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 65DDD23CF;
	Sun,  4 Jun 2023 08:07:34 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A7D215C1
	for <netdev@vger.kernel.org>; Sun,  4 Jun 2023 08:07:34 +0000 (UTC)
Received: from sender3-op-o19.zoho.com (sender3-op-o19.zoho.com [136.143.184.19])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 028AFED;
	Sun,  4 Jun 2023 01:07:32 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1685866005; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=PBkjITfkcgLIrj2ukmOM0fJ4ihuOMqEtafmR6mLgSGjFYsPWhsa/gIVDeFBxRvEV00S3RKY0KxRNzRIriDKzhx/meoRB2k62oCGQGX8q5t16jdELu89k2cjkr4V2zGtnBeYfbeEIgxXJvmI7RltKCCWhCdYiVL2BUjy8a0gFz1Q=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1685866005; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
	bh=sfXhf5HJgDnX1ZAfbfzJSTS4W+MU2gPcWf2z5/WiU2I=; 
	b=XO/GcWvk1dGtQphlY+JLIITYbd+c2jcZlNAdFTE3XvKRE6nbNvnwN8kVWpCw6DwvXHgPd0792ZuwZn8SE77mQS7qDuw7nqkV7NE6yE+kL31MKHULFA1KaQeYmNSVDk7nRF/7pOraSQKbIddZQV3Pm/40Zdg+RG5/qkZM7gJSHrE=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=arinc9.com;
	spf=pass  smtp.mailfrom=arinc.unal@arinc9.com;
	dmarc=pass header.from=<arinc.unal@arinc9.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1685866005;
	s=zmail; d=arinc9.com; i=arinc.unal@arinc9.com;
	h=Message-ID:Date:Date:MIME-Version:Subject:Subject:To:To:Cc:Cc:References:From:From:In-Reply-To:Content-Type:Content-Transfer-Encoding:Message-Id:Reply-To;
	bh=sfXhf5HJgDnX1ZAfbfzJSTS4W+MU2gPcWf2z5/WiU2I=;
	b=faOgHM7yJfCX/G92IExil29L7G5rtErAxx0mk8VSkP3ZmS8nxcLRVlhYuCYshZL+
	KMeA9mHW0+XhK//TTuG01mIzt9Vyt8ct+X8qezLytZdYPzBK6+yhUwCP+fkdTcWEg+E
	ucMh091BVH2PsUjQ8b5C0OxIBiKTZjcVNWddMxVg=
Received: from [192.168.66.198] (178-147-169-233.haap.dm.cosmote.net [178.147.169.233]) by mx.zohomail.com
	with SMTPS id 16858660033101021.621262772672; Sun, 4 Jun 2023 01:06:43 -0700 (PDT)
Message-ID: <e4aff9aa-d0c6-1f2e-7f16-35df59d51b90@arinc9.com>
Date: Sun, 4 Jun 2023 11:06:32 +0300
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH net-next 24/30] net: dsa: mt7530: rename MT7530_MFC to
 MT753X_MFC
Content-Language: en-US
To: "Russell King (Oracle)" <linux@armlinux.org.uk>,
 Vladimir Oltean <olteanv@gmail.com>
Cc: Sean Wang <sean.wang@mediatek.com>, Landen Chao
 <Landen.Chao@mediatek.com>, DENG Qingfang <dqfext@gmail.com>,
 Daniel Golle <daniel@makrotopia.org>, Andrew Lunn <andrew@lunn.ch>,
 Florian Fainelli <f.fainelli@gmail.com>,
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
 Matthias Brugger <matthias.bgg@gmail.com>,
 AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
 Richard van Schagen <richard@routerhints.com>,
 Richard van Schagen <vschagen@cs.com>,
 Frank Wunderlich <frank-w@public-files.de>,
 Bartel Eerdekens <bartel.eerdekens@constell8.be>, erkin.bozoglu@xeront.com,
 mithat.guner@xeront.com, netdev@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 linux-mediatek@lists.infradead.org
References: <20230522121532.86610-1-arinc.unal@arinc9.com>
 <20230522121532.86610-25-arinc.unal@arinc9.com>
 <20230526154258.skbkk4p34ro5uivr@skbuf>
 <ZHDVUC1AqncfF2mK@shell.armlinux.org.uk>
From: =?UTF-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>
In-Reply-To: <ZHDVUC1AqncfF2mK@shell.armlinux.org.uk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ZohoMailClient: External
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
	RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net



On 26.05.2023 18:50, Russell King (Oracle) wrote:
> On Fri, May 26, 2023 at 06:42:58PM +0300, Vladimir Oltean wrote:
>> On Mon, May 22, 2023 at 03:15:26PM +0300, arinc9.unal@gmail.com wrote:
>>>   	/* Disable flooding on all ports */
>>> -	mt7530_clear(priv, MT7530_MFC, BC_FFP_MASK | UNM_FFP_MASK |
>>> -		     UNU_FFP_MASK);
>>> +	mt7530_clear(priv, MT753X_MFC, MT753X_BC_FFP_MASK | MT753X_UNM_FFP_MASK
>>> +		     | MT753X_UNU_FFP_MASK);
>>
>> The preferred coding style is not to start new lines with operators.
>>
>>> +/* Register for CPU forward control */
>>>   #define MT7531_CFC			0x4
>>>   #define  MT7531_MIRROR_EN		BIT(19)
>>> -#define  MT7531_MIRROR_MASK		(MIRROR_MASK << 16)
>>> -#define  MT7531_MIRROR_PORT_GET(x)	(((x) >> 16) & MIRROR_MASK)
>>> -#define  MT7531_MIRROR_PORT_SET(x)	(((x) & MIRROR_MASK) << 16)
>>> +#define  MT7531_MIRROR_MASK		(0x7 << 16)
>>
>> minor nitpick: if you express this as GENMASK(18, 16), it will be a bit
>> easier to cross-check with the datasheet, since both 18 and 16 are more
>> representative than 0x7.
>>
>>> +#define  MT7531_MIRROR_PORT_GET(x)	(((x) >> 16) & 0x7)
>>
>> also here: (((x) & GENMASK(18, 16)) >> 16)
> 
> Even better are:
> #define  MT7531_MIRROR_PORT_GET(x)	FIELD_GET(MT7531_MIRROR_MASK, x)
> 
>>
>>> +#define  MT7531_MIRROR_PORT_SET(x)	(((x) & 0x7) << 16)
>>
>> and here: (((x) << 16) & GENMASK(18, 16))
> 
> #define  MT7531_MIRROR_PORT_SET(x)	FIELD_PREP(MT7531_MIRROR_MASK, x)
> 
> No need to add parens around "x" in either of these uses as we're not
> doing anything with x other than passing it into another macro.

Thanks. I suppose the GENMASK, FIELD_PREP, and FIELD_GET macros can be 
widely used on mt7530.h? Like GENMASK(2, 0) on MT7530_MIRROR_MASK and 
FIELD_PREP(MT7530_MIRROR_MASK, x) on MT7530_MIRROR_PORT(x)?

Arınç

