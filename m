Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B0D2CCBF22
	for <lists+netdev@lfdr.de>; Fri,  4 Oct 2019 17:28:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389794AbfJDP2L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Oct 2019 11:28:11 -0400
Received: from mail-qk1-f194.google.com ([209.85.222.194]:43605 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389572AbfJDP2K (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Oct 2019 11:28:10 -0400
Received: by mail-qk1-f194.google.com with SMTP id h126so6135805qke.10;
        Fri, 04 Oct 2019 08:28:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=p1aa1gvAUudNo1sXM0Ug5LkQkUHfs3ZS9jV8m0YLU7U=;
        b=Q70kxMmluR4JYuTh7sKv1E8q6D0H5TtKwCX/rVsYa00JNxjK++GdZl3zoiA1vlG1U/
         Vc+j7I59sVX4TeZuZXcKw9pd1trnJWvfL5jJnjYFtjD+ElO8YffE956MVodu1FUxBFEJ
         2LByJtoboVGJZFrlALyANOQgsWuAxI2TXHhx1rr+c/IbFgCCKcwoLqCq7KrwgA79FT1U
         7oRd3aUeVotsg4yZLx31ORgNeZN2rPuGrRez/J9YxDftrlGYAdbPKEqSPt/OnP5F9+B5
         5UqfObyKKW5X2AuLQ9li77FKpnb9/ihA6LEEZ2zTKz9zkLI6O8bqyTvyPTJ0OivNPjWw
         kLlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=p1aa1gvAUudNo1sXM0Ug5LkQkUHfs3ZS9jV8m0YLU7U=;
        b=bvfHszlTSlTfRM5zegcUttSAT/diHLMK+qXQbzON2ZKOncevBFN9m7k9AD4qbYgSDr
         ng4yR4Xe9Vim06uGMeT3MxqAOrnGEyCZc5FmhOLg9dGzjpftw9+xNca82PdxX3AsiSB6
         KlSGYpzkBLYiPh1Hl9r1z9PNnvvb+1jMTH1hKQPr6avzuGmXppjfnC0Q/adamJqqdDPh
         zmJiKtiydz20wgfWznKbNlAC0OxFJ01VIIqpZt26xR1FrqQe6q4A4ryTGudtKfQdx4xo
         4XpUBeSZG1QEIm1tcR7zWamIiny7SN7vUA4QCjcKiTMjxJyKBCGiyBMjYJIuPRBeXagJ
         puZw==
X-Gm-Message-State: APjAAAWFPPtUJCDNG5+jisu5A0gWEVXS88Q4WUrYfmRpGqVHPeHwnGxI
        viDaRf+zb0mSS5FAlIjdTowdCRS3FlCrp/gE8k1jdcU91bQ=
X-Google-Smtp-Source: APXvYqzHtFBF/WEf72DtI4DFsqLpcdoVoifr2RrGNHWOvKjtA8//fnQmqBfp731QfJT5ojgCPPWJ6Muy1+XqgTYpLnM=
X-Received: by 2002:a05:620a:119a:: with SMTP id b26mr10428817qkk.39.1570202889532;
 Fri, 04 Oct 2019 08:28:09 -0700 (PDT)
MIME-Version: 1.0
References: <20191003212856.1222735-1-andriin@fb.com> <20191003212856.1222735-6-andriin@fb.com>
 <da73636f-7d81-1fe0-65af-aa32f7654c57@gmail.com>
In-Reply-To: <da73636f-7d81-1fe0-65af-aa32f7654c57@gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 4 Oct 2019 08:27:58 -0700
Message-ID: <CAEf4BzYRJ4i05prEJF_aCQK5jnmpSUqrwTXYsj4FDahCWcNQdQ@mail.gmail.com>
Subject: Re: [PATCH v3 bpf-next 5/7] libbpf: move bpf_{helpers,endian,tracing}.h
 into libbpf
To:     David Ahern <dsahern@gmail.com>
Cc:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 4, 2019 at 7:47 AM David Ahern <dsahern@gmail.com> wrote:
>
> On 10/3/19 3:28 PM, Andrii Nakryiko wrote:
> > Move bpf_helpers.h, bpf_tracing.h, and bpf_endian.h into libbpf. Ensure
> > they are installed along the other libbpf headers. Also, adjust
> > selftests and samples include path to include libbpf now.
>
> There are side effects to bringing bpf_helpers.h into libbpf if this
> gets propagated to the github sync.
>
> bpf_helpers.h references BPF_FUNC_* which are defined in the
> uapi/linux/bpf.h header. That is a kernel version dependent api file
> which means attempts to use newer libbpf with older kernel headers is
> going to throw errors when compiling bpf programs -- bpf_helpers.h will
> contain undefined BPF_FUNC references.

That's true, but I'm wondering if maintaining a copy of that enum in
bpf_helpers.h itself is a good answer here?

bpf_helpers.h will be most probably used with BPF CO-RE and
auto-generated vmlinux.h with all the enums and types. In that case,
you'll probably want to use vmlinux.h for one of the latest kernels
anyways.

Nevertheless, it is a problem and thanks for bringing it up! I'd say
for now we should still go ahead with this move and try to solve with
issue once bpf_helpers.h is in libbpf. If bpf_helpers.h doesn't work
for someone, it's no worse than it is today when users don't have
bpf_helpers.h at all.
