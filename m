Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A01AD5B93D3
	for <lists+netdev@lfdr.de>; Thu, 15 Sep 2022 07:09:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229647AbiIOFI2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Sep 2022 01:08:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229657AbiIOFIZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Sep 2022 01:08:25 -0400
Received: from mail-oi1-x233.google.com (mail-oi1-x233.google.com [IPv6:2607:f8b0:4864:20::233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57FDB85F8F;
        Wed, 14 Sep 2022 22:08:23 -0700 (PDT)
Received: by mail-oi1-x233.google.com with SMTP id s140so898175oie.0;
        Wed, 14 Sep 2022 22:08:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date;
        bh=HDYs7vs+thMMDY6yodcXDXhWOMLfZv2S6AqnKaCcDRk=;
        b=fjRmEANxa4Ci2C8NGJiFGaRrqPV7/+Nt5aUx0ywwlww2acQv/sYHN5d6AolkIP0DQX
         KqHyfAMrtRvGjnMHQjlU16OpHm+pdfyJRF2NicOj8VwEAcRByvQ0M5vG32FM+Hg8CRn/
         n0i6jEQKIS6D5fzEKN9CyVZv2AMrh6vaCgd55CiltFeLPSAXi9K7Hebvtfiq3Zt7ZgfT
         Ab522y4Lxwh2mf5KWWtJxdH2h6M5ZOfo5Urpbcf+wdjJkuAbk6dkDReLh05/97W5lk84
         TI9bfIKW2MLl5tSkw/By4VeksO1HwfGNfh1R4llpWrhD5vz6uoAOPS0vfQhMu/WYXlUy
         CvhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date;
        bh=HDYs7vs+thMMDY6yodcXDXhWOMLfZv2S6AqnKaCcDRk=;
        b=UCy3JB/+EknL61wfEjVmZP6Q2EKZiWKDhym1Dkfat1Xg/6uet4FTMskvaCjbYsEBM/
         lfuFDSZpUwbDxXliK9QpOsJmddEvf3QTDd5GDn0lZIGLzJQBgMslk92B0RdvEYT6VIgK
         3Ab+Xhnsjev3+5IzBlT2hAXhsUuRsfOEJgdEEH09r5+1y5eZ2OUhdfrKE8DHaZaR7UFG
         2gP7HylAEiND8JjlrUvWNr1KsF4MT+ju/UwSmatW0eKVN6V331oX93x13TFWZ+J0G2pR
         H1nwPJk1AhHX82xpqISYeVmw23PNeHXk6P0SX24ik6vFSgJnZDv7MYkjmah5wsAhVO5J
         rMBQ==
X-Gm-Message-State: ACgBeo1llZJjTDBWYxCuSQIBKiS4bvMtW2k1gwM/in0D8JhSxjjKPugm
        +wRQw71SCG79nPvLyIVeFVfcugqIL56CednJjnQfzh6Ys0mrEEBC
X-Google-Smtp-Source: AA6agR7bm8mPpUUJY4ncvftwWMu/7VrdSYwhN+VZHkwkeVNOVpRT4cvzU/rsGAzLjl6BjtlpzTZ33WDL/s/fD5kAklc=
X-Received: by 2002:a05:6808:1b22:b0:34f:7879:53cc with SMTP id
 bx34-20020a0568081b2200b0034f787953ccmr3378456oib.144.1663218502705; Wed, 14
 Sep 2022 22:08:22 -0700 (PDT)
MIME-Version: 1.0
References: <20220914085451.11723-1-arinc.unal@arinc9.com> <20220914085451.11723-11-arinc.unal@arinc9.com>
In-Reply-To: <20220914085451.11723-11-arinc.unal@arinc9.com>
From:   Sergio Paracuellos <sergio.paracuellos@gmail.com>
Date:   Thu, 15 Sep 2022 07:08:10 +0200
Message-ID: <CAMhs-H-Nxub7==J0gTO9A+Lw_hurWaUeR+ZoqnS5KrJcJs6S_A@mail.gmail.com>
Subject: Re: [PATCH 10/10] mips: dts: ralink: mt7621: add GB-PC2 LEDs
To:     =?UTF-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>
Cc:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>, erkin.bozoglu@xeront.com,
        netdev <netdev@vger.kernel.org>,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS" 
        <devicetree@vger.kernel.org>, linux-arm-kernel@lists.infradead.org,
        "moderated list:ARM/Mediatek SoC support" 
        <linux-mediatek@lists.infradead.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "open list:MIPS" <linux-mips@vger.kernel.org>,
        Petr Louda <petr.louda@outlook.cz>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 14, 2022 at 10:56 AM Ar=C4=B1n=C3=A7 =C3=9CNAL <arinc.unal@arin=
c9.com> wrote:
>
> Add the missing LEDs for GB-PC2. The ethblack-green, ethblue-green, power
> and system LEDs weren't added previously, because they don't exist on the
> device schematics. Tests on a GB-PC2 by me and Petr proved otherwise.
>
> The i2c bus cannot be used on GB-PC2 as its pins are wired to LEDs instea=
d,
> and GB-PC1 does not use it. Therefore, do not enable it on both devices.
>
> Link: https://github.com/ngiger/GnuBee_Docs/blob/master/GB-PCx/Documents/=
GB-PC2_V1.1_schematic.pdf
> Tested-by: Petr Louda <petr.louda@outlook.cz>
> Signed-off-by: Ar=C4=B1n=C3=A7 =C3=9CNAL <arinc.unal@arinc9.com>
> ---
>  .../boot/dts/ralink/mt7621-gnubee-gb-pc1.dts  |  6 ---
>  .../boot/dts/ralink/mt7621-gnubee-gb-pc2.dts  | 42 ++++++++++++++++---
>  2 files changed, 36 insertions(+), 12 deletions(-)

Reviewed-by: Sergio Paracuellos <sergio.paracuellos@gmail.com>
