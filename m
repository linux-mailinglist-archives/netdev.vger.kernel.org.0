Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4798960040A
	for <lists+netdev@lfdr.de>; Mon, 17 Oct 2022 00:58:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229759AbiJPW6Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 16 Oct 2022 18:58:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229786AbiJPW6X (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 16 Oct 2022 18:58:23 -0400
Received: from mail-ot1-f47.google.com (mail-ot1-f47.google.com [209.85.210.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E619732BA8;
        Sun, 16 Oct 2022 15:58:21 -0700 (PDT)
Received: by mail-ot1-f47.google.com with SMTP id cb2-20020a056830618200b00661b6e5dcd8so4888208otb.8;
        Sun, 16 Oct 2022 15:58:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=date:subject:message-id:references:in-reply-to:cc:to:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=0FGJBQWXx5CpWaQi3nYfZu/z/0GkvFFnodWEgQwT7VU=;
        b=SH9Jur0xCrMAFWQ46mdPAXevodYLQv2pCTsMNyQ32G/cFMmgGxBdW7a17XFGDhdVQz
         PbpLxW83qK42ivtTPR6OfUaw/KegEj0F3FZrv7s3XHMM4Y6IaQOLQe8lcQW2OEhSLFq3
         IxoLuGjlJuf76jGjZoqnGUlo1YIElS0yfWR+CMj00lB8WotyfiTNLIPVMZw0Fxj/Cazq
         DO9P6QMc+pCa2S7kiZkWLq8Hd88GmmoNB0hYT+rcCWR7koOdjv5JXF+e+ph8TeOjjQkY
         RwrhV9Ucb1f4hLsFK4//aANXJZTk/BSLSjG41Tj2Ej7a1vhxRVi/ExYQNWl6uM+Ws+M8
         fxjQ==
X-Gm-Message-State: ACrzQf2nFwT9eiIncwrrkusD4zI6vOk02nklnGA67mAwAjuGS+XlIeNK
        vNrTf2Xnj9QvWau2UcZSAg==
X-Google-Smtp-Source: AMsMyM4LLY5uBLl0jyQjiLuAfmIxU2jlW1svNyO4p/uoDTSaYOLamHpc4SKVCxcOVtlx52/RTMJ6mA==
X-Received: by 2002:a9d:f43:0:b0:638:c3c4:73ee with SMTP id 61-20020a9d0f43000000b00638c3c473eemr3601886ott.186.1665961101090;
        Sun, 16 Oct 2022 15:58:21 -0700 (PDT)
Received: from robh_at_kernel.org (66-90-144-107.dyn.grandenetworks.net. [66.90.144.107])
        by smtp.gmail.com with ESMTPSA id y3-20020a056870418300b0011f400edb17sm4281809oac.4.2022.10.16.15.58.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 16 Oct 2022 15:58:20 -0700 (PDT)
Received: (nullmailer pid 3904632 invoked by uid 1000);
        Sun, 16 Oct 2022 22:58:18 -0000
From:   Rob Herring <robh@kernel.org>
To:     =?utf-8?q?Micha=C5=82_Grzelak?= <mig@semihalf.com>
Cc:     davem@davemloft.net, krzysztof.kozlowski+dt@linaro.org,
        upstream@semihalf.com, kuba@kernel.org, edumazet@google.com,
        netdev@vger.kernel.org, pabeni@redhat.com,
        linux-kernel@vger.kernel.org, robh+dt@kernel.org,
        devicetree@vger.kernel.org, mw@semihalf.com, linux@armlinux.org.uk
In-Reply-To: <20221014213254.30950-2-mig@semihalf.com>
References: <20221014213254.30950-1-mig@semihalf.com> <20221014213254.30950-2-mig@semihalf.com>
Message-Id: <166596083428.3897181.16535515589194840767.robh@kernel.org>
Subject: Re: [PATCH v5 1/3] dt-bindings: net: marvell,pp2: convert to json-schema
Date:   Sun, 16 Oct 2022 17:58:18 -0500
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,
        FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,PP_MIME_FAKE_ASCII_TEXT,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 14 Oct 2022 23:32:52 +0200, Michał Grzelak wrote:
> Convert the marvell,pp2 bindings from text to proper schema.
> 
> Move 'marvell,system-controller' and 'dma-coherent' properties from
> port up to the controller node, to match what is actually done in DT.
> 
> Rename all subnodes to match "^(ethernet-)?port@[0-2]$" and deprecate
> port-id in favour of 'reg'.
> 
> Signed-off-by: Michał Grzelak <mig@semihalf.com>
> ---
>  .../devicetree/bindings/net/marvell,pp2.yaml  | 305 ++++++++++++++++++
>  .../devicetree/bindings/net/marvell-pp2.txt   | 141 --------
>  MAINTAINERS                                   |   2 +-
>  3 files changed, 306 insertions(+), 142 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/net/marvell,pp2.yaml
>  delete mode 100644 Documentation/devicetree/bindings/net/marvell-pp2.txt
> 

Running 'make dtbs_check' with the schema in this patch gives the
following warnings. Consider if they are expected or the schema is
incorrect. These may not be new warnings.

Note that it is not yet a requirement to have 0 warnings for dtbs_check.
This will change in the future.

Full log is available here: https://patchwork.ozlabs.org/patch/


ethernet@0: 'eth0', 'eth1', 'eth2' do not match any of the regexes: '^(ethernet-)?port@[0-2]$', 'pinctrl-[0-9]+'
	arch/arm64/boot/dts/marvell/armada-7040-db.dtb
	arch/arm64/boot/dts/marvell/armada-7040-mochabin.dtb
	arch/arm64/boot/dts/marvell/armada-8040-clearfog-gt-8k.dtb
	arch/arm64/boot/dts/marvell/armada-8040-clearfog-gt-8k.dtb
	arch/arm64/boot/dts/marvell/armada-8040-db.dtb
	arch/arm64/boot/dts/marvell/armada-8040-db.dtb
	arch/arm64/boot/dts/marvell/armada-8040-mcbin.dtb
	arch/arm64/boot/dts/marvell/armada-8040-mcbin.dtb
	arch/arm64/boot/dts/marvell/armada-8040-mcbin-singleshot.dtb
	arch/arm64/boot/dts/marvell/armada-8040-mcbin-singleshot.dtb
	arch/arm64/boot/dts/marvell/armada-8040-puzzle-m801.dtb
	arch/arm64/boot/dts/marvell/armada-8040-puzzle-m801.dtb
	arch/arm64/boot/dts/marvell/cn9130-crb-A.dtb
	arch/arm64/boot/dts/marvell/cn9130-crb-B.dtb
	arch/arm64/boot/dts/marvell/cn9130-db-B.dtb
	arch/arm64/boot/dts/marvell/cn9130-db.dtb
	arch/arm64/boot/dts/marvell/cn9131-db-B.dtb
	arch/arm64/boot/dts/marvell/cn9131-db-B.dtb
	arch/arm64/boot/dts/marvell/cn9131-db.dtb
	arch/arm64/boot/dts/marvell/cn9131-db.dtb
	arch/arm64/boot/dts/marvell/cn9132-db-B.dtb
	arch/arm64/boot/dts/marvell/cn9132-db-B.dtb
	arch/arm64/boot/dts/marvell/cn9132-db-B.dtb
	arch/arm64/boot/dts/marvell/cn9132-db.dtb
	arch/arm64/boot/dts/marvell/cn9132-db.dtb
	arch/arm64/boot/dts/marvell/cn9132-db.dtb

ethernet@f0000: 'eth0', 'eth1' do not match any of the regexes: '^(ethernet-)?port@[0-2]$', 'pinctrl-[0-9]+'
	arch/arm/boot/dts/armada-375-db.dtb

