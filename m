Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3D7E3576A69
	for <lists+netdev@lfdr.de>; Sat, 16 Jul 2022 01:06:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231810AbiGOXGg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jul 2022 19:06:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229580AbiGOXGf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Jul 2022 19:06:35 -0400
Received: from mail-io1-f45.google.com (mail-io1-f45.google.com [209.85.166.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A34028B49A;
        Fri, 15 Jul 2022 16:06:34 -0700 (PDT)
Received: by mail-io1-f45.google.com with SMTP id p128so5009671iof.1;
        Fri, 15 Jul 2022 16:06:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:in-reply-to:references:subject:date
         :message-id;
        bh=YDlkhqWKsbJBSkGChagGjsv3FbYi9c+x2tAtlYBYcqs=;
        b=LExJW4pi4GcUClBF//o6HyygHymcmueSxFiZ7WATlXvnJ02P3NwRFFJWuIIwJarE0v
         5GG+9FbWCnjlVoC7SUYwJjz8iJ69VV00SM2NjYJDcYyrAlGLjk5+Sg1r1rwObGKwDaFG
         h7065MUqgWlyrDK16a96exS9M1DbcZBcLK6qihBjV4hwfRayololRO4hnPJdQ8ogXNOd
         CZV5OAuLvRw84myD2byWAf+EJ1Ck9Tl29nkTs5Sv2YEaH74cDnyxpbsMsO1HbhCyxj67
         h2v42Vu8qloFXEYWI7pMQAq61W6a67vJktrNuuEGQ1ImwFGbzjlF4G0+gQoWzkNrsjk4
         1Ozw==
X-Gm-Message-State: AJIora/1JztSBNUAAFYt0SiwgKKlz7Sr+Yn7WbPu0X9XlYnKi2g6MXT7
        bUt1xQu8bQoFni6ZaD0+hQ==
X-Google-Smtp-Source: AGRyM1sUbyT8G+qLwBnGuz9wxAX+YT+GbATzT32jX5qUjf9gpXjD6N6hWKSTZmNym1N+6hLf7WDI3Q==
X-Received: by 2002:a05:6638:3586:b0:33c:9df7:6dec with SMTP id v6-20020a056638358600b0033c9df76decmr8832917jal.175.1657926393834;
        Fri, 15 Jul 2022 16:06:33 -0700 (PDT)
Received: from robh.at.kernel.org ([64.188.179.248])
        by smtp.gmail.com with ESMTPSA id v20-20020a02b094000000b0033c836fe144sm2453075jah.85.2022.07.15.16.06.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Jul 2022 16:06:33 -0700 (PDT)
Received: (nullmailer pid 1631479 invoked by uid 1000);
        Fri, 15 Jul 2022 23:06:28 -0000
From:   Rob Herring <robh@kernel.org>
To:     Sean Anderson <sean.anderson@seco.com>
Cc:     devicetree@vger.kernel.org, Rob Herring <robh+dt@kernel.org>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        Paolo Abeni <pabeni@redhat.com>,
        Madalin Bucur <madalin.bucur@nxp.com>,
        Eric Dumazet <edumazet@google.com>,
        "David S . Miller" <davem@davemloft.net>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
In-Reply-To: <20220715215954.1449214-4-sean.anderson@seco.com>
References: <20220715215954.1449214-1-sean.anderson@seco.com> <20220715215954.1449214-4-sean.anderson@seco.com>
Subject: Re: [PATCH net-next v3 03/47] dt-bindings: net: Convert FMan MAC bindings to yaml
Date:   Fri, 15 Jul 2022 17:06:28 -0600
Message-Id: <1657926388.246596.1631478.nullmailer@robh.at.kernel.org>
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,
        FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 15 Jul 2022 17:59:10 -0400, Sean Anderson wrote:
> This converts the MAC portion of the FMan MAC bindings to yaml.
> 
> Signed-off-by: Sean Anderson <sean.anderson@seco.com>
> Reviewed-by: Rob Herring <robh@kernel.org>
> ---
> 
> Changes in v3:
> - Incorperate some minor changes into the first FMan binding commit
> 
> Changes in v2:
> - New
> 
>  .../bindings/net/fsl,fman-dtsec.yaml          | 145 ++++++++++++++++++
>  .../devicetree/bindings/net/fsl-fman.txt      | 128 +---------------
>  2 files changed, 146 insertions(+), 127 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/net/fsl,fman-dtsec.yaml
> 

My bot found errors running 'make DT_CHECKER_FLAGS=-m dt_binding_check'
on your patch (DT_CHECKER_FLAGS is new in v5.13):

yamllint warnings/errors:

dtschema/dtc warnings/errors:
/builds/robherring/linux-dt-review/Documentation/devicetree/bindings/net/fsl,fman-dtsec.example.dtb: ethernet@e8000: 'phy-connection-type', 'phy-handle' do not match any of the regexes: 'pinctrl-[0-9]+'
	From schema: /builds/robherring/linux-dt-review/Documentation/devicetree/bindings/net/fsl,fman-dtsec.yaml

doc reference errors (make refcheckdocs):

See https://patchwork.ozlabs.org/patch/

This check can fail if there are any dependencies. The base for a patch
series is generally the most recent rc1.

If you already ran 'make dt_binding_check' and didn't see the above
error(s), then make sure 'yamllint' is installed and dt-schema is up to
date:

pip3 install dtschema --upgrade

Please check and re-submit.

