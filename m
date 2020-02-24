Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7C33D16AE7D
	for <lists+netdev@lfdr.de>; Mon, 24 Feb 2020 19:15:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727940AbgBXSPt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Feb 2020 13:15:49 -0500
Received: from mail-pj1-f68.google.com ([209.85.216.68]:50524 "EHLO
        mail-pj1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726208AbgBXSPt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Feb 2020 13:15:49 -0500
Received: by mail-pj1-f68.google.com with SMTP id r67so108930pjb.0;
        Mon, 24 Feb 2020 10:15:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=brxB6nCVv+i2GwW72Eq2fyarSjv5ai+2kowRw2SjOU8=;
        b=ouLsOvGqngOPnCX+NoCeZeOcq4G8jRayZietQRdBBmgLWMHq2prNQiPPByuBN+pFho
         WJV5sx+jYbwLbHGVzP8A0AqeARIAyjNGs55zXn9veB1jrD6XZ02YGcDsKx6hzwkd+4hw
         NeVlmYuIz+/D/3IXbZvwooRnNhFFdI8LdwkTzDefnmAwM+ZLKAOuuZg2lT9aS2rwypVX
         On+vtpTJ49G6KXdfg+m4jqJV4D5Rfr9Szs43CvChSIbXvR9aaYsc0XFpiEyfEvgHAQjA
         pNwQSzQtFLAAs2+efXjcG+AgamIslHnI6cwPu8o/40uInAaUgU5T9/l/27ZwkCUdlJA6
         fu1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=brxB6nCVv+i2GwW72Eq2fyarSjv5ai+2kowRw2SjOU8=;
        b=kb9RQQakbz+fC+NV6M81RKwmCOHolwiK2RvWb9A5SIjc8JX326WG4hSmIuV8i11xaN
         JorkVaynpYe2z1TJDsszJbC4KD8Qb9C4+bCy2T7/Bd1SYfqxpNEJhPRZFzh2Qh1LwpBC
         A6koC2t3sQ693sSgpbwBIVO0HAwC3tCSzVHW048NYNomqFRn/ONvc1GDAHfkQIOc7JCl
         xVSWFGLb7v4hCYtar6o9PrfHqaP9BNKOFPu0H0LZkLnNpbuGxYGEFCJnrvczSDz/a9Ge
         yfKogm7sh2ZtIzhyNPG3nAXdlClD6cAAxKMOm4JpOnf1mmewWHLn+0cSgKPnlcBzErYm
         S2DQ==
X-Gm-Message-State: APjAAAWtni8QbPYaH6mZETQjgEPM908/15Cj3EGJxml8MC4npxMuEhu8
        JvFZeklAyo1sp0Jig86WlOu+Qj4/AF3r+aVmSZg=
X-Google-Smtp-Source: APXvYqy/xKyh4Es8oCnQr3N2M/8mM1I4KcLcr+jhkxUygwPZHZAtShiUO3SlywSEJ02eRrDniadWuFWmpWVn7bqmLU8=
X-Received: by 2002:a17:902:bd43:: with SMTP id b3mr47960058plx.230.1582568148037;
 Mon, 24 Feb 2020 10:15:48 -0800 (PST)
MIME-Version: 1.0
References: <20200224085311.460338-1-leon@kernel.org> <20200224085311.460338-19-leon@kernel.org>
In-Reply-To: <20200224085311.460338-19-leon@kernel.org>
From:   Chris Snook <chris.snook@gmail.com>
Date:   Mon, 24 Feb 2020 10:15:36 -0800
Message-ID: <CAMXMK6um=B+bL0vjL-65chjEvfNoU0qfbCAwDnRSD_18_Z5ODA@mail.gmail.com>
Subject: Re: [PATCH net-next v1 18/18] net/atheros: Clean atheros code from
 driver version
To:     Leon Romanovsky <leon@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Leon Romanovsky <leonro@mellanox.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Keyur Chudgar <keyur@os.amperecomputing.com>,
        Don Fry <pcnet32@frontier.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Jay Vosburgh <j.vosburgh@gmail.com>, linux-acenic@sunsite.dk,
        Maxime Ripard <mripard@kernel.org>,
        Heiko Stuebner <heiko@sntech.de>,
        Mark Einon <mark.einon@gmail.com>,
        linux-rockchip@lists.infradead.org,
        Iyappan Subramanian <iyappan@os.amperecomputing.com>,
        Igor Russkikh <irusskikh@marvell.com>,
        David Dillow <dave@thedillows.org>,
        Netanel Belgazal <netanel@amazon.com>,
        Quan Nguyen <quan@os.amperecomputing.com>,
        Jay Cliburn <jcliburn@gmail.com>,
        Lino Sanfilippo <LinoSanfilippo@gmx.de>,
        linux-arm-kernel@lists.infradead.org,
        Andreas Larsson <andreas@gaisler.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        netdev <netdev@vger.kernel.org>,
        Thor Thayer <thor.thayer@linux.intel.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Ion Badulescu <ionut@badula.org>,
        Arthur Kiyanovski <akiyano@amazon.com>,
        Jes Sorensen <jes@trained-monkey.org>,
        nios2-dev@lists.rocketboards.org, Chen-Yu Tsai <wens@csie.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Acked-by: Chris Snook <chris.snook@gmail.com>

On Mon, Feb 24, 2020 at 12:54 AM Leon Romanovsky <leon@kernel.org> wrote:
>
> From: Leon Romanovsky <leonro@mellanox.com>
>
> Use linux kernel version for ethtool and module versions.
>
> Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
> ---
>  drivers/net/ethernet/atheros/atl1c/atl1c.h         |  1 -
>  drivers/net/ethernet/atheros/atl1c/atl1c_ethtool.c |  2 --
>  drivers/net/ethernet/atheros/atl1c/atl1c_main.c    |  5 -----
>  drivers/net/ethernet/atheros/atl1e/atl1e.h         |  1 -
>  drivers/net/ethernet/atheros/atl1e/atl1e_ethtool.c |  2 --
>  drivers/net/ethernet/atheros/atl1e/atl1e_main.c    |  4 ----
>  drivers/net/ethernet/atheros/atlx/atl1.c           |  6 ------
>  drivers/net/ethernet/atheros/atlx/atl2.c           | 10 ----------
>  8 files changed, 31 deletions(-)
>
> diff --git a/drivers/net/ethernet/atheros/atl1c/atl1c.h b/drivers/net/ethernet/atheros/atl1c/atl1c.h
> index 60b2febd7315..a0562a90fb6d 100644
> --- a/drivers/net/ethernet/atheros/atl1c/atl1c.h
> +++ b/drivers/net/ethernet/atheros/atl1c/atl1c.h
> @@ -583,7 +583,6 @@ struct atl1c_adapter {
>                 readl(((a)->hw_addr + reg) + ((offset) << 2)))
>
>  extern char atl1c_driver_name[];
> -extern char atl1c_driver_version[];
>
>  void atl1c_reinit_locked(struct atl1c_adapter *adapter);
>  s32 atl1c_reset_hw(struct atl1c_hw *hw);
> diff --git a/drivers/net/ethernet/atheros/atl1c/atl1c_ethtool.c b/drivers/net/ethernet/atheros/atl1c/atl1c_ethtool.c
> index b5a70a36fa04..e2eb7b8c63a0 100644
> --- a/drivers/net/ethernet/atheros/atl1c/atl1c_ethtool.c
> +++ b/drivers/net/ethernet/atheros/atl1c/atl1c_ethtool.c
> @@ -221,8 +221,6 @@ static void atl1c_get_drvinfo(struct net_device *netdev,
>         struct atl1c_adapter *adapter = netdev_priv(netdev);
>
>         strlcpy(drvinfo->driver,  atl1c_driver_name, sizeof(drvinfo->driver));
> -       strlcpy(drvinfo->version, atl1c_driver_version,
> -               sizeof(drvinfo->version));
>         strlcpy(drvinfo->bus_info, pci_name(adapter->pdev),
>                 sizeof(drvinfo->bus_info));
>  }
> diff --git a/drivers/net/ethernet/atheros/atl1c/atl1c_main.c b/drivers/net/ethernet/atheros/atl1c/atl1c_main.c
> index 0d67b951c0b2..00bd7bd55794 100644
> --- a/drivers/net/ethernet/atheros/atl1c/atl1c_main.c
> +++ b/drivers/net/ethernet/atheros/atl1c/atl1c_main.c
> @@ -8,9 +8,7 @@
>
>  #include "atl1c.h"
>
> -#define ATL1C_DRV_VERSION "1.0.1.1-NAPI"
>  char atl1c_driver_name[] = "atl1c";
> -char atl1c_driver_version[] = ATL1C_DRV_VERSION;
>
>  /*
>   * atl1c_pci_tbl - PCI Device ID Table
> @@ -37,7 +35,6 @@ MODULE_AUTHOR("Jie Yang");
>  MODULE_AUTHOR("Qualcomm Atheros Inc., <nic-devel@qualcomm.com>");
>  MODULE_DESCRIPTION("Qualcomm Atheros 100/1000M Ethernet Network Driver");
>  MODULE_LICENSE("GPL");
> -MODULE_VERSION(ATL1C_DRV_VERSION);
>
>  static int atl1c_stop_mac(struct atl1c_hw *hw);
>  static void atl1c_disable_l0s_l1(struct atl1c_hw *hw);
> @@ -2642,8 +2639,6 @@ static int atl1c_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
>                 goto err_register;
>         }
>
> -       if (netif_msg_probe(adapter))
> -               dev_info(&pdev->dev, "version %s\n", ATL1C_DRV_VERSION);
>         cards_found++;
>         return 0;
>
> diff --git a/drivers/net/ethernet/atheros/atl1e/atl1e.h b/drivers/net/ethernet/atheros/atl1e/atl1e.h
> index e9893da50995..9fcad783c939 100644
> --- a/drivers/net/ethernet/atheros/atl1e/atl1e.h
> +++ b/drivers/net/ethernet/atheros/atl1e/atl1e.h
> @@ -482,7 +482,6 @@ struct atl1e_adapter {
>                 readl(((a)->hw_addr + reg) + ((offset) << 2)))
>
>  extern char atl1e_driver_name[];
> -extern char atl1e_driver_version[];
>
>  void atl1e_check_options(struct atl1e_adapter *adapter);
>  int atl1e_up(struct atl1e_adapter *adapter);
> diff --git a/drivers/net/ethernet/atheros/atl1e/atl1e_ethtool.c b/drivers/net/ethernet/atheros/atl1e/atl1e_ethtool.c
> index c6b9e7ea8e38..0cbde352d1ba 100644
> --- a/drivers/net/ethernet/atheros/atl1e/atl1e_ethtool.c
> +++ b/drivers/net/ethernet/atheros/atl1e/atl1e_ethtool.c
> @@ -307,8 +307,6 @@ static void atl1e_get_drvinfo(struct net_device *netdev,
>         struct atl1e_adapter *adapter = netdev_priv(netdev);
>
>         strlcpy(drvinfo->driver,  atl1e_driver_name, sizeof(drvinfo->driver));
> -       strlcpy(drvinfo->version, atl1e_driver_version,
> -               sizeof(drvinfo->version));
>         strlcpy(drvinfo->fw_version, "L1e", sizeof(drvinfo->fw_version));
>         strlcpy(drvinfo->bus_info, pci_name(adapter->pdev),
>                 sizeof(drvinfo->bus_info));
> diff --git a/drivers/net/ethernet/atheros/atl1e/atl1e_main.c b/drivers/net/ethernet/atheros/atl1e/atl1e_main.c
> index e0d89942d537..223ef846123e 100644
> --- a/drivers/net/ethernet/atheros/atl1e/atl1e_main.c
> +++ b/drivers/net/ethernet/atheros/atl1e/atl1e_main.c
> @@ -8,10 +8,7 @@
>
>  #include "atl1e.h"
>
> -#define DRV_VERSION "1.0.0.7-NAPI"
> -
>  char atl1e_driver_name[] = "ATL1E";
> -char atl1e_driver_version[] = DRV_VERSION;
>  #define PCI_DEVICE_ID_ATTANSIC_L1E      0x1026
>  /*
>   * atl1e_pci_tbl - PCI Device ID Table
> @@ -33,7 +30,6 @@ MODULE_DEVICE_TABLE(pci, atl1e_pci_tbl);
>  MODULE_AUTHOR("Atheros Corporation, <xiong.huang@atheros.com>, Jie Yang <jie.yang@atheros.com>");
>  MODULE_DESCRIPTION("Atheros 1000M Ethernet Network Driver");
>  MODULE_LICENSE("GPL");
> -MODULE_VERSION(DRV_VERSION);
>
>  static void atl1e_setup_mac_ctrl(struct atl1e_adapter *adapter);
>
> diff --git a/drivers/net/ethernet/atheros/atlx/atl1.c b/drivers/net/ethernet/atheros/atlx/atl1.c
> index b498fd6a47d0..271e7034fa70 100644
> --- a/drivers/net/ethernet/atheros/atlx/atl1.c
> +++ b/drivers/net/ethernet/atheros/atlx/atl1.c
> @@ -65,12 +65,10 @@
>
>  #include "atl1.h"
>
> -#define ATLX_DRIVER_VERSION "2.1.3"
>  MODULE_AUTHOR("Xiong Huang <xiong.huang@atheros.com>, "
>               "Chris Snook <csnook@redhat.com>, "
>               "Jay Cliburn <jcliburn@gmail.com>");
>  MODULE_LICENSE("GPL");
> -MODULE_VERSION(ATLX_DRIVER_VERSION);
>
>  /* Temporary hack for merging atl1 and atl2 */
>  #include "atlx.c"
> @@ -2965,8 +2963,6 @@ static int atl1_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
>         /* get device revision number */
>         adapter->hw.dev_rev = ioread16(adapter->hw.hw_addr +
>                 (REG_MASTER_CTRL + 2));
> -       if (netif_msg_probe(adapter))
> -               dev_info(&pdev->dev, "version %s\n", ATLX_DRIVER_VERSION);
>
>         /* set default ring resource counts */
>         adapter->rfd_ring.count = adapter->rrd_ring.count = ATL1_DEFAULT_RFD;
> @@ -3344,8 +3340,6 @@ static void atl1_get_drvinfo(struct net_device *netdev,
>         struct atl1_adapter *adapter = netdev_priv(netdev);
>
>         strlcpy(drvinfo->driver, ATLX_DRIVER_NAME, sizeof(drvinfo->driver));
> -       strlcpy(drvinfo->version, ATLX_DRIVER_VERSION,
> -               sizeof(drvinfo->version));
>         strlcpy(drvinfo->bus_info, pci_name(adapter->pdev),
>                 sizeof(drvinfo->bus_info));
>  }
> diff --git a/drivers/net/ethernet/atheros/atlx/atl2.c b/drivers/net/ethernet/atheros/atlx/atl2.c
> index b81a4e0c5b57..7c52b92b599d 100644
> --- a/drivers/net/ethernet/atheros/atlx/atl2.c
> +++ b/drivers/net/ethernet/atheros/atlx/atl2.c
> @@ -36,18 +36,13 @@
>
>  #include "atl2.h"
>
> -#define ATL2_DRV_VERSION "2.2.3"
> -
>  static const char atl2_driver_name[] = "atl2";
>  static const char atl2_driver_string[] = "Atheros(R) L2 Ethernet Driver";
> -static const char atl2_copyright[] = "Copyright (c) 2007 Atheros Corporation.";
> -static const char atl2_driver_version[] = ATL2_DRV_VERSION;
>  static const struct ethtool_ops atl2_ethtool_ops;
>
>  MODULE_AUTHOR("Atheros Corporation <xiong.huang@atheros.com>, Chris Snook <csnook@redhat.com>");
>  MODULE_DESCRIPTION("Atheros Fast Ethernet Network Driver");
>  MODULE_LICENSE("GPL");
> -MODULE_VERSION(ATL2_DRV_VERSION);
>
>  /*
>   * atl2_pci_tbl - PCI Device ID Table
> @@ -1688,9 +1683,6 @@ static struct pci_driver atl2_driver = {
>   */
>  static int __init atl2_init_module(void)
>  {
> -       printk(KERN_INFO "%s - version %s\n", atl2_driver_string,
> -               atl2_driver_version);
> -       printk(KERN_INFO "%s\n", atl2_copyright);
>         return pci_register_driver(&atl2_driver);
>  }
>  module_init(atl2_init_module);
> @@ -2011,8 +2003,6 @@ static void atl2_get_drvinfo(struct net_device *netdev,
>         struct atl2_adapter *adapter = netdev_priv(netdev);
>
>         strlcpy(drvinfo->driver,  atl2_driver_name, sizeof(drvinfo->driver));
> -       strlcpy(drvinfo->version, atl2_driver_version,
> -               sizeof(drvinfo->version));
>         strlcpy(drvinfo->fw_version, "L2", sizeof(drvinfo->fw_version));
>         strlcpy(drvinfo->bus_info, pci_name(adapter->pdev),
>                 sizeof(drvinfo->bus_info));
> --
> 2.24.1
>
