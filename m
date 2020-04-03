Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9786C19DDA8
	for <lists+netdev@lfdr.de>; Fri,  3 Apr 2020 20:10:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404479AbgDCSKh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Apr 2020 14:10:37 -0400
Received: from mail-vs1-f68.google.com ([209.85.217.68]:45187 "EHLO
        mail-vs1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728066AbgDCSKh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Apr 2020 14:10:37 -0400
Received: by mail-vs1-f68.google.com with SMTP id x82so5475278vsc.12
        for <netdev@vger.kernel.org>; Fri, 03 Apr 2020 11:10:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=rZFwcLh88yvLFoU8cFxaAMsHIVK/kbvNYFcbKC3BCso=;
        b=jmtpfdyamIsA1Ylu3Q/6gwghzY6og8+UX/ZfkZuJ6ROuYXbTpehjoFhXuYiOyoEYBE
         8SgfiyG0zzWYFb4teybGEj1op9SUHS9ckHvLKUkNKa8pMBBt8gSrQi7I2FxDRcHvg2lq
         N2UY2EM7oCBqkzhdI2i06UDSCWxD2d9XLXBA4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=rZFwcLh88yvLFoU8cFxaAMsHIVK/kbvNYFcbKC3BCso=;
        b=R1iLBEeV0CFzaorXXEH2kg6LHnUdxoNyr1mQ797tdlS3Wt82R94md2VvzmoxP7suzR
         yGKT6Rl2YqE2Op9KISEjQ58xKJBCRPJEZ8LezSq6Fq9wmOqVKXNGtWWWzeX0UUyJbroe
         MNWvRhaRQQAm+NAV9yvLkHWctdcj5X/ks3NxB+TjxPWra+p2Mh9EsU3vF6131srLGYHx
         h0ZAxeVZIzSlCIEL/W+ESA+2ebwuwxkqXon10Y6UAqbd+tBUN4QlAFifxufoudGNBCu6
         mmZnrF3etp1ueRqjDHJnYVyO/C//Fi/VAma8uspbbnGz2sefMOzLSeo+xGX3QvE7VmMy
         d+qQ==
X-Gm-Message-State: AGi0PuZlaagwBOt/kq4+Hr0Z52nQREoR7Mrxr7NR8pBUQR1ORCGvm6Wr
        LtPMclBmS+hp6sgSskF4Jrf7m7wIglV6RhfYVBb1Ig==
X-Google-Smtp-Source: APiQypJxM9qgTZhmPUIT1h2Szg6sGhwsSGY749rhsDMKaR+M4LwrlPNfAZF627ZfAsj+u/oTmccg/Qr3VE1hGfznd+E=
X-Received: by 2002:a67:d49c:: with SMTP id g28mr8255493vsj.71.1585937434649;
 Fri, 03 Apr 2020 11:10:34 -0700 (PDT)
MIME-Version: 1.0
References: <20200323194507.90944-1-abhishekpandit@chromium.org>
 <20200323124503.v3.1.I17e2220fd0c0822c76a15ef89b882fb4cfe3fe89@changeid> <7FD50BDC-A4B5-4ED9-8DAB-887039735800@holtmann.org>
In-Reply-To: <7FD50BDC-A4B5-4ED9-8DAB-887039735800@holtmann.org>
From:   Abhishek Pandit-Subedi <abhishekpandit@chromium.org>
Date:   Fri, 3 Apr 2020 11:10:23 -0700
Message-ID: <CANFp7mX=LvTzttCHcb14TRF8YukQt_WdMpYzJP5LP_ZXwzQTsQ@mail.gmail.com>
Subject: Re: [PATCH v3 1/1] Bluetooth: Prioritize SCO traffic
To:     Marcel Holtmann <marcel@holtmann.org>
Cc:     Bluetooth Kernel Mailing List <linux-bluetooth@vger.kernel.org>,
        ChromeOS Bluetooth Upstreaming 
        <chromeos-bluetooth-upstreaming@chromium.org>,
        "David S. Miller" <davem@davemloft.net>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Marcel,

Thanks for merging.

I agree that the distinction between SCO/eSCO and ACL/LE is a bit
concerning for scheduling. I will make some time to revisit this as
part of Audio improvements we are making.

Thanks
Abhishek

Abhishek

On Thu, Apr 2, 2020 at 11:56 PM Marcel Holtmann <marcel@holtmann.org> wrote=
:
>
> Hi Abhishek,
>
> > When scheduling TX packets, send all SCO/eSCO packets first, check for
> > pending SCO/eSCO packets after every ACL/LE packet and send them if any
> > are pending.  This is done to make sure that we can meet SCO deadlines
> > on slow interfaces like UART.
> >
> > If we were to queue up multiple ACL packets without checking for a SCO
> > packet, we might miss the SCO timing. For example:
> >
> > The time it takes to send a maximum size ACL packet (1024 bytes):
> > t =3D 10/8 * 1024 bytes * 8 bits/byte * 1 packet / baudrate
> >        where 10/8 is uart overhead due to start/stop bits per byte
> >
> > Replace t =3D 3.75ms (SCO deadline), which gives us a baudrate of 27306=
66.
> >
> > At a baudrate of 3000000, if we didn't check for SCO packets within 102=
4
> > bytes, we would miss the 3.75ms timing window.
> >
> > Signed-off-by: Abhishek Pandit-Subedi <abhishekpandit@chromium.org>
> > ---
> >
> > Changes in v3:
> > * Removed hci_sched_sync
> >
> > Changes in v2:
> > * Refactor to check for SCO/eSCO after each ACL/LE packet sent
> > * Enabled SCO priority all the time and removed the sched_limit variabl=
e
> >
> > net/bluetooth/hci_core.c | 106 +++++++++++++++++++++------------------
> > 1 file changed, 57 insertions(+), 49 deletions(-)
>
> patch has been applied to bluetooth-next tree.
>
> However I have been a bit reluctant to apply this right away. I think whe=
n this code was originally written, we only had ACL and SCO packets. The wo=
rld was pretty simple. And right now we also only have two packets types (i=
gnoring ISO packets for now), but we added LE and eSCO as separate scheduli=
ng and thus =E2=80=9Cfake=E2=80=9D packet types.
>
> I have the feeling that this serialized packet processing will get us int=
o trouble since we prioritize BR/EDR packets over LE packets and SCO over e=
SCO. I think we should have looked at all packets based on SO_PRIORITY and =
with ISO packets we have to most likely re-design this. Anyway, just someth=
ing to think about.
>
> Regards
>
> Marcel
>
