Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 651B36968EA
	for <lists+netdev@lfdr.de>; Tue, 14 Feb 2023 17:12:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232007AbjBNQMx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Feb 2023 11:12:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231701AbjBNQMw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Feb 2023 11:12:52 -0500
Received: from mail-il1-f175.google.com (mail-il1-f175.google.com [209.85.166.175])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 605252C643;
        Tue, 14 Feb 2023 08:12:37 -0800 (PST)
Received: by mail-il1-f175.google.com with SMTP id h5so595545ilq.6;
        Tue, 14 Feb 2023 08:12:37 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=date:subject:message-id:references:in-reply-to:cc:to:from
         :mime-version:content-transfer-encoding:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=t8LghQUZ4VYOI6+8MHgB96YfD7xfMJYsYr1SqpZhU7o=;
        b=Y/D6RPNFoPQBrg7DUhCk+5QStUEqEiZyRmnk7OvS/19e5PpacrqMfoto+ZmG+yqG4P
         ZeOXuA7BoiihAp8s+U7laPjjO0DkdTmg+KQeQcANvHd5Fa8UfhRBeeuBzLkt99htDwiv
         R4m6NJ6AG+vXkQT2dV98sNrKbiIheKfboAa6+aRZFopHjWjy686RHld8oS7KLd0B+sRw
         L5L72tud2uUW9aQIY9R9Mzufn+KpTWq2GtOXTsN2RHRjQdwGn7VfeYDCKRERBhbZhvjb
         IAQMskJNts7DqMfqlXCUPuJh67ct6LpH180Y/sCVXMjwFn+GrTLWN5Rf9TMIh2GM/HgZ
         F2GQ==
X-Gm-Message-State: AO0yUKVQo38b47ES9C+yGiRQ9zsw7qzcWooDyEX1VJZKUpidGRf4ODbV
        gkHYh6rLenkGjkNHH9mLPA==
X-Google-Smtp-Source: AK7set9P06VBvJOV/3HQy92KwaaH93I7FfQX7zsyhx026ziuRyyeCZabJOgdFFLebGu0c07o5vc65g==
X-Received: by 2002:a05:6e02:20ef:b0:315:3252:655f with SMTP id q15-20020a056e0220ef00b003153252655fmr3373501ilv.21.1676391156308;
        Tue, 14 Feb 2023 08:12:36 -0800 (PST)
Received: from robh_at_kernel.org (c-73-14-99-67.hsd1.co.comcast.net. [73.14.99.67])
        by smtp.gmail.com with ESMTPSA id r13-20020a92d44d000000b0031550a3dc7esm1306185ilm.32.2023.02.14.08.12.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Feb 2023 08:12:35 -0800 (PST)
Received: (nullmailer pid 76705 invoked by uid 1000);
        Tue, 14 Feb 2023 16:12:34 -0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Rob Herring <robh@kernel.org>
To:     Neeraj Sanjay Kale <neeraj.sanjaykale@nxp.com>
Cc:     ilpo.jarvinen@linux.intel.com, johan.hedberg@gmail.com,
        amitkumar.karwar@nxp.com, robh+dt@kernel.org,
        devicetree@vger.kernel.org, linux-serial@vger.kernel.org,
        linux-bluetooth@vger.kernel.org, krzysztof.kozlowski+dt@linaro.org,
        luiz.dentz@gmail.com, hdanton@sina.com, alok.a.tiwari@oracle.com,
        gregkh@linuxfoundation.org, netdev@vger.kernel.org,
        edumazet@google.com, jirislaby@kernel.org,
        linux-kernel@vger.kernel.org, kuba@kernel.org, sherry.sun@nxp.com,
        pabeni@redhat.com, leon@kernel.org, davem@davemloft.net,
        marcel@holtmann.org, rohit.fule@nxp.com
In-Reply-To: <20230213145432.1192911-3-neeraj.sanjaykale@nxp.com>
References: <20230213145432.1192911-1-neeraj.sanjaykale@nxp.com>
 <20230213145432.1192911-3-neeraj.sanjaykale@nxp.com>
Message-Id: <167638943735.3594.3469258159164603021.robh@kernel.org>
Subject: Re: [PATCH v3 2/3] dt-bindings: net: bluetooth: Add NXP bluetooth
 support
Date:   Tue, 14 Feb 2023 10:12:34 -0600
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,
        FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On Mon, 13 Feb 2023 20:24:31 +0530, Neeraj Sanjay Kale wrote:
> Add binding document for NXP bluetooth chipsets attached
> over UART.
> 
> Signed-off-by: Neeraj Sanjay Kale <neeraj.sanjaykale@nxp.com>
> ---
> v2: Resolved dt_binding_check errors. (Rob Herring)
> v2: Modified description, added specific compatibility devices, corrected indentations. (Krzysztof Kozlowski)
> v3: Modified description, renamed file (Krzysztof Kozlowski)
> ---
>  .../bindings/net/bluetooth/nxp,w8xxx-bt.yaml  | 44 +++++++++++++++++++
>  MAINTAINERS                                   |  7 +++
>  2 files changed, 51 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/net/bluetooth/nxp,w8xxx-bt.yaml
> 

My bot found errors running 'make DT_CHECKER_FLAGS=-m dt_binding_check'
on your patch (DT_CHECKER_FLAGS is new in v5.13):

yamllint warnings/errors:

dtschema/dtc warnings/errors:
./Documentation/devicetree/bindings/net/bluetooth/nxp,w8xxx-bt.yaml: $id: relative path/filename doesn't match actual path or filename
	expected: http://devicetree.org/schemas/net/bluetooth/nxp,w8xxx-bt.yaml#

doc reference errors (make refcheckdocs):
MAINTAINERS: Documentation/devicetree/bindings/net/bluetooth/nxp-bluetooth.yaml

See https://patchwork.ozlabs.org/project/devicetree-bindings/patch/20230213145432.1192911-3-neeraj.sanjaykale@nxp.com

The base for the series is generally the latest rc1. A different dependency
should be noted in *this* patch.

If you already ran 'make dt_binding_check' and didn't see the above
error(s), then make sure 'yamllint' is installed and dt-schema is up to
date:

pip3 install dtschema --upgrade

Please check and re-submit after running the above command yourself. Note
that DT_SCHEMA_FILES can be set to your schema file to speed up checking
your schema. However, it must be unset to test all examples with your schema.

