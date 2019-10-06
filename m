Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 750C9CCEB9
	for <lists+netdev@lfdr.de>; Sun,  6 Oct 2019 07:34:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726086AbfJFFeG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 6 Oct 2019 01:34:06 -0400
Received: from mail-qk1-f194.google.com ([209.85.222.194]:39781 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725899AbfJFFeG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 6 Oct 2019 01:34:06 -0400
Received: by mail-qk1-f194.google.com with SMTP id 4so9697184qki.6;
        Sat, 05 Oct 2019 22:34:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=YWBlzp7j5NtHO50MUKYcfjT/iC11Ax2IBgxkPAUPhj0=;
        b=k3xTPvI1WyMnsGBxQgt8I3+aNHrBISBiuKOrzzUI7VuzNZTaKiBGVk0fI01DI6ndCI
         iCGjbWvUG7nA0XyKVyyBK3z0PXwN/AisDab/RqwP/0qWBrwqvpAVGkyjhGveaEswAJ3o
         LiCO/EM1yI6VCipX0aMvfSE9OKjbX9t5ngIahKihnRAQ7B3j91ta/w4c2v3CiumZ2dWj
         zuiPVQjnqth2ewj8dERiaXOlC90tEkmHSYV9+Hd8FqBd+YVUqbhGgGt2tQUbAeTckyop
         2xONGz/C2I3h51wjLi40skBbgbV6wDWsG06ztvSiUALnd0YDYhizpcBDjJWHYvbVbt8t
         tu0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=YWBlzp7j5NtHO50MUKYcfjT/iC11Ax2IBgxkPAUPhj0=;
        b=lIytF9zqYEqnFsKScpE18Q3O6uXobgRUiQX8NNj/wHdb5iqFr8+O5AsCN9tMo1EPXa
         KjKaGXxHLG/fsCx6nokAd8exN2xWhXm3reCOzDwPIUmuJg+/aSWSlPHx9DJgOPF4V8dl
         c9P6MxV3cEAn4mfOvsK8xgmLBKOVH91VjFmyx0yVhQjaCdCUy8OQ9K5cNPP2uXRr0CTC
         KXJB/ejJz9GXzNI2k90oK6E6Esd9q4vqN5DqCpYEotyttMEdrNhx1+/3bHcTfioGrsAx
         YpuJcRx08tY9z5yJPt2ukPd0HpMi72d3j5oNCmMYd9XO49VkV1Hl9CTfzz5YsHb7s1g1
         BHqg==
X-Gm-Message-State: APjAAAUejBs8iTUYalClHLBNCVO/36Eczmg+l7+ZFBPL95be47/LHukh
        hJqw0I5XMWbB4MICoay4XWbRD/k7sMg9OmCu5BOubdgk
X-Google-Smtp-Source: APXvYqyk6QNMDXjjLRAqYriqgrFQyNLUF+XBlyf41KtbFkB141HGkP84h58q3qso/vKzweg4fkxc+arkGRRSiaPf73Y=
X-Received: by 2002:ae9:eb93:: with SMTP id b141mr18515802qkg.36.1570340044539;
 Sat, 05 Oct 2019 22:34:04 -0700 (PDT)
MIME-Version: 1.0
References: <20191006032008.2571427-1-andriin@fb.com> <20191006032008.2571427-3-andriin@fb.com>
 <c2302e65-90e4-adc1-7e6d-7dc324a133c9@fb.com>
In-Reply-To: <c2302e65-90e4-adc1-7e6d-7dc324a133c9@fb.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Sat, 5 Oct 2019 22:33:53 -0700
Message-ID: <CAEf4BzZsKNx=y2WtA2=bV4SBfvEhogudMjx=nrBVBVEFVbrGUQ@mail.gmail.com>
Subject: Re: [PATCH v2 bpf-next 2/3] scripts/bpf: teach bpf_helpers_doc.py to
 dump BPF helper definitions
To:     Alexei Starovoitov <ast@fb.com>
Cc:     Andrii Nakryiko <andriin@fb.com>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        Kernel Team <Kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Oct 5, 2019 at 9:21 PM Alexei Starovoitov <ast@fb.com> wrote:
>
> On 10/5/19 8:20 PM, Andrii Nakryiko wrote:
> > Enhance scripts/bpf_helpers_doc.py to emit C header with BPF helper
> > definitions (to be included from libbpf's bpf_helpers.h).
> >
> > Signed-off-by: Andrii Nakryiko<andriin@fb.com>
> > ---
> >   scripts/bpf_helpers_doc.py      |  155 +-
> >   tools/lib/bpf/bpf_helper_defs.h | 2677 +++++++++++++++++++++++++++++++
> >   2 files changed, 2831 insertions(+), 1 deletion(-)
> >   create mode 100644 tools/lib/bpf/bpf_helper_defs.h
>
> patch 2 adds it. patch 3 deletes it? stress testing git? ;)

oh, wow... I checked cover letter's summary stats, didn't see
bpf_helpers_defs.h there and figured I didn't screw up.. wrong!
