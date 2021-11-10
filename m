Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0829A44C943
	for <lists+netdev@lfdr.de>; Wed, 10 Nov 2021 20:44:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233192AbhKJTrY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Nov 2021 14:47:24 -0500
Received: from mail-oi1-f174.google.com ([209.85.167.174]:42957 "EHLO
        mail-oi1-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233340AbhKJTrK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Nov 2021 14:47:10 -0500
Received: by mail-oi1-f174.google.com with SMTP id n66so7242861oia.9;
        Wed, 10 Nov 2021 11:44:23 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:in-reply-to:references:subject:date
         :message-id;
        bh=likDWmDbN5o7SnT6cQ2yzO1g3PQ+qTt1FP1WspXaXGk=;
        b=jGpQ36p4/NttbHoLZOMFe/fOUiweQhTOmy7ybWgMfjclXRUgVKrFoUAq/f0m+2flPn
         d2SqPq/UsYruYfgGhuW9espy2xPJi2aYC8Ckg4Cmh2XnXUY2ShWOB1olkM4v5NzmiDnx
         dA/fO0wR4fXe4oDoqFFUBbvikqkPcSP/QW4RIUC+hpwqv/6oeS7bc80/DaeKD0hGyrPr
         8YMQgae85+0bZkcCq7nKtC7NIkjgPsnca7G0Od5B5LbrxYrYHTk+t0IzIAIg+pRANCao
         9P2lLaInW7B7B+eXh8F7COG5TClE/uI4eAiJdx8H6+XJqa2pAsmljG62BjUGbjzxz30e
         Hr3Q==
X-Gm-Message-State: AOAM530IqbSLFccHUCdvpUBpg9VgBjhY53cdwxAheOulNwIEWC7Kr0ZP
        Ra4bUbTZGUksiYQTicxn6w==
X-Google-Smtp-Source: ABdhPJwlYFTqlf/pRDAF7GOesoK3aqCR/9qaTWoFXcVxyzNBSZ+QDPSjYJOp7qkgxie7eyK+wcyhhg==
X-Received: by 2002:aca:be54:: with SMTP id o81mr14764752oif.64.1636573462569;
        Wed, 10 Nov 2021 11:44:22 -0800 (PST)
Received: from robh.at.kernel.org (66-90-148-213.dyn.grandenetworks.net. [66.90.148.213])
        by smtp.gmail.com with ESMTPSA id 3sm162484otl.60.2021.11.10.11.44.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Nov 2021 11:44:22 -0800 (PST)
Received: (nullmailer pid 1783736 invoked by uid 1000);
        Wed, 10 Nov 2021 19:44:20 -0000
From:   Rob Herring <robh@kernel.org>
To:     Biao Huang <biao.huang@mediatek.com>
Cc:     davem@davemloft.net, Jose Abreu <joabreu@synopsys.com>,
        srv_heupstream@mediatek.com, linux-mediatek@lists.infradead.org,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        macpaul.lin@mediatek.com, Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>
In-Reply-To: <20211110083948.6082-5-biao.huang@mediatek.com>
References: <20211110083948.6082-1-biao.huang@mediatek.com> <20211110083948.6082-5-biao.huang@mediatek.com>
Subject: Re: [PATCH 4/5] dt-bindings: net: dwmac: Convert mediatek-dwmac to DT schema
Date:   Wed, 10 Nov 2021 13:44:20 -0600
Message-Id: <1636573460.872424.1783735.nullmailer@robh.at.kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 10 Nov 2021 16:39:47 +0800, Biao Huang wrote:
> Convert mediatek-dwmac to DT schema, and delete old mediatek-dwmac.txt.
> 
> Signed-off-by: Biao Huang <biao.huang@mediatek.com>
> ---
>  .../bindings/net/mediatek-dwmac.txt           |  91 ---------
>  .../bindings/net/mediatek-dwmac.yaml          | 179 ++++++++++++++++++
>  2 files changed, 179 insertions(+), 91 deletions(-)
>  delete mode 100644 Documentation/devicetree/bindings/net/mediatek-dwmac.txt
>  create mode 100644 Documentation/devicetree/bindings/net/mediatek-dwmac.yaml
> 

My bot found errors running 'make DT_CHECKER_FLAGS=-m dt_binding_check'
on your patch (DT_CHECKER_FLAGS is new in v5.13):

yamllint warnings/errors:

dtschema/dtc warnings/errors:
/builds/robherring/linux-dt-review/Documentation/devicetree/bindings/net/mediatek-dwmac.yaml: properties:mediatek,tx-delay-ps: '$ref' should not be valid under {'const': '$ref'}
	hint: Standard unit suffix properties don't need a type $ref
	from schema $id: http://devicetree.org/meta-schemas/core.yaml#
/builds/robherring/linux-dt-review/Documentation/devicetree/bindings/net/mediatek-dwmac.yaml: properties:mediatek,rx-delay-ps: '$ref' should not be valid under {'const': '$ref'}
	hint: Standard unit suffix properties don't need a type $ref
	from schema $id: http://devicetree.org/meta-schemas/core.yaml#
/builds/robherring/linux-dt-review/Documentation/devicetree/bindings/net/mediatek-dwmac.yaml: properties:clocks: {'minItems': 5, 'maxItems': 6, 'items': [{'description': 'AXI clock'}, {'description': 'APB clock'}, {'description': 'MAC clock gate'}, {'description': 'MAC Main clock'}, {'description': 'PTP clock'}, {'description': 'RMII reference clock provided by MAC'}]} should not be valid under {'required': ['maxItems']}
	hint: "maxItems" is not needed with an "items" list
	from schema $id: http://devicetree.org/meta-schemas/items.yaml#
/builds/robherring/linux-dt-review/Documentation/devicetree/bindings/net/mediatek-dwmac.yaml: ignoring, error in schema: properties: mediatek,tx-delay-ps
warning: no schema found in file: ./Documentation/devicetree/bindings/net/mediatek-dwmac.yaml
Documentation/devicetree/bindings/net/mediatek-dwmac.example.dt.yaml:0:0: /example-0/ethernet@1101c000: failed to match any schema with compatible: ['mediatek,mt2712-gmac', 'snps,dwmac-4.20a']

doc reference errors (make refcheckdocs):

See https://patchwork.ozlabs.org/patch/1553304

This check can fail if there are any dependencies. The base for a patch
series is generally the most recent rc1.

If you already ran 'make dt_binding_check' and didn't see the above
error(s), then make sure 'yamllint' is installed and dt-schema is up to
date:

pip3 install dtschema --upgrade

Please check and re-submit.

