Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE9A442DBB1
	for <lists+netdev@lfdr.de>; Thu, 14 Oct 2021 16:31:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231925AbhJNOd2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Oct 2021 10:33:28 -0400
Received: from mail-oo1-f46.google.com ([209.85.161.46]:36622 "EHLO
        mail-oo1-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230515AbhJNOdR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Oct 2021 10:33:17 -0400
Received: by mail-oo1-f46.google.com with SMTP id r1-20020a4a9641000000b002b6b55007bfso1955021ooi.3;
        Thu, 14 Oct 2021 07:31:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:in-reply-to:references:subject:date
         :message-id;
        bh=4NM7e3TNIm0ImMqlA2/I6RFGXdB2wzMfY7HbO921q28=;
        b=cmMFTGX7FHoE9ItBLkt2zlmVpItbL1JbZtHgZ/ltScVFtuVoeP3JZcgLbtAiVKlU8h
         gnjJxN39UWchKw+1k+nW5kHqmL6DX31U6hFn+qQhHbzxcI3c6GWeqNVzObzYM1A6+tMn
         46Z6o90bcpCcmu9tDB5pwLO5qVTzc+ehY/vwNVJLw+KjfQnsC5fibVF09sMYTKfLh1xN
         yaTqs/zFfhI+DRVUqF3S2myr3D8GRq9QGyul82TDAGGBzAb34EMOvzIMev0hccius3zY
         Gjl4o8fFd64hcr6LYmcvYw+98y+K775w4osYbgggPKTzbnZ1wqr/trt8raXpzeZ5ZhRU
         F7Og==
X-Gm-Message-State: AOAM533NSUq/GmPn2KKZAEWXGOy0Q77Eb8qn3lqJfv8wGkEr521csxvb
        yMAkPZdkMuWQdCJzUeUffDhvyts25A==
X-Google-Smtp-Source: ABdhPJwULPJ9RTEyH25NOWSl1gVe9I2y5u8tjZLCfGXvVzoAE7VYeF1f4Ri8qhBP94+A+Bi1Ai5lFw==
X-Received: by 2002:a4a:d54c:: with SMTP id q12mr4377667oos.25.1634221872584;
        Thu, 14 Oct 2021 07:31:12 -0700 (PDT)
Received: from robh.at.kernel.org (66-90-148-213.dyn.grandenetworks.net. [66.90.148.213])
        by smtp.gmail.com with ESMTPSA id d18sm485688ook.14.2021.10.14.07.31.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Oct 2021 07:31:12 -0700 (PDT)
Received: (nullmailer pid 3295875 invoked by uid 1000);
        Thu, 14 Oct 2021 14:31:04 -0000
From:   Rob Herring <robh@kernel.org>
To:     =?utf-8?q?Marek_Beh=C3=BAn?= <kabel@kernel.org>
Cc:     devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Luka Kovacic <luka.kovacic@sartura.hr>, netdev@vger.kernel.org,
        robh+dt@kernel.org, U-Boot Mailing List <u-boot@lists.denx.de>
In-Reply-To: <20211013232048.16559-1-kabel@kernel.org>
References: <20211013232048.16559-1-kabel@kernel.org>
Subject: Re: [PATCH RFC linux] dt-bindings: nvmem: Add binding for U-Boot environment NVMEM provider
Date:   Thu, 14 Oct 2021 09:31:04 -0500
Message-Id: <1634221864.152281.3295874.nullmailer@robh.at.kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 14 Oct 2021 01:20:48 +0200, Marek Behún wrote:
> Add device tree bindings for U-Boot environment NVMEM provider.
> 
> U-Boot environment can be stored at a specific offset of a MTD device,
> EEPROM, MMC, NAND or SATA device, on an UBI volume, or in a file on a
> filesystem.
> 
> The environment can contain information such as device's MAC address,
> which should be used by the ethernet controller node.
> 
> Signed-off-by: Marek Behún <kabel@kernel.org>
> ---
>  .../bindings/nvmem/denx,u-boot-env.yaml       | 88 +++++++++++++++++++
>  include/dt-bindings/nvmem/u-boot-env.h        | 18 ++++
>  2 files changed, 106 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/nvmem/denx,u-boot-env.yaml
>  create mode 100644 include/dt-bindings/nvmem/u-boot-env.h
> 

My bot found errors running 'make DT_CHECKER_FLAGS=-m dt_binding_check'
on your patch (DT_CHECKER_FLAGS is new in v5.13):

yamllint warnings/errors:

dtschema/dtc warnings/errors:
/builds/robherring/linux-dt-review/Documentation/devicetree/bindings/nvmem/denx,u-boot-env.example.dt.yaml: partition@180000: compatible: ['denx,u-boot-env'] is not of type 'object'
	From schema: /builds/robherring/linux-dt-review/Documentation/devicetree/bindings/nvmem/denx,u-boot-env.yaml
/builds/robherring/linux-dt-review/Documentation/devicetree/bindings/nvmem/denx,u-boot-env.example.dt.yaml: partition@180000: label: ['u-boot-env'] is not of type 'object'
	From schema: /builds/robherring/linux-dt-review/Documentation/devicetree/bindings/nvmem/denx,u-boot-env.yaml
/builds/robherring/linux-dt-review/Documentation/devicetree/bindings/nvmem/denx,u-boot-env.example.dt.yaml: partition@180000: reg: [[1572864, 65536]] is not of type 'object'
	From schema: /builds/robherring/linux-dt-review/Documentation/devicetree/bindings/nvmem/denx,u-boot-env.yaml
/builds/robherring/linux-dt-review/Documentation/devicetree/bindings/nvmem/denx,u-boot-env.example.dt.yaml: partition@180000: $nodename: ['partition@180000'] is not of type 'object'
	From schema: /builds/robherring/linux-dt-review/Documentation/devicetree/bindings/nvmem/denx,u-boot-env.yaml

doc reference errors (make refcheckdocs):

See https://patchwork.ozlabs.org/patch/1540721

This check can fail if there are any dependencies. The base for a patch
series is generally the most recent rc1.

If you already ran 'make dt_binding_check' and didn't see the above
error(s), then make sure 'yamllint' is installed and dt-schema is up to
date:

pip3 install dtschema --upgrade

Please check and re-submit.

