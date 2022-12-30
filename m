Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3F87C659A6F
	for <lists+netdev@lfdr.de>; Fri, 30 Dec 2022 17:13:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235145AbiL3QNW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Dec 2022 11:13:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235064AbiL3QNV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Dec 2022 11:13:21 -0500
Received: from nbd.name (nbd.name [46.4.11.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 066431BEA6;
        Fri, 30 Dec 2022 08:13:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
        s=20160729; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
        References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=oLpu04+RbbeBI/Nbl4YEI0+hXME43XlTduDWQwUs7U0=; b=W0V4c2xmmo9qMY2lMo0UPZC2L+
        OSWUKXOVgSit6IqjGEFoC87+rhuqEG5V0O87EkI2hG1sE96HiEe5/M/1p5fXj5MFKBEBXJyfJlR9p
        bceHia7lyYICoGtrdFxhLTFGqsD0KyWAEyRaxajtmOX1BpOgbO/++ZryOAPpVBvbLbuM=;
Received: from p200300daa720fc02b9d78281b940d549.dip0.t-ipconnect.de ([2003:da:a720:fc02:b9d7:8281:b940:d549] helo=nf.local)
        by ds12 with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.94.2)
        (envelope-from <nbd@nbd.name>)
        id 1pBI0E-00CklB-8W; Fri, 30 Dec 2022 17:13:02 +0100
Message-ID: <904dfc35-ecae-97dc-e9d9-a7df83ff89d4@nbd.name>
Date:   Fri, 30 Dec 2022 17:13:01 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.6.1
Subject: Re: Aw: Re: Re: [PATCH net v3 4/5] net: ethernet: mtk_eth_soc: drop
 generic vlan rx offload, only use DSA untagging
Content-Language: en-US
To:     Frank Wunderlich <frank-w@public-files.de>
Cc:     netdev@vger.kernel.org, John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org
References: <20221230073145.53386-1-nbd@nbd.name>
 <20221230073145.53386-4-nbd@nbd.name>
 <trinity-a07d48f4-11cf-4a24-a797-03ad4b1150d9-1672400818371@3c-app-gmx-bap18>
 <82821d48-9259-9508-cc80-fc07f4d3ba14@nbd.name>
 <trinity-ace28b50-2929-4af3-9dd2-765f848c4d99-1672408565903@3c-app-gmx-bap18>
 <fc09b981-282e-26cd-661e-86fdc72bedf9@nbd.name>
 <trinity-01eda9f9-b989-4554-ba35-a7f7a18da786-1672414711074@3c-app-gmx-bap18>
From:   Felix Fietkau <nbd@nbd.name>
In-Reply-To: <trinity-01eda9f9-b989-4554-ba35-a7f7a18da786-1672414711074@3c-app-gmx-bap18>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 30.12.22 16:38, Frank Wunderlich wrote:
> seems only tx is affected on r3, as i see packets on the vlan from my laptop
> 
> tcpdump on R3 (e4:b9:7a:f7:c4:8b is mac from laptop):
> 
> 13:47:05.265508 e4:b9:7a:f7:c4:8b > ff:ff:ff:ff:ff:ff, ethertype 802.1Q (0x8100), length 577: vlan 500, p 0, ethertype IPv4 (0x0800), 192.168.50.2.59389 > 192.168.50.255.21027: UDP, length 531
> 13:47:05.265548 e4:b9:7a:f7:c4:8b > ff:ff:ff:ff:ff:ff, ethertype 802.1Q (0x8100), length 577: vlan 600, p 0, ethertype IPv4 (0x0800), 192.168.60.2.59389 > 192.168.60.255.21027: UDP, length 531
> 
> regards Frank
I don't have a setup to test 6.2 on my MT7986 board right now, but I did 
test latest OpenWrt with my changes and couldn't reproduce the issue there.
I checked the diff between my tree and upstream and didn't find any 
relevant differences in mtk_eth_soc.c
Not sure what's going on or how to narrow it down further.

- Felix
