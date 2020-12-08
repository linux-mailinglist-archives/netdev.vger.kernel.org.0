Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DACCF2D2162
	for <lists+netdev@lfdr.de>; Tue,  8 Dec 2020 04:20:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727009AbgLHDSb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Dec 2020 22:18:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725881AbgLHDSb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Dec 2020 22:18:31 -0500
Received: from mail-il1-x141.google.com (mail-il1-x141.google.com [IPv6:2607:f8b0:4864:20::141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E11FC0613D6
        for <netdev@vger.kernel.org>; Mon,  7 Dec 2020 19:17:51 -0800 (PST)
Received: by mail-il1-x141.google.com with SMTP id r17so14238858ilo.11
        for <netdev@vger.kernel.org>; Mon, 07 Dec 2020 19:17:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=rdHox7f3Bm+4eg7FA2K6XaAW5Mtytw967E7ieqIv+CQ=;
        b=UWUascKohDxP4/2W2N3+kJppXqnzfnqdnWuITvQ5vNe4SkYtUG5mjBUH0Qic8vGVes
         pGDK/Soj2NG1MdaF/J0vJaNKSnefTRrQD1R8GBZkYJeGGSFh3Ak/1k1dhKLTn2tM6Q1/
         gv8fokOxsGEHdntRnSaGGrw3u+/v9AIXmcY6UiD/89n9NIEDrXClaVa0152HBwDdimgE
         I8pixWAKzSF9VhXFlLedo0vgJSbTkgR2Gc5Uttz9WYaiOLm6Z+0r0zcl/pf4yKOC0fuE
         qWhbvnVjcFSOmRi76oAZ5wbynHLX11a508eBic9gpHAYVTXCwol/HaOTdrIUQB5DTw78
         n+Lw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=rdHox7f3Bm+4eg7FA2K6XaAW5Mtytw967E7ieqIv+CQ=;
        b=ivq+OFITEYDgmNtkpKKrRcmfNpnWcAowmtVFrnWpC3GxnRYX0qs17iQ5v43vRFv7He
         fc8mVXODHkpv4Kp13fr2Nkfy3r2BbifrRAYMLkUPbp9+JJIbK280Ly63Op8936WS3ymI
         NXEDoWoKoG6pKZGUMpEoQJeJCcfb5Y9fdJzqnaBiixfzjnbcZcGPpLXwssP7+0hJOl9l
         a9InmNKgnrWk0OpqxhmSzG9fEwDTM4iIzNhNVFOeuBLy1wL1MnW6RMi8PeQcg6h8jk2V
         dtHnsjI7+phYJFD4EKXiVci0O1sWtPIaDofEtbHQ1lWmMjupaTPnObkwhb1KcZrIqlPO
         960g==
X-Gm-Message-State: AOAM530EYbqCKjyfbD5PBbvJxQHtPL43sDmsPliAQgegklnh0YTUrHXN
        n0sSUme+m2zxY0dYi06hXmNa6Y7SfdXTlbtPxn3ueih56G0=
X-Google-Smtp-Source: ABdhPJzwnwibXAOLcAXgNY5YfixAqmNwFKqEyz4BcdFVIbNFoqVc8ajFEgBdOmWlrw1hAsl7lk0VVQnq2ded+sIEtn8=
X-Received: by 2002:a92:d8cc:: with SMTP id l12mr22963360ilo.64.1607397469551;
 Mon, 07 Dec 2020 19:17:49 -0800 (PST)
MIME-Version: 1.0
References: <20201207224526.95773-1-awogbemila@google.com>
In-Reply-To: <20201207224526.95773-1-awogbemila@google.com>
From:   Alexander Duyck <alexander.duyck@gmail.com>
Date:   Mon, 7 Dec 2020 19:17:38 -0800
Message-ID: <CAKgT0UeRdj4ek=3OZQSHLT8NNH04k+ziK_3LVtBpr4T8k=+U9w@mail.gmail.com>
Subject: Re: [PATCH net-next v10 0/4] GVE Raw Addressing
To:     David Awogbemila <awogbemila@google.com>
Cc:     Netdev <netdev@vger.kernel.org>, Saeed Mahameed <saeed@kernel.org>,
        Alexander Duyck <alexanderduyck@fb.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 7, 2020 at 2:45 PM David Awogbemila <awogbemila@google.com> wrote:
>
> Patchset description:
> This  patchset introduces "raw addressing" mode to the GVE driver.
> Previously (in "queue_page_list" or "qpl" mode), the driver would
> pre-allocate and dma_map buffers to be used on egress and ingress.
> On egress, it would copy data from the skb provided to the
> pre-allocated buffers - this was expensive.
> In raw addressing mode, the driver can avoid this copy and simply
> dma_map the skb's data so that the NIC can use it.
> On ingress, the driver passes buffers up to the networking stack and
> then frees and reallocates buffers when necessary instead of using
> skb_copy_to_linear_data.
> Patch 3 separates the page refcount tracking mechanism
> into a function gve_rx_can_recycle_buffer which uses get_page - this will
> be changed in a future patch to eliminate the use of get_page in tracking
> page refcounts.
>
> Changes from v9:
>   Patch 4: Use u64, not u32 for new tx stat counters.
>
> Catherine Sullivan (3):
>   gve: Add support for raw addressing device option
>   gve: Add support for raw addressing to the rx path
>   gve: Add support for raw addressing in the tx path
>
> David Awogbemila (1):
>   gve: Rx Buffer Recycling
>
>
>  drivers/net/ethernet/google/gve/gve.h         |  39 +-
>  drivers/net/ethernet/google/gve/gve_adminq.c  |  89 ++++-
>  drivers/net/ethernet/google/gve/gve_adminq.h  |  15 +-
>  drivers/net/ethernet/google/gve/gve_desc.h    |  19 +-
>  drivers/net/ethernet/google/gve/gve_ethtool.c |   2 +
>  drivers/net/ethernet/google/gve/gve_main.c    |  11 +-
>  drivers/net/ethernet/google/gve/gve_rx.c      | 364 +++++++++++++-----
>  drivers/net/ethernet/google/gve/gve_tx.c      | 197 ++++++++--
>  8 files changed, 574 insertions(+), 162 deletions(-)
>
> Reviewed-by: Alexander Duyck <alexanderduyck@fb.com>

Normally the reviewed-by should be included on the individual patches
instead of here. It can be moved if you end up needing to resubmit.
