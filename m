Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5D7BE5A2BEE
	for <lists+netdev@lfdr.de>; Fri, 26 Aug 2022 18:06:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244437AbiHZQFr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Aug 2022 12:05:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344189AbiHZQFn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Aug 2022 12:05:43 -0400
Received: from mail-oa1-f48.google.com (mail-oa1-f48.google.com [209.85.160.48])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27630BBA50;
        Fri, 26 Aug 2022 09:05:40 -0700 (PDT)
Received: by mail-oa1-f48.google.com with SMTP id 586e51a60fabf-11d2dcc31dbso2593876fac.7;
        Fri, 26 Aug 2022 09:05:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=message-id:date:subject:references:in-reply-to:cc:to:from
         :x-gm-message-state:from:to:cc;
        bh=Bt46CA3gkhtjHQtX98/khRB3Yq8EzK753ZbUa2Xb1R4=;
        b=kIkRE0KZbp4pkk4FPR93yi1zSdmDWHVWbnKB1c/rrNfb9sSWBcLPwABmAqkz/F80w0
         IExWhsSBC0tR9XKkD/hFMSkLigyShCYZKrFk9x57VWfK6lNpGe3kIU+n6OXWUyweySbR
         Q4t3MnESINyKAaD/AVJr2TIl5wuiw54eo48gmG4AcOKlA/uXd0Xhodw+pIu7dxETRhKH
         m/Q/zHqm5dciTW6z6jfvQsf9RG+5geRub8t7hji/Yzc53f7CAvZGiv6hfGkNmeWCJpd2
         SWp2zjDYjtQr9dguT8iKp/NXGUWhJUmhheZhYbmynStSUJXWyQhrG5PTRa8SYYfXQZsC
         q1Jg==
X-Gm-Message-State: ACgBeo3sY8g9IhGVuleTsJe3cdLUxD/EV40JKnB4dFjxxu+oc+S1IyLX
        HeAucVo90sehVjJwlqc6mg==
X-Google-Smtp-Source: AA6agR5qo/Htznv740wYaz6ZBJU7DWuY9xkifeqYbjUccJ1C8uL4cnUGayiUfnbXUI+6wiQlGYSgNw==
X-Received: by 2002:a05:6870:3484:b0:11e:4465:3d9b with SMTP id n4-20020a056870348400b0011e44653d9bmr2311584oah.46.1661529939549;
        Fri, 26 Aug 2022 09:05:39 -0700 (PDT)
Received: from robh.at.kernel.org (66-90-144-107.dyn.grandenetworks.net. [66.90.144.107])
        by smtp.gmail.com with ESMTPSA id y16-20020a056870429000b0010bf07976c9sm1465908oah.41.2022.08.26.09.05.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Aug 2022 09:05:39 -0700 (PDT)
Received: (nullmailer pid 3267073 invoked by uid 1000);
        Fri, 26 Aug 2022 16:05:31 -0000
From:   Rob Herring <robh@kernel.org>
To:     Michael Walle <michael@walle.cc>
Cc:     Vignesh Raghavendra <vigneshr@ti.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Eric Dumazet <edumazet@google.com>, devicetree@vger.kernel.org,
        netdev@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Frank Rowand <frowand.list@gmail.com>,
        Ahmad Fatoum <a.fatoum@pengutronix.de>,
        linux-arm-kernel@lists.infradead.org,
        =?utf-8?b?UmFmYcWCIE1pxYJlY2tp?= <rafal@milecki.pl>,
        Shawn Guo <shawnguo@kernel.org>, Li Yang <leoyang.li@nxp.com>,
        "David S . Miller" <davem@davemloft.net>,
        Richard Weinberger <richard@nod.at>,
        linux-kernel@vger.kernel.org,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        linux-mtd@lists.infradead.org,
        Miquel Raynal <miquel.raynal@bootlin.com>
In-Reply-To: <20220825214423.903672-10-michael@walle.cc>
References: <20220825214423.903672-1-michael@walle.cc> <20220825214423.903672-10-michael@walle.cc>
Subject: Re: [PATCH v1 09/14] dt-bindings: nvmem: add YAML schema for the sl28 vpd layout
Date:   Fri, 26 Aug 2022 11:05:31 -0500
Message-Id: <1661529931.067130.3267072.nullmailer@robh.at.kernel.org>
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

On Thu, 25 Aug 2022 23:44:18 +0200, Michael Walle wrote:
> Add a schema for the NVMEM layout on Kontron's sl28 boards.
> 
> Signed-off-by: Michael Walle <michael@walle.cc>
> ---
>  .../nvmem/layouts/kontron,sl28-vpd.yaml       | 52 +++++++++++++++++++
>  1 file changed, 52 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/nvmem/layouts/kontron,sl28-vpd.yaml
> 

My bot found errors running 'make DT_CHECKER_FLAGS=-m dt_binding_check'
on your patch (DT_CHECKER_FLAGS is new in v5.13):

yamllint warnings/errors:

dtschema/dtc warnings/errors:
/builds/robherring/linux-dt-review/Documentation/devicetree/bindings/mtd/mtd.example.dtb: otp-2: compatible:0: 'kontron,sl28-vpd' was expected
	From schema: /builds/robherring/linux-dt-review/Documentation/devicetree/bindings/nvmem/layouts/kontron,sl28-vpd.yaml
/builds/robherring/linux-dt-review/Documentation/devicetree/bindings/mtd/mtd.example.dtb: otp-2: compatible: ['user-otp'] is too short
	From schema: /builds/robherring/linux-dt-review/Documentation/devicetree/bindings/nvmem/layouts/kontron,sl28-vpd.yaml
/builds/robherring/linux-dt-review/Documentation/devicetree/bindings/mtd/mtd.example.dtb: otp-2: '#address-cells', '#size-cells', 'mac-address@0' do not match any of the regexes: 'pinctrl-[0-9]+'
	From schema: /builds/robherring/linux-dt-review/Documentation/devicetree/bindings/nvmem/layouts/kontron,sl28-vpd.yaml

doc reference errors (make refcheckdocs):

See https://patchwork.ozlabs.org/patch/

This check can fail if there are any dependencies. The base for a patch
series is generally the most recent rc1.

If you already ran 'make dt_binding_check' and didn't see the above
error(s), then make sure 'yamllint' is installed and dt-schema is up to
date:

pip3 install dtschema --upgrade

Please check and re-submit.

