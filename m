Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 837D510AFDF
	for <lists+netdev@lfdr.de>; Wed, 27 Nov 2019 14:03:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726694AbfK0NDB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Nov 2019 08:03:01 -0500
Received: from mail-qt1-f193.google.com ([209.85.160.193]:39576 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726520AbfK0NDA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Nov 2019 08:03:00 -0500
Received: by mail-qt1-f193.google.com with SMTP id g1so15869301qtj.6;
        Wed, 27 Nov 2019 05:02:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=1984T7r6pANtFAuP4BoKNpZAvUp4hUdF7V9m7It1Qd8=;
        b=tWDwn0Xmuoj1nThJAJWbNrdNuSfB63SihYvpYH2nLaGeoKTeLoXKjQp9x9odtZ4biM
         /PQTZ2yhQpUth5SN2YhmmQEhZ/XYy/TLtozMtimbijQFecmVnhoYZGK1D5YNXnhZP/Qu
         GM1Og2kJAgnNPMSY+lkb4DrQ3v5up3UIue2qjOZMAzyezcIv6OnJGJdxBld9XfSne8p+
         ZL6MV/iBATOjajqHNM2RpRA/T6ZAWyWRU2kOidk7gfvC6Q9JPaFSq2xJ6ud0IT92A5FE
         u+XUmNBQbAzDyVTPpbdOBozmKU4Di+H1ddUirJO66RXJsyhI0KrrKgv6fYUIf/VqH/bm
         g1Wg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=1984T7r6pANtFAuP4BoKNpZAvUp4hUdF7V9m7It1Qd8=;
        b=UuzbeoaTFRSCOmOg3oAQm5wo+ZLq+p6CpiUD+ISgRb/smTW7Q17CZYUZ/HIQwqi6hR
         SB3QbG6dBsVuBhThWYsq5K4Eo2I/07D9hSdcSY90C5UIOc9qeoekAV9NUDkm4BrmnkLq
         vdiLFJdQvNgZnyVbqi8GHDpRoNBrdbGS9CUYEbRFY3Spj9l1tqx/V8lgZGzWtSZV0HB7
         8B3sbP3zzLXbTHMvpjXocyRQEnhybB2LSgjOhSD+QYalHhirsAyeTe7ZUJIjD3+FhdD0
         aSZkofIgOXydprp+UlB8wt7TWISChAAWy6q7Vz2NkVadEvy71Z3UAENzNV1VIHLYc9aE
         d9sw==
X-Gm-Message-State: APjAAAWbWIRFPbjBa7Ebt31xkAcxzfH0x2VfGWYnw1XIEBGCoGMjzPFZ
        1M2XBysaAvMUob1HGrEEBaA8P7/eaKF5KTCdK/o=
X-Google-Smtp-Source: APXvYqwQvuvKMWrK5N5Jn+YzXQ/5ZnAZRptOXQTosdAgRrCmLaMtjetuntgaTqUCtzQXvWy8ulKRp5jZIs6k8Zajin0=
X-Received: by 2002:ac8:2b86:: with SMTP id m6mr7890232qtm.190.1574859778014;
 Wed, 27 Nov 2019 05:02:58 -0800 (PST)
MIME-Version: 1.0
References: <20191127054358.GA59549@LGEARND20B15> <46dfe877-4f32-b763-429f-7af3a83828f0@cogentembedded.com>
In-Reply-To: <46dfe877-4f32-b763-429f-7af3a83828f0@cogentembedded.com>
From:   Austin Kim <austindh.kim@gmail.com>
Date:   Wed, 27 Nov 2019 22:02:49 +0900
Message-ID: <CADLLry4jOr1S7YhdN5saRCXSnjTt_J=TB+sm=CjbcW9NJ4V7Pg@mail.gmail.com>
Subject: Re: [PATCH] brcmsmac: Remove always false 'channel < 0' statement
To:     Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Cc:     arend.vanspriel@broadcom.com, franky.lin@broadcom.com,
        hante.meuleman@broadcom.com, chi-hsien.lin@cypress.com,
        wright.feng@cypress.com, Kalle Valo <kvalo@codeaurora.org>,
        davem@davemloft.net, linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        brcm80211-dev-list@cypress.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

2019=EB=85=84 11=EC=9B=94 27=EC=9D=BC (=EC=88=98) =EC=98=A4=ED=9B=84 7:48, =
Sergei Shtylyov
<sergei.shtylyov@cogentembedded.com>=EB=8B=98=EC=9D=B4 =EC=9E=91=EC=84=B1:
>
> On 27.11.2019 8:43, Austin Kim wrote:
>
> > As 'channel' is declared as u16, the following statement is always fals=
e.
> >     channel < 0
> >
> > So we can remove unnecessary 'always false' statement.
>
>     It's an expression, not a statement.
>

According to below link, it is okay to use 'statement' in above case.
https://en.wikipedia.org/wiki/Statement_(computer_science)

Why don't you show your opition about patch rather than commit message?

Thanks,
Austin Kim

> > Signed-off-by: Austin Kim <austindh.kim@gmail.com>
> > ---
> >   drivers/net/wireless/broadcom/brcm80211/brcmsmac/main.c | 2 +-
> >   1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmsmac/main.c b/=
drivers/net/wireless/broadcom/brcm80211/brcmsmac/main.c
> > index 3f09d89..7f2c15c 100644
> > --- a/drivers/net/wireless/broadcom/brcm80211/brcmsmac/main.c
> > +++ b/drivers/net/wireless/broadcom/brcm80211/brcmsmac/main.c
> > @@ -5408,7 +5408,7 @@ int brcms_c_set_channel(struct brcms_c_info *wlc,=
 u16 channel)
> >   {
> >       u16 chspec =3D ch20mhz_chspec(channel);
> >
> > -     if (channel < 0 || channel > MAXCHANNEL)
> > +     if (channel > MAXCHANNEL)
> >               return -EINVAL;
> >
> >       if (!brcms_c_valid_chanspec_db(wlc->cmi, chspec))
>
> MBR, Sergei
>
