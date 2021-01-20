Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3ACF82FCDB0
	for <lists+netdev@lfdr.de>; Wed, 20 Jan 2021 10:59:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729814AbhATJXd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jan 2021 04:23:33 -0500
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:53515 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730495AbhATJPx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Jan 2021 04:15:53 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 737185C00D0;
        Wed, 20 Jan 2021 04:14:41 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Wed, 20 Jan 2021 04:14:41 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=uIH4wy
        PjOm/CaxTAI6CY9qlQfNYFT5GrpNvNSdqxucg=; b=rCkBb2f1by+mKc+iUbf1aM
        wnqSCWWDvox9c4tzj5JOX8RPOWHSjv6wUDOmH9YQ+5zzjRhlOlhcc+Aba+Zer+VU
        SEjoOTz8j0RLPPZ97O/AXk4v8ah+xL1OAS09WppfTb1U4KnyGo+ApwnxR3YFyNMv
        Fsiks77x8uadUy+XkZTw6iBfeouu4A6KSQDJ/c9sBq9hlTl77Gxyvbz31aTy1V9t
        kkWoxcWhw/iQeGrZqjMMiSikVZbK2MZeuDEA6B361v0U2CnS9VYZSuCT6bZmU75X
        AI2cA4R0febEXH0rRKhmorq1suakIcOwOyAwZZxO6OtzHmQFoCtN3a7NBDbDtbYQ
        ==
X-ME-Sender: <xms:gfQHYEb4M1ommoy5hbuhBYNeHWR9K-wAW_eRXXTO9jEmcQc3kkyMwA>
    <xme:gfQHYPa1rfU3f70ZkF_hdKONM3vVOxZFiUgt3mdt11oxstc3hl66VJxld-2yX4l3S
    S3KrgRJHva9sk4>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledruddvgddtfecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepfffhvffukfhfgggtuggjsehttdertd
    dttddvnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihguohhs
    tghhrdhorhhgqeenucggtffrrghtthgvrhhnpedtffekkeefudffveegueejffejhfetgf
    euuefgvedtieehudeuueekhfduheelteenucfkphepkeegrddvvdelrdduheefrdeggeen
    ucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiughosh
    gthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:gfQHYO_Vmbae7raGZCWULueByw0zqYXK_agMz3IcqgTv721yCtsm1Q>
    <xmx:gfQHYOo87LRRXD2djZpK7sFoE0GS5_YvlYYdjv0GjI50Uh7stX4IUw>
    <xmx:gfQHYPrvS5dqFdYK04Zytywz4uDOfTOQpp5S9I3Z_RtI1ej2t4k09w>
    <xmx:gfQHYAmSjt1-h3NwvhFVh43vxWXf_gwdoSDNGpTXrDlG964kbg6v_A>
Received: from localhost (igld-84-229-153-44.inter.net.il [84.229.153.44])
        by mail.messagingengine.com (Postfix) with ESMTPA id BACD0108005B;
        Wed, 20 Jan 2021 04:14:40 -0500 (EST)
Date:   Wed, 20 Jan 2021 11:14:37 +0200
From:   Ido Schimmel <idosch@idosch.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, petrm@nvidia.com,
        jiri@nvidia.com, amcohen@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: Re: [PATCH net-next 0/5] mlxsw: Add support for RED qevent "mark"
Message-ID: <20210120091437.GA2591869@shredder.lan>
References: <20210117080223.2107288-1-idosch@idosch.org>
 <20210119142255.1caca7fb@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210119142255.1caca7fb@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 19, 2021 at 02:22:55PM -0800, Jakub Kicinski wrote:
> On Sun, 17 Jan 2021 10:02:18 +0200 Ido Schimmel wrote:
> > From: Ido Schimmel <idosch@nvidia.com>
> > 
> > The RED qdisc currently supports two qevents: "early_drop" and "mark". The
> > filters added to the block bound to the "early_drop" qevent are executed on
> > packets for which the RED algorithm decides that they should be
> > early-dropped. The "mark" filters are similarly executed on ECT packets
> > that are marked as ECN-CE (Congestion Encountered).
> > 
> > A previous patchset has offloaded "early_drop" filters on Spectrum-2 and
> > later, provided that the classifier used is "matchall", that the action
> > used is either "trap" or "mirred", and a handful or further limitations.
> 
> For early_drop trap or mirred makes obvious sense, no explanation
> needed.
> 
> But for marked as a user I'd like to see a _copy_ of the packet, 
> while the original continues on its marry way to the destination.
> I'd venture to say that e.g. for a DCTCP deployment mark+trap is
> unusable, at least for tracing, because it distorts the operation 
> by effectively dropping instead of marking.
> 
> Am I reading this right?

You get a copy of the packet as otherwise it will create a lot of
problems (like you wrote).

> 
> If that is the case and you really want to keep the mark+trap
> functionality - I feel like at least better documentation is needed.
> The current two liner should also be rewritten, quoting from patch 1:
> 
> > * - ``ecn_mark``
> >   - ``drop``
> >   - Traps ECN-capable packets that were marked with CE (Congestion
> >     Encountered) code point by RED algorithm instead of being dropped
> 
> That needs to say that the trap is for datagrams trapped by a qevent.
> Otherwise "Traps ... instead of being dropped" is too much of a
> thought-shortcut, marked packets are not dropped.
> 
> (I'd also think that trap is better documented next to early_drop,
> let's look at it from the reader's perspective)

How about:

"Traps a copy of ECN-capable packets that were marked with CE
(Congestion Encountered) code point by RED algorithm instead of being
dropped. The trap is enabled by attaching a filter with action 'trap' to
the 'mark' qevent of the RED qdisc."

In addition, this output:

$ devlink trap show pci/0000:06:00.0 trap ecn_mark 
pci/0000:06:00.0:
  name ecn_mark type drop generic true action trap group buffer_drops

Can be converted to:

$ devlink trap show pci/0000:06:00.0 trap ecn_mark 
pci/0000:06:00.0:
  name ecn_mark type drop generic true action mirror group buffer_drops

"mirror: The packet is forwarded by the underlying device and a copy is sent to
the CPU."

In this case the action is static and you cannot change it.
