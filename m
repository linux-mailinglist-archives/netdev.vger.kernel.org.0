Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 89F7CD5D98
	for <lists+netdev@lfdr.de>; Mon, 14 Oct 2019 10:36:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730502AbfJNIgb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Oct 2019 04:36:31 -0400
Received: from mail-wr1-f45.google.com ([209.85.221.45]:38675 "EHLO
        mail-wr1-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730281AbfJNIga (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Oct 2019 04:36:30 -0400
Received: by mail-wr1-f45.google.com with SMTP id y18so9151925wrn.5;
        Mon, 14 Oct 2019 01:36:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=3gmRUmFQrzOfBkzy6ru5FDEj5eSol2+yWvH8vsuXVmk=;
        b=TKoXaAztojGymarvUnBK/B1aJmlEgDUx676yige1BTS81+VJQjPCkPxnRLGV2ewMG2
         yIYL5yZwGLoP2FU6bcFyimZGqCHpXn8EWtwYCvdH1scPYieQRWHzxDO24HCmAzZAAtme
         eP/mfKSb6tEyK/nfadcVSEkSZ80GOja8bHXjSMz+k3flTnACDNzGZhvVKqo/p+CIL03p
         MIdlKHLN74CkWgeg+dvtDOMEjtfiL24fexKDCZrVpZpHMShPK1tzz50H4upki0Z4Q/15
         QdePTGjZn8qjoHUfwstVjW7hWQes7vXxbYW+dyuWNSaSdYrw2TLZv9zidY2tVvvFVFpv
         qXtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=3gmRUmFQrzOfBkzy6ru5FDEj5eSol2+yWvH8vsuXVmk=;
        b=f2NSPuvOPlAUL2+mK0N4wJHNDTZVNF+gs1kl9/0Xx8CYUlBS8J0s2DyqQWHXgPDnP6
         FT9nkKgwSSewdtYVkaFD0/dBExrtcY7twPVwZOio2qKwzlKTmjFzzYVoEMKwl0UTsuIQ
         mniFG1nMjqQL3ylBHLt+J4V10czHKTNTRFJdbw/RrZP+FUJcI5e2GRUVSulgjiJCT3Jt
         RN/+b5lh+wuTum1fsSoEDRsP5O2+qVWRFX/2ZyFMzN24b1cPC9UcvKBd4ealAhoEhgj8
         xbPMpSvyIEwp8edKMSiwNmmHiTEx6XAkHVMKZ0kWNkQxDCDS6dbZK/Kj3JsCN1e0PepE
         pAIA==
X-Gm-Message-State: APjAAAVd+XCIBxKxiXMD9op0VugExRTGWQG2579qlGnd5em8HrjtSAFw
        6HUheOfACQPxgXeNH0FvAcRKPlNj7ji6yK058Bw=
X-Google-Smtp-Source: APXvYqwNGn1xWbNMJrDiXZM/brqGYLBAM1gWyar8Kxd8cg7jz/vSU3x5aAPl0qPDINIZ28Zut7RRd+2Xnl6xsKeDFQM=
X-Received: by 2002:a05:6000:11c5:: with SMTP id i5mr24564196wrx.303.1571042188922;
 Mon, 14 Oct 2019 01:36:28 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1570533716.git.lucien.xin@gmail.com> <066605f2269d5d92bc3fefebf33c6943579d8764.1570533716.git.lucien.xin@gmail.com>
 <60a7f76bd5f743dd8d057b32a4456ebd@AcuMS.aculab.com> <CADvbK_cFCuHAwxGAdY0BevrrAd6pQRP2tW_ej9mM3G4Aog3qpg@mail.gmail.com>
 <20191009161508.GB25555@hmswarspite.think-freely.org>
In-Reply-To: <20191009161508.GB25555@hmswarspite.think-freely.org>
From:   Xin Long <lucien.xin@gmail.com>
Date:   Mon, 14 Oct 2019 16:36:34 +0800
Message-ID: <CADvbK_fb9jjm-h-XyVci971Uu=YuwMsUjWEcv9ehUv9Q6W_VxQ@mail.gmail.com>
Subject: Re: [PATCHv2 net-next 3/5] sctp: add SCTP_EXPOSE_POTENTIALLY_FAILED_STATE
 sockopt
To:     Neil Horman <nhorman@tuxdriver.com>
Cc:     David Laight <David.Laight@aculab.com>,
        network dev <netdev@vger.kernel.org>,
        "linux-sctp@vger.kernel.org" <linux-sctp@vger.kernel.org>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 10, 2019 at 12:18 AM Neil Horman <nhorman@tuxdriver.com> wrote:
>
> On Tue, Oct 08, 2019 at 11:28:32PM +0800, Xin Long wrote:
> > On Tue, Oct 8, 2019 at 9:02 PM David Laight <David.Laight@aculab.com> wrote:
> > >
> > > From: Xin Long
> > > > Sent: 08 October 2019 12:25
> > > >
> > > > This is a sockopt defined in section 7.3 of rfc7829: "Exposing
> > > > the Potentially Failed Path State", by which users can change
> > > > pf_expose per sock and asoc.
> > >
> > > If I read these patches correctly the default for this sockopt in 'enabled'.
> > > Doesn't this mean that old application binaries will receive notifications
> > > that they aren't expecting?
> > >
> > > I'd have thought that applications would be required to enable it.
> > If we do that, sctp_getsockopt_peer_addr_info() in patch 2/5 breaks.
> >
> I don't think we can safely do either of these things.  Older
> applications still need to behave as they did prior to the introduction
> of this notification, and we shouldn't allow unexpected notifications to
> be sent.
Hi, Neil

I think about again, and also talked with QE, we think to get unexpected
notifications shouldn't be a problem for user's applications.

RFC actually keeps adding new notifications, and a user shouldn't expect
the specific notifications coming in some exact orders. They should just
ignore it and wait until the ones they expect. I don't think some users
would abort its application when getting an unexpected notification.

We should NACK patchset v3 and go with v2. What do you think?

>
> What if you added a check in get_peer_addr_info to only return -EACCESS
> if pf_expose is 0 and the application isn't subscribed to the PF event?
>
> Neil
>
> > >
> > >         David
> > >
> > > -
> > > Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
> > > Registration No: 1397386 (Wales)
> > >
> >
