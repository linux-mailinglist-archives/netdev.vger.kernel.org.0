Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C58431B21CA
	for <lists+netdev@lfdr.de>; Tue, 21 Apr 2020 10:38:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728335AbgDUIhz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Apr 2020 04:37:55 -0400
Received: from mail-yb1-f195.google.com ([209.85.219.195]:36808 "EHLO
        mail-yb1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726018AbgDUIhx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Apr 2020 04:37:53 -0400
Received: by mail-yb1-f195.google.com with SMTP id n188so6954754ybc.3;
        Tue, 21 Apr 2020 01:37:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=v/3+VZnCM3ynIiT8UZUwJeZ01xBwJWokxUvrEQAQiYo=;
        b=bFiWT9gfbZn/9gjObOQOTbFNwt54kCMcvWNu0aIy4nTdD0qM6djPi68yql1KO2b07h
         LGK4eLtd1PGPIfE9J8zMbsVtGkDe+tFmG22BrgKrsIHXNgr86W2zzCr59avhi5FBoW21
         1gO2ZVUjUTgTShYVC7QUEzdTIg1EgrWB3JqFgMPbBF2/jZiwTypRtcKVFNmc4kOnKCr8
         FtzqnA+IM0nF71xpUFyk1w/9A1qMI12Iy8ZyRoEu6yK/RI4dAMTyaMGpu5jptGt8Cjvj
         Ag6JRbfPkAtA+YQD46JxdgcGMytJjNJA33HggkiOv8jlsFISUmEt/kzTt9AjOEHlJaV6
         dDYw==
X-Gm-Message-State: AGi0Pub+120rqvy724HfOey6uUx4SsczN1QYhLSmtSz9vHbw5jM59PKt
        UWgD54nL//XYGYGf6JvviSW/9mWHv9afCNJtf7+3Lki7
X-Google-Smtp-Source: APiQypIaHQB7wPhEVieQJfu8de8zwg12nMpx1Ox449Qw7TthaEYyLuX1tCmdRhbmN76uN/LTV2imJSE1sR5SRTbdF3M=
X-Received: by 2002:a25:cec8:: with SMTP id x191mr24951591ybe.39.1587458272417;
 Tue, 21 Apr 2020 01:37:52 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1587058078.git.nicolas.ferre@microchip.com>
 <56bb7a742093cec160c4465c808778a14b2607e7.1587058078.git.nicolas.ferre@microchip.com>
 <61762f4b-03fa-5484-334e-8515eed485e2@microchip.com> <8fcf4a8a-362c-a71f-c99e-be9500db7371@microchip.com>
In-Reply-To: <8fcf4a8a-362c-a71f-c99e-be9500db7371@microchip.com>
From:   Harini Katakam <harinik@xilinx.com>
Date:   Tue, 21 Apr 2020 14:07:41 +0530
Message-ID: <CAFcVECL-uYF2dpOZvAeGpot4wstT3551QKuYm0TCTXv_SxsyXA@mail.gmail.com>
Subject: Re: [PATCH 4/5] net: macb: WoL support for GEM type of Ethernet controller
To:     Nicolas Ferre <Nicolas.Ferre@microchip.com>
Cc:     linux-arm-kernel@lists.infradead.org, netdev@vger.kernel.org,
        Claudiu Beznea <Claudiu.Beznea@microchip.com>,
        Harini Katakam <harini.katakam@xilinx.com>,
        Florian Fainelli <f.fainelli@gmail.com>, linux@armlinux.org.uk,
        Andrew Lunn <andrew@lunn.ch>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Sergio Prado <sergio.prado@e-labworks.com>,
        Parshuram Raju Thombare <pthombar@cadence.com>,
        antoine.tenart@bootlin.com, linux-kernel@vger.kernel.org,
        Michal Simek <michal.simek@xilinx.com>,
        David Miller <davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 21, 2020 at 1:55 PM <Nicolas.Ferre@microchip.com> wrote:
<snip>
> I've reviewed this series to fix this last issues. It's was a
> combination of runtime_pm not handled properly and a mix of
> netif_carrier_* call with phylink calls not well positioned nor balanced
> between suspend and resume.
>
> I have a v2 series that I'm preparing for today: Harini, I prefer to
> post it now so it could avoid that you hit the same issues as me while
> testing on your platform.

OK thanks Nicolas.

Regards,
Harini
