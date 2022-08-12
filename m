Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F33E65912C0
	for <lists+netdev@lfdr.de>; Fri, 12 Aug 2022 17:15:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238827AbiHLPOc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Aug 2022 11:14:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238884AbiHLPOE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Aug 2022 11:14:04 -0400
Received: from mail-io1-f44.google.com (mail-io1-f44.google.com [209.85.166.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADA78A7A80;
        Fri, 12 Aug 2022 08:14:03 -0700 (PDT)
Received: by mail-io1-f44.google.com with SMTP id y82so1036451iof.7;
        Fri, 12 Aug 2022 08:14:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=message-id:date:subject:references:in-reply-to:cc:to:from
         :x-gm-message-state:from:to:cc;
        bh=BMZIfIjHtqwgWzdSXqrr9NE51goJCuzG7L3KL1zDXNg=;
        b=ayvCdLOUb48rYdOu0LdKroaJVyWioYQbD6+SIjy5PATK4ASBzyDLI/5sb5bO2neY0T
         F/Iabg3OkoNohl+22WS+N301K7wBLJLjksbcGYi+82YNzvQ8Su1VTGu0bia4twI81faX
         olszei0oIV+AuSoZ68fmvejUV4mH3bXM/YLQ+kIIgI1pBRGCTxJzOhuaz0koSEGrmSEB
         evpSdmpiz17lhV4ZnibDAjM+EQUPY9qjiavqbBfg8VXwXPLR3KTdYYYp6Pelscp4tA54
         j31RgkIl0ri6uzvY6POj2Zy3Qt99amrhI0wMv6ElNqnbfr6AOdcWY0s7c8J6Xow+aS3u
         ImeA==
X-Gm-Message-State: ACgBeo2L/zNJryjX0/Rlk5PdtTn0/BzC+blxQ3AO6AvRBADtJWUhjGWg
        /IyznzVIVt5H+K4h0RNUBQ==
X-Google-Smtp-Source: AA6agR4X5v/nUftmGk0t9KaWseTabpHT1C+d74LDJT61kSTdh21Tr/Mjcs4ZeK6MF/9vOSWFo+VCrw==
X-Received: by 2002:a05:6638:3892:b0:342:8aa5:a050 with SMTP id b18-20020a056638389200b003428aa5a050mr2305379jav.145.1660317242922;
        Fri, 12 Aug 2022 08:14:02 -0700 (PDT)
Received: from robh.at.kernel.org ([64.188.179.248])
        by smtp.gmail.com with ESMTPSA id k17-20020a023351000000b0034286654d38sm1082746jak.82.2022.08.12.08.14.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Aug 2022 08:14:02 -0700 (PDT)
Received: (nullmailer pid 168986 invoked by uid 1000);
        Fri, 12 Aug 2022 15:13:53 -0000
From:   Rob Herring <robh@kernel.org>
To:     wei.fang@nxp.com
Cc:     andrew@lunn.ch, pabeni@redhat.com, robh+dt@kernel.org,
        f.fainelli@gmail.com, hkallweit1@gmail.com, netdev@vger.kernel.org,
        krzysztof.kozlowski+dt@linaro.org, linux-kernel@vger.kernel.org,
        davem@davemloft.net, linux@armlinux.org.uk, edumazet@google.com,
        kuba@kernel.org, devicetree@vger.kernel.org
In-Reply-To: <20220812145009.1229094-2-wei.fang@nxp.com>
References: <20220812145009.1229094-1-wei.fang@nxp.com> <20220812145009.1229094-2-wei.fang@nxp.com>
Subject: Re: [PATCH net 1/2] dt: ar803x: Document disable-hibernation property
Date:   Fri, 12 Aug 2022 09:13:53 -0600
Message-Id: <1660317233.459028.168985.nullmailer@robh.at.kernel.org>
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

On Sat, 13 Aug 2022 00:50:08 +1000, wei.fang@nxp.com wrote:
> From: Wei Fang <wei.fang@nxp.com>
> 
> The hibernation mode of Atheros AR803x PHYs is default enabled.
> When the cable is unplugged, the PHY will enter hibernation
> mode and the PHY clock does down. For some MACs, it needs the
> clock to support it's logic. For instance, stmmac needs the PHY
> inputs clock is present for software reset completion. Therefore,
> It is reasonable to add a DT property to disable hibernation mode.
> 
> Signed-off-by: Wei Fang <wei.fang@nxp.com>
> ---
>  Documentation/devicetree/bindings/net/qca,ar803x.yaml | 6 ++++++
>  1 file changed, 6 insertions(+)
> 

My bot found errors running 'make DT_CHECKER_FLAGS=-m dt_binding_check'
on your patch (DT_CHECKER_FLAGS is new in v5.13):

yamllint warnings/errors:
./Documentation/devicetree/bindings/net/qca,ar803x.yaml:46:5: [error] syntax error: could not find expected ':' (syntax)

dtschema/dtc warnings/errors:
make[1]: *** Deleting file 'Documentation/devicetree/bindings/net/qca,ar803x.example.dts'
Documentation/devicetree/bindings/net/qca,ar803x.yaml:46:5: could not find expected ':'
make[1]: *** [Documentation/devicetree/bindings/Makefile:26: Documentation/devicetree/bindings/net/qca,ar803x.example.dts] Error 1
make[1]: *** Waiting for unfinished jobs....
./Documentation/devicetree/bindings/net/qca,ar803x.yaml:46:5: could not find expected ':'
/builds/robherring/linux-dt-review/Documentation/devicetree/bindings/net/qca,ar803x.yaml: ignoring, error parsing file
make: *** [Makefile:1404: dt_binding_check] Error 2

doc reference errors (make refcheckdocs):

See https://patchwork.ozlabs.org/patch/

This check can fail if there are any dependencies. The base for a patch
series is generally the most recent rc1.

If you already ran 'make dt_binding_check' and didn't see the above
error(s), then make sure 'yamllint' is installed and dt-schema is up to
date:

pip3 install dtschema --upgrade

Please check and re-submit.

