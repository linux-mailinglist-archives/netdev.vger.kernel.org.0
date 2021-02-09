Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB9F8314517
	for <lists+netdev@lfdr.de>; Tue,  9 Feb 2021 01:51:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230405AbhBIAuY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Feb 2021 19:50:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229618AbhBIAuV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Feb 2021 19:50:21 -0500
Received: from mail-il1-x130.google.com (mail-il1-x130.google.com [IPv6:2607:f8b0:4864:20::130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA6CDC061788
        for <netdev@vger.kernel.org>; Mon,  8 Feb 2021 16:49:40 -0800 (PST)
Received: by mail-il1-x130.google.com with SMTP id z18so14588834ile.9
        for <netdev@vger.kernel.org>; Mon, 08 Feb 2021 16:49:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Rd7sUZoCfEeMwp4K0JvICSj9RceJe7m9YxLsT9n7Ku4=;
        b=ocyKsUwQhs6CQLR8xwRjifxmzutdnPDvLnQFtrcnzXblMLgZXrMqjdXQVxvkNORFaJ
         KS7S3Qppsl9Wj+nd7XxhcUsAaD2Z5aqnKyjerbLP+3zP56aSPncpcBJLrxvbG+YhCV1B
         vjE7JShlUhyyOP7zM2sPIXjBIYqp+tcTdBnkRuhYJl6GHaTsq51Nh7MJr4Om8hVeepsS
         pS3py7L7LHzybIEZ5VXwBLSkt8623YV6d1HQub0/FKTwu2qdnum712WGCN3Cmr2+5KZE
         nmHHCzeG1p3Rc8ddjWpO6bRTPY/eMKQUF9ivtRCulEwC0nkD2OgF+xkfuDhAa3vV1V/9
         X6gg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Rd7sUZoCfEeMwp4K0JvICSj9RceJe7m9YxLsT9n7Ku4=;
        b=cFVzmiWDXCKVLV3jboSkjqdXVKvIQaPb2fv14ylcab4O5jmzBd86KK/BViVsa5eSsg
         QpnTzv+RojlA8gyXDMTDzgzE2mevPoO4azClhjaSEsiapF7kiTZXryVOuZ2A/k3IKgnd
         tIXKAkUkVwoUYB5RaPHaGtn6BdGYlW4XIw02GGSCjhonPDPshvcV08NQYtqP+BJG6HAq
         q3ShKlvjpXr3AeFN+yHV9en+GxGMplZ3RA3sLvNF4DJybICuYX8CKl/g6QbYjEJRrO4e
         4cWIAEIeP7jcTEtZyQdocUPZ2Ok3ylUaq8G+5Ao0IupY8ioq6kz/haciaD3g4M4TvskU
         UVmg==
X-Gm-Message-State: AOAM531gEbEoP7Ydp5zD93KmsZRJ2oOPZ8ncysTyp+H6N4E4kD5SB4wF
        5x8R18XGFaOew4csZWe9AQwRH8gumHtFONYiqS8=
X-Google-Smtp-Source: ABdhPJySEelkK3PyJP0Ey4nAk1hsSDo/6oTDQYHoLA0YlEOr5xiUiEuO/+nnwP9cSwEOrfWcOo1kWz++7SpH03GMGcs=
X-Received: by 2002:a05:6e02:2196:: with SMTP id j22mr17793346ila.64.1612831780224;
 Mon, 08 Feb 2021 16:49:40 -0800 (PST)
MIME-Version: 1.0
References: <1612826906-25356-1-git-send-email-rahul.lakkireddy@chelsio.com>
In-Reply-To: <1612826906-25356-1-git-send-email-rahul.lakkireddy@chelsio.com>
From:   Alexander Duyck <alexander.duyck@gmail.com>
Date:   Mon, 8 Feb 2021 16:49:29 -0800
Message-ID: <CAKgT0UfHm74LvNX3Uh00Kt6=H5+i=aE2heRqGa7o69mWB8UjGg@mail.gmail.com>
Subject: Re: [PATCH net-next] cxgb4: collect serial config version from register
To:     Rahul Lakkireddy <rahul.lakkireddy@chelsio.com>
Cc:     Netdev <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Raju Rangoju <rajur@chelsio.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 8, 2021 at 3:48 PM Rahul Lakkireddy
<rahul.lakkireddy@chelsio.com> wrote:
>
> Collect serial config version information directly from an internal
> register, instead of explicitly resizing VPD.
>
> Signed-off-by: Rahul Lakkireddy <rahul.lakkireddy@chelsio.com>
> ---
>  .../net/ethernet/chelsio/cxgb4/cudbg_entity.h |  3 ---
>  .../net/ethernet/chelsio/cxgb4/cudbg_lib.c    | 24 +++----------------
>  drivers/net/ethernet/chelsio/cxgb4/t4_regs.h  |  2 ++
>  3 files changed, 5 insertions(+), 24 deletions(-)
>
> diff --git a/drivers/net/ethernet/chelsio/cxgb4/cudbg_entity.h b/drivers/net/ethernet/chelsio/cxgb4/cudbg_entity.h
> index 876f90e5795e..d5218e74284c 100644
> --- a/drivers/net/ethernet/chelsio/cxgb4/cudbg_entity.h
> +++ b/drivers/net/ethernet/chelsio/cxgb4/cudbg_entity.h
> @@ -220,9 +220,6 @@ struct cudbg_mps_tcam {
>         u8 reserved[2];
>  };
>
> -#define CUDBG_VPD_PF_SIZE 0x800
> -#define CUDBG_SCFG_VER_ADDR 0x06
> -#define CUDBG_SCFG_VER_LEN 4
>  #define CUDBG_VPD_VER_ADDR 0x18c7
>  #define CUDBG_VPD_VER_LEN 2
>
> diff --git a/drivers/net/ethernet/chelsio/cxgb4/cudbg_lib.c b/drivers/net/ethernet/chelsio/cxgb4/cudbg_lib.c
> index 75474f810249..6c85a10f465c 100644
> --- a/drivers/net/ethernet/chelsio/cxgb4/cudbg_lib.c
> +++ b/drivers/net/ethernet/chelsio/cxgb4/cudbg_lib.c
> @@ -2686,10 +2686,10 @@ int cudbg_collect_vpd_data(struct cudbg_init *pdbg_init,
>         struct adapter *padap = pdbg_init->adap;
>         struct cudbg_buffer temp_buff = { 0 };
>         char vpd_str[CUDBG_VPD_VER_LEN + 1];
> -       u32 scfg_vers, vpd_vers, fw_vers;
>         struct cudbg_vpd_data *vpd_data;
>         struct vpd_params vpd = { 0 };
> -       int rc, ret;
> +       u32 vpd_vers, fw_vers;
> +       int rc;
>
>         rc = t4_get_raw_vpd_params(padap, &vpd);
>         if (rc)
> @@ -2699,24 +2699,6 @@ int cudbg_collect_vpd_data(struct cudbg_init *pdbg_init,
>         if (rc)
>                 return rc;
>
> -       /* Serial Configuration Version is located beyond the PF's vpd size.
> -        * Temporarily give access to entire EEPROM to get it.
> -        */
> -       rc = pci_set_vpd_size(padap->pdev, EEPROMVSIZE);
> -       if (rc < 0)
> -               return rc;
> -
> -       ret = cudbg_read_vpd_reg(padap, CUDBG_SCFG_VER_ADDR, CUDBG_SCFG_VER_LEN,
> -                                &scfg_vers);
> -
> -       /* Restore back to original PF's vpd size */
> -       rc = pci_set_vpd_size(padap->pdev, CUDBG_VPD_PF_SIZE);
> -       if (rc < 0)
> -               return rc;
> -
> -       if (ret)
> -               return ret;
> -
>         rc = cudbg_read_vpd_reg(padap, CUDBG_VPD_VER_ADDR, CUDBG_VPD_VER_LEN,
>                                 vpd_str);
>         if (rc)
> @@ -2737,7 +2719,7 @@ int cudbg_collect_vpd_data(struct cudbg_init *pdbg_init,
>         memcpy(vpd_data->bn, vpd.pn, PN_LEN + 1);
>         memcpy(vpd_data->na, vpd.na, MACADDR_LEN + 1);
>         memcpy(vpd_data->mn, vpd.id, ID_LEN + 1);
> -       vpd_data->scfg_vers = scfg_vers;
> +       vpd_data->scfg_vers = t4_read_reg(padap, PCIE_STATIC_SPARE2_A);
>         vpd_data->vpd_vers = vpd_vers;
>         vpd_data->fw_major = FW_HDR_FW_VER_MAJOR_G(fw_vers);
>         vpd_data->fw_minor = FW_HDR_FW_VER_MINOR_G(fw_vers);

All of the above looks good to me.

> diff --git a/drivers/net/ethernet/chelsio/cxgb4/t4_regs.h b/drivers/net/ethernet/chelsio/cxgb4/t4_regs.h
> index b11a172b5174..2d7bb8b66a3e 100644
> --- a/drivers/net/ethernet/chelsio/cxgb4/t4_regs.h
> +++ b/drivers/net/ethernet/chelsio/cxgb4/t4_regs.h
> @@ -884,6 +884,8 @@
>  #define TDUE_V(x) ((x) << TDUE_S)
>  #define TDUE_F    TDUE_V(1U)
>
> +#define PCIE_STATIC_SPARE2_A   0x5bfc
> +
>  /* registers for module MC */
>  #define MC_INT_CAUSE_A         0x7518
>  #define MC_P_INT_CAUSE_A       0x41318

I cannot say I am a fan of the naming. I assume that is the name of an
existing register that someone claimed to use to store the serial
config version? A comment explaining what all is stored in the
register might be useful since the name doesn't imply anything related
to a serial config version is stored there.
