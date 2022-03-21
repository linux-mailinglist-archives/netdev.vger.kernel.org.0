Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 160884E2CDA
	for <lists+netdev@lfdr.de>; Mon, 21 Mar 2022 16:52:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347860AbiCUPwi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Mar 2022 11:52:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238686AbiCUPwg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Mar 2022 11:52:36 -0400
Received: from mail-wr1-f52.google.com (mail-wr1-f52.google.com [209.85.221.52])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 621D01557FF;
        Mon, 21 Mar 2022 08:51:11 -0700 (PDT)
Received: by mail-wr1-f52.google.com with SMTP id r10so21329536wrp.3;
        Mon, 21 Mar 2022 08:51:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=hefucE+Jiu9ept//sebHy0SZe1pf91jzk4A2hhyEoXU=;
        b=j5xnLu4HfbvAZePTS+Q8j2bHhaftEKa8xdA01aScy2pzazE+gAPbz6pO0JtVC5Zq1e
         N4Hs5AMCIGYtqhsYv265rz8TBpwSwGIZO5MbPglxS2WeF3YEf0AnF1pCuxJS/u+ZqEHR
         gdCUPnJ0eh9RCPPfTmo8E4TytT6+2PEzWmsFJdeW0SP50r3z0UasQi3T67cQMp74rRVG
         x2K96uw9LKOXXaGz6IV6UkYvLjh2TVIHUP5+FqlHocQ8HpLclT0d2xsEGpqcCadpkMkY
         0Foy0FbPKnc8T/xmVr+BVtg35FHtJIbqhcEVhK0LwGu9vaIwD27HsQSlCZvHuGdG71b2
         RCHw==
X-Gm-Message-State: AOAM533PXJwUG47JMtrettbyIIlzp6DGwHWUjLDGqw1nqy5VsYPWvom4
        h7ajqYl5MegyVFIq4c+cuD4=
X-Google-Smtp-Source: ABdhPJwvW8A/Q2Qjh46eoL/oVh5ZiV0UasSIAFG93IFQXPqcKZSoCt5kt1x/8yu76BU3wmUskwpDfw==
X-Received: by 2002:a5d:6acd:0:b0:1ef:78e9:193a with SMTP id u13-20020a5d6acd000000b001ef78e9193amr18601351wrw.281.1647877869926;
        Mon, 21 Mar 2022 08:51:09 -0700 (PDT)
Received: from [192.168.0.17] (78-11-189-27.static.ip.netia.com.pl. [78.11.189.27])
        by smtp.googlemail.com with ESMTPSA id u7-20020a5d6da7000000b00203d9d1875bsm15376362wrs.73.2022.03.21.08.51.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 21 Mar 2022 08:51:09 -0700 (PDT)
Message-ID: <3aae94bd-d39d-ddfc-2b06-356173f6b1f8@kernel.org>
Date:   Mon, 21 Mar 2022 16:51:07 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH v2 1/3] dt-bindings: net: add reset property for aspeed,
 ast2600-mdio binding
Content-Language: en-US
To:     Dylan Hung <dylan_hung@aspeedtech.com>, robh+dt@kernel.org,
        joel@jms.id.au, andrew@aj.id.au, andrew@lunn.ch,
        hkallweit1@gmail.com, linux@armlinux.org.uk, davem@davemloft.net,
        kuba@kernel.org, pabeni@redhat.com, p.zabel@pengutronix.de,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-aspeed@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     BMC-SW@aspeedtech.com, stable@vger.kernel.org
References: <20220321095648.4760-1-dylan_hung@aspeedtech.com>
 <20220321095648.4760-2-dylan_hung@aspeedtech.com>
From:   Krzysztof Kozlowski <krzk@kernel.org>
In-Reply-To: <20220321095648.4760-2-dylan_hung@aspeedtech.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 21/03/2022 10:56, Dylan Hung wrote:
> The AST2600 MDIO bus controller has a reset control bit and must be
> deasserted before the manipulating the MDIO controller.
> 
> Signed-off-by: Dylan Hung <dylan_hung@aspeedtech.com>
> Cc: stable@vger.kernel.org

No bugs fixes, no cc-stable. Especially that you break existing devices...

> ---
>  .../devicetree/bindings/net/aspeed,ast2600-mdio.yaml          | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/Documentation/devicetree/bindings/net/aspeed,ast2600-mdio.yaml b/Documentation/devicetree/bindings/net/aspeed,ast2600-mdio.yaml
> index 1c88820cbcdf..8ba108e25d94 100644
> --- a/Documentation/devicetree/bindings/net/aspeed,ast2600-mdio.yaml
> +++ b/Documentation/devicetree/bindings/net/aspeed,ast2600-mdio.yaml
> @@ -23,12 +23,15 @@ properties:
>    reg:
>      maxItems: 1
>      description: The register range of the MDIO controller instance

Missing empty line.

> +  resets:
> +    maxItems: 1
>  
>  required:
>    - compatible
>    - reg
>    - "#address-cells"
>    - "#size-cells"
> +  - resets

You break the ABI. This isusually not accepted in a regular kernel and
even totally not accepted accepted for stable kernel.

>  
>  unevaluatedProperties: false
>  
> @@ -39,6 +42,7 @@ examples:
>              reg = <0x1e650000 0x8>;
>              #address-cells = <1>;
>              #size-cells = <0>;
> +            resets = <&syscon 35>;
>  
>              ethphy0: ethernet-phy@0 {
>                      compatible = "ethernet-phy-ieee802.3-c22";


Best regards,
Krzysztof
