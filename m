Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 212272F1F21
	for <lists+netdev@lfdr.de>; Mon, 11 Jan 2021 20:23:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391041AbhAKTWU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jan 2021 14:22:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390347AbhAKTWN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Jan 2021 14:22:13 -0500
Received: from nbd.name (nbd.name [IPv6:2a01:4f8:221:3d45::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CB3DC061794
        for <netdev@vger.kernel.org>; Mon, 11 Jan 2021 11:21:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
         s=20160729; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:
        MIME-Version:Date:Message-ID:Subject:From:References:Cc:To:Sender:Reply-To:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=HiadGpznOS95dAFv9yuG6NP6bu4TXenxldCVhYwVOvA=; b=SdnQ57DbUqnJnD3KOFsPMSb+1Y
        GkkttJS/Lyq5AFjruMTEfLGKP0L8Hjp8IZ5UIr1b+mBPIOLwQ9y6GbGeL/BBGebF2REN63NqxsEaZ
        WH5Kleo5pWetAjo9bV5tn4TeIj/FURlfpMv8pFSQL4BkzVUZ2+cJSk1+Zs7rAoSWeSB0=;
Received: from p54ae91f2.dip0.t-ipconnect.de ([84.174.145.242] helo=nf.local)
        by ds12 with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.89)
        (envelope-from <nbd@nbd.name>)
        id 1kz2km-000330-GZ; Mon, 11 Jan 2021 20:21:24 +0100
To:     Jakub Kicinski <kuba@kernel.org>, Joe Perches <joe@perches.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, corbet@lwn.net,
        John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Mark Lee <Mark-MC.Lee@mediatek.com>
References: <20210111052759.2144758-1-kuba@kernel.org>
 <20210111052759.2144758-7-kuba@kernel.org>
 <c5d10d66321ee8b58263d6d9fce6c34e99d839e8.camel@perches.com>
 <20210111094137.0ead3481@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Felix Fietkau <nbd@nbd.name>
Subject: Re: [PATCH net 6/9] MAINTAINERS: mtk-eth: remove Felix
Message-ID: <21afd8f4-fce4-65af-4b14-7a461e8a504f@nbd.name>
Date:   Mon, 11 Jan 2021 20:21:23 +0100
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:78.0)
 Gecko/20100101 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20210111094137.0ead3481@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2021-01-11 18:41, Jakub Kicinski wrote:
> On Sun, 10 Jan 2021 21:45:46 -0800 Joe Perches wrote:
>> On Sun, 2021-01-10 at 21:27 -0800, Jakub Kicinski wrote:
>> > Drop Felix from Mediatek Ethernet driver maintainers.
>> > We haven't seen any tags since the initial submission.  
>> []
>> > diff --git a/MAINTAINERS b/MAINTAINERS  
>> []
>> > @@ -11165,7 +11165,6 @@ F:	Documentation/devicetree/bindings/dma/mtk-*
>> >  F:	drivers/dma/mediatek/
>> >  
>> > 
>> >  MEDIATEK ETHERNET DRIVER
>> > -M:	Felix Fietkau <nbd@nbd.name>
>> >  M:	John Crispin <john@phrozen.org>
>> >  M:	Sean Wang <sean.wang@mediatek.com>
>> >  M:	Mark Lee <Mark-MC.Lee@mediatek.com>  
>> 
>> I think your script is broken as there are multiple subdirectories
>> for this entry and 
> 
> Quite the opposite, the script intentionally only counts contributions
> only to the code under the MAINTAINERS entry. People lose interest and
> move on to working on other parts of the kernel (or maybe were never
> that interested in maintaining something in the first place?). 
> 
> We want to list folks who are likely to give us reviews.
> 
>> Felix is active.
> 
> Which I tried to state in the commit message as well :)
Sorry for the delayed response. I'm going to submit a bunch of work on
this driver in the near future.
The patches have already been written, just need a bit more time for
testing/review.

- Felix
