Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 90CCD634C1B
	for <lists+netdev@lfdr.de>; Wed, 23 Nov 2022 02:08:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235431AbiKWBIW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Nov 2022 20:08:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235443AbiKWBII (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Nov 2022 20:08:08 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C238525F3;
        Tue, 22 Nov 2022 17:08:07 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7BBF9B81DDD;
        Wed, 23 Nov 2022 01:08:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33D46C433B5;
        Wed, 23 Nov 2022 01:08:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669165685;
        bh=qTQ21cFsHNaq36zv0IktHLxNFPVLWU4zT0U5TeMVodI=;
        h=In-Reply-To:References:Subject:From:Cc:To:Date:From;
        b=t1GF3SzcQqEax6YraA5cSidEEBrY+t9CKMvXX1RB2OIOQGszcdQKKFeS2makpGNNh
         e4I4P34f0tkGChp7gb47xQ/AGIz3FYUjxTW2+uMyfIWKA/DqFQbQRgua2C8UYfCQ8H
         LUD9FfLW3L0tpgSJxKD6isoQQEkiA79vLzeZkQWRdmvpXdYAjqtPxd49k0qPQ+Wp30
         DhjwqykE7JWbCdDok81NTKOLoNJQevNoBRbcazCXpjtjCDJPo+kV+m2Jkl2prEKmAW
         W2RbDr28IQOUcmdrWeOyl/WRLLZSR9ClBHGr6O6aJQnPsTDE9+nb7rS/f6xsjvKfLe
         Zz4cyioi1Jocg==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <20221121110615.97962-4-krzysztof.kozlowski@linaro.org>
References: <20221121110615.97962-1-krzysztof.kozlowski@linaro.org> <20221121110615.97962-4-krzysztof.kozlowski@linaro.org>
Subject: Re: [PATCH v2 3/9] dt-bindings: clock: st,stm32mp1-rcc: add proper title
From:   Stephen Boyd <sboyd@kernel.org>
Cc:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Jonathan Cameron <jic23@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Mark Brown <broonie@kernel.org>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Rob Herring <robh+dt@kernel.org>,
        Sebastian Reichel <sre@kernel.org>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Vinod Koul <vkoul@kernel.org>,
        Viresh Kumar <vireshk@kernel.org>, alsa-devel@alsa-project.org,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-arm-msm@vger.kernel.org, linux-can@vger.kernel.org,
        linux-clk@vger.kernel.org, linux-gpio@vger.kernel.org,
        linux-iio@vger.kernel.org, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-leds@vger.kernel.org,
        linux-media@vger.kernel.org, linux-mips@vger.kernel.org,
        linux-mmc@vger.kernel.org, linux-mtd@lists.infradead.org,
        linux-pci@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-pwm@vger.kernel.org, linux-riscv@lists.infradead.org,
        linux-rtc@vger.kernel.org, linux-serial@vger.kernel.org,
        linux-spi@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-watchdog@vger.kernel.org, netdev@vger.kernel.org,
        virtualization@lists.linux-foundation.org
Date:   Tue, 22 Nov 2022 17:08:03 -0800
User-Agent: alot/0.10
Message-Id: <20221123010805.33D46C433B5@smtp.kernel.org>
X-Spam-Status: No, score=-6.7 required=5.0 tests=BAYES_00,DKIM_INVALID,
        DKIM_SIGNED,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Quoting Krzysztof Kozlowski (2022-11-21 03:06:09)
> Add device name in the title, because "Reset Clock Controller" sounds
> too generic.
>=20
> Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
> Acked-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
> ---

Acked-by: Stephen Boyd <sboyd@kernel.org>
