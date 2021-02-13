Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 36F2E31A978
	for <lists+netdev@lfdr.de>; Sat, 13 Feb 2021 02:23:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232105AbhBMBWO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Feb 2021 20:22:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229650AbhBMBWM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Feb 2021 20:22:12 -0500
Received: from mail-io1-xd2a.google.com (mail-io1-xd2a.google.com [IPv6:2607:f8b0:4864:20::d2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 124AEC061574
        for <netdev@vger.kernel.org>; Fri, 12 Feb 2021 17:21:32 -0800 (PST)
Received: by mail-io1-xd2a.google.com with SMTP id q7so1149174iob.0
        for <netdev@vger.kernel.org>; Fri, 12 Feb 2021 17:21:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=blZ+p+C8DT5ov77/Ew+JJEfXNzCZtorrWutT02ymjIE=;
        b=JlscEiD/ytW8ZxdBwYXx0URpmKMRpn+wtglQfgQanzBoQOKsNgiG+XyhzplARlY+K4
         K+c8gbbjOjDkT07nz7Ti6yqZ2GZNHko52Gys3vV29+QD2UD3TTxX8uv3LQatszW6s5Py
         6kgeD0NbSu10IFmlB13i4hNOwHeW2aW+THhzM2M16ACNgSt4BWHwVw/NZ632KD/gomul
         lWLweTvLFrjRnTgmNyLc5gUFalSYnyZZUsYTvAQa3EpmjTVhAEjXvE8Z/JxBkuu4D57F
         ZCG5nZZ66bAE0uANUfnWc4s/0tEbKdv9JyUupNUdGzuH3vls6hpsJCRT9862ilPhqXog
         +eMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=blZ+p+C8DT5ov77/Ew+JJEfXNzCZtorrWutT02ymjIE=;
        b=mUx4bVi4YWW7i/ucAU1uinvR/sPVN2sSO+7tbbK5c8MJEfASXGrlC3Tx8YyOxBAlZl
         +42VZRp4V1Xp3p2VsCGCG8q8YyFu3yt/NHhRi55b3bpV/YkrCHtnuM4acgraeqLv123n
         8DpqKjDkoiXsJOhK+H15cnyS2Fu8Hi2cfjZh2l4i/380yktb0fwmhbIyLKrypwz7LDGG
         neU6fEISuQiRYEZ7MaCzBXRvzO1zQ6e71xq1JAE3JstFnFO/EU4p0diAluh9CZA0vMpa
         R1rfmW4fM6/Q9yZ3A5TRWEZQY6Y85HzGWN0mnUfXRDQMR9RTjI2tB4hZW4tmRE8vyD5u
         C5Hw==
X-Gm-Message-State: AOAM531plQz0cwClua2uDBoycQMtHdfGnN24Su9fFirPbBu6IAsi+ISB
        G0wIL6UrlFDjD179Mu1ts2FutUaJwFQeEdvFggcu/GdPJJs=
X-Google-Smtp-Source: ABdhPJwESNSvXMoWNQV4A+yDfrG/mNPWGCWTwjC5a3NUwM0NI+BVWKNPL1qFeJq7adHTKkTCkHwmtvef+26mq8UGAm4=
X-Received: by 2002:a05:6638:b12:: with SMTP id a18mr5170344jab.114.1613179291362;
 Fri, 12 Feb 2021 17:21:31 -0800 (PST)
MIME-Version: 1.0
References: <20210212223952.1172568-1-anthony.l.nguyen@intel.com> <20210212223952.1172568-3-anthony.l.nguyen@intel.com>
In-Reply-To: <20210212223952.1172568-3-anthony.l.nguyen@intel.com>
From:   Alexander Duyck <alexander.duyck@gmail.com>
Date:   Fri, 12 Feb 2021 17:21:20 -0800
Message-ID: <CAKgT0Uf+f5+MdN0c0uiHByRCXD_mAiQQOC5W9+TgPxuwo3zLsg@mail.gmail.com>
Subject: Re: [PATCH net-next 02/11] i40e: drop misleading function comments
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Netdev <netdev@vger.kernel.org>,
        Stefan Assmann <sassmann@redhat.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        Tony Brelinski <tonyx.brelinski@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 12, 2021 at 2:46 PM Tony Nguyen <anthony.l.nguyen@intel.com> wr=
ote:
>
> From: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
>
> i40e_cleanup_headers has a statement about check against skb being
> linear or not which is not relevant anymore, so let's remove it.
>
> Same case for i40e_can_reuse_rx_page, it references things that are not
> present there anymore.
>
> Reviewed-by: Bj=C3=B6rn T=C3=B6pel <bjorn.topel@intel.com>
> Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
> Tested-by: Tony Brelinski <tonyx.brelinski@intel.com>
> Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
> ---
>  drivers/net/ethernet/intel/i40e/i40e_txrx.c | 33 ++++-----------------
>  1 file changed, 6 insertions(+), 27 deletions(-)
>
> diff --git a/drivers/net/ethernet/intel/i40e/i40e_txrx.c b/drivers/net/et=
hernet/intel/i40e/i40e_txrx.c
> index 3d24c6032616..5f6aa13e85ca 100644
> --- a/drivers/net/ethernet/intel/i40e/i40e_txrx.c
> +++ b/drivers/net/ethernet/intel/i40e/i40e_txrx.c
> @@ -1963,9 +1963,6 @@ void i40e_process_skb_fields(struct i40e_ring *rx_r=
ing,
>   * @skb: pointer to current skb being fixed
>   * @rx_desc: pointer to the EOP Rx descriptor
>   *
> - * Also address the case where we are pulling data in on pages only
> - * and as such no data is present in the skb header.
> - *
>   * In addition if skb is not at least 60 bytes we need to pad it so that
>   * it is large enough to qualify as a valid Ethernet frame.
>   *
> @@ -1998,33 +1995,15 @@ static bool i40e_cleanup_headers(struct i40e_ring=
 *rx_ring, struct sk_buff *skb,
>  }
>
>  /**
> - * i40e_can_reuse_rx_page - Determine if this page can be reused by
> - * the adapter for another receive
> - *
> + * i40e_can_reuse_rx_page - Determine if page can be reused for another =
Rx
>   * @rx_buffer: buffer containing the page
>   * @rx_buffer_pgcnt: buffer page refcount pre xdp_do_redirect() call
>   *
> - * If page is reusable, rx_buffer->page_offset is adjusted to point to
> - * an unused region in the page.
> - *
> - * For small pages, @truesize will be a constant value, half the size
> - * of the memory at page.  We'll attempt to alternate between high and
> - * low halves of the page, with one half ready for use by the hardware
> - * and the other half being consumed by the stack.  We use the page
> - * ref count to determine whether the stack has finished consuming the
> - * portion of this page that was passed up with a previous packet.  If
> - * the page ref count is >1, we'll assume the "other" half page is
> - * still busy, and this page cannot be reused.
> - *
> - * For larger pages, @truesize will be the actual space used by the
> - * received packet (adjusted upward to an even multiple of the cache
> - * line size).  This will advance through the page by the amount
> - * actually consumed by the received packets while there is still
> - * space for a buffer.  Each region of larger pages will be used at
> - * most once, after which the page will not be reused.
> - *
> - * In either case, if the page is reusable its refcount is increased.
> - **/
> + * If page is reusable, we have a green light for calling i40e_reuse_rx_=
page,
> + * which will assign the current buffer to the buffer that next_to_alloc=
 is
> + * pointing to; otherwise, the DMA mapping needs to be destroyed and
> + * page freed
> + */
>  static bool i40e_can_reuse_rx_page(struct i40e_rx_buffer *rx_buffer,
>                                    int rx_buffer_pgcnt)
>  {

So this lost all of the context for why or how the function works.

You should probably call out that for 4K pages it is using a simple
page count where if the count hits 2 we have to return false, and if
the page is bigger than 4K we have to check the remaining unused
buffer to determine if we will fail or not.
