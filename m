Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BDDB72AE52A
	for <lists+netdev@lfdr.de>; Wed, 11 Nov 2020 01:56:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731805AbgKKA4a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Nov 2020 19:56:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727275AbgKKA42 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Nov 2020 19:56:28 -0500
Received: from mail-lj1-x234.google.com (mail-lj1-x234.google.com [IPv6:2a00:1450:4864:20::234])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C0F5C0613D1;
        Tue, 10 Nov 2020 16:56:24 -0800 (PST)
Received: by mail-lj1-x234.google.com with SMTP id s9so91781ljo.11;
        Tue, 10 Nov 2020 16:56:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ibYHRITwovHehatBTDyOaIjSjp1FDrg3sFv2ExyPAJg=;
        b=jNcwXkwrYvw0eWiBMEOxbPIPR22Yx/0QacAEu2yYjvo+QBozeVYJ+clisFf05DuJXp
         A1KD+RacWwNNFX8p0k7POLJLrSP6hcyouCxOvI0RCX2YTEkCK996fgPSWLofEJc35T2j
         rYxkKvn7yp8tzLuw7QWdbCfgGT6cwKslojAT5yG6fQTv20MURBmcNDAWBYtjqW6w0ljU
         L6bVatzuhr0nRstXJO2N/9LwI2poO4ZagL4VoGY+owMmPFEDTxUZu4Qr7qEk24UqdHod
         tU7iBwElNcxhYxioC9UH1l2xcnZiQssFhQysYV0pGnBe0fhOEqkSTVKxLNjYDSRaNS2o
         rscw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ibYHRITwovHehatBTDyOaIjSjp1FDrg3sFv2ExyPAJg=;
        b=TKxWnu9DaBMX7WawTs29KMr3efKll7VQ11h9ODjZBRM1uh82sZhURrDmn2/nnrIkmX
         HZskQZ4LwshB+pn+3Bb+S7gUVqaVBtrnRXCrz5Ak/yPEcT00if0zV78cMTD/ekBCY6ts
         XaA4/l9xO0fCZLZf1tAEIo3j6SnZJOGn/JQE7WsY0uj+KSOew27R9WWHiP+DbURDTt78
         EBZLxMDJ4sKAYaQLjGzFxmAAfHDhiM/euYcOeFtgQ5G4fwNptfzDdcm6il5xyeN3j2wc
         NT4jy7TrqV/lJDhjJ+LMKUQDBXkyCQqmi4nCHAZWWu4ddxRCrjKba6NZzwmtqF7duzaT
         I6QA==
X-Gm-Message-State: AOAM5316B20LoL8Hv8NQerT08/sMiy3PLjQr6vt4Y8OsHwSMJCQNjK5N
        wrIqKy1J/9g8mHEJMB5fBPrGa+N5PxdhDERWFJh3O4Q8
X-Google-Smtp-Source: ABdhPJyXpdPDUG9zv+bmVQgcmXVyckhNtbIq3YCEjmrJtnNcmvT7IstpPzDBqpyfNBbW+IH35K7rsQRxMJHYl2RP0lo=
X-Received: by 2002:a2e:8982:: with SMTP id c2mr7785523lji.121.1605056174730;
 Tue, 10 Nov 2020 16:56:14 -0800 (PST)
MIME-Version: 1.0
References: <20201106090117.3755588-1-liuhangbin@gmail.com>
 <20201110015013.1570716-1-liuhangbin@gmail.com> <20201110173549.i4osogbqr2pji3ua@kafai-mbp.dhcp.thefacebook.com>
In-Reply-To: <20201110173549.i4osogbqr2pji3ua@kafai-mbp.dhcp.thefacebook.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Tue, 10 Nov 2020 16:56:03 -0800
Message-ID: <CAADnVQJvg2O67T+bVRyFnZP19HpV0yfndX_yosiMYwje57qQkA@mail.gmail.com>
Subject: Re: [PATCHv3 bpf 0/2] Remove unused test_ipip.sh test and add missed
 ip6ip6 test
To:     Martin KaFai Lau <kafai@fb.com>
Cc:     Hangbin Liu <liuhangbin@gmail.com>, bpf <bpf@vger.kernel.org>,
        William Tu <u9012063@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Network Development <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 10, 2020 at 9:39 AM Martin KaFai Lau <kafai@fb.com> wrote:
>
> On Tue, Nov 10, 2020 at 09:50:11AM +0800, Hangbin Liu wrote:
> > In comment 173ca26e9b51 ("samples/bpf: add comprehensive ipip, ipip6,
> > ip6ip6 test") we added some bpf tunnel tests. In commit 933a741e3b82
> > ("selftests/bpf: bpf tunnel test.") when we moved it to the current
> > folder, we missed some points:
> >
> > 1. ip6ip6 test is not added
> > 2. forgot to remove test_ipip.sh in sample folder
> > 3. TCP test code is not removed in test_tunnel_kern.c
> >
> > In this patch set I add back ip6ip6 test and remove unused code. I'm not sure
> > if this should be net or net-next, so just set to net.
> >
> > Here is the test result:
> > ```
> > Testing IP6IP6 tunnel...
> > PING ::11(::11) 56 data bytes
> >
> > --- ::11 ping statistics ---
> > 3 packets transmitted, 3 received, 0% packet loss, time 63ms
> > rtt min/avg/max/mdev = 0.014/1028.308/2060.906/841.361 ms, pipe 2
> > PING 1::11(1::11) 56 data bytes
> >
> > --- 1::11 ping statistics ---
> > 3 packets transmitted, 3 received, 0% packet loss, time 48ms
> > rtt min/avg/max/mdev = 0.026/0.029/0.036/0.006 ms
> > PING 1::22(1::22) 56 data bytes
> >
> > --- 1::22 ping statistics ---
> > 3 packets transmitted, 3 received, 0% packet loss, time 47ms
> > rtt min/avg/max/mdev = 0.030/0.048/0.067/0.016 ms
> > PASS: ip6ip6tnl
> > ```
> >
> > v3:
> > Add back ICMP check as Martin suggested.
> >
> > v2: Keep ip6ip6 section in test_tunnel_kern.c.
> This should be for bpf-next.
>
> Acked-by: Martin KaFai Lau <kafai@fb.com>

git bot got lost.
the patches were applied.
