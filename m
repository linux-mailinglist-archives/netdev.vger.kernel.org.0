Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 239EE5B8CCB
	for <lists+netdev@lfdr.de>; Wed, 14 Sep 2022 18:23:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229616AbiINQXG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Sep 2022 12:23:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229587AbiINQXF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Sep 2022 12:23:05 -0400
Received: from mail-oa1-f43.google.com (mail-oa1-f43.google.com [209.85.160.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7959CDB;
        Wed, 14 Sep 2022 09:23:04 -0700 (PDT)
Received: by mail-oa1-f43.google.com with SMTP id 586e51a60fabf-1279948d93dso42308424fac.10;
        Wed, 14 Sep 2022 09:23:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=kkiJ2QjkXnMB41sUfUeccKp4SNjAEkQI5boRWjBFc08=;
        b=GZ6hj7oAVUSMzR9c1KUH6Pfzg/nafDv7Ncsg/WVWXd9dVrb2j8gTZG/C4rnUqxg+mc
         rEHovf7PWeVstBeSZH+8VOSQOFgvvuFUHA1WJ5K3m8+lPJrESv2tT/7J50zZXA9MwVbm
         Wa3YvdGICNhxP5vGajMwfNbC1Y/NzV+xuWXEqwvrydo9TPd6S86OrS8IrB5uQCr4yTok
         Amm/5bL2zl7JGkEuJhSubPedfQcgbbaFOkukRwdBnzCN7zbsyP0+rekdX98a6x4cbdIC
         /Yt7DWrJ0ZNDvecw9h4g6fd7u78mQBPFc9wNoKfrl/1XiB/MHZowZYY5+JhiBvK/o2mt
         gNqQ==
X-Gm-Message-State: ACgBeo2OzcG0UU5dxT1T0yiCq4qqvG72uaIYxn4aNPB2K6wgaXvdReDe
        2NncP/HjvVV6Y1JrSCXNiA==
X-Google-Smtp-Source: AA6agR4yXmDTUtpS5negz9/3cRnAaZwJa9iYI3g67nuCBTVaTrtcngEtf+aypRfug1+79wQ4Acy6zw==
X-Received: by 2002:a05:6870:568b:b0:127:9fdd:f31b with SMTP id p11-20020a056870568b00b001279fddf31bmr2926635oao.79.1663172583965;
        Wed, 14 Sep 2022 09:23:03 -0700 (PDT)
Received: from robh.at.kernel.org (66-90-144-107.dyn.grandenetworks.net. [66.90.144.107])
        by smtp.gmail.com with ESMTPSA id t35-20020a05687063a300b00127c03b39cesm8601649oap.35.2022.09.14.09.23.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Sep 2022 09:23:03 -0700 (PDT)
Received: (nullmailer pid 2478210 invoked by uid 1000);
        Wed, 14 Sep 2022 16:23:02 -0000
Date:   Wed, 14 Sep 2022 11:23:02 -0500
From:   Rob Herring <robh@kernel.org>
To:     Siddharth Vadapalli <s-vadapalli@ti.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, krzysztof.kozlowski@linaro.org,
        krzysztof.kozlowski+dt@linaro.org, linux@armlinux.org.uk,
        vladimir.oltean@nxp.com, grygorii.strashko@ti.com, vigneshr@ti.com,
        nsekhar@ti.com, netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kishon@ti.com
Subject: Re: [PATCH 1/8] dt-bindings: net: ti: k3-am654-cpsw-nuss: Update
 bindings for J721e CPSW9G
Message-ID: <20220914162302.GA2468487-robh@kernel.org>
References: <20220914095053.189851-1-s-vadapalli@ti.com>
 <20220914095053.189851-2-s-vadapalli@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220914095053.189851-2-s-vadapalli@ti.com>
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

On Wed, Sep 14, 2022 at 03:20:46PM +0530, Siddharth Vadapalli wrote:
> Update bindings for TI K3 J721e SoC which contains 9 ports (8 external
> ports) CPSW9G module and add compatible for it.
> 
> Changes made:
>     - Add new compatible ti,j721e-cpswxg-nuss for CPSW9G.
>     - Extend pattern properties for new compatible.
>     - Change maximum number of CPSW ports to 8 for new compatible.
> 
> Signed-off-by: Siddharth Vadapalli <s-vadapalli@ti.com>
> ---
>  .../bindings/net/ti,k3-am654-cpsw-nuss.yaml   | 23 +++++++++++++++++--
>  1 file changed, 21 insertions(+), 2 deletions(-)

What's the base for this patch? It didn't apply for me.

Run 'make dt_binding_check'. It should point out the issue I did. If 
not, let me know.

Rob
