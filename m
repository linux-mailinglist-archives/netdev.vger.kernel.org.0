Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A2F4D11E742
	for <lists+netdev@lfdr.de>; Fri, 13 Dec 2019 16:59:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728085AbfLMP7e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Dec 2019 10:59:34 -0500
Received: from mail-qk1-f193.google.com ([209.85.222.193]:38360 "EHLO
        mail-qk1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728032AbfLMP7e (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Dec 2019 10:59:34 -0500
Received: by mail-qk1-f193.google.com with SMTP id k6so2075048qki.5;
        Fri, 13 Dec 2019 07:59:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=YaGS+weH47I/SZaacTDzVpVmLaiT/qa5rn7n2VFVb9Y=;
        b=aVE4wl6KSCalmJ7U1VEKm/rkYNfZhVpLRikwTrTACbC/1yJAYXPa5AaPbLvcT1eNsK
         HGpFbEZ3QyF15TD8kk+TGNzI3sVrN4Bl0cEwuOZe+GyDExFisB488gT7LxYI2bi1m6ux
         PXVBJKb4K3EnZiXh33eN5FO9z3CzB1t/wJiHEywCzq/j+lW+ukIMAjAgvw47tkGJPCFh
         cnuPaqkE2CWyTdEUNIOGWxv41W2Ekh1swttVoTc8HbrQMSuO+waLhLZnKgJQsKk6KhqI
         Oib6IP+co+cghh1wbOv2UI/cOjmfZFca4S8WipvBE7/7u7VcuZ/boCauUEgZQu4N30Az
         5XsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=YaGS+weH47I/SZaacTDzVpVmLaiT/qa5rn7n2VFVb9Y=;
        b=q5U0q/buCrJM5Sc9bzqovzuoBfHwRzZXff9+SAD75TknCAV8XJCk5S1q3SvKbTHQqD
         ONWkpUCtAzG8zlwZ/z5ncGUFCsni17/nX6IM9NR7V0bZocnAlONWlsl43qWGOEnriYdY
         vDKKYrCL7tM4jk3h84+Rlhl2imrrN6p6BVqVv8lpYOYM55zIdpjxPtimolUUgyvH/0zk
         GtnKtO+GcW2B8CxqvUioV2/ySjidA2urWtzTQ99YdwHak7sDE6BDb4Tx+GLMjeHVwXOI
         6Z8GSr4cN1Ag7l4nmmccvIuKnxAWgi7d//FCCoVSuAD8bd8YWls/sj/z35Bk1u1ikS5m
         QgqQ==
X-Gm-Message-State: APjAAAVIrGvM7ywQgGXbxghbseFVbtq9FUpcz2nhCMnw98lxkR2pmlWj
        hJLUygImPuFYW4YEHyf8eb2jgJc0SO5iLBm3R6DbLO2O0XU=
X-Google-Smtp-Source: APXvYqxFLKs7iTBXOlOj5N91fPNNkFBC18S6wstPhZYLuIZEYqS1lasfVVzxdf1cztoxwctq2NsAW2N52+jrH0Pt7GQ=
X-Received: by 2002:a37:9c0f:: with SMTP id f15mr14210887qke.297.1576252773164;
 Fri, 13 Dec 2019 07:59:33 -0800 (PST)
MIME-Version: 1.0
References: <20191211123017.13212-1-bjorn.topel@gmail.com> <20191211123017.13212-3-bjorn.topel@gmail.com>
 <20191213053054.l3o6xlziqzwqxq22@ast-mbp> <CAJ+HfNiYHM1v8SXs54rkT86MrNxuB5V_KyHjwYupcjUsMf1nSQ@mail.gmail.com>
 <20191213150407.laqt2n2ue2ahsu2b@ast-mbp.dhcp.thefacebook.com>
 <CAJ+HfNgjvT2O=ux=AqdDdO=QSwBkALvXSBjZhib6zGu=AeARwA@mail.gmail.com> <CAADnVQLPJPDGY8aJwrTjOxVaDkZ3KM1_aBVc5jGwxxtNB+dBrg@mail.gmail.com>
In-Reply-To: <CAADnVQLPJPDGY8aJwrTjOxVaDkZ3KM1_aBVc5jGwxxtNB+dBrg@mail.gmail.com>
From:   =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
Date:   Fri, 13 Dec 2019 16:59:22 +0100
Message-ID: <CAJ+HfNg4uAA+++LvhPG8cvkz7X_wjJkB8vYGNeZROaDV6eDXmA@mail.gmail.com>
Subject: Re: [PATCH bpf-next v4 2/6] bpf: introduce BPF dispatcher
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Netdev <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        bpf <bpf@vger.kernel.org>,
        Magnus Karlsson <magnus.karlsson@gmail.com>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Edward Cree <ecree@solarflare.com>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <thoiland@redhat.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 13 Dec 2019 at 16:52, Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> On Fri, Dec 13, 2019 at 7:49 AM Bj=C3=B6rn T=C3=B6pel <bjorn.topel@gmail.=
com> wrote:
> >
> > On Fri, 13 Dec 2019 at 16:04, Alexei Starovoitov
> > <alexei.starovoitov@gmail.com> wrote:
> > >
> > > On Fri, Dec 13, 2019 at 08:51:47AM +0100, Bj=C3=B6rn T=C3=B6pel wrote=
:
> > > >
> > > > > I hope my guess that compiler didn't inline it is correct. Then e=
xtra noinline
> > > > > will not hurt and that's the only thing needed to avoid the issue=
.
> > > > >
> > > >
> > > > I'd say it's broken not marking it as noinline, and I was lucky. It
> > > > would break if other BPF entrypoints that are being called from
> > > > filter.o would appear. I'll wait for more comments, and respin a v5
> > > > after the weekend.
> > >
> > > Also noticed that EXPORT_SYMBOL for dispatch function is not necessar=
y atm.
> > > Please drop it. It can be added later when need arises.
> > >
> >
> > It's needed for module builds, so I cannot drop it!
>
> Not following. Which module it's used out of?

The trampoline is referenced from bpf_prog_run_xdp(), which is
inlined. Without EXPORT, the symbol is not visible for the module. So,
if, say i40e, is built as a module, you'll get a linker error.
