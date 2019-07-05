Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C232B60035
	for <lists+netdev@lfdr.de>; Fri,  5 Jul 2019 06:37:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725865AbfGEEhs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Jul 2019 00:37:48 -0400
Received: from mail-qt1-f196.google.com ([209.85.160.196]:39570 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725468AbfGEEhs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Jul 2019 00:37:48 -0400
Received: by mail-qt1-f196.google.com with SMTP id l9so1709991qtu.6
        for <netdev@vger.kernel.org>; Thu, 04 Jul 2019 21:37:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=endlessm-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=E4tQKZ7fykfnk1s1sWexseP5zItY8m/Ql+ltT8MN+jU=;
        b=Xl/ZiR/Mp0004403KKrucoOknyIq+kZO0YDx1/1QqKpPxzJ8bpDgbLOGxx0cN8uTgd
         1RJaxqCE6MylJZh/aTj6LPKB4Rs3veAbHfpLyprVgWAzTRRT6lwZspe1f5hdtp+DYK4z
         GjH4XKyXEGxm1SF/P/aHRGqNOXrtRrOGZQBulAoAeCiYN6Cr9pf8zV2rQRiFurLn9mA8
         Nzh484YnMLerf7ORWMlhdJizA31Be4fy6NdYsokCTaIgMjsn1uZlk/4y1FtsBLcyxtB0
         gqP6gnDfEz9Yu1E+xN4JqdyQyIMa/13kLt0tlWmEufEyrW/fY3AdiyG7ihVwTG5plaEl
         UC7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=E4tQKZ7fykfnk1s1sWexseP5zItY8m/Ql+ltT8MN+jU=;
        b=QAXHFxqwhWXMHtQ7XHyleTDU9goIWwy78//faCHARzj6AZiiuV9db8Ua/UvZncb5Rl
         PZiXfKJuycZz6t0XDobeUZSkclAVuuoTFuVF84hE1vIOjaiFO32XZ14bqv4JCBxZ4eIz
         fKV6+L8Mz242tngkf3CCpLAUO3brhoaYPquHv0jv9TDL3Ktrq5mQChVEedXMQSpgag37
         MzuBNFcwFJpUYWxklK6hIhowF/P7EMqi4GG2kixNseOE30bZSOyc386kjlOBCheKACu2
         L5YigKLKyH7LyOcsfyzrfoeQSK5tFqRs4C5ZLD/eep6vcdz8LssgXQJeAenbEi8M4Jn/
         kfXg==
X-Gm-Message-State: APjAAAU2Uzk4cQKjlN7XTuQw2CR+x4D2Ijufj0SBQS4iILSwBbJ9+0ex
        FsDGnw1dAmfnvAa7yQilzt9Yps0EMj+39rnfBFqQhg==
X-Google-Smtp-Source: APXvYqz3TKMBMrMdGFslZiseysb5WUOqwB2TRyRUBYzEK5BDFN/m7nW9LC+nIyAZ5zFnmJJ8bMVSGpr7cgak70nnEYk=
X-Received: by 2002:a0c:ae5a:: with SMTP id z26mr1466461qvc.65.1562301466888;
 Thu, 04 Jul 2019 21:37:46 -0700 (PDT)
MIME-Version: 1.0
References: <20190704105528.74028-1-chiu@endlessm.com> <CAD8Lp45rYuE5WHx4vSbUhF10hOHam1aBLd52_aDKP8z2eeL4vA@mail.gmail.com>
In-Reply-To: <CAD8Lp45rYuE5WHx4vSbUhF10hOHam1aBLd52_aDKP8z2eeL4vA@mail.gmail.com>
From:   Chris Chiu <chiu@endlessm.com>
Date:   Fri, 5 Jul 2019 12:37:34 +0800
Message-ID: <CAB4CAwd1N=eZaVTSu8CdDTSyw7+gwriJ866t9AoP5YEoHbjEvw@mail.gmail.com>
Subject: Re: [PATCH v2] rtl8xxxu: Fix wifi low signal strength issue of RTL8723BU
To:     Daniel Drake <drake@endlessm.com>
Cc:     Jes Sorensen <jes.sorensen@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        David Miller <davem@davemloft.net>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Linux Upstreaming Team <linux@endlessm.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 5, 2019 at 11:41 AM Daniel Drake <drake@endlessm.com> wrote:
>
> On Thu, Jul 4, 2019 at 6:55 PM Chris Chiu <chiu@endlessm.com> wrote:
> > The WiFi tx power of RTL8723BU is extremely low after booting. So
> > the WiFi scan gives very limited AP list and it always fails to
> > connect to the selected AP. This module only supports 1x1 antenna
> > and the antenna is switched to bluetooth due to some incorrect
> > register settings.
> >
> > Compare with the vendor driver https://github.com/lwfinger/rtl8723bu,
> > we realized that the 8723bu's enable_rf() does the same thing as
> > rtw_btcoex_HAL_Initialize() in vendor driver. And it by default
> > sets the antenna path to BTC_ANT_PATH_BT which we verified it's
> > the cause of the wifi weak tx power. The vendor driver will set
> > the antenna path to BTC_ANT_PATH_PTA in the consequent btcoexist
> > mechanism, by the function halbtc8723b1ant_PsTdma.
>
> Checking these details in the vendor driver:
> EXhalbtc8723b1ant_PowerOnSetting sets:
>         pBoardInfo->btdmAntPos = BTC_ANTENNA_AT_AUX_PORT;
>
> Following the code flow from rtw_btcoex_HAL_Initialize(), this has a
> bWifiOnly parameter which will ultimately influence the final register
> value.
> Continuing the flow, we reach halbtc8723b1ant_SetAntPath() with
> bInitHwCfg=TRUE, bWifiOff=FALSE. antPosType is set to WIFI in the
> bWifiOnly case, and BT otherwise.
>
> I'm assuming that bUseExtSwitch = FALSE (existing rtl8xxxu code also
> seems to make the same assumption).
> For the bWifiOnly=FALSE case, it uses BT,
>                     pBtCoexist->fBtcWrite4Byte(pBtCoexist, 0x948, 0x0);
> and rtl8xxxu seems to do the same - seemingly routing the antenna path
> for BT only.
>
> As for halbtc8723b1ant_PsTdma() then being called in a way that causes
> it to switch to the PTA path a little later, it's more difficult to
> point out how that happens in an email, but I thin kwe can trust you
> on that :) There are certainly many callsites that would pass those
> parameters.
>
> > +        * Different settings per different antenna position.
> > +        *      Antenna Position:   | Normal   Inverse
> > +        * --------------------------------------------------
> > +        * Antenna switch to BT:    |  0x280,   0x00
> > +        * Antenna switch to WiFi:  |  0x0,     0x280
> > +        * Antenna switch to PTA:   |  0x200,   0x80
> >          */
> > -       rtl8xxxu_write32(priv, REG_S0S1_PATH_SWITCH, 0x00);
> > +       rtl8xxxu_write32(priv, REG_S0S1_PATH_SWITCH, 0x80);
>
> I don't really understand what we mean by an "inverse" antenna and my
> reading of the vendor driver leads me to another interpretation.
>
> The logic is based around an antenna position - btdmAntPos. It takes
> one of two values:
>     BTC_ANTENNA_AT_MAIN_PORT                = 0x1,
>     BTC_ANTENNA_AT_AUX_PORT                = 0x2,
>
> So the chip has pins to support two antennas - a "main" antenna and an
> "aux" one.
>
> We know we're dealing with a single antenna, so the actual module is
> going to only be using one of those antenna interfaces. If the chip
> tries to use the other antenna interface, it's effectively not using
> the antenna. So it's rather important to tell the chip to use the
> right interface.
>
> And that's exactly what happens here. btdmAntPos is hardcoded that the
> antenna is on the aux port for these devices, and this code is telling
> the chip that this is how things are wired up.
>
> The alternative way of calling this an antenna inverse (which the
> vendor driver also does in another section), i.e. "antenna is not
> connected to the main port but instead it's connected to the other
> one", seems less clear to me.
>
I agree with this part. From my past experience working on drivers for
WiFi access point, there's always a board config to describe how the
antenna wired up. The driver or firmware will select antennas from
something like txchainmask/rxchainmask to perform some smart
antenna and MIMO features. So The antenna position setting is quite
important for each wifi(MIMO) product because it could have impact on
the coverage and throughput. Back to the 1x1 rtl8723bu here, I think
it's the same thing. The antenna position is fixed in the factory and wired
to the AUX port. Maybe we can just take this antenna settings as the
default for 8723bu based on the assumption that there will be no other
antenna configuration.

Chris

> Even if we don't fully understand what's going on here, I'm convinced
> that your code change is fixing an inconsistency with the vendor
> driver, and most significantly, making the signal level actually
> usable on our devices. But if you agree with my interpretation of
> these values then maybe you could update the comment here!
>
> Daniel
