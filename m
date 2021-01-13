Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D12A2F4698
	for <lists+netdev@lfdr.de>; Wed, 13 Jan 2021 09:36:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725899AbhAMIdb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jan 2021 03:33:31 -0500
Received: from wout3-smtp.messagingengine.com ([64.147.123.19]:56591 "EHLO
        wout3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725372AbhAMIdb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Jan 2021 03:33:31 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.west.internal (Postfix) with ESMTP id 5D7C61770;
        Wed, 13 Jan 2021 03:32:45 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Wed, 13 Jan 2021 03:32:45 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=xpcbTS
        oS9mPxSXOLA+daZb+doaFZLVm+Kq8HRF2ZLCM=; b=eWKdmqEEMa+bfUrQvjrQ1J
        ySnl6EslWRLKl43dkTUC1vANegS+MRwur9aXAd3FzXNZNMh02+p5LDnFZ7sXYHrw
        /gFAGGkA1pYHh9UCVTuyExXYCcSexjVrTSQDCEW3pbNfeEigD0uHXs+7Cda2bWwA
        wRKvhfaguzsqiBT+0b3mhT/eG8oZfthdCjAjHAn6SV8Wt+G58+tX0PNLXK09WXTn
        zaW/Dx/8dCxSQHm5mQaThncmR8GpkC6UKZIENOaBSoHyZLEau61iFvS2QwUac1+B
        NMvRz6YonTXupbKarOjXIrCcNK0rq6wK4CJPS6fJuWm9iKIEqlnwueIkuDu86GYQ
        ==
X-ME-Sender: <xms:LLD-X-biFpQ_tgoBTEpVt7GUgRRESuiP5PJ33nmNSCYIcXA0arPEpw>
    <xme:LLD-XxZcl4XHHHK6Vas2Y8shQJ5lk7hJEzsHdnpC9lVNuYNzwYl2CukPjJYgsgZKs
    qVyGf9hrezScDo>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedukedrtddugdduvddvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpeffhffvuffkfhggtggujgesthdtre
    dttddtvdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnheptdffkeekfeduffevgeeujeffjefhte
    fgueeugfevtdeiheduueeukefhudehleetnecukfhppeekgedrvddvledrudehfedrgeeg
    necuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepihguoh
    hstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:LLD-X49R1s19VVnmg8XsnQ0uEfRKeoN1xI1dISk8fqCcqVIuyL8Okw>
    <xmx:LLD-XwqgPqhnUp9N5tkF5q9uEPKbFV0fFKIMJvtRiCFZOCAgoM3E6w>
    <xmx:LLD-X5rk7ldPjA0vdD2dk15-prRNxfnE2EdXG_PPMYsdoVUeZNbmaw>
    <xmx:LLD-XwUM_3dqJwFbemMSHZV57iZGISYq-hUFO2l2XXZ2AlcEbdK4Kg>
Received: from localhost (igld-84-229-153-44.inter.net.il [84.229.153.44])
        by mail.messagingengine.com (Postfix) with ESMTPA id 4749A240066;
        Wed, 13 Jan 2021 03:32:44 -0500 (EST)
Date:   Wed, 13 Jan 2021 10:32:41 +0200
From:   Ido Schimmel <idosch@idosch.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, jiri@nvidia.com,
        danieller@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: Re: [PATCH net-next 1/2] mlxsw: Register physical ports as a devlink
 resource
Message-ID: <20210113083241.GA1757975@shredder.lan>
References: <20210112083931.1662874-1-idosch@idosch.org>
 <20210112083931.1662874-2-idosch@idosch.org>
 <20210112202122.5751bc9f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210112202122.5751bc9f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 12, 2021 at 08:21:22PM -0800, Jakub Kicinski wrote:
> On Tue, 12 Jan 2021 10:39:30 +0200 Ido Schimmel wrote:
> > From: Danielle Ratson <danieller@nvidia.com>
> > 
> > The switch ASIC has a limited capacity of physical ('flavour physical'
> > in devlink terminology) ports that it can support. While each system is
> > brought up with a different number of ports, this number can be
> > increased via splitting up to the ASIC's limit.
> > 
> > Expose physical ports as a devlink resource so that user space will have
> > visibility to the maximum number of ports that can be supported and the
> > current occupancy.
> 
> Any thoughts on making this a "generic" resource?

It might be possible to allow drivers to pass the maximum number of
physical ports to devlink during their initialization. Devlink can then
use it as an indication to register the resource itself instead of the
driver. It can report the current occupancy without driver intervention
since the list of ports is maintained in devlink.

There might be an issue with the resource identifier which is a 64-bit
number passed from drivers. I think we can partition this to identifiers
allocated by devlink / drivers.

Danielle / Jiri?
