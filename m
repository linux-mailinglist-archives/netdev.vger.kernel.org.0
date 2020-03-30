Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 960981974EC
	for <lists+netdev@lfdr.de>; Mon, 30 Mar 2020 09:11:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729420AbgC3HLH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Mar 2020 03:11:07 -0400
Received: from conssluserg-06.nifty.com ([210.131.2.91]:46507 "EHLO
        conssluserg-06.nifty.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729150AbgC3HLH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Mar 2020 03:11:07 -0400
Received: from mail-vk1-f173.google.com (mail-vk1-f173.google.com [209.85.221.173]) (authenticated)
        by conssluserg-06.nifty.com with ESMTP id 02U7Av80019091;
        Mon, 30 Mar 2020 16:10:58 +0900
DKIM-Filter: OpenDKIM Filter v2.10.3 conssluserg-06.nifty.com 02U7Av80019091
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nifty.com;
        s=dec2015msa; t=1585552259;
        bh=hkMe26g7xlvZHHpLSXHK4NtsfOWPZ3tdB27BX4Gdox4=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=KcBjhsrL3dR1mZBfET/9TKUG3Daz3RdGt09Vw88Y0YifetOYyh51xxQuPG+592DtH
         pFD/CO1Uz9mbzrlhLsGxyA9LIeKZxQV5JWMNTr3zAUPp/UNFC9xsfpSFLKmSnqpbVi
         KvGBO/fpymKKpXGF51W9+pp48ZX3tcSz8n+L0IMq+80fOal/Z3reDXdedCEK2jpq9t
         ZaAnXDROMrj+BP2GRX1zhtxD+Xkh94NmVI1aUp5NoYk9oPnwKjnxG8FwLUREXbNfCc
         6kGzkoTJ/wqDKmu97f3h+oWVDyt0bnUTb6G3aaLggK3fY//mDPC7DDsHNA2itSmKHS
         IRfBEQUPNsiGg==
X-Nifty-SrcIP: [209.85.221.173]
Received: by mail-vk1-f173.google.com with SMTP id n128so4386036vke.5;
        Mon, 30 Mar 2020 00:10:58 -0700 (PDT)
X-Gm-Message-State: AGi0PuYyqi+Jqqf0vNqIG0UHCnkTbAhwoH+gdkE6en4feAPwTOi1AeBg
        6SNSy4sbA3RjhYi0kM4uSRxQdCChezoSNPT7Oc4=
X-Google-Smtp-Source: APiQypLNZL0F1SjmrpxCYWMM92Tc2B289mmJ4nqnInP/lERMnXKF0z9Hs/o7lbsUDIM38rMhrwxOtOM94wAMTS6itNI=
X-Received: by 2002:a1f:3649:: with SMTP id d70mr6296693vka.12.1585552257254;
 Mon, 30 Mar 2020 00:10:57 -0700 (PDT)
MIME-Version: 1.0
References: <20200325220542.19189-1-robh@kernel.org> <20200325220542.19189-4-robh@kernel.org>
In-Reply-To: <20200325220542.19189-4-robh@kernel.org>
From:   Masahiro Yamada <masahiroy@kernel.org>
Date:   Mon, 30 Mar 2020 16:10:21 +0900
X-Gmail-Original-Message-ID: <CAK7LNASHkBoOP_uGXLuO-UT1JL-rN3od_L+F4cB0SRPCzQCyKA@mail.gmail.com>
Message-ID: <CAK7LNASHkBoOP_uGXLuO-UT1JL-rN3od_L+F4cB0SRPCzQCyKA@mail.gmail.com>
Subject: Re: [PATCH 3/4] dt-bindings: Clean-up schema errors due to missing
 'addtionalProperties: false'
To:     Rob Herring <robh@kernel.org>
Cc:     DTML <devicetree@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Brian Masney <masneyb@onstation.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        "David S. Miller" <davem@davemloft.net>,
        Guillaume La Roque <glaroque@baylibre.com>,
        Hartmut Knaack <knaack.h@gmx.de>,
        Jonathan Cameron <jic23@kernel.org>,
        Kevin Hilman <khilman@baylibre.com>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Lee Jones <lee.jones@linaro.org>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Mark Brown <broonie@kernel.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Michael Hennerich <michael.hennerich@analog.com>,
        Neil Armstrong <narmstrong@baylibre.com>,
        Peter Meerwald-Stadler <pmeerw@pmeerw.net>,
        Stephen Boyd <sboyd@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Zhang Rui <rui.zhang@intel.com>,
        dri-devel <dri-devel@lists.freedesktop.org>,
        linux-amlogic@lists.infradead.org,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        linux-arm-msm <linux-arm-msm@vger.kernel.org>,
        linux-clk <linux-clk@vger.kernel.org>,
        "open list:GPIO SUBSYSTEM" <linux-gpio@vger.kernel.org>,
        linux-iio@vger.kernel.org,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux PM mailing list <linux-pm@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 26, 2020 at 7:06 AM Rob Herring <robh@kernel.org> wrote:
>
> Numerous schemas are missing 'additionalProperties: false' statements which
> ensures a binding doesn't have any extra undocumented properties or child
> nodes. Fixing this reveals various missing properties, so let's fix all
> those occurrences.
>
> Cc: Stephen Boyd <sboyd@kernel.org>
> Cc: Linus Walleij <linus.walleij@linaro.org>
> Cc: Bartosz Golaszewski <bgolaszewski@baylibre.com>
> Cc: Masahiro Yamada <yamada.masahiro@socionext.com>
> Cc: Jonathan Cameron <jic23@kernel.org>
> Cc: Hartmut Knaack <knaack.h@gmx.de>
> Cc: Lars-Peter Clausen <lars@metafoo.de>
> Cc: Peter Meerwald-Stadler <pmeerw@pmeerw.net>
> Cc: Neil Armstrong <narmstrong@baylibre.com>
> Cc: Mauro Carvalho Chehab <mchehab@kernel.org>
> Cc: Kevin Hilman <khilman@baylibre.com>
> Cc: Lee Jones <lee.jones@linaro.org>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Liam Girdwood <lgirdwood@gmail.com>
> Cc: Mark Brown <broonie@kernel.org>
> Cc: Guillaume La Roque <glaroque@baylibre.com>
> Cc: Zhang Rui <rui.zhang@intel.com>
> Cc: Daniel Lezcano <daniel.lezcano@linaro.org>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: linux-clk@vger.kernel.org
> Cc: linux-gpio@vger.kernel.org
> Cc: linux-arm-kernel@lists.infradead.org
> Cc: dri-devel@lists.freedesktop.org
> Cc: linux-iio@vger.kernel.org
> Cc: linux-media@vger.kernel.org
> Cc: linux-amlogic@lists.infradead.org
> Cc: netdev@vger.kernel.org
> Cc: linux-pm@vger.kernel.org
> Signed-off-by: Rob Herring <robh@kernel.org>
> ---



>  .../gpio/socionext,uniphier-gpio.yaml         |  2 ++


You may have already queue this up, but just in case.

Acked-by: Masahiro Yamada <yamada.masahiro@socionext.com>


-- 
Best Regards
Masahiro Yamada
