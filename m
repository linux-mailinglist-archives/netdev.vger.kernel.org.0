Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4755222762E
	for <lists+netdev@lfdr.de>; Tue, 21 Jul 2020 04:53:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728706AbgGUCxJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jul 2020 22:53:09 -0400
Received: from mail-io1-f65.google.com ([209.85.166.65]:38506 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728579AbgGUCxF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jul 2020 22:53:05 -0400
Received: by mail-io1-f65.google.com with SMTP id l1so19806472ioh.5;
        Mon, 20 Jul 2020 19:53:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=xASqgPBn0vQnBjRaakU4/De4PK+WKVGo5AzdY13vuio=;
        b=ntC4ltZX+BfpHUGVvS8VEpn019uB8Wb2nTUklpcpkmFDgk0xUSm4HNYjUkiPSoNvef
         dJT1tSN+2F5YjukNs5Inf3pDElG5oDxF5zpvO5Gl1CJQ88nUwuylfO/4Cd8yx9v7RPuU
         32fpSBNKFOy/jvP3b1guhWhfzkbX/pJ5v4cIvCBkTjW/9xD7n9JWl7cbily43uQAbPoV
         1TZkL76kxoeuLAW6umMjEdyrHg1MVxAEcB2/eVUn8bPUfdh1KP4DKVbwChEtEniVS/M7
         R+mGJgewes2vquW0l2qbCj9LGvwa/zesfAI413r9wDXqg25dUcwxpw78Ya3nw0l6Auyu
         bj0w==
X-Gm-Message-State: AOAM533z5Y5Xe0Gt/1L7ew7ecLUSctIbZ0QcJhxrK427SkwzrT40kCdA
        tnk+2CIoZyTwUL9xBixRog==
X-Google-Smtp-Source: ABdhPJz41h8OM5s4geRzLZHoERqx9LciqCO3xEc+DShybK0JD+WqMSGJQl6OIfjmXHrai9bDWqOecw==
X-Received: by 2002:a05:6638:1308:: with SMTP id r8mr20353417jad.106.1595299984114;
        Mon, 20 Jul 2020 19:53:04 -0700 (PDT)
Received: from xps15 ([64.188.179.252])
        by smtp.gmail.com with ESMTPSA id i84sm10099147ill.30.2020.07.20.19.53.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Jul 2020 19:53:03 -0700 (PDT)
Received: (nullmailer pid 3448269 invoked by uid 1000);
        Tue, 21 Jul 2020 02:53:01 -0000
Date:   Mon, 20 Jul 2020 20:53:01 -0600
From:   Rob Herring <robh@kernel.org>
To:     Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        linux-watchdog@vger.kernel.org, netdev@vger.kernel.org,
        Amit Kucheria <amit.kucheria@verdurent.com>,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        Niklas <niklas.soderlund@ragnatech.se>,
        "David S. Miller" <davem@davemloft.net>,
        Wim Van Sebroeck <wim@linux-watchdog.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Rob Herring <robh+dt@kernel.org>,
        linux-renesas-soc@vger.kernel.org,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Wolfram Sang <wsa+renesas@sang-engineering.com>,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        linux-can@vger.kernel.org, Marc Kleine-Budde <mkl@pengutronix.de>,
        linux-i2c@vger.kernel.org, Wolfgang Grandegger <wg@grandegger.com>,
        Mark Brown <broonie@kernel.org>,
        Magnus Damm <magnus.damm@gmail.com>, linux-pm@vger.kernel.org,
        linux-spi@vger.kernel.org, Zhang Rui <rui.zhang@intel.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Prabhakar <prabhakar.csengg@gmail.com>
Subject: Re: [PATCH 19/20] dt-bindings: can: rcar_canfd: Document r8a774e1
 support
Message-ID: <20200721025301.GA3448222@bogus>
References: <1594811350-14066-1-git-send-email-prabhakar.mahadev-lad.rj@bp.renesas.com>
 <1594811350-14066-20-git-send-email-prabhakar.mahadev-lad.rj@bp.renesas.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1594811350-14066-20-git-send-email-prabhakar.mahadev-lad.rj@bp.renesas.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 15 Jul 2020 12:09:09 +0100, Lad Prabhakar wrote:
> Document the support for rcar_canfd on R8A774E1 SoC devices.
> 
> Signed-off-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
> Reviewed-by: Marian-Cristian Rotariu <marian-cristian.rotariu.rb@bp.renesas.com>
> ---
>  Documentation/devicetree/bindings/net/can/rcar_canfd.txt | 1 +
>  1 file changed, 1 insertion(+)
> 

Acked-by: Rob Herring <robh@kernel.org>
