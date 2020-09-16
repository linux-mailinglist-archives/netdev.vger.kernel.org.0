Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C7A5E26B972
	for <lists+netdev@lfdr.de>; Wed, 16 Sep 2020 03:39:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726217AbgIPBji (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Sep 2020 21:39:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726159AbgIPBjh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Sep 2020 21:39:37 -0400
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F03EC06174A;
        Tue, 15 Sep 2020 18:39:37 -0700 (PDT)
Received: by mail-pg1-x543.google.com with SMTP id 34so2939162pgo.13;
        Tue, 15 Sep 2020 18:39:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=nsZSxf6bknKWz5B/SxUyJuYB2K7c48cbSeGDJpaBcyQ=;
        b=nc9tQcNpyGObSutyaAvEQ9nCYSIK7diObRzAYUTjmPoeR0o76sw1fJSNbzkIr0lKaH
         7vqN5sjAmdApZPt/pdbyd6i8W+sfp9VYQc1T+AO43T6JFWjBfLaEUKBuoK85aH2UQ0Wp
         Uztrq6gOxD7JvKIOBeTg9V0AiIa94CRHJrWoZMvb0oUuwDfjWkr8nUAcMCEbtSa+n6QD
         4teEhDv0OiVTVNDkmdT8mq0ltgZYUSLQ/OTbJRAn9PxqOfGQEk4yDStEerXWo4iJl49Y
         oNgTN3ZuGwn6XBX+ANo7Uj19/0ze7tQygbP+FW7OXAGpCJNIG/NP9rkUQqbje9cTr8c8
         BW4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=nsZSxf6bknKWz5B/SxUyJuYB2K7c48cbSeGDJpaBcyQ=;
        b=rj/RO34TqzisfL1Iqcaay0MUlDG+OzH+gXQd+sRgp7U/moeYjjCsCx9E4/84doNXvg
         hrysoDsxcDZvYT3AXeTRYu1ZMVa6Evp+Q11Mq7SNIlG11ObpU046NmWV3ZJzMrX27V1Y
         zr+35kOkhEHXrmyHNXBNub2Y4QMTCqFyRVB0jvxKa0GvliT1Uzm1x9Npyc2rcQiNtIcf
         TrcMgJvKxxuNS6Ra9Am7+9q7I/3llpspXOmmk3bI/lNttKHFjwO/8TTtrwolAYHtSvHw
         FJv/dbdugqGwKnEHb2S6fGbN/B3UD9pUniBGXvXXbZsvI/79x7pWIOOreQJLhTXCPH0e
         vjEw==
X-Gm-Message-State: AOAM530zkaP0sCIYGjHDWZMahHEAwec+rA9dpL8hy3ozmreSZnioiJp4
        8ROajA2FpiCsb3p9S80VpDE=
X-Google-Smtp-Source: ABdhPJz9OCpkwSyNYezPNsFf8tqmVrnNTK/uA5ittzU7PKyvsCyltrEbkjhKoUSQfb9pQOVZ4bQcCw==
X-Received: by 2002:a63:4b47:: with SMTP id k7mr2826025pgl.315.1600220376462;
        Tue, 15 Sep 2020 18:39:36 -0700 (PDT)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:400::5:8a26])
        by smtp.gmail.com with ESMTPSA id g9sm15546310pfo.144.2020.09.15.18.39.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Sep 2020 18:39:35 -0700 (PDT)
Date:   Tue, 15 Sep 2020 18:39:33 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Andrii Nakryiko <andriin@fb.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org, ast@fb.com,
        daniel@iogearbox.net, andrii.nakryiko@gmail.com, kernel-team@fb.com
Subject: Re: [PATCH v3 bpf-next] selftests/bpf: merge most of test_btf into
 test_progs
Message-ID: <20200916013933.lflk4peklgl2hi7q@ast-mbp.dhcp.thefacebook.com>
References: <20200916004819.3767489-1-andriin@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200916004819.3767489-1-andriin@fb.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 15, 2020 at 05:48:19PM -0700, Andrii Nakryiko wrote:
> Merge 183 tests from test_btf into test_progs framework to be exercised
> regularly. All the test_btf tests that were moved are modeled as proper
> sub-tests in test_progs framework for ease of debugging and reporting.
> 
> No functional or behavioral changes were intended, I tried to preserve
> original behavior as much as possible. E.g., `test_progs -v` will activate
> "always_log" flag to emit BTF validation log.
> 
> The only difference is in reducing the max_entries limit for pretty-printing
> tests from (128 * 1024) to just 128 to reduce tests running time without
> reducing the coverage.
> 
> Example test run:
> 
>   $ sudo ./test_progs -n 8
>   ...
>   #8 btf:OK
>   Summary: 1/183 PASSED, 0 SKIPPED, 0 FAILED
> 
> Signed-off-by: Andrii Nakryiko <andriin@fb.com>

Applied. Thanks.

Now we have that rcu warn in bpf-next tree. I'll send bpf PR shortly to
converge the trees.
