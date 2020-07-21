Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB8C022763B
	for <lists+netdev@lfdr.de>; Tue, 21 Jul 2020 04:53:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728690AbgGUCxI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jul 2020 22:53:08 -0400
Received: from mail-io1-f67.google.com ([209.85.166.67]:42004 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728582AbgGUCwt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jul 2020 22:52:49 -0400
Received: by mail-io1-f67.google.com with SMTP id c16so19795554ioi.9;
        Mon, 20 Jul 2020 19:52:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=c+0taXNaECn7y2VlannbsmBiH6MUPiUSHkj3B94qbQA=;
        b=AqXPs4UQIoOHHFd+ONzeggBlNl7gwq9PLB8u4VAoBE1DLPfsg6LsVU/j929dTIc466
         /ThFRFGc4KTaDnxawPo7WAdefFtuh/B1Nkf7Z3E4CUiplBMEMJF8pNAfp/nI/vAMUWSW
         he3UDWALa4142nzhtug0bK53E4D+cMcHnMWGsn+1R2wXGjoNr4Q5TREoPbp8KXBwlyoo
         kT8+mCmKsdzi8A7gjPqBmeb+RfCFHIGXerh3xcPm1nCfmqVlPBj9RAama4x/9A0WZhdO
         HOJHIOiXmEr9IRFSUwpDEJsid6+Drj4lHcIp6RsbMuAJQccao3MFHkX7Fo9LA4BrMxfe
         APTQ==
X-Gm-Message-State: AOAM532aE+N7fU24EIAQnYmpCatvmOgGRFwT8sGDp0OgT48fQty+wMc0
        7oUgsWXnoxjp/pZTI0kBBw==
X-Google-Smtp-Source: ABdhPJwW8M6ulL8WoWoT/i8WmaS8SVzClzUmmha58DjuQhCaHLUWm7ewaHop1oeHI/wnhpm1eKLaHg==
X-Received: by 2002:a6b:8b11:: with SMTP id n17mr25722405iod.155.1595299967660;
        Mon, 20 Jul 2020 19:52:47 -0700 (PDT)
Received: from xps15 ([64.188.179.252])
        by smtp.gmail.com with ESMTPSA id i12sm10314120ioi.48.2020.07.20.19.52.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Jul 2020 19:52:46 -0700 (PDT)
Received: (nullmailer pid 3447780 invoked by uid 1000);
        Tue, 21 Jul 2020 02:52:45 -0000
Date:   Mon, 20 Jul 2020 20:52:45 -0600
From:   Rob Herring <robh@kernel.org>
To:     Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
Cc:     linux-renesas-soc@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Zhang Rui <rui.zhang@intel.com>,
        Wim Van Sebroeck <wim@linux-watchdog.org>,
        "David S. Miller" <davem@davemloft.net>,
        Mark Brown <broonie@kernel.org>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Prabhakar <prabhakar.csengg@gmail.com>,
        Wolfram Sang <wsa+renesas@sang-engineering.com>,
        linux-watchdog@vger.kernel.org, linux-spi@vger.kernel.org,
        Magnus Damm <magnus.damm@gmail.com>,
        Amit Kucheria <amit.kucheria@verdurent.com>,
        Guenter Roeck <linux@roeck-us.net>, linux-i2c@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-can@vger.kernel.org,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Marc Kleine-Budde <mkl@pengutronix.de>, netdev@vger.kernel.org,
        Niklas <niklas.soderlund@ragnatech.se>,
        Jakub Kicinski <kuba@kernel.org>, devicetree@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 18/20] dt-bindings: can: rcar_can: Document r8a774e1
 support
Message-ID: <20200721025245.GA3447733@bogus>
References: <1594811350-14066-1-git-send-email-prabhakar.mahadev-lad.rj@bp.renesas.com>
 <1594811350-14066-19-git-send-email-prabhakar.mahadev-lad.rj@bp.renesas.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1594811350-14066-19-git-send-email-prabhakar.mahadev-lad.rj@bp.renesas.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 15 Jul 2020 12:09:08 +0100, Lad Prabhakar wrote:
> Document SoC specific bindings for RZ/G2H (R8A774E1) SoC.
> 
> Signed-off-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
> Reviewed-by: Marian-Cristian Rotariu <marian-cristian.rotariu.rb@bp.renesas.com>
> ---
>  Documentation/devicetree/bindings/net/can/rcar_can.txt | 1 +
>  1 file changed, 1 insertion(+)
> 

Acked-by: Rob Herring <robh@kernel.org>
