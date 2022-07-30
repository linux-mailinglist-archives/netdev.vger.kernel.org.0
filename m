Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EE803585998
	for <lists+netdev@lfdr.de>; Sat, 30 Jul 2022 11:30:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233796AbiG3Jah (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 30 Jul 2022 05:30:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230135AbiG3Jae (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 30 Jul 2022 05:30:34 -0400
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12A01186DD;
        Sat, 30 Jul 2022 02:30:34 -0700 (PDT)
Received: by mail-pg1-x52d.google.com with SMTP id h132so5744108pgc.10;
        Sat, 30 Jul 2022 02:30:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=rrdKDJbtGqa5viWukiN2p7Td+Kx3OFsE5gH0u7qT+jU=;
        b=RRfQHaMAO4mu/wyFZRz7MFqoYB3wwHE2gYR7h9+xQYhNKRKnLDnzRu9hOEhVvrfxpG
         VGG4BPeC8llyWTW9J2yo/ExyFhkJsvTpY9NdtwMwJP13dTYHmQB3MGFTucTYHX4va6Qx
         dhTIN4FhtKJouj2dcSwif8SN9HihuEa6NdIRFyc5Cn0A2tRytz4suhyg6VcvbqMmcLvt
         W+i5A37iV1PLjN8zXmMkGU7rMg4HXRNrPEidZgoCIudr7hHDSkTJq5XrfxosWP09daQI
         /u1TFjRfLOcOxb8WXw5hYLBpMg05Pg7o4cGNRWmX936WpedNdubM/KQYyTFQvIionvIl
         gy0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=rrdKDJbtGqa5viWukiN2p7Td+Kx3OFsE5gH0u7qT+jU=;
        b=J9Jh6IUA1F2CG6dVsSG22+odPKua+89NGpiCE8djeIxufhYtd1BPMfEeT6nZYm9tEc
         XVz3dVzMsUuWm4QgmdK74qyO/Smx12o0+KKSBRETuNo342FgitTY8zI44wB2JSBzuOey
         S+YfkOxgv8bd6xdWCkMooB6PnbP+D7/v/zS3Nv33qEBekpK0IklsrHzDmt1Pz6oNIHoC
         VNwFIeCrqcvDT6XpM3fxSVvHR2oUk88tnp9B0QxCvn2bsJ84UKxViOEljC4NrjXQ7KyG
         qSTSF1oXG32A7/gPXKPROGXqAMgHvjcWoqYat9AyFXQ+rYf3YAsVsD++vhlWgKNMIMxH
         lymg==
X-Gm-Message-State: AJIora9R6aaVV2tCPL4mj762rwk7Y5QBIt2u7lLrFmHtAIg+PG4tlq3m
        LuZ96/daiPqbdYGPwnR0amaiOjUvkqspcmI4zUc=
X-Google-Smtp-Source: AGRyM1uEHExAwDPMjqjRxs4fCYjmwCx9oX7UsRv4rOEZkJCal6Y3x7tqTVyR4ThmsAcK5LLhRnvu4PQuU70eM2+FnxY=
X-Received: by 2002:a65:4b8c:0:b0:41b:cbd:b9c4 with SMTP id
 t12-20020a654b8c000000b0041b0cbdb9c4mr5938371pgq.128.1659173433579; Sat, 30
 Jul 2022 02:30:33 -0700 (PDT)
MIME-Version: 1.0
References: <20220726122406.31043-1-arinc.unal@arinc9.com> <YuK193gAQ+Rwe26s@makrotopia.org>
 <980c9926-9199-9b6e-aa65-6b5276af5d70@arinc9.com>
In-Reply-To: <980c9926-9199-9b6e-aa65-6b5276af5d70@arinc9.com>
From:   DENG Qingfang <dqfext@gmail.com>
Date:   Sat, 30 Jul 2022 17:30:23 +0800
Message-ID: <CALW65jYfcfND4QiD=8OhMCgW0LZMSBYmVZK5Ce8u3cMPh+8Rdg@mail.gmail.com>
Subject: Re: [RFC PATCH net-next] dt-bindings: net: dsa: mediatek,mt7530:
 completely rework binding
To:     =?UTF-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>
Cc:     Daniel Golle <daniel@makrotopia.org>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Frank Wunderlich <frank-w@public-files.de>,
        Luiz Angelo Daros de Luca <luizluca@gmail.com>,
        Sander Vanheule <sander@svanheule.net>,
        =?UTF-8?Q?Ren=C3=A9_van_Dorst?= <opensource@vdorst.com>,
        erkin.bozoglu@xeront.com,
        Sergio Paracuellos <sergio.paracuellos@gmail.com>,
        netdev <netdev@vger.kernel.org>,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS" 
        <devicetree@vger.kernel.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        "moderated list:ARM/Mediatek SoC support" 
        <linux-mediatek@lists.infradead.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
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

On Sat, Jul 30, 2022 at 5:15 PM Ar=C4=B1n=C3=A7 =C3=9CNAL <arinc.unal@arinc=
9.com> wrote:
> Thanks Daniel. To be precise, this is the case for MT7620AN, MT7620DA,
> MT7620DAN, MT7620NN, MT7628AN, MT7628DAN, MT7628DBN, MT7628KN, MT7628NN,
> MT7688AN and MT7688KN SoCs as all include a 5p FE switch according to
> Russia hosted WikiDevi.

MT76x8 series uses a different switch IP.
>
> I'll update the description accordingly.
>
> Ar=C4=B1n=C3=A7
