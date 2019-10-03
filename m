Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 38C9AC97DF
	for <lists+netdev@lfdr.de>; Thu,  3 Oct 2019 07:18:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726472AbfJCFSg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Oct 2019 01:18:36 -0400
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:60239 "EHLO
        out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726354AbfJCFSg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Oct 2019 01:18:36 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id EBBB021EA0;
        Thu,  3 Oct 2019 01:18:35 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Thu, 03 Oct 2019 01:18:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=47qUgz
        IW1xVVvx1d7kSuSzjJzZVgAB9ct6rq4oLG3v8=; b=CzgAATl4eVc+y/STScyej+
        +5OHAQ+JcRt9RjfYTteZlPQIduLoBCcJUN5JAdKypcAC9S2oGT+xkp6PZJg6DMiZ
        brYG3p8HgJigJpnxZcTKgki5IZN1W6w6aWZK6Uci223aXx89MN6kLQC0xzI4+x/+
        sDqS0UkSpnsT2DuddsZ6er5y2ELCGEAyIE2rF864LL/gOijYw2q6qVuLixCg5qqc
        kuVlK7fX3yoecEAQthj3N0EBSvyG3mg83WhlmcvnU/ud4BKBmpHS2RqUMnP60zQ5
        wXWsSIu9jbY/DMW+/Vm/kwAOvld+Qf0jQJWTl/HukcITa0CwBlIL+liD2RhwMV8g
        ==
X-ME-Sender: <xms:q4SVXdlizsYPpObPGgUI0e0iZUMpH_7YhA-l-stKL_5t54NM-G38RQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrgeejgdelvdcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggujggfsehttdertddtredvnecuhfhrohhmpefkughoucfu
    tghhihhmmhgvlhcuoehiughoshgthhesihguohhstghhrdhorhhgqeenucfkphepudelfe
    drgeejrdduieehrddvhedunecurfgrrhgrmhepmhgrihhlfhhrohhmpehiughoshgthhes
    ihguohhstghhrdhorhhgnecuvehluhhsthgvrhfuihiivgepud
X-ME-Proxy: <xmx:q4SVXfZMAwc9dk0MG5XdgmnNllqDqvgAXKBUnKdFm1u0aX76kOdtFA>
    <xmx:q4SVXQ313as1mxy1zsjH4uyiqLDf6QT_px_-doeN0gXPkIdDRshKCA>
    <xmx:q4SVXfrl29LJuANzkKs6cKZ3vVMTFnxQUK7x6eHMSAFFct4a02nHnw>
    <xmx:q4SVXU9B02BBDaJHZ6Hq66Hp4ujmHLMogBbT_AS0lRw6hhQteHpDNw>
Received: from localhost (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id BCB3C8005A;
        Thu,  3 Oct 2019 01:18:34 -0400 (EDT)
Date:   Thu, 3 Oct 2019 08:18:32 +0300
From:   Ido Schimmel <idosch@idosch.org>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, dsahern@gmail.com,
        jiri@mellanox.com, jakub.kicinski@netronome.com,
        saeedm@mellanox.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: Re: [RFC PATCH net-next 00/15] Simplify IPv4 route offload API
Message-ID: <20191003051832.GB4325@splinter>
References: <20191002084103.12138-1-idosch@idosch.org>
 <20191002181759.GE2279@nanopsycho>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191002181759.GE2279@nanopsycho>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 02, 2019 at 08:17:59PM +0200, Jiri Pirko wrote:
> Wed, Oct 02, 2019 at 10:40:48AM CEST, idosch@idosch.org wrote:
> >From: Ido Schimmel <idosch@mellanox.com>
> >
> >Today, whenever an IPv4 route is added or deleted a notification is sent
> >in the FIB notification chain and it is up to offload drivers to decide
> >if the route should be programmed to the hardware or not. This is not an
> >easy task as in hardware routes are keyed by {prefix, prefix length,
> >table id}, whereas the kernel can store multiple such routes that only
> >differ in metric / TOS / nexthop info.
> >
> >This series makes sure that only routes that are actually used in the
> >data path are notified to offload drivers. This greatly simplifies the
> >work these drivers need to do, as they are now only concerned with
> >programming the hardware and do not need to replicate the IPv4 route
> >insertion logic and store multiple identical routes.
> >
> >The route that is notified is the first FIB alias in the FIB node with
> >the given {prefix, prefix length, table ID}. In case the route is
> >deleted and there is another route with the same key, a replace
> >notification is emitted. Otherwise, a delete notification is emitted.
> >
> >The above means that in the case of multiple routes with the same key,
> >but different TOS, only the route with the highest TOS is notified.
> >While the kernel can route a packet based on its TOS, this is not
> >supported by any hardware devices I'm familiar with. Moreover, this is
> >not supported by IPv6 nor by BIRD/FRR from what I could see. Offload
> >drivers should therefore use the presence of a non-zero TOS as an
> >indication to trap packets matching the route and let the kernel route
> >them instead. mlxsw has been doing it for the past two years.
> >
> >The series also adds an "in hardware" indication to routes, in addition
> 
> I think this might be a separate patchset. I mean patch "ipv4: Replace
> route in list before notifying" and above.

OK. I mainly wanted to have it together in order to submit the tests
with the patchset itself. I can split it into two.
