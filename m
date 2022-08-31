Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 217835A8856
	for <lists+netdev@lfdr.de>; Wed, 31 Aug 2022 23:48:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230143AbiHaVsN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Aug 2022 17:48:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229510AbiHaVsM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Aug 2022 17:48:12 -0400
Received: from mail-oa1-f52.google.com (mail-oa1-f52.google.com [209.85.160.52])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4C8BF61AD;
        Wed, 31 Aug 2022 14:48:11 -0700 (PDT)
Received: by mail-oa1-f52.google.com with SMTP id 586e51a60fabf-11f11d932a8so18958878fac.3;
        Wed, 31 Aug 2022 14:48:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=JD82AHGx84kMfXbfehKRODVwT5PdMYhij9FNOZzBHYc=;
        b=U7fymrrzN329Sf5bfjRw9duInxROWaO4+CJHSU+cSx+XyJY75RcmUVpTQ33/7BRZhb
         H0q+ENPjZU0tRkuvFXr4afxNI+b/vzp0XqjRKOxCHRJpMDVLykPE68lhf+Kl9AACUGP8
         4/P23eYzdJwM091bPGL+DuBV0qxw44g1fs9CoPVncaz2WrD4shqOjqwRp3MtQibRMTOM
         X8WHVDrIk+/wqtM0TlxCvsPiyG8SMRFKYQDl8tYjTOiTwvfZ78mT+uqAd6rQhNxnRxjd
         M3dHg8MGBYLmfZjpX2NROKt/W+i+pn0xaLs3OZOD9hZ1CdzA/dutRprY0nUEX5hk5Yyz
         SARw==
X-Gm-Message-State: ACgBeo1Z4ttzgq4zHqrIt99K4Fc8/byYFv0J6+BR/235SrS4HSlILFxZ
        Hs6f4jEQlNxD93m2uXbMJA==
X-Google-Smtp-Source: AA6agR42CMQBtttjZ/zkx4w8wd0niU7A9WHNAhfgLAJFh/npgcOzrKIbttMD5OzwceY42pFmKqe7lw==
X-Received: by 2002:a05:6808:1491:b0:343:7543:1a37 with SMTP id e17-20020a056808149100b0034375431a37mr2191781oiw.106.1661982491138;
        Wed, 31 Aug 2022 14:48:11 -0700 (PDT)
Received: from robh.at.kernel.org (66-90-144-107.dyn.grandenetworks.net. [66.90.144.107])
        by smtp.gmail.com with ESMTPSA id p81-20020acad854000000b00342ded07a75sm7875032oig.18.2022.08.31.14.48.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 31 Aug 2022 14:48:10 -0700 (PDT)
Received: (nullmailer pid 310004 invoked by uid 1000);
        Wed, 31 Aug 2022 21:48:09 -0000
Date:   Wed, 31 Aug 2022 16:48:09 -0500
From:   Rob Herring <robh@kernel.org>
To:     Michael Walle <michael@walle.cc>
Cc:     Miquel Raynal <miquel.raynal@bootlin.com>,
        Richard Weinberger <richard@nod.at>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Shawn Guo <shawnguo@kernel.org>, Li Yang <leoyang.li@nxp.com>,
        =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <rafal@milecki.pl>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Frank Rowand <frowand.list@gmail.com>,
        linux-mtd@lists.infradead.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        netdev@vger.kernel.org, Ahmad Fatoum <a.fatoum@pengutronix.de>
Subject: Re: [PATCH v1 08/14] dt-bindings: mtd: relax the nvmem compatible
 string
Message-ID: <20220831214809.GA282739-robh@kernel.org>
References: <20220825214423.903672-1-michael@walle.cc>
 <20220825214423.903672-9-michael@walle.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220825214423.903672-9-michael@walle.cc>
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

On Thu, Aug 25, 2022 at 11:44:17PM +0200, Michael Walle wrote:
> The "user-otp" and "factory-otp" compatible string just depicts a
> generic NVMEM device. But an actual device tree node might as well
> contain a more specific compatible string. Make it possible to add
> more specific binding elsewere and just match part of the compatibles
> here.
> 
> Signed-off-by: Michael Walle <michael@walle.cc>
> ---
>  Documentation/devicetree/bindings/mtd/mtd.yaml | 7 ++++---
>  1 file changed, 4 insertions(+), 3 deletions(-)

In hindsight it looks like we are mixing 2 different purposes of 'which 
instance is this' and 'what is this'. 'compatible' is supposed to be the 
latter.

Maybe there's a better way to handle user/factory? There's a similar 
need with partitions for A/B or factory/update.

Rob
