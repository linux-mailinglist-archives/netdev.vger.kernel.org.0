Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 59B63CD9D9
	for <lists+netdev@lfdr.de>; Mon,  7 Oct 2019 02:13:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726757AbfJGANa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 6 Oct 2019 20:13:30 -0400
Received: from mail-qt1-f195.google.com ([209.85.160.195]:45466 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726266AbfJGANa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 6 Oct 2019 20:13:30 -0400
Received: by mail-qt1-f195.google.com with SMTP id c21so16777612qtj.12;
        Sun, 06 Oct 2019 17:13:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=IsIVE2IZg7zRoFf75XZATurzX1xHvEfb7tRbjT/egVo=;
        b=jUUDWa0PhjuqHZ0R5C0SCIknQzlfJZ5X3rIhIp96goxlWNtKX8MqPKmYDqouYVtTSV
         vOpLJK/wmIGkVHjlzFyOMI6745+PT5XycfUiX/5K4NRRZABM7c9XQ9J1NMZ1FOQnLYuK
         0HP4HpkB7+xxd44RDRH9GGuTuPmggFldJEXbqSl/D0mXNMNAkst2UEjKio7hYS/GNXUj
         /rd7XB4BZARwLgMfcGiTwTZYjjmBroW28sgeFlaxvZ4wkSZqYFhhwcXLA8FrAF1b64go
         ic8GIqFdW0msbykiz9bBYgUnKO13PC8gFBh8zc5tPmutIM9RtB0Y4KtfTkpA5WVn1/XN
         NZyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=IsIVE2IZg7zRoFf75XZATurzX1xHvEfb7tRbjT/egVo=;
        b=SsuAvPUakfOPeE2KH9wQhELvutAd2LfcoyCpDtWPNgtXL4Cff/hOqxF7ptbGr5UuKN
         DceIo3nkCsQBKt9I4K+QhlUYMcioijx4Lfq6/+2HK4PRL2XcbTK06YrZbIG7wgLsRw2H
         77auJXjbp3EK/1QI2AygZZG5K47M4TZEtfMEbIOQpbDv22tyL+x4ysn3kNufyrfId2x/
         ishr9DOjpLhpC3Hzld+BEJoZ+bQ/BU2Z0yieUvy0se0v+mQlx9cojI3ld5vfVFsDFUd6
         oDUtPQro1ii3bQSbLozIiksJZe792ff0l4eyKv7lIjCtuJiQuSI5073VYJnhJeXoGzjc
         9Lsg==
X-Gm-Message-State: APjAAAWbgP2uwxKn66z9GKG9xmoY2En2jP8EYzvqGb+o/us/2rss7bJt
        Vr3aX+jh7ocSFIMnTZ3oKD0E6wTRcDOVxSuSgazuypmF27k=
X-Google-Smtp-Source: APXvYqzgCYdqVw+ejAOsu61I2hK3VR+yyvl6JewaYlYaau/2woilm5HNFKT07RvurwZwNkap3SgwiDUMBJKxkCuKNM8=
X-Received: by 2002:a0c:ae9a:: with SMTP id j26mr3139484qvd.163.1570407209267;
 Sun, 06 Oct 2019 17:13:29 -0700 (PDT)
MIME-Version: 1.0
References: <20191006054350.3014517-1-andriin@fb.com> <20191006054350.3014517-4-andriin@fb.com>
 <CAADnVQ+CmZ+=GTrW=GOOnaJBB-th60SEnPacX4w7+gt8bKKueQ@mail.gmail.com>
In-Reply-To: <CAADnVQ+CmZ+=GTrW=GOOnaJBB-th60SEnPacX4w7+gt8bKKueQ@mail.gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Sun, 6 Oct 2019 17:13:18 -0700
Message-ID: <CAEf4BzZ5KUX5obfqxd7RkguaQ0g1JYbKs=RkrHKdDFDGbaSJ_w@mail.gmail.com>
Subject: Re: [PATCH v3 bpf-next 3/3] libbpf: auto-generate list of BPF helper definitions
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Quentin Monnet <quentin.monnet@netronome.com>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Oct 6, 2019 at 4:56 PM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> On Sat, Oct 5, 2019 at 10:46 PM Andrii Nakryiko <andriin@fb.com> wrote:
> >
> > Get rid of list of BPF helpers in bpf_helpers.h (irony...) and
> > auto-generate it into bpf_helpers_defs.h, which is now included from
> > bpf_helpers.h.
> >
> > Suggested-by: Alexei Starovoitov <ast@fb.com>
> > Signed-off-by: Andrii Nakryiko <andriin@fb.com>
> > ---
> >  tools/lib/bpf/.gitignore    |   1 +
> >  tools/lib/bpf/Makefile      |  10 +-
> >  tools/lib/bpf/bpf_helpers.h | 264 +-----------------------------------
> >  3 files changed, 10 insertions(+), 265 deletions(-)
>
> This patch doesn't apply to bpf-next.

Yes, it has to be applied on top of bpf_helpers.h move patch set. I
can bundle them together and re-submit as one patch set, but I don't
think there were any remaining issues besides the one solved in this
patch set (independence from any specific bpf.h UAPI), so that one can
be applied as is.
