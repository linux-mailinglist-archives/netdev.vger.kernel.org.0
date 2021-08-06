Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B62023E2EBF
	for <lists+netdev@lfdr.de>; Fri,  6 Aug 2021 19:07:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240291AbhHFRHp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Aug 2021 13:07:45 -0400
Received: from mail-io1-f52.google.com ([209.85.166.52]:43613 "EHLO
        mail-io1-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240082AbhHFRHo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Aug 2021 13:07:44 -0400
Received: by mail-io1-f52.google.com with SMTP id y1so12532331iod.10;
        Fri, 06 Aug 2021 10:07:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:in-reply-to:references:subject:date
         :message-id;
        bh=SpX7SebU2UFWPMjyIRX9LOsjqpj+MU1ElfcHAk1jVTU=;
        b=gUgBluZ45TeVtRP67bdOpZTWVX0BonGQvIKOFw/BgmFh9SyygAzgBtYwxQvXaFYMfO
         YNhZEm4potzdcaP96hCmvElPDIwhY92xxA/BTzNLIgdQacPuvmPcQAFJ8A26+ld/VfOA
         a9wPjKLk96ugP81nUEnRyRyougMqsmsGvmax//Wv+kB4SkcpDA6lgi7k+XaXMzFjlzVo
         C9/tlWz6RTzmYIW6BafZcPN5v2flA4bIkA8NzE6KZyyo7Mj328CNL6myP8jkg4VwpF4g
         l6a/3IxsPj/A7QN7GVj1W78Aq5O2fTgzd11BQyt76ApY5k7/QytglX0hCRTArk92IeDB
         xoBQ==
X-Gm-Message-State: AOAM5335k8Ku4kVBB9yj1rJgvFit89zIbj1sx1EjZOyUe8pxsIiZ7u3g
        PuXi/dxwrKDolA+pxi32ng==
X-Google-Smtp-Source: ABdhPJx9BHZs01DJ9w8bSbshfXN5wKPnFE66REvokwLZ5nH98ij84/K6YyJWpUXHwa29IV/F2N6V3A==
X-Received: by 2002:a05:6e02:1a03:: with SMTP id s3mr645202ild.63.1628269646869;
        Fri, 06 Aug 2021 10:07:26 -0700 (PDT)
Received: from robh.at.kernel.org ([64.188.179.248])
        by smtp.gmail.com with ESMTPSA id u12sm4817839ill.55.2021.08.06.10.07.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Aug 2021 10:07:26 -0700 (PDT)
Received: (nullmailer pid 1430717 invoked by uid 1000);
        Fri, 06 Aug 2021 17:07:21 -0000
From:   Rob Herring <robh@kernel.org>
To:     Joel Stanley <joel@jms.id.au>
Cc:     Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        netdev@vger.kernel.org, Rob Herring <robh+dt@kernel.org>,
        David Shah <dave@ds0.me>, Anton Blanchard <anton@ozlabs.org>,
        Stafford Horne <shorne@gmail.com>,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        Mateusz Holenko <mholenko@antmicro.com>,
        "David S . Miller" <davem@davemloft.net>,
        Karol Gugala <kgugala@antmicro.com>,
        Gabriel Somlo <gsomlo@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>
In-Reply-To: <20210806054904.534315-2-joel@jms.id.au>
References: <20210806054904.534315-1-joel@jms.id.au> <20210806054904.534315-2-joel@jms.id.au>
Subject: Re: [PATCH 1/2] dt-bindings: net: Add bindings for LiteETH
Date:   Fri, 06 Aug 2021 11:07:21 -0600
Message-Id: <1628269641.635234.1430716.nullmailer@robh.at.kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 06 Aug 2021 15:19:03 +0930, Joel Stanley wrote:
> LiteETH is a small footprint and configurable Ethernet core for FPGA
> based system on chips.
> 
> Signed-off-by: Joel Stanley <joel@jms.id.au>
> ---
>  .../bindings/net/litex,liteeth.yaml           | 62 +++++++++++++++++++
>  1 file changed, 62 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/net/litex,liteeth.yaml
> 

My bot found errors running 'make DT_CHECKER_FLAGS=-m dt_binding_check'
on your patch (DT_CHECKER_FLAGS is new in v5.13):

yamllint warnings/errors:

dtschema/dtc warnings/errors:
/builds/robherring/linux-dt-review/Documentation/devicetree/bindings/net/litex,liteeth.example.dt.yaml: example-0: ethernet@8020000:reg:0: [134352896, 256, 134350848, 256, 134414336, 8192] is too long
	From schema: /usr/local/lib/python3.8/dist-packages/dtschema/schemas/reg.yaml
/builds/robherring/linux-dt-review/Documentation/devicetree/bindings/net/litex,liteeth.example.dt.yaml: ethernet@8020000: reg: [[134352896, 256, 134350848, 256, 134414336, 8192]] is too short
	From schema: /builds/robherring/linux-dt-review/Documentation/devicetree/bindings/net/litex,liteeth.yaml

doc reference errors (make refcheckdocs):

See https://patchwork.ozlabs.org/patch/1514186

This check can fail if there are any dependencies. The base for a patch
series is generally the most recent rc1.

If you already ran 'make dt_binding_check' and didn't see the above
error(s), then make sure 'yamllint' is installed and dt-schema is up to
date:

pip3 install dtschema --upgrade

Please check and re-submit.

