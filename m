Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 89D45F074
	for <lists+netdev@lfdr.de>; Tue, 30 Apr 2019 08:24:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726343AbfD3GYS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Apr 2019 02:24:18 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:36445 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725790AbfD3GYR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Apr 2019 02:24:17 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 98174222BA;
        Tue, 30 Apr 2019 02:24:16 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Tue, 30 Apr 2019 02:24:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=R4PNIa
        woZroIatMAqIDL5AOAk2m7CUyJd9rOpQuko0I=; b=ePp8cX+XxTlKOJoGq/CMGr
        mr99WPLKjw4L4nCje+fy1b71foFdU37LUv8t1no2R0J3J1SNPipggGVD5Lx9ym7D
        ddRMFQLzE/lwUxVgKRS/NZRftjNqww5MSq8oojn7DyUneDKH/t6yiXVs5+rhDBfa
        PjNoqVEBrdehaG6NauUh8r04BjAxDk7HwzZFvcIczgzWV5UtA545HUexFE0TmQx7
        jdYXYhfxNQdhFjCEYkaij0YcN9KPIeGiKkb5bNxJtGwV8wEJTY+flwMHgvPrLTrw
        nYZnFmDYBHxDuK5gYzikhe4Kf0CdrM6P116b6iQ2M1M7zm0EwA1UTYbi0RwU/03g
        ==
X-ME-Sender: <xms:EOrHXCnXBdon12UOsWggwOIYMnPbp3knQe0TypczSB1qRv10LG5YRw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduuddrieefgddutdelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjfgesthdtredttdervdenucfhrhhomhepkfguohcu
    ufgthhhimhhmvghluceoihguohhstghhsehiughoshgthhdrohhrgheqnecukfhppedule
    efrdegjedrudeihedrvdehudenucfrrghrrghmpehmrghilhhfrhhomhepihguohhstghh
    sehiughoshgthhdrohhrghenucevlhhushhtvghrufhiiigvpedt
X-ME-Proxy: <xmx:EOrHXPxKRAr77tk14RmY5IxOpiDsH8FHm-hv8126srOfv0Q79K7yzA>
    <xmx:EOrHXOQNY5JLU51Y6vMDrateIF8by8HmAXaQd60QjBM3ee1GrGU81Q>
    <xmx:EOrHXFb8bZRtFsiJQODbmrbs7RdXfZdncAa_XXKYU_6tS4h1D6nI5w>
    <xmx:EOrHXN-1X_3VH9t40hdspJsZHG-7fFobYQ6c0KS91OktTeiq1ZgTvg>
Received: from localhost (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id 8FD78103C9;
        Tue, 30 Apr 2019 02:24:15 -0400 (EDT)
Date:   Tue, 30 Apr 2019 09:24:13 +0300
From:   Ido Schimmel <idosch@idosch.org>
To:     David Ahern <dsahern@gmail.com>
Cc:     netdev@vger.kernel.org, jiri@mellanox.com, alexanderk@mellanox.com,
        mlxsw@mellanox.com, Ido Schimmel <idosch@mellanox.com>
Subject: Re: [PATCH iproute2-next] devlink: Increase column size for larger
 shared buffers
Message-ID: <20190430062413.GA18155@splinter>
References: <20190423063630.5599-1-idosch@idosch.org>
 <dc650651-a9e7-6ee7-f055-636701bfc745@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <dc650651-a9e7-6ee7-f055-636701bfc745@gmail.com>
User-Agent: Mutt/1.11.3 (2019-02-01)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 23, 2019 at 08:27:36PM -0600, David Ahern wrote:
> 2 more columns fixes the current problem, what assurances are there that
> the occupancy levels and max won't reach 100 million in the next few years?

Yes, I thought about that as well, but while the size of the shared
buffers is getting bigger and bigger (with the number of ports), I'm not
familiar with sizes at the levels you're referring to.

Anyway, point taken, I'll make this more future-proof.

Thanks!
