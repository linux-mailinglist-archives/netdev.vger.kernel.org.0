Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D234155065
	for <lists+netdev@lfdr.de>; Tue, 25 Jun 2019 15:31:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730497AbfFYNbg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jun 2019 09:31:36 -0400
Received: from mail-qt1-f194.google.com ([209.85.160.194]:43296 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726506AbfFYNbg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jun 2019 09:31:36 -0400
Received: by mail-qt1-f194.google.com with SMTP id w17so18326938qto.10;
        Tue, 25 Jun 2019 06:31:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=mTryXtUWZqdyVYM1MueH/eKMt0k4lXrA890nDMjDJvw=;
        b=gvDSZnncVmD2ytXixlXbMbg5H6QJllwyMAlYP37Q2Rh7uOK9Vik0GdWSC9NYc0glNG
         ksFkbXFn5y8meUo/3FTCikNiJ2ctFCJ21jS3tddKbf2EbcRdLSjdbvkM7dHOEIszk6GX
         nXaGWsIisFaSrjBFClP833Abn8KE+ZZi31CdEpju6znv5Wt29o3ZMufQD5lbRsG7jzfv
         70TJ7MZvQrFYaAdRcyb4TQ3EGGqq/g3MjcSXnw/1aY5hf7wUQpR3wG3mG7lOtNcZAID/
         z6JGINdlFulUlsRPvdAEPu5+/O9hyGqQi0K8Eo2b/BEsNeUL95uMFkW7FYUFw7QcQWg/
         8EFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=mTryXtUWZqdyVYM1MueH/eKMt0k4lXrA890nDMjDJvw=;
        b=C91MB5R9m/dNUYhpZrl1/7OrH7VeJWw9qlGcWVIdJXt4sEmlMZ9CIjk6sItIySLwTb
         83qoGDVLrEVURgGRhg9+JJhbWw3AZ7WXA0cJHralpC2l3IsayR8sfJ88GsuGrFIQeWzk
         a0oeAYglEblLcyL4gHYrmXcATrtIPr5C2Z4rad0+HNBFJq1QnwzwP4ERP0pHVEY56nh/
         54QrZd5PRQ9uHxnLwfCpgLnaeTCdHvBe9iCTtNVF0j2DcOHKy6Iv7opmBwQhwEs0HxMH
         BUN0lte5mIeuwpTEA1/Qfi/IWXlCzU0QztVMq0jdhMrCtDb9dxfInE8qEy+uHsvSFSWf
         HHLw==
X-Gm-Message-State: APjAAAV8/xwlPhHp6B+mE5Oud3cyUIVS2VEtjP6ccfBS+Y7/HvmDfk9U
        Puil8H+D1LFGct8lY+88qMQ9E6xW224B8THJYCU=
X-Google-Smtp-Source: APXvYqw93V5DoDhXhejhj7LdjZ9geUpk1V22E1asOy5waiHJJSohXy4kgAUk0THZBvXINDQz5eWHHsdu72HjzoJXjVc=
X-Received: by 2002:aed:38c2:: with SMTP id k60mr59654852qte.83.1561469495259;
 Tue, 25 Jun 2019 06:31:35 -0700 (PDT)
MIME-Version: 1.0
References: <20190625005536.2516-1-danieltimlee@gmail.com> <878stqdoc9.fsf@toke.dk>
 <20190625120543.12b25184@carbon>
In-Reply-To: <20190625120543.12b25184@carbon>
From:   Song Liu <liu.song.a23@gmail.com>
Date:   Tue, 25 Jun 2019 06:31:24 -0700
Message-ID: <CAPhsuW4RaLzpfOtw4E3cah2PF5jiAmUnWRq1HQoEiKhVitBs5w@mail.gmail.com>
Subject: Re: [PATCH v2] samples: bpf: make the use of xdp samples consistent
To:     Jesper Dangaard Brouer <brouer@redhat.com>
Cc:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        "Daniel T. Lee" <danieltimlee@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 25, 2019 at 5:09 AM Jesper Dangaard Brouer
<brouer@redhat.com> wrote:
>
> On Tue, 25 Jun 2019 11:08:22 +0200
> Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com> wrote:
>
> > "Daniel T. Lee" <danieltimlee@gmail.com> writes:
> >
> > > Currently, each xdp samples are inconsistent in the use.
> > > Most of the samples fetch the interface with it's name.
> > > (ex. xdp1, xdp2skb, xdp_redirect_cpu, xdp_sample_pkts, etc.)
> > >
> > > But some of the xdp samples are fetching the interface with
> > > ifindex by command argument.
> > >
> > > This commit enables xdp samples to fetch interface with it's name
> > > without changing the original index interface fetching.
> > > (<ifname|ifindex> fetching in the same way as xdp_sample_pkts_user.c =
does.)
> > >
> > > Signed-off-by: Daniel T. Lee <danieltimlee@gmail.com>

Acked-by: Song Liu <songliubraving@fb.com>

> > > ---
> > > Changes in v2:
> > >   - added xdp_redirect_user.c, xdp_redirect_map_user.c
> >
> > Great, thanks!
> >
> > Acked-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
>
> Great you basically solved one of our TODOs:
> - TODO Change sample programs to accept ifnames as well as indexes
>
> https://github.com/xdp-project/xdp-project/blob/master/xdp-project.org#ne=
xt-change-sample-programs-to-accept-ifnames-as-well-as-indexes
>
> Acked-by: Jesper Dangaard Brouer <brouer@redhat.com>
>
> --
> Best regards,
>   Jesper Dangaard Brouer
>   MSc.CS, Principal Kernel Engineer at Red Hat
>   LinkedIn: http://www.linkedin.com/in/brouer
