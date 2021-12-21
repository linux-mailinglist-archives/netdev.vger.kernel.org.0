Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 49D3247C268
	for <lists+netdev@lfdr.de>; Tue, 21 Dec 2021 16:13:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239096AbhLUPM6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Dec 2021 10:12:58 -0500
Received: from mail-qt1-f171.google.com ([209.85.160.171]:43521 "EHLO
        mail-qt1-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239083AbhLUPMx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Dec 2021 10:12:53 -0500
Received: by mail-qt1-f171.google.com with SMTP id q14so13084781qtx.10;
        Tue, 21 Dec 2021 07:12:53 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=+IafIC2V8+I0Hhvac9VMHU6UeR8wAMvvd/ODcVaMRss=;
        b=fwOo+dm72ZpIOC5exR28z0Ncm21j7OfO8m3jmRSDXdpIv54Kk//CZ5XTQ+1Aoxd9Mk
         6yNpXBg6Ti+d9qRWpTQrvkd5AI0FvkKYUq7b1tuEh70nppj2oBWmPMXZJe42fDCHkSRF
         9D4R8lQAjAWMFFmi9xzx05ae5wh/Bq5ozOhQb5ccdqGIeCR0sC4ju0P45hFGyRg5O5v7
         v3asziH8/QjSU43T+pxuLqb3wno39YSQttU0lqgcuhXbHP8bCWCKIdD52nK5yw1v9hrK
         wMfIGCrsp8Y37m+pHt3dXPwI1XkaqxD2p0hF7BejkAWQmiOgXKeRvR42z+gcpScdErXB
         1QtQ==
X-Gm-Message-State: AOAM531jplGmFUG9nwDL/cY++QfJ5sR8i+QlrpQatMwq15AoedV/zUzV
        SYc8GbRCkVxEZ2eUphXsOQ==
X-Google-Smtp-Source: ABdhPJyINjn8JyGssNu3VoFciVEkg+e+SVR8AusCwCyOBxbNiehdjx/uid1/aRb1yTupp5iRFKlAWg==
X-Received: by 2002:ac8:7f15:: with SMTP id f21mr2566111qtk.392.1640099572633;
        Tue, 21 Dec 2021 07:12:52 -0800 (PST)
Received: from robh.at.kernel.org ([24.55.105.145])
        by smtp.gmail.com with ESMTPSA id h9sm14190852qkp.106.2021.12.21.07.12.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Dec 2021 07:12:52 -0800 (PST)
Received: (nullmailer pid 1426512 invoked by uid 1000);
        Tue, 21 Dec 2021 15:12:50 -0000
Date:   Tue, 21 Dec 2021 11:12:50 -0400
From:   Rob Herring <robh@kernel.org>
To:     David Mosberger-Tang <davidm@egauge.net>
Cc:     Ajay Singh <ajay.kathat@microchip.com>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org,
        Kalle Valo <kvalo@codeaurora.org>, netdev@vger.kernel.org,
        linux-wireless@vger.kernel.org,
        Claudiu Beznea <claudiu.beznea@microchip.com>,
        "David S. Miller" <davem@davemloft.net>,
        Adham Abozaeid <adham.abozaeid@microchip.com>
Subject: Re: [PATCH v6 2/2] wilc1000: Document enable-gpios and reset-gpios
 properties
Message-ID: <YcHu8qkzguAPZcKx@robh.at.kernel.org>
References: <20211220180334.3990693-1-davidm@egauge.net>
 <20211220180334.3990693-3-davidm@egauge.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211220180334.3990693-3-davidm@egauge.net>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 20 Dec 2021 18:03:38 +0000, David Mosberger-Tang wrote:
> Add documentation for the ENABLE and RESET GPIOs that may be needed by
> wilc1000-spi.
> 
> Signed-off-by: David Mosberger-Tang <davidm@egauge.net>
> ---
>  .../net/wireless/microchip,wilc1000.yaml      | 19 +++++++++++++++++++
>  1 file changed, 19 insertions(+)
> 


Please add Acked-by/Reviewed-by tags when posting new versions. However,
there's no need to repost patches *only* to add the tags. The upstream
maintainer will do that for acks received on the version they apply.

If a tag was not added on purpose, please state why and what changed.

