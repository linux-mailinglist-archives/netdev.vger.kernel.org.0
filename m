Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F38C3347214
	for <lists+netdev@lfdr.de>; Wed, 24 Mar 2021 08:11:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235678AbhCXHK2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Mar 2021 03:10:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231378AbhCXHKT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Mar 2021 03:10:19 -0400
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FFD3C061763;
        Wed, 24 Mar 2021 00:10:19 -0700 (PDT)
Received: by mail-wr1-x432.google.com with SMTP id x7so835541wrw.10;
        Wed, 24 Mar 2021 00:10:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=BVW+eD0V9Yhtkn4icwQeqwslm+oHkxZq5yTeO7esYzs=;
        b=mBplqvjKHwWPL4jRZPXU2FfoCLYUjA1RdJ9i4jzZn4JZ2+8LsH1EzwHO0SJ070Us3y
         B9ngwueXef6vPuw7hB/4R5iw2WoIN8OD95vsaq8ESO/Fs/y8cBXkR/4bqwG6rdkEfUaR
         NC41NDUurRFN7LbyeXIKZEC4VqovXG8rTOsHYyVD0Z/MKXPTPvUVvvMdLlZ8y1RGSewJ
         iCHAwUcecwt1FLTcnuMeCvnkmODqVKpB0ckbkLEP9hEMVy0bEEvyZW0mBhZEdncxGHHj
         EH4Q1XWXWS3PGbxp48uIdcLk8o5Ri7naq2jM157uDpPHDpsZTty9D7sNyhJD28Z+txLn
         JCwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=BVW+eD0V9Yhtkn4icwQeqwslm+oHkxZq5yTeO7esYzs=;
        b=blEXQ7lw8cCnYD+qV0WrnY9Sagf9n4Z167e2NLp3sn8GVuQVC+mG8tzaO6JxoXbFGp
         GrerVl1MtzWiwwU92O/vs70Otfj8GH5M+K27MCMlKchfp9AvffYkbiLn4T6cHuYGnx2M
         Vgw4COsTc1uG1RciBPTtpqoqEexw5tF7w1bZcmvSFqIGnXRewXhaXbaqxT3RaxIjAI5n
         3oGbGBWBWkpbc4G5XLB+AsjiMeJYqjxYDbzEgx3aYmTMze4b645IE1pi2KXxBh1RQ5b3
         vfizecd0YpScEkUr2eVfrV+C7vrIGfky44thkKOV4Hp+mlQDgBJ52HuYVJfu8BqHzdaB
         O+mQ==
X-Gm-Message-State: AOAM532+Fwn5Nt9moRVm5jBf3Yryi4DMxMb/XOD0zodkEW6t5d/WBuqm
        GIv9AN+KHMDl6jPIIa+AEEe/sa18XUdd433Tn/U=
X-Google-Smtp-Source: ABdhPJzcKMPhC5CCoArYvi7/jrEtfXOl4xeEFG9Y2gyT0uTqgOqhLqH8pn6qHMm5bCDR3FIDNjzrDDEksGseS/DchDY=
X-Received: by 2002:adf:de92:: with SMTP id w18mr1785813wrl.217.1616569817803;
 Wed, 24 Mar 2021 00:10:17 -0700 (PDT)
MIME-Version: 1.0
References: <20210323125337.1783611-1-arnd@kernel.org>
In-Reply-To: <20210323125337.1783611-1-arnd@kernel.org>
From:   Sunil Kovvuri <sunil.kovvuri@gmail.com>
Date:   Wed, 24 Mar 2021 12:40:05 +0530
Message-ID: <CA+sq2Cd1a10Wj4FXZpA8Pkemf8Cy=iUMy_OjJ0U5TC=_28PDgQ@mail.gmail.com>
Subject: Re: [PATCH net-next] octeontx2: fix -Wnonnull warning
To:     Arnd Bergmann <arnd@kernel.org>
Cc:     Sunil Goutham <sgoutham@marvell.com>,
        Linu Cherian <lcherian@marvell.com>,
        Geetha sowjanya <gakula@marvell.com>,
        Jerin Jacob <jerinj@marvell.com>,
        hariprasad <hkelam@marvell.com>,
        Subbaraya Sundeep <sbhatta@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Christina Jacob <cjacob@marvell.com>,
        Zyta Szpak <zyta@marvell.com>,
        Colin Ian King <colin.king@canonical.com>,
        Rakesh Babu <rsaladi2@marvell.com>,
        Linux Netdev List <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 23, 2021 at 6:26 PM Arnd Bergmann <arnd@kernel.org> wrote:
>
> From: Arnd Bergmann <arnd@arndb.de>
>
> When compile testing this driver on a platform on which probe() is
> known to fail at compile time, gcc warns about the cgx_lmactype_string[]
> array being uninitialized:
>
> In function 'strncpy',
>     inlined from 'link_status_user_format' at /git/arm-soc/drivers/net/ethernet/marvell/octeontx2/af/cgx.c:838:2,
>     inlined from 'cgx_link_change_handler' at /git/arm-soc/drivers/net/ethernet/marvell/octeontx2/af/cgx.c:853:2:
> include/linux/fortify-string.h:27:30: error: argument 2 null where non-null expected [-Werror=nonnull]
>    27 | #define __underlying_strncpy __builtin_strncpy
>
> Address this by turning the runtime initialization into a fixed array,
> which should also produce better code.
>
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
>  .../net/ethernet/marvell/octeontx2/af/cgx.c   | 60 +++++++++----------
>  1 file changed, 28 insertions(+), 32 deletions(-)
>
> diff --git a/drivers/net/ethernet/marvell/octeontx2/af/cgx.c b/drivers/net/ethernet/marvell/octeontx2/af/cgx.c
> index 9caa375d01b1..ea5a033a1d0b 100644
> --- a/drivers/net/ethernet/marvell/octeontx2/af/cgx.c
> +++ b/drivers/net/ethernet/marvell/octeontx2/af/cgx.c
> @@ -30,10 +30,35 @@
>  static LIST_HEAD(cgx_list);
>
>  /* Convert firmware speed encoding to user format(Mbps) */
> -static u32 cgx_speed_mbps[CGX_LINK_SPEED_MAX];
> +static const u32 cgx_speed_mbps[CGX_LINK_SPEED_MAX] = {
> +       [CGX_LINK_NONE] = 0,
> +       [CGX_LINK_10M] = 10,
> +       [CGX_LINK_100M] = 100,
> +       [CGX_LINK_1G] = 1000,
> +       [CGX_LINK_2HG] = 2500,
> +       [CGX_LINK_5G] = 5000,
> +       [CGX_LINK_10G] = 10000,
> +       [CGX_LINK_20G] = 20000,
> +       [CGX_LINK_25G] = 25000,
> +       [CGX_LINK_40G] = 40000,
> +       [CGX_LINK_50G] = 50000,
> +       [CGX_LINK_80G] = 80000,
> +       [CGX_LINK_100G] = 100000,
> +};
>
>  /* Convert firmware lmac type encoding to string */
> -static char *cgx_lmactype_string[LMAC_MODE_MAX];
> +static const char *cgx_lmactype_string[LMAC_MODE_MAX] = {
> +       [LMAC_MODE_SGMII] = "SGMII",
> +       [LMAC_MODE_XAUI] = "XAUI",
> +       [LMAC_MODE_RXAUI] = "RXAUI",
> +       [LMAC_MODE_10G_R] = "10G_R",
> +       [LMAC_MODE_40G_R] = "40G_R",
> +       [LMAC_MODE_QSGMII] = "QSGMII",
> +       [LMAC_MODE_25G_R] = "25G_R",
> +       [LMAC_MODE_50G_R] = "50G_R",
> +       [LMAC_MODE_100G_R] = "100G_R",
> +       [LMAC_MODE_USXGMII] = "USXGMII",
> +};
>
>  /* CGX PHY management internal APIs */
>  static int cgx_fwi_link_change(struct cgx *cgx, int lmac_id, bool en);
> @@ -657,34 +682,6 @@ int cgx_fwi_cmd_generic(u64 req, u64 *resp, struct cgx *cgx, int lmac_id)
>         return err;
>  }
>
> -static inline void cgx_link_usertable_init(void)
> -{
> -       cgx_speed_mbps[CGX_LINK_NONE] = 0;
> -       cgx_speed_mbps[CGX_LINK_10M] = 10;
> -       cgx_speed_mbps[CGX_LINK_100M] = 100;
> -       cgx_speed_mbps[CGX_LINK_1G] = 1000;
> -       cgx_speed_mbps[CGX_LINK_2HG] = 2500;
> -       cgx_speed_mbps[CGX_LINK_5G] = 5000;
> -       cgx_speed_mbps[CGX_LINK_10G] = 10000;
> -       cgx_speed_mbps[CGX_LINK_20G] = 20000;
> -       cgx_speed_mbps[CGX_LINK_25G] = 25000;
> -       cgx_speed_mbps[CGX_LINK_40G] = 40000;
> -       cgx_speed_mbps[CGX_LINK_50G] = 50000;
> -       cgx_speed_mbps[CGX_LINK_80G] = 80000;
> -       cgx_speed_mbps[CGX_LINK_100G] = 100000;
> -
> -       cgx_lmactype_string[LMAC_MODE_SGMII] = "SGMII";
> -       cgx_lmactype_string[LMAC_MODE_XAUI] = "XAUI";
> -       cgx_lmactype_string[LMAC_MODE_RXAUI] = "RXAUI";
> -       cgx_lmactype_string[LMAC_MODE_10G_R] = "10G_R";
> -       cgx_lmactype_string[LMAC_MODE_40G_R] = "40G_R";
> -       cgx_lmactype_string[LMAC_MODE_QSGMII] = "QSGMII";
> -       cgx_lmactype_string[LMAC_MODE_25G_R] = "25G_R";
> -       cgx_lmactype_string[LMAC_MODE_50G_R] = "50G_R";
> -       cgx_lmactype_string[LMAC_MODE_100G_R] = "100G_R";
> -       cgx_lmactype_string[LMAC_MODE_USXGMII] = "USXGMII";
> -}
> -
>  static int cgx_link_usertable_index_map(int speed)
>  {
>         switch (speed) {
> @@ -826,7 +823,7 @@ static inline void link_status_user_format(u64 lstat,
>                                            struct cgx_link_user_info *linfo,
>                                            struct cgx *cgx, u8 lmac_id)
>  {
> -       char *lmac_string;
> +       const char *lmac_string;
>
>         linfo->link_up = FIELD_GET(RESP_LINKSTAT_UP, lstat);
>         linfo->full_duplex = FIELD_GET(RESP_LINKSTAT_FDUPLEX, lstat);
> @@ -1375,7 +1372,6 @@ static int cgx_probe(struct pci_dev *pdev, const struct pci_device_id *id)
>
>         list_add(&cgx->cgx_list, &cgx_list);
>
> -       cgx_link_usertable_init();
>
>         cgx_populate_features(cgx);
>
> --
> 2.29.2
>

Looks good to me, thanks for the fix.

Acked-by: Sunil Goutham <sgoutham@marvell.com>
