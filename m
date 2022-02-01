Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 13CAD4A68BC
	for <lists+netdev@lfdr.de>; Wed,  2 Feb 2022 00:48:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242969AbiBAXsI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Feb 2022 18:48:08 -0500
Received: from mail-ot1-f44.google.com ([209.85.210.44]:46857 "EHLO
        mail-ot1-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230127AbiBAXsH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Feb 2022 18:48:07 -0500
Received: by mail-ot1-f44.google.com with SMTP id l12-20020a0568302b0c00b005a4856ff4ceso9707571otv.13;
        Tue, 01 Feb 2022 15:48:07 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=5RUplZRfk9YiyZU4EF15hHG6YA+dvhtsvLI3vOjO5F8=;
        b=3YcA/S9EcFOZvffNAiE6AGwjd2QK5931qMqtujHLNj7zB4OQtVR5vAB16NH2SnRs74
         LKtBsEfhMxGjiYsoE8IYrk2wGo1iSejPNTNJQZOxklkf2QEE8AYnNdJkuWgNV+ZNKcAE
         ou9FzjfyAU+qlABbriknlplEjju8MoES8qqKwebkfm3OEWOD0v/1uYhMzheczOswVqjg
         BHVlWJckx1ktYVBI6GfIdg5jbJ9pm7dpu4VG+C8uxtOmu4iMANbIfa/ikKmR+niN/JU/
         bvbFqpqvw81btXsgbb2YTSw6EAYGF7IG4fjocUzvCf3+Ldz/j8Dj0NRbJwNIbdk2muzW
         lJsA==
X-Gm-Message-State: AOAM530fPsTBAc09f6tUu8dlljZ4ubhQ9kWdUV7hOb1bS0yA1p0G8Ykt
        GM+Y1gMxsRORcBzyq5XF1g==
X-Google-Smtp-Source: ABdhPJwEcIPJ/wlzFp18MRMmXG5x/PY4EflMK5dXNRpiHc3/DtsJc9VwDGSIe8m9lYbL4pWMuPPqow==
X-Received: by 2002:a05:6830:1dc5:: with SMTP id a5mr15290341otj.147.1643759286959;
        Tue, 01 Feb 2022 15:48:06 -0800 (PST)
Received: from robh.at.kernel.org (66-90-148-213.dyn.grandenetworks.net. [66.90.148.213])
        by smtp.gmail.com with ESMTPSA id f21sm14562717otq.4.2022.02.01.15.48.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Feb 2022 15:48:06 -0800 (PST)
Received: (nullmailer pid 994944 invoked by uid 1000);
        Tue, 01 Feb 2022 23:48:05 -0000
Date:   Tue, 1 Feb 2022 17:48:05 -0600
From:   Rob Herring <robh@kernel.org>
To:     Biao Huang <biao.huang@mediatek.com>
Cc:     angelogioacchino.delregno@collabora.com,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        linux-stm32@st-md-mailman.stormreply.com,
        Jose Abreu <joabreu@synopsys.com>, devicetree@vger.kernel.org,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        linux-arm-kernel@lists.infradead.org, macpaul.lin@mediatek.com,
        dkirjanov@suse.de, netdev@vger.kernel.org,
        srv_heupstream@mediatek.com,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-mediatek@lists.infradead.org,
        Rob Herring <robh+dt@kernel.org>, linux-kernel@vger.kernel.org,
        davem@davemloft.net
Subject: Re: [PATCH net-next v12 7/7] net: dt-bindings: dwmac: add support
 for mt8195
Message-ID: <YfnGtWZLujX6SWQD@robh.at.kernel.org>
References: <20220117070706.17853-1-biao.huang@mediatek.com>
 <20220117070706.17853-8-biao.huang@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220117070706.17853-8-biao.huang@mediatek.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 17 Jan 2022 15:07:06 +0800, Biao Huang wrote:
> Add binding document for the ethernet on mt8195.
> 
> Signed-off-by: Biao Huang <biao.huang@mediatek.com>
> ---
>  .../bindings/net/mediatek-dwmac.yaml          | 28 ++++++++++++++++---
>  1 file changed, 24 insertions(+), 4 deletions(-)
> 

Reviewed-by: Rob Herring <robh@kernel.org>
