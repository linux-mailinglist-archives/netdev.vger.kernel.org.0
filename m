Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 693FC3064EB
	for <lists+netdev@lfdr.de>; Wed, 27 Jan 2021 21:18:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231346AbhA0UQ7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jan 2021 15:16:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231206AbhA0UQo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Jan 2021 15:16:44 -0500
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ECCA1C061574;
        Wed, 27 Jan 2021 12:16:03 -0800 (PST)
Received: by mail-ed1-x52f.google.com with SMTP id d22so4036367edy.1;
        Wed, 27 Jan 2021 12:16:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=3PbeJCQPhfYg0rsJTVCfMp2iHlLM/leRKCXlhwOTOjc=;
        b=S/YRGrtIIqeR6eh2EB+MFIWSjBF12Ud+IcDvTUDdilwx1TONdKRY7oYRKWIpU1qPnW
         hOXwjBxb8HQLoG4mc4sqqIenpFU2pfKASYUy4U+NLuWSKt73zHFEKnNAMG3RCHWtcuvt
         qNgvMs9VepXlTdG/v59Zp/W9NVtKMfLRwvaGAzEAN7oWSpaoYYA50WSxDOUOVmT638u3
         e1kQtFrFHUibWp7nKcPtSSBW8bojGUKtDK4Gw0pbOzAJh4MgW4fNFgVglO2/pT2BmGtA
         Lr4pujF1AnKE0UG7HNxh5nKtVRj7nm0PVrztFtAj8TjjtVw1BczEurFitAhPavERqD/a
         e2xg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=3PbeJCQPhfYg0rsJTVCfMp2iHlLM/leRKCXlhwOTOjc=;
        b=h8rI9wLfbZraxvgbY5itK0uKhIpF99X+2+YHvn0VsuKDIpWhPHIxsKPMn+rx+IVR3H
         MZZNWhtp8MEn0HkOmxIi13TQ1KI5dzHE0Wq1LSAJt6Qxl/K79ASq2ZGJs7Fs+Fx01Uhb
         PRrZyHdmjAUp1aQmOyBF59O91ea6kFJ4sOGF5u0ARzXizepMAm78L5gJZUNWe9IRLd3I
         bzysdqYxY65xAyl/FgKrFjzr4JpLNE81/rW+ZR7sLskW9rWjbxZ9eWk/NZAB2NTdlJ9u
         3q2QavHBopjpBa8klGmFML8tcBY/q5wEkepGjEi7cqHTxRQi6vux8mW+kFg8DZ9X13ye
         /HHw==
X-Gm-Message-State: AOAM530CcAo8Gwaoex+pp6QC8KlXYljhJKsLo5EeEdCjQFbcV/FpbmsD
        UDr7lWTViTyciM3Kpnnyioe4efFJNEu0W23NLgc=
X-Google-Smtp-Source: ABdhPJx3TwPn2n+melTk7i7DkuNDsFT96Rubag7hZ3zq0+/gfV3fyqQQTKOTuVzLurLYVeKTwVdARDhQOMQSZFKwZ5A=
X-Received: by 2002:a05:6402:31bb:: with SMTP id dj27mr10682449edb.285.1611778562521;
 Wed, 27 Jan 2021 12:16:02 -0800 (PST)
MIME-Version: 1.0
References: <1611733552-150419-1-git-send-email-hkelam@marvell.com> <1611733552-150419-2-git-send-email-hkelam@marvell.com>
In-Reply-To: <1611733552-150419-2-git-send-email-hkelam@marvell.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Wed, 27 Jan 2021 15:15:26 -0500
Message-ID: <CAF=yD-LJ9O2Vsqj2+wPu3Hnf2wRwPDUX=ty=sX49=nD1iF2Nhw@mail.gmail.com>
Subject: Re: [Patch v2 net-next 1/7] octeontx2-af: forward error correction configuration
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

On Wed, Jan 27, 2021 at 4:05 AM Hariprasad Kelam <hkelam@marvell.com> wrote:
>
> From: Christina Jacob <cjacob@marvell.com>
>
> CGX block supports forward error correction modes baseR
> and RS. This patch adds support to set encoding mode
> and to read corrected/uncorrected block counters
>
> Adds new mailbox handlers set_fec to configure encoding modes
> and fec_stats to read counters and also increase mbox timeout
> to accomdate firmware command response timeout.
>
> Along with new CGX_CMD_SET_FEC command add other commands to
> sync with kernel enum list with firmware.
>
> Signed-off-by: Christina Jacob <cjacob@marvell.com>
> Signed-off-by: Sunil Goutham <sgoutham@marvell.com>
> Signed-off-by: Hariprasad Kelam <hkelam@marvell.com>
> ---
>  drivers/net/ethernet/marvell/octeontx2/af/cgx.c    | 74 ++++++++++++++++++++++
>  drivers/net/ethernet/marvell/octeontx2/af/cgx.h    |  7 ++
>  .../net/ethernet/marvell/octeontx2/af/cgx_fw_if.h  | 17 ++++-
>  drivers/net/ethernet/marvell/octeontx2/af/mbox.h   | 22 ++++++-
>  .../net/ethernet/marvell/octeontx2/af/rvu_cgx.c    | 33 ++++++++++
>  5 files changed, 151 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/net/ethernet/marvell/octeontx2/af/cgx.c b/drivers/net/ethernet/marvell/octeontx2/af/cgx.c
> index 84a9123..5489dab 100644
> --- a/drivers/net/ethernet/marvell/octeontx2/af/cgx.c
> +++ b/drivers/net/ethernet/marvell/octeontx2/af/cgx.c
> @@ -340,6 +340,58 @@ int cgx_get_tx_stats(void *cgxd, int lmac_id, int idx, u64 *tx_stat)
>         return 0;
>  }
>
> +static int cgx_set_fec_stats_count(struct cgx_link_user_info *linfo)
> +{
> +       if (linfo->fec) {
> +               switch (linfo->lmac_type_id) {
> +               case LMAC_MODE_SGMII:
> +               case LMAC_MODE_XAUI:
> +               case LMAC_MODE_RXAUI:
> +               case LMAC_MODE_QSGMII:
> +                       return 0;
> +               case LMAC_MODE_10G_R:
> +               case LMAC_MODE_25G_R:
> +               case LMAC_MODE_100G_R:
> +               case LMAC_MODE_USXGMII:
> +                       return 1;
> +               case LMAC_MODE_40G_R:
> +                       return 4;
> +               case LMAC_MODE_50G_R:
> +                       if (linfo->fec == OTX2_FEC_BASER)
> +                               return 2;
> +                       else
> +                               return 1;
> +               }
> +       }
> +       return 0;

may consider inverting the condition, to remove one level of indentation.

> +int cgx_set_fec(u64 fec, int cgx_id, int lmac_id)
> +{
> +       u64 req = 0, resp;
> +       struct cgx *cgx;
> +       int err = 0;
> +
> +       cgx = cgx_get_pdata(cgx_id);
> +       if (!cgx)
> +               return -ENXIO;
> +
> +       req = FIELD_SET(CMDREG_ID, CGX_CMD_SET_FEC, req);
> +       req = FIELD_SET(CMDSETFEC, fec, req);
> +       err = cgx_fwi_cmd_generic(req, &resp, cgx, lmac_id);
> +       if (!err) {
> +               cgx->lmac_idmap[lmac_id]->link_info.fec =
> +                       FIELD_GET(RESP_LINKSTAT_FEC, resp);
> +               return cgx->lmac_idmap[lmac_id]->link_info.fec;
> +       }
> +       return err;

Prefer keeping the success path linear and return early if (err) in
explicit branch. This also aids branch prediction.

> +int rvu_mbox_handler_cgx_fec_stats(struct rvu *rvu,
> +                                  struct msg_req *req,
> +                                  struct cgx_fec_stats_rsp *rsp)
> +{
> +       int pf = rvu_get_pf(req->hdr.pcifunc);
> +       u8 cgx_idx, lmac;
> +       int err = 0;
> +       void *cgxd;
> +
> +       if (!is_cgx_config_permitted(rvu, req->hdr.pcifunc))
> +               return -EPERM;
> +       rvu_get_cgx_lmac_id(rvu->pf2cgxlmac_map[pf], &cgx_idx, &lmac);
> +
> +       cgxd = rvu_cgx_pdata(cgx_idx, rvu);
> +       err = cgx_get_fec_stats(cgxd, lmac, rsp);
> +       return err;

no need for variable err
