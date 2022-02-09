Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D0F94AE7F5
	for <lists+netdev@lfdr.de>; Wed,  9 Feb 2022 05:07:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236492AbiBIEHR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Feb 2022 23:07:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245500AbiBIDfe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Feb 2022 22:35:34 -0500
Received: from mail-oo1-f51.google.com (mail-oo1-f51.google.com [209.85.161.51])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46FF9C0401C7;
        Tue,  8 Feb 2022 19:35:32 -0800 (PST)
Received: by mail-oo1-f51.google.com with SMTP id u47-20020a4a9732000000b00316d0257de0so1050071ooi.7;
        Tue, 08 Feb 2022 19:35:32 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Ua8yzWuBZ3Q29vbdd20GEsasq9Yt7O844bjqRtO+wJI=;
        b=V5q3OgBz/5SsdnigDknvUPJDHfV5PR4cVJ54UGlFH9rlhGha4Z+SO5++9ETJ2Uhe6U
         PuPWtx9ii2BL0Y7jne8cSE2FkewS2TTpaOE2HYLd0sZMwPr9PUvOJ5GS2UG5Gtpa/hqZ
         yRVsjFYNdQataxMqJJmOA1XysDin8hjCUSZq6OHWI+F34ftK/2Y5g3OKk7jd5tghFnoS
         7nFpBtV39Sy5wjvznaAXEhOD565mH+H8XrF9c92Z4B5FLE0CFoKqFlu2jRESkuWploGB
         ppHdXLhUASKAcMylsdNSlzf2m3GrDXtNv5pfv8JqLPgma2VjPt7DJXpxGBhxIXflBc/3
         auMw==
X-Gm-Message-State: AOAM531GfJh/lUxjT8W1SEf/ieTqbGsI/5JfTr9xDzYdHoGM1SNQawUC
        h6chMqytbHZseOhuTo7PG8l6Km90KQ==
X-Google-Smtp-Source: ABdhPJwklbn1MIZs1/9RclzK3S7SlJx6e1DOtC9O6gHsNTCdMxHh0O0KRUuHoqfzQbEnwz7S4bpX7w==
X-Received: by 2002:a05:6870:5146:: with SMTP id z6mr147799oak.52.1644377731646;
        Tue, 08 Feb 2022 19:35:31 -0800 (PST)
Received: from robh.at.kernel.org (66-90-148-213.dyn.grandenetworks.net. [66.90.148.213])
        by smtp.gmail.com with ESMTPSA id s3sm6113168otg.67.2022.02.08.19.35.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Feb 2022 19:35:31 -0800 (PST)
Received: (nullmailer pid 3591177 invoked by uid 1000);
        Wed, 09 Feb 2022 03:35:29 -0000
Date:   Tue, 8 Feb 2022 21:35:29 -0600
From:   Rob Herring <robh@kernel.org>
To:     Biao Huang <biao.huang@mediatek.com>
Cc:     Mark Lee <Mark-MC.Lee@mediatek.com>,
        linux-arm-kernel@lists.infradead.org,
        Fabien Parent <fparent@baylibre.com>,
        Bartosz Golaszewski <brgl@bgdev.pl>,
        Felix Fietkau <nbd@nbd.name>, devicetree@vger.kernel.org,
        Macpaul Lin <macpaul.lin@mediatek.com>,
        John Crispin <john@phrozen.org>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-mediatek@lists.infradead.org, srv_heupstream@mediatek.com,
        Matthias Brugger <matthias.bgg@gmail.com>,
        netdev@vger.kernel.org, Sean Wang <sean.wang@mediatek.com>,
        Rob Herring <robh+dt@kernel.org>, linux-kernel@vger.kernel.org,
        David Miller <davem@davemloft.net>,
        Yinghua Pan <ot_yinghua.pan@mediatek.com>
Subject: Re: [PATCH net-next v2 4/9] dt-bindings: net: mtk-star-emac: add
 support for MT8365
Message-ID: <YgM2gb7mqZAwmigt@robh.at.kernel.org>
References: <20220127015857.9868-1-biao.huang@mediatek.com>
 <20220127015857.9868-5-biao.huang@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220127015857.9868-5-biao.huang@mediatek.com>
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

On Thu, 27 Jan 2022 09:58:52 +0800, Biao Huang wrote:
> Add binding document for Ethernet on MT8365.
> 
> Signed-off-by: Biao Huang <biao.huang@mediatek.com>
> Reviewed-by: Bartosz Golaszewski <brgl@bgdev.pl>
> ---
>  Documentation/devicetree/bindings/net/mediatek,star-emac.yaml | 1 +
>  1 file changed, 1 insertion(+)
> 

Acked-by: Rob Herring <robh@kernel.org>
