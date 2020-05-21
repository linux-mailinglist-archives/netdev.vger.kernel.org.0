Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D4A091DD8DE
	for <lists+netdev@lfdr.de>; Thu, 21 May 2020 22:52:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729826AbgEUUwR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 May 2020 16:52:17 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:43027 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728778AbgEUUwR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 May 2020 16:52:17 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id 6D9035C00C4;
        Thu, 21 May 2020 16:52:16 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Thu, 21 May 2020 16:52:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=FDjHLS
        98QpqdtvIr6hFPDME1kvXU6ZRy0mCau8zXmxE=; b=MDiKGq2yJPjRCQsjEnAI5K
        1F5iNankDc3Tc132RiuZIjc+GAKYQbBxctsta4t23CrZ8bvbTfocKji1CRIsp4dp
        FRrIZkfXC/5/2ROXtXnsxeUdo5RnapTXLafOIQ9C3gw+P/59y217o1c8xT3XD+SM
        MDuN0yAOR/jd7EQsa92N1LpnS0y/AKcY4oCv+eMXCbsQL3hpZ4sytVVSchhrIdex
        58tVUzbmvfV/bXfMOjNXnDXcsF8cAepYChYiaYYk4glo/A0Ood838wi4py3oALig
        ndGk8bVR0W3tRbHkaYOdlPY8yptImv/4MJQj5sSWtBPXQR0O3jwcr3oryov6XzFQ
        ==
X-ME-Sender: <xms:AOrGXqulq2LpGdMbGUX2MXV3br5Z_Cu8shbjKCIBF89DiKAHAeO91g>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrudduuddgudeghecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepkfguohcu
    ufgthhhimhhmvghluceoihguohhstghhsehiughoshgthhdrohhrgheqnecuggftrfgrth
    htvghrnhepgfevgfevueduueffieffheeifffgjeelvedtteeuteeuffekvefggfdtudfg
    keevnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphepjeelrddujeeirddvge
    druddtjeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhm
    pehiughoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:AOrGXvdHh4UAInRAlCJm-3UjDdr0OgGmgkYl__9cWRD0_cEEZnStpA>
    <xmx:AOrGXlzmVeYe8FAI4ClmwXmqFi9zv199KFV14blFWhq3gKYpcULcqg>
    <xmx:AOrGXlMpPakkY_HZKeATku7qvHqiv7Ejx27XeYX5KxaGil0MW0ZZPA>
    <xmx:AOrGXgns4m69dZaCGBVuMRRPLAt8cFNXwl5-OvVH6Bay7v0IEWptMQ>
Received: from localhost (bzq-79-176-24-107.red.bezeqint.net [79.176.24.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id A8F4A306649A;
        Thu, 21 May 2020 16:52:15 -0400 (EDT)
Date:   Thu, 21 May 2020 23:52:13 +0300
From:   Ido Schimmel <idosch@idosch.org>
To:     Jacob Keller <jacob.e.keller@intel.com>
Cc:     Jakub Kicinski <kuba@kernel.org>, Jiri Pirko <jiri@resnulli.us>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        petrm@mellanox.com, amitc@mellanox.com
Subject: Re: devlink interface for asynchronous event/messages from firmware?
Message-ID: <20200521205213.GA1093714@splinter>
References: <fea3e7bc-db75-ce15-1330-d80483267ee2@intel.com>
 <20200520171655.08412ba5@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <b0435043-269b-9694-b43e-f6740d1862c9@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b0435043-269b-9694-b43e-f6740d1862c9@intel.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 21, 2020 at 01:22:34PM -0700, Jacob Keller wrote:
> On 5/20/2020 5:16 PM, Jakub Kicinski wrote:
> > On Wed, 20 May 2020 17:03:02 -0700 Jacob Keller wrote:
> >> Hi Jiri, Jakub,
> >>
> >> I've been asked to investigate using devlink as a mechanism for
> >> reporting asynchronous events/messages from firmware including
> >> diagnostic messages, etc.
> >>
> >> Essentially, the ice firmware can report various status or diagnostic
> >> messages which are useful for debugging internal behavior. We want to be
> >> able to get these messages (and relevant data associated with them) in a
> >> format beyond just "dump it to the dmesg buffer and recover it later".
> >>
> >> It seems like this would be an appropriate use of devlink. I thought
> >> maybe this would work with devlink health:
> >>
> >> i.e. we create a devlink health reporter, and then when firmware sends a
> >> message, we use devlink_health_report.
> >>
> >> But when I dug into this, it doesn't seem like a natural fit. The health
> >> reporters expect to see an "error" state, and don't seem to really fit
> >> the notion of "log a message from firmware" notion.
> >>
> >> One of the issues is that the health reporter only keeps one dump, when
> >> what we really want is a way to have a monitoring application get the
> >> dump and then store its contents.
> >>
> >> Thoughts on what might make sense for this? It feels like a stretch of
> >> the health interface...
> >>
> >> I mean basically what I am thinking of having is using the devlink_fmsg
> >> interface to just send a netlink message that then gets sent over the
> >> devlink monitor socket and gets dumped immediately.
> > 
> > Why does user space need a raw firmware interface in the first place?
> > 
> > Examples?
> > 
> 
> So the ice firmware can optionally send diagnostic debug messages via
> its control queue. The current solutions we've used internally
> essentially hex-dump the binary contents to the kernel log, and then
> these get scraped and converted into a useful format for human consumption.
> 
> I'm not 100% of the format, but I know it's based on a decoding file
> that is specific to a given firmware image, and thus attempting to tie
> this into the driver is problematic.

You explained how it works, but not why it's needed :)

> There is also a plan to provide a simpler interface for some of the
> diagnostic messages where a simple bijection between one code to one
> message for a handful of events, like if the link engine can detect a
> known reason why it wasn't able to get link. I suppose these could be
> translated and immediately printed by the driver without a special
> interface.

Petr worked on something similar last year:
https://lore.kernel.org/netdev/cover.1552672441.git.petrm@mellanox.com/

Amit is currently working on a new version based on ethtool (netlink).
