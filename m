Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C88FA519166
	for <lists+netdev@lfdr.de>; Wed,  4 May 2022 00:28:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243632AbiECWZ3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 May 2022 18:25:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243612AbiECWZ2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 May 2022 18:25:28 -0400
Received: from mail-oa1-f54.google.com (mail-oa1-f54.google.com [209.85.160.54])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8A0040A11;
        Tue,  3 May 2022 15:21:54 -0700 (PDT)
Received: by mail-oa1-f54.google.com with SMTP id 586e51a60fabf-ed9a75c453so8059592fac.11;
        Tue, 03 May 2022 15:21:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:in-reply-to:references:subject:date
         :message-id;
        bh=ZMswsRgrr4czkPyiix2hW0UdLC5GFg9ChlTcl/aPVqU=;
        b=SFtaZ5pzie94h/ZfDNUkstZc1Z2YZk0VVsvQhYKbtAE7IgElRzRvpAia7e2MUEmrNj
         V5y5cbsSyB7XUSix6nXh+SsbRko7Kcc6t50Zc/cmxg8qmYt0cPrfcMBMR1QJUPY+flV/
         lp/Bl0skmcndWpjqbsCELYj5pvlCS7or6NkILbLcGf6/yISIIvKBgZBP21Nwzxgii70A
         C7hyar+n/VdKfTn4ewgd68Iw4ef/ajrGAZC3W8OQnwGRtjPRrr9t8Dh1/77alktq0ViP
         A83yGBL87Hpm/4mfxmlu2StvY/34iu5ZMajR9fqmvREB3i9/lq/dqiK1aHygY4Y6ruyY
         6O9Q==
X-Gm-Message-State: AOAM5302ESmefcJQhcxy0TTaJHoWujSGMVqH6Y3eMhp0EwXOZJ4Svj0m
        KWAPP6Otw+aD3klzUhX/j5Kc+1b36g==
X-Google-Smtp-Source: ABdhPJzUvGB897gw3KLizpqR/iiVh0AJ0DdpO0bZX5lsEQV+PSslsUA9UPO5GCcLtWc4xs2G6+i+ug==
X-Received: by 2002:a05:6870:6301:b0:e9:17b2:2e12 with SMTP id s1-20020a056870630100b000e917b22e12mr2655540oao.96.1651616513982;
        Tue, 03 May 2022 15:21:53 -0700 (PDT)
Received: from robh.at.kernel.org (66-90-144-107.dyn.grandenetworks.net. [66.90.144.107])
        by smtp.gmail.com with ESMTPSA id 23-20020a4ae1b7000000b0035eb4e5a6d8sm5456884ooy.46.2022.05.03.15.21.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 May 2022 15:21:53 -0700 (PDT)
Received: (nullmailer pid 139790 invoked by uid 1000);
        Tue, 03 May 2022 22:21:51 -0000
From:   Rob Herring <robh@kernel.org>
To:     Ansuel Smith <ansuelsmth@gmail.com>
Cc:     Jakub Kicinski <kuba@kernel.org>, Pavel Machek <pavel@ucw.cz>,
        linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-leds@vger.kernel.org, John Crispin <john@phrozen.org>,
        devicetree@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Paolo Abeni <pabeni@redhat.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Rob Herring <robh+dt@kernel.org>, netdev@vger.kernel.org,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Jonathan Corbet <corbet@lwn.net>,
        "David S. Miller" <davem@davemloft.net>
In-Reply-To: <20220503151633.18760-12-ansuelsmth@gmail.com>
References: <20220503151633.18760-1-ansuelsmth@gmail.com> <20220503151633.18760-12-ansuelsmth@gmail.com>
Subject: Re: [RFC PATCH v6 11/11] dt-bindings: net: dsa: qca8k: add LEDs definition example
Date:   Tue, 03 May 2022 17:21:51 -0500
Message-Id: <1651616511.165627.139789.nullmailer@robh.at.kernel.org>
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

On Tue, 03 May 2022 17:16:33 +0200, Ansuel Smith wrote:
> Add LEDs definition example for qca8k using the offload trigger as the
> default trigger and add all the supported offload triggers by the
> switch.
> 
> Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
> ---
>  .../devicetree/bindings/net/dsa/qca8k.yaml    | 20 +++++++++++++++++++
>  1 file changed, 20 insertions(+)
> 

My bot found errors running 'make DT_CHECKER_FLAGS=-m dt_binding_check'
on your patch (DT_CHECKER_FLAGS is new in v5.13):

yamllint warnings/errors:

dtschema/dtc warnings/errors:
Error: Documentation/devicetree/bindings/net/dsa/qca8k.example.dts:209.42-43 syntax error
FATAL ERROR: Unable to parse input tree
make[1]: *** [scripts/Makefile.lib:364: Documentation/devicetree/bindings/net/dsa/qca8k.example.dtb] Error 1
make[1]: *** Waiting for unfinished jobs....
make: *** [Makefile:1401: dt_binding_check] Error 2

doc reference errors (make refcheckdocs):

See https://patchwork.ozlabs.org/patch/

This check can fail if there are any dependencies. The base for a patch
series is generally the most recent rc1.

If you already ran 'make dt_binding_check' and didn't see the above
error(s), then make sure 'yamllint' is installed and dt-schema is up to
date:

pip3 install dtschema --upgrade

Please check and re-submit.

