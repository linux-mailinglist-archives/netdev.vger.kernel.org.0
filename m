Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C56F6477684
	for <lists+netdev@lfdr.de>; Thu, 16 Dec 2021 17:01:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238739AbhLPQBd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Dec 2021 11:01:33 -0500
Received: from mail-oi1-f175.google.com ([209.85.167.175]:38554 "EHLO
        mail-oi1-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233061AbhLPQBc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Dec 2021 11:01:32 -0500
Received: by mail-oi1-f175.google.com with SMTP id r26so37032627oiw.5;
        Thu, 16 Dec 2021 08:01:32 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=dbSG32y6ukLoqfqRo2sXQ+YKKGePZyrZXfU9tAawzpw=;
        b=qUkDD6WsVl4msrfnNzQD/rDW3DAl9r/pW3JVPxl773gzU0aSJnHqEFmyIvRFbMWRo3
         I7AtSr1XB3osR9XG5bjkAcMMwfXsokLo32X3T/rDCQVHTevpWqjEJQNQeQs6Lw2Xf+mp
         +djnkCc+d3m56HrRjXK8ld0HEKvwwYjvQGArOtKyCaNq4uSrlyxS/jpf+x4EZbqw43OF
         aqo+up9PgrvR4Kk+C/13dHh4MDtoZDrZeUSLdGefWK31xgdKSkRvQ23pVQBLwXJtkylc
         M3GicbeTXkdPqcBn/tU30jjvJJeaz4fAsa33nrdw4ZmkWifIaFlvSwcz31DkClX6exQ2
         XnRg==
X-Gm-Message-State: AOAM533cvwLli2511FfGPTXDNEqgn86pCU93aBSQYf9E4vr4pWkRkF5B
        unVt83mIbuEy915wy6RWrTXfzImSKA==
X-Google-Smtp-Source: ABdhPJwT+stimIXyLjdj+CQr+hmRqN6GhTves5+Kg2E8pFUvFz/CQxyByaiN3nzlpTAMNrsQfGSp7A==
X-Received: by 2002:a05:6808:697:: with SMTP id k23mr4663881oig.18.1639670491935;
        Thu, 16 Dec 2021 08:01:31 -0800 (PST)
Received: from robh.at.kernel.org (66-90-148-213.dyn.grandenetworks.net. [66.90.148.213])
        by smtp.gmail.com with ESMTPSA id x17sm1077566oot.30.2021.12.16.08.01.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Dec 2021 08:01:31 -0800 (PST)
Received: (nullmailer pid 298545 invoked by uid 1000);
        Thu, 16 Dec 2021 16:01:30 -0000
Date:   Thu, 16 Dec 2021 10:01:30 -0600
From:   Rob Herring <robh@kernel.org>
To:     Biao Huang <biao.huang@mediatek.com>
Cc:     davem@davemloft.net, Jakub Kicinski <kuba@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org,
        linux-stm32@st-md-mailman.stormreply.com,
        srv_heupstream@mediatek.com, macpaul.lin@mediatek.com,
        angelogioacchino.delregno@collabora.com, dkirjanov@suse.de
Subject: Re: [PATCH net-next v10 4/6] net: dt-bindings: dwmac: Convert
 mediatek-dwmac to DT schema
Message-ID: <Ybti2mNfEVNWQWgM@robh.at.kernel.org>
References: <20211216055328.15953-1-biao.huang@mediatek.com>
 <20211216055328.15953-5-biao.huang@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211216055328.15953-5-biao.huang@mediatek.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 16, 2021 at 01:53:26PM +0800, Biao Huang wrote:
> Convert mediatek-dwmac to DT schema, and delete old mediatek-dwmac.txt.
> And there are some changes in .yaml than .txt, others almost keep the same:
>   1. compatible "const: snps,dwmac-4.20".
>   2. delete "snps,reset-active-low;" in example, since driver remove this
>      property long ago.
>   3. add "snps,reset-delay-us = <0 10000 10000>" in example.
>   4. the example is for rgmii interface, keep related properties only.
> 
> Signed-off-by: Biao Huang <biao.huang@mediatek.com>
> ---
>  .../bindings/net/mediatek-dwmac.txt           |  91 ----------
>  .../bindings/net/mediatek-dwmac.yaml          | 155 ++++++++++++++++++
>  2 files changed, 155 insertions(+), 91 deletions(-)
>  delete mode 100644 Documentation/devicetree/bindings/net/mediatek-dwmac.txt
>  create mode 100644 Documentation/devicetree/bindings/net/mediatek-dwmac.yaml

Reviewed-by: Rob Herring <robh@kernel.org>
