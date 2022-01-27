Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B3E649E413
	for <lists+netdev@lfdr.de>; Thu, 27 Jan 2022 15:03:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237342AbiA0ODL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jan 2022 09:03:11 -0500
Received: from mail-oi1-f169.google.com ([209.85.167.169]:42686 "EHLO
        mail-oi1-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234049AbiA0ODI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jan 2022 09:03:08 -0500
Received: by mail-oi1-f169.google.com with SMTP id v67so5985088oie.9;
        Thu, 27 Jan 2022 06:03:08 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:in-reply-to:references:subject:date
         :message-id;
        bh=5tJ7fem3em4tFzd0KzWRxEgHSNls1XyM25Knzpl5oYI=;
        b=fGIjpu4Bf89RCdp1N/ZGBXqMuZEjZzzUl/XJ5n76w3G+ZRCxcDqdud1snQu8htR2BE
         z8utCkG2Q8QaAYlZBNc7cBLohXx6LnZvDxKVNMyglqcp4NHrr9MDllqLVESTe6yW7kmj
         puuLuXMAg9inIZ7r7GWA0Z5E90J//D/sC/pbC2OwEpl3ThcPekKGsVPY7KQg0Lx0D79N
         XPDB12/Qq3HOHXnIsy/KRrtOQx7o3IsjiG52sUS/+c3M/+K3iLE63fxYc7XYrnTh137V
         v7YSECn1Qiy06fbKtW2PzEz8iM2IeMnsuRKF7BdNE1AAsUq3x3YatqpKh+p4q2ZjHdM/
         Whbg==
X-Gm-Message-State: AOAM53109szCJkWlmNNn3KAM+cVQY+pTrQAxebVn9BG1wyXhlBOfs68+
        MAI9iY8Dw7um+eRFAJWEIQ==
X-Google-Smtp-Source: ABdhPJzAYKYVqVv4q47AEw3MKa8RQm9DLHzNhgd8sifQ+jDvwjNarIbwspmijsWI1Nzg/NOVZ687XQ==
X-Received: by 2002:a05:6808:f0a:: with SMTP id m10mr2297639oiw.65.1643292187754;
        Thu, 27 Jan 2022 06:03:07 -0800 (PST)
Received: from robh.at.kernel.org (66-90-148-213.dyn.grandenetworks.net. [66.90.148.213])
        by smtp.gmail.com with ESMTPSA id 6sm10591555oig.29.2022.01.27.06.03.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Jan 2022 06:03:06 -0800 (PST)
Received: (nullmailer pid 3149358 invoked by uid 1000);
        Thu, 27 Jan 2022 14:03:05 -0000
From:   Rob Herring <robh@kernel.org>
To:     Corentin Labbe <clabbe@baylibre.com>
Cc:     davem@davemloft.net, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, kuba@kernel.org, robh+dt@kernel.org,
        linus.walleij@linaro.org, devicetree@vger.kernel.org,
        ulli.kroll@googlemail.com, netdev@vger.kernel.org
In-Reply-To: <20220126211128.3663486-1-clabbe@baylibre.com>
References: <20220126211128.3663486-1-clabbe@baylibre.com>
Subject: Re: [PATCH] dt-bindings: net: convert net/cortina,gemini-ethernet to yaml
Date:   Thu, 27 Jan 2022 08:03:05 -0600
Message-Id: <1643292185.221187.3149357.nullmailer@robh.at.kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 26 Jan 2022 21:11:28 +0000, Corentin Labbe wrote:
> Converts net/cortina,gemini-ethernet.txt to yaml
> This permits to detect some missing properties like interrupts
> 
> Signed-off-by: Corentin Labbe <clabbe@baylibre.com>
> ---
>  .../bindings/net/cortina,gemini-ethernet.txt  |  92 ------------
>  .../bindings/net/cortina,gemini-ethernet.yaml | 138 ++++++++++++++++++
>  2 files changed, 138 insertions(+), 92 deletions(-)
>  delete mode 100644 Documentation/devicetree/bindings/net/cortina,gemini-ethernet.txt
>  create mode 100644 Documentation/devicetree/bindings/net/cortina,gemini-ethernet.yaml
> 

My bot found errors running 'make DT_CHECKER_FLAGS=-m dt_binding_check'
on your patch (DT_CHECKER_FLAGS is new in v5.13):

yamllint warnings/errors:

dtschema/dtc warnings/errors:
/builds/robherring/linux-dt-review/Documentation/devicetree/bindings/net/cortina,gemini-ethernet.yaml: patternProperties:^ethernet-port@[0-9]+$:properties:reg: 'oneOf' conditional failed, one must be fixed:
	[{'description': 'DMA/TOE memory'}, {'description': 'GMAC memory area of the port'}] is too long
	[{'description': 'DMA/TOE memory'}, {'description': 'GMAC memory area of the port'}] is too short
	False schema does not allow 2
	1 was expected
	hint: "minItems" is only needed if less than the "items" list length
	from schema $id: http://devicetree.org/meta-schemas/items.yaml#
/builds/robherring/linux-dt-review/Documentation/devicetree/bindings/net/cortina,gemini-ethernet.yaml: ignoring, error in schema: patternProperties: ^ethernet-port@[0-9]+$: properties: reg
Documentation/devicetree/bindings/net/cortina,gemini-ethernet.example.dt.yaml:0:0: /example-0/ethernet@60000000: failed to match any schema with compatible: ['cortina,gemini-ethernet']
Documentation/devicetree/bindings/net/cortina,gemini-ethernet.example.dt.yaml:0:0: /example-0/ethernet@60000000/ethernet-port@0: failed to match any schema with compatible: ['cortina,gemini-ethernet-port']
Documentation/devicetree/bindings/net/cortina,gemini-ethernet.example.dt.yaml:0:0: /example-0/ethernet@60000000/ethernet-port@1: failed to match any schema with compatible: ['cortina,gemini-ethernet-port']

doc reference errors (make refcheckdocs):
MAINTAINERS: Documentation/devicetree/bindings/net/cortina,gemini-ethernet.txt

See https://patchwork.ozlabs.org/patch/1584680

This check can fail if there are any dependencies. The base for a patch
series is generally the most recent rc1.

If you already ran 'make dt_binding_check' and didn't see the above
error(s), then make sure 'yamllint' is installed and dt-schema is up to
date:

pip3 install dtschema --upgrade

Please check and re-submit.

