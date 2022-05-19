Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7505052C85E
	for <lists+netdev@lfdr.de>; Thu, 19 May 2022 02:08:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231682AbiESAI3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 May 2022 20:08:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231965AbiESAIV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 May 2022 20:08:21 -0400
Received: from mail-oi1-f181.google.com (mail-oi1-f181.google.com [209.85.167.181])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DB02DE327;
        Wed, 18 May 2022 17:08:12 -0700 (PDT)
Received: by mail-oi1-f181.google.com with SMTP id m25so4666730oih.2;
        Wed, 18 May 2022 17:08:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:in-reply-to:references:subject:date
         :message-id;
        bh=vCQnkYgc1zVHenxwoyabefaogr520hch3r3ycwfJxBY=;
        b=yihaYLqPs2+rTqBNUBjTTQROLZ9EWIIrDkqeh1dCc+ScLg46UxYmX8/TirpdvT2uqq
         AX9LdvRz2ApBmvQiBkDcnq0lri+f5avVP5p/WSMSCOfJStRFltwkiiQMwHsYyPSGe9xC
         0FCTS+29optLI6yxozLTGaigurfyYHTMq8QHw3ACfOcK5Nzxadrnql9Izpdo9W9vO0YW
         UyF5AxkpN6gASxvOK+AfAadUJ3rROQ6cmnu3H/h+zyskLlhyf05fXtYoTXbDpYdvx81K
         BdoM06Ri/R/c52BHd7e2jwF4vpYhffqH5HFwM26J0NmrmdvcpBRCDIoXSWLcbAOpg556
         SqyA==
X-Gm-Message-State: AOAM533BShjBUemMCMHszNxUESZxhIGt0B+k119jnErYQ+GH6GmoehUI
        eEUFeqbMh38bhaS6ghuH4g==
X-Google-Smtp-Source: ABdhPJxpp9m6M87ZFeTNPEQnDSUwEbSseDW7JPj0qpBLpkd8eWwd79O5OpLHulj0YFHL7xqDn/FaSQ==
X-Received: by 2002:a05:6808:10ca:b0:32a:dc6a:da6f with SMTP id s10-20020a05680810ca00b0032adc6ada6fmr1406701ois.41.1652918891363;
        Wed, 18 May 2022 17:08:11 -0700 (PDT)
Received: from robh.at.kernel.org (66-90-144-107.dyn.grandenetworks.net. [66.90.144.107])
        by smtp.gmail.com with ESMTPSA id m18-20020a9d7e92000000b0060603221268sm1222721otp.56.2022.05.18.17.08.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 May 2022 17:08:10 -0700 (PDT)
Received: (nullmailer pid 50697 invoked by uid 1000);
        Thu, 19 May 2022 00:08:09 -0000
From:   Rob Herring <robh@kernel.org>
To:     Corentin Labbe <clabbe@baylibre.com>
Cc:     pabeni@redhat.com, linux-arm-kernel@lists.infradead.org,
        samuel@sholland.org, kuba@kernel.org, broonie@kernel.org,
        linux-kernel@vger.kernel.org, lgirdwood@gmail.com,
        edumazet@google.com, hkallweit1@gmail.com, wens@csie.org,
        andrew@lunn.ch, davem@davemloft.net, linux-sunxi@lists.linux.dev,
        krzysztof.kozlowski+dt@linaro.org, devicetree@vger.kernel.org,
        jernej.skrabec@gmail.com, calvin.johnson@oss.nxp.com,
        netdev@vger.kernel.org, linux@armlinux.org.uk, robh+dt@kernel.org
In-Reply-To: <20220518200939.689308-5-clabbe@baylibre.com>
References: <20220518200939.689308-1-clabbe@baylibre.com> <20220518200939.689308-5-clabbe@baylibre.com>
Subject: Re: [PATCH v2 4/5] dt-bindings: net: Add documentation for optional regulators
Date:   Wed, 18 May 2022 19:08:09 -0500
Message-Id: <1652918889.376228.50696.nullmailer@robh.at.kernel.org>
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

On Wed, 18 May 2022 20:09:38 +0000, Corentin Labbe wrote:
> Add entries for the new optional regulators.
> 
> Signed-off-by: Corentin Labbe <clabbe@baylibre.com>
> ---
>  Documentation/devicetree/bindings/net/ethernet-phy.yaml | 9 +++++++++
>  1 file changed, 9 insertions(+)
> 

My bot found errors running 'make DT_CHECKER_FLAGS=-m dt_binding_check'
on your patch (DT_CHECKER_FLAGS is new in v5.13):

yamllint warnings/errors:
./Documentation/devicetree/bindings/net/ethernet-phy.yaml:149:8: [warning] wrong indentation: expected 6 but found 7 (indentation)

dtschema/dtc warnings/errors:

doc reference errors (make refcheckdocs):

See https://patchwork.ozlabs.org/patch/

This check can fail if there are any dependencies. The base for a patch
series is generally the most recent rc1.

If you already ran 'make dt_binding_check' and didn't see the above
error(s), then make sure 'yamllint' is installed and dt-schema is up to
date:

pip3 install dtschema --upgrade

Please check and re-submit.

