Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CB4576985B9
	for <lists+netdev@lfdr.de>; Wed, 15 Feb 2023 21:39:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229615AbjBOUjn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Feb 2023 15:39:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229462AbjBOUjm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Feb 2023 15:39:42 -0500
Received: from mail-oi1-f180.google.com (mail-oi1-f180.google.com [209.85.167.180])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1DEA135AC;
        Wed, 15 Feb 2023 12:39:36 -0800 (PST)
Received: by mail-oi1-f180.google.com with SMTP id s4so696809oiw.9;
        Wed, 15 Feb 2023 12:39:36 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HzK5I1pNsEideIKIsH0oUfCStwuiZkZL1s6hJYppcDU=;
        b=HtJlL9QrK7kcrw62Nyjctsy3exR4Mie+b2O3A6ogCPWrAAk6c6pZobMq8byTuy9PRR
         NQFkOT72AVvaLEsQZetsc/T4d6u7fV6QAxMpxN9XgEKt/n3d1cXvdZ1quAU+8Vho9HIL
         9ta+caDQjRMNGpuPXunprIVFVf26RSiu9Tl+d3fLdeQl9hLofPlptDlw4M+84ouhl82s
         umlAE0UPkSuDZE5/sRpNEkHs+YfeoxiGCTaXfF1YZyi7Lm7vaT+G0ZZB86rU0nQPBQKX
         g2dR8Y0Z8XrSUat+Qp37DLV9epBKfLBrJ0KRwCu4H0cU7jwyaKacKbi3IJtjaKdp6NOh
         NVyw==
X-Gm-Message-State: AO0yUKVnHDss8xLrVlNuZJp2IMfGH2NMJcA2NBgGIJeDooUgowXnRwyP
        +ykJ+Rq7+Ms7fGZbOv9Tyun72QeTZg==
X-Google-Smtp-Source: AK7set8JGewk7qhxhDolu1AIuSeGTxio2AJMsUYS+A8/PyJbFDXDhFOcAygr16obLyL+w8kSVqR+TQ==
X-Received: by 2002:a05:6808:5d0:b0:378:3ae7:f746 with SMTP id d16-20020a05680805d000b003783ae7f746mr1428467oij.47.1676493575389;
        Wed, 15 Feb 2023 12:39:35 -0800 (PST)
Received: from robh_at_kernel.org (66-90-144-107.dyn.grandenetworks.net. [66.90.144.107])
        by smtp.gmail.com with ESMTPSA id s16-20020a056808209000b0037d74967ef6sm5497922oiw.44.2023.02.15.12.39.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Feb 2023 12:39:35 -0800 (PST)
Received: (nullmailer pid 517622 invoked by uid 1000);
        Wed, 15 Feb 2023 20:39:33 -0000
Date:   Wed, 15 Feb 2023 14:39:33 -0600
From:   Rob Herring <robh@kernel.org>
To:     Daniel Golle <daniel@makrotopia.org>
Cc:     Rob Herring <robh+dt@kernel.org>,
        =?UTF-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Felix Fietkau <nbd@nbd.name>,
        Florian Fainelli <f.fainelli@gmail.com>,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>,
        John Crispin <john@phrozen.org>, Andrew Lunn <andrew@lunn.ch>,
        Jianhui Zhao <zhaojh329@gmail.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Landen Chao <Landen.Chao@mediatek.com>,
        "David S. Miller" <davem@davemloft.net>,
        DENG Qingfang <dqfext@gmail.com>, netdev@vger.kernel.org,
        Heiner Kallweit <hkallweit1@gmail.com>,
        devicetree@vger.kernel.org, Vladimir Oltean <olteanv@gmail.com>,
        linux-kernel@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>,
        linux-arm-kernel@lists.infradead.org,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        linux-mediatek@lists.infradead.org,
        Sean Wang <sean.wang@mediatek.com>
Subject: Re: [PATCH v6 02/12] dt-bindings: net: mediatek,net: add mt7981-eth
 binding
Message-ID: <167649357343.517569.9770950931766718368.robh@kernel.org>
References: <cover.1676323692.git.daniel@makrotopia.org>
 <f94af4b4a0519530b5a87989ef08f9f85a385920.1676323692.git.daniel@makrotopia.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f94af4b4a0519530b5a87989ef08f9f85a385920.1676323692.git.daniel@makrotopia.org>
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,
        FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On Mon, 13 Feb 2023 21:34:25 +0000, Daniel Golle wrote:
> Introduce DT bindings for the MT7981 SoC to mediatek,net.yaml.
> 
> Signed-off-by: Daniel Golle <daniel@makrotopia.org>
> ---
>  .../devicetree/bindings/net/mediatek,net.yaml | 52 +++++++++++++++++--
>  1 file changed, 47 insertions(+), 5 deletions(-)
> 

Reviewed-by: Rob Herring <robh@kernel.org>

