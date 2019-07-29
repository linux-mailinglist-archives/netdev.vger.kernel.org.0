Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9C0F87937D
	for <lists+netdev@lfdr.de>; Mon, 29 Jul 2019 21:00:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728458AbfG2TAc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jul 2019 15:00:32 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:47659 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727089AbfG2TAc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Jul 2019 15:00:32 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 0523C223A8;
        Mon, 29 Jul 2019 15:00:31 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Mon, 29 Jul 2019 15:00:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=zoiT+g
        nmstlHX62hYSN+tWp+MTF5CXw+1yLDRuatK1E=; b=qAMJxphOiQsAzo6c3GIY+7
        oadjOGqBiV902wdjVugJH6zv7YIWIuOesntbkgetd3TOT//vG2/vbfLAdrjwx5D6
        V3DCylgdDwpWbdj00Mq/B7mMtSb4yMUv3mo5Q6ThzKcv4nsWZsdffv2j0aC+z+Ci
        FDq+l4x+YBrFgJroPQHe2QEG5YgtE7jfeTkbZMX3Q0zCIAeUv011n5ZIYVm55hu9
        SIG3OoKCY8yutGG6DKON6fLdP1kFIq/3yiPgiH3epEYubpNPCKC1z9KdOP14Wg1L
        JylPmo4ueYL2JsVNEe8am+ETh8CONH7GxmIyAyF5ofRuYjK/Qym4pZ7DKdgSPrmA
        ==
X-ME-Sender: <xms:TkI_XVTkyLeWpv05TL-ctJITiB_gb4ZMuaMD0oZjoUqvnFuXDy4kpg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddrledugddufeefucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjfgesthdtredttdervdenucfhrhhomhepkfguohcu
    ufgthhhimhhmvghluceoihguohhstghhsehiughoshgthhdrohhrgheqnecukfhppeejje
    drudefkedrvdegledrvddtleenucfrrghrrghmpehmrghilhhfrhhomhepihguohhstghh
    sehiughoshgthhdrohhrghenucevlhhushhtvghrufhiiigvpedt
X-ME-Proxy: <xmx:TkI_XTWRUSDNmDpIaYsUhA7SU1JqBsWgqiGuglRqftryWnrA2hmxPA>
    <xmx:TkI_XWti81Sa0AnbxKW0b6rqBe-FtbPEZ_kdaCc9kfekBUALJhaeaA>
    <xmx:TkI_XZs5JTIKNfGxWT4TUPyJ3zVVHz-42Qfqr79S7ACK5-zLEtsDmA>
    <xmx:TkI_XRT72YBPBroNIap-5w00ykLoswEy5MJF7DMr8SVsRgDOBCMLbA>
Received: from localhost (unknown [77.138.249.209])
        by mail.messagingengine.com (Postfix) with ESMTPA id A5AB7380088;
        Mon, 29 Jul 2019 15:00:29 -0400 (EDT)
Date:   Mon, 29 Jul 2019 22:00:15 +0300
From:   Ido Schimmel <idosch@idosch.org>
To:     Petr Machata <petrm@mellanox.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jiri Pirko <jiri@mellanox.com>,
        Ido Schimmel <idosch@mellanox.com>,
        "davem@davemloft.net" <davem@davemloft.net>
Subject: Re: [PATCH net v2] mlxsw: spectrum_ptp: Increase parsing depth when
 PTP is enabled
Message-ID: <20190729190015.GA31413@splinter>
References: <b1584bdec4a0a36a2567a43dc0973dd8f3a05dec.1564424420.git.petrm@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b1584bdec4a0a36a2567a43dc0973dd8f3a05dec.1564424420.git.petrm@mellanox.com>
User-Agent: Mutt/1.12.0 (2019-05-25)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 29, 2019 at 06:26:14PM +0000, Petr Machata wrote:
> Spectrum systems have a configurable limit on how far into the packet they
> parse. By default, the limit is 96 bytes.
> 
> An IPv6 PTP packet is layered as Ethernet/IPv6/UDP (14+40+8 bytes), and
> sequence ID of a PTP event is only available 32 bytes into payload, for a
> total of 94 bytes. When an additional 802.1q header is present as
> well (such as when ptp4l is running on a VLAN port), the parsing limit is
> exceeded. Such packets are not recognized as PTP, and are not timestamped.
> 
> Therefore generalize the current VXLAN-specific parsing depth setting to
> allow reference-counted requests from other modules as well. Keep it in the
> VXLAN module, because the MPRS register also configures UDP destination
> port number used for VXLAN, and is thus closely tied to the VXLAN code
> anyway.
> 
> Then invoke the new interfaces from both VXLAN (in obvious places), as well
> as from PTP code, when the (global) timestamping configuration changes from
> disabled to enabled or vice versa.
> 
> Fixes: 8748642751ed ("mlxsw: spectrum: PTP: Support SIOCGHWTSTAMP, SIOCSHWTSTAMP ioctls")
> Signed-off-by: Petr Machata <petrm@mellanox.com>

Reviewed-by: Ido Schimmel <idosch@mellanox.com>
