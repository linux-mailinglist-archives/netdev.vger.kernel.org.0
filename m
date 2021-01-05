Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 423682EB479
	for <lists+netdev@lfdr.de>; Tue,  5 Jan 2021 21:50:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729907AbhAEUtP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jan 2021 15:49:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729094AbhAEUtK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Jan 2021 15:49:10 -0500
Received: from mail-lf1-x12b.google.com (mail-lf1-x12b.google.com [IPv6:2a00:1450:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD69EC061796;
        Tue,  5 Jan 2021 12:48:29 -0800 (PST)
Received: by mail-lf1-x12b.google.com with SMTP id o13so1666280lfr.3;
        Tue, 05 Jan 2021 12:48:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:reply-to:from:date:message-id
         :subject:to:cc;
        bh=VI6nFNhOrDBsKOeartd6J0bcnx10OA5inX4UBRpL4qE=;
        b=XMzvAK1uTDP9sqD7pLv4Wz7WB5ahyaA4m6Kusb5//KKj6ORucbf4DEkHedVG2WYchx
         ww5E+S2pe/MVFqDwCWn3GDiS2f5riKTPoV75h71RVrW0K2vBiy9ckj/U7dA9PWNjyCNI
         nX5bomPKCcbVJeOgp/Cj7QeOBmzBoXkvbgT+W8lDuSsHgW8SMCpsK5rlGY82XsKP7qkx
         a29IAV41Ls1xim5un7jcVMha0ymLBu7etMhtRuauiNm4Zo6NPbxuUdxGaFB5dXcGICKr
         V9gREmCqoUjAr+3BJU51evd6QVFkDSbGIsK3A3GwKvAN8OhPsBEmC8Moy5N8LCKzSIDI
         qz8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:reply-to
         :from:date:message-id:subject:to:cc;
        bh=VI6nFNhOrDBsKOeartd6J0bcnx10OA5inX4UBRpL4qE=;
        b=FG6SNthz8P94I2FoXGzya5sRVgOPbypbkHtVdcNSFG+DgmibLQoPKra/TvrVh2Vdv2
         leFN9mNc/tZ6Z4UUKldJnV85Us0eDPB13bP3XeE9gH/lmc3DkevR11UZd9LSJoXTffDe
         RyicTBGoSPEGcw2FX1g47y0pym2m16A6Qx0hlHeuo0U5WFKzIdNGhGe/qLvRnC93YuOh
         Eydg2fpeDYwxsB8C0dPUirx7huBeiVBTxGmuuB6L3ChsVSv84N7XjF602qo0pRsH0O6q
         hli3IB4JvZYYOMjNrjEOHG/depgPQofXFEsga2m4M0bdWml3wvU2pnUloW3Zd9iOnjsZ
         ux9g==
X-Gm-Message-State: AOAM5305RrdE0AAtjoTNIhMuTR3cWMeBHvXkoyTtwcA7X2xnyV0sBVOx
        5IzuPqY/Y3bZU7VBY3YC8bLFZ/Ojoxos58UUjcE=
X-Google-Smtp-Source: ABdhPJxu0obS2EF+VNsGTCaRCOLzZxvocXJO+DOkx1q/eD1CrMCNDr6ayRfy6f/783TFKHGmdZ4OqMWe5HwKjoHK0HI=
X-Received: by 2002:a2e:8084:: with SMTP id i4mr635086ljg.291.1609879708350;
 Tue, 05 Jan 2021 12:48:28 -0800 (PST)
MIME-Version: 1.0
References: <20210104230253.2805217-1-robh@kernel.org>
In-Reply-To: <20210104230253.2805217-1-robh@kernel.org>
Reply-To: cwchoi00@gmail.com
From:   Chanwoo Choi <cwchoi00@gmail.com>
Date:   Wed, 6 Jan 2021 05:47:51 +0900
Message-ID: <CAGTfZH11n8cRbrNB6XbzCydR4387d7V-gmRWou8hFFXbFBgvHQ@mail.gmail.com>
Subject: Re: [PATCH] dt-bindings: Add missing array size constraints
To:     Rob Herring <robh@kernel.org>
Cc:     devicetree <devicetree@vger.kernel.org>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        linux-usb@vger.kernel.org, linux-iio@vger.kernel.org,
        linux-remoteproc@vger.kernel.org, alsa-devel@alsa-project.org,
        dri-devel <dri-devel@lists.freedesktop.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        linux-ide@vger.kernel.org,
        Thierry Reding <thierry.reding@gmail.com>,
        netdev@vger.kernel.org, linux-clk@vger.kernel.org,
        Chanwoo Choi <cw00.choi@samsung.com>,
        Marc Zyngier <maz@kernel.org>, linux-riscv@lists.infradead.org,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>,
        Chen-Yu Tsai <wens@csie.org>,
        MyungJoo Ham <myungjoo.ham@samsung.com>,
        linux-serial@vger.kernel.org, linux-input@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>, linux-media@vger.kernel.org,
        Ohad Ben-Cohen <ohad@wizery.com>,
        Linux PM list <linux-pm@vger.kernel.org>,
        linux-gpio@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Jens Axboe <axboe@kernel.dk>, Stephen Boyd <sboyd@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        linux-mmc@vger.kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-spi@vger.kernel.org, Sebastian Reichel <sre@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jonathan Cameron <jic23@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Rob,

On Tue, Jan 5, 2021 at 8:03 AM Rob Herring <robh@kernel.org> wrote:
>
> DT properties which can have multiple entries need to specify what the
> entries are and define how many entries there can be. In the case of
> only a single entry, just 'maxItems: 1' is sufficient.
>
> Add the missing entry constraints. These were found with a modified
> meta-schema. Unfortunately, there are a few cases where the size
> constraints are not defined such as common bindings, so the meta-schema
> can't be part of the normal checks.
>
> Cc: Jens Axboe <axboe@kernel.dk>
> Cc: Stephen Boyd <sboyd@kernel.org>
> Cc: Thierry Reding <thierry.reding@gmail.com>
> Cc: MyungJoo Ham <myungjoo.ham@samsung.com>
> Cc: Chanwoo Choi <cw00.choi@samsung.com>
> Cc: Linus Walleij <linus.walleij@linaro.org>
> Cc: Bartosz Golaszewski <bgolaszewski@baylibre.com>
> Cc: Jonathan Cameron <jic23@kernel.org>
> Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Marc Zyngier <maz@kernel.org>
> Cc: Mauro Carvalho Chehab <mchehab@kernel.org>
> Cc: Chen-Yu Tsai <wens@csie.org>
> Cc: Ulf Hansson <ulf.hansson@linaro.org>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Jakub Kicinski <kuba@kernel.org>
> Cc: Sebastian Reichel <sre@kernel.org>
> Cc: Ohad Ben-Cohen <ohad@wizery.com>
> Cc: Bjorn Andersson <bjorn.andersson@linaro.org>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Signed-off-by: Rob Herring <robh@kernel.org>
> ---
> Cc: linux-arm-kernel@lists.infradead.org
> Cc: linux-ide@vger.kernel.org
> Cc: linux-clk@vger.kernel.org
> Cc: dri-devel@lists.freedesktop.org
> Cc: linux-gpio@vger.kernel.org
> Cc: linux-iio@vger.kernel.org
> Cc: linux-input@vger.kernel.org
> Cc: linux-media@vger.kernel.org
> Cc: linux-mmc@vger.kernel.org
> Cc: netdev@vger.kernel.org
> Cc: linux-pm@vger.kernel.org
> Cc: linux-remoteproc@vger.kernel.org
> Cc: linux-riscv@lists.infradead.org
> Cc: linux-serial@vger.kernel.org
> Cc: alsa-devel@alsa-project.org
> Cc: linux-spi@vger.kernel.org
> Cc: linux-usb@vger.kernel.org
> ---
>  .../socionext,uniphier-system-cache.yaml      |  4 ++--
>  .../bindings/ata/sata_highbank.yaml           |  1 +
>  .../bindings/clock/canaan,k210-clk.yaml       |  1 +
>  .../bindings/display/brcm,bcm2711-hdmi.yaml   |  1 +
>  .../bindings/display/brcm,bcm2835-hdmi.yaml   |  1 +
>  .../display/panel/jdi,lt070me05000.yaml       |  1 +
>  .../display/panel/mantix,mlaf057we51-x.yaml   |  3 ++-
>  .../display/panel/novatek,nt36672a.yaml       |  1 +
>  .../devicetree/bindings/dsp/fsl,dsp.yaml      |  2 +-
>  .../devicetree/bindings/eeprom/at25.yaml      |  3 +--
>  .../bindings/extcon/extcon-ptn5150.yaml       |  2 ++

For extcon part,
Acked-by: Chanwoo Choi <cw00.choi@samsung.com>

(snip)

Best Regards,
Chanwoo Choi
