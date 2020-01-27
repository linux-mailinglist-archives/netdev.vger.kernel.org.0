Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 88B1214AA07
	for <lists+netdev@lfdr.de>; Mon, 27 Jan 2020 19:46:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726327AbgA0Sqr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jan 2020 13:46:47 -0500
Received: from mail-lf1-f67.google.com ([209.85.167.67]:34387 "EHLO
        mail-lf1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725955AbgA0Sqr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jan 2020 13:46:47 -0500
Received: by mail-lf1-f67.google.com with SMTP id l18so7015376lfc.1;
        Mon, 27 Jan 2020 10:46:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=r6j8ZrHqnAL/W88gLwdWKIRQ3rx0fpmE67YlL/tBUZc=;
        b=lF5K5DZKcEB8ULYyKv4nCNl2jy1/WL5idqfUViOv5GytKmCl59Tn5W0JOKslCkyuWm
         s0P8fpf5gFaaT3SA2+DCPBk9SmhnQrqq7GSp80/lR7tcjcBhPp2nW2uqz/YABAoyD6nc
         /Pl5mvcAsKVOZdwmnzeS9yNMB+EEFMlywhm1aKW8H2yZPhGVA8PNnI0U41+G6RYPwTl3
         o13NGiYYOUzdCO7RJAWJc30uDIwM9m8ZgF0U/hyafV9zo+8wjLAjqR1cKJdLvPx8fSoI
         YAzIOi1rHpc9GfiO8/XFOqsghaRb3xChQCgnwVMl2Kxjjm2sDF7jBAZHF7XF9Wd66G9X
         aVbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=r6j8ZrHqnAL/W88gLwdWKIRQ3rx0fpmE67YlL/tBUZc=;
        b=J2bUcBuxm8Ee3E/EXhilBec1Q+RTXfYsKYIuQaGnqqGCZVOlysO+mfEvU2z04i/mmd
         cu9NU+2Ev+JAFvirTMoZ90PB9agNCc0R6E4jHZvJSMGNFL0RhSj9/a3mnB2DfL+LFhuo
         AC/QbzfzqjuqeAHPkNAH0NazrAOhhUM4VhM6bLGP9bwvrF5G0be272qkV5+EBosNMZGQ
         d3uERxd9NW+oSz8XfNAh61J3wFHO2Wdcc8hXrJKxPYvk457TMjmjhgBZiDXEFjMB1Ba+
         OlolmmtSh5F6mF35m5kh0iaHWekXeapYMp5tU4p/KbDpNXb9FLJ0ooPPZP1A9RmRCWnO
         j2KA==
X-Gm-Message-State: APjAAAX7OM1nRE1Od2GZscEp27UdmyVKTLARg0T/1QJOXsXz4aKlGEzV
        KDGGyhUx1g63IklFM943R81m8oxy3abhaTrW0g0=
X-Google-Smtp-Source: APXvYqxIrSIoPOAfM2CqC4CpGwBvS9FF2EPJPH+76gg65eXVlPam6BFaicgKM0R+skYXkazNS9BZwOIb+0jBks2b0Qw=
X-Received: by 2002:ac2:515b:: with SMTP id q27mr145lfd.119.1580150805112;
 Mon, 27 Jan 2020 10:46:45 -0800 (PST)
MIME-Version: 1.0
References: <20200127175145.1154438-1-kafai@fb.com> <CAEf4BzYONH0jpi+VV8Q72q2Uico2_MnydX0ptpcOJQLW8H+gng@mail.gmail.com>
In-Reply-To: <CAEf4BzYONH0jpi+VV8Q72q2Uico2_MnydX0ptpcOJQLW8H+gng@mail.gmail.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Mon, 27 Jan 2020 10:46:33 -0800
Message-ID: <CAADnVQKx46Ors4=ywPs-+Oq1-8yRid81_mWqHyGYAD2kvZ0eLQ@mail.gmail.com>
Subject: Re: [PATCH bpf] bpf: Reuse log from btf_prase_vmlinux() in btf_struct_ops_init()
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Martin KaFai Lau <kafai@fb.com>, bpf <bpf@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        David Miller <davem@davemloft.net>,
        Kernel Team <kernel-team@fb.com>,
        Networking <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 27, 2020 at 10:34 AM Andrii Nakryiko
<andrii.nakryiko@gmail.com> wrote:
>
> On Mon, Jan 27, 2020 at 9:52 AM Martin KaFai Lau <kafai@fb.com> wrote:
> >
> > Instead of using a locally defined "struct bpf_verifier_log log = {}",
> > btf_struct_ops_init() should reuse the "log" from its calling
> > function "btf_parse_vmlinux()".  It should also resolve the
> > frame-size too large compiler warning in some ARCH.
> >
> > Fixes: 27ae7997a661 ("bpf: Introduce BPF_PROG_TYPE_STRUCT_OPS")
> > Signed-off-by: Martin KaFai Lau <kafai@fb.com>
> > ---
>
> LGTM, but there is typo in subject (btf_prase_vmlinux).
>
> Acked-by: Andrii Nakryiko <andriin@fb.com>

Tested. All works.

Dave,
if you haven't sent PR yet may be you can apply this patch
directly to silence the warning?
Not a big deal if not. I don't see this warn with default config.

Acked-by: Alexei Starovoitov <ast@kernel.org>
