Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1E3B8DF5D1
	for <lists+netdev@lfdr.de>; Mon, 21 Oct 2019 21:17:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730075AbfJUTO5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Oct 2019 15:14:57 -0400
Received: from mail-qt1-f194.google.com ([209.85.160.194]:47103 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730052AbfJUTO5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Oct 2019 15:14:57 -0400
Received: by mail-qt1-f194.google.com with SMTP id u22so22740461qtq.13;
        Mon, 21 Oct 2019 12:14:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=b4SWj2iunV816xEhviWCgvXKQ4e0TIqrHlFShHDfuNQ=;
        b=bP0ZdbKq/xs8P+NfkmRlLe7FOIZlcc0lNN6rnj7ht+Q4hRRGNUg97Jua7ItgYqLv2M
         b/HWcsgx01feEy5SFadEzItmxkgbTarwHujYfREbtQV6vygj/XmjMJGhlEor1jKvCSyK
         okdSMYAlHGB5gtwgViGVrxk1dfSL8ijIFEJ59cLdEhq0CRa3iY+GKpfs832PT9Ao0l53
         G8IT6ick7KQ+QSdiJtH+1rOZerWUt2J7t6ZuvfNIWjXxca/zOisN+5KqPfVi8NqR1ZXS
         NsyI8fJeUn89m4CvweRnMAvEX9N7FgmX/PhZF02583Mi55N+kcCLeeAHea3oUJaH5gsh
         C24g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=b4SWj2iunV816xEhviWCgvXKQ4e0TIqrHlFShHDfuNQ=;
        b=lhhswE3g3TAQNfJkC+VGgwIjAEZs3oHTS8v/wb0IJ4Cd63FGLp503HfVXtSXEx6b8k
         WKLCDf02yLjwXMOpJzsGMX4S4H8lcA7DEe/QolBrLY9T5gsjViFmgNs9UNPmenV4bY9V
         y8BsMJsb0gHed50W6K/9fbcurikXZ3wOGU/3+HoDS1mJ15/oY3Xs88pUrxMJ4EkX+o5j
         k86npp7s8UEmEYTm2zCjrOz7Q7ohZlU6l5C7X4tLy5JGa8lmTdCSNN5f7U/OXemsj/EQ
         /RKyn1Kdbi2NEmDr5UaH/k2MpLAEmkzsERMNGipf40FXA4NGIQfDSYogOd/TEUacAt0K
         E8CA==
X-Gm-Message-State: APjAAAX6VoythwuRMR0bnLdnB1PuwjJPZeAaugqMvmwKk8IPImpvKAfy
        5JVqsMHY3Xl9hAOjD2PUfh0=
X-Google-Smtp-Source: APXvYqxKDouRJrdf42YpJ4dtXtzrPAqinhXQjZGADTkT2mbC7UmBEb+Mlak9f/zhfzynmULg3T+mqg==
X-Received: by 2002:ac8:72d4:: with SMTP id o20mr26337563qtp.366.1571685296106;
        Mon, 21 Oct 2019 12:14:56 -0700 (PDT)
Received: from ebpf00.byteswizards.com ([190.162.109.190])
        by smtp.gmail.com with ESMTPSA id x125sm10755861qkc.24.2019.10.21.12.14.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Oct 2019 12:14:55 -0700 (PDT)
Date:   Mon, 21 Oct 2019 16:14:51 -0300
From:   Carlos Antonio Neira Bustos <cneirabustos@gmail.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Yonghong Song <yhs@fb.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "ebiederm@xmission.com" <ebiederm@xmission.com>,
        "brouer@redhat.com" <brouer@redhat.com>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>
Subject: Re: [PATCH v14 4/5] tools/testing/selftests/bpf: Add self-tests for
 new helper.
Message-ID: <20191021191449.GA16484@ebpf00.byteswizards.com>
References: <20191017150032.14359-1-cneirabustos@gmail.com>
 <20191017150032.14359-5-cneirabustos@gmail.com>
 <d88ce3ca-d235-cd9c-c1a9-c2d01a01541d@fb.com>
 <CAEf4BzbsDbxjALMJ119B-nweD1xEZ_PHX9r9k8qDpekraaHR2w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEf4BzbsDbxjALMJ119B-nweD1xEZ_PHX9r9k8qDpekraaHR2w@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 21, 2019 at 11:20:01AM -0700, Andrii Nakryiko wrote:
> On Sat, Oct 19, 2019 at 1:58 AM Yonghong Song <yhs@fb.com> wrote:
> >
> >
> >
> > On 10/17/19 8:00 AM, Carlos Neira wrote:
> > > Self tests added for new helper
> > >
> > > Signed-off-by: Carlos Neira <cneirabustos@gmail.com>
> > > ---
> > >   .../bpf/prog_tests/get_ns_current_pid_tgid.c  | 96 +++++++++++++++++++
> > >   .../bpf/progs/get_ns_current_pid_tgid_kern.c  | 53 ++++++++++
> 
> It looks like typical naming convention is:
> 
> prog_test/<something>.c
> progs/test_<something>.c
> 
> Let's keep this consistent. I'm about to do a bit smarter Makefile
> that will capture this convention, so it's good to have less exception
> to create. Thanks!
> 
> Otherwise, besides what Yonghong mentioned, this look good to me.
> 
> 
> > >   2 files changed, 149 insertions(+)
> > >   create mode 100644 tools/testing/selftests/bpf/prog_tests/get_ns_current_pid_tgid.c
> > >   create mode 100644 tools/testing/selftests/bpf/progs/get_ns_current_pid_tgid_kern.c
> > >
> 
> [...]
> 
> > > +     prog = bpf_object__find_program_by_title(obj, probe_name);
> > > +     if (CHECK(!prog, "find_probe",
> > > +               "prog '%s' not found\n", probe_name))
> > > +             goto cleanup;
> > > +
> > > +     bpf_program__set_type(prog, BPF_PROG_TYPE_RAW_TRACEPOINT);
> >
> > Do we need this? I thought libbpf should automatically
> > infer program type from section name?
> 
> We used to, until the patch set that Daniel landed today. Now it can be dropped.
> 
> >
> > > +
> > > +     load_attr.obj = obj;
> > > +     load_attr.log_level = 0;
> > > +     load_attr.target_btf_path = NULL;
> > > +     err = bpf_object__load_xattr(&load_attr);
> > > +     if (CHECK(err, "obj_load",
> > > +               "failed to load prog '%s': %d\n",
> > > +               probe_name, err))
> > > +             goto cleanup;
> >
> 
> [...]

Thanks Andrii,
I have a doubt, I don't find in prog_tests/rdonly_map.c  where is "test_rdo.bss" defined ?, is called in line 43 but I'm missing how to is it used as I don't see it defined.

Bests
