Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BDE2761F75
	for <lists+netdev@lfdr.de>; Mon,  8 Jul 2019 15:19:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731267AbfGHNTO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jul 2019 09:19:14 -0400
Received: from new4-smtp.messagingengine.com ([66.111.4.230]:37901 "EHLO
        new4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727352AbfGHNTO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Jul 2019 09:19:14 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailnew.nyi.internal (Postfix) with ESMTP id C7215251E;
        Mon,  8 Jul 2019 09:19:12 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Mon, 08 Jul 2019 09:19:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=II31xQ
        tEcDron6N68cewQ84Ftg8YAwfeuqB1zQwW5nI=; b=dAjyeA763i4BnIWNmRb/qA
        Y8ujkyiv/ux0l1Hn+QCigimzjDxuCjJS5PWCc8rC1fgvBtaxE8zNMK4Jiw6cv1VE
        zNCiwz6ehk7jqIERzR2tZGK9ZcNU7MtZOg1UCc+XTpTXeJCWrglNSiXN4EHJ85wZ
        H5bXQSkEkeqAdrdvFckMYm+K7pdFqi0Xr9pkgo0GImL33DyaqR1wz+VPb4nOdn1J
        ho7aB5vGDfxvhwYY5h3PufwIKvRrWOrJR4rsztiCDu2S6DvCzR2UJXoeitKMzcV/
        T4agE+FZXpBdIpoOOngnRcLmx8NALG6gCbvdSPtPOvLU49vzBQHjTebErrGTDDrQ
        ==
X-ME-Sender: <xms:zkIjXVGcfyhA_Qxl5tnFakkIHM8MjwW6l-maD27elLEvL5Utm03fkw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddrgedtgdeihecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggujggfsehttdertddtredvnecuhfhrohhmpefkughoucfu
    tghhihhmmhgvlhcuoehiughoshgthhesihguohhstghhrdhorhhgqeenucfkphepudelfe
    drgeejrdduieehrddvhedunecurfgrrhgrmhepmhgrihhlfhhrohhmpehiughoshgthhes
    ihguohhstghhrdhorhhgnecuvehluhhsthgvrhfuihiivgeptd
X-ME-Proxy: <xmx:zkIjXbqtutmWrVqok1T5GVMVDRrrkbK24E2k5PDBzkm8gwZIFDJ2CA>
    <xmx:zkIjXZlbM67IVYnrmdKNOx9W3k_M9ouf2UFgHvTYs6X25lCKWHe8yA>
    <xmx:zkIjXQu28re7040MbCInz46jXcKqv35B47Z0bUkzWm1GfDVmtDfrfQ>
    <xmx:0EIjXUY1gDa9A3gCuAhV2bsy0Qyj9oLRvQcZHrfzmYtLK7Bq16BojA>
Received: from localhost (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id D67E2380079;
        Mon,  8 Jul 2019 09:19:09 -0400 (EDT)
Date:   Mon, 8 Jul 2019 16:19:08 +0300
From:   Ido Schimmel <idosch@idosch.org>
To:     David Miller <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, jiri@mellanox.com, mlxsw@mellanox.com,
        dsahern@gmail.com, roopa@cumulusnetworks.com,
        nikolay@cumulusnetworks.com, andy@greyhouse.net,
        pablo@netfilter.org, jakub.kicinski@netronome.com,
        pieter.jansenvanvuuren@netronome.com, andrew@lunn.ch,
        f.fainelli@gmail.com, vivien.didelot@gmail.com, idosch@mellanox.com
Subject: Re: [PATCH net-next 00/11] Add drop monitor for offloaded data paths
Message-ID: <20190708131908.GA13672@splinter>
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

Let me try to explain again because I probably wasn't clear enough. The
devlink-trap mechanism is not doing the same thing as other solutions.

The packets we are capturing in this patchset are packets that the
kernel (the CPU) never saw up until now - they were silently dropped by
the underlying device performing the packet forwarding instead of the
CPU.

For each such packet we get valuable metadata from the underlying device
such as the drop reason and the ingress port. With time, even more
reasons and metadata could be provided (e.g., egress port, traffic
class). Netlink provides a structured and extensible way to report the
packet along with the metadata to interested users. The tc-sample action
uses a similar concept.

I would like to emphasize that these dropped packets are not injected to
the kernel's receive path and therefore not subject to kfree_skb() and
related infrastructure. There is no need to waste CPU cycles on packets
we already know were dropped (and why). Further, hardware tail/early
drops will not be dropped by the kernel, given its qdiscs are probably
empty.

Regarding the use of devlink, current ASICs can forward packets at
6.4Tb/s. We do not want to overwhelm the CPU with dropped packets and
therefore we give users the ability to control - via devlink - the
trapping of certain packets to the CPU and their reporting to user
space. In the future, devlink-trap can be extended to support the
configuration of the hardware policers of each trap.
