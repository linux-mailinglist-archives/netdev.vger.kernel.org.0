Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4563365719
	for <lists+netdev@lfdr.de>; Thu, 11 Jul 2019 14:39:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728231AbfGKMjP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Jul 2019 08:39:15 -0400
Received: from new2-smtp.messagingengine.com ([66.111.4.224]:49851 "EHLO
        new2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726016AbfGKMjP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Jul 2019 08:39:15 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailnew.nyi.internal (Postfix) with ESMTP id C16B83580;
        Thu, 11 Jul 2019 08:39:13 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Thu, 11 Jul 2019 08:39:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=Yx8SKZ
        3tf3DhsyBMrrvEo1eA953BtoM4IqdhkJbacsI=; b=VGTV6PM7KT88OVKLsD4wcS
        auIy8IxIiCrXNsfc98EhgzpMYcU+S08pTw0P4dACBFqQzgVJDBy6+i6/b4Q0Y/Q4
        57mKmP2B1QWqz7aj29HxUyFvIaXUN/fRbAWo25QfQoI4eiL1LaEw1DYypG2kwr5N
        Qwnb5J1qbROrP63X7mXQVuyuUx4jPc+b2TPqXwPhGPjEpNQeXFL4D1/UTcrLh3Jv
        WcIy8ruqCC99ApOLe7mpKB3L3PDsOdWc8LXRWeQe3xcu0QxgK04e1yON0/simOOp
        TjTmzj6uLn9Efzr1Om3aaWykCW/5NVCX5dTUzXWVJve/yC2KcWsFO6LUym0DTwpg
        ==
X-ME-Sender: <xms:7y0nXffjkecMIVE9vcnnqK5PshGjHaNCFXAAeQUSThWK3sOfHONmMQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddrgeekgdehiecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggujggfsehttdertddtredvnecuhfhrohhmpefkughoucfu
    tghhihhmmhgvlhcuoehiughoshgthhesihguohhstghhrdhorhhgqeenucffohhmrghinh
    epghhithhhuhgsrdgtohhmnecukfhppeduleefrdegjedrudeihedrvdehudenucfrrghr
    rghmpehmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrghenucevlhhush
    htvghrufhiiigvpedt
X-ME-Proxy: <xmx:7y0nXQCM2tTDOTMIXcViS4uDhixGS9BovPMSUQ2NXzunUi4fiab0wQ>
    <xmx:7y0nXWxo_dzvZtWHZJt1sZxp29PLs9rtDhovwV0_jqgCcAV0W_SvkQ>
    <xmx:7y0nXQg2LrlIbyCEwdn0BRtBEu8hx8ptUoEVtXL-x25qZiMMZMygDQ>
    <xmx:8S0nXR0dZiPe5y5hARfhzeXyNpQC0YHG961Xh9GorOM2Jw67G4qHaA>
Received: from localhost (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id 53A218005C;
        Thu, 11 Jul 2019 08:39:11 -0400 (EDT)
Date:   Thu, 11 Jul 2019 15:39:09 +0300
From:   Ido Schimmel <idosch@idosch.org>
To:     David Miller <davem@davemloft.net>, nhorman@tuxdriver.com
Cc:     netdev@vger.kernel.org, jiri@mellanox.com, mlxsw@mellanox.com,
        dsahern@gmail.com, roopa@cumulusnetworks.com,
        nikolay@cumulusnetworks.com, andy@greyhouse.net,
        pablo@netfilter.org, jakub.kicinski@netronome.com,
        pieter.jansenvanvuuren@netronome.com, andrew@lunn.ch,
        f.fainelli@gmail.com, vivien.didelot@gmail.com, idosch@mellanox.com
Subject: Re: [PATCH net-next 00/11] Add drop monitor for offloaded data paths
Message-ID: <20190711123909.GA10978@splinter>
References: <20190707075828.3315-1-idosch@idosch.org>
 <20190707.124541.451040901050013496.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190707.124541.451040901050013496.davem@davemloft.net>
User-Agent: Mutt/1.11.3 (2019-02-01)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jul 07, 2019 at 12:45:41PM -0700, David Miller wrote:
> From: Ido Schimmel <idosch@idosch.org>
> Date: Sun,  7 Jul 2019 10:58:17 +0300
> 
> > Users have several ways to debug the kernel and understand why a packet
> > was dropped. For example, using "drop monitor" and "perf". Both
> > utilities trace kfree_skb(), which is the function called when a packet
> > is freed as part of a failure. The information provided by these tools
> > is invaluable when trying to understand the cause of a packet loss.
> > 
> > In recent years, large portions of the kernel data path were offloaded
> > to capable devices. Today, it is possible to perform L2 and L3
> > forwarding in hardware, as well as tunneling (IP-in-IP and VXLAN).
> > Different TC classifiers and actions are also offloaded to capable
> > devices, at both ingress and egress.
> > 
> > However, when the data path is offloaded it is not possible to achieve
> > the same level of introspection as tools such "perf" and "drop monitor"
> > become irrelevant.
> > 
> > This patchset aims to solve this by allowing users to monitor packets
> > that the underlying device decided to drop along with relevant metadata
> > such as the drop reason and ingress port.
> 
> We are now going to have 5 or so ways to capture packets passing through
> the system, this is nonsense.
> 
> AF_PACKET, kfree_skb drop monitor, perf, XDP perf events, and now this
> devlink thing.
> 
> This is insanity, too many ways to do the same thing and therefore the
> worst possible user experience.
> 
> Pick _ONE_ method to trap packets and forward normal kfree_skb events,
> XDP perf events, and these taps there too.
> 
> I mean really, think about it from the average user's perspective.  To
> see all drops/pkts I have to attach a kfree_skb tracepoint, and not just
> listen on devlink but configure a special tap thing beforehand and then
> if someone is using XDP I gotta setup another perf event buffer capture
> thing too.

Dave,

Before I start working on v2, I would like to get your feedback on the
high level plan. Also adding Neil who is the maintainer of drop_monitor
(and counterpart DropWatch tool [1]).

IIUC, the problem you point out is that users need to use different
tools to monitor packet drops based on where these drops occur
(SW/HW/XDP).

Therefore, my plan is to extend the existing drop_monitor netlink
channel to also cover HW drops. I will add a new message type and a new
multicast group for HW drops and encode in the message what is currently
encoded in the devlink events.

I would like to emphasize that the configuration of whether these
dropped packets are even sent to the CPU from the device still needs to
reside in devlink given this is the go-to tool for device-specific
configuration. In addition, these drop traps are a small subset of the
entire packet traps devices support and all have similar needs such as
HW policer configuration and statistics.

In the future we might also want to report events that indicate the
formation of possible problems. For example, in case packets are queued
above a certain threshold or for long periods of time. I hope we could
re-use drop_monitor for this as well, thereby making it the go-to
channel for diagnosing current and to-be problems in the data path.

Thanks

[1] https://github.com/nhorman/dropwatch
