Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 62FC742413D
	for <lists+netdev@lfdr.de>; Wed,  6 Oct 2021 17:23:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239000AbhJFPZW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Oct 2021 11:25:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231874AbhJFPZV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Oct 2021 11:25:21 -0400
Received: from mail-yb1-xb2c.google.com (mail-yb1-xb2c.google.com [IPv6:2607:f8b0:4864:20::b2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A2BAC061746
        for <netdev@vger.kernel.org>; Wed,  6 Oct 2021 08:23:29 -0700 (PDT)
Received: by mail-yb1-xb2c.google.com with SMTP id s64so6206013yba.11
        for <netdev@vger.kernel.org>; Wed, 06 Oct 2021 08:23:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=semihalf-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=BdYu75KIwFFaT2fZxQt0rwQxEQMnLwxxhAkEj+AC8E4=;
        b=eBav9hLBSy9kDDtAt/g5R6hBA9ActIP47dVAtl/pw+M+KbjJoPF+dLJvyO8hvlcqpK
         M2EJGmRo0457ctGcj0xxpGF2KDlIcHiox/mRnzCXEPYWXX6WMXZRaAE0GeTMWfFrwo4A
         +juqqT8i9U2QWnh7aRzIQVBQt7Rx1sRQG5x/DI7DUaUtV7iK5BmuvUgd+4oDmVTukooZ
         E0iaDIfRRW4hsXtxfwLR40gxg1qz7Rag9woCmE26qC923FDMj/qKDtMru0h0J9JEtrTr
         lQ0cfCHEf/mUCzrKeKgS31XUGUsZZP/+Q74Pf4HvZ+xlK5f7/uMXzByF0VCnLWnmB/qS
         pCcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=BdYu75KIwFFaT2fZxQt0rwQxEQMnLwxxhAkEj+AC8E4=;
        b=sBQio3mi1shtg4AL2pKbBtly0gsn7s96PUJQzbKhbL9wXOC+m/OWUi2w0IMgFvvHEo
         mNWe4itKcHREKxs5lq7UkkdQao55OTtErxBIYnrUZ54rchxy6eXSz6myIbdFOMAt0kLM
         lbIJt8c7DEUn1JebqNX6eZOZLe97yQqMn1rXmsTWpZUyJukSCMFjkhKf/DowkWrhOnGF
         3+z0MhYx1PJyi48msXoytC/Sn1VxxaF8AYkt072Cvix7HUEAn0tS8vezK+K3rF4Ze6TF
         qVvi2ubwRKzlXJ2e78Plnk2Y0g2HEfxGd50eSG4NrcoPkGDuSa95Lfcl85At+PmTgONW
         4aRw==
X-Gm-Message-State: AOAM532KY++9dYNddlGCZqlu6tGHi2v366aWdqArgTtcjD3s+/UUeZbw
        eG9Ngo/sASTHX45oz3Z04c700Qp8X2MLm9YzIldsM1ShmU8=
X-Google-Smtp-Source: ABdhPJzehW+a5XLWTO/nIrbs/ozEbs+awpVBFxiXeEDZu52yjlxAHf+akSeO2w+o+4+l3erhw12eSSWF6OFI+RF+BWg=
X-Received: by 2002:a5b:f03:: with SMTP id x3mr29265065ybr.546.1633533808267;
 Wed, 06 Oct 2021 08:23:28 -0700 (PDT)
MIME-Version: 1.0
References: <20211006022444.3155482-1-kuba@kernel.org>
In-Reply-To: <20211006022444.3155482-1-kuba@kernel.org>
From:   Marcin Wojtas <mw@semihalf.com>
Date:   Wed, 6 Oct 2021 17:23:18 +0200
Message-ID: <CAPv3WKfUY-DbAaJPMn5F4QCGhooB+c5BVBGmis=Wuzton_CaWQ@mail.gmail.com>
Subject: Re: [RFC] fwnode: change the return type of mac address helpers
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>, saravanak@google.com,
        Andrew Lunn <andrew@lunn.ch>,
        Jeremy Linton <jeremy.linton@arm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

=C5=9Br., 6 pa=C5=BA 2021 o 04:25 Jakub Kicinski <kuba@kernel.org> napisa=
=C5=82(a):
>
> fwnode_get_mac_address() and device_get_mac_address()
> return a pointer to the buffer that was passed to them
> on success or NULL on failure. None of the callers
> care about the actual value, only if it's NULL or not.
>
> These semantics differ from of_get_mac_address() which
> returns an int so to avoid confusion make the device
> helpers return an errno.
>
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> --
> Full disclosure this resolves an obvious issue with
> device_get_ethdev_addr() returning a stack pointer.
> Which works, since no caller derefs the pointer but
> is obviously hard to condone.
> ---
>  drivers/base/property.c                       | 45 ++++++++++---------
>  drivers/net/ethernet/apm/xgene-v2/main.c      |  2 +-
>  .../net/ethernet/apm/xgene/xgene_enet_main.c  |  2 +-
>  .../net/ethernet/broadcom/genet/bcmgenet.c    |  2 +-
>  .../net/ethernet/cavium/thunder/thunder_bgx.c |  6 +--
>  drivers/net/ethernet/faraday/ftgmac100.c      |  4 +-
>  drivers/net/ethernet/hisilicon/hns/hns_enet.c |  2 +-
>  .../net/ethernet/marvell/mvpp2/mvpp2_main.c   |  2 +-
>  drivers/net/ethernet/microchip/enc28j60.c     |  2 +-
>  drivers/net/ethernet/qualcomm/emac/emac.c     |  2 +-
>  drivers/net/ethernet/socionext/netsec.c       |  8 ++--
>  include/linux/property.h                      |  7 ++-
>  12 files changed, 41 insertions(+), 43 deletions(-)
>
> diff --git a/drivers/base/property.c b/drivers/base/property.c
> index 1c8d4676addc..20c5d3a4ee6b 100644
> --- a/drivers/base/property.c
> +++ b/drivers/base/property.c
> @@ -935,15 +935,21 @@ int device_get_phy_mode(struct device *dev)
>  }
>  EXPORT_SYMBOL_GPL(device_get_phy_mode);
>
> -static void *fwnode_get_mac_addr(struct fwnode_handle *fwnode,
> -                                const char *name, char *addr,
> -                                int alen)
> +static int fwnode_get_mac_addr(struct fwnode_handle *fwnode,
> +                              const char *name, char *addr, int alen)
>  {
> -       int ret =3D fwnode_property_read_u8_array(fwnode, name, addr, ale=
n);
> +       int ret;
>
> -       if (ret =3D=3D 0 && alen =3D=3D ETH_ALEN && is_valid_ether_addr(a=
ddr))
> -               return addr;
> -       return NULL;
> +       if (alen !=3D ETH_ALEN)
> +               return -EINVAL;
> +
> +       ret =3D fwnode_property_read_u8_array(fwnode, name, addr, alen);
> +       if (ret)
> +               return ret;
> +
> +       if (!is_valid_ether_addr(addr))
> +               return -EINVAL;
> +       return 0;
>  }
>
>  /**
> @@ -969,19 +975,14 @@ static void *fwnode_get_mac_addr(struct fwnode_hand=
le *fwnode,
>   * In this case, the real MAC is in 'local-mac-address', and 'mac-addres=
s'
>   * exists but is all zeros.
>  */
> -void *fwnode_get_mac_address(struct fwnode_handle *fwnode, char *addr, i=
nt alen)
> +int fwnode_get_mac_address(struct fwnode_handle *fwnode, char *addr, int=
 alen)
>  {
> -       char *res;
> -
> -       res =3D fwnode_get_mac_addr(fwnode, "mac-address", addr, alen);
> -       if (res)
> -               return res;
> -
> -       res =3D fwnode_get_mac_addr(fwnode, "local-mac-address", addr, al=
en);
> -       if (res)
> -               return res;
> +       if (!fwnode_get_mac_addr(fwnode, "mac-address", addr, alen) ||
> +           !fwnode_get_mac_addr(fwnode, "local-mac-address", addr, alen)=
 ||
> +           !fwnode_get_mac_addr(fwnode, "address", addr, alen))
> +               return 0;
>
> -       return fwnode_get_mac_addr(fwnode, "address", addr, alen);
> +       return -ENOENT;
>  }
>  EXPORT_SYMBOL(fwnode_get_mac_address);
>
> @@ -991,7 +992,7 @@ EXPORT_SYMBOL(fwnode_get_mac_address);
>   * @addr:      Address of buffer to store the MAC in
>   * @alen:      Length of the buffer pointed to by addr, should be ETH_AL=
EN
>   */
> -void *device_get_mac_address(struct device *dev, char *addr, int alen)
> +int device_get_mac_address(struct device *dev, char *addr, int alen)
>  {
>         return fwnode_get_mac_address(dev_fwnode(dev), addr, alen);
>  }
> @@ -1005,13 +1006,13 @@ EXPORT_SYMBOL(device_get_mac_address);
>   * Wrapper around device_get_mac_address() which writes the address
>   * directly to netdev->dev_addr.
>   */
> -void *device_get_ethdev_addr(struct device *dev, struct net_device *netd=
ev)
> +int device_get_ethdev_addr(struct device *dev, struct net_device *netdev=
)
>  {
>         u8 addr[ETH_ALEN];
> -       void *ret;
> +       int ret;
>
>         ret =3D device_get_mac_address(dev, addr, ETH_ALEN);
> -       if (ret)
> +       if (!ret)
>                 eth_hw_addr_set(netdev, addr);
>         return ret;
>  }
> diff --git a/drivers/net/ethernet/apm/xgene-v2/main.c b/drivers/net/ether=
net/apm/xgene-v2/main.c
> index 119e488979f9..060265892401 100644
> --- a/drivers/net/ethernet/apm/xgene-v2/main.c
> +++ b/drivers/net/ethernet/apm/xgene-v2/main.c
> @@ -36,7 +36,7 @@ static int xge_get_resources(struct xge_pdata *pdata)
>                 return -ENOMEM;
>         }
>
> -       if (!device_get_ethdev_addr(dev, ndev))
> +       if (device_get_ethdev_addr(dev, ndev))
>                 eth_hw_addr_random(ndev);
>
>         memcpy(ndev->perm_addr, ndev->dev_addr, ndev->addr_len);
> diff --git a/drivers/net/ethernet/apm/xgene/xgene_enet_main.c b/drivers/n=
et/ethernet/apm/xgene/xgene_enet_main.c
> index 111cd88984c9..f69cc8c5c9b7 100644
> --- a/drivers/net/ethernet/apm/xgene/xgene_enet_main.c
> +++ b/drivers/net/ethernet/apm/xgene/xgene_enet_main.c
> @@ -1731,7 +1731,7 @@ static int xgene_enet_get_resources(struct xgene_en=
et_pdata *pdata)
>                 xgene_get_port_id_acpi(dev, pdata);
>  #endif
>
> -       if (!device_get_ethdev_addr(dev, ndev))
> +       if (device_get_ethdev_addr(dev, ndev))
>                 eth_hw_addr_random(ndev);
>
>         memcpy(ndev->perm_addr, ndev->dev_addr, ndev->addr_len);
> diff --git a/drivers/net/ethernet/broadcom/genet/bcmgenet.c b/drivers/net=
/ethernet/broadcom/genet/bcmgenet.c
> index 541763968201..c6fa5c773b3b 100644
> --- a/drivers/net/ethernet/broadcom/genet/bcmgenet.c
> +++ b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
> @@ -4084,7 +4084,7 @@ static int bcmgenet_probe(struct platform_device *p=
dev)
>         if (pd && !IS_ERR_OR_NULL(pd->mac_address))
>                 eth_hw_addr_set(dev, pd->mac_address);
>         else
> -               if (!device_get_ethdev_addr(&pdev->dev, dev))
> +               if (device_get_ethdev_addr(&pdev->dev, dev))
>                         if (has_acpi_companion(&pdev->dev))
>                                 bcmgenet_get_hw_addr(priv, dev->dev_addr)=
;
>
> diff --git a/drivers/net/ethernet/cavium/thunder/thunder_bgx.c b/drivers/=
net/ethernet/cavium/thunder/thunder_bgx.c
> index db66d4beb28a..77ce81633cdc 100644
> --- a/drivers/net/ethernet/cavium/thunder/thunder_bgx.c
> +++ b/drivers/net/ethernet/cavium/thunder/thunder_bgx.c
> @@ -1387,10 +1387,10 @@ static int acpi_get_mac_address(struct device *de=
v, struct acpi_device *adev,
>                                 u8 *dst)
>  {
>         u8 mac[ETH_ALEN];
> -       u8 *addr;
> +       int ret;
>
> -       addr =3D fwnode_get_mac_address(acpi_fwnode_handle(adev), mac, ET=
H_ALEN);
> -       if (!addr) {
> +       ret =3D fwnode_get_mac_address(acpi_fwnode_handle(adev), mac, ETH=
_ALEN);
> +       if (ret) {
>                 dev_err(dev, "MAC address invalid: %pM\n", mac);
>                 return -EINVAL;
>         }
> diff --git a/drivers/net/ethernet/faraday/ftgmac100.c b/drivers/net/ether=
net/faraday/ftgmac100.c
> index ab9267225573..8de9c99a18fb 100644
> --- a/drivers/net/ethernet/faraday/ftgmac100.c
> +++ b/drivers/net/ethernet/faraday/ftgmac100.c
> @@ -182,10 +182,8 @@ static void ftgmac100_initial_mac(struct ftgmac100 *=
priv)
>         u8 mac[ETH_ALEN];
>         unsigned int m;
>         unsigned int l;
> -       void *addr;
>
> -       addr =3D device_get_mac_address(priv->dev, mac, ETH_ALEN);
> -       if (addr) {
> +       if (!device_get_mac_address(priv->dev, mac, ETH_ALEN)) {
>                 eth_hw_addr_set(priv->netdev, mac);
>                 dev_info(priv->dev, "Read MAC address %pM from device tre=
e\n",
>                          mac);
> diff --git a/drivers/net/ethernet/hisilicon/hns/hns_enet.c b/drivers/net/=
ethernet/hisilicon/hns/hns_enet.c
> index f4ed877e16e9..c5e7475b0a60 100644
> --- a/drivers/net/ethernet/hisilicon/hns/hns_enet.c
> +++ b/drivers/net/ethernet/hisilicon/hns/hns_enet.c
> @@ -1212,7 +1212,7 @@ static void hns_init_mac_addr(struct net_device *nd=
ev)
>  {
>         struct hns_nic_priv *priv =3D netdev_priv(ndev);
>
> -       if (!device_get_ethdev_addr(priv->dev, ndev)) {
> +       if (device_get_ethdev_addr(priv->dev, ndev)) {
>                 eth_hw_addr_random(ndev);
>                 dev_warn(priv->dev, "No valid mac, use random mac %pM",
>                          ndev->dev_addr);
> diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c b/drivers/ne=
t/ethernet/marvell/mvpp2/mvpp2_main.c
> index 3197526455d9..b84f8b6fe9f4 100644
> --- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
> +++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
> @@ -6081,7 +6081,7 @@ static void mvpp2_port_copy_mac_addr(struct net_dev=
ice *dev, struct mvpp2 *priv,
>         char hw_mac_addr[ETH_ALEN] =3D {0};
>         char fw_mac_addr[ETH_ALEN];
>
> -       if (fwnode_get_mac_address(fwnode, fw_mac_addr, ETH_ALEN)) {
> +       if (!fwnode_get_mac_address(fwnode, fw_mac_addr, ETH_ALEN)) {
>                 *mac_from =3D "firmware node";
>                 eth_hw_addr_set(dev, fw_mac_addr);
>                 return;

I did not test it, but overall the change LGTM.

Best regards,
Marcin

> diff --git a/drivers/net/ethernet/microchip/enc28j60.c b/drivers/net/ethe=
rnet/microchip/enc28j60.c
> index bf77e8adffbf..fa62311d326a 100644
> --- a/drivers/net/ethernet/microchip/enc28j60.c
> +++ b/drivers/net/ethernet/microchip/enc28j60.c
> @@ -1572,7 +1572,7 @@ static int enc28j60_probe(struct spi_device *spi)
>                 goto error_irq;
>         }
>
> -       if (device_get_mac_address(&spi->dev, macaddr, sizeof(macaddr)))
> +       if (!device_get_mac_address(&spi->dev, macaddr, sizeof(macaddr)))
>                 eth_hw_addr_set(dev, macaddr);
>         else
>                 eth_hw_addr_random(dev);
> diff --git a/drivers/net/ethernet/qualcomm/emac/emac.c b/drivers/net/ethe=
rnet/qualcomm/emac/emac.c
> index fbfabfc5cc51..2e913508fbeb 100644
> --- a/drivers/net/ethernet/qualcomm/emac/emac.c
> +++ b/drivers/net/ethernet/qualcomm/emac/emac.c
> @@ -549,7 +549,7 @@ static int emac_probe_resources(struct platform_devic=
e *pdev,
>         int ret =3D 0;
>
>         /* get mac address */
> -       if (device_get_mac_address(&pdev->dev, maddr, ETH_ALEN))
> +       if (!device_get_mac_address(&pdev->dev, maddr, ETH_ALEN))
>                 eth_hw_addr_set(netdev, maddr);
>         else
>                 eth_hw_addr_random(netdev);
> diff --git a/drivers/net/ethernet/socionext/netsec.c b/drivers/net/ethern=
et/socionext/netsec.c
> index c7e56dc0a494..c4b92bfd00a7 100644
> --- a/drivers/net/ethernet/socionext/netsec.c
> +++ b/drivers/net/ethernet/socionext/netsec.c
> @@ -1978,10 +1978,10 @@ static int netsec_register_mdio(struct netsec_pri=
v *priv, u32 phy_addr)
>  static int netsec_probe(struct platform_device *pdev)
>  {
>         struct resource *mmio_res, *eeprom_res, *irq_res;
> -       u8 *mac, macbuf[ETH_ALEN];
>         struct netsec_priv *priv;
>         u32 hw_ver, phy_addr =3D 0;
>         struct net_device *ndev;
> +       u8 macbuf[ETH_ALEN];
>         int ret;
>
>         mmio_res =3D platform_get_resource(pdev, IORESOURCE_MEM, 0);
> @@ -2034,12 +2034,12 @@ static int netsec_probe(struct platform_device *p=
dev)
>                 goto free_ndev;
>         }
>
> -       mac =3D device_get_mac_address(&pdev->dev, macbuf, sizeof(macbuf)=
);
> -       if (mac)
> +       ret =3D device_get_mac_address(&pdev->dev, macbuf, sizeof(macbuf)=
);
> +       if (!ret)
>                 eth_hw_addr_set(ndev, mac);
>
>         if (priv->eeprom_base &&
> -           (!mac || !is_valid_ether_addr(ndev->dev_addr))) {
> +           (ret || !is_valid_ether_addr(ndev->dev_addr))) {
>                 void __iomem *macp =3D priv->eeprom_base +
>                                         NETSEC_EEPROM_MAC_ADDRESS;
>
> diff --git a/include/linux/property.h b/include/linux/property.h
> index 24dc4d2b9dbd..260594280e09 100644
> --- a/include/linux/property.h
> +++ b/include/linux/property.h
> @@ -390,12 +390,11 @@ const void *device_get_match_data(struct device *de=
v);
>
>  int device_get_phy_mode(struct device *dev);
>
> -void *device_get_mac_address(struct device *dev, char *addr, int alen);
> -void *device_get_ethdev_addr(struct device *dev, struct net_device *netd=
ev);
> +int device_get_mac_address(struct device *dev, char *addr, int alen);
> +int device_get_ethdev_addr(struct device *dev, struct net_device *netdev=
);
>
>  int fwnode_get_phy_mode(struct fwnode_handle *fwnode);
> -void *fwnode_get_mac_address(struct fwnode_handle *fwnode,
> -                            char *addr, int alen);
> +int fwnode_get_mac_address(struct fwnode_handle *fwnode, char *addr, int=
 alen);
>  struct fwnode_handle *fwnode_graph_get_next_endpoint(
>         const struct fwnode_handle *fwnode, struct fwnode_handle *prev);
>  struct fwnode_handle *
> --
> 2.31.1
>
