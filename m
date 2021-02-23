Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C61C532301A
	for <lists+netdev@lfdr.de>; Tue, 23 Feb 2021 18:59:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233857AbhBWR5v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Feb 2021 12:57:51 -0500
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:48369 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233828AbhBWR5e (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Feb 2021 12:57:34 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 3620A5C0115;
        Tue, 23 Feb 2021 12:56:27 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Tue, 23 Feb 2021 12:56:27 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=ax9hpp
        KHjHdmi9MiYiJ7cg/G+rXmjeVb/WQqdM+aU8Y=; b=Zu45cc4Xaal03f4gVnaUXa
        r5b9aLaeUMaAKvb+HOZWKqY6fD2zSV9y7o7LTwu0UquApmHgNEFOlHSqpwJhbZnD
        jjgTRB7s2JffvoI19flm71d2bvNoH7wv/fYW9RrxwirxObhiDWMYobkM3qrICiNs
        81akIJDX/kA50yjFMCLsEsXKLW2mPtar3w99++hTgVy3hi5QyyCdpHgRmTN8t+uA
        llp8Ee1VMR6/zDcOlI3XxgGqjtm4s3RjSQkKadPEpIWZev41njD90ZwOq0zkaS8M
        uRoiH+vlvvu8pW/YJ+7UvqTXU8BUmKRMToUdHjVcOdkeg5iKShsrDCVak/oDsTCw
        ==
X-ME-Sender: <xms:ykE1YG-hr7yZBC1BRp7ehwTjvQ6uyzSJljYavGvCKq2rizMfFqG4GQ>
    <xme:ykE1YGuSG35LeJd4D85sN9IvN2UjIIx9gVfg3bAr-o766B0SIKivYKeddFGukda8w
    AwQhiGBv1UrdlA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrkeehgddutdeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefkughoucfu
    tghhihhmmhgvlhcuoehiughoshgthhesihguohhstghhrdhorhhgqeenucggtffrrghtth
    gvrhhnpedtffekkeefudffveegueejffejhfetgfeuuefgvedtieehudeuueekhfduheel
    teenucfkphepkeegrddvvdelrdduheefrdeggeenucevlhhushhtvghrufhiiigvpedtne
    curfgrrhgrmhepmhgrihhlfhhrohhmpehiughoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:ykE1YMDRTTNexsVTni5cKzXU7hwfQuc1lZOxuQJuYl6RNCDczT0u0Q>
    <xmx:ykE1YOc6eOQ_VMeh0wWggWsNnbeBogVvFGamnZ6fw6fHWO7vm9YBNA>
    <xmx:ykE1YLNiVCeCJQjLfgaX86V_WzlT13Vmgobd3k-Td1New2YVQuxRXw>
    <xmx:y0E1YEbz16gseXgG_TAAq8qixUmaNjh2dF8wN0WUDzSoMVsEZirEYQ>
Received: from localhost (igld-84-229-153-44.inter.net.il [84.229.153.44])
        by mail.messagingengine.com (Postfix) with ESMTPA id 2F5401080068;
        Tue, 23 Feb 2021 12:56:25 -0500 (EST)
Date:   Tue, 23 Feb 2021 19:56:22 +0200
From:   Ido Schimmel <idosch@idosch.org>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Nikolay Aleksandrov <nikolay@nvidia.com>,
        Roopa Prabhu <roopa@nvidia.com>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>, netdev@vger.kernel.org
Subject: Re: Timing of host-joined bridge multicast groups with switchdev
Message-ID: <YDVBxrkYOtlmO1bn@shredder.lan>
References: <20210223173753.vrlxhnj5rtvd6i6g@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210223173753.vrlxhnj5rtvd6i6g@skbuf>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 23, 2021 at 07:37:53PM +0200, Vladimir Oltean wrote:
> Hi,
> 
> I have udhcpcd in my system and this is configured to bring interfaces
> up as soon as they are created.
> 
> I create a bridge as follows:
> 
> ip link add br0 type bridge
> 
> As soon as I create the bridge and udhcpcd brings it up, I have some
> other crap (avahi) that starts sending some random IPv6 packets to
> advertise some local services, and from there, the br0 bridge joins the
> following IPv6 groups:
> 
> 33:33:ff:6d:c1:9c vid 0
> 33:33:00:00:00:6a vid 0
> 33:33:00:00:00:fb vid 0
> 
> br_dev_xmit
> -> br_multicast_rcv
>    -> br_ip6_multicast_add_group
>       -> __br_multicast_add_group
>          -> br_multicast_host_join
>             -> br_mdb_notify
> 
> This is all fine, but inside br_mdb_notify we have br_mdb_switchdev_host
> hooked up, and switchdev will attempt to offload the host joined groups
> to an empty list of ports. Of course nobody offloads them.
> 
> Then when we add a port to br0:
> 
> ip link set swp0 master br0
> 
> the bridge doesn't replay the host-joined MDB entries from br_add_if ->
> new_nbp -> br_multicast_add_port (should it?), and eventually the host
> joined addresses expire, and a switchdev notification for deleting it is
> emitted, but surprise, the original addition was already completely missed.
> 
> What to do?

For route offload you get a dump of all the existing routes when you
register your notifier. It's a bit different with bridge because you
don't care about existing bridges when you just initialize your driver.

We had a similar issue with VXLAN because its FDB can be populated and
only then attached to a bridge that you offload. Check
vxlan_fdb_replay(). Probably need to introduce something similar for
FDB/MDB entries.
