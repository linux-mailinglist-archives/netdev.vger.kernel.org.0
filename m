Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 55B02306538
	for <lists+netdev@lfdr.de>; Wed, 27 Jan 2021 21:34:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233077AbhA0Ucq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jan 2021 15:32:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233064AbhA0Ubw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Jan 2021 15:31:52 -0500
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E676FC061573;
        Wed, 27 Jan 2021 12:31:11 -0800 (PST)
Received: by mail-ed1-x52c.google.com with SMTP id z22so4055514edb.9;
        Wed, 27 Jan 2021 12:31:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=3XS90KtmQumLXlPtwpnJjXRsD+64Pdc4rIwKhhGJB1M=;
        b=hfO3iP61xhHalSCKMM3gTtqU30PcuFj8KLDLalEAQJnsIkS0nIdVnwzEM+trML6lKz
         NAgaLHNLrwN343jEPif6kiw+llhMmyQDvIwAWM/aaz4v65LnqhNsKCmZ3DAZf2BMKrxv
         UMFljJwMoHIBwU7p4B8dv0pQdyO348WPutkjfHaKjoHT2wcrXP6gl/HKhgy1fH7K2YpD
         2DdcZfs1AydzX1AuRa0VjOluusjRhOCYxO+c8fFo0G4lfFrh05j6c4BM4FyJRoMFZni9
         DuRtxMMvRj7kcjRkacgHtCRa8W9h6fvUAX9EVtSLEkZOAWbOhjGD0TGvhUJp50N/gqua
         fEfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=3XS90KtmQumLXlPtwpnJjXRsD+64Pdc4rIwKhhGJB1M=;
        b=FSPubzObCXKRtiYO/r/fIPSB8MEQ0O7ibDKyYDOZVEhUB63FS9iAgeRmJOIoZ2NVB3
         8Jkz5IswzIHqFiIzh5sVQfCrP59kP/RIncZvwU7OoT2MxoISmBz2XlI4i8MOm3lH4r1u
         DPD9qJMJMGVh6UbnGiTdYPg+DAebva4SoO9RmT9IHLYyx8iuETfjBRPHGEBi5Baxacpo
         PM3ctax/TZHxlcc3K31EZjGC4ghpd+VHMk1/YM7pEFj2IJeu25fA0ZtJ6X8D7lKf6V3Q
         lwSdZ4p0MVTYTmw38VxlxuPhfuTLR4sXPFvLOWhlbq8WqOXSFTKmAc6OGctqiorqTUXB
         vOTQ==
X-Gm-Message-State: AOAM530kFomf4zEeYCgL67sz0tKj7XbhIn2PDB4ZZAj5iCyYfeaJrLdB
        oexNf1/R4FndL4ChqGPQaee9rOhb6V7QNNvLG993du6iiF4Qig==
X-Google-Smtp-Source: ABdhPJwHiUpSKrKJ7iZqz025edEhN0myt9gwGFTzxakU/k0KnLlI9gLKVq+NC03ozxHEZI/xBof43ZgnddZSBsDf3R4=
X-Received: by 2002:a05:6402:ce:: with SMTP id i14mr10604828edu.42.1611779470636;
 Wed, 27 Jan 2021 12:31:10 -0800 (PST)
MIME-Version: 1.0
References: <1611733552-150419-1-git-send-email-hkelam@marvell.com> <1611733552-150419-4-git-send-email-hkelam@marvell.com>
In-Reply-To: <1611733552-150419-4-git-send-email-hkelam@marvell.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Wed, 27 Jan 2021 15:30:33 -0500
Message-ID: <CAF=yD-Lx-rxFPGQ+Sv0ECnso80UUZ_BaAep9Y707cTsTcodnEQ@mail.gmail.com>
Subject: Re: [Patch v2 net-next 3/7] octeontx2-pf: ethtool fec mode support
To:     Hariprasad Kelam <hkelam@marvell.com>
Cc:     Network Development <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Sunil Kovvuri Goutham <sgoutham@marvell.com>,
        Linu Cherian <lcherian@marvell.com>,
        Geethasowjanya Akula <gakula@marvell.com>,
        Jerin Jacob <jerinj@marvell.com>, sbhatta@marvell.com,
        Christina Jacob <cjacob@marvell.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 27, 2021 at 4:03 AM Hariprasad Kelam <hkelam@marvell.com> wrote:
>
> From: Christina Jacob <cjacob@marvell.com>
>
> Add ethtool support to configure fec modes baser/rs and
> support to fecth FEC stats from CGX as well PHY.
>
> Configure fec mode
>         - ethtool --set-fec eth0 encoding rs/baser/off/auto
> Query fec mode
>         - ethtool --show-fec eth0
>
> Signed-off-by: Christina Jacob <cjacob@marvell.com>
> Signed-off-by: Sunil Goutham <sgoutham@marvell.com>
> Signed-off-by: Hariprasad Kelam <hkelam@marvell.com>
> ---
>  .../ethernet/marvell/octeontx2/nic/otx2_common.c   |  23 +++
>  .../ethernet/marvell/octeontx2/nic/otx2_common.h   |   6 +
>  .../ethernet/marvell/octeontx2/nic/otx2_ethtool.c  | 181 ++++++++++++++++++++-
>  .../net/ethernet/marvell/octeontx2/nic/otx2_pf.c   |   3 +
>  4 files changed, 211 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
> index bdfa2e2..f7e5450 100644
> --- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
> +++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
> @@ -60,6 +60,22 @@ void otx2_update_lmac_stats(struct otx2_nic *pfvf)
>         mutex_unlock(&pfvf->mbox.lock);
>  }
>
> +void otx2_update_lmac_fec_stats(struct otx2_nic *pfvf)
> +{
> +       struct msg_req *req;
> +
> +       if (!netif_running(pfvf->netdev))
> +               return;
> +       mutex_lock(&pfvf->mbox.lock);
> +       req = otx2_mbox_alloc_msg_cgx_fec_stats(&pfvf->mbox);
> +       if (!req) {
> +               mutex_unlock(&pfvf->mbox.lock);
> +               return;
> +       }
> +       otx2_sync_mbox_msg(&pfvf->mbox);

Perhaps simpler to have a single exit from the critical section:

  if (req)
    otx2_update_lmac_fec_stats

> +       mutex_unlock(&pfvf->mbox.lock);
> +}

Also, should this function return an error on failure? The caller
returns errors in other cases.
