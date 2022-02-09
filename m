Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 701D04AECB0
	for <lists+netdev@lfdr.de>; Wed,  9 Feb 2022 09:38:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239223AbiBIIiF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Feb 2022 03:38:05 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:40058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232550AbiBIIiD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Feb 2022 03:38:03 -0500
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CDA65C094CB0;
        Wed,  9 Feb 2022 00:38:00 -0800 (PST)
Received: by mail-pf1-x42f.google.com with SMTP id d187so3013710pfa.10;
        Wed, 09 Feb 2022 00:38:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=22Xi1z/ScqVSExlbxCk1GGbcWjUYoCEzTiIBgifbR8k=;
        b=XYCAQTI45l9GPO+hXmMbN+HqvTO6Luiwt337miZ/r8Qj8Hld+/3tuyT2zYGQhNOCvv
         80AceUYqEdoJHxmnmIo8Er6kBSjMvZX/RDTqUt536+uYcmJ1LkX5yrv+iYBQPZJ1zgHf
         kcFjiPAKN2rA7olq5IT7pl8frpdXSyTpKpfdJTIGKwPfz0CVa2MloGKQr7aSPdOTEmml
         Bmba8grwjsbSaIYnmjQAe07ua+OqBkarVDtnKBGxR1ZaFDyK4eOtp7Oo/mn+vItvi4hN
         fSgMX5H4CZv0wAXyvccIzuVp9XQx8mWAtmNZtHGaDkEr7NX/UiLpmBU1XZAld1IVNIr3
         bHkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=22Xi1z/ScqVSExlbxCk1GGbcWjUYoCEzTiIBgifbR8k=;
        b=3N7fstn8mh45s1IbgpGeH3brIZlVnDKBZOEEl52ctWk2MXpv+pVLV6LiDB/p9+qq6s
         QTzGakTarbXoYJPjYu2C/K3wq7AfK+7eooin1BvreoGZ+oFZgzE01mqdrdlj/9275+f/
         CL2ltxlzBdxtOY/Yotrs3FjJcOuru7y/z7E0R/P+OoMrvwj4WiIqII8oUxR3nHNl8jCM
         PBM9HwQYdMvqfEMl8z07LqC+2BEK/G8ieFMoT0WT5gJ/5NGzGsRS2Qt4TjogfKusuBd5
         TScWMBF7G4expMjVwXNax1X/xvgqgfRGBz7b888Y922/J7J2lfNRnz2RXSR1uoaMlFBe
         NN5Q==
X-Gm-Message-State: AOAM530LEE3aqw4FuFWqBpXci6oa2ZqGoo/xy9vrbGNK1j99opH2DJwu
        ouiZb+IzTxdX2whtYsDnIGRoWe2TnHw7WfU/Axg=
X-Google-Smtp-Source: ABdhPJxWr0Kbq83LpjlqWfmGu30DOKd4Oo70si+5KGXccF9/zMwD3H9w+YFnjXYls53fU6SGRXrxkD/bWGFXE3vSYOM=
X-Received: by 2002:a63:6c84:: with SMTP id h126mr1043241pgc.456.1644395877349;
 Wed, 09 Feb 2022 00:37:57 -0800 (PST)
MIME-Version: 1.0
References: <20211228072645.32341-1-luizluca@gmail.com> <Ydx4+o5TsWZkZd45@robh.at.kernel.org>
 <CAJq09z4G40ttsTHXtOywjyusNLSjt_BQ9D78PhwSodJr=4p6OA@mail.gmail.com>
 <7d6231f1-a45d-f53e-77d9-3e8425996662@arinc9.com> <CAJq09z7n_RZpsZS+RNpdzzYzhiogHfWmfpOF5CJCLBL6gurS_Q@mail.gmail.com>
 <a9571486-1efd-49a7-aa26-c582d493ead6@gmail.com>
In-Reply-To: <a9571486-1efd-49a7-aa26-c582d493ead6@gmail.com>
From:   Luiz Angelo Daros de Luca <luizluca@gmail.com>
Date:   Wed, 9 Feb 2022 05:37:46 -0300
Message-ID: <CAJq09z7xGADn9u6Bu8MNeQGcR-T4s_wRuun2r+KO8Jh4fmYYjg@mail.gmail.com>
Subject: Re: [PATCH] dt-bindings: net: dsa: realtek-smi: convert to YAML schema
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     =?UTF-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>,
        Rob Herring <robh@kernel.org>,
        =?UTF-8?Q?Alvin_=C5=A0ipraga?= <ALSI@bang-olufsen.dk>,
        Linus Walleij <linus.walleij@linaro.org>,
        devicetree@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Olof Johansson <olof@lixom.net>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "open list:NETWORKING DRIVERS" <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> If there
> are properties that only apply to SPI or MDIO, you can make use of
> conditionals within the YAML file to enforce those. Having a single
> binding file would be very helpful to make sure all eggs are in the same
> basket.

Sorry Florian but I failed to find a way to test the parent node
(platform or mdio) and conditionally offer properties.
What I did was to guess if it is an mdio driver or not by checking the
"reg" property. Is there a better way to solve it?

Luiz

PS: I might post the merged v2 doc soon.
