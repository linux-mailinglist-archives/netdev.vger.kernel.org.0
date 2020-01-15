Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0B39113D069
	for <lists+netdev@lfdr.de>; Thu, 16 Jan 2020 00:00:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730984AbgAOXAM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jan 2020 18:00:12 -0500
Received: from mail-qt1-f194.google.com ([209.85.160.194]:40721 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729714AbgAOXAL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jan 2020 18:00:11 -0500
Received: by mail-qt1-f194.google.com with SMTP id v25so17310891qto.7;
        Wed, 15 Jan 2020 15:00:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=UyMfns3owD4Yeq25dM9c4Ys31RS5WNJacv3rjtg79Cc=;
        b=ifBrP5eXzX7HYPtlNNgMwKsi9sTasWIVYAVWnmI+OwhP/s082qGRpBvVkk52HWQsjo
         d+C6IclsaFmqQZXM1DnD66L1/TzKPrGD/E8XtJ7ao/I7NfuQp8nkmUrvb1Znio5CNaV3
         OAfZ1Il/OJW7e8bTuMlXIBmJ0O24H5eG0/cqSpSKPk7Wo+AsMPsYb4ubFSZXDrBzOE6h
         K3FO+oRtTusdS5X2y8WhI8UufaGQ+wd3AElN6BHsJtyHpdbRPSMvEN+KIda18iRMj++n
         tVOGsSOm03kwq8MbFhTqZQK50iNHWHFO5dpx65XI0jgGfWEzQkhtueFEjZSfYl3nWI6Q
         WyGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=UyMfns3owD4Yeq25dM9c4Ys31RS5WNJacv3rjtg79Cc=;
        b=YO3e8tlAADF6ktc7Zk6uZtS+2gTCkcTJ1236E7wc15ig2KxZaQ/eJD2TXYDTUPHoqJ
         27q7pKnb+D2vFTGIjyHSbM9V3qHGqSRDF7+VLF13nno/bGyadqeISbLrIH4Ujf9oXuyX
         rWFwjFKDIj/ICK7FgqA9z3nyt9lq+uIlSYYBK/2J1uXxN7hVqNUtPT0csSFL0Kg5bChg
         2yqaf2CQusFXSYjWD7zB3sCTouD3pVsZoyl/O6XqA5OtWo3/CesQbHmWB3Fl/r3tSO0F
         zWksEZQqK2o/o+JHY6qnIZY+ZG8zDWQAopcXwNWSGe48cVFgbj9/R/6CXlbDH6T1/osQ
         KILQ==
X-Gm-Message-State: APjAAAWQ8wTQf26v3kMA4eWRQ7kH6FkWPN83jv5WkTPowsULdAytAgNL
        Peun4uLRUuSCos3eleaNeOapM3iIBkKCYryZYwM=
X-Google-Smtp-Source: APXvYqxTIeGl3PGR7t3ZewlG16y2o9r3DR4w8VMav8fDwFV27rFYiFRZyx+gVzzWv0V91FatGJvTR3+rMnTdMZvMAuI=
X-Received: by 2002:ac8:140c:: with SMTP id k12mr955610qtj.117.1579129210598;
 Wed, 15 Jan 2020 15:00:10 -0800 (PST)
MIME-Version: 1.0
References: <20200115222241.945672-1-kafai@fb.com> <20200115222312.948025-1-kafai@fb.com>
 <CAEf4BzbBTqp7jDsTFdT60DSFSw7hX2wr3PB4a8p2pOaqs18tVA@mail.gmail.com> <20200115224955.45evt277ino4j5zi@kafai-mbp.dhcp.thefacebook.com>
In-Reply-To: <20200115224955.45evt277ino4j5zi@kafai-mbp.dhcp.thefacebook.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 15 Jan 2020 14:59:59 -0800
Message-ID: <CAEf4BzZDnaYswB07s2HSMQ4D96LuqLwVa4rp3gwi8a6chV2Zog@mail.gmail.com>
Subject: Re: [PATCH v2 bpf-next 5/5] bpftool: Support dumping a map with btf_vmlinux_value_type_id
To:     Martin Lau <kafai@fb.com>
Cc:     bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        David Miller <davem@davemloft.net>,
        Kernel Team <Kernel-team@fb.com>,
        Networking <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 15, 2020 at 2:50 PM Martin Lau <kafai@fb.com> wrote:
>
> On Wed, Jan 15, 2020 at 02:46:10PM -0800, Andrii Nakryiko wrote:
> > On Wed, Jan 15, 2020 at 2:28 PM Martin KaFai Lau <kafai@fb.com> wrote:
> > >
> > > This patch makes bpftool support dumping a map's value properly
> > > when the map's value type is a type of the running kernel's btf.
> > > (i.e. map_info.btf_vmlinux_value_type_id is set instead of
> > > map_info.btf_value_type_id).  The first usecase is for the
> > > BPF_MAP_TYPE_STRUCT_OPS.
> > >
> > > Signed-off-by: Martin KaFai Lau <kafai@fb.com>
> > > ---
> >
> > LGTM.
> >
> > Acked-by: Andrii Nakryiko <andriin@fb.com>
> Thanks for the review!
>
> I just noticied I forgot to remove the #include "libbpf_internal.h".
> I will respin one more.

didn't notice that. Please also update a subject on patch exposing
libbpf_find_kernel_btf (it still mentions old name).
