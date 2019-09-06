Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C14F9AC2B5
	for <lists+netdev@lfdr.de>; Sat,  7 Sep 2019 00:51:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392504AbfIFWvJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Sep 2019 18:51:09 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:44285 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730864AbfIFWvJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Sep 2019 18:51:09 -0400
Received: by mail-pf1-f196.google.com with SMTP id q21so5503863pfn.11
        for <netdev@vger.kernel.org>; Fri, 06 Sep 2019 15:51:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fomichev-me.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=AtIdKbzr0YQu5CrLf8FM0b4YurkzEg55iDmeFG+2tak=;
        b=0binOhGOwoRQMCYy+r2lVl/4uQDNcTSM0u79BGgMIGIa+0kKidpTExCV+giX0jQZUl
         BoBYLJ0DgFNaJ7wmCYr/bqM6AuGbZgGwAunhxmFikADYEgL7HqEKRnAMpSZ8mXdLo79y
         VXEqoyf75ZD/G5DuxOR6cY80P3asVghVAkGyz54Tq1XV8uwsX4vF34eQ6s0zo1DLpfA9
         05lzYrxU2IKVuPj4jw8l3ku0Xmhs9FitNP7wKl7tTy6m5HaInCdmTdp0lG2flHmKAluC
         ZO5KDuDExY020EYqj+cOy8ypSzkLOb74Yrk5dueDg/VQw3SP2afO6vn7Liit0FApJITC
         f0AA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=AtIdKbzr0YQu5CrLf8FM0b4YurkzEg55iDmeFG+2tak=;
        b=KNR4gMotc80e3KSeize0+c7qO3TYofhpp1FY7sFR56KO4OKd0Wquwout6JXHFlRkns
         8q+EsDAsHkBJzCyvWwhwRqj38Fks2vY76Ex2/qaMO07cSgGLixcruglcN1FI9F4xbVt8
         FZ02I4/aOtQHne77LT/uSDMTW5kH+PfEwgqRZxO6QjYMnLq9Qv0ZcHcssMmxgc2LLf2M
         pWotJinrk9/KvDILctmGeEyCZOHVtC4jxtLxcuHX105xrUmiXpIDsmZxFULQttuwdTjA
         fUMBA5SZjkyuGhYYT+cB9Mgy2NmV1nxl+Q3SjhIjSHyBlgq07wIUh3hmCNOHRlySygHz
         G8Lg==
X-Gm-Message-State: APjAAAW/zvO8rTxMle+hSH3vwzVhCaHDVH6kfKzBWz8bIYP2dtfPn3Mo
        0FM0CGYEHWtrGXBdoRitwLH7AuSHU6s=
X-Google-Smtp-Source: APXvYqx8/OMFoqIecuvzfnIGVUYs+7jGK8L0qYnJ9e8kVhAN02awQXLnhghlfQ2SvpTV1wH7I1chYg==
X-Received: by 2002:a62:2d3:: with SMTP id 202mr14023832pfc.141.1567810268481;
        Fri, 06 Sep 2019 15:51:08 -0700 (PDT)
Received: from localhost ([2601:646:8f00:18d9:d0fa:7a4b:764f:de48])
        by smtp.gmail.com with ESMTPSA id s5sm6555589pfe.52.2019.09.06.15.51.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Sep 2019 15:51:08 -0700 (PDT)
Date:   Fri, 6 Sep 2019 15:51:07 -0700
From:   Stanislav Fomichev <sdf@fomichev.me>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Stanislav Fomichev <sdf@google.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Subject: Re: [PATCH bpf-next v2 1/6] selftests/bpf: test_progs: add
 test__join_cgroup helper
Message-ID: <20190906225107.GA10158@mini-arch>
References: <20190905152709.111193-1-sdf@google.com>
 <20190905152709.111193-2-sdf@google.com>
 <CAEf4Bzb=0gJv148r+RARMOYHikvvrzXJ-o5jQ7F_WtSzhRF38w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEf4Bzb=0gJv148r+RARMOYHikvvrzXJ-o5jQ7F_WtSzhRF38w@mail.gmail.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 09/06, Andrii Nakryiko wrote:
> On Thu, Sep 5, 2019 at 7:40 PM Stanislav Fomichev <sdf@google.com> wrote:
> >
> > test__join_cgroup() combines the following operations that usually
> > go hand in hand and returns cgroup fd:
> >
> >   * setup cgroup environment (make sure cgroupfs is mounted)
> >   * mkdir cgroup
> >   * join cgroup
> >
> > It also marks a test as a "cgroup cleanup needed" and removes cgroup
> > state after the test is done.
> >
> > Signed-off-by: Stanislav Fomichev <sdf@google.com>
> > ---
> 
> First of all, thanks a lot for all these improvements to test_progs
> and converting existing tests to test_progs tests, it's great to see
> this consolidation!
> 
> [...]
> 
> > @@ -17,6 +18,7 @@ struct prog_test_def {
> >         int error_cnt;
> >         int skip_cnt;
> >         bool tested;
> > +       bool need_cgroup_cleanup;
> >
> >         const char *subtest_name;
> >         int subtest_num;
> > @@ -122,6 +124,39 @@ void test__fail(void)
> >         env.test->error_cnt++;
> >  }
> >
> > +int test__join_cgroup(const char *path)
> 
> This doesn't seem to be testing-specific functionality, tbh. It's
> certainly useful helper, but I don't think it warrants test__ prefix.
I didn't like the mess we used to have:

	if (setup_cgroup_environment())
		goto cleanup_obj;

	cgroup_fd = create_and_get_cgroup(CG_PATH);
	if (cgroup_fd < 0)
		goto cleanup_cgroup_env;

	if (join_cgroup(CG_PATH))
		goto cleanup_cgroup;

	... do the test

	cleanup_cgroup_environment();

All I really want to do in several tests is to create a temporary cgroup
and join it (I don't even really care about the name most of the time).
We can rename and move this test__join_cgroup into cgroup_helpers.h if
you prefer, I don't really mind. I just want to avoid repeating those
10 lines over and over in each test that just wants to run in a cgroup.

> As for test->need_cgroup_cleanup field, this approach won't scale if
> we need other types of custom/optional clean up after test ends.
> Generic test framework code will need to know about every possible
> custom setup to be able to cleanup/undo it.
> 
> I wonder if generalizing it to be able to add custom clean up code
> (some test frameworks have "teardown" overrides for this) would be
> cleaner and more maintainable solution.
> 
> Something like:
> 
> typedef void (* test_teardown_fn)(struct test *test, void *ctx);
> 
> /* somewhere at the beginning of test: */
> test__schedule_teardown(test_teardown_fn cb, void *ctx);
> 
> [...]
> 
> > +
> > +               if (test->need_cgroup_cleanup)
> > +                       cleanup_cgroup_environment();
> 
> Then in generic framework we'll just process a list of callbacks and
> call each one with stored ctx per each callback (in case we need some
> custom data to be stored, of course).
> 
> Thoughts?
Idk, I don't see the need to be too generic since we control both the
tests and the framework. So putting something like test__join_cgroup
and doing automatic cleanup looks fine to me if this is shared between
several tests. If, at some point, it becomes unmanageable, we can
think about refactoring; but until then, I'd not bother tbh.
