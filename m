Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F37D37208A
	for <lists+netdev@lfdr.de>; Mon,  3 May 2021 21:35:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229672AbhECTgm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 May 2021 15:36:42 -0400
Received: from mail-oo1-f50.google.com ([209.85.161.50]:34710 "EHLO
        mail-oo1-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229570AbhECTgk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 May 2021 15:36:40 -0400
Received: by mail-oo1-f50.google.com with SMTP id m25-20020a4abc990000b02901ed4500e31dso1501212oop.1;
        Mon, 03 May 2021 12:35:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=JBWBNxVimdXrI5+KU0cFX5vZU2z6L9qx8BxSHFKVFus=;
        b=X0aIwVXz4bxVRcHQqvDQZ1YkkBrJ9XY3UsVOcKbi7D8i+YdoEEv6W2z1XbOcolDuAT
         AbBUWFa+g7usYXIeFxPRnTll8sjN6fUUbaCGXuSYjuHwhhX4kOVoNLugwsNTnLQbRZdh
         /I2qlrv+TLD5lMA9DofMVtwCGHiOnGAQoGhsZKy8LKlTwOZANzvpGsdhxfVMrhKR0FD8
         PDXvshFQ3Gs0Rz0CZKA6rHNJOFgmv8kpQbvXdJzvVw9njvZ7dzc506HWQQZRKAComAb8
         co722AWVqR1XiZ3b+Ij1qmDom89UOQHVYv++hFIw2K/GIyR8Ur0rRSHKXoPpkHtCe86b
         slTQ==
X-Gm-Message-State: AOAM532eyjzP79DiMVl2uO09dY0UGP3iQKVyQHOU072IVeBmEqEevSv9
        S+0O70qPM7l25NBQGI6o0w==
X-Google-Smtp-Source: ABdhPJy/V6F3DccyF7xGWdj8eRMoURIuuJIGusacpBLZ1d5VgTJTuNBh1PnHECTqQEI5m6aTgsVEzA==
X-Received: by 2002:a4a:aa41:: with SMTP id y1mr15483387oom.52.1620070544325;
        Mon, 03 May 2021 12:35:44 -0700 (PDT)
Received: from robh.at.kernel.org (24-155-109-49.dyn.grandenetworks.net. [24.155.109.49])
        by smtp.gmail.com with ESMTPSA id a4sm188470oib.17.2021.05.03.12.35.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 May 2021 12:35:43 -0700 (PDT)
Received: (nullmailer pid 2253889 invoked by uid 1000);
        Mon, 03 May 2021 19:35:41 -0000
Date:   Mon, 3 May 2021 14:35:41 -0500
From:   Rob Herring <robh@kernel.org>
To:     DENG Qingfang <dqfext@gmail.com>
Cc:     Russell King <linux@armlinux.org.uk>,
        Vladimir Oltean <olteanv@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Sergio Paracuellos <sergio.paracuellos@gmail.com>,
        linux-kernel@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>, devicetree@vger.kernel.org,
        Chuanhong Guo <gch981213@gmail.com>,
        linux-staging@lists.linux.dev, Sean Wang <sean.wang@mediatek.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        netdev@vger.kernel.org, Frank Wunderlich <frank-w@public-files.de>,
        =?UTF-8?Q?Ren=C3=A9_van_Dorst?= <opensource@vdorst.com>,
        Weijie Gao <weijie.gao@mediatek.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        linux-mediatek@lists.infradead.org
Subject: Re: [PATCH net-next 3/4] dt-bindings: net: dsa: add MT7530 interrupt
 controller binding
Message-ID: <20210503193541.GA2253835@robh.at.kernel.org>
References: <20210429062130.29403-1-dqfext@gmail.com>
 <20210429062130.29403-4-dqfext@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210429062130.29403-4-dqfext@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 29 Apr 2021 14:21:29 +0800, DENG Qingfang wrote:
> Add device tree binding to support MT7530 interrupt controller.
> 
> Signed-off-by: DENG Qingfang <dqfext@gmail.com>
> ---
> RFC v4 -> PATCH v1:
> - No changes.
> 
>  Documentation/devicetree/bindings/net/dsa/mt7530.txt | 6 ++++++
>  1 file changed, 6 insertions(+)
> 

Acked-by: Rob Herring <robh@kernel.org>
