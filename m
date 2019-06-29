Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 61E165ACCC
	for <lists+netdev@lfdr.de>; Sat, 29 Jun 2019 20:05:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726912AbfF2SFG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 29 Jun 2019 14:05:06 -0400
Received: from mail-qt1-f193.google.com ([209.85.160.193]:42548 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726864AbfF2SFG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 29 Jun 2019 14:05:06 -0400
Received: by mail-qt1-f193.google.com with SMTP id s15so10054278qtk.9;
        Sat, 29 Jun 2019 11:05:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=CefZKsmM2A6Zyc/zmiloyjitBBuWqZnhnX2Roepg/v8=;
        b=SUqGZ9YI1laWgDHBPpMtlETbSWecwqPAxFGzkI2dkgJxfiGpOdW4Y/cRsqqTM1hnn+
         tFDic0NyZ9pmOfFBdUAkSzwINjaNzfZs99qQjJoiH/P+/TOMPsZ/FBeHUXGoy9XQMsFr
         ias1NsoZryElyJ2U7x1cDXtsuD5uXPCE66se4JWy390bmiVkLkjuRKyjcevpi+hlzc6d
         g/rCIS+4J55HT6QPYCdentAxynH3fMJMrUo11WIvMXtyaSYmnNbkKeKeF1lrMrqp2NFP
         n0U+sf+7ztTTAUz8wFc78ra53Xy2jYji3q1ooXUJxmntxwmr89bUSCE8gQ1R8OykHrPf
         wMiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=CefZKsmM2A6Zyc/zmiloyjitBBuWqZnhnX2Roepg/v8=;
        b=c3iAl1Xhco4pyJC5llOZSMzbxZ/C0oZ+mVc+/n1BDzg0r38z1ThhHWILyHhUZSEQ3Y
         9Vu98aQPGM+Zj+fotAnXQgz3GodVglZo5uYlFGGBq8JS/fOW85pG5aWs+HayFU1V+hwj
         wrxjPn9KweP5v011r6+HROqs1EoEauxkkz1j8fu/v/iwgTT27D/0OSxuTJuWxW+FWAdA
         pM1VgC5AclvQpPDkyUxxAW3yd807alUpUZQ4Nwcjhg0YWr7kY8XziO+N4fAd5gxAVcgY
         IIP/SuO09/DiDuoTnt947q9nUSH0K98x1EZi1zPh6ZbcagX/z2P5mgzDcKkAnWME1G3B
         n1IQ==
X-Gm-Message-State: APjAAAVkj9l72DUXAE/a0e9Bil/CXmZXIz8iSyqrS88U16j1mwjOems6
        w2fmqGVc2i9P88sZWA/NmindJ/Jc9xhhfedd4e0=
X-Google-Smtp-Source: APXvYqzCHulnQIYseBoHT9xQ4CY1pEKy79Fz7di/DyVOdQQlmHkUWlB0wY0CCW8rkw8RLEyfPWzM9wkfQYLIXw71Eo0=
X-Received: by 2002:a0c:c68d:: with SMTP id d13mr13722232qvj.145.1561831505395;
 Sat, 29 Jun 2019 11:05:05 -0700 (PDT)
MIME-Version: 1.0
References: <4fdda0547f90e96bd2ef5d5533ee286b02dd4ce2.1561819374.git.jbenc@redhat.com>
 <CAPhsuW4ncpfNCvbYHF36pb6ZEBJMX-iJP5sD0x3PbmAds+WGOQ@mail.gmail.com>
In-Reply-To: <CAPhsuW4ncpfNCvbYHF36pb6ZEBJMX-iJP5sD0x3PbmAds+WGOQ@mail.gmail.com>
From:   Song Liu <liu.song.a23@gmail.com>
Date:   Sat, 29 Jun 2019 11:04:54 -0700
Message-ID: <CAPhsuW4Ric_nMGxpKf3mEJw3JDBZYpbeAQwTW_Nrsz79T2zisw@mail.gmail.com>
Subject: Re: [PATCH bpf] selftests: bpf: fix inlines in test_lwt_seg6local
To:     Jiri Benc <jbenc@redhat.com>
Cc:     Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Mathieu Xhonneux <m.xhonneux@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jun 29, 2019 at 11:04 AM Song Liu <liu.song.a23@gmail.com> wrote:
>
> On Sat, Jun 29, 2019 at 7:43 AM Jiri Benc <jbenc@redhat.com> wrote:
> >
> > Selftests are reporting this failure in test_lwt_seg6local.sh:
> >
> > + ip netns exec ns2 ip -6 route add fb00::6 encap bpf in obj test_lwt_seg6local.o sec encap_srh dev veth2
> > Error fetching program/map!
> > Failed to parse eBPF program: Operation not permitted
> >
> > The problem is __attribute__((always_inline)) alone is not enough to prevent
> > clang from inserting those functions in .text. In that case, .text is not
> > marked as relocateable.
> >
> > See the output of objdump -h test_lwt_seg6local.o:
> >
> > Idx Name          Size      VMA               LMA               File off  Algn
> >   0 .text         00003530  0000000000000000  0000000000000000  00000040  2**3
> >                   CONTENTS, ALLOC, LOAD, READONLY, CODE
> >
> > This causes the iproute bpf loader to fail in bpf_fetch_prog_sec:
> > bpf_has_call_data returns true but bpf_fetch_prog_relo fails as there's no
> > relocateable .text section in the file.
> >
> > Add 'static inline' to fix this.
> >
> > Fixes: c99a84eac026 ("selftests/bpf: test for seg6local End.BPF action")
> > Signed-off-by: Jiri Benc <jbenc@redhat.com>
>
> Maybe use "__always_inline" as most other tests do?

I meant "static __always_inline".

Song
