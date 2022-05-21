Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0C62E52FDF1
	for <lists+netdev@lfdr.de>; Sat, 21 May 2022 17:44:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235314AbiEUPn6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 21 May 2022 11:43:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232671AbiEUPn5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 21 May 2022 11:43:57 -0400
Received: from mail-lj1-x230.google.com (mail-lj1-x230.google.com [IPv6:2a00:1450:4864:20::230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E6F75DBFC
        for <netdev@vger.kernel.org>; Sat, 21 May 2022 08:43:56 -0700 (PDT)
Received: by mail-lj1-x230.google.com with SMTP id r3so5690859ljd.7
        for <netdev@vger.kernel.org>; Sat, 21 May 2022 08:43:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=wJtjegKQirvwB32gH9239SE+3TpnMc7sTBARznemBeA=;
        b=rHnU0AJfxYSJk4dWu+EQZOT00DrtLky7GJSRI7opNKA72fhNtZWArdLTC2YX1cEZt0
         qB56Rb2t79QRgrbOsyeg4G3meKOaY6AtdtyNaPLPZJXT7Gr3egY3trprPigWNj+9qZUY
         Rz1bvezh4ASHEh+Dpou1FTh0uUyoHahD72vUmeqUsg1zXKvDNpYZjk0119+EWX7VuC3a
         va4y42+07uOVkUgvw7dxnszTTL+2RraiKCJmA2dORYp/VsqXwp65niaIB+QYEtBVtBmN
         s0EMgB6qv3jQIeL1v/vreYC4pxZTIuQf12i+WIgZ6zqolZtHRfoXzB97Nq1VEhv297e2
         T1rQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=wJtjegKQirvwB32gH9239SE+3TpnMc7sTBARznemBeA=;
        b=VuEQXe9XdXReoyiTLzBEe+CglZew6HRO36YzS6JALYdDA0rW0lat9kOLNo/iajoCQ7
         OwkXmxq0Vg+v5lWU3HGbi4EuQZBFHjZch64Ytek0kqwemCJp7xbo3JKgyWCScrqt/kwy
         x4IihON+pCwCqOyMANQpPL7SshT+F+lSB9jww/KhDpb2pJSkM0cgeMokn2+wzsvDdA5r
         Zgqd6BZ2b89Go43LagTVZ9DuoEV6CvdFuEIeV5s/3ru4RxGX7ITKLVFijYSwNiy3R/6l
         CA929zMK+U1FuO/L5Vr8O4uxuEWhWzXC2ClAJOCbviwORGUiabj5wDSjL4nVM1BgeHVT
         XfZg==
X-Gm-Message-State: AOAM532T9NyRuIdESvarzQ3Y3zzsjsQs7mgmuB+FKSAkmXcJAsrU7U+m
        MVi7xndzo468WVnDubEAgf/B5A==
X-Google-Smtp-Source: ABdhPJyfXeTYFTH2YSm07Q4/SRjtLq6RdF2FJbLzE7a3ieXX5ldwJm5T9cajy78FDGgCkN/KkaIH6g==
X-Received: by 2002:a05:651c:2120:b0:24f:555d:a2d3 with SMTP id a32-20020a05651c212000b0024f555da2d3mr8302036ljq.157.1653147834421;
        Sat, 21 May 2022 08:43:54 -0700 (PDT)
Received: from [192.168.0.17] (78-11-189-27.static.ip.netia.com.pl. [78.11.189.27])
        by smtp.gmail.com with ESMTPSA id d24-20020a056512369800b0047255d211fbsm1093133lfs.298.2022.05.21.08.43.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 21 May 2022 08:43:53 -0700 (PDT)
Message-ID: <5c426fdc-6250-60fe-6c10-109a0ceb3e0c@linaro.org>
Date:   Sat, 21 May 2022 17:43:52 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
Subject: Re: [PATCH net-next] dt-bindings: net: xilinx: document xilinx
 emaclite driver binding
Content-Language: en-US
To:     Radhey Shyam Pandey <radhey.shyam.pandey@amd.com>,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, harini.katakam@amd.com,
        michal.simek@amd.com
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, git@amd.com
References: <1653031473-21032-1-git-send-email-radhey.shyam.pandey@amd.com>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <1653031473-21032-1-git-send-email-radhey.shyam.pandey@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 20/05/2022 09:24, Radhey Shyam Pandey wrote:
> Add basic description for the xilinx emaclite driver DT bindings.
> 
> Signed-off-by: Radhey Shyam Pandey <radhey.shyam.pandey@amd.com>
> ---
> Changes since RFC:
> - Add ethernet-controller yaml reference.
> - 4 space indent for DTS example.
> ---
>  .../bindings/net/xlnx,emaclite.yaml           | 63 +++++++++++++++++++
>  1 file changed, 63 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/net/xlnx,emaclite.yaml
> 
> diff --git a/Documentation/devicetree/bindings/net/xlnx,emaclite.yaml b/Documentation/devicetree/bindings/net/xlnx,emaclite.yaml
> new file mode 100644
> index 000000000000..6105122ad583
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/net/xlnx,emaclite.yaml
> @@ -0,0 +1,63 @@
> +# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
> +%YAML 1.2
> +---
> +$id: http://devicetree.org/schemas/net/xlnx,emaclite.yaml#
> +$schema: http://devicetree.org/meta-schemas/core.yaml#
> +
> +title: Xilinx Emaclite Ethernet controller
> +
> +allOf:
> +  - $ref: ethernet-controller.yaml#

This goes just before properties (so after maintainers).

> +
> +maintainers:
> +  - Radhey Shyam Pandey <radhey.shyam.pandey@amd.com>
> +  - Harini Katakam <harini.katakam@amd.com>
> +
> +properties:
> +  compatible:
> +    enum:
> +      - xlnx,opb-ethernetlite-1.01.a
> +      - xlnx,opb-ethernetlite-1.01.b
> +      - xlnx,xps-ethernetlite-1.00.a
> +      - xlnx,xps-ethernetlite-2.00.a
> +      - xlnx,xps-ethernetlite-2.01.a
> +      - xlnx,xps-ethernetlite-3.00.a
> +
> +  reg:
> +    maxItems: 1
> +
> +  interrupts:
> +    maxItems: 1
> +
> +  phy-handle: true
> +
> +  local-mac-address: true
> +
> +  xlnx,tx-ping-pong:
> +    type: boolean
> +    description: hardware supports tx ping pong buffer.
> +
> +  xlnx,rx-ping-pong:
> +    type: boolean
> +    description: hardware supports rx ping pong buffer.
> +
> +required:
> +  - compatible
> +  - reg
> +  - interrupts
> +  - phy-handle
> +
> +additionalProperties: false
> +
> +examples:
> +  - |
> +    axi_ethernetlite_1: ethernet@40e00000 {
> +        compatible = "xlnx,xps-ethernetlite-3.00.a";
> +        interrupt-parent = <&axi_intc_1>;
> +        interrupts = <1 0>;

Is "0" an interrupt none type? If yes, then this should be rather a
define and a proper type, not none.

> +        local-mac-address = [00 0a 35 00 00 00];

Each device should get it's own MAC address, right? I understand you
leave it for bootloader, then just fill it with 0.

> +        phy-handle = <&phy0>;
> +        reg = <0x40e00000 0x10000>;

Put the reg after compatible in DTS code.

> +        xlnx,rx-ping-pong;
> +        xlnx,tx-ping-pong;
> +    };


Best regards,
Krzysztof
