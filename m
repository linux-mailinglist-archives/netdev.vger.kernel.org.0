Return-Path: <netdev+bounces-4170-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id AE8B570B730
	for <lists+netdev@lfdr.de>; Mon, 22 May 2023 09:58:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 57D66280EA1
	for <lists+netdev@lfdr.de>; Mon, 22 May 2023 07:58:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7D37B63AE;
	Mon, 22 May 2023 07:58:22 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B82CEDA
	for <netdev@vger.kernel.org>; Mon, 22 May 2023 07:58:22 +0000 (UTC)
Received: from mail-pg1-f182.google.com (mail-pg1-f182.google.com [209.85.215.182])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C26FF100;
	Mon, 22 May 2023 00:58:13 -0700 (PDT)
Received: by mail-pg1-f182.google.com with SMTP id 41be03b00d2f7-528dd896165so3938536a12.2;
        Mon, 22 May 2023 00:58:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684742293; x=1687334293;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=nAFKA78IaHcJwZ6V3vkZECGdswzTSuRN8DOvY6iFKSg=;
        b=OhRpgKwrNv4FN/nmbesB17mpZ1Ry4P4vJnGqcRt7mbgAYIGKCOM84+TNUkHCs9ftCh
         OS/blzHlQrmFicWvLGRcIfbuIpqFR9yN9A1fYhk4UoBhx3/PQYiB+VoROAzPMhkAXlki
         nhMGb3mywwXAFZI05wgDhlMJze3e42Q2DwCiXA2t5SBxq4+jDou8Cr35H+FtUcM+2hdZ
         kZ/3i9GgSrP7477kFDxVbOcSEG4bWo8A59O0hJAdEqCQUkuh9GPyRITkU7T7bGYETedF
         ekhgNq6ZAOUeoQ73A2RlFBT7Q1dGARTFebqKYq8ngsiW+1ZoGf4pOELz01evKgwW/nnc
         MNmw==
X-Gm-Message-State: AC+VfDxE0nsjvWrQmoCMg7BdTRa8QY2BEQKFD+dYVUfsTJ9g9gpgE8i8
	gSj9PKHPBtTi74VrdHXZzFFY2RV1hcbYKHdBBRkwbjaMgLU=
X-Google-Smtp-Source: ACHHUZ6DZZoSGcDctNHXYJdgpxbQdXYWoF482KS5bCJQvYOFwDWtOkCRGl94rmz1brVyLWM5/jRXU5eQX8MKChkeNag=
X-Received: by 2002:a17:90a:9401:b0:253:4d77:451e with SMTP id
 r1-20020a17090a940100b002534d77451emr9201080pjo.9.1684742293131; Mon, 22 May
 2023 00:58:13 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20230417085204.179268-1-git@cookiesoft.de>
In-Reply-To: <20230417085204.179268-1-git@cookiesoft.de>
From: Vincent MAILHOL <mailhol.vincent@wanadoo.fr>
Date: Mon, 22 May 2023 16:58:02 +0900
Message-ID: <CAMZ6RqJqwyJQ17EJd0eV_8tbsC5b16nbuQj3uD38BeRzSdPc3Q@mail.gmail.com>
Subject: Re: [PATCH] can: dev: add transceiver capabilities to xilinx_can
To: Marcel Hellwig <git@cookiesoft.de>
Cc: Appana Durga Kedareswara rao <appana.durga.rao@xilinx.com>, 
	Naga Sureshkumar Relli <naga.sureshkumar.relli@xilinx.com>, linux-can@vger.kernel.org, 
	netdev@vger.kernel.org, Marcel Hellwig <mhellwig@mut-group.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
	FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
	RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
	SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Hi Marcel,

Style check only (I am not yet familiar enough with the devicetree).

On Mon. 17 Apr. 2023 at 18:01, Marcel Hellwig <git@cookiesoft.de> wrote:
> Currently the xilinx_can driver does not support adding a phy like the
> "ti,tcan1043" to its devicetree.
>
> This code makes it possible to add such phy, so that the kernel makes
> sure that the PHY is in operational state, when the link is set to an
> "up" state.
>
> Signed-off-by: Marcel Hellwig <git@cookiesoft.de>
> ---
>  drivers/net/can/xilinx_can.c | 20 ++++++++++++++++++++
>  1 file changed, 20 insertions(+)
>
> diff --git a/drivers/net/can/xilinx_can.c b/drivers/net/can/xilinx_can.c
> index 43c812ea1de0..6a5b805d579a 100644
> --- a/drivers/net/can/xilinx_can.c
> +++ b/drivers/net/can/xilinx_can.c
> @@ -28,6 +28,7 @@
>  #include <linux/types.h>
>  #include <linux/can/dev.h>
>  #include <linux/can/error.h>
> +#include <linux/phy/phy.h>
>  #include <linux/pm_runtime.h>
>
>  #define DRIVER_NAME    "xilinx_can"
> @@ -215,6 +216,7 @@ struct xcan_priv {
>         struct clk *bus_clk;
>         struct clk *can_clk;
>         struct xcan_devtype_data devtype;
> +       struct phy *transceiver;
>  };
>
>  /* CAN Bittiming constants as per Xilinx CAN specs */
> @@ -1419,6 +1421,12 @@ static int xcan_open(struct net_device *ndev)
>         struct xcan_priv *priv = netdev_priv(ndev);
>         int ret;
>
> +       ret = phy_power_on(priv->transceiver);
> +       if (ret) {
> +               netdev_err(ndev, "%s: phy_power_on failed(%d)\n", __func__, ret);

From the Linux kernel coding style:

  Printing numbers in parentheses (%d) adds no value and should be avoided.
  Link: https://www.kernel.org/doc/html/latest/process/coding-style.html#printing-kernel-messages

Also consider %pe to print the mnemotechnic instead of the value:

          netdev_err(ndev, "%s: phy_power_on failed: %pe\n", __func__,
ERR_PTR(ret));

> +               return ret;
> +       }
> +
>         ret = pm_runtime_get_sync(priv->dev);
>         if (ret < 0) {
>                 netdev_err(ndev, "%s: pm_runtime_get failed(%d)\n",

It is up to you, but bonus points if you send a clean-up patch to fix
the existing log messages.

> @@ -1461,6 +1469,7 @@ static int xcan_open(struct net_device *ndev)
>  err_irq:
>         free_irq(ndev->irq, ndev);
>  err:
> +       phy_power_off(priv->transceiver);
>         pm_runtime_put(priv->dev);
>
>         return ret;
> @@ -1482,6 +1491,7 @@ static int xcan_close(struct net_device *ndev)
>         free_irq(ndev->irq, ndev);
>         close_candev(ndev);
>
> +       phy_power_off(priv->transceiver);
>         pm_runtime_put(priv->dev);
>
>         return 0;
> @@ -1713,6 +1723,7 @@ static int xcan_probe(struct platform_device *pdev)
>  {
>         struct net_device *ndev;
>         struct xcan_priv *priv;
> +       struct phy *transceiver;
>         const struct of_device_id *of_id;
>         const struct xcan_devtype_data *devtype = &xcan_axi_data;
>         void __iomem *addr;
> @@ -1843,6 +1854,14 @@ static int xcan_probe(struct platform_device *pdev)
>                 goto err_free;
>         }
>
> +       transceiver = devm_phy_optional_get(&pdev->dev, NULL);
> +       if (IS_ERR(transceiver)) {
> +               ret = PTR_ERR(transceiver);
> +               dev_err_probe(&pdev->dev, ret, "failed to get phy\n");
> +               goto err_free;
> +       }
> +       priv->transceiver = transceiver;
> +
>         priv->write_reg = xcan_write_reg_le;
>         priv->read_reg = xcan_read_reg_le;
>
> @@ -1869,6 +1888,7 @@ static int xcan_probe(struct platform_device *pdev)
>                 goto err_disableclks;
>         }
>
> +       of_can_transceiver(ndev);
>         pm_runtime_put(&pdev->dev);
>
>         if (priv->devtype.flags & XCAN_FLAG_CANFD_2) {
> --
> 2.34.1
>

