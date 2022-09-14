Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D745A5B8B60
	for <lists+netdev@lfdr.de>; Wed, 14 Sep 2022 17:09:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230164AbiINPHV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Sep 2022 11:07:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230146AbiINPHR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Sep 2022 11:07:17 -0400
Received: from mail-oa1-f43.google.com (mail-oa1-f43.google.com [209.85.160.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE46F760CE;
        Wed, 14 Sep 2022 08:07:15 -0700 (PDT)
Received: by mail-oa1-f43.google.com with SMTP id 586e51a60fabf-1280590722dso41807304fac.1;
        Wed, 14 Sep 2022 08:07:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date;
        bh=tW80ioERjs8HL0K2G02PeQt4G+hoDIT7HdwegIsyDlg=;
        b=zOpB5Mse1YwzCgbJy/ROyVk7ywv9n9XPczZr/9baLxu9WbyLHDhPDsKpbJHXeJ1uOa
         MYDm9Svfn+hP+tHABJTrYB4p+FRIFWsnKBi/PFGN6So2Os+LZa52kJeIUKxpZz9opxCT
         Ggj2TGubdWb6aFBaTJ3F2MBQVTCuNc+mwoGLiMnnoeb+7e+fO1AtlxCbV/284CimCDtg
         63tv2vpGdyCP7svsmKhC0BcNr9udBsB+ut0TOpNnfMgh+IoKC7U/v4NUSoqt1pPHKbhe
         DGh/QBdcnm1JKC2dcHbDMZM+2MxEFBUctvV4DVhuWFac/WmNU7OQsN5wPO0yXvXJuCHU
         G44g==
X-Gm-Message-State: ACgBeo1fW8QUxaMaY6nx9EdrlLguv2CGaVe4G9U45755R1AkU8H546gd
        sQ1/+QDcSWDAQsEH+2l/iA==
X-Google-Smtp-Source: AA6agR6nHjlVpJ4ODROLhE1cOSEVGf/++cY8d55HrUHcYhHLiNPEEebU50Ldgv8bEVLNMWBj0bV6cA==
X-Received: by 2002:a05:6808:120f:b0:349:f62:5c04 with SMTP id a15-20020a056808120f00b003490f625c04mr2143683oil.100.1663168034307;
        Wed, 14 Sep 2022 08:07:14 -0700 (PDT)
Received: from robh.at.kernel.org (66-90-144-107.dyn.grandenetworks.net. [66.90.144.107])
        by smtp.gmail.com with ESMTPSA id u22-20020a056871009600b0012b342d1125sm7789250oaa.13.2022.09.14.08.07.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Sep 2022 08:07:13 -0700 (PDT)
Received: (nullmailer pid 2227891 invoked by uid 1000);
        Wed, 14 Sep 2022 15:07:12 -0000
Date:   Wed, 14 Sep 2022 10:07:12 -0500
From:   Rob Herring <robh@kernel.org>
To:     =?utf-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Sungbo Eo <mans0n@gorani.run>,
        Eric Dumazet <edumazet@google.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Sergio Paracuellos <sergio.paracuellos@gmail.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        linux-mips@vger.kernel.org, devicetree@vger.kernel.org,
        netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        linux-kernel@vger.kernel.org, DENG Qingfang <dqfext@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>, erkin.bozoglu@xeront.com,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        linux-arm-kernel@lists.infradead.org,
        Florian Fainelli <f.fainelli@gmail.com>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Rob Herring <robh+dt@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Sean Wang <sean.wang@mediatek.com>,
        linux-mediatek@lists.infradead.org
Subject: Re: [PATCH 02/10] dt-bindings: net: dsa: mediatek,mt7530: change
 mt7530 switch address
Message-ID: <20220914150712.GA2227774-robh@kernel.org>
References: <20220914085451.11723-1-arinc.unal@arinc9.com>
 <20220914085451.11723-3-arinc.unal@arinc9.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220914085451.11723-3-arinc.unal@arinc9.com>
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

On Wed, 14 Sep 2022 11:54:43 +0300, Arınç ÜNAL wrote:
> In the case of muxing phy0 of the MT7530 switch, the switch and the phy
> will have the same address on the mdio bus, 0. This causes the ethernet
> driver to fail since devices on the mdio bus cannot share an address.
> 
> Any address can be used for the switch, therefore, change the switch
> address to 0x1f.
> 
> Suggested-by: Sungbo Eo <mans0n@gorani.run>
> Signed-off-by: Arınç ÜNAL <arinc.unal@arinc9.com>
> ---
>  .../bindings/net/dsa/mediatek,mt7530.yaml     | 24 +++++++++----------
>  1 file changed, 12 insertions(+), 12 deletions(-)
> 

Acked-by: Rob Herring <robh@kernel.org>
