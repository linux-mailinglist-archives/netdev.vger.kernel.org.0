Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AC11B5963F8
	for <lists+netdev@lfdr.de>; Tue, 16 Aug 2022 22:49:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237263AbiHPUtR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Aug 2022 16:49:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237097AbiHPUtP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Aug 2022 16:49:15 -0400
Received: from mail-io1-f50.google.com (mail-io1-f50.google.com [209.85.166.50])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 550AD5E67A;
        Tue, 16 Aug 2022 13:49:13 -0700 (PDT)
Received: by mail-io1-f50.google.com with SMTP id b142so6287683iof.10;
        Tue, 16 Aug 2022 13:49:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc;
        bh=Igzpe2dfFh072dG7M9af7EwnEZkHHQlF9Pf46jZtejY=;
        b=PqEGG3q64rKWeyKsEbJNiL3pY5X5LW7lCo1WACA46+Oe5m6JfwodqHOwqvsbtsoYPZ
         JoZ1eU58aEm0crqWqRvxdlYlE3ddcz13NQxDM65t04ESBuHa7XmyDupBejzEB+800hct
         BYYsK+bbxexiW0xU0i6S4BeYoJZjrKnvsCMT4DilH59YzLLbJbwqDfmxofGlnbyf7DXQ
         1n9VcSoBMsmEmPrdDWDONthBL2xq7kW0NyQde3eP7yLCDYVFKm6xrg/bByGKGSXeQ7wi
         iOV7rpiyjXgIPCGjabzbgJPb4cxZ+ZRKXhX6Ahi17VfQci4vEbES4eImgGLL4eEbsVoA
         n6yw==
X-Gm-Message-State: ACgBeo0y0bHH5a5QvS25JVX+WokbLaCQg82dlVJ25haRKOMvcM7+SiIL
        Y0W5Xuy9GMWsPEe1h3MW3w==
X-Google-Smtp-Source: AA6agR4JUMnAxe73i4k/USANa7oT8A2bvPIyHs4SYiN3MfNVQoRaN9YqHKUNH74CBK0dcaCnelKJeg==
X-Received: by 2002:a5d:94d6:0:b0:67c:55f9:f355 with SMTP id y22-20020a5d94d6000000b0067c55f9f355mr9749658ior.133.1660682952543;
        Tue, 16 Aug 2022 13:49:12 -0700 (PDT)
Received: from robh.at.kernel.org ([64.188.179.248])
        by smtp.gmail.com with ESMTPSA id z25-20020a056602081900b00688b30a7812sm1312208iow.42.2022.08.16.13.49.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Aug 2022 13:49:12 -0700 (PDT)
Received: (nullmailer pid 2709183 invoked by uid 1000);
        Tue, 16 Aug 2022 20:49:08 -0000
Date:   Tue, 16 Aug 2022 14:49:08 -0600
From:   Rob Herring <robh@kernel.org>
To:     =?utf-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>
Cc:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Daniel Golle <daniel@makrotopia.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        linux-arm-kernel@lists.infradead.org,
        Rob Herring <robh+dt@kernel.org>,
        Luiz Angelo Daros de Luca <luizluca@gmail.com>,
        linux-kernel@vger.kernel.org,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        =?UTF-8?Q?Ren=C3=A9_van_Dorst?= <opensource@vdorst.com>,
        linux-mediatek@lists.infradead.org, Andrew Lunn <andrew@lunn.ch>,
        Vladimir Oltean <olteanv@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Sander Vanheule <sander@svanheule.net>,
        Frank Wunderlich <frank-w@public-files.de>,
        Sean Wang <sean.wang@mediatek.com>,
        Sergio Paracuellos <sergio.paracuellos@gmail.com>,
        devicetree@vger.kernel.org, erkin.bozoglu@xeront.com,
        Eric Dumazet <edumazet@google.com>,
        DENG Qingfang <dqfext@gmail.com>
Subject: Re: [PATCH v2 1/7] dt-bindings: net: dsa: mediatek,mt7530: make
 trivial changes
Message-ID: <20220816204908.GA2709132-robh@kernel.org>
References: <20220813154415.349091-1-arinc.unal@arinc9.com>
 <20220813154415.349091-2-arinc.unal@arinc9.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220813154415.349091-2-arinc.unal@arinc9.com>
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

On Sat, 13 Aug 2022 18:44:09 +0300, Arınç ÜNAL wrote:
> Make trivial changes on the binding.
> 
> - Update title to include MT7531 switch.
> - Add me as a maintainer. List maintainers in alphabetical order by first
> name.
> - Add description to compatible strings.
> - Stretch descriptions up to the 80 character limit.
> - Remove quotes from $ref: "dsa.yaml#".
> 
> Signed-off-by: Arınç ÜNAL <arinc.unal@arinc9.com>
> ---
>  .../bindings/net/dsa/mediatek,mt7530.yaml     | 36 ++++++++++++-------
>  1 file changed, 24 insertions(+), 12 deletions(-)
> 

Reviewed-by: Rob Herring <robh@kernel.org>
