Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 00DFC2CEC53
	for <lists+netdev@lfdr.de>; Fri,  4 Dec 2020 11:39:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729798AbgLDKio (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Dec 2020 05:38:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726733AbgLDKio (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Dec 2020 05:38:44 -0500
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 590B7C0613D1;
        Fri,  4 Dec 2020 02:38:04 -0800 (PST)
Received: by mail-pf1-x441.google.com with SMTP id 131so3402628pfb.9;
        Fri, 04 Dec 2020 02:38:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=GyCGIRBert/rbu3/o+JMuvN8trSWjIB7zDVKIQkL0iI=;
        b=SM/yjHOr8O2YWaBDEExY8hZHp2qE/6dpab0mpbm7h5owujCBWGab2nUoCwn3z6pCYk
         GBRIn3BdosK+8LajIHzDDL1SRYJ3DcUBZfdKw6chj1cBYB1HE1tS74FIcfP7CrjhlJ8o
         Sd4ywuUKuMetKFZpXoy6z6RVJgbC8Wj2EDjcT7wiLQRaRPZI/4OYJWoYTFN1LIxJurRA
         fSRYSRL9Nze6dmgWukBO7bJYTsY8G2CX7RAXlFgpB/oLV87BAIPEkW5TeTDcJv9OprRY
         IqzCXOlxIQyyQTDwt1roam242q5Z/miFDTz6TwxQX5kllkS1N6OQYJ8XWZyZINJ1JNr7
         Abig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=GyCGIRBert/rbu3/o+JMuvN8trSWjIB7zDVKIQkL0iI=;
        b=Ue+48bwvjUCYMEWD+95VnE+HUymvhHrK3NmNwvMywcoPQ84S+/gIWViyV2Ak/VenXm
         NzJzW48uEU7phdd/ZkNML8l0HX9UWev5aF6RBqgY4Lzv97eDKtbuajW3wPKg59u0xwWg
         6UsRAO4rN+79F8aE5qeilWmiogvhklQQt3tnTjgQlcgqBHoVIn6bPywFa5NcReovszzp
         gr3GcMH2hKR/ciFCLE96ChYqrr1eER9LAehCIn96X8ZI6FYyQuwR/2ZmqmO3xhVDkTaL
         eQf71tMibF/Dwon+K9VEdinrnMHfgN8FoMxFD22KrHOhiKJr7JV1Z5b0WgfrMeiIunX3
         6XUQ==
X-Gm-Message-State: AOAM530n/taig3xT/UFQzHY9N2u7BImED8pXkov2eFVzhyWnE82mMEcg
        /avufXg+rL2xR60OjAfGgMfCjzvNXorSnsSvYSyOqk1lHtTfpXYvKhE=
X-Google-Smtp-Source: ABdhPJxBuThZnzP9AYFN7h0wQDhymO9Zc8H4gdgxC8lxt6+4bL+rIhmd3eKwAVkVVBBDSTqIMowxTyvbwaW730UwQZQ=
X-Received: by 2002:a65:64cc:: with SMTP id t12mr7104067pgv.126.1607078283965;
 Fri, 04 Dec 2020 02:38:03 -0800 (PST)
MIME-Version: 1.0
References: <1607077277-41995-1-git-send-email-zhangchangzhong@huawei.com>
In-Reply-To: <1607077277-41995-1-git-send-email-zhangchangzhong@huawei.com>
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
Date:   Fri, 4 Dec 2020 11:37:53 +0100
Message-ID: <CAJ8uoz19OhNMTZTyUrZoaSdUMuZk90HES_Z0i9UJ2Dis9HJvUw@mail.gmail.com>
Subject: Re: [PATCH net v2] xsk: Return error code if force_zc is set
To:     Zhang Changzhong <zhangchangzhong@huawei.com>
Cc:     =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 4, 2020 at 11:18 AM Zhang Changzhong
<zhangchangzhong@huawei.com> wrote:
>
> If force_zc is set, we should exit out with an error, not fall back to
> copy mode.
>
> Fixes: 921b68692abb ("xsk: Enable sharing of dma mappings")
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: Zhang Changzhong <zhangchangzhong@huawei.com>
> ---
>  net/xdp/xsk_buff_pool.c | 1 +
>  1 file changed, 1 insertion(+)

Thank you Changzhong!

Acked-by: Magnus Karlsson <magnus.karlsson@intel.com>

> diff --git a/net/xdp/xsk_buff_pool.c b/net/xdp/xsk_buff_pool.c
> index 9287edd..d5adeee 100644
> --- a/net/xdp/xsk_buff_pool.c
> +++ b/net/xdp/xsk_buff_pool.c
> @@ -175,6 +175,7 @@ static int __xp_assign_dev(struct xsk_buff_pool *pool,
>
>         if (!pool->dma_pages) {
>                 WARN(1, "Driver did not DMA map zero-copy buffers");
> +               err = -EINVAL;
>                 goto err_unreg_xsk;
>         }
>         pool->umem->zc = true;
> --
> 2.9.5
>
