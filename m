Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3562F4D27E
	for <lists+netdev@lfdr.de>; Thu, 20 Jun 2019 17:54:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727144AbfFTPyF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Jun 2019 11:54:05 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:46613 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726562AbfFTPyF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Jun 2019 11:54:05 -0400
Received: by mail-wr1-f68.google.com with SMTP id n4so3521282wrw.13;
        Thu, 20 Jun 2019 08:54:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=q2BZSgLwxymATwcz5mZeMXxgTAlopkINs/PMNefIvUU=;
        b=V44Esc+XKQSOQjNnaxw2MmMTKdJaJKQDxq17rl0lBAneRfZN1f8XeL5yyjyQyrOSOa
         FOfj2kwyNRS6HcW9PAPst6IjjKKkU3xxvrLkESfhmQZAPNvN6EkfJnAbjkY3PoX1v35I
         0monHG7qNbVh+PckIESPcARdhbOow9+mlJxI6YjsIIqmz532OE0y3GP28s3Ogpzt4z6/
         /n/pZlnjpYEvB1tlUCbEZawOHnoFxPDA+q5gLVoWxYEuh5iN8f5oZEqewN4ttmGHe0P3
         XoQRJJUakLeW6GigtSRWsIH0o1zAzuVucDEgR2zJlzBu4kv0rX7gVRK2zoVE0SSAu+rV
         +ajg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=q2BZSgLwxymATwcz5mZeMXxgTAlopkINs/PMNefIvUU=;
        b=W1a5DR7QWla8dMqL7ZJkF2lwXYFaTo2zPESK+khtRq6oIn86dz/GmeM9mRifljfJsv
         RQa1HcktTBD8+JRdR8yNqeVkxlLnYdD9Y9+2tusDRSSTFo3wUdAjb874ZnZ3lDu640OG
         CJ4+lCgGh6/sTy+evNMbcfoMwjY5SoWze0bcGCd1CJ1gU9LGY24kMnFwkiZa4u897dWA
         xPuvW3o7sx+lz3OZsmnszDdLUlh1cA8ymj7MLwMzHH88ouOxn6F/nXVF1aD91o37ndwn
         xs3xy4BgQSV+iuGShBD/yHktxdmMO0MYFkBET8R1+L+nLBDo2uxppDNmGxxvzIVXspIP
         iSYA==
X-Gm-Message-State: APjAAAUhD40wkoY+aPoNRLkloVG9xDAF+PDl+F4gKy5dYgwoEw3SUYJ4
        9WTMQXzWkPHLggu3tteHNCgr2Y9tdEU=
X-Google-Smtp-Source: APXvYqwjinCWK/aSKbDmwODZdByqPtonNAHy81M6XwA7AeZJB8EfRvgjyd6heFibzYj9+zCcNldc5Q==
X-Received: by 2002:adf:b1ca:: with SMTP id r10mr15094293wra.156.1561046042286;
        Thu, 20 Jun 2019 08:54:02 -0700 (PDT)
Received: from jernej-laptop.localnet (cpe-86-58-52-202.static.triera.net. [86.58.52.202])
        by smtp.gmail.com with ESMTPSA id o13sm34914608wra.92.2019.06.20.08.53.59
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 20 Jun 2019 08:54:00 -0700 (PDT)
From:   Jernej =?utf-8?B?xaBrcmFiZWM=?= <jernej.skrabec@gmail.com>
To:     linux-sunxi@googlegroups.com, megous@megous.com
Cc:     Maxime Ripard <maxime.ripard@bootlin.com>,
        Chen-Yu Tsai <wens@csie.org>, Rob Herring <robh+dt@kernel.org>,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>,
        Mark Rutland <mark.rutland@arm.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        dri-devel@lists.freedesktop.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com
Subject: Re: [linux-sunxi] [PATCH v7 0/6] Add support for Orange Pi 3
Date:   Thu, 20 Jun 2019 17:53:58 +0200
Message-ID: <2263144.KN5DhQ2VKD@jernej-laptop>
In-Reply-To: <20190620134748.17866-1-megous@megous.com>
References: <20190620134748.17866-1-megous@megous.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi!

Dne =C4=8Detrtek, 20. junij 2019 ob 15:47:42 CEST je megous via linux-sunxi=
=20
napisal(a):
> From: Ondrej Jirman <megous@megous.com>
>=20
> This series implements support for Xunlong Orange Pi 3 board.
>=20
> - ethernet support (patches 1-3)

Correct me if I'm wrong, but patches 1-2 aren't strictly necessary for=20
OrangePi 3, right? H6 DTSI already has emac node with dual compatible (H6 a=
nd=20
A64) and since OrangePi 3 uses gigabit ethernet, quirk introduced by patche=
s=20
1-2 are not needed.

However, it is nice to have this 100 Mbit fix, because most STB DTS will ne=
ed=20
it.

Best regards,
Jernej

> - HDMI support (patches 4-6)
>=20
> For some people, ethernet doesn't work after reboot (but works on cold
> boot), when the stmmac driver is built into the kernel. It works when
> the driver is built as a module. It's either some timing issue, or power
> supply issue or a combination of both. Module build induces a power
> cycling of the phy.
>=20
> I encourage people with this issue, to build the driver into the kernel,
> and try to alter the reset timings for the phy in DTS or
> startup-delay-us and report the findings.
>=20
>=20
> Please take a look.
>=20
> thank you and regards,
>   Ondrej Jirman
>=20
>=20
> Changes in v7:
> - dropped stored reference to connector_pdev as suggested by Jernej
> - added forgotten dt-bindings reviewed-by tag
>=20
> Changes in v6:
> - added dt-bindings reviewed-by tag
> - fix wording in stmmac commit (as suggested by Sergei)
>=20
> Changes in v5:
> - dropped already applied patches (pinctrl patches, mmc1 pinconf patch)
> - rename GMAC-3V3 -> GMAC-3V to match the schematic (Jagan)
> - changed hdmi-connector's ddc-supply property to ddc-en-gpios
>   (Rob Herring)
>=20
> Changes in v4:
> - fix checkpatch warnings/style issues
> - use enum in struct sunxi_desc_function for io_bias_cfg_variant
> - collected acked-by's
> - fix compile error in drivers/pinctrl/sunxi/pinctrl-sun9i-a80-r.c:156
>   caused by missing conversion from has_io_bias_cfg struct member
>   (I've kept the acked-by, because it's a trivial change, but feel free
>   to object.) (reported by Martin A. on github)
>   I did not have A80 pinctrl enabled for some reason, so I did not catch
>   this sooner.
> - dropped brcm firmware patch (was already applied)
> - dropped the wifi dts patch (will re-send after H6 RTC gets merged,
>   along with bluetooth support, in a separate series)
>=20
> Changes in v3:
> - dropped already applied patches
> - changed pinctrl I/O bias selection constants to enum and renamed
> - added /omit-if-no-ref/ to mmc1_pins
> - made mmc1_pins default pinconf for mmc1 in H6 dtsi
> - move ddc-supply to HDMI connector node, updated patch descriptions,
>   changed dt-bindings docs
>=20
> Changes in v2:
> - added dt-bindings documentation for the board's compatible string
>   (suggested by Clement)
> - addressed checkpatch warnings and code formatting issues (on Maxime's
>   suggestions)
> - stmmac: dropped useless parenthesis, reworded description of the patch
>   (suggested by Sergei)
> - drop useles dev_info() about the selected io bias voltage
> - docummented io voltage bias selection variant macros
> - wifi: marked WiFi DTS patch and realted mmc1_pins as "DO NOT MERGE",
>   because wifi depends on H6 RTC support that's not merged yet (suggested
>   by Clement)
> - added missing signed-of-bys
> - changed &usb2otg dr_mode to otg, and added a note about VBUS
> - improved wording of HDMI driver's DDC power supply patch
>=20
> Icenowy Zheng (2):
>   net: stmmac: sun8i: add support for Allwinner H6 EMAC
>   net: stmmac: sun8i: force select external PHY when no internal one
>=20
> Ondrej Jirman (4):
>   arm64: dts: allwinner: orange-pi-3: Enable ethernet
>   dt-bindings: display: hdmi-connector: Support DDC bus enable
>   drm: sun4i: Add support for enabling DDC I2C bus to sun8i_dw_hdmi glue
>   arm64: dts: allwinner: orange-pi-3: Enable HDMI output
>=20
>  .../display/connector/hdmi-connector.txt      |  1 +
>  .../dts/allwinner/sun50i-h6-orangepi-3.dts    | 70 +++++++++++++++++++
>  drivers/gpu/drm/sun4i/sun8i_dw_hdmi.c         | 54 ++++++++++++--
>  drivers/gpu/drm/sun4i/sun8i_dw_hdmi.h         |  2 +
>  .../net/ethernet/stmicro/stmmac/dwmac-sun8i.c | 21 ++++++
>  5 files changed, 144 insertions(+), 4 deletions(-)




