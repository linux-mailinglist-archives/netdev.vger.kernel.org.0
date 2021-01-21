Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B4A3E2FE782
	for <lists+netdev@lfdr.de>; Thu, 21 Jan 2021 11:26:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725933AbhAUKYv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jan 2021 05:24:51 -0500
Received: from wout2-smtp.messagingengine.com ([64.147.123.25]:33117 "EHLO
        wout2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729059AbhAUKYS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Jan 2021 05:24:18 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.west.internal (Postfix) with ESMTP id 2C32B1CC4;
        Thu, 21 Jan 2021 05:23:22 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Thu, 21 Jan 2021 05:23:22 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=nDpE8+
        q8PSmtJR9sphFQrcjS9rRrHX40AxSUK7gCIV8=; b=DK14f7RBpVriQRb4jVlYCy
        o5guzsYCeRDOL9tYXzDM7ZlgjOUJJRChLicO8iCrgTlyHUfeWhgosQJAeHwcuqkK
        rwXSyAYpRv7k8rGS+/6Z2d1gPYZ4gg/YiP9AKYF9YCK24xnEzuL09AARyRPHespL
        QMu74fnvdE8X61jQmAjb0SOxW9gUJlg1IgN2zgMyPph47uVNgFsBT7Z89zTgXJGi
        Ltv5bb7ptruwzySXJVaYjbxYA8Ha/odu94UI4lqZyvnLFlUshNJ6pvhcRL8ZiO4Y
        Ohi9s8ax+W6zpw/X7zN/Do3UOjhg9OP5gazI4ShTaNMg+gjq+z0wDQSZPA7UXkZA
        ==
X-ME-Sender: <xms:GVYJYNM27Vm1jEIGlwgCoAzKBR7LaeOt3tMYLnbBiHWwecbIUybtZw>
    <xme:GVYJYP8FvDUSvih9Fy77adgDLk-3XuFEwNR4qS3Lk_vgSDkYdsFYoyFaAZwLuq6l6
    xu5giHS6twV-P4>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrudeggdduiecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepfffhvffukfhfgggtuggjsehttdertd
    dttddvnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihguohhs
    tghhrdhorhhgqeenucggtffrrghtthgvrhhnpedtffekkeefudffveegueejffejhfetgf
    euuefgvedtieehudeuueekhfduheelteenucfkphepkeegrddvvdelrdduheefrdeggeen
    ucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiughosh
    gthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:GVYJYMT_5W43JXjeH1-K3ziD7_ylISJG3nPEXfRrCkfQKrvFxpUSLw>
    <xmx:GVYJYJtqS-EoZ0WEfzQnXWzzXKVm_IIFcehDSlqXpsdelNM-edWRBw>
    <xmx:GVYJYFdqC5xGkmBbmscs5vTfi9fausEQGIIc0VyD_NQVLoxk8L5uaw>
    <xmx:GVYJYM6jt8QjZVUwpNLV3tFSWjQ0TvIyHwy5Y2Wro3lQaONK8-52Ag>
Received: from localhost (igld-84-229-153-44.inter.net.il [84.229.153.44])
        by mail.messagingengine.com (Postfix) with ESMTPA id 2267A1080063;
        Thu, 21 Jan 2021 05:23:20 -0500 (EST)
Date:   Thu, 21 Jan 2021 12:23:18 +0200
From:   Ido Schimmel <idosch@idosch.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, petrm@nvidia.com,
        jiri@nvidia.com, amcohen@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: Re: [PATCH net-next 0/5] mlxsw: Add support for RED qevent "mark"
Message-ID: <20210121102318.GA2637214@shredder.lan>
References: <20210117080223.2107288-1-idosch@idosch.org>
 <20210119142255.1caca7fb@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20210120091437.GA2591869@shredder.lan>
 <20210120164508.6009dbbd@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210120164508.6009dbbd@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 20, 2021 at 04:45:08PM -0800, Jakub Kicinski wrote:
> On Wed, 20 Jan 2021 11:14:37 +0200 Ido Schimmel wrote:
> > On Tue, Jan 19, 2021 at 02:22:55PM -0800, Jakub Kicinski wrote:
> > > On Sun, 17 Jan 2021 10:02:18 +0200 Ido Schimmel wrote:  
> > > > From: Ido Schimmel <idosch@nvidia.com>
> > > > 
> > > > The RED qdisc currently supports two qevents: "early_drop" and "mark". The
> > > > filters added to the block bound to the "early_drop" qevent are executed on
> > > > packets for which the RED algorithm decides that they should be
> > > > early-dropped. The "mark" filters are similarly executed on ECT packets
> > > > that are marked as ECN-CE (Congestion Encountered).
> > > > 
> > > > A previous patchset has offloaded "early_drop" filters on Spectrum-2 and
> > > > later, provided that the classifier used is "matchall", that the action
> > > > used is either "trap" or "mirred", and a handful or further limitations.  
> > > 
> > > For early_drop trap or mirred makes obvious sense, no explanation
> > > needed.
> > > 
> > > But for marked as a user I'd like to see a _copy_ of the packet, 
> > > while the original continues on its marry way to the destination.
> > > I'd venture to say that e.g. for a DCTCP deployment mark+trap is
> > > unusable, at least for tracing, because it distorts the operation 
> > > by effectively dropping instead of marking.
> > > 
> > > Am I reading this right?  
> > 
> > You get a copy of the packet as otherwise it will create a lot of
> > problems (like you wrote).
> 
> Hm, so am I missing some background on semantics on TC_ACT_TRAP?
> Or perhaps you use a different action code?

Well, to make it really clear, we can add TC_ACT_TRAP_MIRROR.

TC_ACT_TRAP: Sole copy goes to the CPU
TC_ACT_TRAP_MIRROR: The packet is forwarded by the underlying device and
a copy is sent to the CPU

And only allow (in mlxsw) attaching filters with TC_ACT_TRAP_MIRROR to
the "mark" qevent.

> 
> AFAICT the code in the kernel is:
> 
> struct sk_buff *tcf_qevent_handle(...
> 
> 	case TC_ACT_STOLEN:
> 	case TC_ACT_QUEUED:
> 	case TC_ACT_TRAP:
> 		__qdisc_drop(skb, to_free);
> 		*ret = __NET_XMIT_STOLEN;
> 		return NULL;
> 
> Having TRAP mean DROP makes sense for filters, but in case of qevents
> shouldn't they be a no-op?
> 
> Looking at sch_red looks like TRAP being a no-op would actually give us
> the expected behavior.

I'm not sure it makes sense to try to interpret these actions in
software (I expect they will be used with "skip_sw" filters), but
TC_ACT_TRAP_MIRROR can be a no-op like you suggested.

> 
> > > If that is the case and you really want to keep the mark+trap
> > > functionality - I feel like at least better documentation is needed.
> > > The current two liner should also be rewritten, quoting from patch 1:
> > >   
> > > > * - ``ecn_mark``
> > > >   - ``drop``
> > > >   - Traps ECN-capable packets that were marked with CE (Congestion
> > > >     Encountered) code point by RED algorithm instead of being dropped  
> > > 
> > > That needs to say that the trap is for datagrams trapped by a qevent.
> > > Otherwise "Traps ... instead of being dropped" is too much of a
> > > thought-shortcut, marked packets are not dropped.
> > > 
> > > (I'd also think that trap is better documented next to early_drop,
> > > let's look at it from the reader's perspective)  
> > 
> > How about:
> > 
> > "Traps a copy of ECN-capable packets that were marked with CE
> 
> I think "Traps copies" or "Traps the copy of .. packet"?
> I'm not a native speaker but there seems to be a grammatical mix here.
> 
> > (Congestion Encountered) code point by RED algorithm instead of being
> > dropped. The trap is enabled by attaching a filter with action 'trap' to
> 
> ... instead of those copies being dropped.

Will reword

> 
> > the 'mark' qevent of the RED qdisc."
> >
> > In addition, this output:
> > 
> > $ devlink trap show pci/0000:06:00.0 trap ecn_mark 
> > pci/0000:06:00.0:
> >   name ecn_mark type drop generic true action trap group buffer_drops
> > 
> > Can be converted to:
> > 
> > $ devlink trap show pci/0000:06:00.0 trap ecn_mark 
> > pci/0000:06:00.0:
> >   name ecn_mark type drop generic true action mirror group buffer_drops
> > 
> > "mirror: The packet is forwarded by the underlying device and a copy is sent to
> > the CPU."
> > 
> > In this case the action is static and you cannot change it.
> 
> Oh yes, that's nice, I thought mirror in traps means mirror to another
> port. Are there already traps which implement the mirroring / trapping
> a clone? Quick grep yields nothing of substance.

Yes. That's why we have the 'offload_fwd_mark' and 'offload_l3_fwd_mark'
bits in the skb. For example, we let the hardware flood ARP requests
('arp_request'), but also send a copy to the CPU in case it needs to
update its neighbour table. The trapping happens at L2, so we only set
the 'offload_fwd_mark' bit. It will tell the bridge driver to not flood
the packet again.

The 'offload_l3_fwd_mark' bit is mainly used to support one-armed router
use cases where a packet is forwarded through the same interface through
which it was received ('uc_loopback'). We do the forwarding in hardware,
but also send a copy to the CPU to give the kernel the chance to
generate an ICMP redirect if it was not disabled by the user. See more
info in commit 55827458e058 ("Merge branch
'mlxsw-Add-one-armed-router-support'").

I also want to explain how the qevent stuff works in hardware to make
sure it is all clear. We have the ability to bind different triggers to
a mirroring (SPAN) agent. The agent can point to a physical port /
virtual interface (e.g., gretap for ERSPAN) or to the CPU port. The
first is programmed via the mirred action and the second using the trap
action.

The triggers can be simple such as Rx/Tx packet (matchall + mirred) or
policy engine (flower + mirred). The more advanced triggers are various
buffer events such as early drops ('early_drop' qevent) and ECN marking
('mark' qevent). Currently, it is only possible to bind these triggers
to a mirroring agent which is why we only support (in mlxsw) attaching
matchall filters to these qevents. In the future we might be able to
bind ACLs to these triggers in which case we will allow attaching flower
filters. devlink-trap is really only a read-only interface in this case,
meant to tell you why you go the packet from the hardware datapath. The
enablement / disablement is done by tc which gives us feature parity
with the software datapath.
