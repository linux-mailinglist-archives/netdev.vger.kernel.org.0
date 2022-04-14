Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E42C9501A67
	for <lists+netdev@lfdr.de>; Thu, 14 Apr 2022 19:49:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343788AbiDNRwD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Apr 2022 13:52:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234563AbiDNRwC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Apr 2022 13:52:02 -0400
Received: from mail-oo1-f49.google.com (mail-oo1-f49.google.com [209.85.161.49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D76521FCE9;
        Thu, 14 Apr 2022 10:49:36 -0700 (PDT)
Received: by mail-oo1-f49.google.com with SMTP id c2-20020a4aacc2000000b003333c8697bbso341639oon.12;
        Thu, 14 Apr 2022 10:49:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=v2ZywhYAsntftmD0dEx1WR18hbxVe7T66gl7M0y0+0s=;
        b=E3fE9UzMCh5r3PddEbTdz+EwllNzipw4W3gxFe8lpF2+Khw/Eh5jibDazQiv4wRjHB
         bHu8YceeW8rObzcQFzDaHH2+AtKy8H8r2rRod/L79Lsu6lxCT8ejJvwTndvdVPQm8Gbp
         wQz/5spOSF3OVYVMHxd2zd35UL/mZPfP44ZY1usfV0GU0kuOsChEUK6/o0k3R4ea7+AY
         OIBniUIgwWMbgdGMUuAkdQkbwoY3keXPVwHoIZvcaTu6AeILIVN1LoZxFlRl2D4LgdaH
         NB+GPgk3+MhQ/KANs/5oOJJpEAbKHb7t5WjHZcUX1ne9EqVCK76lA+kQ799MJMP6O5Fp
         6+9Q==
X-Gm-Message-State: AOAM530JtWgP8wZHdrdc4guRET2AwS3A8V8I+4w4PStBl+erHAtsHVx2
        IC1G5E1Iqy6wNVWhJAZe9g==
X-Google-Smtp-Source: ABdhPJzwhILDM0khPNThPT0pzjGRWWc9mSrkf15HiIobnLx2hXxJhHTWRu7eVO8nXb6ficB8vGpENg==
X-Received: by 2002:a4a:d254:0:b0:324:b1bf:da28 with SMTP id e20-20020a4ad254000000b00324b1bfda28mr1104453oos.49.1649958576166;
        Thu, 14 Apr 2022 10:49:36 -0700 (PDT)
Received: from robh.at.kernel.org (66-90-144-107.dyn.grandenetworks.net. [66.90.144.107])
        by smtp.gmail.com with ESMTPSA id h21-20020a9d6015000000b006025edf7cafsm256680otj.22.2022.04.14.10.49.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Apr 2022 10:49:35 -0700 (PDT)
Received: (nullmailer pid 2301385 invoked by uid 1000);
        Thu, 14 Apr 2022 17:49:35 -0000
Date:   Thu, 14 Apr 2022 12:49:35 -0500
From:   Rob Herring <robh@kernel.org>
To:     Abel Vesa <abel.vesa@nxp.com>
Cc:     netdev@vger.kernel.org, Fabio Estevam <fabio.estevam@nxp.com>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-mmc@vger.kernel.org, NXP Linux Team <linux-imx@nxp.com>,
        linux-arm-kernel@lists.infradead.org,
        Shawn Guo <shawnguo@kernel.org>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        devicetree@vger.kernel.org
Subject: Re: [PATCH v6 10/13] dt-bindings: net: fec: Add i.MX8DXL compatible
 string
Message-ID: <Ylher/mIwewDllu9@robh.at.kernel.org>
References: <20220413103356.3433637-1-abel.vesa@nxp.com>
 <20220413103356.3433637-11-abel.vesa@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220413103356.3433637-11-abel.vesa@nxp.com>
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

On Wed, 13 Apr 2022 13:33:53 +0300, Abel Vesa wrote:
> Add the i.MX8DXL compatible string for FEC. It also uses
> "fsl,imx8qm-fec".
> 
> Signed-off-by: Abel Vesa <abel.vesa@nxp.com>
> ---
>  Documentation/devicetree/bindings/net/fsl,fec.yaml | 4 ++++
>  1 file changed, 4 insertions(+)
> 

Acked-by: Rob Herring <robh@kernel.org>
