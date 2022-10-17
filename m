Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4437960078E
	for <lists+netdev@lfdr.de>; Mon, 17 Oct 2022 09:19:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230145AbiJQHTl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Oct 2022 03:19:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229919AbiJQHTk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Oct 2022 03:19:40 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1D1565D0;
        Mon, 17 Oct 2022 00:19:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1665991176; x=1697527176;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=UBuvRDypJT++mgXI7DOwGnJFcpVZ/gzflYCezJdbRdo=;
  b=uym6OB4c1Sk5NO5RwIY51XSS9/CIJ07C5BmaM8Q+VVZUb0IaslrOWhtJ
   cLoVAuTxp4wl68MPEvd6+pzimQfZvo+YQKjjIts2iPvim2WR8xfCfxJtw
   P7cMhS2ZgaIXOEoGbAwSQFw6GXzLahEKXrBcLTOIe7fhOONftq3lWsxlS
   TOoZt35q2tWqT6DHlSVSvGFAoHMNSd5XUn25isoC6DzXNIvdCjtAo60Yq
   bYxQyfh0e2Z27T2rcfHtYtND17wdKz1Dqc+ksbE4osXF0CBvUvMEXRy9j
   CV8n82ELrr3QcfXf9mngBFnuaLnaL9/bURic9BB1JWuPWBKvjuvxvyQWM
   Q==;
X-IronPort-AV: E=Sophos;i="5.95,190,1661842800"; 
   d="scan'208";a="182465180"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 17 Oct 2022 00:19:33 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Mon, 17 Oct 2022 00:19:33 -0700
Received: from [10.159.245.112] (10.10.115.15) by chn-vm-ex03.mchp-main.com
 (10.10.85.151) with Microsoft SMTP Server id 15.1.2507.12 via Frontend
 Transport; Mon, 17 Oct 2022 00:19:26 -0700
Message-ID: <91250148-67b9-d514-6af0-bfcd719fde53@microchip.com>
Date:   Mon, 17 Oct 2022 09:19:22 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH] dt-bindings: Remove "status" from schema examples, again
Content-Language: en-US
To:     Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Jonathan Hunter <jonathanh@nvidia.com>,
        "David Airlie" <airlied@gmail.com>,
        Daniel Vetter <daniel@ffwll.ch>,
        "Lars-Peter Clausen" <lars@metafoo.de>,
        Michael Hennerich <Michael.Hennerich@analog.com>,
        Cosmin Tanislav <cosmin.tanislav@analog.com>,
        Jonathan Cameron <jic23@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Shawn Guo <shawnguo@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        Fabio Estevam <festevam@gmail.com>,
        NXP Linux Team <linux-imx@nxp.com>,
        Nandhini Srikandan <nandhini.srikandan@intel.com>,
        Rashmi A <rashmi.a@intel.com>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Vinod Koul <vkoul@kernel.org>, Sumit Gupta <sumitg@nvidia.com>,
        Mikko Perttunen <mperttunen@nvidia.com>,
        Claudiu Beznea <claudiu.beznea@microchip.com>,
        Joakim Zhang <qiangqing.zhang@nxp.com>
CC:     <devicetree@vger.kernel.org>, <linux-tegra@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <dri-devel@lists.freedesktop.org>,
        <linux-iio@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-phy@lists.infradead.org>
References: <20221014205104.2822159-1-robh@kernel.org>
From:   Nicolas Ferre <nicolas.ferre@microchip.com>
Organization: microchip
In-Reply-To: <20221014205104.2822159-1-robh@kernel.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 14/10/2022 at 22:51, Rob Herring wrote:
> There's no reason to have "status" properties in examples. "okay" is the
> default, and "disabled" turns off some schema checks ('required'
> specifically).
> 
> A meta-schema check for this is pending, so hopefully the last time to
> fix these.
> 
> Fix the indentation in intel,phy-thunderbay-emmc while we're here.
> 
> Signed-off-by: Rob Herring <robh@kernel.org>
> ---
>   .../arm/tegra/nvidia,tegra-ccplex-cluster.yaml    |  1 -
>   .../display/tegra/nvidia,tegra124-dpaux.yaml      |  1 -
>   .../display/tegra/nvidia,tegra186-display.yaml    |  2 --
>   .../bindings/iio/addac/adi,ad74413r.yaml          |  1 -
>   .../devicetree/bindings/net/cdns,macb.yaml        |  1 -
>   .../devicetree/bindings/net/nxp,dwmac-imx.yaml    |  1 -
>   .../bindings/phy/intel,phy-thunderbay-emmc.yaml   | 15 +++++++--------
>   7 files changed, 7 insertions(+), 15 deletions(-)

[..]

> diff --git a/Documentation/devicetree/bindings/net/cdns,macb.yaml b/Documentation/devicetree/bindings/net/cdns,macb.yaml
> index 318f4efe7f6f..bef5e0f895be 100644
> --- a/Documentation/devicetree/bindings/net/cdns,macb.yaml
> +++ b/Documentation/devicetree/bindings/net/cdns,macb.yaml
> @@ -203,7 +203,6 @@ examples:
>                       power-domains = <&zynqmp_firmware PD_ETH_1>;
>                       resets = <&zynqmp_reset ZYNQMP_RESET_GEM1>;
>                       reset-names = "gem1_rst";
> -                    status = "okay";
>                       phy-mode = "sgmii";
>                       phys = <&psgtr 1 PHY_TYPE_SGMII 1 1>;
>                       fixed-link {


Acked-by: Nicolas Ferre <nicolas.ferre@microchip.com>
Thanks Rob. Best regards,
   Nicolas

-- 
Nicolas Ferre
