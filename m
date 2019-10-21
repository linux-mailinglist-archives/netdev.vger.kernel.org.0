Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 71DE8DE987
	for <lists+netdev@lfdr.de>; Mon, 21 Oct 2019 12:33:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727685AbfJUKdY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Oct 2019 06:33:24 -0400
Received: from mout.kundenserver.de ([217.72.192.75]:44471 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726725AbfJUKdY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Oct 2019 06:33:24 -0400
Received: from mail-qt1-f177.google.com ([209.85.160.177]) by
 mrelayeu.kundenserver.de (mreue109 [212.227.15.145]) with ESMTPSA (Nemesis)
 id 1MZCSt-1iZXf804QL-00V80k for <netdev@vger.kernel.org>; Mon, 21 Oct 2019
 12:33:23 +0200
Received: by mail-qt1-f177.google.com with SMTP id d17so5604029qto.3
        for <netdev@vger.kernel.org>; Mon, 21 Oct 2019 03:33:22 -0700 (PDT)
X-Gm-Message-State: APjAAAXBfLEUmhX7PCSLPZtpr0cy78k8pgOhQoCRh34o2Ra8Lg4nyaSK
        wp4ly0t//X4reAsfSmFxT4zTLifN69HEu1/0fqE=
X-Google-Smtp-Source: APXvYqw+EiF6uCS0I1HhLQwhY6Zcruajf95iluYOLp6CGFQdsCSNmgJKaI6oeE3SIJCmPBUVNiY1acxUgNRGKqG3E7E=
X-Received: by 2002:a0c:c70a:: with SMTP id w10mr23112413qvi.222.1571654001877;
 Mon, 21 Oct 2019 03:33:21 -0700 (PDT)
MIME-Version: 1.0
References: <20191021000824.531-1-linus.walleij@linaro.org>
In-Reply-To: <20191021000824.531-1-linus.walleij@linaro.org>
From:   Arnd Bergmann <arnd@arndb.de>
Date:   Mon, 21 Oct 2019 12:33:05 +0200
X-Gmail-Original-Message-ID: <CAK8P3a1Kou5sRDECxA+iaJ_soogczHPdc_QNYnBDFW6Q8kKkrw@mail.gmail.com>
Message-ID: <CAK8P3a1Kou5sRDECxA+iaJ_soogczHPdc_QNYnBDFW6Q8kKkrw@mail.gmail.com>
Subject: Re: [PATCH 00/10] IXP4xx networking cleanups
To:     Linus Walleij <linus.walleij@linaro.org>
Cc:     Networking <netdev@vger.kernel.org>,
        "David S . Miller" <davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
X-Provags-ID: V03:K1:NxkjItSWE0Ea3Ij6ZyoI4jr2+4VUS2pIe1PJWW/F//9GgwAS5Cp
 dmdmKdofVFlXZkor5A5jPrtkgr3UuoY8R+x6saGMaRhpCuWiv6ZgVAc5+ZK32Q33AqGOvqe
 f5ewdZ11An5AwlsmFIa3OziigkuJJ+t988aDoRS4XzbQ4HD5IW+rbCb05iy0jwKow1AnUlw
 S482Z1/PlIzWg+0O5oH5A==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:JEwy5sWwf2k=:RiYbHS053picEtm3K9wZ9K
 DoiPd6sBesWZy6PokqkAiBYZpVB1CFJ7yryIUz6hM/2O+TPFm9eDAbeT/6ROXN1ZZFqDC3/MT
 9zbgLbEqw8Dgyv0RL4dAaartPLApx26VFXekvJwfa2KofTen+QnD6VRDTvNYPvgvrFhx4Ttv4
 wl0XlFgNJAvN45TMdhMZMUUkIY9QKkHEybFhhkTLSiMYQuQ2/644e0nZyClfz6nORVT5sHYwt
 F2Uym/aA9I3g2txbduPS2VOo3E5iQe3JApWp/J+Oo/94fIbzr/E+G8xNOI26Jh8q0P7qtIL2x
 wDml51pGRZZl8SybPhAZ5VjLxGqQEC1ozuP3XGST1pyl2ojZGVnwtBLrBDlTB4L/nUbL6ZXWu
 tp3bnG0nOF6gNRVG+2YVgNcSNTjiHzux8PkFLcjZ9sLX7F5QnbWZNl9kTLVeFrA/VB0hdth6N
 c29AS2HBhU77ck6lDVLnFJlw11ADJRo343LezoXegfIgqXsGYEF1iAK05l4FcDFGIjYV/Owmm
 3N95AX0D2I8TwcV4M1KH36IXQe4JnRtQykzQlHP+jitONgcdDGkicANhulbSAm3dvt7bDE54k
 LX+auiG92uyXLn0SxB2qXHVSy/yqInc5hUIH40pu6qopUisNppLU7ig0rs3z8NoTkyVyhZiYo
 4a5ZcHo3/iQAUKWj0p7+1hRoJReCqgXyaWR5656Sknzt9aYc9TE6nqmCvymdgxPeUlLSRvUDH
 fn/0jL+9c7mLFO35khqPnTroFNTJqsTLjI8hEafbdA2CvFGFQGW2k6M+SZKjAAcZ30XZo184g
 9lEjyah0Bs2AAcrfd5Pb82+Z9Nxp2ERYzXOeZXefCZ29PXSCWHkmxTAzdr4n0wDdmJBTVyTzs
 26ccQi0PXV2E5H1vTBeg==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 21, 2019 at 2:08 AM Linus Walleij <linus.walleij@linaro.org> wrote:
>
> This is a patch series which jams together Arnds and mine
> cleanups for the IXP4xx networking.
>
> I also have patches for device tree support but that
> requires more elaborate work, this series is some of
> mine and some of Arnds patches that is a good foundation
> for his multiplatform work and my device tree work.
>
> These are for application to the networking tree so
> that can be taken in one separate sweep.
>
> I have tested the patches for a bit using zeroday builds
> and some boots on misc IXP4xx devices and haven't run
> into any major problems. We might find some new stuff
> as a result from the new compiler coverage.
>
> The patch set also hits in the ARM tree but Arnd is
> a ARM SoC maintainer and is hereby informed :)

Thanks a lot for collecting these, it looks very good overall.

I had two minor comments for your patches and noticed one
more thing about one of mine:

> Arnd Bergmann (4):
>   wan: ixp4xx_hss: fix compile-testing on 64-bit
>   wan: ixp4xx_hss: enable compile testing
>   ptp: ixp46x: move next to ethernet driver

That subject "move next to ..." makes no sense. I don't
know what I tried to write there, but if you send a new
version, please drop the "next" or try to come up with a
better subject than what I had.

     Arnd
