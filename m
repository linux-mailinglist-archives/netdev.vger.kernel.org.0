Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2EEDA12ABD2
	for <lists+netdev@lfdr.de>; Thu, 26 Dec 2019 12:14:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726626AbfLZLOC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Dec 2019 06:14:02 -0500
Received: from wout1-smtp.messagingengine.com ([64.147.123.24]:52155 "EHLO
        wout1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726109AbfLZLOB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Dec 2019 06:14:01 -0500
Received: from compute2.internal (compute2.nyi.internal [10.202.2.42])
        by mailout.west.internal (Postfix) with ESMTP id 7B32A7A9;
        Thu, 26 Dec 2019 06:14:00 -0500 (EST)
Received: from imap1 ([10.202.2.51])
  by compute2.internal (MEProxy); Thu, 26 Dec 2019 06:14:00 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=octaforge.org;
         h=mime-version:message-id:in-reply-to:references:date:from:to
        :cc:subject:content-type; s=fm2; bh=JXta/WqdhE4YY2I64sh/VVqEpXKm
        hm0Lw30srU4vDGY=; b=cexShvJUjvFwcGdxsSXh8AXoF/W8dUGxFBgYL7E6yt4v
        /UdZo9DC2dgzLsDbCSpvV4BwOy9oUVW3eUlmJMMkhzVBA18Qeclw5f5JGlbJ9Tuj
        lS0fRxFeuQREAdpestQrT+H2cJFGofW72Lr+iQYpZj96K+afYIuOgkzO51/eV4ve
        gAc0iFkxAVo/lIoeVvkHv7HhNSp0mpeb/Ee54Ii53IfvmcwjCjeVFUfTXmx2i11X
        CpIyNO/qtMBxbCPdBI5TFE2AyEAzt/gK9KwdL9QPbun1Xt+SZqPFLME79BXB8R78
        eA0NaHpu4dxmvR/mGRS/1tIqpQgW6go8fiyAIpus9g==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=JXta/W
        qdhE4YY2I64sh/VVqEpXKmhm0Lw30srU4vDGY=; b=UK+ibjhycYCi5Lk4PWm+u5
        4mKlo8Zyulbqaw3YGqeE14x5JIKaDKnTJW4+Y79yMskjq7zFVPuIPkb0qY84yjqK
        72g1Ve5uKZT5P+A6elXdToG2Q5bTIntGIJ8ovsv2LurIHwqclo2hyrBBAJUs4FGG
        5F0TihkgYrx3R3irMpDDs7kAnlc2T5MDRqVnRmTrIe1py7V4Nr/xnATDGsCWHevf
        2mySJ0ETsFH5eeO72LpLI/uAMP0t7wZ95tFvrLcVZg/VjFwP0/WIbqFWYpDrEzw6
        l/W5Wq1whvF8efV5RnS+40noycpalmoTkOugc60E2jNGRfJzucO+MBvFTv8SlyAA
        ==
X-ME-Sender: <xms:95UEXqM8zGqPOFXYpIMTMBF2hD1WFLHwRZrXgv5aZcDwyEMu9p6kqg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrvddviedgvdegucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepofgfggfkjghffffhvffutgesthdtredtreertdenucfhrhhomhepfdffrghn
    ihgvlhcumfholhgvshgrfdcuoegurghnihgvlhesohgtthgrfhhorhhgvgdrohhrgheqne
    curfgrrhgrmhepmhgrihhlfhhrohhmpegurghnihgvlhesohgtthgrfhhorhhgvgdrohhr
    ghenucevlhhushhtvghrufhiiigvpedt
X-ME-Proxy: <xmx:95UEXpYKIVPvoGXx8cS8vnFmpZVWTpJMvbtyuIKlbRgiS6-GUrQXwg>
    <xmx:95UEXmuJmr88Q22yakGgo29iOw8aIksTXl5m6_uDPQPYF1g8G3H0HA>
    <xmx:95UEXor7Hvtm3mGf7QpgKVr2EAX6DvAM1a7kSNzCrHhDlqqKQ7KdSw>
    <xmx:-JUEXp3-wAXuoL8KJ4PWci7_HzbD643sOPnjWgtnDg_h4n8H6kOruA>
Received: by mailuser.nyi.internal (Postfix, from userid 501)
        id A4D93C200A4; Thu, 26 Dec 2019 06:13:59 -0500 (EST)
X-Mailer: MessagingEngine.com Webmail Interface
User-Agent: Cyrus-JMAP/3.1.7-694-gd5bab98-fmstable-20191218v1
Mime-Version: 1.0
Message-Id: <66db73b0-c470-4708-a017-c662f4ca0d7c@www.fastmail.com>
In-Reply-To: <20191225.194929.1465672299217213413.davem@davemloft.net>
References: <20191222060227.7089-1-AWilcox@Wilcox-Tech.com>
 <20191225.163411.1590483851343305623.davem@davemloft.net>
 <20191226010515.GD30412@brightrain.aerifal.cx>
 <20191225.194929.1465672299217213413.davem@davemloft.net>
Date:   Thu, 26 Dec 2019 12:13:37 +0100
From:   "Daniel Kolesa" <daniel@octaforge.org>
To:     "David Miller" <davem@davemloft.net>, musl@lists.openwall.com,
        dalias@libc.org
Cc:     AWilcox@Wilcox-Tech.com, netdev@vger.kernel.org,
        linux-api@vger.kernel.org
Subject: Re: [musl] Re: [PATCH] uapi: Prevent redefinition of struct iphdr
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 26, 2019, at 04:49, David Miller wrote:
> From: Rich Felker <dalias@libc.org>
> Date: Wed, 25 Dec 2019 20:05:15 -0500
> 
> > On Wed, Dec 25, 2019 at 04:34:11PM -0800, David Miller wrote:
> >> I find it really strange that this, therefore, only happens for musl
> >> and we haven't had thousands of reports of this conflict with glibc
> >> over the years.
> > 
> > It's possible that there's software that's including just one of the
> > headers conditional on __GLIBC__, and including both otherwise, or
> > something like that. Arguably this should be considered unsupported
> > usage; there are plenty of headers where that doesn't work and
> > shouldn't be expected to.
> 
> I don't buy that, this is waaaaaay too common a header to use.

In case of net-tools, only <linux/ip.h> is included, and never <netinet/ip.h> directly. Chances are in musl the indirect include tree happens to be different and conflicting, while in glibc it is not.

> 
> Please investigate.
>

Daniel
