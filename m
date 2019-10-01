Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 03FE6C435A
	for <lists+netdev@lfdr.de>; Wed,  2 Oct 2019 00:00:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728644AbfJAWAc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Oct 2019 18:00:32 -0400
Received: from mail-io1-f66.google.com ([209.85.166.66]:35744 "EHLO
        mail-io1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727473AbfJAWAb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Oct 2019 18:00:31 -0400
Received: by mail-io1-f66.google.com with SMTP id q10so52200951iop.2;
        Tue, 01 Oct 2019 15:00:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=Ofb6T6xdILQ89Quyul9GGKyHwjSaqm5qwwuzogf11LQ=;
        b=p/ZRYnkSTcEdKV9aBcYChw1Q5JZe+1lC26/XnmbGG/YQK0HHKcMWl0DdRnoEp+wmb6
         rGK1jHnBcTUFOlEYMIEZrW5oQchf7H5pgBBoErFib9lGgk8DYuX5Llp9ozkO8PbXkXw3
         VJFijFDbJGZs0sHHz56AXhtm7vkpEDFnJhbuUzeHokhsDjKdxLd5MgexzQi44n2cC4+b
         YQ6r2QJqSORrd25MovitIgqs9ogkCtrI1yo7Wirn5qBFSFuRsQik8ptdY30P7/hIi1Bj
         jkVwComagozLVJyIVkhFQogwDX3q6smYiWquOfU2TiBGuN4AznAJTFbMDUZmSTrPoxJa
         AQtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=Ofb6T6xdILQ89Quyul9GGKyHwjSaqm5qwwuzogf11LQ=;
        b=e8qPz2WwR/v7kEIUO7OkWCoTF452D6RljxG6xNTU4kGrGL4b6HdmObcAD3JsgrWApy
         7CHwnn/iMu3+9WLNre2diKn1QRszuvRjcFh/N99e+8UJpaiY/ykrELdQnMqrMK3v65FM
         thD2SJuR7M0conK843FnLnn3BYH6p+bdrIpducK/NY8Dg+i8k2umQN7zgq/v1b/AiMNq
         PUlyxu87gfyI8T85VMKzyaWU/UBIiORu9kdZ/SV1e+1/EBUB7Yce+3zpdLbp5rdyPmp5
         zLzI7wlKZE7ZLLEBr8ToyGtRC/NPpy1xaxmVkZP9Bc3T3wppEs6ek0n5HUR3AwcLgr91
         IodA==
X-Gm-Message-State: APjAAAXuxSSplHnpDgt5wuu9GZ5tFssWfSgUo/o5uV4Tx3X22qHS5Urv
        6T6CNJef++m4IMDp6tAyKtU=
X-Google-Smtp-Source: APXvYqxRNEpfn7i1UzwaZ9p+rlSwTmjKQy4bdLkvztqK1RY/tAH8nID9D/fpxBiRzGdBR+N9+qNdjA==
X-Received: by 2002:a6b:e512:: with SMTP id y18mr442604ioc.4.1569967230010;
        Tue, 01 Oct 2019 15:00:30 -0700 (PDT)
Received: from localhost ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id n17sm6558538iog.11.2019.10.01.15.00.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Oct 2019 15:00:29 -0700 (PDT)
Date:   Tue, 01 Oct 2019 15:00:21 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        John Fastabend <john.fastabend@gmail.com>
Cc:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
Message-ID: <5d93cc75429b4_67df2ac29a6045b472@john-XPS-13-9370.notmuch>
In-Reply-To: <CAEf4Bzb8Q5nUppqBqnXH93U1con3895BJFHP88hQi5r6wohR6Q@mail.gmail.com>
References: <20190930185855.4115372-1-andriin@fb.com>
 <20190930185855.4115372-3-andriin@fb.com>
 <87d0fhvt4e.fsf@toke.dk>
 <5d93a6713cf1d_85b2b0fc76de5b424@john-XPS-13-9370.notmuch>
 <CAEf4Bzb8Q5nUppqBqnXH93U1con3895BJFHP88hQi5r6wohR6Q@mail.gmail.com>
Subject: Re: [PATCH bpf-next 2/6] libbpf: move bpf_helpers.h, bpf_endian.h
 into libbpf
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Andrii Nakryiko wrote:
> On Tue, Oct 1, 2019 at 12:18 PM John Fastabend <john.fastabend@gmail.co=
m> wrote:
> >
> > Toke H=C3=B8iland-J=C3=B8rgensen wrote:
> > >
> > > > +struct bpf_map_def {
> > > > +   unsigned int type;
> > > > +   unsigned int key_size;
> > > > +   unsigned int value_size;
> > > > +   unsigned int max_entries;
> > > > +   unsigned int map_flags;
> > > > +   unsigned int inner_map_idx;
> > > > +   unsigned int numa_node;
> > > > +};
> > >
> > > Didn't we agree on no new bpf_map_def ABI in libbpf, and that all
> > > additions should be BTF-based?
> > >
> > > -Toke
> > >
> >
> > We use libbpf on pre BTF kernels so in this case I think it makes
> > sense to add these fields. Having inner_map_idx there should allow
> > us to remove some other things we have sitting around.
> =

> We had a discussion about supporting non-BTF and non-standard BPF map
> definition before and it's still on my TODO list to go and do a proof
> of concept how that can look like and what libbpf changes we need to
> make. Right now libbpf doesn't support those new fields anyway, so we
> shouldn't add them to public API.

I'm carrying around a patch for perf_event_open_probe() to get it working=

without BTF I'll send that out today/tomorrow. It seems enough to get
all the basic prog load, maps reused/pinned, etc at least for my use
case.

> =

> >
> > .John


