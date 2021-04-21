Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B3E053664A3
	for <lists+netdev@lfdr.de>; Wed, 21 Apr 2021 06:51:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234921AbhDUEua (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Apr 2021 00:50:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234885AbhDUEua (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Apr 2021 00:50:30 -0400
Received: from mail-il1-x12a.google.com (mail-il1-x12a.google.com [IPv6:2607:f8b0:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7EE19C06174A
        for <netdev@vger.kernel.org>; Tue, 20 Apr 2021 21:49:56 -0700 (PDT)
Received: by mail-il1-x12a.google.com with SMTP id e14so10195932ils.12
        for <netdev@vger.kernel.org>; Tue, 20 Apr 2021 21:49:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=+Ko/eAFiZqjEkPVtUUT/TOVCljggaNoN7NIwsD3ukV0=;
        b=Tsx/fNM7AFzawjWlmK2LIGWriCB1OmVekEJfCbYeHU37JB3+Bo9Rte0kuFTvpJwb4/
         AJO27l386QTHc+S1td5atvc+C33Tmsevqbqu6phYYrwjJUQ5QtAbje7txwnKbQWKoUbP
         J3UgMKpxWoWTcn8llbbbRfSjRyL8S1FHgvHAaEir9lSCiEyrhjU2iI2kCaADvnsEkFLN
         ONzVlrS+TpOaNMx0braGHx3GSuCkyOdx1VE9btRmJNOb5E6GFc85NPg2FXqI0tE0tXzo
         sM3h6c+q9nDYQEcxGbhoshYe9dNpptwJ3v72lkyKdTa0uNK0qGzsHiXfvlvGBvturfJC
         t/Ng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=+Ko/eAFiZqjEkPVtUUT/TOVCljggaNoN7NIwsD3ukV0=;
        b=TgSIu9ttN5phEYW26rJFzp4QEJ/RDrKm7D7DtbcQThIJQFQEGTsOGMxx9dxuk/fwpG
         LwNxfDPZvDTeWcJ+OWN25W1NWG95QpeYhktKh2MKHKHXtoON1f7QGdDM6pZttSs2HCc0
         6SwIM01NVuDuKqbHka0MYo36MhK1P+IWNLGbeJl+bLZ08YNZrdifykViaStWLtLMygyQ
         Rlp0QlqGk9XAcEhEhayMizIuFkUooZanbM8T/ewr9U0AB55eKUss8HVBO34CigTfxCKp
         Qk8CWA4dTNwzWbpeRi8iC4/l1j8GSdy99A0cSMEDKkmZCULT8g6iHBdH+HdJrZagn/lc
         EO7A==
X-Gm-Message-State: AOAM532sfzFVODTlkUwscThFYGrvD886864xnyhK6jaT00WOgXkLcedj
        NmTaRQIp0QdYL79Gs64vl0SoqnKfsojLJ0kAMBU=
X-Google-Smtp-Source: ABdhPJzfr2a7DXkGwUpQlwM2aAGOkw6YzJ/IerzkZcmQkw54eE4quS93KRPmHaYHKwFDHw1QGw61Q/GmMqTS/RJE2Kw=
X-Received: by 2002:a05:6e02:80b:: with SMTP id u11mr25327465ilm.153.1618980595901;
 Tue, 20 Apr 2021 21:49:55 -0700 (PDT)
MIME-Version: 1.0
References: <9008a711-be95-caf7-5c56-dad5450e8f5c@gmail.com>
 <20210420082636.1210305-1-Tony.Ambardar@gmail.com> <20210420081608.3287f75f@hermes.local>
In-Reply-To: <20210420081608.3287f75f@hermes.local>
From:   Tony Ambardar <tony.ambardar@gmail.com>
Date:   Tue, 20 Apr 2021 21:49:46 -0700
Message-ID: <CAPGftE-a5cEPBLV=52pYhXQ1Qi7B2gkg-H9VdrS-CXivN=m3LA@mail.gmail.com>
Subject: Re: [PATCH iproute2 v2] ip: drop 2-char command assumption
To:     Stephen Hemminger <stephen@networkplumber.org>
Cc:     David Ahern <dsahern@gmail.com>,
        Networking <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 20 Apr 2021 at 08:16, Stephen Hemminger
<stephen@networkplumber.org> wrote:
>
> On Tue, 20 Apr 2021 01:26:36 -0700
> Tony Ambardar <tony.ambardar@gmail.com> wrote:
>
> > The 'ip' utility hardcodes the assumption of being a 2-char command, where
> > any follow-on characters are passed as an argument:
> >
> >   $ ./ip-full help
> >   Object "-full" is unknown, try "ip help".
> >
> > This confusing behaviour isn't seen with 'tc' for example, and was added in
> > a 2005 commit without documentation. It was noticed during testing of 'ip'
> > variants built/packaged with different feature sets (e.g. w/o BPF support).
> >
> > Mitigate the problem by redoing the command without the 2-char assumption
> > if the follow-on characters fail to parse as a valid command.
> >
> > Fixes: 351efcde4e62 ("Update header files to 2.6.14")
> > Signed-off-by: Tony Ambardar <Tony.Ambardar@gmail.com>
> > ---
> > v2: (feedback from David Ahern)
> >   * work around problem but remain compatible with 2-char assumption
>
> I am ok with this, but if you change the name of command, you can expect some
> friction (and non support).
>

The renamed binaries are normally accessed via an 'ip' symlink managed
at package installation, so shouldn't be an issue. I only discovered
the problem while running regression tests on the the underlying
binaries, and thought to fix things.

> The original commit was inherited from the original integration of tarball's
> into BitKeeper. This "feature" was put in by Alexey Kuznetsov back in orignal 2.4
> time frame.

Thanks for the feedback and additional detail,
Tony
