Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0956399D39
	for <lists+netdev@lfdr.de>; Thu, 22 Aug 2019 19:41:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405079AbfHVRkq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Aug 2019 13:40:46 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:48297 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732134AbfHVRkp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Aug 2019 13:40:45 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 41EAF2203C;
        Thu, 22 Aug 2019 13:40:44 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Thu, 22 Aug 2019 13:40:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=8pZAXt
        RMx+VEVnKNoMyIg9vofEv03RCUzdqHEbFK3i0=; b=L+91U0S2PhF9g2vi4rzc2P
        PBexqJj7AJXB1KXWWokVHUTqufsRT2AD0HhEgN9iW2SrGLe5Lj01pIJKzvvuB/Gk
        xQIn3uW5Yh4OcK6qWlUrxP7I/7iz9xRL6WPpDrFeD5XB9pIE8I0LQ4N74zULhe1P
        Zg2p5y66v9p2c/NzyIYmfcOxylhdbQbyRjkXUmPe3aeVC42zN1Nvb/h/HE2kQuvH
        /gmLNfW60k9Q78aEGUItMPezmyTC6CIVLJr0Cdu5K7b+xkFenGsehH4ZMS45z+xy
        Fm6IhwHhkPXt2oG7SU2P2HDwZiqrrJCOCZu2sRdhUiqpvx2n+n+kjhx3Vg1a5BEQ
        ==
X-ME-Sender: <xms:mNNeXeN0UdKgY1F-hENgR-z4lL9n0VGomxrWJz4uzLvSeO7uZYNRWQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddrudegiedgjedvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjfgesthdtredttdervdenucfhrhhomhepkfguohcu
    ufgthhhimhhmvghluceoihguohhstghhsehiughoshgthhdrohhrgheqnecukfhppedule
    efrdegjedrudeihedrvdehudenucfrrghrrghmpehmrghilhhfrhhomhepihguohhstghh
    sehiughoshgthhdrohhrghenucevlhhushhtvghrufhiiigvpedt
X-ME-Proxy: <xmx:mNNeXV98ba5k99kqioo2w-XUShKxDAWrHyAFgGA-Eql2RGeAhIpqDA>
    <xmx:mNNeXe9hzGJVmDYuTRtpdd7V7qA1V22xMiAlj-u61j9XcDSGGbx2ig>
    <xmx:mNNeXVq8ol-MJ7TBtkakg-oaxRMBG8jalBhWY7NW_LSrEXSW1mYaDA>
    <xmx:nNNeXYAihIpqzhbMXatYfHrqZwcjWkx8G4qvFNds9LApIjAJv1Sk_w>
Received: from localhost (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id B76EA80059;
        Thu, 22 Aug 2019 13:40:39 -0400 (EDT)
Date:   Thu, 22 Aug 2019 20:40:37 +0300
From:   Ido Schimmel <idosch@idosch.org>
To:     Andrew Lunn <andrew@lunn.ch>, arnd@arndb.de
Cc:     Aya Levin <ayal@mellanox.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jiri Pirko <jiri@mellanox.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [net] devlink: Add method for time-stamp on reporter's dump
Message-ID: <20190822174037.GA18030@splinter>
References: <1566461871-21992-1-git-send-email-ayal@mellanox.com>
 <20190822140635.GH13020@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190822140635.GH13020@lunn.ch>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 22, 2019 at 04:06:35PM +0200, Andrew Lunn wrote:
> On Thu, Aug 22, 2019 at 11:17:51AM +0300, Aya Levin wrote:
> > When setting the dump's time-stamp, use ktime_get_real in addition to
> > jiffies. This simplifies the user space implementation and bypasses
> > some inconsistent behavior with translating jiffies to current time.
> 
> Hi Aya
> 
> Is this year 2038 safe? I don't know enough about this to answer the
> question myself.

Hi Andrew,

Good point. 'struct timespec' is not considered year 2038 safe and
unfortunately I recently made the mistake of using it to communicate
timestamps to user space over netlink. :/ The code is still in net-next,
so I will fix it while I can.

Arnd, would it be acceptable to use 'struct __kernel_timespec' instead?

Thanks
