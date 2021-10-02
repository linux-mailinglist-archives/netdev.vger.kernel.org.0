Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8479141FD15
	for <lists+netdev@lfdr.de>; Sat,  2 Oct 2021 18:33:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233522AbhJBQep (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 2 Oct 2021 12:34:45 -0400
Received: from wout4-smtp.messagingengine.com ([64.147.123.20]:48017 "EHLO
        wout4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233444AbhJBQeo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 2 Oct 2021 12:34:44 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.west.internal (Postfix) with ESMTP id 48B1C3200A60;
        Sat,  2 Oct 2021 12:32:58 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Sat, 02 Oct 2021 12:32:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=dvX1e0
        Npm9+NwidcnFu6i2bU1y785ZOK5Zic0CIfd20=; b=fvrrI12JxEY3xFuYaqEPeN
        t1HcekIbzt6AbYxpuWVyeQp6OCwKFl8SPU2IUxEVcUYkauJ4zwi+ftrDBmuSaCSV
        c6l2D5n/+l0KJWSAi4z6mp9DWuSkoyvB7xIU6BSzz/C47KepQsb1l1S03AAcwUPM
        BxP3cWqhGdOsAlRRHyM3qBd/EfJT/C8LTcCg/dKECT3jMdVXTzY5KcnTHx1DjydN
        8HLIWHTefWdEfO8Rtn3QXFcrF/cd1+dbqoQzliuQc6PcWNn/l8Q8Q6QJLkvXjNtz
        eANEL7AMlt3hYWCBHSaqvq2k2sPHk3TUDuq3OmTNxAL976b81WLMfp5JSvXHmpeg
        ==
X-ME-Sender: <xms:uYlYYeD_fgbeDdkLNxovY1fMPONClPXGUSfVXs8gzDP2FEOyHLx4OA>
    <xme:uYlYYYhObEg8AchLb5rwgtLMkt8R_yLwXem4q-8hJR2Ie9RT-r6r-3a4wQoCHSYtr
    TDuqYw11CvllGg>
X-ME-Received: <xmr:uYlYYRn4a3GVoJdV38A9duyQ9WzgeCAlv6HpNz-2YN6-OA8e9RE71Ln12S01T4_F0Uq64DpG2rqoByVpHCChGS6F769qWw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddrudekkedguddttdcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhepfffhvffukfhfgggtuggjsehttd
    ertddttddvnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihgu
    ohhstghhrdhorhhgqeenucggtffrrghtthgvrhhnpedtffekkeefudffveegueejffejhf
    etgfeuuefgvedtieehudeuueekhfduheelteenucevlhhushhtvghrufhiiigvpedtnecu
    rfgrrhgrmhepmhgrihhlfhhrohhmpehiughoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:uYlYYcyEzvUXdDePAp0C3bIPLYeaTio4owVWzVFJHuZpOtgtrMlUyA>
    <xmx:uYlYYTSXkcT7qZEFkzX1EYo1a2KjD2KmRTyw-Y0z1B4yuCwFvD83cQ>
    <xmx:uYlYYXa1rHwM4fXW4ENN38A7wYpAuVqPSkFrtHrY4OWwFk7xv7Q4mg>
    <xmx:uYlYYU6f7DhDt9nWavnMOQSy4okQ_Tm-8ZeV3jDiWCqHGA47YC4uPg>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sat,
 2 Oct 2021 12:32:56 -0400 (EDT)
Date:   Sat, 2 Oct 2021 19:32:53 +0300
From:   Ido Schimmel <idosch@idosch.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: Re: [PATCH net-next 03/11] ethernet: use eth_hw_addr_set()
Message-ID: <YViJtfwpSqR9wIOU@shredder>
References: <20211001213228.1735079-1-kuba@kernel.org>
 <20211001213228.1735079-4-kuba@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211001213228.1735079-4-kuba@kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 01, 2021 at 02:32:20PM -0700, Jakub Kicinski wrote:
> Convert all Ethernet drivers from memcpy(... ETH_ADDR)
> to eth_hw_addr_set():
> 
>   @@
>   expression dev, np;
>   @@
>   - memcpy(dev->dev_addr, np, ETH_ALEN)
>   + eth_hw_addr_set(dev, np)

Some use:

memcpy(dev->dev_addr, np, dev->addr_len)

Not sure if you missed it or if it's going to be in part 2. I assume the
latter, but thought I would ask.

Thanks
