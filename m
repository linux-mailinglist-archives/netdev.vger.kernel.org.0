Return-Path: <netdev+bounces-4151-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id CB44B70B66F
	for <lists+netdev@lfdr.de>; Mon, 22 May 2023 09:24:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9D6AB1C209C4
	for <lists+netdev@lfdr.de>; Mon, 22 May 2023 07:24:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A04314C61;
	Mon, 22 May 2023 07:24:33 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 953354A3D
	for <netdev@vger.kernel.org>; Mon, 22 May 2023 07:24:33 +0000 (UTC)
Received: from mout-p-201.mailbox.org (mout-p-201.mailbox.org [IPv6:2001:67c:2050:0:465::201])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90E55121;
	Mon, 22 May 2023 00:24:27 -0700 (PDT)
Received: from smtp1.mailbox.org (smtp1.mailbox.org [10.196.197.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by mout-p-201.mailbox.org (Postfix) with ESMTPS id 4QPpq702fXz9sWC;
	Mon, 22 May 2023 09:24:19 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cookiesoft.de;
	s=MBO0001; t=1684740259;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Of2oI/grVRnAAPcP3YUUDUE7rRXWKP9LVEUrZ+YGnXY=;
	b=G2hhyUYdY1YTnwXDHnd9VVDgmBTTipmpDPJEcNJhTnh0HxizJ0Yg16tgGf2A0tLftWf8os
	OIzII4FeEWVnfjydbsvCnI8LzqDSP96i2ESaCzwONWNJEMujLS5sYV9qAIQ3zcwL6GOAUx
	SniN0IF5kPww/TCDK4v07TQ+XCfJpTKiPI1ApbmQW74Wq+a8LmFSo906AEuY1DTqnNHq5b
	oa4BGolx80C5sDbEW1SJ8GwxQwFe/NlOlioPBsK6x6XHO+TTI/Fb7txvKtWWGP/+gUdos7
	PEXYEaUZYzKd3AOnRtv57Vf4uWxmVWeJomCBElToqvgZLV+LO9BlO6gp74ojQw==
Date: Mon, 22 May 2023 09:24:17 +0200 (CEST)
From: git@cookiesoft.de
To: Appana Durga Kedareswara rao <appana.durga.rao@xilinx.com>,
	Naga Sureshkumar Relli <naga.sureshkumar.relli@xilinx.com>,
	linux-can@vger.kernel.org, netdev@vger.kernel.org
Cc: Marcel Hellwig <mhellwig@mut-group.com>
Message-ID: <831053285.870396.1684740257842@office.mailbox.org>
In-Reply-To: <20230417085204.179268-1-git@cookiesoft.de>
References: <20230417085204.179268-1-git@cookiesoft.de>
Subject: Re: [PATCH] can: dev: add transceiver capabilities to xilinx_can
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Priority: 3
Importance: Normal
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
	SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Hey everyone,

is there anything I can do to get this merged?
Is there anything missing?

Greetings,
Marcel

> Marcel Hellwig <git@cookiesoft.de> hat am 17.04.2023 10:52 CEST geschrieben:
> 
>  
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
>  #define DRIVER_NAME	"xilinx_can"
> @@ -215,6 +216,7 @@ struct xcan_priv {
>  	struct clk *bus_clk;
>  	struct clk *can_clk;
>  	struct xcan_devtype_data devtype;
> +	struct phy *transceiver;
>  };
>  
>  /* CAN Bittiming constants as per Xilinx CAN specs */
> @@ -1419,6 +1421,12 @@ static int xcan_open(struct net_device *ndev)
>  	struct xcan_priv *priv = netdev_priv(ndev);
>  	int ret;
>  
> +	ret = phy_power_on(priv->transceiver);
> +	if (ret) {
> +		netdev_err(ndev, "%s: phy_power_on failed(%d)\n", __func__, ret);
> +		return ret;
> +	}
> +
>  	ret = pm_runtime_get_sync(priv->dev);
>  	if (ret < 0) {
>  		netdev_err(ndev, "%s: pm_runtime_get failed(%d)\n",
> @@ -1461,6 +1469,7 @@ static int xcan_open(struct net_device *ndev)
>  err_irq:
>  	free_irq(ndev->irq, ndev);
>  err:
> +	phy_power_off(priv->transceiver);
>  	pm_runtime_put(priv->dev);
>  
>  	return ret;
> @@ -1482,6 +1491,7 @@ static int xcan_close(struct net_device *ndev)
>  	free_irq(ndev->irq, ndev);
>  	close_candev(ndev);
>  
> +	phy_power_off(priv->transceiver);
>  	pm_runtime_put(priv->dev);
>  
>  	return 0;
> @@ -1713,6 +1723,7 @@ static int xcan_probe(struct platform_device *pdev)
>  {
>  	struct net_device *ndev;
>  	struct xcan_priv *priv;
> +	struct phy *transceiver;
>  	const struct of_device_id *of_id;
>  	const struct xcan_devtype_data *devtype = &xcan_axi_data;
>  	void __iomem *addr;
> @@ -1843,6 +1854,14 @@ static int xcan_probe(struct platform_device *pdev)
>  		goto err_free;
>  	}
>  
> +	transceiver = devm_phy_optional_get(&pdev->dev, NULL);
> +	if (IS_ERR(transceiver)) {
> +		ret = PTR_ERR(transceiver);
> +		dev_err_probe(&pdev->dev, ret, "failed to get phy\n");
> +		goto err_free;
> +	}
> +	priv->transceiver = transceiver;
> +
>  	priv->write_reg = xcan_write_reg_le;
>  	priv->read_reg = xcan_read_reg_le;
>  
> @@ -1869,6 +1888,7 @@ static int xcan_probe(struct platform_device *pdev)
>  		goto err_disableclks;
>  	}
>  
> +	of_can_transceiver(ndev);
>  	pm_runtime_put(&pdev->dev);
>  
>  	if (priv->devtype.flags & XCAN_FLAG_CANFD_2) {
> -- 
> 2.34.1

