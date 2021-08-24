Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C05773F635D
	for <lists+netdev@lfdr.de>; Tue, 24 Aug 2021 18:51:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233598AbhHXQwa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Aug 2021 12:52:30 -0400
Received: from mail-ot1-f42.google.com ([209.85.210.42]:36697 "EHLO
        mail-ot1-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233753AbhHXQwW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Aug 2021 12:52:22 -0400
Received: by mail-ot1-f42.google.com with SMTP id a20-20020a0568300b9400b0051b8ca82dfcso26869894otv.3;
        Tue, 24 Aug 2021 09:51:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=TqDTocubplmJ8KIunSvtYYFh2tdzr0o4H6aSnsFWwoQ=;
        b=FajAzifi4PglX2qAAZvtbVMhll47upp6HknWOrPTgwem6GWwkElSrZ0jEWTwweFFNG
         CEQ3T77ZpCTUeSCGvk+Zy+wnEPRaXmGKU0McGXEo4fD6T+3hx2/UTgPkPB7Rjd9MZJoe
         hvhTEFvrqwGPd4ZXHlJfmJoVCZH7TtPhfvwDkf/W9ycAqg547QmEwCMF9HgcEs35ubJI
         hzmJiQGrbIbgSzms2R/+/qNufkiaOOKIopynD66VzT7gYPqCXYK5mTbUXh0CerY9sRNH
         ovLfy3qpEzlqJw80T9LH23YW8qzBjcSpLoNXhwxXhQWK5cda/nno2XTivcpcvlJlPcVp
         DVtw==
X-Gm-Message-State: AOAM531Qkgm0QiR8iAsUx290nRm/MtyqNVq+Uh5axZ83jNtrEFoAj9d6
        WjUHp+/jYnT5/atG4/CF4w==
X-Google-Smtp-Source: ABdhPJw2Hya/lTKLZYUqyBceJAvjGguwwCvu6T1Gp8q0wDr42rjLwqv+cAQ7rocAmn8afcP6DRhdhw==
X-Received: by 2002:a9d:de1:: with SMTP id 88mr34275329ots.60.1629823898082;
        Tue, 24 Aug 2021 09:51:38 -0700 (PDT)
Received: from robh.at.kernel.org (66-90-148-213.dyn.grandenetworks.net. [66.90.148.213])
        by smtp.gmail.com with ESMTPSA id g8sm4048072otk.34.2021.08.24.09.51.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Aug 2021 09:51:37 -0700 (PDT)
Received: (nullmailer pid 614406 invoked by uid 1000);
        Tue, 24 Aug 2021 16:51:36 -0000
Date:   Tue, 24 Aug 2021 11:51:36 -0500
From:   Rob Herring <robh@kernel.org>
To:     Alvin =?utf-8?Q?=C5=A0ipraga?= <alvin@pqrs.dk>
Cc:     Rob Herring <robh+dt@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Vladimir Oltean <olteanv@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>, mir@bang-olufsen.dk,
        Russell King <linux@armlinux.org.uk>,
        devicetree@vger.kernel.org,
        Alvin =?utf-8?Q?=C5=A0ipraga?= <alsi@bang-olufsen.dk>,
        Linus Walleij <linus.walleij@linaro.org>,
        linux-kernel@vger.kernel.org,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>, netdev@vger.kernel.org
Subject: Re: [RFC PATCH net-next 2/5] dt-bindings: net: dsa: realtek-smi:
 document new compatible rtl8365mb
Message-ID: <YSUjmFdtX5uUutPt@robh.at.kernel.org>
References: <20210822193145.1312668-1-alvin@pqrs.dk>
 <20210822193145.1312668-3-alvin@pqrs.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210822193145.1312668-3-alvin@pqrs.dk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 22 Aug 2021 21:31:40 +0200, Alvin Šipraga wrote:
> From: Alvin Šipraga <alsi@bang-olufsen.dk>
> 
> rtl8365mb is a new realtek-smi subdriver for the RTL8365MB-VC 4+1 port
> 10/100/1000M Ethernet switch controller. Its compatible string is
> "realtek,rtl8365mb".
> 
> Signed-off-by: Alvin Šipraga <alsi@bang-olufsen.dk>
> ---
>  Documentation/devicetree/bindings/net/dsa/realtek-smi.txt | 1 +
>  1 file changed, 1 insertion(+)
> 

Acked-by: Rob Herring <robh@kernel.org>
