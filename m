Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BC487DF4F9
	for <lists+netdev@lfdr.de>; Mon, 21 Oct 2019 20:20:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729979AbfJUSUQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Oct 2019 14:20:16 -0400
Received: from mail-qk1-f195.google.com ([209.85.222.195]:36018 "EHLO
        mail-qk1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726672AbfJUSUP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Oct 2019 14:20:15 -0400
Received: by mail-qk1-f195.google.com with SMTP id y189so13593863qkc.3;
        Mon, 21 Oct 2019 11:20:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=EqPGNnMebZz4c/xVZrozzj12KPSZJh44zwjeVidbrD8=;
        b=WJqUYFMQY9dYgqIvx8hj0iArBpnWpnGlSsZfVOT7qQR+OJ7WxMFkW/WLt1U3WN/JeQ
         UGhYe1iQsSLHD6py0aKFusQ0reHvIfqysVmULZvaSZxwKBwa3+pk8wCbDxZVMQQjPck6
         d1XuwpL3pU5ny0v0SzmKQHwsaBv3ZBizRcxb1x9SS3KVEjwxP0ZaMAGOI0EzafmVSZsz
         K0juGO65TGeBPs3Dr6U31nI2lrVJcDeUZW5jpXvrE9J7yRiwed7saeEhh6COItutR2vm
         dAmsajboI2P+1vkBjMmP481ts0hyh9fmBfWWW16PLj9B1lQGxRk5AvXD2N6uc+4mhDwc
         cCnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=EqPGNnMebZz4c/xVZrozzj12KPSZJh44zwjeVidbrD8=;
        b=biWelejj0sYR3Ma8IDqKr9/uEfFmhUAOpzeM3QwMk/dMn6pmQNcfcIuO7mDuqDoWW+
         FSfUq9EqVP5OD5OpnzgrRmEDLKxt7DsEE4kDLrbe2MYeoCz7rBdELNDOl0B7gwESMz4J
         leLAWgQosxwFmFN+xanE8SnHUk9lKbKX8ewlMgrtKmDBUOvUM7CpiqW2tKNNzhmO1oka
         oqX5TDPOlAcDLuidBq9WRovOBRKysYmpF12iKMB5NKTbdItLVvXCJEooc/a4czEp8m7H
         5wgXELoZpwAaHLYB9Rd6GwqUoy699kifSGPwJnUHWWHpAFpoNMr5Lu3kvqV7xGwVDBQZ
         ANvQ==
X-Gm-Message-State: APjAAAXaaV2e3weYZ3rQeuzhKBRGCFAmR2Ghfsk1E0+sZGeoF776D7jN
        hM5RSBBIRGTgNn+TK+FvQvH5MUw5jbLkm0ak2IeuPzBr
X-Google-Smtp-Source: APXvYqxYSShwEgtqvT4qtfO+uTUk1FuxmBbbqCf22Ct4weLEJEe8FbOAGDo34S/zVwEFx8tn1DUAdQaVxEZ4AmzqCi0=
X-Received: by 2002:a37:b447:: with SMTP id d68mr24091046qkf.437.1571682013124;
 Mon, 21 Oct 2019 11:20:13 -0700 (PDT)
MIME-Version: 1.0
References: <20191017150032.14359-1-cneirabustos@gmail.com>
 <20191017150032.14359-5-cneirabustos@gmail.com> <d88ce3ca-d235-cd9c-c1a9-c2d01a01541d@fb.com>
In-Reply-To: <d88ce3ca-d235-cd9c-c1a9-c2d01a01541d@fb.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 21 Oct 2019 11:20:01 -0700
Message-ID: <CAEf4BzbsDbxjALMJ119B-nweD1xEZ_PHX9r9k8qDpekraaHR2w@mail.gmail.com>
Subject: Re: [PATCH v14 4/5] tools/testing/selftests/bpf: Add self-tests for
 new helper.
To:     Yonghong Song <yhs@fb.com>
Cc:     Carlos Neira <cneirabustos@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "ebiederm@xmission.com" <ebiederm@xmission.com>,
        "brouer@redhat.com" <brouer@redhat.com>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Oct 19, 2019 at 1:58 AM Yonghong Song <yhs@fb.com> wrote:
>
>
>
> On 10/17/19 8:00 AM, Carlos Neira wrote:
> > Self tests added for new helper
> >
> > Signed-off-by: Carlos Neira <cneirabustos@gmail.com>
> > ---
> >   .../bpf/prog_tests/get_ns_current_pid_tgid.c  | 96 +++++++++++++++++++
> >   .../bpf/progs/get_ns_current_pid_tgid_kern.c  | 53 ++++++++++

It looks like typical naming convention is:

prog_test/<something>.c
progs/test_<something>.c

Let's keep this consistent. I'm about to do a bit smarter Makefile
that will capture this convention, so it's good to have less exception
to create. Thanks!

Otherwise, besides what Yonghong mentioned, this look good to me.


> >   2 files changed, 149 insertions(+)
> >   create mode 100644 tools/testing/selftests/bpf/prog_tests/get_ns_current_pid_tgid.c
> >   create mode 100644 tools/testing/selftests/bpf/progs/get_ns_current_pid_tgid_kern.c
> >

[...]

> > +     prog = bpf_object__find_program_by_title(obj, probe_name);
> > +     if (CHECK(!prog, "find_probe",
> > +               "prog '%s' not found\n", probe_name))
> > +             goto cleanup;
> > +
> > +     bpf_program__set_type(prog, BPF_PROG_TYPE_RAW_TRACEPOINT);
>
> Do we need this? I thought libbpf should automatically
> infer program type from section name?

We used to, until the patch set that Daniel landed today. Now it can be dropped.

>
> > +
> > +     load_attr.obj = obj;
> > +     load_attr.log_level = 0;
> > +     load_attr.target_btf_path = NULL;
> > +     err = bpf_object__load_xattr(&load_attr);
> > +     if (CHECK(err, "obj_load",
> > +               "failed to load prog '%s': %d\n",
> > +               probe_name, err))
> > +             goto cleanup;
>

[...]
