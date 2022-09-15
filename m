Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F3E5E5B93D7
	for <lists+netdev@lfdr.de>; Thu, 15 Sep 2022 07:09:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229665AbiIOFJ3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Sep 2022 01:09:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229635AbiIOFJ2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Sep 2022 01:09:28 -0400
Received: from mail-oi1-x22d.google.com (mail-oi1-x22d.google.com [IPv6:2607:f8b0:4864:20::22d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 156974BA7E;
        Wed, 14 Sep 2022 22:09:26 -0700 (PDT)
Received: by mail-oi1-x22d.google.com with SMTP id t62so900875oie.10;
        Wed, 14 Sep 2022 22:09:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date;
        bh=Z1u0N1ZJfcMPueq2SWcO4i8OlPSVWclmpIeRHJIVStU=;
        b=JBIj0fTNeLAKOYOxmzHscUM5+aL1yw70MnW5/dh4qZt+6ZsxY+3J6EwLHZJmvtQ2ip
         Z64u7zK5t9lOjjkZ74nGP7wpPh+iBg41jE3CqJXAsXHzX195IOemhLPsfiDjrWdFW9iJ
         lJeAXwXii8LAcHZTJRKSAFy4xUD6uFHQx44HwX41zw2RLkBxwhnrJRJNLZ0SBBHUgrp7
         AaDk9+VY/aFtnQMMQrvVUHAsYWXnNPxJfBwG4PywLUMgR8a0GeQxlhW/+Ezj6XJOtv7e
         4E5Y0Gwu/IdTrGuaiG4BAzgmbIBgeWt3lgKdg6WOSpqbOkBCw5YfyDvVKTkNZU3GI4cq
         9dWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date;
        bh=Z1u0N1ZJfcMPueq2SWcO4i8OlPSVWclmpIeRHJIVStU=;
        b=XUTuHbtFXkFI37pxJrJZLW8keRUgNGPDXAEJs8H41/RiftWB/drVauvXpxmAR8kHyM
         jylDqi4ZegeiFLgE6NRQ1enCEvbXihY6B3Tw5Rtberm7VO9bCbEBshOW4znQanhna3tj
         A7dqevHO20rjFssHAgzVQE6PCbvkub1yojdjPkzYtZ7Nw6y3Lq8ac7xQA8/JGFhhiunb
         AIHdyPGSdGQshcJdeCtMa/tbq2h0ysKGwm0sT2gfjuIeEHC4a6exu4o5/VFvshOI0f8T
         Up5bObTy8UHLOlGgT+lhrfMgW2xAzBCAaovKTyEyW9WNoQIuvtkrwcAewqEPcQadD8fX
         4gCw==
X-Gm-Message-State: ACgBeo1l+2KF0yOhKpP8SGvVfcI57DyxqvPmfkBlfEMG8cQ3YmlAVXbo
        M6XyP3ANuTzJhruvznJQJdZLvAy4WpfodSnfBVI=
X-Google-Smtp-Source: AA6agR5i/Bh3pO/9k18kWiTkxaxJwPRYNQzlq1eA12nfEuyi040sOX1UtxWgnNRcqiPP8+KBdgABsT/lEkeVGexV2sI=
X-Received: by 2002:a05:6808:bcb:b0:345:aa85:6f33 with SMTP id
 o11-20020a0568080bcb00b00345aa856f33mr3479669oik.83.1663218565430; Wed, 14
 Sep 2022 22:09:25 -0700 (PDT)
MIME-Version: 1.0
References: <20220914085451.11723-1-arinc.unal@arinc9.com> <20220914085451.11723-9-arinc.unal@arinc9.com>
In-Reply-To: <20220914085451.11723-9-arinc.unal@arinc9.com>
From:   Sergio Paracuellos <sergio.paracuellos@gmail.com>
Date:   Thu, 15 Sep 2022 07:09:13 +0200
Message-ID: <CAMhs-H-zYdjHX99vXpeDerhMNbX10BWtUq6WSeAHyDNG8ruXCA@mail.gmail.com>
Subject: Re: [PATCH 08/10] mips: dts: ralink: mt7621: change mt7530 switch address
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
        Sungbo Eo <mans0n@gorani.run>
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
> In the case of muxing phy0 of the MT7530 switch, the switch and the phy
> will have the same address on the mdio bus, 0. This causes the ethernet
> driver to fail since devices on the mdio bus cannot share an address.
>
> Any address can be used for the switch, therefore, change the switch
> address to 0x1f.
>
> Suggested-by: Sungbo Eo <mans0n@gorani.run>
> Signed-off-by: Ar=C4=B1n=C3=A7 =C3=9CNAL <arinc.unal@arinc9.com>
> ---
>  arch/mips/boot/dts/ralink/mt7621.dtsi | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)

Reviewed-by: Sergio Paracuellos <sergio.paracuellos@gmail.com>

Thanks,
    Sergio Paracuellos
