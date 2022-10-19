Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BD0F46053EE
	for <lists+netdev@lfdr.de>; Thu, 20 Oct 2022 01:32:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230420AbiJSXb5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Oct 2022 19:31:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229463AbiJSXby (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Oct 2022 19:31:54 -0400
Received: from mail-oa1-f47.google.com (mail-oa1-f47.google.com [209.85.160.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 656EA170DD6;
        Wed, 19 Oct 2022 16:31:53 -0700 (PDT)
Received: by mail-oa1-f47.google.com with SMTP id 586e51a60fabf-134072c15c1so22612806fac.2;
        Wed, 19 Oct 2022 16:31:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=date:subject:message-id:references:in-reply-to:cc:to:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=+33l5I2VZMgbnyKGZxI7ecoUX1H76kvZR+34CwmtQMg=;
        b=tEB6iqz+CJ3jPSDzaFoFqTJT/7+qXhOVWGNoR9c18tlV7aB8Mc02vf3/Jxrk9+562X
         Ax7V0RIcRlCrNNKVpEatiJvNDnES0W9RAUQ0jBGydKYDkRh5BimJ7c7rA/c5163bRqhe
         +KSA6AwKZZomp9JbvbLMDeDw6DbGxg2W2xp1ZijzUgX2wlfRr+rB3AvCNbzm7h5U/ol8
         iqsi6/5uQMW1rdQt1n5S2p7pv3//iXc1utMlnEQd8Cp+8h3zcV27PvuAQhbfMDomF0VF
         LgN84+9J9VxNEiwbqP9Q7hpIgJ7QvFNKFJ0T3P020F3Zd20rV1YtU4tj337OJze+Z6EY
         38dg==
X-Gm-Message-State: ACrzQf0ILzGHJqlFpQw/JPTDoGavEoIWL7z0s++rDR2wfR6V+I+B4Lsi
        hCPxU2aKBkHROlDXrL6AeA==
X-Google-Smtp-Source: AMsMyM54aYnJHjke8Je2cYbVpvRwk2+QL/Qg8jacOx+5wLiVpGaRfOjqPn3dtsJ1MXMyo1mf64+Y8Q==
X-Received: by 2002:a05:6870:d2a0:b0:11d:37d7:9c76 with SMTP id d32-20020a056870d2a000b0011d37d79c76mr7008238oae.57.1666222312385;
        Wed, 19 Oct 2022 16:31:52 -0700 (PDT)
Received: from robh_at_kernel.org (66-90-144-107.dyn.grandenetworks.net. [66.90.144.107])
        by smtp.gmail.com with ESMTPSA id eh6-20020a056870f58600b00132e63ee5e6sm8183007oab.54.2022.10.19.16.31.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Oct 2022 16:31:51 -0700 (PDT)
Received: (nullmailer pid 19939 invoked by uid 1000);
        Wed, 19 Oct 2022 23:31:53 -0000
From:   Rob Herring <robh@kernel.org>
To:     "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
Cc:     Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>
In-Reply-To: <E1ol97m-00EDSR-46@rmk-PC.armlinux.org.uk>
References: <Y0/7dAB8OU3jrbz6@shell.armlinux.org.uk> <E1ol97m-00EDSR-46@rmk-PC.armlinux.org.uk>
Message-Id: <166622204824.13053.10147527260423850821.robh@kernel.org>
Subject: Re: [PATCH net-next 1/7] dt-bindings: net: sff,sfp: update binding
Date:   Wed, 19 Oct 2022 18:31:53 -0500
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,
        FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 19 Oct 2022 14:28:46 +0100, Russell King (Oracle) wrote:
> Add a minimum and default for the maximum-power-milliwatt option;
> module power levels were originally up to 1W, so this is the default
> and the minimum power level we can have for a functional SFP cage.
> 
> Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
> ---
>  Documentation/devicetree/bindings/net/sff,sfp.yaml | 2 ++
>  1 file changed, 2 insertions(+)
> 

My bot found errors running 'make DT_CHECKER_FLAGS=-m dt_binding_check'
on your patch (DT_CHECKER_FLAGS is new in v5.13):

yamllint warnings/errors:

dtschema/dtc warnings/errors:
/builds/robherring/dt-review-ci/linux/Documentation/devicetree/bindings/net/sff,sfp.yaml: properties:maximum-power-milliwatt: 'minimum' should not be valid under {'enum': ['const', 'enum', 'exclusiveMaximum', 'exclusiveMinimum', 'minimum', 'maximum', 'multipleOf', 'pattern']}
	hint: Scalar and array keywords cannot be mixed
	from schema $id: http://devicetree.org/meta-schemas/keywords.yaml#

doc reference errors (make refcheckdocs):

See https://patchwork.ozlabs.org/patch/

This check can fail if there are any dependencies. The base for a patch
series is generally the most recent rc1.

If you already ran 'make dt_binding_check' and didn't see the above
error(s), then make sure 'yamllint' is installed and dt-schema is up to
date:

pip3 install dtschema --upgrade

Please check and re-submit.

