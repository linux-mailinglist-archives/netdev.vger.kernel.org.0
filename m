Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 25CFD501B77
	for <lists+netdev@lfdr.de>; Thu, 14 Apr 2022 21:01:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343644AbiDNTDb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Apr 2022 15:03:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240550AbiDNTCR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Apr 2022 15:02:17 -0400
Received: from mail-oa1-f53.google.com (mail-oa1-f53.google.com [209.85.160.53])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF10A35DD1;
        Thu, 14 Apr 2022 11:59:50 -0700 (PDT)
Received: by mail-oa1-f53.google.com with SMTP id 586e51a60fabf-df22f50e0cso6189323fac.3;
        Thu, 14 Apr 2022 11:59:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:in-reply-to:references:subject:date
         :message-id;
        bh=sGXGJsA6ojsv1bZR7pNAd+jEQyhK/dZz4WuojRJvdPo=;
        b=OAnhA4GUJ/NSZaI1OetcGpHAjz/Q7L0YjujNsg4Ug5GM5YytL7qboTlhzJHhhIR0ve
         WY4Fr46XA2yft08aouPKUbLOFkP5cgfW8SLYueEwSUAViAehrPoj1kUXRm9zdEJURb6p
         NaRXQx0jxC6d4d2d1Pp465c1+ISpMaqCgvM2MRUelW8XRJZvibXNAwn6TctRYmt4wPUP
         9H++Bt4H22P+WWSbKbpGB3uRksPkqIUIU/lmXoB5fYQPEab5PeHNwq/ENT8aZzdwAzn/
         aHZ2alqMJyv8liwTHkMwyRuMxImppMO1xqZj7oma5wls5lp4vsJA5fzNZz4xNdSCGeSJ
         tvyg==
X-Gm-Message-State: AOAM5326Hz0RJM11AkdLxV3MbILiTm12xX40zGwpxkoUU22mF7QTozm0
        007o7VBMxFL3sp+AykLnUg==
X-Google-Smtp-Source: ABdhPJzl2G7/Jj7Yz2M4LJif3HpLB1RIFVYTsN5iMog0zkACwjqqeuSpXmtLg6UZNKYv/jBw5JCGrA==
X-Received: by 2002:a05:6870:d392:b0:e2:aa54:9601 with SMTP id k18-20020a056870d39200b000e2aa549601mr16586oag.184.1649962789989;
        Thu, 14 Apr 2022 11:59:49 -0700 (PDT)
Received: from robh.at.kernel.org (66-90-144-107.dyn.grandenetworks.net. [66.90.144.107])
        by smtp.gmail.com with ESMTPSA id 1-20020a05687011c100b000de98359b43sm998780oav.1.2022.04.14.11.59.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Apr 2022 11:59:49 -0700 (PDT)
Received: (nullmailer pid 2441854 invoked by uid 1000);
        Thu, 14 Apr 2022 18:59:45 -0000
From:   Rob Herring <robh@kernel.org>
To:     =?utf-8?b?Q2zDqW1lbnQgTMOpZ2Vy?= <clement.leger@bootlin.com>
Cc:     linux-renesas-soc@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Herve Codina <herve.codina@bootlin.com>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        =?utf-8?q?Miqu=C3=A8l_Raynal?= <miquel.raynal@bootlin.com>,
        Vladimir Oltean <olteanv@gmail.com>, netdev@vger.kernel.org,
        Milan Stevanovic <milan.stevanovic@se.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Magnus Damm <magnus.damm@gmail.com>,
        Jimmy Lalande <jimmy.lalande@se.com>,
        devicetree@vger.kernel.org, Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Rob Herring <robh+dt@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        linux-kernel@vger.kernel.org,
        Florian Fainelli <f.fainelli@gmail.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>
In-Reply-To: <20220414122250.158113-6-clement.leger@bootlin.com>
References: <20220414122250.158113-1-clement.leger@bootlin.com> <20220414122250.158113-6-clement.leger@bootlin.com>
Subject: Re: [PATCH net-next 05/12] dt-bindings: net: dsa: add bindings for Renesas RZ/N1 Advanced 5 port switch
Date:   Thu, 14 Apr 2022 13:59:45 -0500
Message-Id: <1649962785.217704.2441853.nullmailer@robh.at.kernel.org>
X-Spam-Status: No, score=-0.2 required=5.0 tests=BAYES_00,
        FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,PP_MIME_FAKE_ASCII_TEXT,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_PASS,T_FILL_THIS_FORM_SHORT,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 14 Apr 2022 14:22:43 +0200, Clément Léger wrote:
> Add bindings for Renesas RZ/N1 Advanced 5 port switch. This switch is
> present on Renesas RZ/N1 SoC and was probably provided by MoreThanIP.
> This company does not exists anymore and has been bought by Synopsys.
> Since this IP can't be find anymore in the Synospsy portfolio, lets use
> Renesas as the vendor compatible for this IP.
> 
> Signed-off-by: Clément Léger <clement.leger@bootlin.com>
> ---
>  .../bindings/net/dsa/renesas,rzn1-a5psw.yaml  | 128 ++++++++++++++++++
>  1 file changed, 128 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/net/dsa/renesas,rzn1-a5psw.yaml
> 

My bot found errors running 'make DT_CHECKER_FLAGS=-m dt_binding_check'
on your patch (DT_CHECKER_FLAGS is new in v5.13):

yamllint warnings/errors:

dtschema/dtc warnings/errors:
schemas/net/dsa/mdio.yaml: ignoring, error parsing file
schemas/net/dsa/mdio.yaml: ignoring, error parsing file
Traceback (most recent call last):
  File "/usr/local/bin/dt-validate", line 176, in <module>
    sg.check_trees(filename, testtree)
  File "/usr/local/bin/dt-validate", line 123, in check_trees
    self.check_subtree(dt, subtree, False, "/", "/", filename)
  File "/usr/local/bin/dt-validate", line 112, in check_subtree
    self.check_subtree(tree, value, disabled, name, fullname + name, filename)
  File "/usr/local/bin/dt-validate", line 112, in check_subtree
    self.check_subtree(tree, value, disabled, name, fullname + name, filename)
  File "/usr/local/bin/dt-validate", line 107, in check_subtree
    self.check_node(tree, subtree, disabled, nodename, fullname, filename)
  File "/usr/local/bin/dt-validate", line 51, in check_node
    errors = sorted(dtschema.DTValidator(schema).iter_errors(node), key=lambda e: e.linecol)
  File "/usr/local/lib/python3.8/dist-packages/dtschema/lib.py", line 1027, in iter_errors
    for error in super().iter_errors(instance, _schema):
  File "/usr/local/lib/python3.8/dist-packages/jsonschema/validators.py", line 229, in iter_errors
    for error in errors:
  File "/usr/local/lib/python3.8/dist-packages/jsonschema/_validators.py", line 332, in properties
    yield from validator.descend(
  File "/usr/local/lib/python3.8/dist-packages/jsonschema/validators.py", line 245, in descend
    for error in self.evolve(schema=schema).iter_errors(instance):
  File "/usr/local/lib/python3.8/dist-packages/dtschema/lib.py", line 1027, in iter_errors
    for error in super().iter_errors(instance, _schema):
  File "/usr/local/lib/python3.8/dist-packages/jsonschema/validators.py", line 229, in iter_errors
    for error in errors:
  File "/usr/local/lib/python3.8/dist-packages/jsonschema/_validators.py", line 298, in ref
    yield from validator.descend(instance, resolved)
  File "/usr/local/lib/python3.8/dist-packages/jsonschema/validators.py", line 245, in descend
    for error in self.evolve(schema=schema).iter_errors(instance):
  File "/usr/local/lib/python3.8/dist-packages/dtschema/lib.py", line 1027, in iter_errors
    for error in super().iter_errors(instance, _schema):
  File "/usr/local/lib/python3.8/dist-packages/jsonschema/validators.py", line 219, in iter_errors
    scope = id_of(_schema)
  File "/usr/local/lib/python3.8/dist-packages/jsonschema/validators.py", line 96, in _id_of
    return schema.get("$id", "")
AttributeError: 'NoneType' object has no attribute 'get'

doc reference errors (make refcheckdocs):

See https://patchwork.ozlabs.org/patch/

This check can fail if there are any dependencies. The base for a patch
series is generally the most recent rc1.

If you already ran 'make dt_binding_check' and didn't see the above
error(s), then make sure 'yamllint' is installed and dt-schema is up to
date:

pip3 install dtschema --upgrade

Please check and re-submit.

