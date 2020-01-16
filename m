Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1DB7213FCB0
	for <lists+netdev@lfdr.de>; Fri, 17 Jan 2020 00:06:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390293AbgAPXGA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jan 2020 18:06:00 -0500
Received: from mail-qv1-f67.google.com ([209.85.219.67]:40878 "EHLO
        mail-qv1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389860AbgAPXF7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jan 2020 18:05:59 -0500
Received: by mail-qv1-f67.google.com with SMTP id dp13so9906484qvb.7;
        Thu, 16 Jan 2020 15:05:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=gMt8+SnETNvSb3er2IKqZvH30KrtlFraAAc0+bmLfy8=;
        b=aCo9b38KWts8WXzzWZLO6NyHm24NRK5AZ1gyZAy0kzRKfAU758kF2Caxkzd/cNs8UF
         1Y8csThLqPBq8MV4gMUlPRbQMfTrbVU4ve/TYfafcsMa6ISYnsX/X24pU+0IgDNRgbPU
         VQzI33opWjFxxHmrVAR7q1TDpN6HGbs7uqOtdAaEiaL0TRv068c3wVlJeW6Y9wZIFvpH
         dyG1KI7f82lNj618TBmExEyl1E3Qndm82VdXwdhsmwk144mBfOuAD+ooWTZK2pZQzsRq
         Gk5SzY5PDoEG90on7p6PJKtdQAp2U/B4eZrUiyE4MqfnP9yEK2q4RdGZ5pPcEVTjwGS6
         gTew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=gMt8+SnETNvSb3er2IKqZvH30KrtlFraAAc0+bmLfy8=;
        b=F4dyuqYpKlEUA4rU1Wmu7S3cEGL68j57PQQYJUz6n0SE3fyo+7jPQYNDHHYHtiyrUZ
         mJetTi9Tz6TkqWnkojEarrNhqtAZ9dlBPdMicbKuBjUJi7GBGxKyIyoFjklf7AA5kuvT
         Jva9TGU/FnL3120sn4GO/zUyZsxuQRJIKWoocOlVn/VNpVtomNONZb+3tLhzNFSus3Y2
         zA9108RivJTDSXI9oQ2etoxFwTxMDIa6VEcxykl452Jbh9jHVdWKctiv6JvHEM9Ys9Kl
         IJVz1EnZ2r+GTH3IzTR0GlCUmVouirSWoS6c4ZUQ0U2PQNvgd4AnrsrHKR4KrssNrcpB
         ZgWw==
X-Gm-Message-State: APjAAAUmFRJnaoW2xMFA9bkHQoiOARbWGaZ40Fp6b/LtUdNmIIdz3QKt
        3YblHM0iN0k5mUiN5BEbhcRG8MYvDrRBdaY7JEc=
X-Google-Smtp-Source: APXvYqxm0/W2knBcgV6QmcH9v3GrczUEyP9YA3sjHEkH2lQPEIR3SHv0joKQo9NtxDo2DxqWajM/E2SZxnAnRTfXpJ8=
X-Received: by 2002:ad4:514e:: with SMTP id g14mr5152752qvq.196.1579215958396;
 Thu, 16 Jan 2020 15:05:58 -0800 (PST)
MIME-Version: 1.0
References: <157918093154.1357254.7616059374996162336.stgit@toke.dk>
 <157918094179.1357254.14428494370073273452.stgit@toke.dk> <CAEf4Bzba5FHN_iN52qRiGisRcauur1FqDY545EwE+RVR-nFvQA@mail.gmail.com>
In-Reply-To: <CAEf4Bzba5FHN_iN52qRiGisRcauur1FqDY545EwE+RVR-nFvQA@mail.gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 16 Jan 2020 15:05:47 -0800
Message-ID: <CAEf4BzYaLd25P7Uu=aFHW_=nHOCPdCpZCcoJobhRoSGQUA49HQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next v3 09/11] selftests: Remove tools/lib/bpf from
 include path
To:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Shuah Khan <shuah@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        linux-rdma@vger.kernel.org,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>,
        clang-built-linux@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 16, 2020 at 2:41 PM Andrii Nakryiko
<andrii.nakryiko@gmail.com> wrote:
>
> On Thu, Jan 16, 2020 at 5:28 AM Toke H=C3=B8iland-J=C3=B8rgensen <toke@re=
dhat.com> wrote:
> >
> > From: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
> >
> > To make sure no new files are introduced that doesn't include the bpf/
> > prefix in its #include, remove tools/lib/bpf from the include path
> > entirely.
> >
> > Instead, we introduce a new header files directory under the scratch to=
ols/
> > dir, and add a rule to run the 'install_headers' rule from libbpf to ha=
ve a
> > full set of consistent libbpf headers in $(OUTPUT)/tools/include/bpf, a=
nd
> > then use $(OUTPUT)/tools/include as the include path for selftests.
> >
> > For consistency we also make sure we put all the scratch build files fr=
om
> > other bpftool and libbpf into tools/build/, so everything stays within
> > selftests/.
> >
> > Signed-off-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
> > ---

BTW, this change also now forces full rebuild regardless if anything
changed or not :(

[...]
