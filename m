Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 86BC7A127F
	for <lists+netdev@lfdr.de>; Thu, 29 Aug 2019 09:21:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727751AbfH2HVm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Aug 2019 03:21:42 -0400
Received: from mail-lj1-f194.google.com ([209.85.208.194]:40434 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726330AbfH2HVl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Aug 2019 03:21:41 -0400
Received: by mail-lj1-f194.google.com with SMTP id e27so1972910ljb.7
        for <netdev@vger.kernel.org>; Thu, 29 Aug 2019 00:21:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=eypPXG0bzTRtjBeUtPdeIwinBSrQDhkgNntc3KH44ag=;
        b=JzGuyYL9mSx7qOwmd1ZG2JCaoVpk7B8qt0dV2yH+tIESRupiNRl4n7e2kdIFP7y1ZM
         XGrPhK8qDCgB74viBTz/ao8wv9BErmYZcAxvmc6tmsubeH3pw5cQUz7YW813HbZRb8TE
         3c9naLgPtEr+0TJOf2RzfWcNM5SVlH2mBzpv/90pg2bfXDP3cB+1DnChNmmH6pyOu2mr
         hUrdEbgt6nCw9qCxKwcMp+yCNuhv4UEV23L7hzndiz4NTwh6mMZ0NfY5t+ldu7zqFzFv
         qSM6D7SpTiKlpdAXq9xriEiGK2I4a2p1OdtQBH0ioyW9e2vdWOrdQOLlTN0fBnweqXfc
         sE/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=eypPXG0bzTRtjBeUtPdeIwinBSrQDhkgNntc3KH44ag=;
        b=IIkDBnyu0A6M4wGL28W/noXPvDzEC4GyZZPjIG08ZMYI5AXAt9ZOn89XlReJiK4L0F
         3Zpz1RbC59F0kKy/1BlgBWUfcMs49K6EaPKyRwh8k02tMlv3rpv9XZNvAdZ6f1EgqdxX
         Lp6YVQzhcAnkq1kNZknI7lsl9e7AjswxErs+8MSGMEevb4aOgJzUyBpdMn+OTmYUA5ND
         XtmAahxmGfDFsNAvZqqr6BoUX1SG5BfcYvtLPtwf3sQ4jKWskKPhe/sSgB26FVJGuVnh
         gvnUFzC/t132wbLLCL3ay9RmZDboUtCfcfjk4DrIw1VkqPBPrctOJpjHGnoWZaGSVBM8
         CFPw==
X-Gm-Message-State: APjAAAV1X1UP3vz0iPSmuY0a888D1I6Iaaoogy4hYQbsvxNkucr+8Pb2
        JHdvwFKUnxaamFh0ZABh9sKrJlgJHYowYfGJ2nM=
X-Google-Smtp-Source: APXvYqztcbuJ18LGsmuYrTuma4rnoGv93OzsgNXD9Jlv6PvgTge5ZDSDb3eFP39MYRRAfOEXatFxh6CAl4aPsUdq5/4=
X-Received: by 2002:a2e:9582:: with SMTP id w2mr4233848ljh.194.1567063299600;
 Thu, 29 Aug 2019 00:21:39 -0700 (PDT)
MIME-Version: 1.0
References: <20190827141938.23483-1-gautamramk@gmail.com> <316fdac3-5fa9-35d5-ad74-94072f19c5fc@gmail.com>
 <CAA93jw6PJXsG++0c+mE8REUb0cD4PU2Xck-J9fD1miuKfxS6BQ@mail.gmail.com>
In-Reply-To: <CAA93jw6PJXsG++0c+mE8REUb0cD4PU2Xck-J9fD1miuKfxS6BQ@mail.gmail.com>
From:   Gautam Ramakrishnan <gautamramk@gmail.com>
Date:   Thu, 29 Aug 2019 12:51:25 +0530
Message-ID: <CADAms0xNAj=hUhz6XmvM7kXBt0BNVb9EkaVdbgRkU_H_9je+_g@mail.gmail.com>
Subject: Re: [net-next] net: sched: pie: enable timestamp based delay calculation
To:     Dave Taht <dave.taht@gmail.com>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        "David S. Miller" <davem@davemloft.net>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Leslie Monis <lesliemonis@gmail.com>,
        "Mohit P . Tahiliani" <tahiliani@nitk.edu.in>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > No module parameter is accepted these days.
> >
> > Please add a new attribute instead,
> > so that pie can be used in both mode on the same host.

We have prepared a new patch which sets the queue delay estimator as
an attribute instead of using module parameters

>
> I note that I think (but lack independent data) this improvement to
> the rate estimator in pie should improve its usability and accuracy
> in low rate or hw mq situations, and with some benchmarking to
> show the cpu impact (at high and low rates) of this improvement as
> well as the network
> impact, the old way should probably be dropped and new way adopted withou=
t
> needing a new variable to control it.
>
> A commit showing the before/after cpu and network impact with a whole
> bunch of flent benchmarks would be great.

We have tested for network impact using flent. However, we are unaware of
any standard methods to test for cpu impact. It would be helpful if
someone could suggest a method to test for cpu impact.
>
> (I'd also love to know if pie can be run with a lower target - like 5ms -
>  with this mod in place)

We will test it with target latencies of 5 and 10 ms as well.
>
> >
> > For a typical example of attribute addition, please take
> > a look at commit 48872c11b77271ef9b070bdc50afe6655c4eb9aa
> > ("net_sched: sch_fq: add dctcp-like marking")
>
> utilizing ce_threshold in this way is actually independent of whether or
> not you are using dctcp-style or rfc3168 style ecn marking.
>
> It's "I'm self congesting... Dooo something! Anything, to reduce the load=
!"
>
>
>
>
> --
>
> Dave T=C3=A4ht
> CTO, TekLibre, LLC
> http://www.teklibre.com
> Tel: 1-831-205-9740



--=20
-------------
Gautam |
