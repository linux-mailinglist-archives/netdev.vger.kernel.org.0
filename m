Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F2DB11AFD09
	for <lists+netdev@lfdr.de>; Sun, 19 Apr 2020 20:14:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726741AbgDSSOl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Apr 2020 14:14:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:37082 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726440AbgDSSOk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 19 Apr 2020 14:14:40 -0400
Received: from kernel.org (unknown [104.132.0.74])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3440920771;
        Sun, 19 Apr 2020 18:14:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587320079;
        bh=bOt9BTn/I9BtpLW6MYPux7kH7zXf1KQ4OwttSbOUgxw=;
        h=In-Reply-To:References:Subject:From:Cc:To:Date:From;
        b=F96kxGnwb5hbRo2uaveExMkh4pG5tmsfXC/X4f7LcIR9NVVk3+CXqwPimCRGIZsLq
         200DZ+NlYkyxPrNFkbuYootDCzDqqWFu0hJkAVPZpKUAgkDDPBPfI6mIZvHi8k+VtM
         aJNXnDOzYimf/GSU7Z8wIQIZEF7kJxvbDOxdjZqA=
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <20200416005549.9683-2-robh@kernel.org>
References: <20200416005549.9683-1-robh@kernel.org> <20200416005549.9683-2-robh@kernel.org>
Subject: Re: [PATCH 2/2] dt-bindings: Remove cases of 'allOf' containing a '$ref'
From:   Stephen Boyd <sboyd@kernel.org>
Cc:     Krzysztof Kozlowski <krzk@kernel.org>,
        Maxime Ripard <mripard@kernel.org>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Thierry Reding <thierry.reding@gmail.com>,
        Sam Ravnborg <sam@ravnborg.org>, Vinod Koul <vkoul@kernel.org>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Jonathan Cameron <jic23@kernel.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Jacek Anaszewski <jacek.anaszewski@gmail.com>,
        Pavel Machek <pavel@ucw.cz>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Lee Jones <lee.jones@linaro.org>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Heiko Stuebner <heiko@sntech.de>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Fabio Estevam <festevam@gmail.com>,
        Mark Brown <broonie@kernel.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Amit Kucheria <amit.kucheria@linaro.org>,
        Danie l Lezcano <daniel.lezcano@linaro.org>,
        linux-arm-kernel@lists.infradead.org, linux-clk@vger.kernel.org,
        dri-devel@lists.freedesktop.org, linux-i2c@vger.kernel.org,
        linux-hwmon@vger.kernel.org, linux-iio@vger.kernel.org,
        linux-input@vger.kernel.org, linux-leds@vger.kernel.org,
        linux-media@vger.kernel.org, linux-mmc@vger.kernel.org,
        linux-mtd@lists.infradead.org, linux-can@vger.kernel.org,
        netdev@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-gpio@vger.kernel.org, linux-pwm@vger.kernel.org,
        linux-remoteproc@vger.kernel.org, linux-riscv@lists.infradead.org,
        linux-rtc@vger.kernel.org, linux-serial@vger.kernel.org,
        alsa-devel@alsa-project.org, linux-spi@vger.kernel.org
To:     Rob Herring <robh@kernel.org>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date:   Sun, 19 Apr 2020 11:14:38 -0700
Message-ID: <158732007844.132238.3936257450130949073@swboyd.mtv.corp.google.com>
User-Agent: alot/0.9
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Quoting Rob Herring (2020-04-15 17:55:49)
> json-schema versions draft7 and earlier have a weird behavior in that
> any keywords combined with a '$ref' are ignored (silently). The correct
> form was to put a '$ref' under an 'allOf'. This behavior is now changed
> in the 2019-09 json-schema spec and '$ref' can be mixed with other
> keywords. The json-schema library doesn't yet support this, but the
> tooling now does a fixup for this and either way works.
>=20
> This has been a constant source of review comments, so let's change this
> treewide so everyone copies the simpler syntax.
>=20
> Signed-off-by: Rob Herring <robh@kernel.org>
> ---
>  .../bindings/clock/fixed-factor-clock.yaml    |   5 +-

Reviewed-by: Stephen Boyd <sboyd@kernel.org> # clock
