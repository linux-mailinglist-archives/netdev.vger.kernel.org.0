Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B37503EC480
	for <lists+netdev@lfdr.de>; Sat, 14 Aug 2021 20:34:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238988AbhHNSet (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Aug 2021 14:34:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233713AbhHNSee (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 14 Aug 2021 14:34:34 -0400
Received: from mail-wm1-x32a.google.com (mail-wm1-x32a.google.com [IPv6:2a00:1450:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16A06C061764;
        Sat, 14 Aug 2021 11:34:06 -0700 (PDT)
Received: by mail-wm1-x32a.google.com with SMTP id c129-20020a1c35870000b02902e6b6135279so7512644wma.0;
        Sat, 14 Aug 2021 11:34:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=oh5k3TeZDUDMQyzUKvwvw8ptjU1lF4vaMeqPRWoFOrc=;
        b=MHmxtB5NJpyvKDrIJP4hv86RIlrpznKzrFa8RphCfvRg1TOS1VirbAaYk9VZ3931xI
         FVaJ9Q35gEiMmEDiD0ELYXswoivrcUZKZ6Rc5OnKh8zDqwJMOZLG0vESd0GQAXzlht//
         zE/a+EA+QxgkaBJrX6sSjd/SwEK2XQochkYfUgvU4EBfFJuSVsjPS7mfQFC/No0vmVlz
         Mtx9sNlIutlBmEKI2v/GGoDoxSYNjxiY9KkuwF7mhzqg2xFlqXRuUMvfaEl+JYxEEm+o
         8NYJJOhbp3QZj8lc3aXRZsXH9vGM3TJHR15X7Q1aLUqjryN93UxyxQXNINmJvQnf5eP4
         Zk6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=oh5k3TeZDUDMQyzUKvwvw8ptjU1lF4vaMeqPRWoFOrc=;
        b=THc9n8gl5u1vC29kzoFSOYmjuOjeu01QWNZJwzv+PZRGebPlZCLosV/ACgER+Jah8Y
         BnCljCmr0hQyNLJTl33nkT1O66y3C5sqSc3k3TxIS2U/SBSMuDtJJ0BXoOjoRuu9eBV2
         v66ucKdu7q+8SNiWc7zdLtCzvPQZU1dfsDXw6X+qt+aWHNAZNcKRDmqSbzUOAAAuv5N0
         npzpzJgDICzbncXlXNFP+eNtk737Da3D+M0LchJtHWRO89tzsSt/NXQw58KNQa/SJ0st
         OIl/F6uYBH1hNB8jBLRVyTwtUbufKKEIlEF43I0c1ZlLEczvLW49KdnkGdQkKmktTa/2
         ZFTg==
X-Gm-Message-State: AOAM530VPWI4t0EKVOl7WJ0nzm1pdpwqpcbQ+QVJsm/vLTa3lUY5EJQl
        SGj9+393Ys0jnWIt0IrULQeY6kv+9Ddgjg==
X-Google-Smtp-Source: ABdhPJxEhl2748Ll34w+fl5VBaoWnlj+TonnKI5PorFMYm3e6DCUnKj4S0yyQAEMpO1Pbs/jKQazaw==
X-Received: by 2002:a05:600c:154d:: with SMTP id f13mr8168877wmg.0.1628966044359;
        Sat, 14 Aug 2021 11:34:04 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f10:c200:1df:469f:59ab:ca40? (p200300ea8f10c20001df469f59abca40.dip0.t-ipconnect.de. [2003:ea:8f10:c200:1df:469f:59ab:ca40])
        by smtp.googlemail.com with ESMTPSA id p6sm5338395wrw.50.2021.08.14.11.34.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 14 Aug 2021 11:34:03 -0700 (PDT)
Subject: Re: [PATCH 1/2] dt-bindings: net: add RTL8152 binding documentation
To:     David Bauer <mail@david-bauer.net>, davem@davemloft.net,
        kuba@kernel.org, robh+dt@kernel.org, Pavel Machek <pavel@ucw.cz>
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        "linux-leds@vger.kernel.org" <linux-leds@vger.kernel.org>
References: <20210814181107.138992-1-mail@david-bauer.net>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <74795336-e3fa-422f-0004-a8cb180d84bc@gmail.com>
Date:   Sat, 14 Aug 2021 20:33:56 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20210814181107.138992-1-mail@david-bauer.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 14.08.2021 20:11, David Bauer wrote:
> Add binding documentation for the Realtek RTL8152 / RTL8153 USB ethernet
> adapters.
> 
> Signed-off-by: David Bauer <mail@david-bauer.net>
> ---
>  .../bindings/net/realtek,rtl8152.yaml         | 43 +++++++++++++++++++
>  1 file changed, 43 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/net/realtek,rtl8152.yaml
> 
> diff --git a/Documentation/devicetree/bindings/net/realtek,rtl8152.yaml b/Documentation/devicetree/bindings/net/realtek,rtl8152.yaml
> new file mode 100644
> index 000000000000..ab760000b3a6
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/net/realtek,rtl8152.yaml
> @@ -0,0 +1,43 @@
> +# SPDX-License-Identifier: GPL-2.0-only OR BSD-2-Clause
> +%YAML 1.2
> +---
> +$id: http://devicetree.org/schemas/net/realtek,rtl8152.yaml#
> +$schema: http://devicetree.org/meta-schemas/core.yaml#
> +
> +title: Realtek RTL8152/RTL8153 series USB ethernet
> +
> +maintainers:
> +  - David Bauer <mail@david-bauer.net>
> +
> +properties:
> +  compatible:
> +    oneOf:
> +      - items:
> +          - enum:
> +              - realtek,rtl8152
> +              - realtek,rtl8153
> +
> +  reg:
> +    description: The device number on the USB bus
> +
> +  realtek,led-data:
> +    $ref: /schemas/types.yaml#/definitions/uint32
> +    description: Value to be written to the LED configuration register.
> +

+Pavel as LED subsystem maintainer

There's an ongoing discussion (with certain decisions taken already) about
how to configure network device LEDs.

> +required:
> +  - compatible
> +  - reg
> +
> +examples:
> +  - |
> +    usb@100 {
> +      reg = <0x100 0x100>;
> +      #address-cells = <1>;
> +      #size-cells = <0>;
> +
> +      usb-eth@2 {
> +        compatible = "realtek,rtl8153";
> +        reg = <0x2>;
> +        realtek,led-data = <0x87>;
> +      };
> +    };
> 

