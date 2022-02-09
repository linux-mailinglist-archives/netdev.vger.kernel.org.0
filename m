Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6CC734B0024
	for <lists+netdev@lfdr.de>; Wed,  9 Feb 2022 23:28:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235540AbiBIW0T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Feb 2022 17:26:19 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:55804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235517AbiBIW0R (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Feb 2022 17:26:17 -0500
Received: from mail-oo1-f43.google.com (mail-oo1-f43.google.com [209.85.161.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DFC5E00FA61;
        Wed,  9 Feb 2022 14:26:18 -0800 (PST)
Received: by mail-oo1-f43.google.com with SMTP id v17-20020a4ac911000000b002eac41bb3f4so4140443ooq.10;
        Wed, 09 Feb 2022 14:26:18 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:in-reply-to:references:subject:date
         :message-id;
        bh=VokS/LV1TEYPleulJVlf7TOB4sLTd1K/O33J8e8TuFc=;
        b=rmM5BJBxZZ7G2fPFNDKMA+gJb0ZOwzuO4RfESp3gtXhFjFxiPdR24k0KPvTrk+Re1G
         4li5O3M+5g/IKibmFmaYrO4Ed/eLCIMEAeTZCjlGqTzBkIRECzM9KoYMGlNx7YFs9AkP
         /q4YZGU0wm/umcjcs6ZcwVgbZ4hWc2Bz7OK74vXBUb7dLuEz0UxHigoBLgyF/xHP8wKM
         gegyXZhNrP7uS2AXh/yJDmruvV/sC2O3XPXBm1UJLSrSLda2ECx/5D/knxRcT+bBOlBS
         auS1Lzx4wTZNPAT8IrAxXAtYR1ZGYIObgwMksIeuPZaB6RQMFJ4fNp9Frx7zeG+Bzptd
         YhMQ==
X-Gm-Message-State: AOAM531gXqST+2ob9btCF2ScaAOkYDssWiXqA8WDvWt9jf+QFfJnr5ie
        bLji5kiux9a/jpSmWcmv2u1ZykWm41wW
X-Google-Smtp-Source: ABdhPJywipe7klTLRE5e/+vPDP8aB+/GYFw41LLTSHGNt4APu/Olw3r/K7+zJZ1vbUg6vM11F84QOQ==
X-Received: by 2002:a4a:a68b:: with SMTP id f11mr1785998oom.11.1644445577901;
        Wed, 09 Feb 2022 14:26:17 -0800 (PST)
Received: from robh.at.kernel.org (66-90-148-213.dyn.grandenetworks.net. [66.90.148.213])
        by smtp.gmail.com with ESMTPSA id 21sm7114224otj.71.2022.02.09.14.26.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Feb 2022 14:26:17 -0800 (PST)
Received: (nullmailer pid 1050092 invoked by uid 1000);
        Wed, 09 Feb 2022 22:26:16 -0000
From:   Rob Herring <robh@kernel.org>
To:     Amit Kumar Mahapatra <amit.kumar-mahapatra@xilinx.com>
Cc:     naga.sureshkumar.relli@xilinx.com, linux-can@vger.kernel.org,
        wg@grandegger.com, netdev@vger.kernel.org,
        appana.durga.rao@xilinx.com, git@xilinx.com, davem@davemloft.net,
        devicetree@vger.kernel.org, michal.simek@xilinx.com,
        linux-kernel@vger.kernel.org, kuba@kernel.org,
        linux-arm-kernel@lists.infradead.org, mkl@pengutronix.de,
        robh+dt@kernel.org
In-Reply-To: <20220209174850.32360-1-amit.kumar-mahapatra@xilinx.com>
References: <20220209174850.32360-1-amit.kumar-mahapatra@xilinx.com>
Subject: Re: [PATCH v2] dt-bindings: can: xilinx_can: Convert Xilinx CAN binding to YAML
Date:   Wed, 09 Feb 2022 16:26:16 -0600
Message-Id: <1644445576.227208.1050091.nullmailer@robh.at.kernel.org>
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

On Wed, 09 Feb 2022 23:18:50 +0530, Amit Kumar Mahapatra wrote:
> Convert Xilinx CAN binding documentation to YAML.
> 
> Signed-off-by: Amit Kumar Mahapatra <amit.kumar-mahapatra@xilinx.com>
> ---
> BRANCH: yaml
> 
> Changes in v2:
>  - Added reference to can-controller.yaml
>  - Added example node for canfd-2.0
> ---
>  .../bindings/net/can/xilinx_can.txt           |  61 -------
>  .../bindings/net/can/xilinx_can.yaml          | 160 ++++++++++++++++++
>  2 files changed, 160 insertions(+), 61 deletions(-)
>  delete mode 100644 Documentation/devicetree/bindings/net/can/xilinx_can.txt
>  create mode 100644 Documentation/devicetree/bindings/net/can/xilinx_can.yaml
> 

Running 'make dtbs_check' with the schema in this patch gives the
following warnings. Consider if they are expected or the schema is
incorrect. These may not be new warnings.

Note that it is not yet a requirement to have 0 warnings for dtbs_check.
This will change in the future.

Full log is available here: https://patchwork.ozlabs.org/patch/1590637


can@ff060000: 'power-domains' does not match any of the regexes: 'pinctrl-[0-9]+'
	arch/arm64/boot/dts/xilinx/avnet-ultra96-rev1.dt.yaml
	arch/arm64/boot/dts/xilinx/zynqmp-sm-k26-revA.dt.yaml
	arch/arm64/boot/dts/xilinx/zynqmp-smk-k26-revA.dt.yaml
	arch/arm64/boot/dts/xilinx/zynqmp-zc1232-revA.dt.yaml
	arch/arm64/boot/dts/xilinx/zynqmp-zc1254-revA.dt.yaml
	arch/arm64/boot/dts/xilinx/zynqmp-zc1275-revA.dt.yaml
	arch/arm64/boot/dts/xilinx/zynqmp-zc1751-xm015-dc1.dt.yaml
	arch/arm64/boot/dts/xilinx/zynqmp-zc1751-xm016-dc2.dt.yaml
	arch/arm64/boot/dts/xilinx/zynqmp-zc1751-xm017-dc3.dt.yaml
	arch/arm64/boot/dts/xilinx/zynqmp-zc1751-xm018-dc4.dt.yaml
	arch/arm64/boot/dts/xilinx/zynqmp-zc1751-xm019-dc5.dt.yaml
	arch/arm64/boot/dts/xilinx/zynqmp-zcu100-revC.dt.yaml
	arch/arm64/boot/dts/xilinx/zynqmp-zcu102-rev1.0.dt.yaml
	arch/arm64/boot/dts/xilinx/zynqmp-zcu102-rev1.1.dt.yaml
	arch/arm64/boot/dts/xilinx/zynqmp-zcu102-revA.dt.yaml
	arch/arm64/boot/dts/xilinx/zynqmp-zcu102-revB.dt.yaml
	arch/arm64/boot/dts/xilinx/zynqmp-zcu104-revA.dt.yaml
	arch/arm64/boot/dts/xilinx/zynqmp-zcu104-revC.dt.yaml
	arch/arm64/boot/dts/xilinx/zynqmp-zcu106-revA.dt.yaml
	arch/arm64/boot/dts/xilinx/zynqmp-zcu111-revA.dt.yaml

can@ff070000: 'power-domains' does not match any of the regexes: 'pinctrl-[0-9]+'
	arch/arm64/boot/dts/xilinx/avnet-ultra96-rev1.dt.yaml
	arch/arm64/boot/dts/xilinx/zynqmp-sm-k26-revA.dt.yaml
	arch/arm64/boot/dts/xilinx/zynqmp-smk-k26-revA.dt.yaml
	arch/arm64/boot/dts/xilinx/zynqmp-zc1232-revA.dt.yaml
	arch/arm64/boot/dts/xilinx/zynqmp-zc1254-revA.dt.yaml
	arch/arm64/boot/dts/xilinx/zynqmp-zc1275-revA.dt.yaml
	arch/arm64/boot/dts/xilinx/zynqmp-zc1751-xm015-dc1.dt.yaml
	arch/arm64/boot/dts/xilinx/zynqmp-zc1751-xm016-dc2.dt.yaml
	arch/arm64/boot/dts/xilinx/zynqmp-zc1751-xm017-dc3.dt.yaml
	arch/arm64/boot/dts/xilinx/zynqmp-zc1751-xm018-dc4.dt.yaml
	arch/arm64/boot/dts/xilinx/zynqmp-zc1751-xm019-dc5.dt.yaml
	arch/arm64/boot/dts/xilinx/zynqmp-zcu100-revC.dt.yaml
	arch/arm64/boot/dts/xilinx/zynqmp-zcu102-rev1.0.dt.yaml
	arch/arm64/boot/dts/xilinx/zynqmp-zcu102-rev1.1.dt.yaml
	arch/arm64/boot/dts/xilinx/zynqmp-zcu102-revA.dt.yaml
	arch/arm64/boot/dts/xilinx/zynqmp-zcu102-revB.dt.yaml
	arch/arm64/boot/dts/xilinx/zynqmp-zcu104-revA.dt.yaml
	arch/arm64/boot/dts/xilinx/zynqmp-zcu104-revC.dt.yaml
	arch/arm64/boot/dts/xilinx/zynqmp-zcu106-revA.dt.yaml
	arch/arm64/boot/dts/xilinx/zynqmp-zcu111-revA.dt.yaml

