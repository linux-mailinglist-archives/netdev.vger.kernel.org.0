Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C7C564815D5
	for <lists+netdev@lfdr.de>; Wed, 29 Dec 2021 18:35:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241117AbhL2RfB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Dec 2021 12:35:01 -0500
Received: from mail-vk1-f169.google.com ([209.85.221.169]:35405 "EHLO
        mail-vk1-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237592AbhL2RfB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Dec 2021 12:35:01 -0500
Received: by mail-vk1-f169.google.com with SMTP id c10so12181809vkn.2;
        Wed, 29 Dec 2021 09:35:00 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:in-reply-to:references:subject:date
         :message-id;
        bh=aUHpp8EvSHkbTSOpO7EAhwgN47lj/B2NCRjAH8ogVNY=;
        b=j2VAyX90SahRtzu7se71HL81ofR90BObMQATOGYTCRTbQeI8MHBQB4hlCtx6sG2rvP
         4K5/zBZBRne54/yXkpBT5zs+eIy+TwIRR/6SoPXiVa8SS5fXuEJIcumhIpY2GFXqClYM
         o95NLCZ0Ey4qdykwO1i9XfDLdtxtzrQRVIVsZERAF0WyyflJPvmUn4nMLkMYAyKd2nCn
         Vu9JN96NbtFXbT3ddKBXEZgraYaVtrzZA/Ma4M+t4bD9NDl3F6GtQx0UsOzp07pO1F4g
         c0sd/sMO35Snaf5sHxgVvlOCKxTPu71HO9Ft9itDL85FHiXOdm8/A7CosSkR0GnGiwhb
         ecMw==
X-Gm-Message-State: AOAM532ClB9fdV3vut6v6JQcOc+jPyF6978iVfkA9RrihGCBEX1XFBmr
        HQaHXGKwx0SEIeXeRj8Enw==
X-Google-Smtp-Source: ABdhPJyOF0vl8XP8OvBBTML/uKoHyRuxtjN0Rnlem0Y5Od2GAtuBNGgE57jGrVSn7Nm5hRfh5D2x1w==
X-Received: by 2002:a05:6122:91e:: with SMTP id j30mr9169182vka.20.1640799299996;
        Wed, 29 Dec 2021 09:34:59 -0800 (PST)
Received: from robh.at.kernel.org ([209.91.231.198])
        by smtp.gmail.com with ESMTPSA id m62sm1805207uam.0.2021.12.29.09.34.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Dec 2021 09:34:59 -0800 (PST)
Received: (nullmailer pid 824017 invoked by uid 1000);
        Wed, 29 Dec 2021 17:34:56 -0000
From:   Rob Herring <robh@kernel.org>
To:     Michael Walle <michael@walle.cc>
Cc:     Miquel Raynal <miquel.raynal@bootlin.com>, netdev@vger.kernel.org,
        Richard Weinberger <richard@nod.at>,
        linux-mtd@lists.infradead.org,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, devicetree@vger.kernel.org,
        Frank Rowand <frowand.list@gmail.com>,
        Shawn Guo <shawnguo@kernel.org>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        linux-kernel@vger.kernel.org, Rob Herring <robh+dt@kernel.org>,
        linux-arm-kernel@lists.infradead.org, Li Yang <leoyang.li@nxp.com>,
        Ansuel Smith <ansuelsmth@gmail.com>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Andrew Lunn <andrew@lunn.ch>
In-Reply-To: <20211228142549.1275412-3-michael@walle.cc>
References: <20211228142549.1275412-1-michael@walle.cc> <20211228142549.1275412-3-michael@walle.cc>
Subject: Re: [PATCH 2/8] dt-bindings: nvmem: add transformation bindings
Date:   Wed, 29 Dec 2021 13:34:56 -0400
Message-Id: <1640799296.468454.824016.nullmailer@robh.at.kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 28 Dec 2021 15:25:43 +0100, Michael Walle wrote:
> Just add a simple list of the supported devices which need a nvmem
> transformations.
> 
> Also, since the compatible string is prepended to the actual nvmem
> compatible string, we need to match using "contains" instead of an exact
> match.
> 
> Signed-off-by: Michael Walle <michael@walle.cc>
> ---
>  .../devicetree/bindings/mtd/mtd.yaml          |  7 +--
>  .../bindings/nvmem/nvmem-transformations.yaml | 46 +++++++++++++++++++
>  2 files changed, 50 insertions(+), 3 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/nvmem/nvmem-transformations.yaml
> 

My bot found errors running 'make DT_CHECKER_FLAGS=-m dt_binding_check'
on your patch (DT_CHECKER_FLAGS is new in v5.13):

yamllint warnings/errors:
./Documentation/devicetree/bindings/nvmem/nvmem-transformations.yaml:19:9: [warning] wrong indentation: expected 10 but found 8 (indentation)
./Documentation/devicetree/bindings/nvmem/nvmem-transformations.yaml:20:11: [warning] wrong indentation: expected 12 but found 10 (indentation)

dtschema/dtc warnings/errors:

doc reference errors (make refcheckdocs):

See https://patchwork.ozlabs.org/patch/1573687

This check can fail if there are any dependencies. The base for a patch
series is generally the most recent rc1.

If you already ran 'make dt_binding_check' and didn't see the above
error(s), then make sure 'yamllint' is installed and dt-schema is up to
date:

pip3 install dtschema --upgrade

Please check and re-submit.

