Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E3F148B47F
	for <lists+netdev@lfdr.de>; Tue, 11 Jan 2022 18:51:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344754AbiAKRvE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Jan 2022 12:51:04 -0500
Received: from mail-oi1-f182.google.com ([209.85.167.182]:44982 "EHLO
        mail-oi1-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344760AbiAKRvC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Jan 2022 12:51:02 -0500
Received: by mail-oi1-f182.google.com with SMTP id s9so69669oib.11;
        Tue, 11 Jan 2022 09:51:02 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=FCQPITei3COem8cmVAANSwaWxSLVAkkDF2YSEJ/o+O4=;
        b=lHlzRVInTDME5au5sr1oghWgv+u8lkaHIxhHPMtJrq4W26YNJb6IgfpV1pDLIJ0dAS
         PyehQf9ojUU8rx50BDNlwkTfKa0RmpdGFBDKuz1zvLNpZHWbdDpZsWHqXUGgwu1BAeU+
         h7oyQR5GPvvf3NwnKjv1I2uYhgtQPxqi8S3zoYbghXSV+rbM6fXwPlH/JmkD/v3DYIoH
         YQSAGNCkKvT3LrE9wMEcgdu4N9pCdpvkyYeexkwl21AQtNtCTMFWzDP1/tcFbAMiR8td
         amvoDUenFnhIPUEcPVJopiwpUz3PbvheaE2FyBqtaM7guWNNN+n5DZPzb4UDPTRybATU
         +Lag==
X-Gm-Message-State: AOAM533qcQjiKHWB4l09R15ddvWoM20tB2qZ706ecGiaDDjqyUAvE2SZ
        /igqC/2+KfkIRxVi3Mg1+g==
X-Google-Smtp-Source: ABdhPJzRyceLnQnI7OQ9vNM9e7mwGoZsEmJTGCoevf0mvD9EDvtFFVOamMtqqTkLJJ2l6jnWh/xgMQ==
X-Received: by 2002:a05:6808:1290:: with SMTP id a16mr2549347oiw.116.1641923461627;
        Tue, 11 Jan 2022 09:51:01 -0800 (PST)
Received: from robh.at.kernel.org (66-90-148-213.dyn.grandenetworks.net. [66.90.148.213])
        by smtp.gmail.com with ESMTPSA id s1sm2020749ooo.11.2022.01.11.09.51.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Jan 2022 09:51:01 -0800 (PST)
Received: (nullmailer pid 3227467 invoked by uid 1000);
        Tue, 11 Jan 2022 17:51:00 -0000
Date:   Tue, 11 Jan 2022 11:51:00 -0600
From:   Rob Herring <robh@kernel.org>
To:     Rob Herring <robh@kernel.org>
Cc:     Felix Fietkau <nbd@nbd.name>, netdev@vger.kernel.org,
        Ryder Lee <ryder.lee@mediatek.com>,
        Kalle Valo <kvalo@kernel.org>, devicetree@vger.kernel.org,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        linux-mediatek@lists.infradead.org, linux-wireless@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] dt-bindings: net: wireless: mt76: Fix 8-bit property
 sizes
Message-ID: <Yd3DhO7bel0NH5UL@robh.at.kernel.org>
References: <20220107030419.2380198-1-robh@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220107030419.2380198-1-robh@kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 06 Jan 2022 21:04:17 -0600, Rob Herring wrote:
> The '/bits/ 8' notation applies the next <> list of values. Another <> list
> is encoded as 32-bits by default. IOW, each <> list needs to be preceeded
> with '/bits/ 8'.
> 
> While the dts format allows this, as a rule we don't mix sizes for DT
> properties since all size information is lost in the dtb file.
> 
> Signed-off-by: Rob Herring <robh@kernel.org>
> ---
>  .../devicetree/bindings/net/wireless/mediatek,mt76.yaml       | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 

Applied, thanks!
