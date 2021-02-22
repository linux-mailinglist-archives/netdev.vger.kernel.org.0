Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E2D7A32139B
	for <lists+netdev@lfdr.de>; Mon, 22 Feb 2021 11:00:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230063AbhBVJ7M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Feb 2021 04:59:12 -0500
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:46369 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230334AbhBVJ7B (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Feb 2021 04:59:01 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id B3CF65C0045;
        Mon, 22 Feb 2021 04:58:13 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Mon, 22 Feb 2021 04:58:13 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=drKS7R
        CyiLHPJhLL3iSRiYPaWkDIGsBINiMi76uTKs8=; b=dctGY4hE35BtGf5vdTVcxn
        DYYON3WR+kWVeCQxc5NbcN3uyxWC2B1RwlkY6OzGjEZl/Rz1TazU4HeBKQ2iapWb
        Skw3fmn89VIoaNrpihpaG/R2AlVGw0WU4f2goW3CJByo+2lBHyenE1HGOWc3NxGE
        w7he+jHSI9Gp6YqvI7a7rgofMtq9rvf128xoDWQGw8Dr12UTqPNqavS/cN07J2ax
        BwSyacwfVhuHv9q4efgn4aEWsxccB6YQJXx/gnG6w3wBfT1jkDmNxoxSNl08UTyO
        i0aCyjrNWxM8jwjoGXLx7LV3HCLGSwHeSPTDpxS4q7sSylC5vyQ5RKVAteXlcFHg
        ==
X-ME-Sender: <xms:NYAzYFJ1hxKe9UGTqBkGPGXxkmd9o8Nou7YzL8HRsfBdaDD-ZTFj3w>
    <xme:NYAzYBK8oiLIRwVgUZcHBG-OdrqAAzw2-1ajgzwRYjfJ-3jUacnHeKFPN6lABoW1t
    J0pvdnr3h_2nzk>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrkeefgddutdcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepkfguohcuufgt
    hhhimhhmvghluceoihguohhstghhsehiughoshgthhdrohhrgheqnecuggftrfgrthhtvg
    hrnheptdffkeekfeduffevgeeujeffjefhtefgueeugfevtdeiheduueeukefhudehleet
    necukfhppeekgedrvddvledrudehfedrgeegnecuvehluhhsthgvrhfuihiivgeptdenuc
    frrghrrghmpehmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:NYAzYNuXOug7_VKcNEqh_yDbU4i6RrbyNbnXGEOERiJdeU2b-h2C3Q>
    <xmx:NYAzYGbWKLI1yVLp4vmFMHo2Mf9JRFzgWUly0byhZoSXSocSspnC5g>
    <xmx:NYAzYMaxTuLslQ_ikctvJjKF4Mjadss0y-w9qxAplYA_LHntB7E94g>
    <xmx:NYAzYHwIgsZBtBMYyj7Wvj0hZp4KhaZhk7vwGfRELjdP5rJvo8ALRA>
Received: from localhost (igld-84-229-153-44.inter.net.il [84.229.153.44])
        by mail.messagingengine.com (Postfix) with ESMTPA id E496F240068;
        Mon, 22 Feb 2021 04:58:12 -0500 (EST)
Date:   Mon, 22 Feb 2021 11:58:09 +0200
From:   Ido Schimmel <idosch@idosch.org>
To:     Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
Cc:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] netdevsim: fib: remove unneeded semicolon
Message-ID: <YDOAMdp8pWXG+reW@shredder.lan>
References: <1613987224-33151-1-git-send-email-jiapeng.chong@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1613987224-33151-1-git-send-email-jiapeng.chong@linux.alibaba.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 22, 2021 at 05:47:04PM +0800, Jiapeng Chong wrote:
> Fix the following coccicheck warnings:
> 
> ./drivers/net/netdevsim/fib.c:564:2-3: Unneeded semicolon.
> 
> Reported-by: Abaci Robot <abaci@linux.alibaba.com>
> Signed-off-by: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
> ---
>  drivers/net/netdevsim/fib.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/netdevsim/fib.c b/drivers/net/netdevsim/fib.c
> index 46fb414..11b43ce 100644
> --- a/drivers/net/netdevsim/fib.c
> +++ b/drivers/net/netdevsim/fib.c
> @@ -561,7 +561,7 @@ static void nsim_fib6_rt_nh_del(struct nsim_fib6_rt *fib6_rt,
>  err_fib6_rt_nh_del:
>  	for (i--; i >= 0; i--) {
>  		nsim_fib6_rt_nh_del(fib6_rt, rt_arr[i]);
> -	};
> +	}

You can simply remove the braces since they are not needed

>  	nsim_fib_rt_fini(&fib6_rt->common);
>  	kfree(fib6_rt);
>  	return ERR_PTR(err);
> -- 
> 1.8.3.1
> 
