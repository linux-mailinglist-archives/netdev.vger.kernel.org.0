Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4D1244C615D
	for <lists+netdev@lfdr.de>; Mon, 28 Feb 2022 03:44:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231441AbiB1CpN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 27 Feb 2022 21:45:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229835AbiB1CpL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 27 Feb 2022 21:45:11 -0500
Received: from mail-oo1-f52.google.com (mail-oo1-f52.google.com [209.85.161.52])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2AE841CB36;
        Sun, 27 Feb 2022 18:44:33 -0800 (PST)
Received: by mail-oo1-f52.google.com with SMTP id i6-20020a4ac506000000b0031c5ac6c078so16769945ooq.6;
        Sun, 27 Feb 2022 18:44:33 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:in-reply-to:references:subject:date
         :message-id;
        bh=NCyRXTyGzECwRj32maNs2V1YROZGx+Yzpw7YRcxNO9I=;
        b=ZjQ+G8PUYZmuYe5Zpj+Q/b8jZILTU6XXTg+wc3m89CStkMerA5DL87TCjx/JpzDSQF
         GeArpRJLSptTrHrS9Dpax6KAN9ZCtUMDZ7l24gwA4tDsNehXILT/NW+GJbbUsG4Pz1w4
         WGhokxsJ5LXjCqW6CwY6FPb8PEoWNRXWbHF1oQEtca+LSbtRAuGg+UKh4kgfPh21EG31
         3zJG5CZ+M7gEUZ+XGylFftLmr0teGeF8Hf9BQRoz1fjDs89kDKyFTvVqOdU7ExiXTHHY
         LLAiyKLyf13t2Qa6Jtm7lSxnLdIpZksALkyTGHJl7c4NWIqvDqcZuWVguNteItSpoUSj
         gA6A==
X-Gm-Message-State: AOAM530S/M8TYXTK7ToiS08Szakwe/PFYDX+10V5SXuekN6t4bJLZxk5
        zh02PVtia+BVbQK9YlIqkdCsfNE2AA==
X-Google-Smtp-Source: ABdhPJxTu83D0Cc53SqyH+LRyQtGVFFa1tlVAG4lz1axZ9Ar90koOUbbwKv6eYOhN9JLi8dNvYWW2A==
X-Received: by 2002:a05:6870:c1c6:b0:d7:1b8:2ad3 with SMTP id i6-20020a056870c1c600b000d701b82ad3mr4715289oad.285.1646016272336;
        Sun, 27 Feb 2022 18:44:32 -0800 (PST)
Received: from robh.at.kernel.org (66-90-148-213.dyn.grandenetworks.net. [66.90.148.213])
        by smtp.gmail.com with ESMTPSA id v5-20020a544d05000000b002d7652b3c52sm3454396oix.25.2022.02.27.18.44.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 27 Feb 2022 18:44:31 -0800 (PST)
Received: (nullmailer pid 47195 invoked by uid 1000);
        Mon, 28 Feb 2022 02:44:30 -0000
From:   Rob Herring <robh@kernel.org>
To:     Baruch Siach <baruch@tkos.co.il>
Cc:     devicetree@vger.kernel.org,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Andy Gross <agross@kernel.org>,
        Baruch Siach <baruch.siach@siklu.com>,
        Bryan O'Donoghue <bryan.odonoghue@linaro.org>,
        linux-arm-msm@vger.kernel.org,
        Robert Marko <robert.marko@sartura.hr>, netdev@vger.kernel.org
In-Reply-To: <e96e06d3228d9bbd927da32379ba78d5b4b718a7.1645949914.git.baruch@tkos.co.il>
References: <e96e06d3228d9bbd927da32379ba78d5b4b718a7.1645949914.git.baruch@tkos.co.il>
Subject: Re: [PATCH v2 1/2] dt-bindings: net: ipq4019-mdio: Add ipq6018 compatible
Date:   Sun, 27 Feb 2022 20:44:30 -0600
Message-Id: <1646016270.923889.47194.nullmailer@robh.at.kernel.org>
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,
        FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 27 Feb 2022 10:18:33 +0200, Baruch Siach wrote:
> From: Baruch Siach <baruch.siach@siklu.com>
> 
> The IPQ60xx MDIO bus is the same as IPQ4019.
> 
> Change 'enum' to 'items' list to allow fallback to older compatible
> strings.
> 
> Signed-off-by: Baruch Siach <baruch.siach@siklu.com>
> ---
> 
> v2:
> 
>   Update the schema to allow fallback compatible (Rob Herring)
> ---
>  Documentation/devicetree/bindings/net/qcom,ipq4019-mdio.yaml | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 

My bot found errors running 'make DT_CHECKER_FLAGS=-m dt_binding_check'
on your patch (DT_CHECKER_FLAGS is new in v5.13):

yamllint warnings/errors:

dtschema/dtc warnings/errors:
/builds/robherring/linux-dt-review/Documentation/devicetree/bindings/net/qcom,ipq4019-mdio.yaml: properties:compatible:items: 'anyOf' conditional failed, one must be fixed:
	['qcom,ipq4019-mdio', 'qcom,ipq5018-mdio', 'qcom,ipq6018-mdio'] is not of type 'object', 'boolean'
	'qcom,ipq4019-mdio' is not of type 'object', 'boolean'
	'qcom,ipq5018-mdio' is not of type 'object', 'boolean'
	'qcom,ipq6018-mdio' is not of type 'object', 'boolean'
	from schema $id: http://json-schema.org/draft-07/schema#
/builds/robherring/linux-dt-review/Documentation/devicetree/bindings/net/qcom,ipq4019-mdio.yaml: ignoring, error in schema: properties: compatible: items
Documentation/devicetree/bindings/net/qcom,ipq4019-mdio.example.dt.yaml:0:0: /example-0/mdio@90000: failed to match any schema with compatible: ['qcom,ipq4019-mdio']

doc reference errors (make refcheckdocs):

See https://patchwork.ozlabs.org/patch/1598217

This check can fail if there are any dependencies. The base for a patch
series is generally the most recent rc1.

If you already ran 'make dt_binding_check' and didn't see the above
error(s), then make sure 'yamllint' is installed and dt-schema is up to
date:

pip3 install dtschema --upgrade

Please check and re-submit.

