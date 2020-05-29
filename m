Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D4B91E86B9
	for <lists+netdev@lfdr.de>; Fri, 29 May 2020 20:35:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726999AbgE2SfW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 May 2020 14:35:22 -0400
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:40385 "EHLO
        out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725839AbgE2SfW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 May 2020 14:35:22 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id 13C0F5C00F5;
        Fri, 29 May 2020 14:35:21 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Fri, 29 May 2020 14:35:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=CqAth+
        /2lvXqWSMZ4rZkTe9fkbcuHQ3N2AK8xsdLiJw=; b=hnBGR7S65i96R82by4q2JP
        qqpDTW2m/+OJy2/8tTZG6AalEbjTrDmO83J95PctlZruDfTVFgn4/wop1oYB3VIU
        hs+SgMsMNi0tw02ByDsa4pkAjTxReqPMkZ6fneHcbRwFK4xEBO11fjYFtQuFZ0s0
        yHginpZw5EZ8dQJqbUzsAbYAmnfc1EJ3nn7aV4bwoHgaietN6oPaB2VV1wuBIevH
        NbTKPySpZJchSy72xDNoCZbZ0r12fwvWS7hkTwxCaPcj51/uxOa59f6PtTMjBNHF
        piNWOKkFHVviEVkF3VmmPQ1ytN7CjdSpftDrgmE57roGFqszoMXB6I2QFTG+k9Wg
        ==
X-ME-Sender: <xms:6FXRXjZRiosyU6qGfuCldVAy-sfpfT8wg6YWHkrE4G92Hq2HL0MdnQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedruddvkedguddtfecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhepfffhvffukfhfgggtuggjsehttd
    ertddttddvnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihgu
    ohhstghhrdhorhhgqeenucggtffrrghtthgvrhhnpedtffekkeefudffveegueejffejhf
    etgfeuuefgvedtieehudeuueekhfduheelteenucfkphepjeelrddujeeirddvgedruddt
    jeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiug
    hoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:6FXRXiY0mahdr1xqhRLpXUmQ8fi0z56LNWn2SArgrdMi0R1rlGiEDw>
    <xmx:6FXRXl-wfWzEp061I8s_QEtsXQ1VxTS2RrdkW6HaqRvdEpvH0Q9T3A>
    <xmx:6FXRXprecFzc2kCCoR7HQ1ohpiY3_PdC9loT8B2iz9Dhnc3FQ_DFGw>
    <xmx:6VXRXjBjZ_Lwu-276-TkOPwL1FymYcxcG5d6OWywbaba0ItFyeX2fw>
Received: from localhost (bzq-79-176-24-107.red.bezeqint.net [79.176.24.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 74D7A3280066;
        Fri, 29 May 2020 14:35:20 -0400 (EDT)
Date:   Fri, 29 May 2020 21:35:18 +0300
From:   Ido Schimmel <idosch@idosch.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, jiri@mellanox.com,
        mlxsw@mellanox.com, Ido Schimmel <idosch@mellanox.com>
Subject: Re: [PATCH net-next 00/14] mlxsw: Various trap changes - part 2
Message-ID: <20200529183518.GA1601549@splinter>
References: <20200525230556.1455927-1-idosch@idosch.org>
 <20200526151437.6fc3fb67@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
 <20200526231905.GA1507270@splinter>
 <20200526164323.565c8309@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
 <20200527073857.GA1511819@splinter>
 <20200527125017.1c960f70@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200527125017.1c960f70@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 27, 2020 at 12:50:17PM -0700, Jakub Kicinski wrote:
> On Wed, 27 May 2020 10:38:57 +0300 Ido Schimmel wrote:
> > There is no special sauce required to get a DHCP daemon working nor BFD.
> > It is supposed to Just Work. Same for IGMP / MLD snooping, STP etc. This
> > is enabled by the ASIC trapping the required packets to the CPU.
> > 
> > However, having a 3.2/6.4/12.8 Tbps ASIC (it keeps growing all the time)
> > send traffic to the CPU can very easily result in denial of service. You
> > need to have hardware policers and classification to different traffic
> > classes ensuring the system remains functional regardless of the havoc
> > happening in the offloaded data path.
> 
> I don't see how that's only applicable to a switch ASIC, though.
> Ingress classification, and rate limiting applies to any network 
> system.

This is not about ingress classification and rate limiting. The
classification does not happen at ingress. It happens throughout
different points in the pipeline, by hard-coded checks meant to identify
packets of interest. These checks look at both state (e.g., neighbour
miss, route miss) and packet fields (e.g., BGP packet that hit a local
route).

Similarly, the rate limiting does not happen at ingress. It only applies
to packets that your offloaded data path decided should go to the
attached host (the control plane). You cannot perform the rate limiting
at ingress for the simple reason that you still do not know if the
packet should reach the control plane.

> 
> > This control plane policy has been hard coded in mlxsw for a few years
> > now (based on sane defaults), but it obviously does not fit everyone's
> > needs. Different users have different use cases and different CPUs
> > connected to the ASIC. Some have Celeron / Atom while others have more
> > high-end Xeon CPUs, which are obviously capable of handling more packets
> > per second. You also have zero visibility into how many packets were
> > dropped by these hardware policers.
> 
> There are embedded Atom systems out there with multi-gig interfaces,
> they obviously can't ingest peak traffic, doesn't matter whether they
> are connected to a switch ASIC or a NIC.

Not the same thing. Every packet received by such systems should reach
the attached host. The control plane and the data plane are the same.
The whole point of this work is to rate limit packets coming from your
offloaded data plane to the control plane.

> 
> > By exposing these traps we allow users to tune these policers and get
> > visibility into how many packets they dropped. In the future also
> > changing their traffic class, so that (for example), packets hitting
> > local routes are scheduled towards the CPU before packets dropped due to
> > ingress VLAN filter.
> > 
> > If you don't have any special needs you are probably OK with the
> > defaults, in which case you don't need to do anything (no special
> > sauce).
> 
> As much as traps which forward traffic to the CPU fit the switch
> programming model, we'd rather see a solution that offloads constructs
> which are also applicable to the software world.

In the software world the data plane and the control plane are the same.
The CPU sees every packet. IGMP packets trigger MDB modifications,
packets that incurred a neighbour miss trigger an ARP / ND etc. These
are all control plane operations.

Once you separate your control plane from the data plane and offload the
latter to a capable hardware (e.g., switch ASIC), you create a need to
limit the packets coming from your data plane to the control plane. This
is a hardware-specific problem.

> 
> Sniffing dropped frames to troubleshoot is one thing, but IMHO traps
> which default to "trap" are a bad smell.

These traps exist today. They are programmed by mlxsw during
initialization. Without them basic stuff like DHCP/ARP/STP would not
work and you would need the "special sauce" you previously mentioned.

By exposing them via devlink-trap we allow users to configure their rate
from the offloaded data plane towards the control plane running on the
attached host. This is the only set operation you can do. Nothing else.

Anyway, I don't know how to argue with "bad smell". I held off on
sending the next patch set because this discussion was on-going, but at
this point I don't think it's possible for me to explain the problem and
solution in a clearer fashion, so I'll go ahead and send the patches.

Thanks
