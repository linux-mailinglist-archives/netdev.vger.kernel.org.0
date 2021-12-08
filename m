Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF41D46DC38
	for <lists+netdev@lfdr.de>; Wed,  8 Dec 2021 20:28:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236458AbhLHTcG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Dec 2021 14:32:06 -0500
Received: from mail-oi1-f180.google.com ([209.85.167.180]:37613 "EHLO
        mail-oi1-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232942AbhLHTcG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Dec 2021 14:32:06 -0500
Received: by mail-oi1-f180.google.com with SMTP id bj13so5505764oib.4;
        Wed, 08 Dec 2021 11:28:33 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Ei1/bJy2vB9qPW5/d6507cGAxG5aCdrek2IZnuOeREY=;
        b=zKMAbMG+LcKe5vkjttfh8msIvub66GL6BO+49/nC69juWfruSqBt33qt9B6xLUZ54f
         /pJm3vCo3ANnlwMDp7brkLovZkz95OfeyY5YcwMzZFrpEmAi8aImwJlLP4f6ZTs9RUvE
         4hwHgNDAsKzex+hf7C4fyqHlVvVK/dc/KZlM7THRIxWKleuBzlMrWANhZtqLB58z2djg
         MK2kgjegUfQKF5AgB5QJg1+r3bWotQXG5bP50b6bm1Ln8OhI9VIE+kIQwZR+/sJDJu5V
         Zr5XLehK+ZF14U8SO+yaAxeVbsbvTB3y4xhfXQVQrPtanfTTpJXvkA9iPp8B+BRudDQ1
         /FVA==
X-Gm-Message-State: AOAM533xjPFalcqsqnyAWjpXfjNGe34UsnMMGBGw0uYtyLWpb06a/d3V
        hb6eFrIIJOV7XJPyAC1XeQ==
X-Google-Smtp-Source: ABdhPJwF+jq77ny2CvN0M9DJhRVaukgUgnt5T4DciezsLcCNsXh6daUT1e0/rDKNjYuM9PQSC80Bww==
X-Received: by 2002:a05:6808:14c4:: with SMTP id f4mr1435157oiw.76.1638991713363;
        Wed, 08 Dec 2021 11:28:33 -0800 (PST)
Received: from robh.at.kernel.org (66-90-148-213.dyn.grandenetworks.net. [66.90.148.213])
        by smtp.gmail.com with ESMTPSA id 109sm603156otv.30.2021.12.08.11.28.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Dec 2021 11:28:32 -0800 (PST)
Received: (nullmailer pid 192567 invoked by uid 1000);
        Wed, 08 Dec 2021 19:28:31 -0000
Date:   Wed, 8 Dec 2021 13:28:31 -0600
From:   Rob Herring <robh@kernel.org>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     Kishon Vijay Abraham I <kishon@ti.com>,
        Scott Branden <sbranden@broadcom.com>, netdev@vger.kernel.org,
        Ray Jui <rjui@broadcom.com>, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, Vinod Koul <vkoul@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <rafal@milecki.pl>,
        bcm-kernel-feedback-list@broadcom.com,
        linux-phy@lists.infradead.org, Rob Herring <robh+dt@kernel.org>,
        Doug Berger <opendmb@gmail.com>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v3 1/8] dt-bindings: net: brcm,unimac-mdio: reg-names is
 optional
Message-ID: <YbEHX3OyNLD/LuPZ@robh.at.kernel.org>
References: <20211206180049.2086907-1-f.fainelli@gmail.com>
 <20211206180049.2086907-2-f.fainelli@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211206180049.2086907-2-f.fainelli@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 06 Dec 2021 10:00:42 -0800, Florian Fainelli wrote:
> The UniMAC MDIO controller integrated into GENET does not provide a
> reg-names property since it is optional, reflect that in the binding.
> 
> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
> ---
>  Documentation/devicetree/bindings/net/brcm,unimac-mdio.yaml | 1 -
>  1 file changed, 1 deletion(-)
> 

Applied, thanks!
