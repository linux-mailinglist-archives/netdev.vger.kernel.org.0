Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CFF724F6B7A
	for <lists+netdev@lfdr.de>; Wed,  6 Apr 2022 22:32:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234102AbiDFUeO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Apr 2022 16:34:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235439AbiDFUcz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Apr 2022 16:32:55 -0400
Received: from mail-oi1-f179.google.com (mail-oi1-f179.google.com [209.85.167.179])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C90F136478D;
        Wed,  6 Apr 2022 11:54:52 -0700 (PDT)
Received: by mail-oi1-f179.google.com with SMTP id b188so3330866oia.13;
        Wed, 06 Apr 2022 11:54:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:in-reply-to:references:subject:date
         :message-id;
        bh=Lm/ONmGbxsdA25Z0fG4ZT+Z1iRsHjkpKpaJkjdZ5COY=;
        b=OBCYVmoZGwmKz2RveRDMOVs2tyG2SUzg6l843Tz1ES5nqYMeR6lhsQzbW7PrrHKUTu
         VmLycItgZMeGPxFH7vmEO4ySoqOufvA/dj4TwdOQrM8RfkwH9Prb+2d2W/0Ipby2ueaH
         fu7gegCEQ/hsTLIlSU/mP0S5bVtvBTv4NvjqXi1/KZDKIF4eNT6Cf3qejmolrOpAKw4t
         89wo3dSy1TgNMovchL9KR/7Lc3t6Hw3OgHYXkC/BO7kXF4AYy8ArrrxyK+T7FKk2uDFl
         L279xSvXzJSZsBQtvaLWy5wqLdQn+541p9KSZ+i4nlZ7UmPIrw58XJIe4RY/7AQj/uLk
         cT+Q==
X-Gm-Message-State: AOAM531Lwx3jQuHJcGR3Mi4XOz8NMpNO09oxgtAHUjxMkBiVWaNlihuJ
        kbjUgaKLSWESwgIvkJZGjJ6SXbf+cw==
X-Google-Smtp-Source: ABdhPJxXvM3z8yhyG8vVgJqle/yx/OreVndgv4ogfsuisU/phylm10J6pGMGOEt5/5eHIivc2c65lQ==
X-Received: by 2002:a05:6808:3ad:b0:2d9:fc59:ef0e with SMTP id n13-20020a05680803ad00b002d9fc59ef0emr4358505oie.266.1649271291912;
        Wed, 06 Apr 2022 11:54:51 -0700 (PDT)
Received: from robh.at.kernel.org (66-90-144-107.dyn.grandenetworks.net. [66.90.144.107])
        by smtp.gmail.com with ESMTPSA id w7-20020a9d6387000000b005b2265711fcsm7152964otk.16.2022.04.06.11.54.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Apr 2022 11:54:51 -0700 (PDT)
Received: (nullmailer pid 2581012 invoked by uid 1000);
        Wed, 06 Apr 2022 18:54:50 -0000
From:   Rob Herring <robh@kernel.org>
To:     Puranjay Mohan <p-mohan@ti.com>
Cc:     linux-kernel@vger.kernel.org, krzysztof.kozlowski+dt@linaro.org,
        devicetree@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        bjorn.andersson@linaro.org, linux-remoteproc@vger.kernel.org,
        ssantosh@kernel.org, vigneshr@ti.com, kishon@ti.com,
        mathieu.poirier@linaro.org, nm@ti.com, netdev@vger.kernel.org,
        s-anna@ti.com, linux-arm-kernel@lists.infradead.org
In-Reply-To: <20220406094358.7895-13-p-mohan@ti.com>
References: <20220406094358.7895-1-p-mohan@ti.com> <20220406094358.7895-13-p-mohan@ti.com>
Subject: Re: [RFC 12/13] dt-bindings: net: Add ICSSG Ethernet Driver bindings
Date:   Wed, 06 Apr 2022 13:54:50 -0500
Message-Id: <1649271290.537509.2581011.nullmailer@robh.at.kernel.org>
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,
        FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS,T_FILL_THIS_FORM_SHORT,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 06 Apr 2022 15:13:57 +0530, Puranjay Mohan wrote:
> Add a YAML binding document for the ICSSG Programmable real time unit
> based Ethernet driver. This driver uses the PRU and PRUSS consumer APIs
> to interface the PRUs and load/run the firmware for supporting ethernet
> functionality.
> 
> Signed-off-by: Puranjay Mohan <p-mohan@ti.com>
> ---
>  .../bindings/net/ti,icssg-prueth.yaml         | 172 ++++++++++++++++++
>  1 file changed, 172 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/net/ti,icssg-prueth.yaml
> 

My bot found errors running 'make DT_CHECKER_FLAGS=-m dt_binding_check'
on your patch (DT_CHECKER_FLAGS is new in v5.13):

yamllint warnings/errors:

dtschema/dtc warnings/errors:
schemas/remoteproc/ti,pru-consumer.yaml: ignoring, error parsing file
schemas/remoteproc/ti,pru-consumer.yaml: ignoring, error parsing file
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
  File "/usr/local/lib/python3.8/dist-packages/jsonschema/_validators.py", line 362, in allOf
    yield from validator.descend(instance, subschema, schema_path=index)
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

