Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5F170143C8B
	for <lists+netdev@lfdr.de>; Tue, 21 Jan 2020 13:07:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729144AbgAUMHG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jan 2020 07:07:06 -0500
Received: from mail-qt1-f196.google.com ([209.85.160.196]:33740 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728655AbgAUMHG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jan 2020 07:07:06 -0500
Received: by mail-qt1-f196.google.com with SMTP id d5so2384224qto.0;
        Tue, 21 Jan 2020 04:07:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=ocAA4rp2v5LQJFVaUNEJKYBfq6c2iJAFtUbkzCPE/us=;
        b=LULWTaPl3G2d8XO/3JB02fv1FNweVLIGZVjkDrU6QMYKBirBorQNRBB90525TP2ERQ
         ZveBTBg3n7f7QNCrpsd+S6QzDMGWrF4I6bL2ffp587cBdKqiUH5JMaS/OsFCTtIaMzyJ
         +1IWQEbzZo0dSFICI38xjVdi6vVO42bObvX/HsL/Aw+uZr7pGZ0VG05EKctmDRDfUpCg
         DomZgiXx0zGe2aU7zta2+GBdVs1WYzfDrBrq6MQdnRy6yJhbpjkDWhNlj0Qe+BT3yXqO
         SFBzMnhdg4sj05KS4KzZNOw3PMVVgjvNHXE/qCFPQjEFx1WDzQ6PAaOxnnXXwUvsCR6h
         fKsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=ocAA4rp2v5LQJFVaUNEJKYBfq6c2iJAFtUbkzCPE/us=;
        b=pe8rG/DOroulxlfOm+nqLXtZyrFyFFJMUsLXJO2EOQGw2jVfjTn90gUY0NJGoJ+W0C
         HkxqwmhPYy3JRbEmj7xzpvy0ug7kTN1FwVCLQVona/cbQHEyc7Pi5tOvyjT3tGuGVpRg
         kDPWcu5Xr5EK716P30e+AtMZIxXL4hBq7gXJwuhsx8Q0dlCbwa6Tgq43vUqvl8EEEaRf
         cfEp08s8oocasSdh883B4JhprN3Bi3lDfLNJzRcncOgd6xCFC7Nx1UQepCMkjdZZTY6Y
         Q4qDnICD/mbrwGd0WBi6cuA3ceVzoqL43bkuEUfPDAYH8VxLIn+i9XbvttlBemCOvaYi
         0TFA==
X-Gm-Message-State: APjAAAXz4fhJP+23M4YU3WFIMQkLc+T2yQrK0rSNdj+/Gg6YY1ZuUiQu
        DdYwvGbugqritwIPPoiEFZygastZkgTRXCUSxrI6fjDqIX0=
X-Google-Smtp-Source: APXvYqzGrlydMYeF5hqn2+BNP9po2Kj6BC90GQz9mdCWF6fBoQ5XlK3Tn1LSRtmLohw+yxBeyTFyEdmVjxSlJTTyMUQ=
X-Received: by 2002:ac8:2310:: with SMTP id a16mr3985386qta.46.1579608425310;
 Tue, 21 Jan 2020 04:07:05 -0800 (PST)
MIME-Version: 1.0
References: <20200120092917.13949-1-bjorn.topel@gmail.com> <5e264a3a5d5e6_20912afc5c86e5c4b5@john-XPS-13-9370.notmuch>
In-Reply-To: <5e264a3a5d5e6_20912afc5c86e5c4b5@john-XPS-13-9370.notmuch>
From:   =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
Date:   Tue, 21 Jan 2020 13:06:54 +0100
Message-ID: <CAJ+HfNirBncXGcath_MKpzbcf3JRBRU7ThpapCQh_zMNqQVtxQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next] xsk, net: make sock_def_readable() have external linkage
To:     John Fastabend <john.fastabend@gmail.com>
Cc:     Netdev <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        bpf <bpf@vger.kernel.org>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 21 Jan 2020 at 01:48, John Fastabend <john.fastabend@gmail.com> wro=
te:
>
> Bj=C3=B6rn T=C3=B6pel wrote:
> > From: Bj=C3=B6rn T=C3=B6pel <bjorn.topel@intel.com>
> >
> > XDP sockets use the default implementation of struct sock's
> > sk_data_ready callback, which is sock_def_readable(). This function is
> > called in the XDP socket fast-path, and involves a retpoline. By
> > letting sock_def_readable() have external linkage, and being called
> > directly, the retpoline can be avoided.
> >
> > Signed-off-by: Bj=C3=B6rn T=C3=B6pel <bjorn.topel@intel.com>
> > ---
> >  include/net/sock.h | 2 ++
> >  net/core/sock.c    | 2 +-
> >  net/xdp/xsk.c      | 2 +-
> >  3 files changed, 4 insertions(+), 2 deletions(-)
> >
>
> I think this is fine but curious were you able to measure the
> difference with before/after pps or something?

Ugh, yeah, of course I've should have added that. Sorry for that! Here
goes; Benchmark is xdpsock rxdrop, NAPI running on core 20:

**Pre-patch: xdpsock rxdrop: 22.8 Mpps
 Performance counter stats for 'CPU(s) 20':

         10,000.58 msec cpu-clock                 #    1.000 CPUs
utilized
                12      context-switches          #    0.001 K/sec
                 1      cpu-migrations            #    0.000 K/sec
                 0      page-faults               #    0.000 K/sec
    29,931,407,416      cycles                    #    2.993 GHz
    82,538,852,331      instructions              #    2.76  insn per
cycle
    15,894,169,979      branches                  # 1589.324 M/sec
        30,916,486      branch-misses             #    0.19% of all
branches

      10.000636027 seconds time elapsed

**Post-patch: xdpsock rxdrop: 23.2 Mpps
         10,000.90 msec cpu-clock                 #    1.000 CPUs
utilized
                12      context-switches          #    0.001 K/sec
                 1      cpu-migrations            #    0.000 K/sec
                 0      page-faults               #    0.000 K/sec
    29,932,353,067      cycles                    #    2.993 GHz
    84,299,636,827      instructions              #    2.82  insn per
cycle
    16,228,795,437      branches                  # 1622.733 M/sec
        28,113,847      branch-misses             #    0.17% of all
branches

      10.000596454 seconds time elapsed

This could fall into the category of noise. :-) PPS and IPC is up a
bit. OTOH, maybe UDP can benefit from this as well?


Bj=C3=B6rn
