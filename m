Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C7AC07AD6C
	for <lists+netdev@lfdr.de>; Tue, 30 Jul 2019 18:20:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731061AbfG3QUO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jul 2019 12:20:14 -0400
Received: from mail-lj1-f193.google.com ([209.85.208.193]:37434 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725793AbfG3QUO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Jul 2019 12:20:14 -0400
Received: by mail-lj1-f193.google.com with SMTP id z28so8423828ljn.4;
        Tue, 30 Jul 2019 09:20:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=LZrs3EXzgagsIRWCcK5WoYuGudeHWQiiXYHAwY61jDU=;
        b=bztm95dBwDr9C9kSDpfKQcPwa2EypHieXjU6mFF73TIPVFDKcC+ZVsfd5MIFcmOQni
         6AGtZxd9HPhpqBM05juVJGHPE+hVWeUJ1Fnw49h+YBITPeGKyVElOd1zUXW3qVgyAN/y
         J+6kp9BfjQLTC+h276H7ZKL+dzzVushEH6yau7rU7nx20Z/q/MReNPKpPXOiCmQrTRyF
         H4aQv/uOK1PETLR0Pfh5NvjdgMg1sqn2VBpFv2MzYDz8twUFNWifgNC16VqBdIF5pVdt
         hXk24tfKJ7yW7tu3zEgVBVShz0r5w0VZ5PC/ALRl1Gq0qUJ33SUFW/fgyanzEAAPqJQP
         qL5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=LZrs3EXzgagsIRWCcK5WoYuGudeHWQiiXYHAwY61jDU=;
        b=ijd0ln9JDqrA26OhREnviCZEjvANFOHs0cc6DI6ZvG5jB9uyVWzJKYJFgeTSv+/4jU
         F7ftDzZ7zkvXXRPRVUfvuaVFhIALu6zkj46eYKj6A7CYAsZPcBflZrOanwvE6idQnQR/
         aoVTLPVXjPe8cLNUJc8tWCg/ZJM/PxLvUqgMm39/Tv7JrHlKS5Zr0QZpAHARmsS/AD2t
         XwzCfYPDUK4cgjXA85jAdnyKJSFw/ILO0S0aPoWvoLS/e9Ag5cPW1Z3vgf4heqHBfnTu
         2kPRLnDmPuOjY/ZT0XOmN387f0XqgX+uLmBBG6aYfLrCtDDZoQM5XtNVrorvqSgAKnY3
         i1Zg==
X-Gm-Message-State: APjAAAW18YFQjSbKkDeVsqLQKzaaDFzA1A2GQXtyQSIkgbjCG5BoaDHU
        0ZKcd4nU35XQ8IzXJ22Hu35Exe76b32EDJIEYuo=
X-Google-Smtp-Source: APXvYqzTQaxZoBfOrS9yI46mqu2ma/TkyeR74iuHX1SlyTMwjGIa7kAWW2W4RvuHsFshA3b4kO+EgrJJZ6pEcRP1A5E=
X-Received: by 2002:a2e:870f:: with SMTP id m15mr61727485lji.223.1564503612218;
 Tue, 30 Jul 2019 09:20:12 -0700 (PDT)
MIME-Version: 1.0
References: <20190730100429.32479-1-h.feurstein@gmail.com> <20190730100429.32479-5-h.feurstein@gmail.com>
 <20190730160032.GA1251@localhost>
In-Reply-To: <20190730160032.GA1251@localhost>
From:   Hubert Feurstein <h.feurstein@gmail.com>
Date:   Tue, 30 Jul 2019 18:20:00 +0200
Message-ID: <CAFfN3gUCqGuC7WB_UjYYNt+VWGfEBsdfgvPBqxoJi_xitH=yog@mail.gmail.com>
Subject: Re: [PATCH 4/4] net: dsa: mv88e6xxx: add PTP support for MV88E6250 family
To:     Richard Cochran <richardcochran@gmail.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Rasmus Villemoes <rasmus.villemoes@prevas.dk>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Richard,

thank you for your comments.

Am Di., 30. Juli 2019 um 18:00 Uhr schrieb Richard Cochran
<richardcochran@gmail.com>:
[...]
> > -/* Raw timestamps are in units of 8-ns clock periods. */
> > -#define CC_SHIFT     28
> > -#define CC_MULT              (8 << CC_SHIFT)
> > -#define CC_MULT_NUM  (1 << 9)
> > -#define CC_MULT_DEM  15625ULL
> > +/* The adjfine API clamps ppb between [-32,768,000, 32,768,000], and
>
> That is not true.
>
> > + * therefore scaled_ppm between [-2,147,483,648, 2,147,483,647].
> > + * Set the maximum supported ppb to a round value smaller than the maximum.
> > + *
> > + * Percentually speaking, this is a +/- 0.032x adjustment of the
> > + * free-running counter (0.968x to 1.032x).
> > + */
> > +#define MV88E6XXX_MAX_ADJ_PPB        32000000
>
> I had set an arbitrary limit of 1000 ppm.  I can't really see any
> point in raising the limit.
>
> > +/* Family MV88E6250:
> > + * Raw timestamps are in units of 10-ns clock periods.
> > + *
> > + * clkadj = scaled_ppm * 10*2^28 / (10^6 * 2^16)
> > + * simplifies to
> > + * clkadj = scaled_ppm * 2^7 / 5^5
> > + */
> > +#define MV88E6250_CC_SHIFT   28
> > +#define MV88E6250_CC_MULT    (10 << MV88E6250_CC_SHIFT)
> > +#define MV88E6250_CC_MULT_NUM        (1 << 7)
> > +#define MV88E6250_CC_MULT_DEM        3125ULL
> > +
> > +/* Other families:
> > + * Raw timestamps are in units of 8-ns clock periods.
> > + *
> > + * clkadj = scaled_ppm * 8*2^28 / (10^6 * 2^16)
> > + * simplifies to
> > + * clkadj = scaled_ppm * 2^9 / 5^6
> > + */
> > +#define MV88E6XXX_CC_SHIFT   28
> > +#define MV88E6XXX_CC_MULT    (8 << MV88E6XXX_CC_SHIFT)
> > +#define MV88E6XXX_CC_MULT_NUM        (1 << 9)
> > +#define MV88E6XXX_CC_MULT_DEM        15625ULL
> >
> >  #define TAI_EVENT_WORK_INTERVAL msecs_to_jiffies(100)
> >
> > @@ -179,24 +206,14 @@ static void mv88e6352_tai_event_work(struct work_struct *ugly)
> >  static int mv88e6xxx_ptp_adjfine(struct ptp_clock_info *ptp, long scaled_ppm)
> >  {
> >       struct mv88e6xxx_chip *chip = ptp_to_chip(ptp);
> > -     int neg_adj = 0;
> > -     u32 diff, mult;
> > -     u64 adj;
> > +     s64 adj;
> >
> > -     if (scaled_ppm < 0) {
> > -             neg_adj = 1;
> > -             scaled_ppm = -scaled_ppm;
> > -     }
>
> Please don't re-write this logic.  It is written like that for a reason.
I used the sja1105_ptp.c as a reference. So it is also wrong there.

Hubert
