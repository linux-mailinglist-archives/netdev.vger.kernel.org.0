Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B83E23096AA
	for <lists+netdev@lfdr.de>; Sat, 30 Jan 2021 17:22:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232018AbhA3QWT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 30 Jan 2021 11:22:19 -0500
Received: from wout3-smtp.messagingengine.com ([64.147.123.19]:55279 "EHLO
        wout3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232096AbhA3PhR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 30 Jan 2021 10:37:17 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.west.internal (Postfix) with ESMTP id 88A1FFC9;
        Sat, 30 Jan 2021 10:11:47 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Sat, 30 Jan 2021 10:11:48 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=TTz9de
        7Aui/b0TqRdz54EZIA8mv8r3BU+/gAevThSpw=; b=Kmt99kIogQ998uedznl8vs
        vyuLMvazFs1yIDO96RMX9Wn85y6sCIKLo75lt+ThupCc6/VmjyHyON6uVQy+OtpU
        Z5NwjEHC79qs6HeeTyY6DiM6aGLE2kbV6eHISYgM5OnnzwFNuYOUMwQ/p2C+8eo1
        zpMuKBwSd60BY6Pgtw7uWnlR8DZfs1hoLoHTcPHooaDeqpMefbcrg7EnYFvdXmdq
        godvnux/i+6mAqfYNIGcUpuaFKuVsHXLjwFa+8MAwrVv3lL9pdH486EZqKm3oSiD
        IpCf35mTzjVUfSXmpD7FK9mQDbX0d0SN1/ARHqehjLWFVaEiQGCH+plhuhc6+yIw
        ==
X-ME-Sender: <xms:MncVYK-FCe6siMhFy_10U3WWxFHLxtf2iQnukP6UvncB5U2UH9Wn6w>
    <xme:MncVYKtBcy9xOhH49S38ob9OiXj29ekjgp2NE2DCmLiVs12aGZ2RMP8h_Bk3O2hQw
    -zIS7y7Zf6xjOg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrfeeggdejhecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepkfguohcuufgt
    hhhimhhmvghluceoihguohhstghhsehiughoshgthhdrohhrgheqnecuggftrfgrthhtvg
    hrnheptdffkeekfeduffevgeeujeffjefhtefgueeugfevtdeiheduueeukefhudehleet
    necukfhppeekgedrvddvledrudehfedrgeegnecuvehluhhsthgvrhfuihiivgeptdenuc
    frrghrrghmpehmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:MncVYADwFoypGdomtX7NA7GahAJzoHb4kWbHibWgVUpCWpO89DrYFA>
    <xmx:MncVYCecR8ZC7TmNEtkI_2yM7azoH_-TnlRwPvSMul9ppyRzYiF97g>
    <xmx:MncVYPNKAMUKpJ31lP_a6vwYljfT78gLr7qZu7cfcclr2wGCBBnpuA>
    <xmx:M3cVYLC0L2L0Ivg76p4gB5ORNlIvBR2j_KG2E9KEyygeLxkJtEQ-Kg>
Received: from localhost (igld-84-229-153-44.inter.net.il [84.229.153.44])
        by mail.messagingengine.com (Postfix) with ESMTPA id 539DD240057;
        Sat, 30 Jan 2021 10:11:46 -0500 (EST)
Date:   Sat, 30 Jan 2021 17:11:43 +0200
From:   Ido Schimmel <idosch@idosch.org>
To:     David Ahern <dsahern@gmail.com>
Cc:     Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        davem@davemloft.net, amcohen@nvidia.com, roopa@nvidia.com,
        sharpd@nvidia.com, bpoirier@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: Re: [PATCH net-next 05/10] net: ipv4: Emit notification when fib
 hardware flags are changed
Message-ID: <20210130151143.GB3330615@shredder.lan>
References: <20210126132311.3061388-1-idosch@idosch.org>
 <20210126132311.3061388-6-idosch@idosch.org>
 <20210128190405.27d6f086@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <aa5291c2-3bbc-c517-8804-6a0543db66db@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aa5291c2-3bbc-c517-8804-6a0543db66db@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 28, 2021 at 08:33:22PM -0700, David Ahern wrote:
> On 1/28/21 8:04 PM, Jakub Kicinski wrote:
> > On Tue, 26 Jan 2021 15:23:06 +0200 Ido Schimmel wrote:
> >> Emit RTM_NEWROUTE notifications whenever RTM_F_OFFLOAD/RTM_F_TRAP flags
> >> are changed. The aim is to provide an indication to user-space
> >> (e.g., routing daemons) about the state of the route in hardware.
> > 
> > What does the daemon in the user space do with it?
> 
> You don't want FRR for example to advertise a route to a peer until it
> is really programmed in h/w. This notification gives routing daemons
> that information.

Correct. It is in the cover letter:

"These flags are of interest to routing daemons since they would like to
delay advertisement of routes until they are installed in hardware."

Amit is working on follow-up to emit notifications when route offload
fails. This request also comes from the FRR team. Currently we have a
policy inside mlxsw to abort route offload and install a default route
that sends all the traffic to the CPU. It obviously kills the box and
anyway the policy is something user space should decide, not the kernel.

> 
> > 
> > The notification will only be generated for the _first_ ASIC which
> > offloaded the object. Which may be fine for you today but as an uAPI 
> > it feels slightly lacking.
> > 
> > If the user space just wants to make sure the devices are synced to
> > notifications from certain stage, wouldn't it be more idiomatic to
> > provide some "fence" operation?
> > 
> > WDYT? David?
> > 
> 
> This feature was first discussed I think about 2 years ago - when I was
> still with Cumulus, so I already knew the intent and end goal.
> 
> I think support for multiple ASICs / NICs doing this kind of offload
> will have a whole lot of challenges. I don't think this particular user
> notification is going to be a big problem - e.g., you could always delay
> the emit until all have indicated the offload.

I do not have experience with multi-ASIC systems, but my understanding
is that each ASIC has its own copy of the networking stack and the ASICs
are connected via front panel or backplane ports, like distinct
leaf/spine switches. In Linux, such a system can be supported by
registering a devlink instance for each ASIC and reloading each instance
to a separate namespace.

Thanks for reviewing, David
