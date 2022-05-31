Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 65AB45393D3
	for <lists+netdev@lfdr.de>; Tue, 31 May 2022 17:20:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345608AbiEaPUd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 May 2022 11:20:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237532AbiEaPUb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 May 2022 11:20:31 -0400
Received: from mail-oi1-f170.google.com (mail-oi1-f170.google.com [209.85.167.170])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EEF5B633AE;
        Tue, 31 May 2022 08:20:30 -0700 (PDT)
Received: by mail-oi1-f170.google.com with SMTP id k11so4244742oia.12;
        Tue, 31 May 2022 08:20:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=5T9PqeW++1xR8KKb+9Iejw7mcxEUijjXojRIr46Glmk=;
        b=fSj9MiGFVu/I11xxqO9+Jy+11hkELC+K7pW925nSsxDrjAa4brjDS/TKYwDlpZkv/I
         +2+LtU4zREFKnWBzInsdw5dciR8/CCpBQftiSy5qpDtxLJXyyTcMDBvX8uOPEuDagvaG
         n2KzM19l21s/WBOlh2jVrN1ItCO1JE5XI9dMh8bBfIPa+5iWMzxGA9OZr1FInEqi50Sy
         FkcKLTvwK9kdt3C1SPh9B7Dg3j3zRGHPzDTjqkAeZg47PJirOGzYowmryymCHEGhpHBS
         SYQ9td83unP5iiKKhhxCFdyYWKuauzkuDMCrX1oEAK862MAMdxQb2ClAk+CoPYV96sAK
         xVkg==
X-Gm-Message-State: AOAM532AyLpr8jNtV/xCLgUu5GqSsd5k+YvgRSkoKBHGGTcIBK7G9fUz
        ePZOOriDLiD4PtxF/ikAlw==
X-Google-Smtp-Source: ABdhPJxjR2JRyWzVqnm7ztIPcE+YpVknf54yXEDm7ZWqZcTjkkBQ/BU8e6ghx/26uMLfuoLOoS41AA==
X-Received: by 2002:aca:61c1:0:b0:2ec:d091:ff53 with SMTP id v184-20020aca61c1000000b002ecd091ff53mr12581172oib.235.1654010430172;
        Tue, 31 May 2022 08:20:30 -0700 (PDT)
Received: from robh.at.kernel.org (66-90-144-107.dyn.grandenetworks.net. [66.90.144.107])
        by smtp.gmail.com with ESMTPSA id r19-20020a056820039300b00333220959b9sm6169928ooj.1.2022.05.31.08.20.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 31 May 2022 08:20:29 -0700 (PDT)
Received: (nullmailer pid 1785018 invoked by uid 1000);
        Tue, 31 May 2022 15:20:28 -0000
Date:   Tue, 31 May 2022 10:20:28 -0500
From:   Rob Herring <robh@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Felix Fietkau <nbd@nbd.name>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Ryder Lee <ryder.lee@mediatek.com>,
        Shayne Chen <shayne.chen@mediatek.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Kalle Valo <kvalo@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Claudiu Beznea <claudiu.beznea@microchip.com>,
        Biao Huang <biao.huang@mediatek.com>
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Subject: Re: [PATCH] dt-bindings: net: Fix unevaluatedProperties warnings in
 examples
Message-ID: <20220531152028.GF1742958-robh@kernel.org>
References: <20220526014149.2872762-1-robh@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220526014149.2872762-1-robh@kernel.org>
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

On Wed, May 25, 2022 at 08:41:48PM -0500, Rob Herring wrote:
> The 'unevaluatedProperties' schema checks is not fully working and doesn't
> catch some cases where there's a $ref to another schema. A fix is pending,
> but results in new warnings in examples. Fix the warnings by removing
> spurious properties or adding missing properties to the schema.
> 
> Signed-off-by: Rob Herring <robh@kernel.org>
> ---
>  Documentation/devicetree/bindings/net/cdns,macb.yaml           | 1 -
>  Documentation/devicetree/bindings/net/mediatek,net.yaml        | 3 +++
>  Documentation/devicetree/bindings/net/mediatek-dwmac.yaml      | 3 +++
>  .../devicetree/bindings/net/wireless/mediatek,mt76.yaml        | 2 +-
>  4 files changed, 7 insertions(+), 2 deletions(-)

Applied, thanks.
