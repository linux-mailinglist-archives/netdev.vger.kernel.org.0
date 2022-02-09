Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 603254AE7FB
	for <lists+netdev@lfdr.de>; Wed,  9 Feb 2022 05:07:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241925AbiBIEHU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Feb 2022 23:07:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346744AbiBIDg0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Feb 2022 22:36:26 -0500
Received: from mail-oo1-f47.google.com (mail-oo1-f47.google.com [209.85.161.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B045C0401C8;
        Tue,  8 Feb 2022 19:36:24 -0800 (PST)
Received: by mail-oo1-f47.google.com with SMTP id 189-20020a4a03c6000000b003179d7b30d8so1081160ooi.2;
        Tue, 08 Feb 2022 19:36:24 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=M0eMaFLZdFHtOyElhZiC1aSTh7v5BhW9YI15xZRN/jo=;
        b=KmlInnK6l/O6j3Sabmd2nypSsAbaBUwD3AU3mboYgK4gFBbRa4yySo+aZVcF6s8c4I
         DwCXb9CORMnsJhDVXCIxQHAesXrqGxnWe6EXSJbT+PQvungBQrdobb8swrrV/yrjOyrg
         dvJ75tl5a0XE1NdHeTvUofrtKq2oUTmaHZOkXcJeyxKC6BcVFtqN11hxN7LjSfcZFiAJ
         qBmhQRK+en7OZCFvkZIVonQBS2np99Zgpxwx6BSRU/gmFaEtuHbayvHKb1bPlobERgOO
         AVWz47kJl+P5hSPj6kPRJt5f4l7T5e4mQPcR+Y1rfkFgeJ98FS8oQcUpWEY+2Z8XC+8Y
         Wghw==
X-Gm-Message-State: AOAM532SCdoNllkfIESEQCaor5g/2Ag2zZwtaVT/SnB7dALuEacADKiH
        BM+bNzx1oWm8wrkRsvpU61poc3hDSA==
X-Google-Smtp-Source: ABdhPJz8GK79FXdMUJW3iiN73KqRsTqgE1epbU3os+/h7mom2viA19kzju50I1wi3jRxGSJOOYKM/A==
X-Received: by 2002:a05:6870:3815:: with SMTP id y21mr142981oal.330.1644377783826;
        Tue, 08 Feb 2022 19:36:23 -0800 (PST)
Received: from robh.at.kernel.org (66-90-148-213.dyn.grandenetworks.net. [66.90.148.213])
        by smtp.gmail.com with ESMTPSA id b7sm6161947ooq.30.2022.02.08.19.36.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Feb 2022 19:36:23 -0800 (PST)
Received: (nullmailer pid 3592618 invoked by uid 1000);
        Wed, 09 Feb 2022 03:36:22 -0000
Date:   Tue, 8 Feb 2022 21:36:22 -0600
From:   Rob Herring <robh@kernel.org>
To:     Biao Huang <biao.huang@mediatek.com>
Cc:     srv_heupstream@mediatek.com, linux-kernel@vger.kernel.org,
        Bartosz Golaszewski <brgl@bgdev.pl>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        Macpaul Lin <macpaul.lin@mediatek.com>,
        Yinghua Pan <ot_yinghua.pan@mediatek.com>,
        David Miller <davem@davemloft.net>,
        Felix Fietkau <nbd@nbd.name>, John Crispin <john@phrozen.org>,
        Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        Sean Wang <sean.wang@mediatek.com>,
        linux-mediatek@lists.infradead.org,
        Fabien Parent <fparent@baylibre.com>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH net-next v2 7/9] dt-bindings: net: mtk-star-emac: add
 description for new  properties
Message-ID: <YgM2tu+Mo34QVAjC@robh.at.kernel.org>
References: <20220127015857.9868-1-biao.huang@mediatek.com>
 <20220127015857.9868-8-biao.huang@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220127015857.9868-8-biao.huang@mediatek.com>
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

On Thu, 27 Jan 2022 09:58:55 +0800, Biao Huang wrote:
> Add description for new properties which will be parsed in driver.
> 
> Signed-off-by: Biao Huang <biao.huang@mediatek.com>
> ---
>  .../bindings/net/mediatek,star-emac.yaml         | 16 ++++++++++++++++
>  1 file changed, 16 insertions(+)
> 

Acked-by: Rob Herring <robh@kernel.org>
