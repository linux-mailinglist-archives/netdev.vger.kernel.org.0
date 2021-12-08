Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5890246DC3E
	for <lists+netdev@lfdr.de>; Wed,  8 Dec 2021 20:29:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239539AbhLHTdH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Dec 2021 14:33:07 -0500
Received: from mail-oo1-f45.google.com ([209.85.161.45]:43644 "EHLO
        mail-oo1-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232942AbhLHTdH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Dec 2021 14:33:07 -0500
Received: by mail-oo1-f45.google.com with SMTP id w5-20020a4a2745000000b002c2649b8d5fso1135874oow.10;
        Wed, 08 Dec 2021 11:29:34 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=AQsCNGRp1t3DJgJLxOhyX2OmCbSptGHddbgapeoW8vc=;
        b=un2ZJHCfyAsLtK05It0nucNhnFLQA4ExhXLZzsljGjPQvivdUWISHZtfmdCwt6Xgiz
         ed+BCoH+N5Yx2mQ/a5j5anVKDDLCK0Damgws9SVBEJuaL+ru54GoR7+lVq+xg1NNLaLZ
         08hJjtBHX4buGzrbt9NKGgeOgYSz3nTww889nXYyC6Vs5hUcMSRxTx5E3ij6ivSW01m2
         B8giXASxnDvNJwcwGeR7LyyNX34TdOgT6hPvud7IT6s0QND3LwzWvuuN/RUV9qoJr7Uo
         B9AsHGGwMgwJ+aP3lBDuFkQ10gXYQiPcAiNf0vasvIe/JVqH3+qASmk9cv9TOKyHqHpf
         MzBA==
X-Gm-Message-State: AOAM530sIQgywhLmyGiC620XqHmZgyN0RME0oFkqj6hi+TO79ajzXUeI
        gc1xtfmsTZ518C7eFtR6aRcyGxaS1Q==
X-Google-Smtp-Source: ABdhPJwcUQTGojrCz3TdV3bF5zi8CK6zzrD2t+T2AWQGnASxlzesKCmpf8JZueF25dzONmo5122rnw==
X-Received: by 2002:a05:6870:2191:b0:a8:8536:cbfe with SMTP id 586e51a60fabf-a88536da98mr207331fac.75.1638991774464;
        Wed, 08 Dec 2021 11:29:34 -0800 (PST)
Received: from robh.at.kernel.org (66-90-148-213.dyn.grandenetworks.net. [66.90.148.213])
        by smtp.gmail.com with ESMTPSA id x12sm648500oom.44.2021.12.08.11.29.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Dec 2021 11:29:33 -0800 (PST)
Received: (nullmailer pid 194267 invoked by uid 1000);
        Wed, 08 Dec 2021 19:29:32 -0000
Date:   Wed, 8 Dec 2021 13:29:32 -0600
From:   Rob Herring <robh@kernel.org>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     Doug Berger <opendmb@gmail.com>, linux-kernel@vger.kernel.org,
        Scott Branden <sbranden@broadcom.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>,
        linux-arm-kernel@lists.infradead.org,
        Vinod Koul <vkoul@kernel.org>, devicetree@vger.kernel.org,
        bcm-kernel-feedback-list@broadcom.com,
        Rob Herring <robh+dt@kernel.org>,
        linux-phy@lists.infradead.org, Ray Jui <rjui@broadcom.com>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <rafal@milecki.pl>
Subject: Re: [PATCH v3 3/8] dt-bindings: net: Document moca PHY interface
Message-ID: <YbEHnD7dSy15ajHm@robh.at.kernel.org>
References: <20211206180049.2086907-1-f.fainelli@gmail.com>
 <20211206180049.2086907-4-f.fainelli@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211206180049.2086907-4-f.fainelli@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 06 Dec 2021 10:00:44 -0800, Florian Fainelli wrote:
> MoCA (Multimedia over Coaxial) is used by the internal GENET/MOCA cores
> and will be needed in order to convert GENET to YAML in subsequent
> changes.
> 
> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
> ---
>  Documentation/devicetree/bindings/net/ethernet-controller.yaml | 1 +
>  1 file changed, 1 insertion(+)
> 

Applied, thanks!
