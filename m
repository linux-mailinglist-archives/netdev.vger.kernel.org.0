Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7B2455B93DB
	for <lists+netdev@lfdr.de>; Thu, 15 Sep 2022 07:10:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229686AbiIOFKE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Sep 2022 01:10:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229635AbiIOFKD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Sep 2022 01:10:03 -0400
Received: from mail-ot1-x335.google.com (mail-ot1-x335.google.com [IPv6:2607:f8b0:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79C1C48EB1;
        Wed, 14 Sep 2022 22:10:02 -0700 (PDT)
Received: by mail-ot1-x335.google.com with SMTP id cm7-20020a056830650700b006587fe87d1aso1299175otb.10;
        Wed, 14 Sep 2022 22:10:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date;
        bh=DhzhPn2YSCEh/VEOd0K8UJG8nXmRRJz83NMi2inqG5U=;
        b=TRp9RmLfxbRJhlww8zHaCm/TpVgwOtsHI0NJZ+7W6/5GSoKr9S1KjDo0+A34loUwnd
         Y7ZFouu0m1Ed7irNlcM8J9ILz++S7ACpAabM8lKxAfc+WGenNQoYoEt7J/aU36CZX0Ls
         xvL2VVyr42+vA+1uryRs4TnUweX0gn98LA+fwCpzedQ1Tmy6bvS06sNzYD6IEKGXz/PF
         pgFni+MKcYV5M9Xr3X3UlbRWimWhugjgzMMf3NjuXbviA7QRbf8ofGK3+7dCUhTVtl00
         gsJsxqAGFaoop+1OCG7z3qc1kkgHOAKLBtVLWxv5GK6nRb7rry6XR0cBuIc4rhd+sl7p
         AKiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date;
        bh=DhzhPn2YSCEh/VEOd0K8UJG8nXmRRJz83NMi2inqG5U=;
        b=uQy7AjoKzyeDiCAjGmAUnN+o/Rfi5vimprKe91iYX+YIoSSrCsI0pZEzIW8Sn8HqhD
         3lgTdoi9iXUOzy1LETzFpCHAvhANREODm0TpLwj+gswXmNy9Zc06L6ocQrEn4EQpsqxe
         Wt30O0EsMQJI0H4vqwItk2o9/K79Qilam9VKAscZ84yHVRY7AgtwvTprAvuBx0OpYNql
         1oartcaiMlkPYfhwhtDDsToqPjj6dlfrnhNVDb58bTjRFCgVgyoRQNNNlB6js+F8m/OP
         Lqrg6R+lBpabYGhKW3t+Mo4b7y95cL5wvUaAd65u7KbmkqDkFNhclPvb+4jnLUAEAVGc
         BKFg==
X-Gm-Message-State: ACgBeo2bfK98ATrTTH7vDDY0oVJx6KuTotfjIYNBsnaqDUgi17OdDwSl
        5HbQOyNkqBP+iCd26D2rfYaiH9g2cT5D0zAEJDc=
X-Google-Smtp-Source: AA6agR7ttNz1jhPVaAmBo6hvEqvWJ4oTkoElikatgicTx2EhjceigRoiTrcQZO71eJfHowxRsQGpz9KUh/yJigwBSLg=
X-Received: by 2002:a05:6830:150e:b0:655:bc7d:1e5d with SMTP id
 k14-20020a056830150e00b00655bc7d1e5dmr10361973otp.272.1663218601884; Wed, 14
 Sep 2022 22:10:01 -0700 (PDT)
MIME-Version: 1.0
References: <20220914085451.11723-1-arinc.unal@arinc9.com> <20220914085451.11723-10-arinc.unal@arinc9.com>
In-Reply-To: <20220914085451.11723-10-arinc.unal@arinc9.com>
From:   Sergio Paracuellos <sergio.paracuellos@gmail.com>
Date:   Thu, 15 Sep 2022 07:09:49 +0200
Message-ID: <CAMhs-H8dE2XOvUZ029X0r85_v81=oMsOGRcaGdjL=+Ti8F0uKQ@mail.gmail.com>
Subject: Re: [PATCH 09/10] mips: dts: ralink: mt7621: fix external phy on GB-PC2
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
> The address of the external phy on the mdio bus is 5. Update the devicetr=
ee
> for GB-PC2 accordingly.
>
> Fixes: 5bc148649cf3 ("staging: mt7621-dts: fix GB-PC2 devicetree")
> Signed-off-by: Ar=C4=B1n=C3=A7 =C3=9CNAL <arinc.unal@arinc9.com>
> ---
>  arch/mips/boot/dts/ralink/mt7621-gnubee-gb-pc2.dts | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)

Reviewed-by: Sergio Paracuellos <sergio.paracuellos@gmail.com>

Thanks,
    Sergio Paracuellos
