Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 028AC5438C9
	for <lists+netdev@lfdr.de>; Wed,  8 Jun 2022 18:23:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245136AbiFHQWv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jun 2022 12:22:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243257AbiFHQWu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jun 2022 12:22:50 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF32DAF33D;
        Wed,  8 Jun 2022 09:22:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7CBF26188D;
        Wed,  8 Jun 2022 16:22:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4CB9C34116;
        Wed,  8 Jun 2022 16:22:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654705366;
        bh=lxj/6uywiPHC43d319e3CMItAQ0cOOseusiSDYoDAGg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=HWFRpGi/0zBl83QGyedjRwODOD8Ia6nfGWD7GZajDwn4hmOOLi7DS+2ECNWazk4ex
         633plU+Tut67obElQeWBwnBiV9i+2cemc92qcqwf+Ka7ULehcKoXiIq4qzqHLGtSuy
         5Eom2KxteyhxFETv76+6Vm1IHWWfXW4E0amHvAzCvKNrmfgIX1rrQL4PFjQNocIa9L
         otgq3vI09DZeSK0M0DT0uAAe9ClQEZddCEz0acwwe8E+3egTDZ7pYNUAeRDopufPZD
         8ELwO2M53AM6DhxJ1AiQcAKG+mtO4RTP5dO9PXNxj0HtW+ohl8xBy2GHzYcF1nlF6r
         oeNwWK8uKUgUw==
Date:   Wed, 8 Jun 2022 21:52:42 +0530
From:   Vinod Koul <vkoul@kernel.org>
To:     Abel Vesa <abel.vesa@nxp.com>
Cc:     Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Joakim Zhang <qiangqing.zhang@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Shawn Guo <shawnguo@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        NXP Linux Team <linux-imx@nxp.com>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        Fabio Estevam <festevam@gmail.com>, devicetree@vger.kernel.org,
        netdev@vger.kernel.org, linux-phy@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, linux-usb@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Dong Aisheng <aisheng.dong@nxp.com>
Subject: Re: [PATCH v9 08/12] dt-bindings: phy: mxs-usb-phy: Add i.MX8DXL
 compatible string
Message-ID: <YqDM0umwk6QizT/b@matsya>
References: <20220607111625.1845393-1-abel.vesa@nxp.com>
 <20220607111625.1845393-9-abel.vesa@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220607111625.1845393-9-abel.vesa@nxp.com>
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 07-06-22, 14:16, Abel Vesa wrote:
> Add compatible for i.MX8DXL USB PHY.

Applied, thanks

> 
> Signed-off-by: Abel Vesa <abel.vesa@nxp.com>
> Acked-by: Rob Herring <robh@kernel.org>
> ---
>  Documentation/devicetree/bindings/phy/mxs-usb-phy.txt | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/Documentation/devicetree/bindings/phy/mxs-usb-phy.txt b/Documentation/devicetree/bindings/phy/mxs-usb-phy.txt
> index c9f5c0caf8a9..c9e392c64a7c 100644
> --- a/Documentation/devicetree/bindings/phy/mxs-usb-phy.txt
> +++ b/Documentation/devicetree/bindings/phy/mxs-usb-phy.txt
> @@ -8,6 +8,7 @@ Required properties:
>  	* "fsl,vf610-usbphy" for Vybrid vf610
>  	* "fsl,imx6sx-usbphy" for imx6sx
>  	* "fsl,imx7ulp-usbphy" for imx7ulp
> +	* "fsl,imx8dxl-usbphy" for imx8dxl
>    "fsl,imx23-usbphy" is still a fallback for other strings
>  - reg: Should contain registers location and length
>  - interrupts: Should contain phy interrupt
> -- 
> 2.34.3
> 
> 
> -- 
> linux-phy mailing list
> linux-phy@lists.infradead.org
> https://lists.infradead.org/mailman/listinfo/linux-phy

-- 
~Vinod
