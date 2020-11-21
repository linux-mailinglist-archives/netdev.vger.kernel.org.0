Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EDF242BC06D
	for <lists+netdev@lfdr.de>; Sat, 21 Nov 2020 17:10:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726370AbgKUQJs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 21 Nov 2020 11:09:48 -0500
Received: from wnew2-smtp.messagingengine.com ([64.147.123.27]:39585 "EHLO
        wnew2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725914AbgKUQJr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 21 Nov 2020 11:09:47 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailnew.west.internal (Postfix) with ESMTP id 8B045D73;
        Sat, 21 Nov 2020 11:09:45 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Sat, 21 Nov 2020 11:09:46 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=huz5Dh
        VGIoT2g9v8/zblY/2WU9UNWjC3Gk6t7/f3xxM=; b=HjcgaItDtOjMydkE2UkT2C
        n+C8mjKYwU5H6Q66922FFvagUGKlwx/VjvjEx3+r4/1eFOq4Co6G7c08txulgj/l
        ZlAlGf7VCt3KxpUDRBj8nOhkax3mS2LIQ/kZ1IxRan0JBuppGlyV4NtFbL/DGa7Z
        TbC/QXFofb6xPc5+4+vBkLjp17wCdCMSzk7LX7rAD5q+naUn1n2+kNVKiOHIEyXU
        7rpM6b0jJnd9aK3k/tlsEJsWqIXOe78T6JMfhQXpLH8nJFjOuf1yOSuOBxdN16cC
        c+KNMx8ya3hmZlUsGSz4N6bmDFI1t/N0jAdp8mx4/4GnuqDwB+wEReCoChMoFcmA
        ==
X-ME-Sender: <xms:yDu5X1vJwh_3X-0DsgHfoLAVuftGWgi7VrHVsKWk4pkMifeKHOUwTg>
    <xme:yDu5X-eZsViXxoNP5Jli79mL_eBihqXI5cR1UQNkv82vO-65XO_F3SUKgt8AfcA2o
    0nzI0Pv63o5_qs>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrudegvddgkeehucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefkughoucfu
    tghhihhmmhgvlhcuoehiughoshgthhesihguohhstghhrdhorhhgqeenucggtffrrghtth
    gvrhhnpedtffekkeefudffveegueejffejhfetgfeuuefgvedtieehudeuueekhfduheel
    teenucfkphepkeegrddvvdelrdduheegrddugeejnecuvehluhhsthgvrhfuihiivgeptd
    enucfrrghrrghmpehmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:yDu5X4xpOH7hEl0hO32HiyS6UB6te8zF5fqs4NIB9SWKIts2_Mb7NQ>
    <xmx:yDu5X8MkzGZTjZPlhXVR6WFmr8VfdaPS1YwL_qqCzGUo2b4pRRG4Ng>
    <xmx:yDu5X1-d-mcsQVrkV-zeiwNK4u0B4A19243zdEJP7Y-DrzDzYVe5UA>
    <xmx:yTu5X8WFGlRmAxbfkQUq03Lt-CbrUr0j4eDSm7cFMLv0J4JQHJYJQouZBiQ>
Received: from localhost (igld-84-229-154-147.inter.net.il [84.229.154.147])
        by mail.messagingengine.com (Postfix) with ESMTPA id 2F31F3064AAE;
        Sat, 21 Nov 2020 11:09:44 -0500 (EST)
Date:   Sat, 21 Nov 2020 18:09:41 +0200
From:   Ido Schimmel <idosch@idosch.org>
To:     Aleksandr Nogikh <aleksandrnogikh@gmail.com>, fw@strlen.de
Cc:     davem@davemloft.net, kuba@kernel.org, johannes@sipsolutions.net,
        edumazet@google.com, andreyknvl@google.com, dvyukov@google.com,
        elver@google.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
        willemdebruijn.kernel@gmail.com,
        Aleksandr Nogikh <nogikh@google.com>,
        Willem de Bruijn <willemb@google.com>
Subject: Re: [PATCH v5 2/3] net: add kcov handle to skb extensions
Message-ID: <20201121160941.GA485907@shredder.lan>
References: <20201029173620.2121359-1-aleksandrnogikh@gmail.com>
 <20201029173620.2121359-3-aleksandrnogikh@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201029173620.2121359-3-aleksandrnogikh@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

+ Florian

On Thu, Oct 29, 2020 at 05:36:19PM +0000, Aleksandr Nogikh wrote:
> From: Aleksandr Nogikh <nogikh@google.com>
> 
> Remote KCOV coverage collection enables coverage-guided fuzzing of the
> code that is not reachable during normal system call execution. It is
> especially helpful for fuzzing networking subsystems, where it is
> common to perform packet handling in separate work queues even for the
> packets that originated directly from the user space.
> 
> Enable coverage-guided frame injection by adding kcov remote handle to
> skb extensions. Default initialization in __alloc_skb and
> __build_skb_around ensures that no socket buffer that was generated
> during a system call will be missed.
> 
> Code that is of interest and that performs packet processing should be
> annotated with kcov_remote_start()/kcov_remote_stop().
> 
> An alternative approach is to determine kcov_handle solely on the
> basis of the device/interface that received the specific socket
> buffer. However, in this case it would be impossible to distinguish
> between packets that originated during normal background network
> processes or were intentionally injected from the user space.
> 
> Signed-off-by: Aleksandr Nogikh <nogikh@google.com>
> Acked-by: Willem de Bruijn <willemb@google.com>

[...]

> @@ -249,6 +249,9 @@ struct sk_buff *__alloc_skb(unsigned int size, gfp_t gfp_mask,
>  
>  		fclones->skb2.fclone = SKB_FCLONE_CLONE;
>  	}
> +
> +	skb_set_kcov_handle(skb, kcov_common_handle());

Hi,

This causes skb extensions to be allocated for the allocated skb, but
there are instances that blindly overwrite 'skb->extensions' by invoking
skb_copy_header() after __alloc_skb(). For example, skb_copy(),
__pskb_copy_fclone() and skb_copy_expand(). This results in the skb
extensions being leaked [1].

One possible solution is to try to patch all these instances with
skb_ext_put() before skb_copy_header().

Another possible solution is to convert skb_copy_header() to use
skb_ext_copy() instead of __skb_ext_copy(). It will first drop the
reference on the skb extensions of the new skb, but it assumes that
'skb->active_extensions' is valid. This is not the case in the
skb_clone() path so we should probably zero this field in __skb_clone().

Other suggestions?

Thanks

[1]
BUG: memory leak
unreferenced object 0xffff888027f9a490 (size 16):
  comm "syz-executor.0", pid 1155, jiffies 4295996826 (age 66.927s)
  hex dump (first 16 bytes):
    01 00 00 00 01 02 6b 6b 01 00 00 00 00 00 00 00  ......kk........
  backtrace:
    [<0000000005a5f2c4>] kmemleak_alloc_recursive include/linux/kmemleak.h:43 [inline]
    [<0000000005a5f2c4>] slab_post_alloc_hook mm/slab.h:528 [inline]
    [<0000000005a5f2c4>] slab_alloc_node mm/slub.c:2891 [inline]
    [<0000000005a5f2c4>] slab_alloc mm/slub.c:2899 [inline]
    [<0000000005a5f2c4>] kmem_cache_alloc+0x173/0x800 mm/slub.c:2904
    [<00000000c5e43ea9>] __skb_ext_alloc+0x22/0x90 net/core/skbuff.c:6173
    [<000000000de35e81>] skb_ext_add+0x230/0x4a0 net/core/skbuff.c:6268
    [<000000003b7efba4>] skb_set_kcov_handle include/linux/skbuff.h:4622 [inline]
    [<000000003b7efba4>] skb_set_kcov_handle include/linux/skbuff.h:4612 [inline]
    [<000000003b7efba4>] __alloc_skb+0x47f/0x6a0 net/core/skbuff.c:253
    [<000000007f789b23>] skb_copy+0x151/0x310 net/core/skbuff.c:1512
    [<000000001ce26864>] mlxsw_emad_transmit+0x4e/0x620 drivers/net/ethernet/mellanox/mlxsw/core.c:585
    [<000000005c732123>] mlxsw_emad_reg_access drivers/net/ethernet/mellanox/mlxsw/core.c:829 [inline]
    [<000000005c732123>] mlxsw_core_reg_access_emad+0xda8/0x1770 drivers/net/ethernet/mellanox/mlxsw/core.c:2408
    [<00000000c07840b3>] mlxsw_core_reg_access+0x101/0x7f0 drivers/net/ethernet/mellanox/mlxsw/core.c:2583
    [<000000007c47f30f>] mlxsw_reg_write+0x30/0x40 drivers/net/ethernet/mellanox/mlxsw/core.c:2603
    [<00000000675e3fc7>] mlxsw_sp_port_admin_status_set+0x8a7/0x980 drivers/net/ethernet/mellanox/mlxsw/spectrum.c:300
    [<00000000fefe35a4>] mlxsw_sp_port_stop+0x63/0x70 drivers/net/ethernet/mellanox/mlxsw/spectrum.c:537
    [<00000000c41390e8>] __dev_close_many+0x1c7/0x300 net/core/dev.c:1607
    [<00000000628c5987>] __dev_close net/core/dev.c:1619 [inline]
    [<00000000628c5987>] __dev_change_flags+0x2b9/0x710 net/core/dev.c:8421
    [<000000008cc810c6>] dev_change_flags+0x97/0x170 net/core/dev.c:8494
    [<0000000053274a78>] do_setlink+0xa5b/0x3b80 net/core/rtnetlink.c:2706
    [<00000000e4085785>] rtnl_group_changelink net/core/rtnetlink.c:3225 [inline]
    [<00000000e4085785>] __rtnl_newlink+0xe06/0x17d0 net/core/rtnetlink.c:3379
