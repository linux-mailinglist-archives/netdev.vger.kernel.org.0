Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C63C3983B7
	for <lists+netdev@lfdr.de>; Wed,  2 Jun 2021 09:59:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232288AbhFBIAk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Jun 2021 04:00:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232136AbhFBIAj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Jun 2021 04:00:39 -0400
Received: from mail-io1-xd2b.google.com (mail-io1-xd2b.google.com [IPv6:2607:f8b0:4864:20::d2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 764D5C061574;
        Wed,  2 Jun 2021 00:58:55 -0700 (PDT)
Received: by mail-io1-xd2b.google.com with SMTP id q7so1564721iob.4;
        Wed, 02 Jun 2021 00:58:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=qabcrgcfhEwhuxn/j/3+LSWfxN4EJWq76mgUFbPSQfc=;
        b=OT9pI1cLDfVtJEbjcRrOd63nDT0/5O6el+Z/j0fD2emf6m06YRE71xYgt5DqE1ub97
         N7kRd/cSxZJ/2Mz6OD3kPnuzof4+lSudMwU5nKWfEhU7fkDwWpCrLVOUQUMjchCEdc2A
         83tv4Z/IyeqJM3gp44zcBiF2QJlwTzgXC+8YD+0smMxtZg9Ay6xt8rONKGV0/gLNnbcv
         hGo6IOM64QaN1vV2Ti60Zy2WIXuL+yOQ7x47a7J6TyK5HrFFgjJYKArhAS9r8dFF0PL6
         Qw+/kAZwePxzJBCIvKbS/Rg4IC6h71q0wTnLJxVwIHhwX4554FgPu23eRm7agH4Lgml+
         ngGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=qabcrgcfhEwhuxn/j/3+LSWfxN4EJWq76mgUFbPSQfc=;
        b=ijCdTpAOyEKqmv60kU+EwINK/WDibY23ifL1vEhQq+ymPEsG1WVYcYo3laWGcnF6ZV
         nz9JOW0kmvv4aK0dWaj1LnCdv3Uja+xNQ+XKUXB+S/8Iz3xCjNcVaydSALmGgUu3/F3B
         4d19xwBxSYksbNJM6DX0h7M1MKqKdEjZAL+QMZntptzV2dMvcCj4AAHaNc2E/rGCt5Ce
         UqPhdAxHc1XfRS+FBsWeihgClw9vta1gbzdtbrJVC0Wpz823kjTsWU3LqGDwsq1HzoW2
         ZtoVoZc8m7QJAKn1cpugzP4GsZbBK1yNbYtmJPd9JOX17qOBWpx6twSRQTeE52ebH8tu
         D/TQ==
X-Gm-Message-State: AOAM532e/3Spv+KOHWBIiMqC+U6gpRSRllh2U4eQc5ztjq/KaUeYhY2B
        9Bsdokj332T8bdX9sXMTf3XS5RyoqEIxr02Nov2jwosj3U/aOA==
X-Google-Smtp-Source: ABdhPJxPmYmfcLfSgGMSYk2vkiJxCMXDTKTmlWHFzeWkXcxGhSG2pycZS4aQblPDVuwAFtckoD3DSwANLPwvKnENa+E=
X-Received: by 2002:a6b:ef04:: with SMTP id k4mr24866061ioh.182.1622620734797;
 Wed, 02 Jun 2021 00:58:54 -0700 (PDT)
MIME-Version: 1.0
References: <20210602065635.106561-1-zhengyongjun3@huawei.com>
In-Reply-To: <20210602065635.106561-1-zhengyongjun3@huawei.com>
From:   Ilya Dryomov <idryomov@gmail.com>
Date:   Wed, 2 Jun 2021 09:58:58 +0200
Message-ID: <CAOi1vP-QtGyRGT-y2naZPzfMOEvv4MQY_iWDhws5e7hagAQQrQ@mail.gmail.com>
Subject: Re: [PATCH net-next] libceph: Fix spelling mistakes
To:     Zheng Yongjun <zhengyongjun3@huawei.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Ceph Development <ceph-devel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Jeff Layton <jlayton@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 2, 2021 at 8:42 AM Zheng Yongjun <zhengyongjun3@huawei.com> wrote:
>
> Fix some spelling mistakes in comments:
> enconding  ==> encoding
> ambigous  ==> ambiguous
> orignal  ==> original
> encyption  ==> encryption
>
> Signed-off-by: Zheng Yongjun <zhengyongjun3@huawei.com>
> ---
>  net/ceph/auth_x_protocol.h | 2 +-
>  net/ceph/mon_client.c      | 2 +-
>  net/ceph/osdmap.c          | 4 ++--
>  3 files changed, 4 insertions(+), 4 deletions(-)
>
> diff --git a/net/ceph/auth_x_protocol.h b/net/ceph/auth_x_protocol.h
> index 792fcb974dc3..9c60feeb1bcb 100644
> --- a/net/ceph/auth_x_protocol.h
> +++ b/net/ceph/auth_x_protocol.h
> @@ -87,7 +87,7 @@ struct ceph_x_authorize_reply {
>
>
>  /*
> - * encyption bundle
> + * encryption bundle
>   */
>  #define CEPHX_ENC_MAGIC 0xff009cad8826aa55ull
>
> diff --git a/net/ceph/mon_client.c b/net/ceph/mon_client.c
> index 195ceb8afb06..013cbdb6cfe2 100644
> --- a/net/ceph/mon_client.c
> +++ b/net/ceph/mon_client.c
> @@ -1508,7 +1508,7 @@ static struct ceph_msg *mon_alloc_msg(struct ceph_connection *con,
>                         return get_generic_reply(con, hdr, skip);
>
>                 /*
> -                * Older OSDs don't set reply tid even if the orignal
> +                * Older OSDs don't set reply tid even if the original
>                  * request had a non-zero tid.  Work around this weirdness
>                  * by allocating a new message.
>                  */
> diff --git a/net/ceph/osdmap.c b/net/ceph/osdmap.c
> index c959320c4775..75b738083523 100644
> --- a/net/ceph/osdmap.c
> +++ b/net/ceph/osdmap.c
> @@ -1309,7 +1309,7 @@ static int get_osdmap_client_data_v(void **p, void *end,
>                         return -EINVAL;
>                 }
>
> -               /* old osdmap enconding */
> +               /* old osdmap encoding */
>                 struct_v = 0;
>         }
>
> @@ -3010,7 +3010,7 @@ static bool is_valid_crush_name(const char *name)
>   * parent, returns 0.
>   *
>   * Does a linear search, as there are no parent pointers of any
> - * kind.  Note that the result is ambigous for items that occur
> + * kind.  Note that the result is ambiguous for items that occur
>   * multiple times in the map.
>   */
>  static int get_immediate_parent(struct crush_map *c, int id,

Applied.

Thanks,

                Ilya
