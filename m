Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3BF182AC015
	for <lists+netdev@lfdr.de>; Mon,  9 Nov 2020 16:41:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729828AbgKIPlJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Nov 2020 10:41:09 -0500
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:55231 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729174AbgKIPlJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Nov 2020 10:41:09 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 074305C034E;
        Mon,  9 Nov 2020 10:41:09 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Mon, 09 Nov 2020 10:41:09 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=4kYHgZ
        mpuPptJt9frDZ8XYC4i0SEJN+alhb0hZaVpvo=; b=fTuT7KhBxeI1t1sxHNURxm
        /R0A5UzYvlhRfQ8BJyayTfGCgBefkQ1iAH+VoP0QMw8IF6owwNdm/qhY0IsIKWG3
        u+pA1p7vEzb14vox9I49/4tx5vgqY7ROC7tojD/y0v3HS4VEqtzkA+6nEE2G+6M5
        aFIs6JUrZipgeELBU3DR9PNelvxAP3H+MJVbvDhQfiBoEx3K5UqT66t8ccpyWTLV
        Lgrr5OFyYz/kwrEN+duyb3qcZ92X+BjTRd1liang/qThdXXAQ5YkA3IjCoUfLO+s
        Pv/1Muo1t/bvYwHzd1z4MbENfpJ72Fw9RtFU5JG+TkE0HKky1grrFxtpYGwKd8tg
        ==
X-ME-Sender: <xms:FGOpX4fL65RQcZeoaX5_J3kFysHMG4MYgQ5y80a0OIhCw29B5V5JYA>
    <xme:FGOpX6MOqzvIk58jTlS8Vq9gCFBaEKVHRqaRx7dfPt3C5Pt3m5Rolzsbn6Dh2j_dR
    jTSGhQCkzme7QU>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrudduhedgkedtucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpeffhffvuffkfhggtggujgesthdtre
    dttddtvdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnheptdffkeekfeduffevgeeujeffjefhte
    fgueeugfevtdeiheduueeukefhudehleetnecukfhppeekgedrvddvledrudehvddrvdeh
    heenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiug
    hoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:FGOpX5gFoObFBu7wM6XrKvQi6evU1TitP0cLj6ztJUJXU0xSAhWYIg>
    <xmx:FGOpX99dLDRqSlrIpqYDFrjLRtsLORHPJ43mhIQPxqlSI8ZOwAceKw>
    <xmx:FGOpX0sWEjtYQDABKZCajvi8_Nwl6F3s51VrcE4Hgm4dkh63eevjMw>
    <xmx:FWOpXwLJrjkTM_F0COK-7InLT-YSp6YQtKnGyfwvisdF1Tv04RkmBg>
Received: from localhost (unknown [84.229.152.255])
        by mail.messagingengine.com (Postfix) with ESMTPA id 04EBD3063083;
        Mon,  9 Nov 2020 10:41:07 -0500 (EST)
Date:   Mon, 9 Nov 2020 17:41:05 +0200
From:   Ido Schimmel <idosch@idosch.org>
To:     Jakub Kicinski <kuba@kernel.org>, dsahern@gmail.com
Cc:     netdev@vger.kernel.org, davem@davemloft.net, jiri@nvidia.com,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: Re: [PATCH net-next 00/18] nexthop: Add support for nexthop objects
 offload
Message-ID: <20201109154105.GB1796533@shredder>
References: <20201104133040.1125369-1-idosch@idosch.org>
 <20201106113159.6c324275@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201106113159.6c324275@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 06, 2020 at 11:31:59AM -0800, Jakub Kicinski wrote:
> On Wed,  4 Nov 2020 15:30:22 +0200 Ido Schimmel wrote:
> > From: Ido Schimmel <idosch@nvidia.com>
> > 
> > This patch set adds support for nexthop objects offload with a dummy
> > implementation over netdevsim. mlxsw support will be added later.
> > 
> > The general idea is very similar to route offload in that notifications
> > are sent whenever nexthop objects are changed. A listener can veto the
> > change and the error will be communicated to user space with extack.
> > 
> > To keep listeners as simple as possible, they not only receive
> > notifications for the nexthop object that is changed, but also for all
> > the other objects affected by this change. For example, when a single
> > nexthop is replaced, a replace notification is sent for the single
> > nexthop, but also for all the nexthop groups this nexthop is member in.
> > This relieves listeners from the need to track such dependencies.
> > 
> > To simplify things further for listeners, the notification info does not
> > contain the raw nexthop data structures (e.g., 'struct nexthop'), but
> > less complex data structures into which the raw data structures are
> > parsed into.
> 
> Applied, thank you!

Great, thank you. And thanks David for the awesome work on the nexthop
infrastructure.

> 
> BTW no need to follow up on my else-after-return comment, 
> just something to keep in mind.

Ack
