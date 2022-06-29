Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C614455F339
	for <lists+netdev@lfdr.de>; Wed, 29 Jun 2022 04:11:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231287AbiF2CKL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jun 2022 22:10:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231189AbiF2CKB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jun 2022 22:10:01 -0400
Received: from mail-il1-f171.google.com (mail-il1-f171.google.com [209.85.166.171])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2E883205E;
        Tue, 28 Jun 2022 19:09:59 -0700 (PDT)
Received: by mail-il1-f171.google.com with SMTP id f15so8912563ilj.11;
        Tue, 28 Jun 2022 19:09:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:in-reply-to:references:subject:date
         :message-id;
        bh=y+RTC0AjihlAiwWDvXzA47g2ErYV5HcVBpXJ4IiEfIU=;
        b=qS+RBMGamTv2DLz/8uGD4vDJf6vx70fbgdzwAyt9VzzsCtwVj4mb1p+mc6iGusPBTH
         V0uNIm3q02flh/KKjnMV3w6PKKwED2GJd2+YAHeFBjXqVoSjgJQa0p0IfhJS9Sq85ElX
         XbQDMRblLMJMPz+sPj0SRHGawQqn+wCO8Iu1rFYcbYBBSL7wZoHZvRkDw3bASG7xcogo
         rYBJyG79sUffIu5KlooFgLw5dXnb3ki5Zh5lp1lUYN83fsJ5aFQd7W/3SwPE1cE5uB3c
         e2c5vfiMwFMwa3N3X4EvVEOTIFE8cZ4HnSwjysiUko3Q4xxLsYuPLkign2VOTPpbapm0
         bsNQ==
X-Gm-Message-State: AJIora/htHalyA2kewY/pQQYXGQdeAGmVXOjr4fgmZn7ZvsLDQelH9bK
        2gCi3QmrKdjYHFgEfBfk+g==
X-Google-Smtp-Source: AGRyM1uJFlnkUhRF4s/C169vokrsoZHMo0DUNb/hlCfpx9DWEDCPyVvbgorEGVHVkbMSerE3Kh7alg==
X-Received: by 2002:a05:6e02:20c9:b0:2d9:4742:9411 with SMTP id 9-20020a056e0220c900b002d947429411mr622645ilq.302.1656468599198;
        Tue, 28 Jun 2022 19:09:59 -0700 (PDT)
Received: from robh.at.kernel.org ([64.188.179.253])
        by smtp.gmail.com with ESMTPSA id u13-20020a5d870d000000b00669ceb1d521sm7348686iom.10.2022.06.28.19.09.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Jun 2022 19:09:58 -0700 (PDT)
Received: (nullmailer pid 1403686 invoked by uid 1000);
        Wed, 29 Jun 2022 02:09:39 -0000
From:   Rob Herring <robh@kernel.org>
To:     Sean Anderson <sean.anderson@seco.com>
Cc:     linux-arm-kernel@lists.infradead.org,
        Rob Herring <robh+dt@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        linux-kernel@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        netdev@vger.kernel.org,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        devicetree@vger.kernel.org, Madalin Bucur <madalin.bucur@nxp.com>
In-Reply-To: <20220628221404.1444200-3-sean.anderson@seco.com>
References: <20220628221404.1444200-1-sean.anderson@seco.com> <20220628221404.1444200-3-sean.anderson@seco.com>
Subject: Re: [PATCH net-next v2 02/35] dt-bindings: net: Convert FMan MAC bindings to yaml
Date:   Tue, 28 Jun 2022 20:09:39 -0600
Message-Id: <1656468579.946817.1403685.nullmailer@robh.at.kernel.org>
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

On Tue, 28 Jun 2022 18:13:31 -0400, Sean Anderson wrote:
> This converts the MAC portion of the FMan MAC bindings to yaml.
> 
> Signed-off-by: Sean Anderson <sean.anderson@seco.com>
> ---
> 
> Changes in v2:
> - New
> 
>  .../bindings/net/fsl,fman-dtsec.yaml          | 144 ++++++++++++++++++
>  .../devicetree/bindings/net/fsl-fman.txt      | 128 +---------------
>  2 files changed, 145 insertions(+), 127 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/net/fsl,fman-dtsec.yaml
> 

My bot found errors running 'make DT_CHECKER_FLAGS=-m dt_binding_check'
on your patch (DT_CHECKER_FLAGS is new in v5.13):

yamllint warnings/errors:

dtschema/dtc warnings/errors:
/builds/robherring/linux-dt-review/Documentation/devicetree/bindings/iio/temperature/adi,ltc2983.yaml: patternProperties:^thermistor@:properties:adi,excitation-current-nanoamp: '$ref' should not be valid under {'const': '$ref'}
	hint: Standard unit suffix properties don't need a type $ref
	from schema $id: http://devicetree.org/meta-schemas/core.yaml#
/builds/robherring/linux-dt-review/Documentation/devicetree/bindings/iio/temperature/adi,ltc2983.yaml: ignoring, error in schema: patternProperties: ^thermistor@: properties: adi,excitation-current-nanoamp
Documentation/devicetree/bindings/iio/temperature/adi,ltc2983.example.dtb:0:0: /example-0/spi/ltc2983@0: failed to match any schema with compatible: ['adi,ltc2983']

doc reference errors (make refcheckdocs):

See https://patchwork.ozlabs.org/patch/

This check can fail if there are any dependencies. The base for a patch
series is generally the most recent rc1.

If you already ran 'make dt_binding_check' and didn't see the above
error(s), then make sure 'yamllint' is installed and dt-schema is up to
date:

pip3 install dtschema --upgrade

Please check and re-submit.

