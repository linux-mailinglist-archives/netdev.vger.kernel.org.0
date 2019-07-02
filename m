Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 901205CA3F
	for <lists+netdev@lfdr.de>; Tue,  2 Jul 2019 10:01:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727059AbfGBIBd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Jul 2019 04:01:33 -0400
Received: from mail-qk1-f193.google.com ([209.85.222.193]:46827 "EHLO
        mail-qk1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725859AbfGBIBd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Jul 2019 04:01:33 -0400
Received: by mail-qk1-f193.google.com with SMTP id x18so13175974qkn.13
        for <netdev@vger.kernel.org>; Tue, 02 Jul 2019 01:01:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=endlessm-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=g9p5xPNbhvX6rdcdMz4PJ3zSu4AdikKW+oNfOMUWzrk=;
        b=fy5Qz7SDXY14L8WdevL9eePkSI+yeR2Q7uiqhJXE0IKwg5vnJs0gzASrqMrIeYOivA
         8+KyFxi6L/xkrX5KErsmrt5Qwkj3fRjxG9s0lRnnRUe9Kv/2RRTdXrsJzTNSZRqchLEU
         oWXvDahBwXwx9UD+FbE6t+yMoaB5bn4nXEOSqJpnOCTe7U9Kl99ayNyOUN3em+gouKfZ
         jq/vg5dBwF4imPWvJavdTv81qm88N4EMMUeiMmmPUk2JYAdujNmptm1S1IA89ZB1nSOU
         tu5/hsj3H5qdwHs0k29Ii+1fGZXxz2kWoar+MY01SYOXV8eHVUdxuLLQc1GJFo+jr4kI
         PK2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=g9p5xPNbhvX6rdcdMz4PJ3zSu4AdikKW+oNfOMUWzrk=;
        b=OF6Qb0XhZJECLs0tYkjVBaUcYIHj/I0o/l99FCCMPkchRRGtKf9NZ/caXZsDPFiHUk
         FrqcWRuT2N9w4hqCp4YVKiSSvKu6ehvNlx2u9SZySABVONcQnH+kK6UQB5Xmf1WqkQbs
         qWqOOIiFQNnLyJKFNeLN7meyY1mj6SbTrOiS3g7XQ4HtqQvERGu25MeiCexqMeHzkmI9
         zgV19DRZveN8KuDDVUFdDuNfIbw4wae/QwC4KYKDsbC2uzuujsejeobnzEa7P0M1P+4l
         9AKxmLypgks5ATKlCsEdgMaJUgv0yHRzP62Fz6iC+r2i/R/jHEvpHQCYN6q38nPUYPJN
         +row==
X-Gm-Message-State: APjAAAXtlN8tJIfhsiK5lVjoA2XEVw2lQT7DF6gpmK40Q+X/NjEFh+Kx
        8wtwxtW8XuxErUGpF7mKyiuP1WgQN6H9/Q396mF88qiHCnSO6A==
X-Google-Smtp-Source: APXvYqyu081PrF6DH3XYn8co6vd3CglY6p4fuQ+Wd1tD/kxeoB428ZroR/lHr4A33wgvO+mZ2qIrRov8ukZ6WZRFE+k=
X-Received: by 2002:ae9:c30e:: with SMTP id n14mr22468492qkg.220.1562054492108;
 Tue, 02 Jul 2019 01:01:32 -0700 (PDT)
MIME-Version: 1.0
References: <20190627095247.8792-1-chiu@endlessm.com> <CAD8Lp44R0a1=fVi=fGv69w1ppdcaFV01opkdkhaX-eJ=K=tYeA@mail.gmail.com>
In-Reply-To: <CAD8Lp44R0a1=fVi=fGv69w1ppdcaFV01opkdkhaX-eJ=K=tYeA@mail.gmail.com>
From:   Chris Chiu <chiu@endlessm.com>
Date:   Tue, 2 Jul 2019 16:01:20 +0800
Message-ID: <CAB4CAwcVoWffpK8xR_UbXaGyHh8ZrrX_9vvzjAkWGKXQotpmYA@mail.gmail.com>
Subject: Re: [PATCH] rtl8xxxu: Fix wifi low signal strength issue of RTL8723BU
To:     Daniel Drake <drake@endlessm.com>
Cc:     Jes Sorensen <jes.sorensen@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        David Miller <davem@davemloft.net>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Linux Upstreaming Team <linux@endlessm.com>,
        Larry Finger <Larry.Finger@lwfinger.net>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 1, 2019 at 4:28 PM Daniel Drake <drake@endlessm.com> wrote:
>
> Hi Chris,
>
> On Thu, Jun 27, 2019 at 5:53 PM Chris Chiu <chiu@endlessm.com> wrote:
> > The WiFi tx power of RTL8723BU is extremely low after booting. So
> > the WiFi scan gives very limited AP list and it always fails to
> > connect to the selected AP. This module only supports 1x1 antenna
> > and the antenna is switched to bluetooth due to some incorrect
> > register settings.
> >
> > This commit hand over the antenna control to PTA, the wifi signal
> > will be back to normal and the bluetooth scan can also work at the
> > same time. However, the btcoexist still needs to be handled under
> > different circumstances. If there's a BT connection established,
> > the wifi still fails to connect until disconneting the BT.
> >
> > Signed-off-by: Chris Chiu <chiu@endlessm.com>
>
> Really nice work finding this!
>
> I know that after this change, you plan to bring over the btcoexist
> code from the vendor driver (or at least the minimum required code)
> for a more complete fix, but I'm curious how you found these magic
> register values and how they compare to the values used by the vendor
> driver with btcoexist?
>
> What's PTA? A type of firmware-implemented btcoexist that works for
> scanning but doesn't work when a BT connection is actually
> established?
>

When the vendor driver invokes rtw_btcoex_HAL_Initialize, which will then
call halbtc8723b1ant_SetAntPath to configure the registers in this patch.
From the code, the registers will have different register settings per the
antenna position and the phase. If the driver is in the InitHwConfig phase,
the register value is identical to what rtl8xxxu driver does in enable_rf().
However, the vendor driver will do halbtc8723b1ant_PsTdma() twice by
halbtc8723b1ant_ActionWifiNotConnected() with the type argument 8 for
PTA control about 200ms after InitHwConfig. The _ActionWifiNotConnected
is invoked by the BTCOEXIST. I keep seeing the halbtc8723b1ant_PsTdma
with type 8 been called every 2 seconds.

I don't know what PTA is. I presume it's the mechanism in FW for the automatic
antenna selecting instead of manual control. Given the phenomenon that wifi
signal still stays low even without bluetooth driver loaded, I believe
setting the
registers as in halbtc8723b1ant_SetAntPath with BTC_ANT_PATH_PTA also
makes sense.



> > diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_8723b.c b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_8723b.c
> > index 3adb1d3d47ac..6c3c70d93ac1 100644
> > --- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_8723b.c
> > +++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_8723b.c
> > @@ -1525,7 +1525,7 @@ static void rtl8723b_enable_rf(struct rtl8xxxu_priv *priv)
> >         /*
> >          * WLAN action by PTA
> >          */
> > -       rtl8xxxu_write8(priv, REG_WLAN_ACT_CONTROL_8723B, 0x04);
> > +       rtl8xxxu_write8(priv, REG_WLAN_ACT_CONTROL_8723B, 0x0c);
>
> The comment above this still says "WLAN action by PTA" and the vendor
> driver has:
>         //set wlan_act control by PTA
>         pBtCoexist->fBtcWrite1Byte(pBtCoexist, 0x76e, 0x4);
>
> but then also:
>             //set wlan_act control by PTA
>             pBtCoexist->fBtcWrite1Byte(pBtCoexist, 0x76e, 0xc);
>
> So this change seems to be at least consistent with ambiguity of the
> vendor driver, do you have any understanding of the extra bit that is
> now set here?
>
I think the precise expression for 0x04 is "set wlan act to always low",
it's configured for wifi only.

> It's not easy to follow the code flow of the vendor driver to see what
> actually happens, have you checked that, does it end up using the 0xc
> value?
>

Yes, it ends up with 0x0c not matter what antenna position type is. Unless
it's configured wifi only.

> > -        * 0x280, 0x00, 0x200, 0x80 - not clear
> > +        * Different settings per different antenna position.
> > +        * Antenna switch to BT: 0x280, 0x00 (inverse)
> > +        * Antenna switch to WiFi: 0x0, 0x280 (inverse)
> > +        * Antenna controlled by PTA: 0x200, 0x80 (inverse)
> >          */
> > -       rtl8xxxu_write32(priv, REG_S0S1_PATH_SWITCH, 0x00);
> > +       rtl8xxxu_write32(priv, REG_S0S1_PATH_SWITCH, 0x80);
>
> I don't quite follow the comment here. Why are there 2 values listed
> for each possibility, what do you mean by inverse? You say the
> register settings were incorrect, but the previous value was 0x00
> which you now document as "antenna switch to wifi" which sounds like
> it was already correct?
>
> Which value does the vendor driver use?
>
The first column means the value for normal antenna installation, wifi
on the main port. The second column is the value for inverse antenna
installation. So if I want to manually switch the antenna for BT use,
and the antenna installation is inverse, I need to set to 0x280. So 0x80
means I want to switch to PTA and the antenna installation in inverse.

The vendor driver's code about this is also in halbtc8723b1ant_SetAntPath.

> >         /*
> >          * Software control, antenna at WiFi side
> > diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
> > index 8136e268b4e6..87b2179a769e 100644
> > --- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
> > +++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
> > @@ -3891,12 +3891,13 @@ static int rtl8xxxu_init_device(struct ieee80211_hw *hw)
> >
> >         /* Check if MAC is already powered on */
> >         val8 = rtl8xxxu_read8(priv, REG_CR);
> > +       val16 = rtl8xxxu_read16(priv, REG_SYS_CLKR);
> >
> >         /*
> >          * Fix 92DU-VC S3 hang with the reason is that secondary mac is not
> >          * initialized. First MAC returns 0xea, second MAC returns 0x00
> >          */
> > -       if (val8 == 0xea)
> > +       if (val8 == 0xea || !(val16 & BIT(11)))
> >                 macpower = false;
> >         else
> >                 macpower = true;
>
> At a glance I can't see which code this corresponds to in the vendor
> driver, can you point that out?
>
> Thanks
> Daniel

It's in rtl8723bu_hal_init and the comment says "Check if MAC has already
power on". In vendor driver, it's just for output messages but in rtl8xxxu, it
will determine whether if the llt_init() and tx related registers
being correctly
initialized. I sometimes hit the problem of connection failure after boot and
it's because the macpower is falsely true.

Chris
