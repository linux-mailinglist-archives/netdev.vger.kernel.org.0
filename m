Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 95BD25B84EF
	for <lists+netdev@lfdr.de>; Wed, 14 Sep 2022 11:27:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230301AbiINJ1A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Sep 2022 05:27:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230112AbiINJ0X (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Sep 2022 05:26:23 -0400
Received: from mail-oa1-x2c.google.com (mail-oa1-x2c.google.com [IPv6:2001:4860:4864:20::2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1622A86046;
        Wed, 14 Sep 2022 02:16:03 -0700 (PDT)
Received: by mail-oa1-x2c.google.com with SMTP id 586e51a60fabf-1280590722dso39324865fac.1;
        Wed, 14 Sep 2022 02:16:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date;
        bh=dKB74mBldf0ryE7wHaQ5c2RXlLTkuN5Oo9MVuStsjik=;
        b=LQrcEfQrlyPgojX5I0QYZZZks9ECkgcggZXX41UcDISBB+0WfHaJpmDgtUvBZ/yF4N
         DKp9QgRLsTGr2fzzsk3qBOwytacITMoOhRbaCaeSrMxCV2OddgNiT206nZ3wCI8/Vb+4
         RqgQ77kxCZOve4LGBZKZNMDX91Sge2/iKWGlmSHmLw8UIbiMtn1LWEDnX36JMvDWqGuY
         wkZk5+wxLZ9PkDKRhLWY6zi8tmxLAB8vmrV7a7efQD4i2rhoYYyi3AAxWw7S/mGtQsUN
         QO0+BeyNaEK5hribqjTsQZMg/jYR0Ffi1UVZ0QMcYsOMpPb9HnDrn09aHidu6m8oLs99
         WQCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date;
        bh=dKB74mBldf0ryE7wHaQ5c2RXlLTkuN5Oo9MVuStsjik=;
        b=F8G+xVCnsTllWGnOsCGTI0d1JrdfgKAbiwbFn3NRE4x1CUEIiojvawVyFjE4b1mwCz
         MbQwgem+7mbPVUS8xqYPlgXXl0abBXGsRshfxo+17iHx80uqHZJUpYZP26K5PzP1mvwN
         D7KxLxL1rJo3Jb5Jr9tpSgz96aK5rDXlKbHoHARRdXgtCK46oIszBQnGZVEfPY9d+Be7
         peumFMs3/muf2xdAVRi2ifwjDe2Bk3uDtrh4D3BwI27pNJY2+IdmmztshkaANhERFkdO
         FRwkWzQSVzA0YAh4Oc+JZWzWXx6tPDvMHdBi2tOuhnUjnIUEGKdvBm4xtX/Q7ZTxc6jS
         FXxg==
X-Gm-Message-State: ACgBeo0M0T4QqacSHa/LLH5WAXvxp+/33s8jEZs+29+PNj8gnA5iPMJz
        /zPoXwZG4LWqxySlIcaJT/cRwIKTGKPIb4J39BA=
X-Google-Smtp-Source: AA6agR6nLizzgsdW2MtHzQMBHn9DNm9fpJhbQUUIbEXzsw0znlDW/B8uuj/JwEk6De066e8MWwu/aAwd592JAvzdEEo=
X-Received: by 2002:a05:6808:1b22:b0:34f:7879:53cc with SMTP id
 bx34-20020a0568081b2200b0034f787953ccmr1433120oib.144.1663146957744; Wed, 14
 Sep 2022 02:15:57 -0700 (PDT)
MIME-Version: 1.0
References: <20220914085451.11723-1-arinc.unal@arinc9.com> <20220914085451.11723-7-arinc.unal@arinc9.com>
In-Reply-To: <20220914085451.11723-7-arinc.unal@arinc9.com>
From:   Sergio Paracuellos <sergio.paracuellos@gmail.com>
Date:   Wed, 14 Sep 2022 11:15:46 +0200
Message-ID: <CAMhs-H8C7QagLK-5+A6U647Lf6u6GbUWNVT3cX1uE8DKWzd-7A@mail.gmail.com>
Subject: Re: [PATCH 06/10] mips: dts: ralink: mt7621: remove interrupt-parent
 from switch node
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
> The interrupt-parent property is inherited from the ethernet node as it's=
 a
> parent node of the switch node. Therefore, remove the unnecessary
> interrupt-parent property from the switch node.
>
> Signed-off-by: Ar=C4=B1n=C3=A7 =C3=9CNAL <arinc.unal@arinc9.com>
> ---
>  arch/mips/boot/dts/ralink/mt7621.dtsi | 1 -
>  1 file changed, 1 deletion(-)

Reviewed-by: Sergio Paracuellos <sergio.paracuellos@gmail.com>
