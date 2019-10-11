Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3C618D469C
	for <lists+netdev@lfdr.de>; Fri, 11 Oct 2019 19:29:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728585AbfJKR2v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Oct 2019 13:28:51 -0400
Received: from mail-io1-f68.google.com ([209.85.166.68]:41354 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728400AbfJKR2v (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Oct 2019 13:28:51 -0400
Received: by mail-io1-f68.google.com with SMTP id n26so23111262ioj.8;
        Fri, 11 Oct 2019 10:28:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=frrCbAZAd68hKoLuiOOGlE5hHEH6QkBVxhQEVUgPYRY=;
        b=uIIO1nQyPQz/S9w2WtpCS/4aeSLRGaiSgqpChH+47hSJeX5nhlRWavPGULpHAFjlUx
         aeByzJ5MhMbRFAXZb2CEaBHoeC6C1i/7hzJDP3fl9Ay6PpKTcJzZw2Rvbqbxes+/g3BN
         wnRtjd2g+CW4YvDzl9rwfVbBh7Jpc5LOlaOZncK/wtnu+y5yEjAYLSPZVB+ICBrs99Z6
         OQBkZEPJK6Gwwec0NB2sHlEBvbqnbxIAy98R6wpFUF0lZO9VwRsl6uRasrGfU2xWll93
         7xFKDn1fuzF2s1YNBhMnEX1lRTyxxv5zQm3Gf0hhDoOkqyNF5qy9e4+vJuVzSwFD5O2z
         m95g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=frrCbAZAd68hKoLuiOOGlE5hHEH6QkBVxhQEVUgPYRY=;
        b=IUSkSCv9cFdFuSMN7hWP2mFk3jkQEn9Wy8SPtkTDLm8zvDRiM6iZgmejFyIvxwJecz
         vp4oRLBeNe8PcjrRyTpIZAKyA5b2Yxbe6d1x8FYpgj/0xJI/O3NIgUMaZihD8PFCAFnj
         Gi3IdwujniAhhFmCA+LJgCpBe15NN1U2QxdzKjab300N5oVAbtoM2/aPX0zDUm36OJHt
         /hSEgtuiFGV8I1hIo07MUqPmGUY6Qsn+lbn+/95BmO5/FpBiEq+ZT+SgfoCLOmsR3iPC
         wH5ESwAdJ0xvbIrHzw26LeF5oOxWUkz1w8YiGAs8RlT+v+rolDILwWUE7qeZCiOWWKbt
         6OVA==
X-Gm-Message-State: APjAAAVoXooFkPW0DUJsrDekUFcFd4iwt2sqMNPVy5VjWtQLMheHJ6l7
        +/aHhsHPpRm/KqIEGPNK6w25IPwjrqQetSnT0DE=
X-Google-Smtp-Source: APXvYqzJDFVnISNwP93ew14GUbMDPf0EA5Qck1Go7sdVCs+QHn0R/7V7Avw/vi26Y8PTjiyKsUKh8ZQIVe6jwF6ARuI=
X-Received: by 2002:a5d:80d3:: with SMTP id h19mr701429ior.156.1570814930427;
 Fri, 11 Oct 2019 10:28:50 -0700 (PDT)
MIME-Version: 1.0
References: <20191011031318.388493-1-andriin@fb.com> <20191011031318.388493-3-andriin@fb.com>
 <20191011162117.ckleov43b5piuzvb@kafai-mbp.dhcp.thefacebook.com>
In-Reply-To: <20191011162117.ckleov43b5piuzvb@kafai-mbp.dhcp.thefacebook.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 11 Oct 2019 10:28:39 -0700
Message-ID: <CAEf4BzZmWLQRxW_gnJEbxZPp6K_RPGXn-MYKetVD0P-yCHwTtw@mail.gmail.com>
Subject: Re: [Potential Spoof] [PATCH bpf-next 2/2] selftests/bpf: remove
 obsolete pahole/BTF support detection
To:     Martin Lau <kafai@fb.com>
Cc:     Andrii Nakryiko <andriin@fb.com>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        Kernel Team <Kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 11, 2019 at 9:21 AM Martin Lau <kafai@fb.com> wrote:
>
> On Thu, Oct 10, 2019 at 08:13:18PM -0700, Andrii Nakryiko wrote:
> > Given lots of selftests won't work without recent enough Clang/LLVM that
> > fully supports BTF, there is no point in maintaining outdated BTF
> > support detection and fall-back to pahole logic. Just assume we have
> > everything we need.
> May be an error message to tell which llvm is needed?

Not sure where we'd want this to be checked/printed. We don't do this
today, so what I'm doing here is not really a regression.
There is no single llvm version I'd want to pin down. For most tests
LLVM w/ basic BTF support would be enough, for CO-RE stuff we need the
latest Clang 10 (not yet released officially), though. So essentially
the stance right now is that you need latest Clang built from sources
to have all the tests compiled and I don't think it's easy to check
for that.

>
> $(CPU) and $(PROBE) are no longer needed also?

Good catch, removing them as well.
