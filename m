Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 85A149F548
	for <lists+netdev@lfdr.de>; Tue, 27 Aug 2019 23:41:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731090AbfH0VlQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Aug 2019 17:41:16 -0400
Received: from mail-io1-f45.google.com ([209.85.166.45]:35501 "EHLO
        mail-io1-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730511AbfH0VlP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Aug 2019 17:41:15 -0400
Received: by mail-io1-f45.google.com with SMTP id b10so1671460ioj.2;
        Tue, 27 Aug 2019 14:41:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=k9+9Hu8LtaqV2cw1LoTggAA9L3QKuBbHOdCcyf8AI58=;
        b=nGag63u/hue8uakpghxzvLChIUygqGosUm4kD2OBI3caD89k1bt58M2O+hGBOIgsRH
         EVe7USVeRpRgc7HlH2QL6fCrx+gQN86LitEdecrnEmrT8RIgoz7uuW+t/28HsQpJ7Ypq
         gUCWgfWsTCJcDOQDv/ajo2fDpn9iFmlCPX0didOLxSIUmWAlGuBvQIjlN6V6vYlVRHgt
         DFZapKCP4ub7ihF7qjLQ3lBwZCOaEiZc/ztlZX55zsE8BXBA4D7Csv+kQuneeNAz1QQA
         0Q184xFpVz6DZwYblpeUqMCD4wGfpCw3jCWRmnKWjtBzJO8U+9gSixHhTL3DfK5H1ho9
         Fcxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=k9+9Hu8LtaqV2cw1LoTggAA9L3QKuBbHOdCcyf8AI58=;
        b=n3ECoficuXetVa3m9CinKHyE30aE3WmcH9ZjAfOQMltpvk46BNWrHxfBcdjvjhnJ2B
         j8NsaSkQ3LN2oYtMzwukFx9E6RilyRweQXTaX8e5pZE8Le+tYRmm5oEFecCsHUxFYXRa
         3ZtCz0bZKTAXF59Fd5smlQ3jAMUZ2dqM0nH+x3F+2pz3COP8M0O+Caj2e4Hye19Iwa7N
         mFdcn21l3n4AOCwkeOhqtncOyXvaU9Tb8zl18H02vhoA9o8WYs4pwhD7g6vDgISK1WCk
         NVxhzYYfU57nMsmnC8yxg/w/O6KmXabFSgDiSWj6Tc9dTDS7yPUBC65jgnvWxnw0k+Z5
         RRnw==
X-Gm-Message-State: APjAAAX30PWonGIO3XfKBspgOn3Rr34IVoeSMrn6JFN+ZbXI291JyFe8
        FpBdT5xQHdlFL5zx2WRum6vQZsKB7LDlMospSKCaDVJv
X-Google-Smtp-Source: APXvYqyT9Cd8H5KzbIgeFP5EbHOWjNdeCOslOptbKoLhSMF3J2FwHIEjNRpT4u6+0EEVwn+Lphqn7QBB5xTb1Dcu6M0=
X-Received: by 2002:a02:cd82:: with SMTP id l2mr991852jap.97.1566942074523;
 Tue, 27 Aug 2019 14:41:14 -0700 (PDT)
MIME-Version: 1.0
References: <CAA5aLPhf1=wzQG0BAonhR3td-RhEmXaczug8n4hzXCzreb+52g@mail.gmail.com>
 <CAM_iQpVyEtOGd5LbyGcSNKCn5XzT8+Ouup26fvE1yp7T5aLSjg@mail.gmail.com>
 <CAA5aLPiqyhnWjY7A3xsaNJ71sDOf=Rqej8d+7=_PyJPmV9uApA@mail.gmail.com>
 <CAM_iQpUH6y8oEct3FXUhqNekQ3sn3N7LoSR0chJXAPYUzvWbxA@mail.gmail.com>
 <CAA5aLPjzX+9YFRGgCgceHjkU0=e6x8YMENfp_cC9fjfHYK3e+A@mail.gmail.com>
 <CAM_iQpXBhrOXtfJkibyxyq781Pjck-XJNgZ-=Ucj7=DeG865mw@mail.gmail.com>
 <CAA5aLPjO9rucCLJnmQiPBxw2pJ=6okf3C88rH9GWnh3p0R+Rmw@mail.gmail.com>
 <CAM_iQpVtGUH6CAAegRtTgyemLtHsO+RFP8f6LH2WtiYu9-srfw@mail.gmail.com>
 <9cbefe10-b172-ae2a-0ac7-d972468eb7a2@gmail.com> <CAA93jw6TWUmqsvBDT4tFPgwjGxAmm_S5bUibj16nwp1F=AwyRA@mail.gmail.com>
 <48a3284b-e8ba-f169-6a2d-9611f8538f07@gmail.com>
In-Reply-To: <48a3284b-e8ba-f169-6a2d-9611f8538f07@gmail.com>
From:   Dave Taht <dave.taht@gmail.com>
Date:   Tue, 27 Aug 2019 14:41:05 -0700
Message-ID: <CAA93jw69=_DnqnOUWaSJqYG-TAQD04j5qkOShNK6WmOU8=Z3mw@mail.gmail.com>
Subject: Re: Unable to create htb tc classes more than 64K
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     Cong Wang <xiyou.wangcong@gmail.com>,
        Akshat Kakkar <akshat.1984@gmail.com>,
        Anton Danilov <littlesmilingcloud@gmail.com>,
        NetFilter <netfilter-devel@vger.kernel.org>,
        lartc <lartc@vger.kernel.org>, netdev <netdev@vger.kernel.org>,
        bloat <bloat@lists.bufferbloat.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 27, 2019 at 2:09 PM Eric Dumazet <eric.dumazet@gmail.com> wrote=
:
>
>
>
> On 8/27/19 10:53 PM, Dave Taht wrote:
> >
> > Although this is very cool, I think in this case the OP is being
> > a router, not server?
>
> This mechanism is generic. EDT has not been designed for servers only.
>
> One HTB class (with one associated qdisc per leaf) per rate limiter
> does not scale, and consumes a _lot_ more memory.
>
> We have abandoned HTB at Google for these reasons.
>
> Nice thing with EDT is that you can stack arbitrary number of rate limite=
rs,
> and still keep a single queue (in FQ or another layer downstream)

There's a lot of nice things about EDT! I'd followed along on the
theory, timerwheels, virtual clocks, etc, and went
seeking ethernet hw that could do it (directly) on the low end and
came up empty - and doing anything with the concept required a
complete rethink on everything we were already doing in
wifi/fq_codel/cake ;(, and after we shipped cake in 4.19, I bought a
sailboat, and logged out for a while.

The biggest problem bufferbloat.net has left is more efficient inbound
shaping/policing on cheap hw.

I don't suppose you've solved that already? :puppy dog eyes:

Next year's version of openwrt we can maybe try to do something
coherent with EDT.

>


--=20

Dave T=C3=A4ht
CTO, TekLibre, LLC
http://www.teklibre.com
Tel: 1-831-205-9740
