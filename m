Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2CF6F4E64F3
	for <lists+netdev@lfdr.de>; Thu, 24 Mar 2022 15:18:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350898AbiCXOUG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Mar 2022 10:20:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350847AbiCXOTr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Mar 2022 10:19:47 -0400
Received: from mail-oi1-f176.google.com (mail-oi1-f176.google.com [209.85.167.176])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C2F917066;
        Thu, 24 Mar 2022 07:18:15 -0700 (PDT)
Received: by mail-oi1-f176.google.com with SMTP id q189so4994135oia.9;
        Thu, 24 Mar 2022 07:18:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:in-reply-to:references:subject:date
         :message-id;
        bh=UX9c1q8lourTfPi9NddD+4IFmspIC15S3XHcsJRKc5c=;
        b=WjeZDBfZZtgnhLGr7O5Q6UYkHAmeu/2RoY5KvK2ddB2z/ezMP5+en1hAjpGRXrIsuV
         v1KYz39BKApp/5R55qjLApPTdZXtkXBqlrDAMQXh1YxH16h4845Gp8W65xyhQ31f6C4M
         FELgnAvs9Py+0AwXenKa9RY1weBmj8J0qoeQYNrTOGVxsirNgBY5HqJxYwDyZBnHMqKh
         jxJGp1/Oh2br2ZXWB4b/meInJaks3jm1K8DdSaW1gdtwvkTvPsuxb/r+0OrtyLrOFbbp
         I62dRdj310xJvQPlrbIaanqFm/S7TGaaPo6/9y2dze9NgZEs7debKejt6p81ZKgqLMzP
         Dz5w==
X-Gm-Message-State: AOAM530xB3Fc42f21RppP55K1JmL5g9eDcneND3qvkCfLlTWqUc40nsf
        n3nzMHKwWH/vM5XCOs03og==
X-Google-Smtp-Source: ABdhPJzZo7f9WriFBFsYJXaB9MNd6tnJ4/pdKBDsEr2xhQidW2RTX47fFs1ytVcAUout4kV+tNNz0g==
X-Received: by 2002:a05:6808:bc2:b0:2ec:e1c2:bd3f with SMTP id o2-20020a0568080bc200b002ece1c2bd3fmr2800927oik.161.1648131494416;
        Thu, 24 Mar 2022 07:18:14 -0700 (PDT)
Received: from robh.at.kernel.org (66-90-144-107.dyn.grandenetworks.net. [66.90.144.107])
        by smtp.gmail.com with ESMTPSA id j145-20020acaeb97000000b002d9f37166c1sm1433368oih.17.2022.03.24.07.18.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Mar 2022 07:18:13 -0700 (PDT)
Received: (nullmailer pid 1995385 invoked by uid 1000);
        Thu, 24 Mar 2022 14:18:08 -0000
From:   Rob Herring <robh@kernel.org>
To:     "Peng Fan (OSS)" <peng.fan@oss.nxp.com>
Cc:     davem@davemloft.net, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, Peng Fan <peng.fan@nxp.com>,
        pabeni@redhat.com, krzk+dt@kernel.org,
        linux-arm-kernel@lists.infradead.org, s.hauer@pengutronix.de,
        mkl@pengutronix.de, netdev@vger.kernel.org, robh+dt@kernel.org,
        kuba@kernel.org, linux-imx@nxp.com, shawnguo@kernel.org,
        festevam@gmail.com, linux-can@vger.kernel.org,
        kernel@pengutronix.de, qiangqing.zhang@nxp.com,
        ulf.hansson@linaro.org, linux-mmc@vger.kernel.org,
        wg@grandegger.com
In-Reply-To: <20220324042024.26813-3-peng.fan@oss.nxp.com>
References: <20220324042024.26813-1-peng.fan@oss.nxp.com> <20220324042024.26813-3-peng.fan@oss.nxp.com>
Subject: Re: [PATCH 2/4] dt-bindings: net: fsl,fec: introduce nvmem property
Date:   Thu, 24 Mar 2022 09:18:08 -0500
Message-Id: <1648131488.609060.1995384.nullmailer@robh.at.kernel.org>
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,
        FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 24 Mar 2022 12:20:22 +0800, Peng Fan (OSS) wrote:
> From: Peng Fan <peng.fan@nxp.com>
> 
> To i.MX8M Family variants, fec maybe fused out. Bootloader could use
> this property to read out the fuse value and mark the node status
> at runtime.
> 
> Signed-off-by: Peng Fan <peng.fan@nxp.com>
> ---
>  Documentation/devicetree/bindings/net/fsl,fec.yaml | 9 +++++++++
>  1 file changed, 9 insertions(+)
> 

Running 'make dtbs_check' with the schema in this patch gives the
following warnings. Consider if they are expected or the schema is
incorrect. These may not be new warnings.

Note that it is not yet a requirement to have 0 warnings for dtbs_check.
This will change in the future.

Full log is available here: https://patchwork.ozlabs.org/patch/1608877


ethernet@2188000: More than one condition true in oneOf schema:
	arch/arm/boot/dts/imx6dl-mba6a.dt.yaml
	arch/arm/boot/dts/imx6dl-nit6xlite.dt.yaml
	arch/arm/boot/dts/imx6dl-nitrogen6x.dt.yaml
	arch/arm/boot/dts/imx6dl-riotboard.dt.yaml
	arch/arm/boot/dts/imx6dl-sabreauto.dt.yaml
	arch/arm/boot/dts/imx6dl-ts7970.dt.yaml
	arch/arm/boot/dts/imx6q-arm2.dt.yaml
	arch/arm/boot/dts/imx6q-evi.dt.yaml
	arch/arm/boot/dts/imx6q-mba6a.dt.yaml
	arch/arm/boot/dts/imx6q-mccmon6.dt.yaml
	arch/arm/boot/dts/imx6q-nitrogen6_max.dt.yaml
	arch/arm/boot/dts/imx6q-nitrogen6_som2.dt.yaml
	arch/arm/boot/dts/imx6q-nitrogen6x.dt.yaml
	arch/arm/boot/dts/imx6qp-nitrogen6_max.dt.yaml
	arch/arm/boot/dts/imx6qp-nitrogen6_som2.dt.yaml
	arch/arm/boot/dts/imx6qp-sabreauto.dt.yaml
	arch/arm/boot/dts/imx6q-sabreauto.dt.yaml
	arch/arm/boot/dts/imx6q-ts7970.dt.yaml

ethernet@30be0000: nvmem-cell-names:0: 'fused' was expected
	arch/arm64/boot/dts/freescale/imx8mm-beacon-kit.dt.yaml
	arch/arm64/boot/dts/freescale/imx8mm-ddr4-evk.dt.yaml
	arch/arm64/boot/dts/freescale/imx8mm-evk.dt.yaml
	arch/arm64/boot/dts/freescale/imx8mm-icore-mx8mm-ctouch2.dt.yaml
	arch/arm64/boot/dts/freescale/imx8mm-icore-mx8mm-edimm2.2.dt.yaml
	arch/arm64/boot/dts/freescale/imx8mm-kontron-n801x-s.dt.yaml
	arch/arm64/boot/dts/freescale/imx8mm-nitrogen-r2.dt.yaml
	arch/arm64/boot/dts/freescale/imx8mm-tqma8mqml-mba8mx.dt.yaml
	arch/arm64/boot/dts/freescale/imx8mm-var-som-symphony.dt.yaml
	arch/arm64/boot/dts/freescale/imx8mm-venice-gw71xx-0x.dt.yaml
	arch/arm64/boot/dts/freescale/imx8mm-venice-gw72xx-0x.dt.yaml
	arch/arm64/boot/dts/freescale/imx8mm-venice-gw73xx-0x.dt.yaml
	arch/arm64/boot/dts/freescale/imx8mm-venice-gw7901.dt.yaml
	arch/arm64/boot/dts/freescale/imx8mm-venice-gw7902.dt.yaml
	arch/arm64/boot/dts/freescale/imx8mn-beacon-kit.dt.yaml
	arch/arm64/boot/dts/freescale/imx8mn-bsh-smm-s2.dt.yaml
	arch/arm64/boot/dts/freescale/imx8mn-bsh-smm-s2pro.dt.yaml
	arch/arm64/boot/dts/freescale/imx8mn-ddr4-evk.dt.yaml
	arch/arm64/boot/dts/freescale/imx8mn-evk.dt.yaml
	arch/arm64/boot/dts/freescale/imx8mn-tqma8mqnl-mba8mx.dt.yaml
	arch/arm64/boot/dts/freescale/imx8mn-var-som-symphony.dt.yaml
	arch/arm64/boot/dts/freescale/imx8mn-venice-gw7902.dt.yaml
	arch/arm64/boot/dts/freescale/imx8mp-evk.dt.yaml
	arch/arm64/boot/dts/freescale/imx8mp-phyboard-pollux-rdk.dt.yaml
	arch/arm64/boot/dts/freescale/imx8mq-evk.dt.yaml
	arch/arm64/boot/dts/freescale/imx8mq-hummingboard-pulse.dt.yaml
	arch/arm64/boot/dts/freescale/imx8mq-kontron-pitx-imx8m.dt.yaml
	arch/arm64/boot/dts/freescale/imx8mq-librem5-devkit.dt.yaml
	arch/arm64/boot/dts/freescale/imx8mq-librem5-r2.dt.yaml
	arch/arm64/boot/dts/freescale/imx8mq-librem5-r3.dt.yaml
	arch/arm64/boot/dts/freescale/imx8mq-librem5-r4.dt.yaml
	arch/arm64/boot/dts/freescale/imx8mq-mnt-reform2.dt.yaml
	arch/arm64/boot/dts/freescale/imx8mq-nitrogen.dt.yaml
	arch/arm64/boot/dts/freescale/imx8mq-phanbell.dt.yaml
	arch/arm64/boot/dts/freescale/imx8mq-pico-pi.dt.yaml
	arch/arm64/boot/dts/freescale/imx8mq-thor96.dt.yaml
	arch/arm64/boot/dts/freescale/imx8mq-tqma8mq-mba8mx.dt.yaml
	arch/arm64/boot/dts/freescale/imx8mq-zii-ultra-rmb3.dt.yaml
	arch/arm64/boot/dts/freescale/imx8mq-zii-ultra-zest.dt.yaml

ethernet@30be0000: 'phy-connection-type' does not match any of the regexes: 'pinctrl-[0-9]+'
	arch/arm64/boot/dts/freescale/imx8mm-kontron-n801x-s.dt.yaml

ethernet@5b040000: 'power-domains' does not match any of the regexes: 'pinctrl-[0-9]+'
	arch/arm64/boot/dts/freescale/imx8qm-mek.dt.yaml
	arch/arm64/boot/dts/freescale/imx8qxp-ai_ml.dt.yaml
	arch/arm64/boot/dts/freescale/imx8qxp-colibri-eval-v3.dt.yaml
	arch/arm64/boot/dts/freescale/imx8qxp-mek.dt.yaml

ethernet@5b050000: 'power-domains' does not match any of the regexes: 'pinctrl-[0-9]+'
	arch/arm64/boot/dts/freescale/imx8qm-mek.dt.yaml
	arch/arm64/boot/dts/freescale/imx8qxp-ai_ml.dt.yaml
	arch/arm64/boot/dts/freescale/imx8qxp-colibri-eval-v3.dt.yaml
	arch/arm64/boot/dts/freescale/imx8qxp-mek.dt.yaml

