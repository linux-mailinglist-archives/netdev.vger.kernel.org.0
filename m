Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CE6CA63E995
	for <lists+netdev@lfdr.de>; Thu,  1 Dec 2022 07:05:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229741AbiLAGFC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Dec 2022 01:05:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229497AbiLAGE7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Dec 2022 01:04:59 -0500
Received: from mail-oi1-x22d.google.com (mail-oi1-x22d.google.com [IPv6:2607:f8b0:4864:20::22d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2050F9AE18;
        Wed, 30 Nov 2022 22:04:59 -0800 (PST)
Received: by mail-oi1-x22d.google.com with SMTP id s186so912045oia.5;
        Wed, 30 Nov 2022 22:04:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SQ6eCCvP2RIqVFnGOfA4yG/2BtjQTMpdxc/JWs/IikY=;
        b=PvHY6dBEyebJE6QNI6Wjq2MneXIl4rTpGS7fBC7Qv6R/Yiga7OIh4/Pj4BgHnrpndG
         GrmgooNZOVFverQjG/PwQwa+jNTTeu5eaofi0fQ6sUgKspL/GgqiAAoT7DsAPA/bcNeL
         CuuBxemNVt9HiH103qegQcLdL8byYtx9q2Sy8nfwvxBZulJQ2g5EAZZ4I/KTXdccwea1
         xayFiXCzBGxNpmCBPyhigLfeSVQaNBWPI/KTZtc4+CqnxGM8xxSJGEpvpTJVaXAoUIMI
         LhDFRKO2nzxUjEipEZonE2WghJNoafzVk4PIFC+1xTm7vj4OLlTNuK0dUH2dye1MdJio
         EOHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=SQ6eCCvP2RIqVFnGOfA4yG/2BtjQTMpdxc/JWs/IikY=;
        b=dnzYRuVBOJfA56lOlWjR/3WF0Z0Fjm3n0v8f7/OJcHPT7/LmRqv7H5l2qNRkKNh9yx
         WyX9eyOIbJKRP5VP9NxC7znaYfNYTl/+tAgfeFcNC7mQ97DUoQwO2O6abDSKnFENADJj
         y+WydRCnnry+pLKeus0xUDQUcdLivdTuw5T3xZEyrxHYC5wMyiFyTrRpXjJyaxvYAp+g
         yd/eZMg67b9xBysiIYlucgay23e3rYrdblir0pm/AbO2u6+/BdLe9ruqTwyAKVZUTe/H
         iYkW49jaOv7lKR9K/oRTXzdSOk2tsWxi3z+t/4Al3E+VB4xScW7tLNdSzECFPxzAm9Iu
         nOGg==
X-Gm-Message-State: ANoB5pnrR1okCRFCmjTjKjFv/WDmgXr6nqdMtC5k0tUZzCbFBopzJgVU
        Aneve+pJMd8CYcRAGEW2+pOXMpAFmKEUjJT1uWk=
X-Google-Smtp-Source: AA0mqf5l2e4XTILLZHTH7QTRBPvz28RAyHNavvCrAHgTBlylFcIYKmUFvkgoGR7uLixlsP/mcB3a5GSDsiHvA3KSd08=
X-Received: by 2002:aca:60c6:0:b0:35a:51fc:2134 with SMTP id
 u189-20020aca60c6000000b0035a51fc2134mr22358640oib.144.1669874698405; Wed, 30
 Nov 2022 22:04:58 -0800 (PST)
MIME-Version: 1.0
References: <20221130141040.32447-1-arinc.unal@arinc9.com> <20221130141040.32447-5-arinc.unal@arinc9.com>
In-Reply-To: <20221130141040.32447-5-arinc.unal@arinc9.com>
From:   Sergio Paracuellos <sergio.paracuellos@gmail.com>
Date:   Thu, 1 Dec 2022 07:04:47 +0100
Message-ID: <CAMhs-H_yk4_ieChz9ZaMgZiQNSO7RxhAXPN0nHWWxbox=qY_mw@mail.gmail.com>
Subject: Re: [PATCH 4/5] mips: dts: remove label = "cpu" from DSA dt-binding
To:     =?UTF-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>
Cc:     Vladimir Oltean <vladimir.oltean@nxp.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        soc@kernel.org, "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Gregory Clement <gregory.clement@bootlin.com>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Beznea <claudiu.beznea@microchip.com>,
        Ray Jui <rjui@broadcom.com>,
        Scott Branden <sbranden@broadcom.com>,
        Broadcom internal kernel review list 
        <bcm-kernel-feedback-list@broadcom.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
        Hans Ulli Kroll <ulli.kroll@googlemail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Shawn Guo <shawnguo@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        Fabio Estevam <festevam@gmail.com>,
        NXP Linux Team <linux-imx@nxp.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Andy Gross <agross@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konrad.dybcio@somainline.org>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Magnus Damm <magnus.damm@gmail.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Chen-Yu Tsai <wens@csie.org>,
        Jernej Skrabec <jernej.skrabec@gmail.com>,
        Samuel Holland <samuel@sholland.org>,
        Stefan Agner <stefan@agner.ch>,
        Heiko Stuebner <heiko@sntech.de>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Nicholas Piggin <npiggin@gmail.com>,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        Tim Harvey <tharvey@gateworks.com>,
        Peng Fan <peng.fan@nxp.com>,
        Rasmus Villemoes <rasmus.villemoes@prevas.dk>,
        Frank Wunderlich <frank-w@public-files.de>,
        Michael Riesch <michael.riesch@wolfvision.net>,
        Oleksij Rempel <linux@rempel-privat.de>,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-arm-msm@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-sunxi@lists.linux.dev, linux-rockchip@lists.infradead.org,
        linux-mips@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 30, 2022 at 3:14 PM Ar=C4=B1n=C3=A7 =C3=9CNAL <arinc.unal@arinc=
9.com> wrote:
>
> This is not used by the DSA dt-binding, so remove it from all devicetrees=
.
>
> Signed-off-by: Ar=C4=B1n=C3=A7 =C3=9CNAL <arinc.unal@arinc9.com>
> ---
>  arch/mips/boot/dts/ralink/mt7621.dtsi | 1 -

Acked-by: Sergio Paracuellos <sergio.paracuellos@gmail.com>

Thanks,
    Sergio Paracuellos
