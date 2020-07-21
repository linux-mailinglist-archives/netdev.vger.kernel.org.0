Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D169022761D
	for <lists+netdev@lfdr.de>; Tue, 21 Jul 2020 04:52:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728538AbgGUCwi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jul 2020 22:52:38 -0400
Received: from mail-il1-f196.google.com ([209.85.166.196]:42857 "EHLO
        mail-il1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726089AbgGUCwh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jul 2020 22:52:37 -0400
Received: by mail-il1-f196.google.com with SMTP id t27so15106623ill.9;
        Mon, 20 Jul 2020 19:52:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=oZcsez3qREEIJpjTZJF7jgs0A2ONjPfmWyrkj+SbpNY=;
        b=QeYeBpw0U5i/q68yOWLQh3EHgJAF06cwFPVc5p5LVzqSlcSk6t09h4VSV60o8Ao0/m
         ZE+9rIxiWftkciE7DX47YLSa1oTcZvOtpM9PcHsR4E64O79ci7177m4tcSulwfXvAsTI
         49TBzIXn27Yq7pyT6J0PrsLXjVWXMPDLAuU+ZX3SM4uKoXUg7p06cb9mOpBFZxcSRTUQ
         9m5eVnKqt0UntgGzZbirrgg4DYlGjid5yld2+kCjm/Vivn3jwbkXKWwGSMCTm9dVq5Nv
         4ov7q3non9504n2dAgNCKqo8d9HLMhJNtMO2bCltcmr1ahrexlKd0lLLirkm6TZxktMS
         lFzw==
X-Gm-Message-State: AOAM531GtBGtZH0SUzL1mr+ECpfpMADdQU/3D++c1Kb3td5NHL03yQIM
        CgTB0dIIxIX8tji0x+AjBg==
X-Google-Smtp-Source: ABdhPJwFPJnw5YtIomUTFweM1LRZXSEMVUyRi7aOALZBN4QBjHMCIc9Dgsaqb9GNy36JPxiWldgroQ==
X-Received: by 2002:a05:6e02:13e2:: with SMTP id w2mr27006727ilj.9.1595299955841;
        Mon, 20 Jul 2020 19:52:35 -0700 (PDT)
Received: from xps15 ([64.188.179.252])
        by smtp.gmail.com with ESMTPSA id u9sm10338345iom.14.2020.07.20.19.52.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Jul 2020 19:52:35 -0700 (PDT)
Received: (nullmailer pid 3447420 invoked by uid 1000);
        Tue, 21 Jul 2020 02:52:33 -0000
Date:   Mon, 20 Jul 2020 20:52:33 -0600
From:   Rob Herring <robh@kernel.org>
To:     Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
Cc:     Magnus Damm <magnus.damm@gmail.com>,
        Wim Van Sebroeck <wim@linux-watchdog.org>,
        Wolfram Sang <wsa+renesas@sang-engineering.com>,
        "David S. Miller" <davem@davemloft.net>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        linux-renesas-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-spi@vger.kernel.org, Niklas <niklas.soderlund@ragnatech.se>,
        Guenter Roeck <linux@roeck-us.net>,
        linux-watchdog@vger.kernel.org,
        Amit Kucheria <amit.kucheria@verdurent.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Prabhakar <prabhakar.csengg@gmail.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        linux-i2c@vger.kernel.org, devicetree@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>, netdev@vger.kernel.org,
        Mark Brown <broonie@kernel.org>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        Zhang Rui <rui.zhang@intel.com>, linux-can@vger.kernel.org,
        linux-pm@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH 16/20] dt-bindings: watchdog: renesas,wdt: Document
 r8a774e1 support
Message-ID: <20200721025233.GA3447371@bogus>
References: <1594811350-14066-1-git-send-email-prabhakar.mahadev-lad.rj@bp.renesas.com>
 <1594811350-14066-17-git-send-email-prabhakar.mahadev-lad.rj@bp.renesas.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1594811350-14066-17-git-send-email-prabhakar.mahadev-lad.rj@bp.renesas.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 15 Jul 2020 12:09:06 +0100, Lad Prabhakar wrote:
> RZ/G2H (a.k.a. R8A774E1) watchdog implementation is compatible
> with R-Car Gen3, therefore add the relevant documentation.
> 
> Signed-off-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
> ---
>  Documentation/devicetree/bindings/watchdog/renesas,wdt.yaml | 1 +
>  1 file changed, 1 insertion(+)
> 

Acked-by: Rob Herring <robh@kernel.org>
