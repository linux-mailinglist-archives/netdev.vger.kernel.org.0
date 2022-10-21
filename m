Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D26A26079F5
	for <lists+netdev@lfdr.de>; Fri, 21 Oct 2022 16:53:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229729AbiJUOxt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Oct 2022 10:53:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229449AbiJUOxr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Oct 2022 10:53:47 -0400
Received: from mail-oa1-f43.google.com (mail-oa1-f43.google.com [209.85.160.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E44E813224F;
        Fri, 21 Oct 2022 07:53:45 -0700 (PDT)
Received: by mail-oa1-f43.google.com with SMTP id 586e51a60fabf-13b23e29e36so3092400fac.8;
        Fri, 21 Oct 2022 07:53:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=date:subject:message-id:references:in-reply-to:cc:to:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=3OjGVeTvODIBbTo/SrESzi4uOh+yZbR1H/f+SbyBdlc=;
        b=hr30QuXxBuZsSrcB2Nh15HzVnDz1lSUJlaJXvb88XdHaPx6RAVcWzU5trKFIPVBrWV
         NRk9vGHETobpyNmk3agM3RsDlL/y7vPnwxP1EpuOhYpuTvfRv5RsHklk+kqosCaM+K/0
         muKeeTodvEVidTaxltTwxnGumuztzjGE1n5AbifhsOW6nLF6ogwildTerltkpRh18j4y
         6f9/5irHBlUk6XknF1vxyAobouks41VMZCbrCWb+7y76p6Y1bIxy9u/01Vf2Vbul4o7G
         P8pVrNf8Ime1nPl6zbg2zqlzbxz2+1V0HwscpG0ExmOJKfrRtQlX816EfPPUquagwH6K
         ZzOw==
X-Gm-Message-State: ACrzQf1mXlhwOBLHpdEc/teBSMNAIdlb6AJIf6bVnLHm6T0EhdfIBS1e
        yB3VoEnX+MpVbOSZgz4NtQ==
X-Google-Smtp-Source: AMsMyM5D0l7ZS02B7nphvgFz2ZyynZhxGSFVZxGIVW7766XaBCkT+7Eqm1ZWsyl9cRMXSGVe7htB8A==
X-Received: by 2002:a05:6871:720:b0:137:2100:2550 with SMTP id f32-20020a056871072000b0013721002550mr24314194oap.211.1666364025105;
        Fri, 21 Oct 2022 07:53:45 -0700 (PDT)
Received: from robh_at_kernel.org (66-90-144-107.dyn.grandenetworks.net. [66.90.144.107])
        by smtp.gmail.com with ESMTPSA id y1-20020a0568302a0100b0066193fe498bsm1186128otu.28.2022.10.21.07.53.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Oct 2022 07:53:44 -0700 (PDT)
Received: (nullmailer pid 3723735 invoked by uid 1000);
        Fri, 21 Oct 2022 14:53:46 -0000
From:   Rob Herring <robh@kernel.org>
To:     Maxime Chevallier <maxime.chevallier@bootlin.com>
Cc:     devicetree@vger.kernel.org, Luka Perkov <luka.perkov@sartura.hr>,
        Russell King <linux@armlinux.org.uk>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        linux-arm-kernel@lists.infradead.org,
        Florian Fainelli <f.fainelli@gmail.com>,
        thomas.petazzoni@bootlin.com, Andrew Lunn <andrew@lunn.ch>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        linux-kernel@vger.kernel.org,
        Robert Marko <robert.marko@sartura.hr>,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        davem@davemloft.net, netdev@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>
In-Reply-To: <20221021124556.100445-2-maxime.chevallier@bootlin.com>
References: <20221021124556.100445-1-maxime.chevallier@bootlin.com> <20221021124556.100445-2-maxime.chevallier@bootlin.com>
Message-Id: <166636401759.3723525.17897747781919721401.robh@kernel.org>
Subject: Re: [PATCH net-next v5 1/5] net: dt-bindings: Introduce the Qualcomm IPQESS Ethernet controller
Date:   Fri, 21 Oct 2022 09:53:46 -0500
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,
        FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 21 Oct 2022 14:45:52 +0200, Maxime Chevallier wrote:
> Add the DT binding for the IPQESS Ethernet Controller. This is a simple
> controller, only requiring the phy-mode, interrupts, clocks, and
> possibly a MAC address setting.
> 
> Signed-off-by: Maxime Chevallier <maxime.chevallier@bootlin.com>
> ---
> V4->V5:
>  - Remove stray quotes arount the ref property
>  - Rename the binding to match the compatible string
> V3->V4:
>  - Fix a binding typo in the compatible string
> V2->V3:
>  - Cleanup on reset and clock names
> V1->V2:
>  - Fixed the example
>  - Added reset and clocks
>  - Removed generic ethernet attributes
>  .../bindings/net/qcom,ipq4019-ess-edma.yaml   | 95 +++++++++++++++++++
>  1 file changed, 95 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/net/qcom,ipq4019-ess-edma.yaml
> 

My bot found errors running 'make DT_CHECKER_FLAGS=-m dt_binding_check'
on your patch (DT_CHECKER_FLAGS is new in v5.13):

yamllint warnings/errors:

dtschema/dtc warnings/errors:
./Documentation/devicetree/bindings/net/qcom,ipq4019-ess-edma.yaml: $id: relative path/filename doesn't match actual path or filename
	expected: http://devicetree.org/schemas/net/qcom,ipq4019-ess-edma.yaml#

doc reference errors (make refcheckdocs):

See https://patchwork.ozlabs.org/patch/

This check can fail if there are any dependencies. The base for a patch
series is generally the most recent rc1.

If you already ran 'make dt_binding_check' and didn't see the above
error(s), then make sure 'yamllint' is installed and dt-schema is up to
date:

pip3 install dtschema --upgrade

Please check and re-submit.

