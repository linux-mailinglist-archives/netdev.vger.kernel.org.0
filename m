Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E6BCA4ACF34
	for <lists+netdev@lfdr.de>; Tue,  8 Feb 2022 03:53:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343974AbiBHCxL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Feb 2022 21:53:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233685AbiBHCxK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Feb 2022 21:53:10 -0500
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97E39C061355;
        Mon,  7 Feb 2022 18:53:09 -0800 (PST)
Received: by mail-pj1-x102f.google.com with SMTP id v4so8961079pjh.2;
        Mon, 07 Feb 2022 18:53:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=FHvEEsTakrojeNRd6lGWIzvkLLl9CJaFPC3mOTNvRw4=;
        b=NFft9JIvnH+k8y3DuoDdh0h7tYf1A+rTKolC2dO9OdB2ZVbQsII9LNGb5+O+n9Pjgy
         Qd5xqzdMnq3A+LSG/w9gGB4FgRZPexyS4lTTB6ExNps+7Qk6twyadlVUAdNCxkA6o0UO
         ICucyXzRFeN5T4v25an9awp+jlu1CC+xTStUIJao+Ht0yZOWJ5TtUEKqM1M/Skzy9EVe
         jQSgaxANRo9wBlkp8FARYZGy+1+5I9tRbLhUm5lI6XIDkiNhOtIivyIWfgfcLakfRMYT
         EB/fcbH8ZbtjiYLRgDf3/WgmfVRkihdgW007Xj1QwiPuyg/NLdQSuAv+PHog76kleml/
         1KFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=FHvEEsTakrojeNRd6lGWIzvkLLl9CJaFPC3mOTNvRw4=;
        b=FexZXflT3lBipzb+DaKPoVAUvov5p6T2ikUJPQtuCcN9AgbjnxZWvdf4M7cpguaz+D
         VdmMjEEG53Ws+zk1AERf9P9hbu2ebFHmz5VsXH/Rr76L8oViaTbGOrUaEWkzFHmMWjBE
         Bic5r/+mrPMK6xz+UK7867PiPiavgtYXn9B3u1eLiX4RMfpGsSIdT1iWu5qF4UdAzAs1
         km3md5Tgj2I5lc3wKJl+5JKpQxiW3+ITkNciQjLQjyWwVvuO/Fd+8fzHFr7OeOmGQ0SP
         TDdkCYB8eQ98Op+UFFeBaCuDIk9bDNEs0aKsl+HFqmAirbqX+jxVO8tcSCbwdYEKhQ33
         Ja6w==
X-Gm-Message-State: AOAM532duhYQQLD7Atx8gvuV1Rq+DOJaDbAx0cU5BCzBwCJ5G/eTO8zC
        PuRtdKP3b/p7c1GFdV0hQbs=
X-Google-Smtp-Source: ABdhPJx6TLFiQTRxVx6o0QBsvhPZejzhqjTs5YNHuChXj/dfNgtKlAfSUxcwost38eA/f8kJDpbaOA==
X-Received: by 2002:a17:902:b941:: with SMTP id h1mr2622972pls.73.1644288789067;
        Mon, 07 Feb 2022 18:53:09 -0800 (PST)
Received: from [192.168.1.3] (ip72-194-116-95.oc.oc.cox.net. [72.194.116.95])
        by smtp.gmail.com with ESMTPSA id t1sm9426770pgj.43.2022.02.07.18.53.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 07 Feb 2022 18:53:08 -0800 (PST)
Message-ID: <88caec5c-c509-124e-5f6b-22b94f968aea@gmail.com>
Date:   Mon, 7 Feb 2022 18:53:06 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.1
Subject: Re: [PATCH v8 net-next 01/10] dt-bindings: net: dsa: dt bindings for
 microchip lan937x
Content-Language: en-US
To:     Prasanna Vengateshan <prasanna.vengateshan@microchip.com>,
        andrew@lunn.ch, netdev@vger.kernel.org, olteanv@gmail.com,
        robh+dt@kernel.org
Cc:     UNGLinuxDriver@microchip.com, woojung.huh@microchip.com,
        hkallweit1@gmail.com, linux@armlinux.org.uk, davem@davemloft.net,
        kuba@kernel.org, linux-kernel@vger.kernel.org,
        vivien.didelot@gmail.com, devicetree@vger.kernel.org,
        Rob Herring <robh@kernel.org>
References: <20220207172204.589190-1-prasanna.vengateshan@microchip.com>
 <20220207172204.589190-2-prasanna.vengateshan@microchip.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20220207172204.589190-2-prasanna.vengateshan@microchip.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2/7/2022 9:21 AM, Prasanna Vengateshan wrote:
> Documentation in .yaml format and updates to the MAINTAINERS
> Also 'make dt_binding_check' is passed.
> 
> RGMII internal delay values for the mac is retrieved from
> rx-internal-delay-ps & tx-internal-delay-ps as per the feedback from
> v3 patch series.
> https://lore.kernel.org/netdev/20210802121550.gqgbipqdvp5x76ii@skbuf/
> 
> It supports only the delay value of 0ns and 2ns.
> 
> Signed-off-by: Prasanna Vengateshan <prasanna.vengateshan@microchip.com>
> Reviewed-by: Rob Herring <robh@kernel.org>
> ---
>   .../bindings/net/dsa/microchip,lan937x.yaml   | 179 ++++++++++++++++++
>   MAINTAINERS                                   |   1 +
>   2 files changed, 180 insertions(+)
>   create mode 100644 Documentation/devicetree/bindings/net/dsa/microchip,lan937x.yaml
> 
> diff --git a/Documentation/devicetree/bindings/net/dsa/microchip,lan937x.yaml b/Documentation/devicetree/bindings/net/dsa/microchip,lan937x.yaml
> new file mode 100644
> index 000000000000..5657a0b89e4e
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/net/dsa/microchip,lan937x.yaml
> @@ -0,0 +1,179 @@
> +# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
> +%YAML 1.2
> +---
> +$id: http://devicetree.org/schemas/net/dsa/microchip,lan937x.yaml#
> +$schema: http://devicetree.org/meta-schemas/core.yaml#
> +
> +title: LAN937x Ethernet Switch Series Tree Bindings
> +
> +maintainers:
> +  - UNGLinuxDriver@microchip.com
> +
> +allOf:
> +  - $ref: dsa.yaml#
> +
> +properties:
> +  compatible:
> +    enum:
> +      - microchip,lan9370
> +      - microchip,lan9371
> +      - microchip,lan9372
> +      - microchip,lan9373
> +      - microchip,lan9374
> +
> +  reg:
> +    maxItems: 1
> +
> +  spi-max-frequency:
> +    maximum: 50000000
> +
> +  reset-gpios:
> +    description: Optional gpio specifier for a reset line
> +    maxItems: 1
> +
> +  mdio:
> +    $ref: /schemas/net/mdio.yaml#
> +    unevaluatedProperties: false

This should be moved to dsa.yaml since this is about describing the 
switch's internal MDIO bus controller. This is applicable to any switch, 
really.

> +
> +patternProperties:
> +  "^(ethernet-)?ports$":
> +    patternProperties:
> +      "^(ethernet-)?port@[0-7]+$":
> +        allOf:
> +          - if:
> +              properties:
> +                phy-mode:
> +                  contains:
> +                    enum:
> +                      - rgmii
> +                      - rgmii-rxid
> +                      - rgmii-txid
> +                      - rgmii-id
> +            then:
> +              properties:
> +                rx-internal-delay-ps:
> +                  $ref: "#/$defs/internal-delay-ps"
> +                tx-internal-delay-ps:
> +                  $ref: "#/$defs/internal-delay-ps"

Likewise, this should actually be changed in ethernet-controller.yaml
-- 
Florian
