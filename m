Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0D8EE60F7D6
	for <lists+netdev@lfdr.de>; Thu, 27 Oct 2022 14:46:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235779AbiJ0Mqf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Oct 2022 08:46:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235770AbiJ0Mqd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Oct 2022 08:46:33 -0400
Received: from mail-qk1-x730.google.com (mail-qk1-x730.google.com [IPv6:2607:f8b0:4864:20::730])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 346E5D0188
        for <netdev@vger.kernel.org>; Thu, 27 Oct 2022 05:46:31 -0700 (PDT)
Received: by mail-qk1-x730.google.com with SMTP id i10so598280qkl.12
        for <netdev@vger.kernel.org>; Thu, 27 Oct 2022 05:46:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=iLWIFJ61KTvk1h38Frs3TC3TSHJ2QOFTnp6zMPLI/+I=;
        b=bAtEYEDuiP+0dE9YH0zh3Twa1GNhE/bYPvc7qdUChMfJ0UkTMZ8R8F+u09cejlTxCK
         3xkoQP510XkYGtKmlbPWtii27mmosmOfd79+LaI/ecU/fFIpjMqVD2UKlpdJDOfPPCmi
         mlxutkL6/LrFuMsYH3aLizU1nMUwYOJHy/3EhT3XPaJ7kJ+duOc4EGlqH8hdEecgztW9
         mhEIYB1M47wfTZmsP4LxdrboCOnTUXgfitw5HIjaBdgOLdFqvDq6JFgtdUIKgSUcw+D6
         aWTHv/f69tZv0vopupoSbe9/Y3nmhteCEOGcg9mHS/1lHjUBDXPxk+z+LSB+lUuSbED/
         joAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=iLWIFJ61KTvk1h38Frs3TC3TSHJ2QOFTnp6zMPLI/+I=;
        b=Ma+JziPM0lWhHouE4sEHwBbxKusawbz/nhkn95+CfF1qUQ1/iseacWwIV+uqUL8wcb
         u8hrh36shJGmDVAtDNpYcfITRnSjwM5JVPhX9EClD3950lbhvoBrLEI3JZDg1DUY3JIu
         EeNtnlRmlF2qsi/hqCewA18uuFMaFQGQmjsEBkzx+9tB66YnxoHpxFK0EuKcJQPZeJzR
         cT7G0pS7X67gfwU7WC/PiU0t/eY46w+YjQatGpSJF50BPETc53yyy+m23fGdQ6xYGttk
         l6iU2db5QBuOLkP+dmsYGEEficYHP6OSkyNu1zqeSs6QZP8w0uNbf4w6bvmvpvzRUSnD
         eVkw==
X-Gm-Message-State: ACrzQf0LNyIEGeC69q+ihwdKwWlwfEVCcGyIfEWh+xi49Ga0xn9EuAbh
        BY1dgRdpl6tsLkgK1dCmxJ7HMw==
X-Google-Smtp-Source: AMsMyM4fC/T/b/VpCuYYB88TAAL0TjNeBxrrJLylS1QScUfck2OJ7U/fGdAnSaZ1eNjXUKzNIBE9Ng==
X-Received: by 2002:a05:620a:4245:b0:6d7:6d51:f66e with SMTP id w5-20020a05620a424500b006d76d51f66emr33806295qko.617.1666874790292;
        Thu, 27 Oct 2022 05:46:30 -0700 (PDT)
Received: from [192.168.1.11] ([64.57.193.93])
        by smtp.gmail.com with ESMTPSA id n14-20020a05620a294e00b006eed094dcdasm912535qkp.70.2022.10.27.05.46.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 27 Oct 2022 05:46:29 -0700 (PDT)
Message-ID: <a7f75d47-30e7-d076-a9fd-baa57688bbf7@linaro.org>
Date:   Thu, 27 Oct 2022 08:46:27 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.0
Subject: Re: [RFC net-next 1/2] dt-bindings: net: dsa: add bindings for GSW
 Series switches
Content-Language: en-US
To:     Camel Guo <camelg@axis.com>, Camel Guo <Camel.Guo@axis.com>,
        Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>
Cc:     "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Rob Herring <robh@kernel.org>, kernel <kernel@axis.com>
References: <20221025135243.4038706-1-camel.guo@axis.com>
 <20221025135243.4038706-2-camel.guo@axis.com>
 <16aac887-232a-7141-cc65-eab19c532592@linaro.org>
 <d0179725-0730-5826-caa4-228469d3bad4@axis.com>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <d0179725-0730-5826-caa4-228469d3bad4@axis.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 27/10/2022 02:34, Camel Guo wrote:
> On 10/25/22 16:27, Krzysztof Kozlowski wrote:
>  > On 25/10/2022 09:52, Camel Guo wrote:
>  >> Add documentation and an example for Maxlinear's GSW Series Ethernet
>  >> switches.
>  >>
>  >> Signed-off-by: Camel Guo <camel.guo@axis.com>
>  >> ---
>  >>  .../devicetree/bindings/net/dsa/mxl,gsw.yaml  | 140 ++++++++++++++++++
>  >>  .../devicetree/bindings/vendor-prefixes.yaml  |   2 +
>  >>  MAINTAINERS                                   |   6 +
>  >>  3 files changed, 148 insertions(+)
>  >>  create mode 100644 
> Documentation/devicetree/bindings/net/dsa/mxl,gsw.yaml
>  >>
>  >> diff --git a/Documentation/devicetree/bindings/net/dsa/mxl,gsw.yaml 
> b/Documentation/devicetree/bindings/net/dsa/mxl,gsw.yaml
>  >> new file mode 100644
>  >> index 000000000000..8e124b7ec58c
>  >> --- /dev/null
>  >> +++ b/Documentation/devicetree/bindings/net/dsa/mxl,gsw.yaml
>  >
>  > Filename based on compatible, so mxl,gsw145-mdio.yaml. But see below.
> 
> I hope in future more gsw1xx chips (e.g: GSW150, GSW120) can be added
> and more management modes (e.g: uart, spi) can be supported. 

Maybe you will add support, maybe not. If these compatibles were
mentioned now, would be different topic, but there are not.

> So I think
> maybe mxl.gsw.yaml is more generic. Otherwise maybe in future someone
> has to add files like mxl,gsw150-uart.yaml, mxl,gsw120-spi.yaml

No, they can be added here, with or without renaming the file.

> 
>  >
>  >> @@ -0,0 +1,140 @@
>  >> +# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
>  >> +%YAML 1.2
>  >> +---
>  >> +$id: http://devicetree.org/schemas/net/dsa/mxl,gsw.yaml#
>  > <http://devicetree.org/schemas/net/dsa/mxl,gsw.yaml#>
>  >> +$schema: http://devicetree.org/meta-schemas/core.yaml#
>  > <http://devicetree.org/meta-schemas/core.yaml#>
>  >> +
>  >> +title: Maxlinear GSW Series Switch Device Tree Bindings
>  >
>  > Drop "Device Tree Bindings"
> 
> Ack. will do in v2
> 
>  >
>  >> +
>  >> +allOf:
>  >> +  - $ref: dsa.yaml#
>  >> +
>  >> +maintainers:
>  >> +  - Camel Guo <camel.guo@axis.com>
>  >> +
>  >> +description:
>  >> +  The Maxlinear's GSW Series Ethernet Switch is a highly 
> integrated, low-power,
>  >> +  non-blocking Gigabit Ethernet Switch.
>  >> +
>  >> +properties:
>  >> +  compatible:
>  >> +    oneOf:
>  >
>  > You do not have multiple choices, so no need for oneOf >
> 
> Currently that is true. But according to the datasheet of gsw1xx, it
> could be easily to expand to other gsw1xx chips and other management
> interfaces (e.g: spi, uart). If so, we could add something like:
> mxl,gsw145-spi
> mxl,gsw150-mdio


So expand it now... Anyway enum allows you to add new types, so why why
oneOf?

> ...
> 
> 
>  >> +      - enum:
>  >> +          - mxl,gsw145-mdio
>  >
>  > Why "mdio" suffix?
> 
> Inspired by others dsa chips.
> lan9303.txt:  - "smsc,lan9303-mdio" for mdio managed mode
> lantiq-gswip.txt:- compatible   : "lantiq,xrx200-mdio" for the MDIO bus
> inside the GSWIP
> nxp,sja1105.yaml:                  - nxp,sja1110-base-t1-mdio

As I replied to Andrew, this is discouraged.

Best regards,
Krzysztof

