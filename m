Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7E9B2E09AB
	for <lists+netdev@lfdr.de>; Tue, 22 Oct 2019 18:50:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732826AbfJVQun (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Oct 2019 12:50:43 -0400
Received: from mail-qt1-f194.google.com ([209.85.160.194]:42913 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727960AbfJVQum (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Oct 2019 12:50:42 -0400
Received: by mail-qt1-f194.google.com with SMTP id w14so27733030qto.9;
        Tue, 22 Oct 2019 09:50:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=3jAJkxjVFVzUVJrkjHv+AxjkWN+Ybu1L+yMTqKZAMBc=;
        b=EaCCNq1n/yFnGw5oVlPlNCPXSUBcFKk9LFZpwAJMAKSBl+3OpoifuytxT7wD4jfcXa
         iIRl447oPtvARYR16XlMs9n8dyqlvOSYUd6l+w7t7hzXrdRltFTbVHl2kFW/pHsiNowA
         +YQ5di1EHZfU9ucxK6VfO2xeNcxV9otqsm8Un1BhD+Q0PMScQ8/qLvV5VnPRPpP4bSkE
         nGAySvIUBD/8ncvXTLe1U4hbIfvsI7D7/V3uqESDtFweTV+0lw0ZqXNjFzsOu8h1g++K
         C6Q7Z05Ivg12YuAWuIuDlj/w8drR1c5CZ2cDYbfLAoHN2gIIGIrgapCnABJy22NHrfIp
         0TUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=3jAJkxjVFVzUVJrkjHv+AxjkWN+Ybu1L+yMTqKZAMBc=;
        b=MU1gTC2wla7/ItIp/VGlm6Yz1PlzfmDtAsu1LSpxWM+CEA5VFHKrY/JBQubk/sg4Uc
         +d4/tIVdms851u22+oDs3bCRlxHtEUObNN8AYuI3EdReXmfbq/2vU9jIF7D42+eu+TpI
         5K6RG8sX6WnLIA/1Yb+S7RHm7Md+F0EqMmH21SCisDNgOILhS1JYtFWEB2hanC1maiBq
         tB6lk7fQFl7ecBwiJa1jvJX5XVEmlWFY0/ayxTy5jvpTp84SvPjwtaRn89HsP9E1VjYp
         mXQhShdDlBYDN6vl0/JvXraR4aGx4E0nvbl9kcnrqaHPSOfVfcraid/DaKR6sF8clvTb
         YHhA==
X-Gm-Message-State: APjAAAV5yw9YTxqJVrk15VvX2luuPnjccZYNnEVYxrVJueT5brFrbeyz
        VgJfT8glFZL1z2b5o9KLvMY=
X-Google-Smtp-Source: APXvYqyjk6QHYezg+upsGzQ268EzLOtaM+TE5FbsU173q1gGX8Msp7t3ciukWbMIKqLk+bKc0gis/A==
X-Received: by 2002:ac8:3652:: with SMTP id n18mr4545182qtb.232.1571763041518;
        Tue, 22 Oct 2019 09:50:41 -0700 (PDT)
Received: from frodo.byteswizards.com ([190.162.109.190])
        by smtp.gmail.com with ESMTPSA id 44sm14922244qtt.13.2019.10.22.09.50.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Oct 2019 09:50:40 -0700 (PDT)
Date:   Tue, 22 Oct 2019 13:50:36 -0300
From:   Carlos Antonio Neira Bustos <cneirabustos@gmail.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Yonghong Song <yhs@fb.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "ebiederm@xmission.com" <ebiederm@xmission.com>,
        "brouer@redhat.com" <brouer@redhat.com>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>
Subject: Re: [PATCH v14 4/5] tools/testing/selftests/bpf: Add self-tests for
 new helper.
Message-ID: <20191022165036.GA22524@frodo.byteswizards.com>
References: <20191017150032.14359-1-cneirabustos@gmail.com>
 <20191017150032.14359-5-cneirabustos@gmail.com>
 <d88ce3ca-d235-cd9c-c1a9-c2d01a01541d@fb.com>
 <CAEf4BzbsDbxjALMJ119B-nweD1xEZ_PHX9r9k8qDpekraaHR2w@mail.gmail.com>
 <20191021191449.GA16484@ebpf00.byteswizards.com>
 <CAEf4BzY5ZMQJYwU5p-r4bnOcZLGsR1_1iY3-0KKnZyttRbyr6g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEf4BzY5ZMQJYwU5p-r4bnOcZLGsR1_1iY3-0KKnZyttRbyr6g@mail.gmail.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 21, 2019 at 12:18:33PM -0700, Andrii Nakryiko wrote:
> On Mon, Oct 21, 2019 at 12:14 PM Carlos Antonio Neira Bustos
> <cneirabustos@gmail.com> wrote:
> >
> > On Mon, Oct 21, 2019 at 11:20:01AM -0700, Andrii Nakryiko wrote:
> > > On Sat, Oct 19, 2019 at 1:58 AM Yonghong Song <yhs@fb.com> wrote:
> > > >
> > > >
> > > >
> > > > On 10/17/19 8:00 AM, Carlos Neira wrote:
> > > > > Self tests added for new helper
> > > > >
> > > > > Signed-off-by: Carlos Neira <cneirabustos@gmail.com>
> > > > > ---
> > > > >   .../bpf/prog_tests/get_ns_current_pid_tgid.c  | 96 +++++++++++++++++++
> > > > >   .../bpf/progs/get_ns_current_pid_tgid_kern.c  | 53 ++++++++++
> > >
> > > It looks like typical naming convention is:
> > >
> > > prog_test/<something>.c
> > > progs/test_<something>.c
> > >
> > > Let's keep this consistent. I'm about to do a bit smarter Makefile
> > > that will capture this convention, so it's good to have less exception
> > > to create. Thanks!
> > >
> > > Otherwise, besides what Yonghong mentioned, this look good to me.
> > >
> > >
> > > > >   2 files changed, 149 insertions(+)
> > > > >   create mode 100644 tools/testing/selftests/bpf/prog_tests/get_ns_current_pid_tgid.c
> > > > >   create mode 100644 tools/testing/selftests/bpf/progs/get_ns_current_pid_tgid_kern.c
> > > > >
> > >
> > > [...]
> > >
> > > > > +     prog = bpf_object__find_program_by_title(obj, probe_name);
> > > > > +     if (CHECK(!prog, "find_probe",
> > > > > +               "prog '%s' not found\n", probe_name))
> > > > > +             goto cleanup;
> > > > > +
> > > > > +     bpf_program__set_type(prog, BPF_PROG_TYPE_RAW_TRACEPOINT);
> > > >
> > > > Do we need this? I thought libbpf should automatically
> > > > infer program type from section name?
> > >
> > > We used to, until the patch set that Daniel landed today. Now it can be dropped.
> > >
> > > >
> > > > > +
> > > > > +     load_attr.obj = obj;
> > > > > +     load_attr.log_level = 0;
> > > > > +     load_attr.target_btf_path = NULL;
> > > > > +     err = bpf_object__load_xattr(&load_attr);
> > > > > +     if (CHECK(err, "obj_load",
> > > > > +               "failed to load prog '%s': %d\n",
> > > > > +               probe_name, err))
> > > > > +             goto cleanup;
> > > >
> > >
> > > [...]
> >
> > Thanks Andrii,
> > I have a doubt, I don't find in prog_tests/rdonly_map.c  where is "test_rdo.bss" defined ?, is called in line 43 but I'm missing how to is it used as I don't see it defined.
> >
> 
> This map is created by libbpf implicitly from global variables used by
> BPF object. You just look it up by name, set its value to whatever you
> need global variables to be set up to, and that value will be
> available to BPF program. From BPF program side, when you update
> global variable, that value can be read from user space using that
> same test_rdo.bss map. Does it make sense?
> 
> > Bests

Thanks for the explanation Andrii, now it works!.
