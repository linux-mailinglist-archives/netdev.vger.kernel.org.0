Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF0832B98B8
	for <lists+netdev@lfdr.de>; Thu, 19 Nov 2020 18:00:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727364AbgKSQ5D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Nov 2020 11:57:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725877AbgKSQ5D (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Nov 2020 11:57:03 -0500
Received: from mail-il1-x142.google.com (mail-il1-x142.google.com [IPv6:2607:f8b0:4864:20::142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 081DEC0613CF
        for <netdev@vger.kernel.org>; Thu, 19 Nov 2020 08:57:02 -0800 (PST)
Received: by mail-il1-x142.google.com with SMTP id z14so4225355ilm.10
        for <netdev@vger.kernel.org>; Thu, 19 Nov 2020 08:57:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=XgdWfY4AlGK4cybPokzm0hmAeGxzWEWyl0m4kyQUFuU=;
        b=e5jLoFsHXpqzdCLD1MEBMKws56p4S3rA+XZaTKs1ZYiows3jLTZY3aEQLTJAtBA7Dk
         1t0fHVBEbUvHkYxZbHp1xrjorMmyWqh4VS950k/yCkWoEt1zOMYsWdfTNTSlaEtQ7gJ+
         vf/4iolkRahFWxD/tNV4eumOSzMVje57JWEC0KhTkGptKrq+NMjjVZtUNeq8Buy7fDpM
         sL+/dcdYjIG18Hql72gqkeWZihBZccp6Eam6qYv9p7I97rbGJe0IQkRp7nQ8slw9ICm+
         PfF9UosWTFU5r/grDPMHrJ55Z6CjG7NFEn+cSvwNiduvQ+DOCNzSt45xF+kjNMppvRcI
         k9XA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=XgdWfY4AlGK4cybPokzm0hmAeGxzWEWyl0m4kyQUFuU=;
        b=t+Tz2dA/BhabvVJtVwSF0HGe7AdG5qS7w8+ZKbwmHBn+9yr56EY9GQgiN+8YlcXX5l
         MO6dmmspXqN2mxeV/1KZmI/XvEGoHj4jipGFgLLPR7ni6CM6nX5sQUFiOH+f0zceLVxb
         BqNqkwwdZe+XKBLbDdwNIpXZDB3ol2qiPJ92YzUg84he/wbFq1JUwh2iMH6924gvfsdP
         72fvhLgohsvBAhx07MAkHyRGa72zTdpV44CNL8NDcHvXbeFaEkrxyIR0WzOd8ZDwHVz9
         +iM1TTXyw8+MMNKKBUOlijtBN2VempOP9WSyMsdXjUMV0HURVb5nFNpLlzW6pBtqpmM9
         NXgw==
X-Gm-Message-State: AOAM53187XT0wAKidN8nI8Xpw8C62Xmo1Z3Lhw0zcUVdXmQ+v9mXrjOs
        LfMFUtv22e8MMgCDaOFopUUUrlM6sOLi5R1umJ0E53sSe1Q=
X-Google-Smtp-Source: ABdhPJxOvoXYfE6sWic/dM1q3hQyffDEMCQE/2EN5xwuzSGSzpRN6ii2LyRl8x8b/cIL5IZ58Wt5a7ImURzU4Q4YQPY=
X-Received: by 2002:a92:aacc:: with SMTP id p73mr5844381ill.64.1605805021393;
 Thu, 19 Nov 2020 08:57:01 -0800 (PST)
MIME-Version: 1.0
References: <20201118232014.2910642-1-awogbemila@google.com>
In-Reply-To: <20201118232014.2910642-1-awogbemila@google.com>
From:   Alexander Duyck <alexander.duyck@gmail.com>
Date:   Thu, 19 Nov 2020 08:56:50 -0800
Message-ID: <CAKgT0Udi+zsWCHt7CT8g+O8YN6cge3wLO1kJNrXSrGRL5PWnew@mail.gmail.com>
Subject: Re: [PATCH net-next v7 0/4] GVE Raw Addressing
To:     David Awogbemila <awogbemila@google.com>
Cc:     Netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Where is the description of what this patch set is meant to do? I
don't recall if I reviewed that in the last patch set but usually the
cover page should tell us something about the patch set and not just
be a list of changes which I assume are diffs from v3?

On Wed, Nov 18, 2020 at 3:22 PM David Awogbemila <awogbemila@google.com> wrote:
>
> Patch 1: Use u8 instead of bool for raw_addressing bit in gve_priv structure.
>         Simplify pointer arithmetic: use (option + 1) in gve_get_next_option.
>         Separate option parsing switch statement into individual function.
> Patch 2: Use u8 instead of bool for raw_addressing bit in gve_gve_rx_data_queue structure.
>         Correct typo in gve_desc.h comment (s/than/then/).
>         Change gve_rx_data_slot from struct to union.
>         Remove dma_mapping_error path change in gve_alloc_page - it should
>         probably be a bug fix.
>         Use & to obtain page address from data_ring->addr.
>         Move declarations of local variables i and slots to if statement where they
>         are used within gve_rx_unfill_pages.
>         Simplify alloc_err path by using "while(i--)", eliminating need for extra "int j"
>         variable in gve_prefill_rx_pages.
>         Apply byteswap to constant in gve_rx_flip_buff.
>         Remove gve_rx_raw_addressing as it does not do much more than gve_rx_add_frags.
>         Remove stats update from elseif block, no need to optimize for infrequent case of
>         work_done = 0.
> Patch 3: Use u8 instead of bool for can_flip in gve_rx_slot_page_info.
>         Move comment in gve_rx_flip_buff to earlier, more relevant patch.
>         Fix comment wrap in gve_rx_can_flip_buffers.
>         Use ternary statement for gve_rx_can_flip_buffers.
>         Correct comment in gve_rx_qpl.
> Patch 4: Use u8 instead of bool in gve_tx_ring structure.
>         Get rid of unnecessary local variable "dma" in gve_dma_sync_for_device.
>
> Catherine Sullivan (3):
>   gve: Add support for raw addressing device option
>   gve: Add support for raw addressing to the rx path
>   gve: Add support for raw addressing in the tx path
>
> David Awogbemila (1):
>   gve: Rx Buffer Recycling
>
>  drivers/net/ethernet/google/gve/gve.h        |  38 +-
>  drivers/net/ethernet/google/gve/gve_adminq.c |  90 ++++-
>  drivers/net/ethernet/google/gve/gve_adminq.h |  15 +-
>  drivers/net/ethernet/google/gve/gve_desc.h   |  19 +-
>  drivers/net/ethernet/google/gve/gve_main.c   |  11 +-
>  drivers/net/ethernet/google/gve/gve_rx.c     | 403 ++++++++++++++-----
>  drivers/net/ethernet/google/gve/gve_tx.c     | 211 ++++++++--
>  7 files changed, 620 insertions(+), 167 deletions(-)
>
> --
> 2.29.2.299.gdc1121823c-goog
>
