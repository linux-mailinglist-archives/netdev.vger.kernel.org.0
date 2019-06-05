Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B6F4F35B52
	for <lists+netdev@lfdr.de>; Wed,  5 Jun 2019 13:34:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727512AbfFELeG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jun 2019 07:34:06 -0400
Received: from mail-ed1-f65.google.com ([209.85.208.65]:44841 "EHLO
        mail-ed1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727172AbfFELeG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Jun 2019 07:34:06 -0400
Received: by mail-ed1-f65.google.com with SMTP id b8so5274772edm.11;
        Wed, 05 Jun 2019 04:34:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Ffft4W2dG10Aqa+pgmYFBdR8SY0KGx8Ycz0fA9eVjTM=;
        b=cJlVjJHjPz3bWzCtQKlPTzde3LowXjTb0IElSQGTO6tDf2HYxoRdKRob446UhQpf1n
         hF15eSwIZ8aXaUP4572hTuiiOWRI5wYRbudhycBDYGnUJaDJXb+Y401gkDF0v4VfZkgY
         AfRxgGD9kgC+tsKPSjh0YyhuRpvc9y1lOnZlVsIqcjrrhWO2rAnD1VdVQ6yHtJ+Nfvfi
         PQ3nVr5O2dvZWEVT5eUthTWoGWWBTIokvCQkGc4Z/2Hx0RyrgfaDUGAuGGvrs/lwA6KL
         wQ47QK1LsfK6RIrOYwHQiPATVhcU0HcL3sgA8mVKd89OxbVeQxuLEzAMYXYWxMk8DX0b
         YkXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Ffft4W2dG10Aqa+pgmYFBdR8SY0KGx8Ycz0fA9eVjTM=;
        b=hYTXDWoxWo8f9nDa8JO0ZiYPnZzqStQN+UzsK2YUAKzeSH2SVWyiKNI4Qp6Ko9/6Au
         zxcDKYW8ST2Nv1B+7ftoTkcil/w9DU/Ym/wA5dYJaqH9yYdF3LDeuQ00Y+zKLd38xEgb
         OWOB1fnJeowlOZ7XM62fv28Ma7bhmCY5gMh4WsWgwz0fAo2QucbGyzkEXpmVlW0FYaEn
         EoxPuGDMQ5jVW0S/xPC7nWKAdt3uJZXeuTEUwMr8NhotlW2h7MybzAyXbESWimokb65k
         qgquyB2ksS/XAIDYED4MpwouWWPeJKNigbCYOw9DeRq1skaNCocoR7Ic65A5/Ov4HmrZ
         nZvA==
X-Gm-Message-State: APjAAAWjDUrtbhuC3pqBYs50Jl3M/XkuYOtZNNeZuCL6fklEW6OHTZzH
        8OWHVe9aq4CkynqkCV/6yJJl95rqsotolYsTBqc=
X-Google-Smtp-Source: APXvYqyz5CJloJ5iU/NThds1L1q9p6IEIVbEjY72UDoMwT+iqrurdaIccGbBpHYY/Y3BotFHUhMW7SkJxbsVMFfsfGA=
X-Received: by 2002:a50:ba1b:: with SMTP id g27mr22529379edc.18.1559734444077;
 Wed, 05 Jun 2019 04:34:04 -0700 (PDT)
MIME-Version: 1.0
References: <20190604170756.14338-1-olteanv@gmail.com> <20190604.202258.1443410652869724565.davem@davemloft.net>
 <CA+h21hq1_wcB6_ffYdtOEyz8-aE=c7MiZP4en_VKOBodo=3VSQ@mail.gmail.com>
In-Reply-To: <CA+h21hq1_wcB6_ffYdtOEyz8-aE=c7MiZP4en_VKOBodo=3VSQ@mail.gmail.com>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Wed, 5 Jun 2019 14:33:52 +0300
Message-ID: <CA+h21hrJYm4GLn+LpJ623_dpgxE2z-k3xTMD=z1QQ9WqXg7zrQ@mail.gmail.com>
Subject: Re: [PATCH v3 net-next 00/17] PTP support for the SJA1105 DSA driver
To:     David Miller <davem@davemloft.net>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Richard Cochran <richardcochran@gmail.com>,
        John Stultz <john.stultz@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Stephen Boyd <sboyd@kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 5 Jun 2019 at 12:13, Vladimir Oltean <olteanv@gmail.com> wrote:
>
> On Wed, 5 Jun 2019 at 06:23, David Miller <davem@davemloft.net> wrote:
> >
> > From: Vladimir Oltean <olteanv@gmail.com>
> > Date: Tue,  4 Jun 2019 20:07:39 +0300
> >
> > > This patchset adds the following:
> > >
> > >  - A timecounter/cyclecounter based PHC for the free-running
> > >    timestamping clock of this switch.
> > >
> > >  - A state machine implemented in the DSA tagger for SJA1105, which
> > >    keeps track of metadata follow-up Ethernet frames (the switch's way
> > >    of transmitting RX timestamps).
> >
> > This series doesn't apply cleanly to net-next, please respin.
> >
> > Thank you.
>
> Hi Dave,
>
> It is conflicting because net-next at the moment lacks this patch that
> I submitted to net:
> https://git.kernel.org/pub/scm/linux/kernel/git/davem/net.git/commit/?id=e8d67fa5696e2fcaf956dae36d11e6eff5246101
> What would you like me to do: resubmit after you merge net into
> net-next, add the above patch to this series (which you'll have to
> skip upon the next merge), or you can just cherry-pick it and then the
> series will apply?
>
> Thanks!
> -Vladimir

In the meantime: Richard, do you have any objections to this patchset?
I was wondering whether the path delay difference between E2E and P2P
rings any bell to you.

Thank you,
-Vladimir
