Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CD3AF501A7A
	for <lists+netdev@lfdr.de>; Thu, 14 Apr 2022 19:53:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343998AbiDNRyJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Apr 2022 13:54:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343977AbiDNRx6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Apr 2022 13:53:58 -0400
Received: from mail-oa1-f45.google.com (mail-oa1-f45.google.com [209.85.160.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2DF3BEA763;
        Thu, 14 Apr 2022 10:51:30 -0700 (PDT)
Received: by mail-oa1-f45.google.com with SMTP id 586e51a60fabf-ddfa38f1c1so5976788fac.11;
        Thu, 14 Apr 2022 10:51:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=DEI45G4jfdbLSLjK6F+n7UUuOmq9pwFT5soFbJ9qWrA=;
        b=i4shKFO0PU7GNvQNI2WW03fSzG2RT5nXceVYvQvopOYuiAMV7cLICqQWnigjTL2+Cl
         r2OH2LqO2K14zAd1fmzYe0BqsUGf98Qq1rd4rxe6IWZliP+sZhmytWWx0E1H3sHdAbUP
         oEmJzgVVZVvhtVk/jz/xmKN/Df+Xk+rw5Oe9WmX4td5d2PvE5GkeQH/KfTXxCeDoUhEu
         I7OVgogKHBMRAWXkINMZvZ0ubyX0A3C5Sr2T6Kl2QiNf1Z0ikPSB6g0+FAKxWC/AbSDy
         Va9Cu7Jj6oxLFDVZrIEdE2IZL9SzcYY2imoOxH/iJiago3CU1Vp7iUygjm8JPNXavD6N
         Xd7A==
X-Gm-Message-State: AOAM531aBbU7dDl1f3FWFzy/e2aEQXVVlx4gXFiNEOYGTuzXlVDJMujQ
        dfAwDkcnQb9JcRU7eL2v+MJJiJT5hg==
X-Google-Smtp-Source: ABdhPJxDRDHbf/842fJuBWcyzVoT6YVdh1vmmWxgq2DyQr5CdgXiXnV4EA6kD1bGnC8psumRBaM8/w==
X-Received: by 2002:a05:6870:6192:b0:e1:dcc4:e0e8 with SMTP id a18-20020a056870619200b000e1dcc4e0e8mr2085666oah.58.1649958689349;
        Thu, 14 Apr 2022 10:51:29 -0700 (PDT)
Received: from robh.at.kernel.org (66-90-144-107.dyn.grandenetworks.net. [66.90.144.107])
        by smtp.gmail.com with ESMTPSA id w133-20020acadf8b000000b002ef9fa2ba84sm266647oig.12.2022.04.14.10.51.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Apr 2022 10:51:29 -0700 (PDT)
Received: (nullmailer pid 2304505 invoked by uid 1000);
        Thu, 14 Apr 2022 17:51:28 -0000
Date:   Thu, 14 Apr 2022 12:51:28 -0500
From:   Rob Herring <robh@kernel.org>
To:     Abel Vesa <abel.vesa@nxp.com>
Cc:     Sascha Hauer <s.hauer@pengutronix.de>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        linux-arm-kernel@lists.infradead.org,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Shawn Guo <shawnguo@kernel.org>, devicetree@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Fabio Estevam <fabio.estevam@nxp.com>,
        NXP Linux Team <linux-imx@nxp.com>,
        linux-mmc@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH v6 13/13] dt-bindings: usb: usbmisc-imx: Add i.MX8DXL
 compatible string
Message-ID: <YlhfIAqBvZM7k67Z@robh.at.kernel.org>
References: <20220413103356.3433637-1-abel.vesa@nxp.com>
 <20220413103356.3433637-14-abel.vesa@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220413103356.3433637-14-abel.vesa@nxp.com>
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,
        FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 13 Apr 2022 13:33:56 +0300, Abel Vesa wrote:
> Add i.MX8DXL compatible string to the usbmisc-imx bindings.
> 
> Signed-off-by: Abel Vesa <abel.vesa@nxp.com>
> ---
>  Documentation/devicetree/bindings/usb/usbmisc-imx.txt | 1 +
>  1 file changed, 1 insertion(+)
> 

Acked-by: Rob Herring <robh@kernel.org>
