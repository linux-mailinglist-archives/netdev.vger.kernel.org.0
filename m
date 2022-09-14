Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 503555B8B67
	for <lists+netdev@lfdr.de>; Wed, 14 Sep 2022 17:09:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230146AbiINPIy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Sep 2022 11:08:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229603AbiINPI2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Sep 2022 11:08:28 -0400
Received: from mail-oa1-f41.google.com (mail-oa1-f41.google.com [209.85.160.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72A8B77EB8;
        Wed, 14 Sep 2022 08:08:23 -0700 (PDT)
Received: by mail-oa1-f41.google.com with SMTP id 586e51a60fabf-1274ec87ad5so41859372fac.0;
        Wed, 14 Sep 2022 08:08:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date;
        bh=WsCqlhcAYszwylafTVn3AQU14ABBFNYiw25xksQ//Tw=;
        b=u25XRZFIS9Yl9dr52Y2dHoipUsp74tkZsfCunhQpV/YQOEXIoajIZs6gZXqFHv6W1t
         8Rj4vBNYrL+FBapxnF9Tllr8QwYM141jcZqPtfGT9akDy34VBRImfJ18s/vxObcDFWzb
         W2sMmX0nRqLqVPDHh8Jmk/CWZQG4GcxWJcXQNWjYP4my69Mx7PS08dLhgcQ5dxcrKssy
         dK8wVwb9sQ0Xi4CCI7e7ilt0VkCbK7s8eI7FoRiFSOoNIlmgLRkM/4354bFutjRsKgPl
         gZ7EpP+etvfdQ1DNuRwWrdA0bnbj8yCQvBZQCPuZgCTj7Is4gaHC3DoUzZORaQUosez6
         e/5w==
X-Gm-Message-State: ACgBeo12JeRx58dxfAu5jLuMeZFilnmN5AUx8UliUNO9UVqlZqEGkxD9
        Mi46g9FlrVtNcaHbPQC7bQ==
X-Google-Smtp-Source: AA6agR4kABtEsUG4U3/uBVd8jycn/uZuDvvgX1kd+YNFBGMNnvsFazZEHBl1ANF49t/a2LRWJdwUkw==
X-Received: by 2002:a05:6870:524f:b0:126:7220:c90b with SMTP id o15-20020a056870524f00b001267220c90bmr2653054oai.21.1663168102573;
        Wed, 14 Sep 2022 08:08:22 -0700 (PDT)
Received: from robh.at.kernel.org (66-90-144-107.dyn.grandenetworks.net. [66.90.144.107])
        by smtp.gmail.com with ESMTPSA id c10-20020a4ab18a000000b00432ac97ad09sm6561797ooo.26.2022.09.14.08.08.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Sep 2022 08:08:21 -0700 (PDT)
Received: (nullmailer pid 2233439 invoked by uid 1000);
        Wed, 14 Sep 2022 15:08:20 -0000
Date:   Wed, 14 Sep 2022 10:08:20 -0500
From:   Rob Herring <robh@kernel.org>
To:     =?utf-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>
Cc:     Paolo Abeni <pabeni@redhat.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "David S . Miller" <davem@davemloft.net>,
        linux-mediatek@lists.infradead.org,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        linux-mips@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, Andrew Lunn <andrew@lunn.ch>,
        Sergio Paracuellos <sergio.paracuellos@gmail.com>,
        erkin.bozoglu@xeront.com, Eric Dumazet <edumazet@google.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        devicetree@vger.kernel.org, Landen Chao <Landen.Chao@mediatek.com>
Subject: Re: [PATCH 03/10] dt-bindings: net: dsa: mediatek,mt7530: expand
 gpio-controller description
Message-ID: <20220914150820.GA2233308-robh@kernel.org>
References: <20220914085451.11723-1-arinc.unal@arinc9.com>
 <20220914085451.11723-4-arinc.unal@arinc9.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220914085451.11723-4-arinc.unal@arinc9.com>
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

On Wed, 14 Sep 2022 11:54:44 +0300, Arınç ÜNAL wrote:
> Expand the description of the gpio-controller property to include the
> controllable pins of the MT7530 switch.
> 
> The gpio-controller property is only used for the MT7530 switch. Therefore,
> invalidate it for the MT7531 switch.
> 
> Signed-off-by: Arınç ÜNAL <arinc.unal@arinc9.com>
> ---
>  .../devicetree/bindings/net/dsa/mediatek,mt7530.yaml   | 10 +++++++++-
>  1 file changed, 9 insertions(+), 1 deletion(-)
> 

Acked-by: Rob Herring <robh@kernel.org>
