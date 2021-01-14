Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C243B2F5E08
	for <lists+netdev@lfdr.de>; Thu, 14 Jan 2021 10:48:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728065AbhANJsX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jan 2021 04:48:23 -0500
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:53395 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725989AbhANJsV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Jan 2021 04:48:21 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 05FE85C0207;
        Thu, 14 Jan 2021 04:47:24 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Thu, 14 Jan 2021 04:47:24 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=Ve0K+4
        mFsy8VhopXYROFi++Wpwnj6ByqFKDcnhRH7JI=; b=eU7fYhf8YFmshjN2b62qia
        Kv+MWc5xWdxVT64bsCDd5lMOM9mtGMNz0LSyhLwRPTp1+eIebYn4ODXKHIBK4Hog
        GEh1osXaD0aRJfh3JeXanasSen0Lv9UVO0OrWdNh8OBABlfXZ5PCg60SLpZTICJ1
        fspk6fWWJFw+Rqo4MLGB2nTiqdEpHJ/MFQuIXBB2dmhPW8+2v6Ar9IFG40Yc0/y1
        cGKm16oTf4mQxIZ8VIPBCshOHr0ViSBB7VFbtC2JXSTFJDKfb7G+PpdUdKeVFP7P
        UsJfZf/ZAOUfph/DPkIK2j1yfCeJTgB+X7YQe7OI8xe6IRvSbfOAvyFlSJxUbsOA
        ==
X-ME-Sender: <xms:KxMAYICFiEOw5AGUauB5U5qMEVZjV7qIFJm_Vah-kUwl2_6be2O04w>
    <xme:KxMAYKjzB8O3q4ywCq9jKEAGgEcytFT8S6-YFNMVMbXwLykAmshQZ1BVyZVmMCZ0q
    fittZuTcgBpAbU>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedukedrtdehgddthecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepkfguohcuufgt
    hhhimhhmvghluceoihguohhstghhsehiughoshgthhdrohhrgheqnecuggftrfgrthhtvg
    hrnheptdffkeekfeduffevgeeujeffjefhtefgueeugfevtdeiheduueeukefhudehleet
    necukfhppeekgedrvddvledrudehfedrgeegnecuvehluhhsthgvrhfuihiivgeptdenuc
    frrghrrghmpehmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:KxMAYLkGjHXhFDnKfKYnbxEz2zSCzE2GrwzNJ8Q5Z6RH8CQbOxiCsQ>
    <xmx:KxMAYOx-GMCzeo4I6qUgqCrVKCheu721yLrbkPTC8-cjSnMY7PSQug>
    <xmx:KxMAYNTWSbLdDH65Pq8E97Hebsbx5lkvQZH52yt_F9Cm0lrVvyNvpw>
    <xmx:LBMAYLMIvg11riV1WWzBllwU9ZuRXmp86cZLLbwlX6JRiqIHAq0fLw>
Received: from localhost (igld-84-229-153-44.inter.net.il [84.229.153.44])
        by mail.messagingengine.com (Postfix) with ESMTPA id 198181080068;
        Thu, 14 Jan 2021 04:47:21 -0500 (EST)
Date:   Thu, 14 Jan 2021 11:47:07 +0200
From:   Ido Schimmel <idosch@idosch.org>
To:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc:     jiri@nvidia.com, idosch@nvidia.com, davem@davemloft.net,
        kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] mlxsw: pci: switch from 'pci_' to 'dma_' API
Message-ID: <20210114094707.GA1979201@shredder.lan>
References: <20210114084757.490540-1-christophe.jaillet@wanadoo.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210114084757.490540-1-christophe.jaillet@wanadoo.fr>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 14, 2021 at 09:47:57AM +0100, Christophe JAILLET wrote:
> The wrappers in include/linux/pci-dma-compat.h should go away.
> 
> The patch has been generated with the coccinelle script below and has been
> hand modified to replace GFP_ with a correct flag.
> It has been compile tested.
> 
> When memory is allocated in 'mlxsw_pci_queue_init()' and
> 'mlxsw_pci_fw_area_init()' GFP_KERNEL can be used because both functions
> are already using this flag and no lock is acquired.
> 
> When memory is allocated in 'mlxsw_pci_mbox_alloc()' GFP_KERNEL can be used
> because it is only called from the probe function and no lock is acquired
> in the between.
> The call chain is:
>   --> mlxsw_pci_probe()
>     --> mlxsw_pci_cmd_init()
>       --> mlxsw_pci_mbox_alloc()
> 
> While at it, also replace the 'dma_set_mask/dma_set_coherent_mask' sequence
> by a less verbose 'dma_set_mask_and_coherent() call.

[...]

> 
> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

For net-next:

Tested-by: Ido Schimmel <idosch@nvidia.com>

Thanks
