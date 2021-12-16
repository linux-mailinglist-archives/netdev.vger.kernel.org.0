Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 424C84773A2
	for <lists+netdev@lfdr.de>; Thu, 16 Dec 2021 14:53:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236932AbhLPNxG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Dec 2021 08:53:06 -0500
Received: from mail-ot1-f44.google.com ([209.85.210.44]:35571 "EHLO
        mail-ot1-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229453AbhLPNxF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Dec 2021 08:53:05 -0500
Received: by mail-ot1-f44.google.com with SMTP id x43-20020a056830246b00b00570d09d34ebso29057388otr.2;
        Thu, 16 Dec 2021 05:53:05 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:in-reply-to:references:subject:date
         :message-id;
        bh=K3q3sT5gz9V74YhNPyceV1V6wk4tRvJfYiaAGVR5wDk=;
        b=IMA8mkxAucS94FUq4f/axGDQZ3HcUffRXG4DdymJUGQc6dKKPCuBUhTIEkdXWdjEkP
         4k3G3yqLPyJmbBObIXL5OdH4e5gfU+Z1rceqYgzRJFnJlgwCzzFhvA79mEE51PSlMz6Q
         ucoY4SUNLtq42LPXqmduJAZ74l/Ty3J7YeDtTxOjgH4HUdmX4h1YC7+Me1hAhV/92rLu
         iMJvVWQTeFx4A1Mkc7dWHDfL2vdCba+Lk8muQcZaePzPZ3lV0V6x4PGbhAOYdWAvoJ/C
         OmBi6dzaGDXz81BcFBqWGuGT/wBfS+3tL2pCYibh36MLL1WS0bm9qsrial0E7Buq0lzA
         4E/g==
X-Gm-Message-State: AOAM531UDfHb4QRmc1kxntU8DpPYSac7Sr9O9pukGjCfH3rkRolDNEzY
        EVfKFGWsxbnD7TWBPuD42GRn8KbOzA==
X-Google-Smtp-Source: ABdhPJwzi2LUj+RCSn0XStSyJDnnJAJ+K5H1xEp0vB1nUSgaPfqCMGLhpagEgc0ZOqdMMiDluU4UEg==
X-Received: by 2002:a9d:461:: with SMTP id 88mr13058565otc.300.1639662785099;
        Thu, 16 Dec 2021 05:53:05 -0800 (PST)
Received: from robh.at.kernel.org (66-90-148-213.dyn.grandenetworks.net. [66.90.148.213])
        by smtp.gmail.com with ESMTPSA id 52sm381367oth.52.2021.12.16.05.53.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Dec 2021 05:53:04 -0800 (PST)
Received: (nullmailer pid 4004876 invoked by uid 1000);
        Thu, 16 Dec 2021 13:53:02 -0000
From:   Rob Herring <robh@kernel.org>
To:     Biao Huang <biao.huang@mediatek.com>
Cc:     srv_heupstream@mediatek.com, linux-arm-kernel@lists.infradead.org,
        davem@davemloft.net, linux-stm32@st-md-mailman.stormreply.com,
        angelogioacchino.delregno@collabora.com,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        linux-mediatek@lists.infradead.org,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Jose Abreu <joabreu@synopsys.com>, netdev@vger.kernel.org,
        dkirjanov@suse.de, linux-kernel@vger.kernel.org,
        macpaul.lin@mediatek.com,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        devicetree@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>
In-Reply-To: <20211216055328.15953-7-biao.huang@mediatek.com>
References: <20211216055328.15953-1-biao.huang@mediatek.com> <20211216055328.15953-7-biao.huang@mediatek.com>
Subject: Re: [PATCH net-next v10 6/6] net: dt-bindings: dwmac: add support for mt8195
Date:   Thu, 16 Dec 2021 07:53:02 -0600
Message-Id: <1639662782.987227.4004875.nullmailer@robh.at.kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 16 Dec 2021 13:53:28 +0800, Biao Huang wrote:
> Add binding document for the ethernet on mt8195.
> 
> Signed-off-by: Biao Huang <biao.huang@mediatek.com>
> ---
>  .../bindings/net/mediatek-dwmac.yaml          | 29 ++++++++++++++++---
>  1 file changed, 25 insertions(+), 4 deletions(-)
> 

My bot found errors running 'make DT_CHECKER_FLAGS=-m dt_binding_check'
on your patch (DT_CHECKER_FLAGS is new in v5.13):

yamllint warnings/errors:

dtschema/dtc warnings/errors:
/builds/robherring/linux-dt-review/Documentation/devicetree/bindings/net/mediatek-dwmac.yaml: properties:clock-names: {'minItems': 5, 'maxItems': 6, 'items': [{'const': 'axi'}, {'const': 'apb'}, {'const': 'mac_main'}, {'const': 'ptp_ref'}, {'const': 'rmii_internal'}, {'const': 'mac_cg'}]} should not be valid under {'required': ['maxItems']}
	hint: "maxItems" is not needed with an "items" list
	from schema $id: http://devicetree.org/meta-schemas/items.yaml#
/builds/robherring/linux-dt-review/Documentation/devicetree/bindings/net/mediatek-dwmac.yaml: ignoring, error in schema: properties: clock-names
warning: no schema found in file: ./Documentation/devicetree/bindings/net/mediatek-dwmac.yaml
Documentation/devicetree/bindings/net/mediatek-dwmac.example.dt.yaml:0:0: /example-0/ethernet@1101c000: failed to match any schema with compatible: ['mediatek,mt2712-gmac', 'snps,dwmac-4.20a']

doc reference errors (make refcheckdocs):

See https://patchwork.ozlabs.org/patch/1568902

This check can fail if there are any dependencies. The base for a patch
series is generally the most recent rc1.

If you already ran 'make dt_binding_check' and didn't see the above
error(s), then make sure 'yamllint' is installed and dt-schema is up to
date:

pip3 install dtschema --upgrade

Please check and re-submit.

