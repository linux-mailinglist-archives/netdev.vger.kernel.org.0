Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B62045B9302
	for <lists+netdev@lfdr.de>; Thu, 15 Sep 2022 05:21:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230211AbiIODVh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Sep 2022 23:21:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230186AbiIODVf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Sep 2022 23:21:35 -0400
Received: from mail-oa1-x32.google.com (mail-oa1-x32.google.com [IPv6:2001:4860:4864:20::32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65D098F962;
        Wed, 14 Sep 2022 20:21:34 -0700 (PDT)
Received: by mail-oa1-x32.google.com with SMTP id 586e51a60fabf-1274ec87ad5so45753133fac.0;
        Wed, 14 Sep 2022 20:21:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date;
        bh=wFkBesRwfqcj3CX5Iz3LowXdYgUQd9xk42DDWFH6z/U=;
        b=ObM2/plyRnLRqerAadJfngGyddnsH7s6dgOq2cT0ktxpFo0XfRu0J1+0F2FpFWlNxM
         OX/RJnXBuaDizTG9vbIrPbPx/PSZ+SUoL6cJIk4JIV9N04pJT/j6wbYqXVPDMjFF39eb
         oLecX6dZOcRicCm72+/m5DTP6/nU/r2ymbWD/FhVubnFXas5KKyeHYFOiz0v2poAaLAX
         9V5e9Qf74MA6NTXmDkBU5gXxC5m6BNdYP8iYyFukqFAYxhHEBEGP/WS1MyNj3H1EsTcJ
         uymbx+4999P1sIogKfeJPd9GtBCGilv2bfaUdma2YXCFPBIA2BjcJyQ6UAkHkGz317W5
         znrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date;
        bh=wFkBesRwfqcj3CX5Iz3LowXdYgUQd9xk42DDWFH6z/U=;
        b=CqK2ncUCfwBsuRjCMIM93opr02UghyiBCflXYJJICYzcKT6kMES1MjbQI5Vr0wEzz7
         UkvP5NycX2w/hbUe65YWF0Q6iseY1b5QRWMDmmA7zi1Xo1xlw8xnzwLLTAIkB3M2F1Zz
         wXafEqT/JflgXpUBpLFJ22tFXVBVTYBDALSba9jTUFHSU+toz7hGvZ7TU5xmosZzFJe7
         OUdDrAsK05mSU0cmQ5s5oW6tQLVSrTljcIChWFsVzo0/jNBagn42lnzBdOY3T1Xyp64p
         T0LGUEoyXX3cCRIrpEtOm3HkUvRSjs4OX4XapJviB+acuEsH+tr/tuo3riHxkafFINzy
         Sk7g==
X-Gm-Message-State: ACgBeo3pH3na6CHFv2yDEBeZ8Qn9hvP5OwCrQp/G/WnZbq3GVb1KrX5/
        2PjdpihzzJsyzKDIVBgwuX9lweUJxF1P3gPdIkI=
X-Google-Smtp-Source: AA6agR72umOG1lwIjilq8Z+bXLoz6rwSEVoZDQ4luKpynK6vC6GFvDWBy92K6048ExMF+/eov5V8X4fmSHo++P6n4bw=
X-Received: by 2002:a05:6870:c0c8:b0:101:b3c3:abc3 with SMTP id
 e8-20020a056870c0c800b00101b3c3abc3mr4119832oad.144.1663212093765; Wed, 14
 Sep 2022 20:21:33 -0700 (PDT)
MIME-Version: 1.0
References: <20220914085451.11723-1-arinc.unal@arinc9.com> <20220914085451.11723-5-arinc.unal@arinc9.com>
 <20220914151414.GA2233841-robh@kernel.org> <44045164-692d-c8f5-3216-b043fb821634@arinc9.com>
In-Reply-To: <44045164-692d-c8f5-3216-b043fb821634@arinc9.com>
From:   Sergio Paracuellos <sergio.paracuellos@gmail.com>
Date:   Thu, 15 Sep 2022 05:21:21 +0200
Message-ID: <CAMhs-H-0XV9ocrG3_MuVc3Q=o8HnYso2CqUURjVR3OMc=dAMYg@mail.gmail.com>
Subject: Re: [PATCH 04/10] dt-bindings: memory: mt7621: add syscon as
 compatible string
To:     =?UTF-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>
Cc:     Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
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
        "open list:MIPS" <linux-mips@vger.kernel.org>
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

On Wed, Sep 14, 2022 at 5:19 PM Ar=C4=B1n=C3=A7 =C3=9CNAL <arinc.unal@arinc=
9.com> wrote:
>
> On 14.09.2022 18:14, Rob Herring wrote:
> > On Wed, Sep 14, 2022 at 11:54:45AM +0300, Ar=C4=B1n=C3=A7 =C3=9CNAL wro=
te:
> >> Add syscon as a constant string on the compatible property as it's req=
uired
> >> for the SoC to work. Update the example accordingly.
> >
> > It's not required. It's required to automagically create a regmap. That
> > can be done yourself as well. The downside to adding 'syscon' is it
> > requires a DT update. Maybe that's fine for this platform? I don't know=
.
>
> My GB-PC2 won't boot without syscon on mt7621.dtsi. This string was
> always there on the memory controller node on mt7621.dtsi.

The string was introduced because the mt7621 clock driver needs to
read some registers creating a regmap from the syscon. The bindings
were added before the clock driver was properly mainlined and at first
the clock driver was using ralink architecture dependent operations
rt_memc_* defined in
'arch/mips/include/asm/mach-ralink/ralink_regs.h'. I forgot to update
the mem controller binding when memc became a syscon so I think this
patch is correct. I also think the sample should use 'syscon' in the
node name instead of memory-controller.

Best regards,
    Sergio Paracuellos
>
> Ar=C4=B1n=C3=A7
