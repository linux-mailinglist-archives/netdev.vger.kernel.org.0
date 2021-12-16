Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6654F477182
	for <lists+netdev@lfdr.de>; Thu, 16 Dec 2021 13:18:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235784AbhLPMSa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Dec 2021 07:18:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234080AbhLPMS3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Dec 2021 07:18:29 -0500
Received: from mail-yb1-xb33.google.com (mail-yb1-xb33.google.com [IPv6:2607:f8b0:4864:20::b33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A93FC061574
        for <netdev@vger.kernel.org>; Thu, 16 Dec 2021 04:18:29 -0800 (PST)
Received: by mail-yb1-xb33.google.com with SMTP id f9so64146667ybq.10
        for <netdev@vger.kernel.org>; Thu, 16 Dec 2021 04:18:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=qCp+wGT7fKJZakvgom/ydnw3EMZZmtlss5G/JKAvScQ=;
        b=DRUEnf5nvq85RQ4G50SrBY6qc/b7PfS4oSqi2sn1r8PhxiJtU7aGE4e25oz7fG8gUD
         NdWzs/0vL7QSpCOAQvsFmEn1Q7N/YBkRRk+/DiN4cGNIVe4j+QPWsC0+kqdDJul2UC3p
         sM33tnGShjMZXMf7jLnh2dOALQfeJ0uaugxCOEPke07UNH169Em+aEu9DzZj1xDVA8E/
         mFux+JR3iApCMDLcp2vb7wmMQA6Mes8fDw7+DTrqMJPogyMFJu+TuI2+pBjZewYMpPI2
         3fVus7brKBi+lpgcVKiLppc4ab7aG6opq8rZJBDceDSGTAKAfhrwD+zjrD5QKXKdwTvx
         nfZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=qCp+wGT7fKJZakvgom/ydnw3EMZZmtlss5G/JKAvScQ=;
        b=d76NXmb1e51J5IBe6dhn7dbF2jtTOMvZQIWqKTJ4t7fCLwZ2DwgIxL/XHCPQRcrwfS
         J/cWiwk+UL9RcirIdBh0Sv/TXF2ihq7p9E5HZUbrjW9X3uuVtDruUOrz3Jfc4eLft6P2
         QqG+Tv8HKo0IS14/QRfASwDJeYW+kGl0B8f0lAGuqTOoywCEMs57R7RK9HUYwhPRmeBs
         qgmCqpeH3IpZ6tiSJHZGErXaBe7g7mdWDDrYKnh4MgXm5mi0PwP/8ykkKbRlxsmQs0eL
         jNAgYMcIUASpfitWJkv15ApmoQUCfNprj+BYSBcNFgmF/s/gcS2LPdlwg/j7IaEILnzM
         h/DQ==
X-Gm-Message-State: AOAM533r5BRZtqGIgheqroNimwvkK1szEjjqa1TOh7MP2V0/5b1TOU/i
        hobOdP+ud8pxB3EaTRrqkAzMyuvNMSuIS43uJlMgDA==
X-Google-Smtp-Source: ABdhPJx3QFINUIywx9N/9CNAgnzvl10jXY6y3jT+cDX3QYApJuLYkPEmoF85vipe3wOb7eLA9IZXvOncR5d1NxEgc1A=
X-Received: by 2002:a25:2344:: with SMTP id j65mr12207551ybj.293.1639657107976;
 Thu, 16 Dec 2021 04:18:27 -0800 (PST)
MIME-Version: 1.0
References: <61baa285.1c69fb81.7e4d7.8287@mx.google.com>
In-Reply-To: <61baa285.1c69fb81.7e4d7.8287@mx.google.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Thu, 16 Dec 2021 04:18:16 -0800
Message-ID: <CANn89iJr+jprQFa9kTDntYcq7n8CrGEDu=V4Ltps6sRMJOyP1A@mail.gmail.com>
Subject: Re: Question about cca9bab1b72cd patch
To:     "clementwei90@gmail.com" <clementwei90@gmail.com>
Cc:     Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Arnd Bergmann <arnd@arndb.de>,
        David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        weirongguang@kylinos.cn, liuyun01@kylinos.cn, xiaolinkui@kylinos.cn
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 15, 2021 at 6:20 PM clementwei90@gmail.com
<clementwei90@gmail.com> wrote:
>
> hello:
> I have a question in patch cca9bab1b72cd ("tcp: use monotonic timestamps =
for PAWS").
> In net/ipv4/tcp_ipv4.c file, before the patch, it was "get_seconds() - tc=
ptw->tw_ts_recent_stamp > 1",
> now it become "time_after32(ktime_get_seconds(), tcptw->tw_ts_recent_stam=
p)".
> Before the patch, the judgment conditions is that the time difference mus=
t greater than 1,
> means that the socket port reuse after 2 seconds. Now the conditions is b=
ecame greater than 0,
> meas it will reuse within 2 seconds. It make difference in tcp_tw_reuse o=
ption and it not explained in the patch description.
> Why do it like this=EF=BC=9FDoes it modify the original logic to make the=
 socket port reuse faster?
> What is the standard in tcp_tw_reuse?
>

If you really care [1], please provide RFC on which this logic is based on.

I say that new code is just fine, and would allow better reuse.

If precise sub-second timing was needed, I guess we would have used
jiffies based tstamp.

[1] By default, tw_reuse is only enabled on loopback.
Applications relying on it should really move on to something else in
our century.

Thank you.


> ---Original---
> From: "clement wei"<clementwei90@gmail.com>
> Date: Tue, Dec 14, 2021 09:13 AM
> To: "Alexey Kuznetsov"<kuznet@ms2.inr.ac.ru>;
> Cc: "Arnd Bergmann"<arnd@arndb.de>;"Eric Dumazet"<edumazet@google.com>;"D=
avid Miller"<davem@davemloft.net>;
> Subject: Re: Question about cca9bab1b72cd patch
>
> Thank you. But I am confused that in > 1, means that the socket port
> reuse after 2 seconds, now the > 0 meas it will reuse within 2
> seconds.
> What is the standard in tcp_tw_reuse?
>
> Alexey Kuznetsov  =E4=BA=8E2021=E5=B9=B412=E6=9C=8813=E6=97=A5=E5=91=A8=
=E4=B8=80 22:52=E5=86=99=E9=81=93=EF=BC=9A
> >
> > On Mon, Dec 13, 2021 at 8:48 PM Arnd Bergmann  wrote:
> > > FWIW, here is the original commit that introduced the '> 1':
> > >
> > > https://git.kernel.org/pub/scm/linux/kernel/git/history/history.git/c=
ommit/net/ipv4/tcp_ipv4.c?h=3Dv2.5.8&id=3Db8439924316d5bcb266d165b93d632a4b=
4b859af
> >
> > Sorry, I cannot tell after so long time. :-)
> >
> > Most likely, > 1 was a mistake, probably coming from worries that > 0 d=
oes
> > not mean that some time has passed. But anyway logic of timestamps
> > does not require that any time actually passed, it is enough that new
> > timestamps are all later than ones sent before. So, time_after32() look=
s right.
