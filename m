Return-Path: <netdev+bounces-5242-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id C801D7105D4
	for <lists+netdev@lfdr.de>; Thu, 25 May 2023 08:52:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 70A8D1C20E90
	for <lists+netdev@lfdr.de>; Thu, 25 May 2023 06:52:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CDE6A8F53;
	Thu, 25 May 2023 06:52:01 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2AE61FB8
	for <netdev@vger.kernel.org>; Thu, 25 May 2023 06:52:01 +0000 (UTC)
Received: from sender4-op-o10.zoho.com (sender4-op-o10.zoho.com [136.143.188.10])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 079FCC0;
	Wed, 24 May 2023 23:51:59 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1684997485; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=afXrsYFLi41jwH+s0sSNtF7dOOG2lVdLUQ3kHMkoesgovweqDtIoPk/C0X29+I4yJTos543ocNwD32phJqChF1rv7yyDdWV2jCe6bIGMj+X8I1V5htoWpeGvBcDPlvpMQ+QR/FLr/kV4wF9iczHez+2neAokZlDMhfSKH1dUZms=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1684997485; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
	bh=MwhSXtCM+amK18ZJFZTkmGQCxpMOw/Tgzf9+hmAj/30=; 
	b=QxA7JTqOzrVF4E/qxiRKNJ+oobC01mwj8p9jLJcdVC5fX8AOfbZ7EJpok3+NTUCfR4Hd00RGeaMANRDdp82EmdaOZV14Y2w7krjkl45MMoAOA7SIOQPGlkGNnc8QMeiTzeyXYF3+xSXJOZiA1u5h4NlskuadK2Qh15Lv2FxG3Go=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=arinc9.com;
	spf=pass  smtp.mailfrom=arinc.unal@arinc9.com;
	dmarc=pass header.from=<arinc.unal@arinc9.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1684997485;
	s=zmail; d=arinc9.com; i=arinc.unal@arinc9.com;
	h=Message-ID:Date:Date:MIME-Version:Subject:Subject:To:To:Cc:Cc:References:From:From:In-Reply-To:Content-Type:Content-Transfer-Encoding:Message-Id:Reply-To;
	bh=MwhSXtCM+amK18ZJFZTkmGQCxpMOw/Tgzf9+hmAj/30=;
	b=SGz24cTwAJTIyieCXy3a7XPVAxp7Cywv4ErQW6cqg2mcv3UulKBRJTBU5ke9V//I
	wVJxXTSiUODqhBGMT8IdnzyZJAbHFW7LcyvqqQoU/vSjIIMB57GUeZDTOb17jN4wAdg
	zLamxWzs07PapbPkEIw6eURALUYXCyJOelzNR3h8=
Received: from [10.10.10.217] (149.91.1.15 [149.91.1.15]) by mx.zohomail.com
	with SMTPS id 1684997484418555.9448204414057; Wed, 24 May 2023 23:51:24 -0700 (PDT)
Message-ID: <0777fa04-7dd7-7f67-2a8b-f855f5aeba82@arinc9.com>
Date: Thu, 25 May 2023 09:51:12 +0300
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH net-next 09/30] net: dsa: mt7530: empty default case on
 mt7530_setup_port5()
Content-Language: en-US
To: Vladimir Oltean <olteanv@gmail.com>
Cc: Sean Wang <sean.wang@mediatek.com>, Landen Chao
 <Landen.Chao@mediatek.com>, DENG Qingfang <dqfext@gmail.com>,
 Daniel Golle <daniel@makrotopia.org>, Andrew Lunn <andrew@lunn.ch>,
 Florian Fainelli <f.fainelli@gmail.com>,
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
 <20230522121532.86610-10-arinc.unal@arinc9.com>
 <20230524180529.y7vl5mb4rn4vwdhh@skbuf>
From: =?UTF-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>
In-Reply-To: <20230524180529.y7vl5mb4rn4vwdhh@skbuf>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ZohoMailClient: External
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 24.05.2023 21:05, Vladimir Oltean wrote:
> On Mon, May 22, 2023 at 03:15:11PM +0300, arinc9.unal@gmail.com wrote:
>>   	default:
>> -		dev_err(ds->dev, "Unsupported p5_intf_sel %d\n",
>> -			priv->p5_intf_sel);
>> -		goto unlock_exit;
> 
> You could have probably left a comment though (that doesn't cost in
> terms of compiled code):
> 
> 		/* We never call mt7530_setup_port5() with P5_DISABLED */

I remove P5_DISABLED with later patches so I don't see a reason to add 
this then remove it on the same patch series.

Arınç

