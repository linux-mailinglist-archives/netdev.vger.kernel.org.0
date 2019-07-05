Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 71D6C5FF7B
	for <lists+netdev@lfdr.de>; Fri,  5 Jul 2019 04:27:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727559AbfGEC1Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Jul 2019 22:27:16 -0400
Received: from mail-qt1-f194.google.com ([209.85.160.194]:45820 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727338AbfGEC1P (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Jul 2019 22:27:15 -0400
Received: by mail-qt1-f194.google.com with SMTP id j19so9717540qtr.12
        for <netdev@vger.kernel.org>; Thu, 04 Jul 2019 19:27:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=endlessm-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=O5KZM3VrT8RC6G2toh1ISaY4NA4LnxOKM8Y2rCcQe00=;
        b=v7bzRvkK8e6Z351NmC9om4MYfvAA5AAzqAxRqT7y5gRpXBfM9kWjSkzep04nq69Ygy
         2LtMeN45mT8nePK9RETcMlaEiwCnnO6jWsbpuXaw314ks+sFIctzRp1vnNAbXYSKGlHW
         vnwRSluLevcfklbnV323d7Cp4xUwjgbZxNcgCMH84bqDRgTcSzyoLLDjsvLB82M5HD0x
         76518+07Yuf1y1QPkS/bi8jIQLCkTPONMbqvMfgwf+SV+6m+rH11j9zPFc+cPDBz3p9W
         aRV3e2p99tTnNCY0q50e14jsABC9YnM3fa+7456EETLL4LFHNikpw5yiaI5n+WzX8WAp
         Nn1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=O5KZM3VrT8RC6G2toh1ISaY4NA4LnxOKM8Y2rCcQe00=;
        b=gbVXvKLo4HxjhzVrEItUrJ1pjEZPw9/2s9EVAFD6cgCQgHzR5Z/JCwx9oOH36Trqcd
         X1SIKYDwm78yZ3DPmEPdMXauybKiyYQmyAneJbChNqg8Mju1Fw9P/ctJ0EWwAKMk1nnm
         RJY651qHTxsdFdHuAzcwtC/SnoClfmNgPREbPYuH82cc9oAKSbe0yxCigNDBvg8tSkEZ
         fMlOhyi7YekGZvOmSDm/OfoNfq1sroXz46vRSsKN5fkJpAQAdg5stBYs3QpXDD0Ek4eG
         MZyKrvJ5n6UQLbwDVwP+cTVMxoiKvhA5XwHgdQTRyiJUqvJt6p/kwwDbGrHEpPI9XsxS
         G0dQ==
X-Gm-Message-State: APjAAAXIveCUuXydKUzGJ2cLdozTpnzvFTUX4/50HWyutELEK5OJFV8C
        lOczzdCIDvXajmfebrewRw+x/e+Vh6e15CldeDyHtw==
X-Google-Smtp-Source: APXvYqwRMB1LlaiHHHFDLQ5+ZRm2dPOx+7B3Io2yOJepgWVcxg3fxIbMumiRoohpyRlH9SrLAgluF75AV4XlKaJ2NIU=
X-Received: by 2002:a0c:95a2:: with SMTP id s31mr1198547qvs.120.1562293634851;
 Thu, 04 Jul 2019 19:27:14 -0700 (PDT)
MIME-Version: 1.0
References: <20190704105528.74028-1-chiu@endlessm.com> <8f1454ca-4610-03d0-82c4-06174083d463@gmail.com>
In-Reply-To: <8f1454ca-4610-03d0-82c4-06174083d463@gmail.com>
From:   Chris Chiu <chiu@endlessm.com>
Date:   Fri, 5 Jul 2019 10:27:03 +0800
Message-ID: <CAB4CAwc8jJQ2f8vpoB0Y6sc0fJmmrq+5rRuJ+TqGMMgCczRi+A@mail.gmail.com>
Subject: Re: [PATCH v2] rtl8xxxu: Fix wifi low signal strength issue of RTL8723BU
To:     Jes Sorensen <jes.sorensen@gmail.com>
Cc:     Kalle Valo <kvalo@codeaurora.org>,
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

On Fri, Jul 5, 2019 at 12:43 AM Jes Sorensen <jes.sorensen@gmail.com> wrote:
>
> On 7/4/19 6:55 AM, Chris Chiu wrote:
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
> >
> > This commit hand over the antenna control to PTA(Packet Traffic
> > Arbitration), which compares the weight of bluetooth/wifi traffic
> > then determine whether to continue current wifi traffic or not.
> > After PTA take control, The wifi signal will be back to normal and
> > the bluetooth scan can also work at the same time. However, the
> > btcoexist still needs to be handled under different circumstances.
> > If there's a BT connection established, the wifi still fails to
> > connect until BT disconnected.
> >
> > Signed-off-by: Chris Chiu <chiu@endlessm.com>
> > ---
> >
> >
> > Note:
> >  v2:
> >   - Replace BIT(11) with the descriptive definition
> >   - Meaningful comment for the REG_S0S1_PATH_SWITCH setting
> >
> >
> >  drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_8723b.c | 11 ++++++++---
> >  drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c  |  3 ++-
> >  2 files changed, 10 insertions(+), 4 deletions(-)
> >
> > diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_8723b.c b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_8723b.c
> > index 3adb1d3d47ac..ceffe05bd65b 100644
> > --- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_8723b.c
> > +++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_8723b.c
> > @@ -1525,7 +1525,7 @@ static void rtl8723b_enable_rf(struct rtl8xxxu_priv *priv)
> >       /*
> >        * WLAN action by PTA
> >        */
> > -     rtl8xxxu_write8(priv, REG_WLAN_ACT_CONTROL_8723B, 0x04);
> > +     rtl8xxxu_write8(priv, REG_WLAN_ACT_CONTROL_8723B, 0x0c);
> >
> >       /*
> >        * BT select S0/S1 controlled by WiFi
> > @@ -1568,9 +1568,14 @@ static void rtl8723b_enable_rf(struct rtl8xxxu_priv *priv)
> >       rtl8xxxu_gen2_h2c_cmd(priv, &h2c, sizeof(h2c.ant_sel_rsv));
> >
> >       /*
> > -      * 0x280, 0x00, 0x200, 0x80 - not clear
> > +      * Different settings per different antenna position.
> > +      *      Antenna Position:   | Normal   Inverse
> > +      * --------------------------------------------------
> > +      * Antenna switch to BT:    |  0x280,   0x00
> > +      * Antenna switch to WiFi:  |  0x0,     0x280
> > +      * Antenna switch to PTA:   |  0x200,   0x80
> >        */
> > -     rtl8xxxu_write32(priv, REG_S0S1_PATH_SWITCH, 0x00);
> > +     rtl8xxxu_write32(priv, REG_S0S1_PATH_SWITCH, 0x80);
>
> Per the documentation, shouldn't this be set to 0x200 then rather than 0x80?
>
Per the code before REG_S0S1_PATH_SWITCH setting, the driver has told
the co-processor the antenna is inverse.
        memset(&h2c, 0, sizeof(struct h2c_cmd));
        h2c.ant_sel_rsv.cmd = H2C_8723B_ANT_SEL_RSV;
        h2c.ant_sel_rsv.ant_inverse = 1;
        h2c.ant_sel_rsv.int_switch_type = 0;
        rtl8xxxu_gen2_h2c_cmd(priv, &h2c, sizeof(h2c.ant_sel_rsv));

At least the current modification is consistent with the antenna
inverse setting.
I'll verify on vendor driver about when/how the inverse be determined.

Chris

> We may need to put in place so
>
> Cheers,
> Jesme code to detect whether we have normal
> or inverse configuration of the dongle otherwise?
>
> I really appreciate you're digging into this!
