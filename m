Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 95135678771
	for <lists+netdev@lfdr.de>; Mon, 23 Jan 2023 21:18:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232217AbjAWUSX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Jan 2023 15:18:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231485AbjAWUST (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Jan 2023 15:18:19 -0500
Received: from mail-oi1-f176.google.com (mail-oi1-f176.google.com [209.85.167.176])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BB7034C23;
        Mon, 23 Jan 2023 12:18:18 -0800 (PST)
Received: by mail-oi1-f176.google.com with SMTP id r9so11396465oie.13;
        Mon, 23 Jan 2023 12:18:18 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mK0iGLqhByM+nmssrOHeinttd969xwUfXTpdV4dep5c=;
        b=n/ZgXUNNpvEd+LVPWGtU33CCgPl/CxQ15SOHcmMCX9i7VvOG7Gpyh3NAen0b3PTBuk
         8LUpeQOKDC97BvrD1suzTd2LMRI2XZRDc4omHS93RX97pKsputDMR9FKGRH6TBLEWwje
         mPms+nhq0UcPV/wwWDCygp5yundkZOrS6jD64ByiLb7lvz3HLI4o/OsQfjPdoH120VVN
         M5gQsMcupzL/7XwHKI3K3kh9wdYDNAW9BE0/5raRZOy1SZ+XPxZFLO6WRkHSCb/aYdc0
         hHNJpw0sxCAbXZaOgNZfKkuf89FpdL8TftRun4UQ2EIS8VGkNuHlxUAXOgg1Oa5HwRhc
         RaGA==
X-Gm-Message-State: AFqh2kpLy1O/IpnoHislKCa5lZEULFiqJLdlOqD5RBnR0Uab+crQejS9
        cBEL5mbUjo/XPWkMObd68w==
X-Google-Smtp-Source: AMrXdXvG469eglRB6stlMcR9S5LSQ9Bd8cqzftLdjrwTlwQV82cvdD2vmDaBK/X/vfCMNq4asQc4ZA==
X-Received: by 2002:aca:3205:0:b0:364:be69:fbc with SMTP id y5-20020aca3205000000b00364be690fbcmr12402093oiy.9.1674505097515;
        Mon, 23 Jan 2023 12:18:17 -0800 (PST)
Received: from robh_at_kernel.org (66-90-144-107.dyn.grandenetworks.net. [66.90.144.107])
        by smtp.gmail.com with ESMTPSA id w21-20020a056808091500b0036eafb8eee9sm147503oih.22.2023.01.23.12.18.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Jan 2023 12:18:17 -0800 (PST)
Received: (nullmailer pid 2454843 invoked by uid 1000);
        Mon, 23 Jan 2023 20:18:16 -0000
Date:   Mon, 23 Jan 2023 14:18:16 -0600
From:   Rob Herring <robh@kernel.org>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-mediatek@lists.infradead.org, Felix Fietkau <nbd@nbd.name>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Kalle Valo <kvalo@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-arm-kernel@lists.infradead.org,
        Ryder Lee <ryder.lee@mediatek.com>,
        Tony Lindgren <tony@atomide.com>,
        Rob Herring <robh+dt@kernel.org>,
        Shayne Chen <shayne.chen@mediatek.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        ath11k@lists.infradead.org, de Goede <hdegoede@redhat.com>,
        devicetree@vger.kernel.org,
        =?iso-8859-1?B?Suly9G1l?= Pouiller <jerome.pouiller@silabs.com>,
        "David S. Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] dt-bindings: net: wireless: minor whitespace and name
 cleanups
Message-ID: <167450509566.2454785.18050476344855369899.robh@kernel.org>
References: <20230118175413.360153-1-krzysztof.kozlowski@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230118175413.360153-1-krzysztof.kozlowski@linaro.org>
X-Spam-Status: No, score=-1.3 required=5.0 tests=BAYES_00,
        FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On Wed, 18 Jan 2023 18:54:13 +0100, Krzysztof Kozlowski wrote:
> Minor cleanups:
>  - Drop redundant blank lines,
>  - Correct indentaion in examples,
>  - Correct node names in examples to drop underscore and use generic
>    name.
> 
> No functional impact except adjusting to preferred coding style.
> 
> Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
> ---
>  .../bindings/net/wireless/esp,esp8089.yaml    | 20 +++---
>  .../bindings/net/wireless/ieee80211.yaml      |  1 -
>  .../bindings/net/wireless/mediatek,mt76.yaml  |  1 -
>  .../bindings/net/wireless/qcom,ath11k.yaml    | 11 ++-
>  .../bindings/net/wireless/silabs,wfx.yaml     |  1 -
>  .../bindings/net/wireless/ti,wlcore.yaml      | 70 +++++++++----------
>  6 files changed, 50 insertions(+), 54 deletions(-)
> 

Acked-by: Rob Herring <robh@kernel.org>
