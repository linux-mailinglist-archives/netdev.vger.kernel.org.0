Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 458B955C190
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 14:45:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235717AbiF0NbO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jun 2022 09:31:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235469AbiF0NbN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jun 2022 09:31:13 -0400
Received: from mail-io1-f41.google.com (mail-io1-f41.google.com [209.85.166.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A000F6457;
        Mon, 27 Jun 2022 06:31:12 -0700 (PDT)
Received: by mail-io1-f41.google.com with SMTP id z191so9525900iof.6;
        Mon, 27 Jun 2022 06:31:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:in-reply-to:references:subject:date
         :message-id;
        bh=gvyNOyKg09RJXU5ec40IlIX3sIrR9XwCvpl1WEk0W1A=;
        b=Yy3XmkTJ4AuyTeGg+L1n9Um8dBoidfwsPStfg+WFgZhNEd5n0dG3jLpGouzAGBnCou
         qqW5NsoyMLsLVcG9Ra7fVGLJcAJfjya/nNQQJPdea44VFoLYGWSP86S6J16RRySgohsK
         3JQmTpnepk5sNItWRdcxhQWGlFoL+Uf6uwFmxXRsM3IKCtSWNTm+TBURveHNJ9VNB8Wx
         fB6OGE38wedfHvlUKAasn1SpoSzxhIUB+o9o1yJHL8N4+UYPl0EKIaKBmiC2ktKCNsLx
         vFXiwhyjg1cfovHq0DR+DgsZuaH/BpXEjm5J4Zzk7D52Kh42gfd03KG92CR0n8kbi6pe
         oV/w==
X-Gm-Message-State: AJIora8CaVeH1HQAUqqUJZKHLv0HdyC9UbfRsp9ueWgrroNqKaCLAErS
        VpBpP4J0UvAdEXy9B5xuUQ==
X-Google-Smtp-Source: AGRyM1sn5cxnWTFDJThm/N0WYIXFSI3CGx3Yy45HDIAoBp2dOs8SX9fD0bX2JUrEW7c9t3fT7UtB8g==
X-Received: by 2002:a02:c942:0:b0:339:ec11:d04e with SMTP id u2-20020a02c942000000b00339ec11d04emr7739526jao.174.1656336671717;
        Mon, 27 Jun 2022 06:31:11 -0700 (PDT)
Received: from robh.at.kernel.org ([64.188.179.253])
        by smtp.gmail.com with ESMTPSA id n21-20020a6b4115000000b0067554b8e92asm229787ioa.20.2022.06.27.06.31.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Jun 2022 06:31:11 -0700 (PDT)
Received: (nullmailer pid 2285163 invoked by uid 1000);
        Mon, 27 Jun 2022 13:31:09 -0000
From:   Rob Herring <robh@kernel.org>
To:     alexandru.tachici@analog.com
Cc:     krzysztof.kozlowski+dt@linaro.org, joel@jms.id.au,
        l.stelmach@samsung.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, stephen@networkplumber.org,
        geert@linux-m68k.org, stefan.wahren@i2se.com, wellslutw@gmail.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        gerhard@engleder-embedded.com, devicetree@vger.kernel.org,
        geert+renesas@glider.be, robh+dt@kernel.org,
        d.michailidis@fungible.com
In-Reply-To: <20220624200628.77047-3-alexandru.tachici@analog.com>
References: <20220624200628.77047-1-alexandru.tachici@analog.com> <20220624200628.77047-3-alexandru.tachici@analog.com>
Subject: Re: [net-next 2/2] dt-bindings: net: adin1110: Add docs
Date:   Mon, 27 Jun 2022 07:31:09 -0600
Message-Id: <1656336669.630006.2285162.nullmailer@robh.at.kernel.org>
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,
        FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 24 Jun 2022 23:06:28 +0300, alexandru.tachici@analog.com wrote:
> From: Alexandru Tachici <alexandru.tachici@analog.com>
> 
> Add bindings for the ADIN1110/2111 MAC-PHY/SWITCH.
> 
> Signed-off-by: Alexandru Tachici <alexandru.tachici@analog.com>
> ---
>  .../devicetree/bindings/net/adi,adin1110.yaml | 127 ++++++++++++++++++
>  1 file changed, 127 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/net/adi,adin1110.yaml
> 

My bot found errors running 'make DT_CHECKER_FLAGS=-m dt_binding_check'
on your patch (DT_CHECKER_FLAGS is new in v5.13):

yamllint warnings/errors:

dtschema/dtc warnings/errors:
./Documentation/devicetree/bindings/net/adi,adin1110.yaml: Unable to find schema file matching $id: http://devicetree.org/schemas/net/spi-controller.yaml
/builds/robherring/linux-dt-review/Documentation/devicetree/bindings/net/adi,adin1110.example.dtb: ethernet@0: False schema does not allow {'compatible': ['adi,adin2111'], 'reg': [[0]], 'spi-max-frequency': [[24500000]], 'adi,spi-crc': True, '#address-cells': [[1]], '#size-cells': [[0]], 'interrupts': [[25, 2]], 'mac-address': [[202, 47, 183, 16, 35, 99]], 'phy@0': {'#phy-cells': [[0]], 'compatible': ['ethernet-phy-id0283.bca1'], 'reg': [[0]]}, 'phy@1': {'#phy-cells': [[0]], 'compatible': ['ethernet-phy-id0283.bca1'], 'reg': [[1]]}, '$nodename': ['ethernet@0']}
	From schema: /builds/robherring/linux-dt-review/Documentation/devicetree/bindings/net/adi,adin1110.yaml

doc reference errors (make refcheckdocs):

See https://patchwork.ozlabs.org/patch/

This check can fail if there are any dependencies. The base for a patch
series is generally the most recent rc1.

If you already ran 'make dt_binding_check' and didn't see the above
error(s), then make sure 'yamllint' is installed and dt-schema is up to
date:

pip3 install dtschema --upgrade

Please check and re-submit.

