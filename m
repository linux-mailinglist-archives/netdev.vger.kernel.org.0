Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 76CE25B84F4
	for <lists+netdev@lfdr.de>; Wed, 14 Sep 2022 11:29:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230148AbiINJ3E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Sep 2022 05:29:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231598AbiINJ2h (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Sep 2022 05:28:37 -0400
Received: from mail-ot1-x332.google.com (mail-ot1-x332.google.com [IPv6:2607:f8b0:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82F3A7DF6C;
        Wed, 14 Sep 2022 02:17:29 -0700 (PDT)
Received: by mail-ot1-x332.google.com with SMTP id d25-20020a9d72d9000000b00655d70a1aeaso6814118otk.3;
        Wed, 14 Sep 2022 02:17:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date;
        bh=jCIOhLvVlvNV9HUxfecamktxgICT/5zf1IRbWZuyeiY=;
        b=YTvc5L6w5aAWrmyBdY3nw/N7B+xVvMzdMLZrPugoPa0yCmTHuZfPxLpvc3UjWheYmA
         LXcAbiY4XkL+8OevtSbLTgZbcxC6dPUMLYkkyRcNWTI+wQkA6Oba6EfSD49HitSTFhDi
         VSX4k3c0hjnPYG/Omp5Xx+K9zgNwTuxj8Kzkw3hu/mUDNJJnjgtJRif4Rvg5rcKRghgJ
         lpbM4x4dKXcVENLNlylRAlj0wD4KHWf98MolUbQG1q+w2PTvusOu6yc0OUODJVqO3n4C
         bZ0gMq1iXkiy4cm5ikT/5ICzgYVc+1cTsJC90xXVgLbssYJuqqOd5BJUPTnmQDVAoH8A
         VRFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date;
        bh=jCIOhLvVlvNV9HUxfecamktxgICT/5zf1IRbWZuyeiY=;
        b=cJYuKQoKQXe3ZM1h5oNsu7+/CXJ2J3Ck8NefwqCCdnrKKGwcOwkantQDl/cqC0CHgq
         FTyFO0AkUo6rZ1+jk9rVwJ4Kn/UEif0JzQTemn/w96mygAAGrDoVVC1sJ3QzdJm07X5u
         BAhVU/sKWNe30tpYCttYv3ZT2XYlhcbgmBNAAQSXKdHaqmb+xlaT+haMj3S8mBS69VTR
         yVY8JfKrZLHwlfp6Jw07kGgPyd5fe55e7uI+gFmulUOzEzV1ZgV5YuQlAqkxQ124GXdM
         +/a6OR8I2jQInGBVoamzf4YYDjd7RIky7Tzicz3FOpX7uwv3+bgH2gKUaBf4Up69i6tK
         V4vQ==
X-Gm-Message-State: ACgBeo2uYCJ4Zpyvs0X8eR+5GL9fHVg2eTs2RNm6xYCF5AmHFlnT1n0Z
        e7Uv2t/stnFBQM4kASmQR0u57WMlo+1HcUNIIFE=
X-Google-Smtp-Source: AA6agR507+omkOoy6Eobpvj7z6t0NT9B9qdaVUmwFrPTtBPz0Sqn1vie6TfYUrdK1+KUiEUglrxPNs70gq8gwNW0amg=
X-Received: by 2002:a05:6830:150e:b0:655:bc7d:1e5d with SMTP id
 k14-20020a056830150e00b00655bc7d1e5dmr8562142otp.272.1663147039255; Wed, 14
 Sep 2022 02:17:19 -0700 (PDT)
MIME-Version: 1.0
References: <20220914085451.11723-1-arinc.unal@arinc9.com> <20220914085451.11723-8-arinc.unal@arinc9.com>
In-Reply-To: <20220914085451.11723-8-arinc.unal@arinc9.com>
From:   Sergio Paracuellos <sergio.paracuellos@gmail.com>
Date:   Wed, 14 Sep 2022 11:17:08 +0200
Message-ID: <CAMhs-H-XRGz5UCkEzOJtBSC9nH4kaw45ziaqfobt1wfo8gDjbw@mail.gmail.com>
Subject: Re: [PATCH 07/10] mips: dts: ralink: mt7621: change phy-mode of gmac1
 to rgmii
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

On Wed, Sep 14, 2022 at 10:56 AM Ar=C4=B1n=C3=A7 =C3=9CNAL <arinc.unal@arin=
c9.com> wrote:
>
> Change phy-mode of gmac1 to rgmii on mt7621.dtsi. Same code path is
> followed for delayed rgmii and rgmii phy-mode on mtk_eth_soc.c.
>
> Signed-off-by: Ar=C4=B1n=C3=A7 =C3=9CNAL <arinc.unal@arinc9.com>
> ---
>  arch/mips/boot/dts/ralink/mt7621.dtsi | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
Reviewed-by: Sergio Paracuellos <sergio.paracuellos@gmail.com>
