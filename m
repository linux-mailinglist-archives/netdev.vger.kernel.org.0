Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 217BC2F601
	for <lists+netdev@lfdr.de>; Thu, 30 May 2019 06:53:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728436AbfE3EwA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 May 2019 00:52:00 -0400
Received: from mail-qk1-f193.google.com ([209.85.222.193]:41272 "EHLO
        mail-qk1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728265AbfE3EwA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 May 2019 00:52:00 -0400
Received: by mail-qk1-f193.google.com with SMTP id m18so3036705qki.8
        for <netdev@vger.kernel.org>; Wed, 29 May 2019 21:51:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=endlessm-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=sHOf1/WDs1TjZmoF3swY2gMBdaFm4kQJB8zDdbqYUtY=;
        b=f825F3Seg4ieVRUakmG+2nGqhhygBqwqBaEc1iOc0MaaO0sTSgNmD0hr/deWGkkk8D
         oSBHHzB7EF7mqP05QR1/t5lDvwyi/eGEyhi4RZ0QM2XtWegAbglgw2jrHuJxJtGEE+U9
         VnJmOLG9LhCt2JYLoUxhPWPUkW3FUk81O7cn3GOxPEAw18lba1Uv+HZVT2yS5fqk0gPm
         jFk18XIsCuviYZzfzpUXg5AH9TqFYqgcps9uvKOir++7jxxwIY/nuYgf5ONNA4hBYvl3
         1KlZphriIqtMRf/ZEXrcrdiDzkzZi/lXz4lIkn2ZlRqLkse/MEEdkcMY3XsfRpUhX9bW
         0tjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=sHOf1/WDs1TjZmoF3swY2gMBdaFm4kQJB8zDdbqYUtY=;
        b=bJPHsCePIi+MUJjZIX8araAxaROzEA9C7sk454KjYJ2j6xR2vccBBhvnG7rpBDN0NO
         rBZl/yeQIG0Y4Q+qsb1Fdqw7WPF2aqIWFH0KduIitLHpnOZJr+Y4GsBrvasSZrfkORBb
         Lz9pLDBU78AnaPg4RAT5nz7eZAWdlOMX5mANAwjnFFMwpOMG6i4N2vKUG5x8AaIN3R4C
         MNyzHKxB0hchkmicD6Yvvk0OhVAQwlc5kCUow5Vdv/LG23YWroMhpxx75yEuk8Cr7kXu
         GOSIMBWoZwjQHlzioqjIr2yxbVB7+AHiAkHBVAn2T1GyIcZDrF5sPSNoSCF63yNTnyxJ
         sdUg==
X-Gm-Message-State: APjAAAV+UxOBnK6RzQq2dn0aAAEVdZs20pFrvbbgqRlpKVmZ0n5s7c5R
        z99u554/kKCd/nlTH77UxjzWlaGEWEEjWy+EsIvPBQ==
X-Google-Smtp-Source: APXvYqwJqY9emE8P8Vz0UaW1tHbFbmoM/x5fzvRbbHX2yA78QWUp92wyAA0LNjazNuKGR/CZ3jZwhs+os92Tr1JE+Ug=
X-Received: by 2002:a37:48c4:: with SMTP id v187mr1318465qka.314.1559191919082;
 Wed, 29 May 2019 21:51:59 -0700 (PDT)
MIME-Version: 1.0
References: <20190529050335.72061-1-chiu@endlessm.com> <CAD8Lp46on32VgWtCe7WsGHXp3Jk16qTh6saf0Vj0Y4Ry5z1n7g@mail.gmail.com>
In-Reply-To: <CAD8Lp46on32VgWtCe7WsGHXp3Jk16qTh6saf0Vj0Y4Ry5z1n7g@mail.gmail.com>
From:   Chris Chiu <chiu@endlessm.com>
Date:   Thu, 30 May 2019 12:51:47 +0800
Message-ID: <CAB4CAwfVDfphWNAN5L1f9BCT9Oo3AQwL19BOUTNJNFM=QR7rjQ@mail.gmail.com>
Subject: Re: [RFC PATCH v3] rtl8xxxu: Improve TX performance of RTL8723BU on
 rtl8xxxu driver
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

On Thu, May 30, 2019 at 2:12 AM Daniel Drake <drake@endlessm.com> wrote:
>
> Hi Chris,
>
> On Tue, May 28, 2019 at 11:03 PM Chris Chiu <chiu@endlessm.com> wrote:
> > +       /*
> > +        * Single virtual interface permitted since the driver supports STATION
> > +        * mode only.
>
> I think you can be a bit more explicit by saying e.g.:
>
> Only one virtual interface permitted because only STA mode is
> supported and no iface_combinations are provided.
>
> > diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
> > index 039e5ca9d2e4..2d612c2df5b2 100644
> > --- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
> > +++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
> > @@ -4345,7 +4345,7 @@ void rtl8xxxu_gen2_update_rate_mask(struct rtl8xxxu_priv *priv,
> >         h2c.b_macid_cfg.ramask3 = (ramask >> 24) & 0xff;
> >
> >         h2c.ramask.arg = 0x80;
> > -       h2c.b_macid_cfg.data1 = 0;
> > +       h2c.b_macid_cfg.data1 = priv->ratr_index;
>
> I think ratr_index can be moved to be a function parameter of the
> update_rate_mask function. It looks like all callsites already know
> which value they want to set. Then you don't have to store it in the
> priv structure.
>

You mean moving the ratr_index to be the 4th function parameter of
update_rate_mask which has 2 candidates rtl8xxxu_update_rate_mask
and rtl8xxxu_gen2_update_rate_mask? I was planning to keep the
rtl8xxxu_update_rate_mask the same because old chips seems don't
need the rate index when invoking H2C command to change rate mask.
And rate index is not a common phrase/term for rate adaptive. Theoretically
we just need packet error rate, sgi and other factors to determine the rate
mask. This rate index seems to be only specific to newer Realtek drivers
or firmware for rate adaptive algorithm.  I'd like to keep this for gen2 but
I admit it's ugly to put it in the priv structure. Any suggestion is
appreciated.
Thanks

> > @@ -5471,6 +5509,10 @@ static int rtl8xxxu_add_interface(struct ieee80211_hw *hw,
> >
> >         switch (vif->type) {
> >         case NL80211_IFTYPE_STATION:
> > +               if (!priv->vif)
> > +                       priv->vif = vif;
> > +               else
> > +                       return -EOPNOTSUPP;
> >                 rtl8xxxu_stop_tx_beacon(priv);
>
> rtl8xxxu_remove_interface should also set priv->vif back to NULL.
>
> > @@ -6183,6 +6259,8 @@ static void rtl8xxxu_disconnect(struct usb_interface *interface)
> >         mutex_destroy(&priv->usb_buf_mutex);
> >         mutex_destroy(&priv->h2c_mutex);
> >
> > +       cancel_delayed_work_sync(&priv->ra_watchdog);
>
> Given that the work was started in rtl8xxxu_start, I think it should
> be cancelled in rtl8xxxu_stop() instead.
>
> Daniel
