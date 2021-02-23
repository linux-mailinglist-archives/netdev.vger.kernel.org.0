Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D7270323170
	for <lists+netdev@lfdr.de>; Tue, 23 Feb 2021 20:30:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234029AbhBWTaW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Feb 2021 14:30:22 -0500
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:36533 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232600AbhBWTaV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Feb 2021 14:30:21 -0500
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id AE8665C008F;
        Tue, 23 Feb 2021 14:29:13 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Tue, 23 Feb 2021 14:29:13 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=0J2CVX
        zpL4ThVxW9XxVCX/Gpf9Mc09uxwh9+LKeYk4I=; b=iwmqhFhgeVhk2dwUOsrG3c
        LHzjz5Zj6vAMEaqkgQg9zPR5G15BLbv0E9BOJ5iagEr8oGyQssJGizYihNbsXQh+
        WUeSDWpxYEH5As48tb6sPc6iL+klTDUMLMBUvoWHJasqtn6pg77pGEVq7jkRrST5
        F6a/OJaOmMJpjZt9PvZcdfFxhy3GE9rM5SH+Ow4zMw2Aam3EuWFdPUdhfpsP22K1
        5fi4m6pJj/+aZNXmIzVSqcNztIXz3S46d7k14efLKyMjcgjsmnPJbMGdvpoqSQhc
        BANfdqzGOO/++tFKUFEp5PewqSQyOWZJVOeUYojFOm+1ZqNloDjHRGAQ3qhvXnhA
        ==
X-ME-Sender: <xms:iFc1YLOM3d0KIUtD6apXRx-yJANMv2DRfrImkxmyJHbfmvmRPve-kQ>
    <xme:iFc1YF47N9sorKGxYRLhnixKd4_xfW8hfzJVoMf0AtkJR5mLWcIhh54-eP9KA6A5x
    AOQRLkMTnPqLtE>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrkeehgdduvdegucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefkughoucfu
    tghhihhmmhgvlhcuoehiughoshgthhesihguohhstghhrdhorhhgqeenucggtffrrghtth
    gvrhhnpedtffekkeefudffveegueejffejhfetgfeuuefgvedtieehudeuueekhfduheel
    teenucfkphepkeegrddvvdelrdduheefrdeggeenucevlhhushhtvghrufhiiigvpedtne
    curfgrrhgrmhepmhgrihhlfhhrohhmpehiughoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:iVc1YHKwp9UpqFwsuF8S8KI7gmN5c7awzgyuQ4MTS1wSBgKaJrY8aA>
    <xmx:iVc1YHd5r-cW0U7KgQ8WS5cDMnaWo_1Uoboi4Xb0W83fp7Y8J-w6wg>
    <xmx:iVc1YCeriodCJhjuJFVGc82pPZJQyJijIVX-998Z3szJdwNyHJ6D_g>
    <xmx:iVc1YAZDTezJmVhwFxXwyX-6Dkr4TpauYngO-qk8qh-nHt14LV4VTQ>
Received: from localhost (igld-84-229-153-44.inter.net.il [84.229.153.44])
        by mail.messagingengine.com (Postfix) with ESMTPA id 823A424005A;
        Tue, 23 Feb 2021 14:29:12 -0500 (EST)
Date:   Tue, 23 Feb 2021 21:29:09 +0200
From:   Ido Schimmel <idosch@idosch.org>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Nikolay Aleksandrov <nikolay@nvidia.com>,
        Roopa Prabhu <roopa@nvidia.com>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>, netdev@vger.kernel.org
Subject: Re: Timing of host-joined bridge multicast groups with switchdev
Message-ID: <YDVXhZdy510mFtG/@shredder.lan>
References: <20210223173753.vrlxhnj5rtvd6i6g@skbuf>
 <YDVBxrkYOtlmO1bn@shredder.lan>
 <20210223180236.e2ggiuxhr5aaayx5@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210223180236.e2ggiuxhr5aaayx5@skbuf>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 23, 2021 at 08:02:36PM +0200, Vladimir Oltean wrote:
> On Tue, Feb 23, 2021 at 07:56:22PM +0200, Ido Schimmel wrote:
> > For route offload you get a dump of all the existing routes when you
> > register your notifier. It's a bit different with bridge because you
> > don't care about existing bridges when you just initialize your driver.
> >
> > We had a similar issue with VXLAN because its FDB can be populated and
> > only then attached to a bridge that you offload. Check
> > vxlan_fdb_replay(). Probably need to introduce something similar for
> > FDB/MDB entries.
> 
> So you would be in favor of a driver-voluntary 'pull' type of approach
> at bridge join, instead of the bridge 'pushing' the addresses?
> 
> That's all fine, except when we'll have more than 3 switchdev drivers,
> how do we expect to manage all this complexity duplicated in many places
> in the kernel, instead of having it in a central place? Are there corner
> cases I'm missing which make the 'push' approach impractical?

Not sure. It needs to be scheduled when the driver is ready to handle
it. In br_add_if() after netdev_master_upper_dev_link() is probably a
good place.

It also needs to be done once and not every time another port joins the
bridge. This can be done using the port's parent ID, similar to what we
are already doing with the offload forward mark in
nbp_switchdev_mark_set().

But I'm not sure how we replay it only for a single notifier block. I'm
not familiar with setups where you have more than one listener let alone
more than one that is interested in notifications from a specific
bridge, so maybe it is OK to just replay it for all the listeners. But I
would prefer to avoid it if we can.
