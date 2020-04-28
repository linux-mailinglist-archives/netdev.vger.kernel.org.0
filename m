Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 82BD61BC251
	for <lists+netdev@lfdr.de>; Tue, 28 Apr 2020 17:09:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728028AbgD1PJf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Apr 2020 11:09:35 -0400
Received: from mail-ot1-f67.google.com ([209.85.210.67]:45056 "EHLO
        mail-ot1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727803AbgD1PJe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Apr 2020 11:09:34 -0400
Received: by mail-ot1-f67.google.com with SMTP id e20so33149856otk.12;
        Tue, 28 Apr 2020 08:09:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=FEtkU4hcjYXFmjYfyqu325vicHnMHo34pYaXMraZzDM=;
        b=MSzdK9eL6RarXRAXGxpFZCxKaYoEwEkQw0jcqso6SM5bBB+YGFogDT+2oxUgEXek3S
         /zPjHYEAN3GVlFCwPo6/3hIK4sdzavpU28MFG4EUCHcTr1SWy/lyD6arlLr2JG5keluT
         +SHtDS8tJLMaAOkqAyifftsDu9ucmbNguhdT1iAOq6+PC7IXMifg3B24sGMmy9QB6h/7
         ZKqHX3Es+szWNwupVdi4MnQUvpQ68X+x+bC7MsPvj9dv9uwA1zg/JUjMXsK7beP+LqTP
         rFSzeykw1NlbBWo+JzqZy3VupXEvpFslUC/B+QsDCiD9aOMX4n9+E6jNMfBdRrZypKfS
         pRxA==
X-Gm-Message-State: AGi0PuauVY2Kj6f7HHZEnjT3bqK+Bio0YZ1ZJqvKV/usmMtNjqTcUnA/
        8O1AgfgNKZ2W7LS5RDz5BA==
X-Google-Smtp-Source: APiQypKmYM+VdqehUo6MhirkRmkVcweA2beGuUjgMoVitv5BtZ9cDwt/Cg8BC2ldu07VXvCN5xX9Iw==
X-Received: by 2002:a05:6830:141:: with SMTP id j1mr8997476otp.294.1588086572206;
        Tue, 28 Apr 2020 08:09:32 -0700 (PDT)
Received: from rob-hp-laptop (24-155-109-49.dyn.grandenetworks.net. [24.155.109.49])
        by smtp.gmail.com with ESMTPSA id u9sm4102772ote.47.2020.04.28.08.09.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Apr 2020 08:09:31 -0700 (PDT)
Received: (nullmailer pid 31119 invoked by uid 1000);
        Tue, 28 Apr 2020 15:09:30 -0000
Date:   Tue, 28 Apr 2020 10:09:30 -0500
From:   Rob Herring <robh@kernel.org>
To:     Robert Marko <robert.marko@sartura.hr>
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, hkallweit1@gmail.com,
        linux@armlinux.org.uk, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, agross@kernel.org,
        bjorn.andersson@linaro.org, mark.rutland@arm.com,
        linux-arm-msm@vger.kernel.org, devicetree@vger.kernel.org,
        Luka Perkov <luka.perkov@sartura.hr>
Subject: Re: [PATCH v3 2/3] dt-bindings: add Qualcomm IPQ4019 MDIO bindings
Message-ID: <20200428150930.GA25643@bogus>
References: <20200415150244.2737206-1-robert.marko@sartura.hr>
 <20200415150244.2737206-2-robert.marko@sartura.hr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200415150244.2737206-2-robert.marko@sartura.hr>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 15, 2020 at 05:02:46PM +0200, Robert Marko wrote:
> This patch adds the binding document for the IPQ40xx MDIO driver.
> 
> Signed-off-by: Robert Marko <robert.marko@sartura.hr>
> Cc: Luka Perkov <luka.perkov@sartura.hr>
> ---
> Changes from v2 to v3:
> * Remove status from example
> 
>  .../bindings/net/qcom,ipq40xx-mdio.yaml       | 61 +++++++++++++++++++
>  1 file changed, 61 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/net/qcom,ipq40xx-mdio.yaml
> 
> diff --git a/Documentation/devicetree/bindings/net/qcom,ipq40xx-mdio.yaml b/Documentation/devicetree/bindings/net/qcom,ipq40xx-mdio.yaml
> new file mode 100644
> index 000000000000..8d4542ccd38c
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/net/qcom,ipq40xx-mdio.yaml
> @@ -0,0 +1,61 @@
> +# SPDX-License-Identifier: GPL-2.0

Dual license new bindings please:

(GPL-2.0-only OR BSD-2-Clause)

> +%YAML 1.2
> +---
> +$id: http://devicetree.org/schemas/net/qcom,ipq40xx-mdio.yaml#
> +$schema: http://devicetree.org/meta-schemas/core.yaml#
> +
> +title: Qualcomm IPQ40xx MDIO Controller Device Tree Bindings
> +
> +maintainers:
> +  - Robert Marko <robert.marko@sartura.hr>
> +
> +allOf:
> +  - $ref: "mdio.yaml#"
> +
> +properties:
> +  compatible:
> +    const: qcom,ipq40xx-mdio

Don't use wildcards in compatible names. Should be SoC specific. If 'all 
the same', then use a fallback to the 1st implementation.

> +
> +  "#address-cells":
> +    const: 1
> +
> +  "#size-cells":
> +    const: 0
> +
> +  reg:
> +    maxItems: 1
> +
> +required:
> +  - compatible
> +  - reg
> +  - "#address-cells"
> +  - "#size-cells"
> +
> +examples:
> +  - |
> +    mdio@90000 {
> +      #address-cells = <1>;
> +      #size-cells = <0>;
> +      compatible = "qcom,ipq40xx-mdio";
> +      reg = <0x90000 0x64>;
> +
> +      ethphy0: ethernet-phy@0 {
> +        reg = <0>;
> +      };
> +
> +      ethphy1: ethernet-phy@1 {
> +        reg = <1>;
> +      };
> +
> +      ethphy2: ethernet-phy@2 {
> +        reg = <2>;
> +      };
> +
> +      ethphy3: ethernet-phy@3 {
> +        reg = <3>;
> +      };
> +
> +      ethphy4: ethernet-phy@4 {
> +        reg = <4>;
> +      };
> +    };
> -- 
> 2.26.0
> 
