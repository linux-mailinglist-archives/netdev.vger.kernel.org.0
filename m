Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ACBFA525E50
	for <lists+netdev@lfdr.de>; Fri, 13 May 2022 11:19:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244331AbiEMIwu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 May 2022 04:52:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378479AbiEMIwr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 May 2022 04:52:47 -0400
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13DA1237BA5
        for <netdev@vger.kernel.org>; Fri, 13 May 2022 01:52:46 -0700 (PDT)
Received: by mail-wm1-x32e.google.com with SMTP id p189so4409422wmp.3
        for <netdev@vger.kernel.org>; Fri, 13 May 2022 01:52:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=vxOaJmhjH8YfZIQgKyqCCSLbPOKdrfGtpJAlkONHxog=;
        b=GGJwKVeDzH7KEj2fuqdiuUJEd++CsSPJSNO//C3THrrQb3nwOv3EW6+PIZQRjmMhK2
         HXaJvvUY4jZ0322WWhNHFWNkrNz70aGRa03TL5xF/LA2d3d0KKhH5KmT8CUKjxB+41Gg
         e7C/7U9OGQvFDT2ZC4RSTDdSl4fKoO8VLKXUyATSDpji1CTdUyK207hajqPBqpXxsk4I
         4PsGLN2JWObqq2X+3YyWihOuIm0ZjEfNNPGGnkL5USgUM0UsBnxUnhKrzEO0+ZFy38G4
         x0cv0OiahC8GeZPS0gGaMI7zd3AT3AHxa4iqRPtI+d+E6ZVm/uX/OMAHMhhBob3rmFgN
         Q4Jw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=vxOaJmhjH8YfZIQgKyqCCSLbPOKdrfGtpJAlkONHxog=;
        b=dGwvVye1qMW2J/64fs8I7xh9YBr9YL0h+3Qi5UcFBo0stahhi5Z9wdDV5uYxxPKFJ+
         ge3R0VWW4UOorH40+6yX4chIURvi/4ncf84oTZhf0gLD6zReW0uJW4485kFUx6bHbfoN
         Pmzj9idl2YpOZHQRjx82FzzjAjCMhzX/ejo2ELccxFeHEh3wIPVXbIvIrUrkfebtbyVD
         x1PbjkHjNeCF7YfAZO6a/7GSc59EbxWzfwDSeW+U8/mWHt3D1XvSO9S56ZYhR6EUiVxh
         IZVfNHUov2Kixy/CCaMjsZloOSS6BxzRLdnHuJBnhzQIRnjsZIg6CMiVx8XRNoJ2eZrt
         rBjA==
X-Gm-Message-State: AOAM533I+4gUI/Cbw4prgAI0BjyT2zcF6f0qXvCnmO5cXYXcOhq+OKP9
        PkO65zK+Rx9E39AEmJx43AVmpSZhkpO1sNiq
X-Google-Smtp-Source: ABdhPJwB5E1AU8zrdU9CCG/fjfh2BsS7a4F0VMUcpJiVYYFQPquanL1yleesfXtFvnZRlXmz+6Ht8A==
X-Received: by 2002:a05:600c:1e13:b0:394:5cdd:e8e6 with SMTP id ay19-20020a05600c1e1300b003945cdde8e6mr13753489wmb.108.1652431964605;
        Fri, 13 May 2022 01:52:44 -0700 (PDT)
Received: from [192.168.0.169] (xdsl-188-155-176-92.adslplus.ch. [188.155.176.92])
        by smtp.gmail.com with ESMTPSA id v3-20020adf8b43000000b0020c5253d8c2sm1627008wra.14.2022.05.13.01.52.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 13 May 2022 01:52:44 -0700 (PDT)
Message-ID: <8b441f8f-7aa2-0fab-9b90-6618a1e8c899@linaro.org>
Date:   Fri, 13 May 2022 10:52:42 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
Subject: Re: [RFC net-next] dt-bindings: net: xilinx: document xilinx emaclite
 driver binding
Content-Language: en-US
To:     Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, harini.katakam@xilinx.com
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, git@xilinx.com
References: <1652373596-5994-1-git-send-email-radhey.shyam.pandey@xilinx.com>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <1652373596-5994-1-git-send-email-radhey.shyam.pandey@xilinx.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/05/2022 18:39, Radhey Shyam Pandey wrote:
> Add basic description for the xilinx emaclite driver DT bindings.
> 
> Signed-off-by: Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>
> ---
>  .../bindings/net/xlnx,emaclite.yaml           | 60 +++++++++++++++++++
>  1 file changed, 60 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/net/xlnx,emaclite.yaml

Why is this RFC? Do you expect DT maintainers review or not? Maybe there
is no point for us to review something which is not going to be applied?

> 
> diff --git a/Documentation/devicetree/bindings/net/xlnx,emaclite.yaml b/Documentation/devicetree/bindings/net/xlnx,emaclite.yaml
> new file mode 100644
> index 000000000000..a3e2a0e89b24
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/net/xlnx,emaclite.yaml
> @@ -0,0 +1,60 @@
> +# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
> +%YAML 1.2
> +---
> +$id: http://devicetree.org/schemas/net/xlnx,emaclite.yaml#
> +$schema: http://devicetree.org/meta-schemas/core.yaml#
> +
> +title: Xilinx Emaclite Ethernet controller
> +
> +maintainers:
> +  - Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>
> +  - Harini Katakam <harini.katakam@xilinx.com>
> +

You should include ethernet controller schema.

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
> +            compatible = "xlnx,xps-ethernetlite-3.00.a";

4-space indentation for DTS, please.

> +            interrupt-parent = <&axi_intc_1>;
> +            interrupts = <1 0>;
> +            local-mac-address = [00 0a 35 00 00 00];
> +            phy-handle = <&phy0>;
> +            reg = <0x40e00000 0x10000>;
> +            xlnx,rx-ping-pong;
> +            xlnx,tx-ping-pong;
> +    };


Best regards,
Krzysztof
