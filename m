Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7195B5B6BBD
	for <lists+netdev@lfdr.de>; Tue, 13 Sep 2022 12:37:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231615AbiIMKhg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Sep 2022 06:37:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229866AbiIMKhf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Sep 2022 06:37:35 -0400
Received: from mail-oa1-f46.google.com (mail-oa1-f46.google.com [209.85.160.46])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A1DD1A839;
        Tue, 13 Sep 2022 03:37:34 -0700 (PDT)
Received: by mail-oa1-f46.google.com with SMTP id 586e51a60fabf-1274ec87ad5so30981861fac.0;
        Tue, 13 Sep 2022 03:37:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=message-id:date:subject:references:in-reply-to:cc:to:from
         :x-gm-message-state:from:to:cc:subject:date;
        bh=8+JGqRHJMWZ89HHRv12KwXXy6JtSzUYuKEfx3af7iOU=;
        b=cbtcA2vAj4QXASqDXHPSTEpIDZaDAtmL7nS/z/5o/YeAYjtXV79/p+GSGLEGJMvuxK
         DlkioSZ8DM7CkX55SqBoZITfMzMhf0FA5b4Rtgj0nduNa13D7MBeLdzrmtjGj4f2OrmZ
         ys55tRx96NlPaP/lf2R5AESciCiQTy8+Hd4fqKd/bauIzM/bkeBebMPywfHV6EjEXJx3
         grA5gfPRU/Gjso6BXZhOS6zwfpbd6hqn8BwSpGXdEiMvPnGPZuqD4uciBXY1iLTI4WRE
         xl/z9DmqfuPwPPiRdnHcteKQpl25S27RTzLVP11rDo57Lo63Yl069PA+lg/cKEKczJOA
         DrDA==
X-Gm-Message-State: ACgBeo28/AAu/KvE+st8JydYrry7HGY/1kd4arAjygg9Pb14Pf3sk9Qn
        fe/3SoQMi56ZqQrT8hO+0Q==
X-Google-Smtp-Source: AA6agR6wzmXY5KYJRhhTfil+nFptqY6cyMGB2MN7hEDoVpAFs+verqPfjhE8phjFQDl/50HffUiPVg==
X-Received: by 2002:a05:6808:e87:b0:345:49f2:a0c4 with SMTP id k7-20020a0568080e8700b0034549f2a0c4mr1120078oil.17.1663065453734;
        Tue, 13 Sep 2022 03:37:33 -0700 (PDT)
Received: from robh.at.kernel.org (66-90-144-107.dyn.grandenetworks.net. [66.90.144.107])
        by smtp.gmail.com with ESMTPSA id i27-20020a056820013b00b0042859bebfebsm5145070ood.45.2022.09.13.03.37.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Sep 2022 03:37:33 -0700 (PDT)
Received: (nullmailer pid 3153423 invoked by uid 1000);
        Tue, 13 Sep 2022 10:37:32 -0000
From:   Rob Herring <robh@kernel.org>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     linux-kernel@vger.kernel.org,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Jakub Kicinski <kuba@kernel.org>, devicetree@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>,
        linux-arm-kernel@lists.infradead.org,
        Maxim Kochetkov <fido_max@inbox.ru>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Colin Foster <colin.foster@in-advantage.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        netdev@vger.kernel.org
In-Reply-To: <20220912153702.246206-1-vladimir.oltean@nxp.com>
References: <20220912153702.246206-1-vladimir.oltean@nxp.com>
Subject: Re: [PATCH net-next] dt-bindings: net: dsa: convert ocelot.txt to dt-schema
Date:   Tue, 13 Sep 2022 05:37:32 -0500
Message-Id: <1663065452.471744.3153422.nullmailer@robh.at.kernel.org>
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

On Mon, 12 Sep 2022 18:37:02 +0300, Vladimir Oltean wrote:
> Replace the free-form description of device tree bindings for VSC9959
> and VSC9953 with a YAML formatted dt-schema description. This contains
> more or less the same information, but reworded to be a bit more
> succint.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> ---
>  .../bindings/net/dsa/mscc,ocelot.yaml         | 239 ++++++++++++++++++
>  .../devicetree/bindings/net/dsa/ocelot.txt    | 213 ----------------
>  2 files changed, 239 insertions(+), 213 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/net/dsa/mscc,ocelot.yaml
>  delete mode 100644 Documentation/devicetree/bindings/net/dsa/ocelot.txt
> 

My bot found errors running 'make DT_CHECKER_FLAGS=-m dt_binding_check'
on your patch (DT_CHECKER_FLAGS is new in v5.13):

yamllint warnings/errors:

dtschema/dtc warnings/errors:
/builds/robherring/dt-review-ci/linux/Documentation/devicetree/bindings/net/dsa/mscc,ocelot.example.dtb: ethernet-switch@0,5: Unevaluated properties are not allowed ('interrupts' was unexpected)
	From schema: /builds/robherring/dt-review-ci/linux/Documentation/devicetree/bindings/net/dsa/mscc,ocelot.yaml
/builds/robherring/dt-review-ci/linux/Documentation/devicetree/bindings/net/dsa/mscc,ocelot.example.dtb: ethernet-switch@800000: Unevaluated properties are not allowed ('little-endian' was unexpected)
	From schema: /builds/robherring/dt-review-ci/linux/Documentation/devicetree/bindings/net/dsa/mscc,ocelot.yaml

doc reference errors (make refcheckdocs):

See https://patchwork.ozlabs.org/patch/

This check can fail if there are any dependencies. The base for a patch
series is generally the most recent rc1.

If you already ran 'make dt_binding_check' and didn't see the above
error(s), then make sure 'yamllint' is installed and dt-schema is up to
date:

pip3 install dtschema --upgrade

Please check and re-submit.

