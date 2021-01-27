Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 34D173064FA
	for <lists+netdev@lfdr.de>; Wed, 27 Jan 2021 21:23:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231820AbhA0UVs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jan 2021 15:21:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231424AbhA0UVq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Jan 2021 15:21:46 -0500
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CE37C061573;
        Wed, 27 Jan 2021 12:21:05 -0800 (PST)
Received: by mail-ed1-x52f.google.com with SMTP id g1so4036536edu.4;
        Wed, 27 Jan 2021 12:21:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=nY++2Ktt5t0NpvtyG07V94lwnaMUXjXyNcAVVFj7Mo4=;
        b=cbcRIa8k+Dzt5J8GKUv+mOlSyeZbFzLaGzqza0LrYE691x/WbMG84J1iscH20lye6/
         MQXgAFZdDPRW55+F4f+fKA+Wj9+4IMMvAT3cRNrl1ho9GIGwMxVd0jTxCkqnVE+fZG3e
         Ro2xBAGUcOfppr1egeNnrasS2gt/tdmkbNPshMG7TcHO3z2RYZo0ietH5CwZGgic6Cr3
         7HavqvHal9r0RgxVv9hGztpbKfU35a7Zrjl4LOklF9mX1DQskZyGUl66cREtrEt4d1RW
         7g4gQyuRl4E+P084PbZUeWR1gOdkdqzRxxYgKaUa1eK0x2S0nngZgoQ58s/hIQ1nzKhJ
         oerg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=nY++2Ktt5t0NpvtyG07V94lwnaMUXjXyNcAVVFj7Mo4=;
        b=C4uaZ8kYtRaMrOPT+phEhib7UxeREsw83FO5GiLzYBKAkzUb1ocO4BuPoeTl2TWtNT
         w/LHEuNvlSo/UZ5Ttqtfvo9HT/tUTuxMuY16G472EY1ulQYGbEGyEGSzG2l4ERBomonY
         iKkj/Ic+YtU4pv0t9TLF+eUPpYCfmocHse/6Vio5qQaaaPQWX1fMR3NEqDUbyt8uUGiv
         IrtH6ZqOZMO3/y5VpY7aH/uJqR6PnSWTHBUT9DlEvtTqePuOeaO5gGUSjib2qvUw0qtc
         1LCMJ5FmnERUIDxeyIADY3RN1EZn7Kq5/jE2a6PI4kzdLwakeXnPhgCznvvoRqbVoHL3
         d9Cw==
X-Gm-Message-State: AOAM530Tf8jXxFDfZmE4zTCJJynNl5di3HzekUu7HcJ1U0eFClx0/2od
        C/AggqUUYLhc+WD7L+smNncT41+uiLbxvkSH6uQ=
X-Google-Smtp-Source: ABdhPJxXszzip0vKMEEGs5SRGXLDD/aRB333TuOEbeYttLkQzLI9viZ40NCSJPU0sTDjjD4OKNyCWkg7DTNkRMPiDiM=
X-Received: by 2002:aa7:c9cf:: with SMTP id i15mr10551833edt.296.1611778864325;
 Wed, 27 Jan 2021 12:21:04 -0800 (PST)
MIME-Version: 1.0
References: <1611733552-150419-1-git-send-email-hkelam@marvell.com> <1611733552-150419-3-git-send-email-hkelam@marvell.com>
In-Reply-To: <1611733552-150419-3-git-send-email-hkelam@marvell.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Wed, 27 Jan 2021 15:20:27 -0500
Message-ID: <CAF=yD-+6J1-HA6eOPFnmWGZidr_vh41907fnoX+kEC=vuH2+Aw@mail.gmail.com>
Subject: Re: [Patch v2 net-next 2/7] octeontx2-af: Add new CGX_CMD to get PHY
 FEC statistics
To:     Hariprasad Kelam <hkelam@marvell.com>
Cc:     Network Development <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Sunil Kovvuri Goutham <sgoutham@marvell.com>,
        Linu Cherian <lcherian@marvell.com>,
        Geethasowjanya Akula <gakula@marvell.com>,
        Jerin Jacob <jerinj@marvell.com>, sbhatta@marvell.com,
        Felix Manlunas <fmanlunas@marvell.com>,
        Christina Jacob <cjacob@marvell.com>,
        Sunil Kovvuri Goutham <Sunil.Goutham@cavium.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 27, 2021 at 4:04 AM Hariprasad Kelam <hkelam@marvell.com> wrote:
>
> From: Felix Manlunas <fmanlunas@marvell.com>
>
> This patch adds support to fetch fec stats from PHY. The stats are
> put in the shared data struct fwdata.  A PHY driver indicates
> that it has FEC stats by setting the flag fwdata.phy.misc.has_fec_stats
>
> Besides CGX_CMD_GET_PHY_FEC_STATS, also add CGX_CMD_PRBS and
> CGX_CMD_DISPLAY_EYE to enum cgx_cmd_id so that Linux's enum list is in sync
> with firmware's enum list.
>
> Signed-off-by: Felix Manlunas <fmanlunas@marvell.com>
> Signed-off-by: Christina Jacob <cjacob@marvell.com>
> Signed-off-by: Sunil Kovvuri Goutham <Sunil.Goutham@cavium.com>
> Signed-off-by: Hariprasad Kelam <hkelam@marvell.com>


> +struct phy_s {
> +       struct {
> +               u64 can_change_mod_type : 1;
> +               u64 mod_type            : 1;
> +               u64 has_fec_stats       : 1;

this style is not customary

> +       } misc;
> +       struct fec_stats_s {
> +               u32 rsfec_corr_cws;
> +               u32 rsfec_uncorr_cws;
> +               u32 brfec_corr_blks;
> +               u32 brfec_uncorr_blks;
> +       } fec_stats;
> +};
> +
> +struct cgx_lmac_fwdata_s {
> +       u16 rw_valid;
> +       u64 supported_fec;
> +       u64 supported_an;

are these intended to be individual u64's?

> +       u64 supported_link_modes;
> +       /* only applicable if AN is supported */
> +       u64 advertised_fec;
> +       u64 advertised_link_modes;
> +       /* Only applicable if SFP/QSFP slot is present */
> +       struct sfp_eeprom_s sfp_eeprom;
> +       struct phy_s phy;
> +#define LMAC_FWDATA_RESERVED_MEM 1021
> +       u64 reserved[LMAC_FWDATA_RESERVED_MEM];
> +};
> +
> +struct cgx_fw_data {
> +       struct mbox_msghdr hdr;
> +       struct cgx_lmac_fwdata_s fwdata;
> +};
> +
>  /* NPA mbox message formats */
>
>  /* NPA mailbox error codes
> diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu.h b/drivers/net/ethernet/marvell/octeontx2/af/rvu.h
> index b1a6ecf..c824f1e 100644
> --- a/drivers/net/ethernet/marvell/octeontx2/af/rvu.h
> +++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu.h
> @@ -350,6 +350,10 @@ struct rvu_fwdata {
>         u64 msixtr_base;
>  #define FWDATA_RESERVED_MEM 1023
>         u64 reserved[FWDATA_RESERVED_MEM];
> +       /* Do not add new fields below this line */
> +#define CGX_MAX         5
> +#define CGX_LMACS_MAX   4
> +       struct cgx_lmac_fwdata_s cgx_fw_data[CGX_MAX][CGX_LMACS_MAX];

Probably want to move the comment below the field.
>  };
>
>  struct ptp;
> diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_cgx.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_cgx.c
> index 74f494b..7fac9ab 100644
> --- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_cgx.c
> +++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_cgx.c
> @@ -694,6 +694,19 @@ int rvu_mbox_handler_cgx_cfg_pause_frm(struct rvu *rvu,
>         return 0;
>  }
>
> +int rvu_mbox_handler_cgx_get_phy_fec_stats(struct rvu *rvu, struct msg_req *req,
> +                                          struct msg_rsp *rsp)
> +{
> +       int pf = rvu_get_pf(req->hdr.pcifunc);
> +       u8 cgx_id, lmac_id;
> +
> +       if (!is_pf_cgxmapped(rvu, pf))
> +               return -EPERM;
> +
> +       rvu_get_cgx_lmac_id(rvu->pf2cgxlmac_map[pf], &cgx_id, &lmac_id);
> +       return cgx_get_phy_fec_stats(rvu_cgx_pdata(cgx_id, rvu), lmac_id);
> +}
> +
>  /* Finds cumulative status of NIX rx/tx counters from LF of a PF and those
>   * from its VFs as well. ie. NIX rx/tx counters at the CGX port level
>   */
> @@ -800,3 +813,22 @@ int rvu_mbox_handler_cgx_set_fec_param(struct rvu *rvu,
>         rsp->fec = cgx_set_fec(req->fec, cgx_id, lmac_id);
>         return 0;
>  }
> +
> +int rvu_mbox_handler_cgx_get_aux_link_info(struct rvu *rvu, struct msg_req *req,
> +                                          struct cgx_fw_data *rsp)
> +{
> +       int pf = rvu_get_pf(req->hdr.pcifunc);
> +       u8 cgx_id, lmac_id;
> +
> +       if (!rvu->fwdata)
> +               return -ENXIO;
> +
> +       if (!is_pf_cgxmapped(rvu, pf))
> +               return -EPERM;
> +
> +       rvu_get_cgx_lmac_id(rvu->pf2cgxlmac_map[pf], &cgx_id, &lmac_id);
> +
> +       memcpy(&rsp->fwdata, &rvu->fwdata->cgx_fw_data[cgx_id][lmac_id],
> +              sizeof(struct cgx_lmac_fwdata_s));
> +       return 0;
> +}
> --
> 2.7.4
>
