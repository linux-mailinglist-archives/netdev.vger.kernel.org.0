Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CF0CF5EC6BA
	for <lists+netdev@lfdr.de>; Tue, 27 Sep 2022 16:45:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233071AbiI0Op1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Sep 2022 10:45:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233088AbiI0Oot (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Sep 2022 10:44:49 -0400
Received: from mail-oi1-f182.google.com (mail-oi1-f182.google.com [209.85.167.182])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B266240BC;
        Tue, 27 Sep 2022 07:39:40 -0700 (PDT)
Received: by mail-oi1-f182.google.com with SMTP id j188so12156563oih.0;
        Tue, 27 Sep 2022 07:39:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=message-id:date:subject:references:in-reply-to:cc:to:from
         :x-gm-message-state:from:to:cc:subject:date;
        bh=aXapzxkwJjXshh7yZTouvFh3NO4W45oOiG6QOPv9xbg=;
        b=aPERMFIIOQdl5pZgcPeRw1wlPETmuTiRy7/hYErp8oXNrs6Ge5CHKKp/oyiwhM3e9Y
         LQhsU4yhsBWyqvGoPMFLQ8yHDm6JXCDv4zyP4vmUBvgRTMe7b1uhuecdfLNLd0x3K2JA
         Y0+QJT2CDxcOtNjT0MM3o/WVu1POdqpOT0HwYFWWwfIQhQcGzvYqhaq0s+xWCneztDor
         qUCqkduAUI2wBi4bIV+VNOvBxu6M+TxqPKmNv4/GUWiGQ9sK7WwmgJ6vsVMgPDLUBo8Z
         w8qH+R6ULsje9ujmyVyAuYHHF9TNsX9oo1slKBFEvlGlI+sWBPF9QMcEFI+Tt1P0rh3a
         W9QA==
X-Gm-Message-State: ACrzQf0ww6L7O4JrYa9muvpJ7b2+YzbvZJc4IP4I+p3nGjBbwo0r+v2i
        CAFJFuxEiTT9yDu5eB69WA==
X-Google-Smtp-Source: AMsMyM4hNo1lj9rE/jk87Z2GYcC05y3cmAk+GwtgMB/vVsr+Y0jnhpLHuNbLvB+pBZP2SyJ7pntfMg==
X-Received: by 2002:a05:6808:ca:b0:350:2d75:f3ed with SMTP id t10-20020a05680800ca00b003502d75f3edmr1899153oic.175.1664289559695;
        Tue, 27 Sep 2022 07:39:19 -0700 (PDT)
Received: from robh.at.kernel.org (66-90-144-107.dyn.grandenetworks.net. [66.90.144.107])
        by smtp.gmail.com with ESMTPSA id q16-20020a9d6550000000b00636fd78dd57sm763037otl.41.2022.09.27.07.39.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Sep 2022 07:39:19 -0700 (PDT)
Received: (nullmailer pid 943210 invoked by uid 1000);
        Tue, 27 Sep 2022 14:39:18 -0000
From:   Rob Herring <robh@kernel.org>
To:     Sean Anderson <sean.anderson@seco.com>
Cc:     Camelia Alexandra Groza <camelia.groza@nxp.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Madalin Bucur <madalin.bucur@nxp.com>,
        linux-kernel@vger.kernel.org,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Russell King <linux@armlinux.org.uk>,
        "linuxppc-dev @ lists . ozlabs . org" <linuxppc-dev@lists.ozlabs.org>,
        Eric Dumazet <edumazet@google.com>,
        linux-arm-kernel@lists.infradead.org,
        Rob Herring <robh+dt@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org,
        "David S . Miller" <davem@davemloft.net>
In-Reply-To: <20220926190322.2889342-2-sean.anderson@seco.com>
References: <20220926190322.2889342-1-sean.anderson@seco.com> <20220926190322.2889342-2-sean.anderson@seco.com>
Subject: Re: [PATCH net-next v5 1/9] dt-bindings: net: Expand pcs-handle to an array
Date:   Tue, 27 Sep 2022 09:39:18 -0500
Message-Id: <1664289558.335769.943209.nullmailer@robh.at.kernel.org>
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,
        FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 26 Sep 2022 15:03:13 -0400, Sean Anderson wrote:
> This allows multiple phandles to be specified for pcs-handle, such as
> when multiple PCSs are present for a single MAC. To differentiate
> between them, also add a pcs-handle-names property.
> 
> Signed-off-by: Sean Anderson <sean.anderson@seco.com>
> ---
> This was previously submitted as [1]. I expect to update this series
> more, so I have moved it here. Changes from that version include:
> - Add maxItems to existing bindings
> - Add a dependency from pcs-names to pcs-handle.
> 
> [1] https://lore.kernel.org/netdev/20220711160519.741990-3-sean.anderson@seco.com/
> 
> (no changes since v4)
> 
> Changes in v4:
> - Use pcs-handle-names instead of pcs-names, as discussed
> 
> Changes in v3:
> - New
> 
>  .../bindings/net/dsa/renesas,rzn1-a5psw.yaml           |  1 +
>  .../devicetree/bindings/net/ethernet-controller.yaml   | 10 +++++++++-
>  .../devicetree/bindings/net/fsl,qoriq-mc-dpmac.yaml    |  2 +-
>  3 files changed, 11 insertions(+), 2 deletions(-)
> 

My bot found errors running 'make DT_CHECKER_FLAGS=-m dt_binding_check'
on your patch (DT_CHECKER_FLAGS is new in v5.13):

yamllint warnings/errors:

dtschema/dtc warnings/errors:
/builds/robherring/dt-review-ci/linux/Documentation/devicetree/bindings/net/dsa/renesas,rzn1-a5psw.yaml: properties:ethernet-ports:patternProperties:^(ethernet-)?port@[0-4]$:properties:pcs-handle:maxItems: False schema does not allow 1
	hint: Scalar properties should not have array keywords
	from schema $id: http://devicetree.org/meta-schemas/keywords.yaml#
/builds/robherring/dt-review-ci/linux/Documentation/devicetree/bindings/net/dsa/renesas,rzn1-a5psw.yaml: ignoring, error in schema: properties: ethernet-ports: patternProperties: ^(ethernet-)?port@[0-4]$: properties: pcs-handle: maxItems
Documentation/devicetree/bindings/net/dsa/renesas,rzn1-a5psw.example.dtb:0:0: /example-0/switch@44050000: failed to match any schema with compatible: ['renesas,r9a06g032-a5psw', 'renesas,rzn1-a5psw']
Documentation/devicetree/bindings/net/dsa/renesas,rzn1-a5psw.example.dtb:0:0: /example-0/switch@44050000: failed to match any schema with compatible: ['renesas,r9a06g032-a5psw', 'renesas,rzn1-a5psw']

doc reference errors (make refcheckdocs):

See https://patchwork.ozlabs.org/patch/

This check can fail if there are any dependencies. The base for a patch
series is generally the most recent rc1.

If you already ran 'make dt_binding_check' and didn't see the above
error(s), then make sure 'yamllint' is installed and dt-schema is up to
date:

pip3 install dtschema --upgrade

Please check and re-submit.

