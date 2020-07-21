Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 090B02275EE
	for <lists+netdev@lfdr.de>; Tue, 21 Jul 2020 04:44:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728547AbgGUCoM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jul 2020 22:44:12 -0400
Received: from mail-il1-f195.google.com ([209.85.166.195]:39653 "EHLO
        mail-il1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725862AbgGUCoK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jul 2020 22:44:10 -0400
Received: by mail-il1-f195.google.com with SMTP id k6so15132682ili.6;
        Mon, 20 Jul 2020 19:44:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=yYPmnd+SjKU1YCRkUXZXwvqzmgl3B+n3upmC6X8T2QQ=;
        b=LBitO/vNYbbeflSEv8mvgvMX63UhjxF43UUQfh4T0RC6py4RxZZLuFQNGG/pPD8gHa
         wVw+m+4qhhgmiAVNmvtXb8apOpkS07sepIKAXIyvJV05nFVWxLHqCrfWnUbZLjhUVfuP
         b0sBfXO2xv+8t3bVh+5kD/+TO+eWs2s/U2IaFhg9722EtzVmngIUlv/Q2Y6Nat/oPwZS
         HyIX0uvDFqNXYimxq//XmbyutSBrzXe1poDpVUNBTCbU0p0jLE/TkUM+Z1XM4Ri1qYbi
         PDpJhvj9skydnUg1E3BbzV4/AwJmsD1BxJMegAWWfbT0WXz6jDgQX30Xm76hKzvLlpr2
         +BDA==
X-Gm-Message-State: AOAM53198PXO0prUJ1x2ntAa4nF0kI9jDbZKXsNJlQDy8v7Fe1CND+pu
        qdAt76evEXmLHQPz3Dw5SQ==
X-Google-Smtp-Source: ABdhPJwgDdwirEHxzZ01CrlLaV9MRJUwpXK9CrErS5iyCmm9bmSo7iTNiNXqf1p2Ybtsn39WCdI5Rg==
X-Received: by 2002:a92:cacf:: with SMTP id m15mr25092442ilq.34.1595299449331;
        Mon, 20 Jul 2020 19:44:09 -0700 (PDT)
Received: from xps15 ([64.188.179.252])
        by smtp.gmail.com with ESMTPSA id p84sm10227862ill.64.2020.07.20.19.44.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Jul 2020 19:44:08 -0700 (PDT)
Received: (nullmailer pid 3435958 invoked by uid 1000);
        Tue, 21 Jul 2020 02:44:04 -0000
Date:   Mon, 20 Jul 2020 20:44:04 -0600
From:   Rob Herring <robh@kernel.org>
To:     Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
Cc:     Daniel Lezcano <daniel.lezcano@linaro.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Rob Herring <robh+dt@kernel.org>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Prabhakar <prabhakar.csengg@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org, Guenter Roeck <linux@roeck-us.net>,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        Niklas <niklas.soderlund@ragnatech.se>,
        Mark Brown <broonie@kernel.org>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        Zhang Rui <rui.zhang@intel.com>, linux-spi@vger.kernel.org,
        Amit Kucheria <amit.kucheria@verdurent.com>,
        linux-i2c@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        linux-watchdog@vger.kernel.org, linux-can@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org, linux-pm@vger.kernel.org,
        Magnus Damm <magnus.damm@gmail.com>,
        Wim Van Sebroeck <wim@linux-watchdog.org>,
        Wolfram Sang <wsa+renesas@sang-engineering.com>
Subject: Re: [PATCH 11/20] dt-bindings: i2c: renesas,i2c: Document r8a774e1
 support
Message-ID: <20200721024404.GA3435911@bogus>
References: <1594811350-14066-1-git-send-email-prabhakar.mahadev-lad.rj@bp.renesas.com>
 <1594811350-14066-12-git-send-email-prabhakar.mahadev-lad.rj@bp.renesas.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1594811350-14066-12-git-send-email-prabhakar.mahadev-lad.rj@bp.renesas.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 15 Jul 2020 12:09:01 +0100, Lad Prabhakar wrote:
> Document i2c controller for RZ/G2H (R8A774E1) SoC, which is compatible
> with R-Car Gen3 SoC family.
> 
> Signed-off-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
> Reviewed-by: Marian-Cristian Rotariu <marian-cristian.rotariu.rb@bp.renesas.com>
> ---
>  Documentation/devicetree/bindings/i2c/renesas,i2c.txt | 1 +
>  1 file changed, 1 insertion(+)
> 

Acked-by: Rob Herring <robh@kernel.org>
