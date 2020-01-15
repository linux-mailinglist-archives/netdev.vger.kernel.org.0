Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5CAE313CCF6
	for <lists+netdev@lfdr.de>; Wed, 15 Jan 2020 20:19:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726527AbgAOTTg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jan 2020 14:19:36 -0500
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:57183 "EHLO
        out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725999AbgAOTTg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jan 2020 14:19:36 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 5A58522085;
        Wed, 15 Jan 2020 14:19:35 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Wed, 15 Jan 2020 14:19:35 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=lFOhyx
        55xjNGhMEvMKh98M1xXLHAofEmofJC0TwH0ek=; b=UWrRhi44JAHgmfltXo6BSP
        3liUyO7XQYtLOf1pHoq1pQ3oYTTPb8bth7324N87oihx97BEdKTWEZGOPfuiK03u
        kDofsfkQxaA+DXxevc6CVESO5En02AUaNb/3Wa2HVTzCSBPsB9iha3YeShC+Lxrh
        sntHgKlmpOhW/hE/PZhgQ2MJOL4Ak8azmdy21ZCkZBZhH53NQrrPOrl6AzWByX+I
        KAGQdXEqR99IfDLyy7g+Jl6kHWmrGmd+9nZj0wNYdslTqX4dwqgs1/IIC59EQY5P
        naRrHY5NMb+sy80R/2DyKEhfBRAEx6uwSUXpwG30+N7tq8yg4NEymujQvWXMFhig
        ==
X-ME-Sender: <xms:xmUfXu_PhCKNM-4ZdgqtmuOhCNsJVpSCrq-b54qXEG3peCZbPB30IA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrtdefgdduvddvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefkughoucfu
    tghhihhmmhgvlhcuoehiughoshgthhesihguohhstghhrdhorhhgqeenucffohhmrghinh
    eptggrnhguvghlrghtvggthhdrtghomhenucfkphepjeejrddufeekrddvgeelrddvtdel
    necurfgrrhgrmhepmhgrihhlfhhrohhmpehiughoshgthhesihguohhstghhrdhorhhgne
    cuvehluhhsthgvrhfuihiivgeptd
X-ME-Proxy: <xmx:xmUfXuQIovbYrEd2neFHfCojbX-NEM2h-4VTVGJ87V7bnRef-KiM_A>
    <xmx:xmUfXnCBF7YT8msFwVjvnDakUd9G8xKYoDv4DrgMBew9XP9aQZ1Rfw>
    <xmx:xmUfXiezzmFrySVHfb0E98ilpEYR5z6_iWMJH5jUCvgjgJlLv7rj9w>
    <xmx:x2UfXjBO_-RNQbJUbL6p1Vk25zITys_ewyxZ-EPn1A0tzYnx2fZkug>
Received: from localhost (unknown [77.138.249.209])
        by mail.messagingengine.com (Postfix) with ESMTPA id E72C030602DE;
        Wed, 15 Jan 2020 14:19:33 -0500 (EST)
Date:   Wed, 15 Jan 2020 21:19:20 +0200
From:   Ido Schimmel <idosch@idosch.org>
To:     Ben Greear <greearb@candelatech.com>
Cc:     David Ahern <dsahern@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: vrf and multicast is broken in some cases
Message-ID: <20200115191920.GA1490933@splinter>
References: <e439bcae-7d20-801c-007d-a41e8e9cd5f5@candelatech.com>
 <3906c6fe-e7a7-94c1-9d7d-74050084b56e@gmail.com>
 <dbefe9b1-c846-6cc6-3819-520fd084a447@candelatech.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <dbefe9b1-c846-6cc6-3819-520fd084a447@candelatech.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 15, 2020 at 11:02:26AM -0800, Ben Greear wrote:
> 
> 
> On 01/15/2020 10:45 AM, David Ahern wrote:
> > On 1/15/20 10:57 AM, Ben Greear wrote:
> > > Hello,
> > > 
> > > We put two different ports into their own VRF, and then tried to run a
> > > multicast
> > > sender on one and receiver on the other.  The receiver does not receive
> > > anything.
> > > 
> > > Is this a known problem?
> > > 
> > > If we do a similar setup with policy based routing rules instead of VRF,
> > > then the multicast
> > > test works.
> > > 
> > 
> > It works for OSPF for example. I have lost track of FRR features that
> > use it, so you will need to specify more details.
> > 
> > Are the sender / receiver on the same host?
> 
> Yes, like eth2 sending to eth3, eth2 is associated with _vrf2, eth3 with _vrf3.

Two questions:

1. Did you re-order the FIB rules so that l3mdev rule is before the main
table?
2. Did you configure a default unreachable route in the VRF?

IIRC, locally generated multicast packets are forwarded according to the
unicast FIB rules, so if you don't have the unreachable route, it is
possible the packet is forwarded according to the default route in the
main table.

> 
> I'll go poking at the code.
> 
> Thanks,
> Ben
> 
> -- 
> Ben Greear <greearb@candelatech.com>
> Candela Technologies Inc  http://www.candelatech.com
