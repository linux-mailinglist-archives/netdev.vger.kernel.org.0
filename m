Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A2C762F4D15
	for <lists+netdev@lfdr.de>; Wed, 13 Jan 2021 15:28:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726426AbhAMO1p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jan 2021 09:27:45 -0500
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:44423 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725846AbhAMO1p (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Jan 2021 09:27:45 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 097395C00CD;
        Wed, 13 Jan 2021 09:26:59 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Wed, 13 Jan 2021 09:26:59 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=5JAOk6
        Rrr2F+fIpSBAGp1qhhtXegvg0cgx2BXmFESQc=; b=ZxyXu4kk+cSlPn/PhmDYrs
        iCOetewyLy0ElngQQDrle9w+cxHsSo743cVNiva5ybyVZhXVXqltP6EdWsNvU/LB
        F9HxhaXgqyW9ftp52zqeuvhOJNEoKt3TNttq9EDrab4rZtqEV7MmswDgat14nDIC
        eZuOdNe5XTAurgDc4PQVE3mWVPUoM5XFayY69knWUCMKuSqufQwxco8jp6+zacEr
        rOrqMiwmDvgLD0v9Eaba7W6AS3/YoEkIQuGVBwrrNjLGFWsLnxS6T3eCz/++QhyU
        ChotyIn5IHsFjFLEnjSDh1owKHLHu53qGjbHJ85SvjRng8Sus8Ot8edakygyZOLA
        ==
X-ME-Sender: <xms:MgP_X8Oqis-X4O5_hX_M-Xur7EBeTf8h47xf028YPYwVPd78XlHmHw>
    <xme:MgP_Xy8DMMERfy5HuDLLfnCjXWpVJmQPSmz-sy0vxm6w-3kgTp1QEGiO1dgb7TNGz
    2w2WHUdcp5BfPM>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedukedrtdefgdeigecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepkfguohcuufgt
    hhhimhhmvghluceoihguohhstghhsehiughoshgthhdrohhrgheqnecuggftrfgrthhtvg
    hrnhepgfevgfevueduueffieffheeifffgjeelvedtteeuteeuffekvefggfdtudfgkeev
    necuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphepkeegrddvvdelrdduheefrd
    eggeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehi
    ughoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:MgP_XzTtAQ3RjFTVqkFUmKW1KRyfrsXQxhfVtKI9E5c043ndPQVZGQ>
    <xmx:MgP_X0sjwk3Prh6QYVzUEm0qkewoFRL2DRAblZZT9lYOZ1ZBkY8u_Q>
    <xmx:MgP_X0ctxlaGyiXBbGOam-V6JON9bRhkJ_Z8Ktnlyt3zFfDIlEdNPw>
    <xmx:MwP_Xz4Weyn_u8w5KtBBdx_w3cwS5vEWYw0mckJd8wMEajPEuUDykQ>
Received: from localhost (igld-84-229-153-44.inter.net.il [84.229.153.44])
        by mail.messagingengine.com (Postfix) with ESMTPA id 57B8324005B;
        Wed, 13 Jan 2021 09:26:58 -0500 (EST)
Date:   Wed, 13 Jan 2021 16:26:56 +0200
From:   Ido Schimmel <idosch@idosch.org>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        davem@davemloft.net, jiri@nvidia.com, danieller@nvidia.com,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: Re: [PATCH net-next 1/2] mlxsw: Register physical ports as a devlink
 resource
Message-ID: <20210113142656.GA1853106@shredder.lan>
References: <20210112083931.1662874-1-idosch@idosch.org>
 <20210112083931.1662874-2-idosch@idosch.org>
 <20210112202122.5751bc9f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20210113083241.GA1757975@shredder.lan>
 <20210113133902.GH3565223@nanopsycho.orion>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210113133902.GH3565223@nanopsycho.orion>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 13, 2021 at 02:39:02PM +0100, Jiri Pirko wrote:
> Wed, Jan 13, 2021 at 09:32:41AM CET, idosch@idosch.org wrote:
> >On Tue, Jan 12, 2021 at 08:21:22PM -0800, Jakub Kicinski wrote:
> >> On Tue, 12 Jan 2021 10:39:30 +0200 Ido Schimmel wrote:
> >> > From: Danielle Ratson <danieller@nvidia.com>
> >> > 
> >> > The switch ASIC has a limited capacity of physical ('flavour physical'
> >> > in devlink terminology) ports that it can support. While each system is
> >> > brought up with a different number of ports, this number can be
> >> > increased via splitting up to the ASIC's limit.
> >> > 
> >> > Expose physical ports as a devlink resource so that user space will have
> >> > visibility to the maximum number of ports that can be supported and the
> >> > current occupancy.
> >> 
> >> Any thoughts on making this a "generic" resource?
> >
> >It might be possible to allow drivers to pass the maximum number of
> >physical ports to devlink during their initialization. Devlink can then
> >use it as an indication to register the resource itself instead of the
> >driver. It can report the current occupancy without driver intervention
> >since the list of ports is maintained in devlink.
> >
> >There might be an issue with the resource identifier which is a 64-bit
> >number passed from drivers. I think we can partition this to identifiers
> >allocated by devlink / drivers.
> >
> >Danielle / Jiri?
> 
> There is no concept of "generic resource". And I think it is a good
> reason for it, as the resource is something which is always quite
> hw-specific. Port number migth be one exception. Can you think of
> anything else? If not, I would vote for not having "generic resource"
> just for this one case.

I think Jakub's point is that he does not want drivers to expose the
same resource to user space under different names. Question is how to
try to guarantee it. One option is what I suggested above, but it might
be an overkill. Another option is better documentation. To add a section
of "generic" resources in devlink-resource documentation [1] and modify
the kernel-doc comment above devlink_resource_register() to point to it.

[1] https://www.kernel.org/doc/html/latest/networking/devlink/devlink-resource.html
