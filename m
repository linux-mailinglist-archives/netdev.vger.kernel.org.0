Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC8BD2275F9
	for <lists+netdev@lfdr.de>; Tue, 21 Jul 2020 04:44:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728567AbgGUCoe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jul 2020 22:44:34 -0400
Received: from mail-io1-f65.google.com ([209.85.166.65]:41148 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725862AbgGUCoc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jul 2020 22:44:32 -0400
Received: by mail-io1-f65.google.com with SMTP id p205so19785560iod.8;
        Mon, 20 Jul 2020 19:44:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=uu4ySp6wQswYUN09uhNhXA6ISKHmvyUgPMvA+Jw19J8=;
        b=iXQL32Sin6T0Xwj7yeNovgTFDf5ynpFus9OCmBsnLODwPCQrONCGF0n3QGhi/qiH0S
         q17xvf6uIHqQ7a8tPKpiYychr6EtZ37LtDJT3FbtGVOtT+/izuw1gZ6GGzegB/ppqY/g
         UYiGdyvvvFK/gBpWDZvXUFb6WhKlw+qlq+ehObOBb2xW5kWodEJLsuNff7N5OXU0eKVk
         +YpBPcwGHlEVpYCi2F0zsVDxbhQR8cBK7kdVEm2+LL+GBJ3DTCvTs5AEB5Z/Frrw3vO/
         v/NAoxfdBs0Nqb61J5InQkE8DJO1kbJXel6gbUHE1Tw5J+8eJK/F+kDH1gJLnYHJoUTj
         amTQ==
X-Gm-Message-State: AOAM530UTOOAFsiw6lHY9VPhHffykupR4n8wfki+UaTcmRSvya5a9CiI
        OJ9779Lb+YK1WdxSNBjZnA==
X-Google-Smtp-Source: ABdhPJxyYEo1LE7MHZcXEB8IcCuSASeNEW+mjtXixCFsA2P5QaMGVUpEFpU+OT+zQhQZO0CSHbIeWg==
X-Received: by 2002:a02:cb92:: with SMTP id u18mr29647110jap.143.1595299471668;
        Mon, 20 Jul 2020 19:44:31 -0700 (PDT)
Received: from xps15 ([64.188.179.252])
        by smtp.gmail.com with ESMTPSA id m5sm9812187ilg.18.2020.07.20.19.44.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Jul 2020 19:44:31 -0700 (PDT)
Received: (nullmailer pid 3436595 invoked by uid 1000);
        Tue, 21 Jul 2020 02:44:28 -0000
Date:   Mon, 20 Jul 2020 20:44:28 -0600
From:   Rob Herring <robh@kernel.org>
To:     Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
Cc:     linux-spi@vger.kernel.org, Zhang Rui <rui.zhang@intel.com>,
        Niklas <niklas.soderlund@ragnatech.se>,
        Wolfgang Grandegger <wg@grandegger.com>,
        linux-watchdog@vger.kernel.org,
        Wim Van Sebroeck <wim@linux-watchdog.org>,
        linux-can@vger.kernel.org, linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        linux-pm@vger.kernel.org, linux-i2c@vger.kernel.org,
        Mark Brown <broonie@kernel.org>,
        linux-renesas-soc@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Guenter Roeck <linux@roeck-us.net>,
        Magnus Damm <magnus.damm@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, devicetree@vger.kernel.org,
        Amit Kucheria <amit.kucheria@verdurent.com>,
        Rob Herring <robh+dt@kernel.org>,
        Marc Kleine-Budde <mkl@pengutronix.de>, netdev@vger.kernel.org,
        Prabhakar <prabhakar.csengg@gmail.com>,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Wolfram Sang <wsa+renesas@sang-engineering.com>
Subject: Re: [PATCH 12/20] dt-bindings: i2c: renesas,iic: Document r8a774e1
 support
Message-ID: <20200721024428.GA3436541@bogus>
References: <1594811350-14066-1-git-send-email-prabhakar.mahadev-lad.rj@bp.renesas.com>
 <1594811350-14066-13-git-send-email-prabhakar.mahadev-lad.rj@bp.renesas.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1594811350-14066-13-git-send-email-prabhakar.mahadev-lad.rj@bp.renesas.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 15 Jul 2020 12:09:02 +0100, Lad Prabhakar wrote:
> Document IIC controller for RZ/G2H (R8A774E1) SoC, which is compatible
> with R-Car Gen3 SoC family.
> 
> Signed-off-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
> Reviewed-by: Marian-Cristian Rotariu <marian-cristian.rotariu.rb@bp.renesas.com>
> ---
>  Documentation/devicetree/bindings/i2c/renesas,iic.txt | 1 +
>  1 file changed, 1 insertion(+)
> 

Acked-by: Rob Herring <robh@kernel.org>
