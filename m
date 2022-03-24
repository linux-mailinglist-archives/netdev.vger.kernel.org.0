Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 391BF4E64ED
	for <lists+netdev@lfdr.de>; Thu, 24 Mar 2022 15:18:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350849AbiCXOTs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Mar 2022 10:19:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350818AbiCXOTp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Mar 2022 10:19:45 -0400
Received: from mail-oo1-f53.google.com (mail-oo1-f53.google.com [209.85.161.53])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B53413DD5;
        Thu, 24 Mar 2022 07:18:13 -0700 (PDT)
Received: by mail-oo1-f53.google.com with SMTP id v19-20020a056820101300b0032488bb70f5so796303oor.5;
        Thu, 24 Mar 2022 07:18:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:in-reply-to:references:subject:date
         :message-id;
        bh=GawCp05khlhl7cBgGdUQSxdDX5kHWZ23Unif+NFb2E8=;
        b=uSU7SaPpc57OK5eRwSRa5AWGQ6OTGB2XSRXrlbH0NhzQsylA3ArsRpAzKzWJt/XNyv
         FolpoHBgh8OcWtKznI4MMAYtaEO502U8lZddy6ikEhByDliA7Fd/e1KjApVYl40GMpIU
         AeJLNxdqfjSIjOsknhZoIY1MNuKp2tgaAug5bxKMugbbWzU7pMgILj7ib/rnZ+GmGwIS
         LrQYEpICG1xs+EcpuLQuhgyahYZe5JSGXv9szPGQtRtTRGKGkg7+H0MkNjbQdJs4O5l8
         tau9pUMQeOWxrv30d1AxKxPbZvk9aUZXVOnOpu9mOOPjRhckKU0dM88QWmbGER1t++wo
         0Nxg==
X-Gm-Message-State: AOAM531FZN72GR0g/npjnQGfgoDMkSJvSyb5COkioCT/H6LQcapwP6wL
        lRZBtEMeoyeE5IMRcd861w==
X-Google-Smtp-Source: ABdhPJydWUBur9AjgFjFMbYu94DYLhx4H4z8qP983Tnwv9mK3HmPPALKdMbgHx4/yMucmO12mRUMMQ==
X-Received: by 2002:a4a:dd15:0:b0:320:da3c:c342 with SMTP id m21-20020a4add15000000b00320da3cc342mr2033346oou.7.1648131492569;
        Thu, 24 Mar 2022 07:18:12 -0700 (PDT)
Received: from robh.at.kernel.org (66-90-144-107.dyn.grandenetworks.net. [66.90.144.107])
        by smtp.gmail.com with ESMTPSA id r129-20020acac187000000b002ef358c6e0esm1407558oif.49.2022.03.24.07.18.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Mar 2022 07:18:11 -0700 (PDT)
Received: (nullmailer pid 1995387 invoked by uid 1000);
        Thu, 24 Mar 2022 14:18:08 -0000
From:   Rob Herring <robh@kernel.org>
To:     "Peng Fan (OSS)" <peng.fan@oss.nxp.com>
Cc:     pabeni@redhat.com, devicetree@vger.kernel.org,
        qiangqing.zhang@nxp.com, wg@grandegger.com, krzk+dt@kernel.org,
        festevam@gmail.com, davem@davemloft.net, kernel@pengutronix.de,
        linux-arm-kernel@lists.infradead.org, linux-can@vger.kernel.org,
        kuba@kernel.org, linux-kernel@vger.kernel.org,
        ulf.hansson@linaro.org, mkl@pengutronix.de,
        Peng Fan <peng.fan@nxp.com>, shawnguo@kernel.org,
        s.hauer@pengutronix.de, robh+dt@kernel.org,
        linux-mmc@vger.kernel.org, netdev@vger.kernel.org,
        linux-imx@nxp.com
In-Reply-To: <20220324042024.26813-5-peng.fan@oss.nxp.com>
References: <20220324042024.26813-1-peng.fan@oss.nxp.com> <20220324042024.26813-5-peng.fan@oss.nxp.com>
Subject: Re: [PATCH 4/4] dt-bindings: net: imx-dwmac: introduce nvmem property
Date:   Thu, 24 Mar 2022 09:18:08 -0500
Message-Id: <1648131488.621544.1995386.nullmailer@robh.at.kernel.org>
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

On Thu, 24 Mar 2022 12:20:24 +0800, Peng Fan (OSS) wrote:
> From: Peng Fan <peng.fan@nxp.com>
> 
> To i.MX8M Family variants, dwmac maybe fused out. Bootloader could use
> this property to read out the fuse value and mark the node status
> at runtime.
> 
> Signed-off-by: Peng Fan <peng.fan@nxp.com>
> ---
>  Documentation/devicetree/bindings/net/nxp,dwmac-imx.yaml | 9 +++++++++
>  1 file changed, 9 insertions(+)
> 

Running 'make dtbs_check' with the schema in this patch gives the
following warnings. Consider if they are expected or the schema is
incorrect. These may not be new warnings.

Note that it is not yet a requirement to have 0 warnings for dtbs_check.
This will change in the future.

Full log is available here: https://patchwork.ozlabs.org/patch/1608879


ethernet@30bf0000: nvmem-cell-names:0: 'fused' was expected
	arch/arm64/boot/dts/freescale/imx8mp-evk.dt.yaml
	arch/arm64/boot/dts/freescale/imx8mp-phyboard-pollux-rdk.dt.yaml

