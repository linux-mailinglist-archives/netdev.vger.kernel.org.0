Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 162C442D4D0
	for <lists+netdev@lfdr.de>; Thu, 14 Oct 2021 10:26:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230109AbhJNI2h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Oct 2021 04:28:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229994AbhJNI2g (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Oct 2021 04:28:36 -0400
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A816C061570
        for <netdev@vger.kernel.org>; Thu, 14 Oct 2021 01:26:30 -0700 (PDT)
Received: by mail-wr1-x42d.google.com with SMTP id i12so16814363wrb.7
        for <netdev@vger.kernel.org>; Thu, 14 Oct 2021 01:26:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=gnT7ITUDew6zP4Lg5jF9hadktZV+ii+Iy6W/r1hLHv0=;
        b=ch547gAZR+Q3c3Y327p3FYyn/arYGkYkc8PECoQM73tPd7llbZqpZ9kvJ7xF/juuU3
         fk4AzzHKo5JYR3JKmSx1FB/kq/Zq2hoQMwvG+b7MdXQap36mMbu3DBq8IApbuZDBXTGZ
         D0IVrEFt1HC9S/0NuF1mFN+KLgXevLgODHWfV7omjKTUpGr2+A7WGRHyUpYSPgF4RMId
         zmf7LbwtLBKkeWyUH1OoDPG/s3oqpFjGauXbC2p9WZGHHA8o/Un/vXt6NY93Y+8HKG92
         ArjVUr/hXPp3vZleNy2IVa5mPocPo5silIz9Bzc3rLl+0CxMQVL0tVu3rckQJ8n0S9lm
         uZLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=gnT7ITUDew6zP4Lg5jF9hadktZV+ii+Iy6W/r1hLHv0=;
        b=GkV+WeyV2teMaYZ4qnI7VSIYWtLjuIf4s/Jl15tBlLXX7xc/cybhF0oYx73YFBR8pR
         6gB/Oc1gT0qveegdprTbaGZE7gktj4nEda5JtQlUxpcqQcgajOSS/JG2w3n/Rx2lQNi4
         DF1LhrwoDtJlfI39Q11QqQOyDlsmyznGXrBnTeZrZU3hjVMmZ7Hv2e+X1TwEX47703sW
         bHgT5UVqz1onsPZKCotopcZWJA8FrWxqBUE910EStZGzEZa6fXl6fW/elgnKD0kAF+pT
         A1Rxmngt4RO+hhwXbUZZEf2iZ70wNSudHlyj3NQI6I/9ABc0CWPh0oweNO8ZDAxl5mwB
         TNiA==
X-Gm-Message-State: AOAM533BngFl4zNgH/4XaoPkSFRAbeCOcgTXu2mA2uY+Qu2ya4ctWNzE
        hWECRkPaW21chp1mMSZPvskKDw==
X-Google-Smtp-Source: ABdhPJx3kb0RKjngL3Zm08lJEMCq0GSiOHIniaxNRNHy0v50tjwHheOj+D0AvP9+hzPqKQ9CgMOa2g==
X-Received: by 2002:a5d:47ac:: with SMTP id 12mr4811542wrb.352.1634199988926;
        Thu, 14 Oct 2021 01:26:28 -0700 (PDT)
Received: from [192.168.86.34] (cpc86377-aztw32-2-0-cust226.18-1.cable.virginm.net. [92.233.226.227])
        by smtp.googlemail.com with ESMTPSA id l20sm10597428wmq.42.2021.10.14.01.26.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 14 Oct 2021 01:26:28 -0700 (PDT)
Subject: Re: [PATCH RFC linux] dt-bindings: nvmem: Add binding for U-Boot
 environment NVMEM provider
To:     =?UTF-8?Q?Marek_Beh=c3=ban?= <kabel@kernel.org>,
        robh+dt@kernel.org, devicetree@vger.kernel.org,
        U-Boot Mailing List <u-boot@lists.denx.de>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Luka Kovacic <luka.kovacic@sartura.hr>
References: <20211013232048.16559-1-kabel@kernel.org>
From:   Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Message-ID: <629c8ba1-c924-565f-0b3c-8b625f4e5fb0@linaro.org>
Date:   Thu, 14 Oct 2021 09:26:27 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20211013232048.16559-1-kabel@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 14/10/2021 00:20, Marek Behún wrote:
> Add device tree bindings for U-Boot environment NVMEM provider.
> 
> U-Boot environment can be stored at a specific offset of a MTD device,
> EEPROM, MMC, NAND or SATA device, on an UBI volume, or in a file on a
> filesystem.
> 
> The environment can contain information such as device's MAC address,
> which should be used by the ethernet controller node.
> 

Have you looked at 
./Documentation/devicetree/bindings/mtd/partitions/nvmem-cells.yaml ?


--srini

> Signed-off-by: Marek Behún <kabel@kernel.org>
> ---
>   .../bindings/nvmem/denx,u-boot-env.yaml       | 88 +++++++++++++++++++
>   include/dt-bindings/nvmem/u-boot-env.h        | 18 ++++
>   2 files changed, 106 insertions(+)
>   create mode 100644 Documentation/devicetree/bindings/nvmem/denx,u-boot-env.yaml
>   create mode 100644 include/dt-bindings/nvmem/u-boot-env.h
> 
> diff --git a/Documentation/devicetree/bindings/nvmem/denx,u-boot-env.yaml b/Documentation/devicetree/bindings/nvmem/denx,u-boot-env.yaml
> new file mode 100644
> index 000000000000..56505c08e622
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/nvmem/denx,u-boot-env.yaml
> @@ -0,0 +1,88 @@
> +# SPDX-License-Identifier: GPL-2.0-only OR BSD-2-Clause
> +%YAML 1.2
> +---
> +$id: http://devicetree.org/schemas/nvmem/denx,u-boot-env.yaml#
> +$schema: http://devicetree.org/meta-schemas/core.yaml#
> +
> +title: U-Boot environment NVMEM Device Tree Bindings
> +
> +maintainers:
> +  - Marek Behún <kabel@kernel.org>
> +
> +description:
> +  This binding represents U-Boot's environment NVMEM settings which can be
> +  stored on a specific offset of an EEPROM, MMC, NAND or SATA device, or
> +  an UBI volume, or in a file on a filesystem.
> +
> +properties:
> +  compatible:
> +    const: denx,u-boot-env
> +
> +  path:
> +    description:
> +      The path to the file containing the environment if on a filesystem.
> +    $ref: /schemas/types.yaml#/definitions/string
> +
> +patternProperties:
> +  "^[^=]+$":
> +    type: object
> +
> +    description:
> +      This node represents one U-Boot environment variable, which is also one
> +      NVMEM data cell.
> +
> +    properties:
> +      name:
> +        description:
> +          If the variable name contains characters not allowed in device tree node
> +          name, use this property to specify the name, otherwise the variable name
> +          is equal to node name.
> +        $ref: /schemas/types.yaml#/definitions/string
> +
> +      type:
> +        description:
> +          Type of the variable. Since variables, even integers and MAC addresses,
> +          are stored as strings in U-Boot environment, for proper conversion the
> +          type needs to be specified. Use one of the U_BOOT_ENV_TYPE_* prefixed
> +          definitions from include/dt-bindings/nvmem/u-boot-env.h.
> +        $ref: /schemas/types.yaml#/definitions/uint32
> +        minimum: 0
> +        maximum: 5
> +
> +    required:
> +      - type
> +
> +required:
> +  - compatible
> +
> +additionalProperties: true
> +
> +examples:
> +  - |
> +
> +    #include <dt-bindings/nvmem/u-boot-env.h>
> +
> +    spi-flash {
> +        partitions {
> +            compatible = "fixed-partitions";
> +            #address-cells = <1>;
> +            #size-cells = <1>;
> +
> +            partition@180000 {
> +                compatible = "denx,u-boot-env";
> +                label = "u-boot-env";
> +                reg = <0x180000 0x10000>;
> +
> +                eth0_addr: ethaddr {
> +                    type = <U_BOOT_ENV_TYPE_MAC_ADDRESS>;
> +                };
> +            };
> +        };
> +    };
> +
> +    ethernet-controller {
> +        nvmem-cells = <&eth0_addr>;
> +        nvmem-cell-names = "mac-address";
> +    };
> +
> +...
> diff --git a/include/dt-bindings/nvmem/u-boot-env.h b/include/dt-bindings/nvmem/u-boot-env.h
> new file mode 100644
> index 000000000000..760e5b240619
> --- /dev/null
> +++ b/include/dt-bindings/nvmem/u-boot-env.h
> @@ -0,0 +1,18 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +/*
> + * Macros for U-Boot environment NVMEM device tree bindings.
> + *
> + * Copyright (C) 2021 Marek Behún <kabel@kernel.org>
> + */
> +
> +#ifndef __DT_BINDINGS_NVMEM_U_BOOT_ENV_H
> +#define __DT_BINDINGS_NVMEM_U_BOOT_ENV_H
> +
> +#define U_BOOT_ENV_TYPE_STRING		0
> +#define U_BOOT_ENV_TYPE_ULONG		1
> +#define U_BOOT_ENV_TYPE_BOOL		2
> +#define U_BOOT_ENV_TYPE_MAC_ADDRESS	3
> +#define U_BOOT_ENV_TYPE_ULONG_HEX	4
> +#define U_BOOT_ENV_TYPE_ULONG_DEC	5
> +
> +#endif /* __DT_BINDINGS_NVMEM_U_BOOT_ENV_H */
> 
