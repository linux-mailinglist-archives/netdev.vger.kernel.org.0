Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 71AD460EA76
	for <lists+netdev@lfdr.de>; Wed, 26 Oct 2022 22:43:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234321AbiJZUni (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Oct 2022 16:43:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234822AbiJZUnW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Oct 2022 16:43:22 -0400
Received: from mail-oi1-f171.google.com (mail-oi1-f171.google.com [209.85.167.171])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F9C6122764;
        Wed, 26 Oct 2022 13:43:15 -0700 (PDT)
Received: by mail-oi1-f171.google.com with SMTP id o64so20277184oib.12;
        Wed, 26 Oct 2022 13:43:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CFt4o/3AT7ylhMFk0KUVLNuDtN3vtOK7H3Uzq0oMikI=;
        b=yCx/jvl7ITE8igLuPQWonXYV1sQUK7VCjOR53k1gGJMAked3gm8UHR2ADV7Cr4qK0h
         xmzdbdN1LUeR3IDG7iHWG5T3DtGqZF2pE0cTwtIdNutyILINIDp/o1hF7lN8a3Z2U21W
         MhFJUCvIoS6S2HF4oP8swjquFYxJ/P2VLwXNYdcmV2FDPjBiNO06xzo3Ngid8D4Zx+/B
         1j58FP4MxWuaPkuN7wX20whispWy7svmOmoPM4TIPtDPDD6Ah9xuEjijK8Q2QsKASM2F
         +CXSNg0UPqGqTOvNsQvXgZfdoMKqDN73uegv3bKPA5ObvmDaPRarC0zwQN9RoHkiPUg4
         1ozQ==
X-Gm-Message-State: ACrzQf0B71KOOoNOwoCFcr2jPLeRyDgSarrGyxSAYgepi46Of1TXgsIb
        1mSVkaQdesshKrvJWlmajg==
X-Google-Smtp-Source: AMsMyM7FmTGjqZWaN9pK4q0aJPmcWfpnQ4tqzXj0b6mzjLRH5YI3B2/g1IWpgJXqTHLyY1pepDgXOQ==
X-Received: by 2002:a05:6808:179a:b0:354:979e:abf8 with SMTP id bg26-20020a056808179a00b00354979eabf8mr2977935oib.238.1666816994439;
        Wed, 26 Oct 2022 13:43:14 -0700 (PDT)
Received: from robh_at_kernel.org (66-90-144-107.dyn.grandenetworks.net. [66.90.144.107])
        by smtp.gmail.com with ESMTPSA id l2-20020a05683016c200b006679a03a753sm1797882otr.11.2022.10.26.13.43.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Oct 2022 13:43:13 -0700 (PDT)
Received: (nullmailer pid 1286320 invoked by uid 1000);
        Wed, 26 Oct 2022 20:43:15 -0000
Date:   Wed, 26 Oct 2022 15:43:15 -0500
From:   Rob Herring <robh@kernel.org>
To:     Siddharth Vadapalli <s-vadapalli@ti.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, krzysztof.kozlowski@linaro.org,
        krzysztof.kozlowski+dt@linaro.org, linux@armlinux.org.uk,
        vladimir.oltean@nxp.com, vigneshr@ti.com, nsekhar@ti.com,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v3 1/3] dt-bindings: net: ti: k3-am654-cpsw-nuss: Update
 bindings for J721e CPSW9G
Message-ID: <20221026204315.GA1161577-robh@kernel.org>
References: <20221026090957.180592-1-s-vadapalli@ti.com>
 <20221026090957.180592-2-s-vadapalli@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221026090957.180592-2-s-vadapalli@ti.com>
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 26, 2022 at 02:39:55PM +0530, Siddharth Vadapalli wrote:
> Update bindings for TI K3 J721e SoC which contains 9 ports (8 external
> ports) CPSW9G module and add compatible for it.

Don't repeat 'bindings' in the subject, space is precious:

dt-bindings: net: ti: k3-am654-cpsw-nuss: Add J721e CPSW9G support

Otherwise,

Reviewed-by: Rob Herring <robh@kernel.org>

> 
> Changes made:
>     - Add new compatible ti,j721e-cpswxg-nuss for CPSW9G.
>     - Extend pattern properties for new compatible.
>     - Change maximum number of CPSW ports to 8 for new compatible.
> 
> Signed-off-by: Siddharth Vadapalli <s-vadapalli@ti.com>
> ---
>  .../bindings/net/ti,k3-am654-cpsw-nuss.yaml   | 33 ++++++++++++++++---
>  1 file changed, 29 insertions(+), 4 deletions(-)
