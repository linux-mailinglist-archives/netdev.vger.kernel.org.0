Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B165326B523
	for <lists+netdev@lfdr.de>; Wed, 16 Sep 2020 01:38:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727253AbgIOXiD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Sep 2020 19:38:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727068AbgIOXhy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Sep 2020 19:37:54 -0400
Received: from mail-pl1-x643.google.com (mail-pl1-x643.google.com [IPv6:2607:f8b0:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1EEE2C06174A;
        Tue, 15 Sep 2020 16:37:53 -0700 (PDT)
Received: by mail-pl1-x643.google.com with SMTP id k13so2165836plk.3;
        Tue, 15 Sep 2020 16:37:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=pMXma8x6YoTQVvMJ+K5iGZI7cwT1mYn89SVxWt3eduo=;
        b=WPizD1wxMnvjpnrz8wJg3/dtWH7Js34Z5uRFxul13NlOksTSUm8sPmgXTQrG5IZULE
         pE9FHEJLzowVMXDRBTpZJ3bKyQ8hYYb8V2Ob21RtjgIKXmaTYvPEmYap/pDxmJQFDmHK
         RpAQx+16tUCGGaSEKUgbwaVXqXBcqVwp8ePYetLFb0FlW2UUYoQEo3jepORmz6TO/Vm4
         i3VM0T2OGmO0t2JBs4Vn6ORrY+AemPHpAlkV4CenH0EgVxUuLi8y1w/ew3hdm1+IAjIV
         VcZv1mG+idFjC5pJ5Nla2ts1EBUi8qxztRONaJ+5QG/tyUgNKfuup6Ws2t4ZXJF9GiZm
         /+pw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=pMXma8x6YoTQVvMJ+K5iGZI7cwT1mYn89SVxWt3eduo=;
        b=DfkERMrMKoXdLE0lGvZCyuiUnFD48qd9WQeYZCUZBeSJpzuHHa+3DbN76EHlhN6xz+
         hYYCKxszfP2Rc6/EMK1d3XiAauEBwZH1EwGL329YSQjFwUzGoQ+rPRRMyW6b3pO7fKww
         R8kp+HnBqgWwTEJ3eRSMNn+7vlvlk8g3RFLhs5zy0QO7loNtPPR8fCuDntxjdZzL5qQ1
         oDXATlakR29qMeibuGLAn4MC6Kesg73u8ntMkrXVMjCyNnBDwOIA0q1ka6LubU/3PpIK
         ku7g+BILJtakwZG3gNeSmUeIYhAqE4uhG8YFsyrgpNzmuBZ1fhSFo0r4Ya8Xk0GLTiD0
         gjHg==
X-Gm-Message-State: AOAM531VfFyZTJPfLHI0x9DBqgRepPh2/GxU2IvOMT12zA4Zj2/vTzPz
        FR8fOz9MaIUgc7/kCvgKZVo=
X-Google-Smtp-Source: ABdhPJyMabW1j8fmLPCAQ2itUbWK+eznPeHgkOpFxEHZWNbCNfcVSDhbJRGNHdVd1hzJ7FwP4nhE0A==
X-Received: by 2002:a17:90a:4b42:: with SMTP id o2mr1356472pjl.205.1600213073314;
        Tue, 15 Sep 2020 16:37:53 -0700 (PDT)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:400::5:8a26])
        by smtp.gmail.com with ESMTPSA id d8sm12034698pgt.19.2020.09.15.16.37.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Sep 2020 16:37:52 -0700 (PDT)
Date:   Tue, 15 Sep 2020 16:37:50 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Andrii Nakryiko <andriin@fb.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org, ast@fb.com,
        daniel@iogearbox.net, andrii.nakryiko@gmail.com,
        kernel-team@fb.com, yhs@fb.com, kafai@fb.com
Subject: Re: [PATCH v2 bpf-next] selftests/bpf: merge most of test_btf into
 test_progs
Message-ID: <20200915233750.imml2qj6p72olga4@ast-mbp.dhcp.thefacebook.com>
References: <20200915014341.2949692-1-andriin@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200915014341.2949692-1-andriin@fb.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 14, 2020 at 06:43:41PM -0700, Andrii Nakryiko wrote:
> Move almost 200 tests from test_btf into test_progs framework to be exercised
> regularly. Pretty-printing tests were left alone and renamed into
> test_btf_pprint because they are very slow and were not even executed by
> default with test_btf.

I think would be good to run them by default.
The following trivial tweak makes them fast:
diff --git a/tools/testing/selftests/bpf/test_btf.c b/tools/testing/selftests/bpf/test_btf.c
index c75fc6447186..589afd4f0e47 100644
--- a/tools/testing/selftests/bpf/test_btf.c
+++ b/tools/testing/selftests/bpf/test_btf.c
@@ -4428,7 +4428,7 @@ static struct btf_raw_test pprint_test_template[] = {
        .value_size = sizeof(struct pprint_mapv),
        .key_type_id = 3,       /* unsigned int */
        .value_type_id = 16,    /* struct pprint_mapv */
-       .max_entries = 128 * 1024,
+       .max_entries = 128,
 },

 {
@@ -4493,7 +4493,7 @@ static struct btf_raw_test pprint_test_template[] = {
        .value_size = sizeof(struct pprint_mapv),
        .key_type_id = 3,       /* unsigned int */
        .value_type_id = 16,    /* struct pprint_mapv */
-       .max_entries = 128 * 1024,
+       .max_entries = 128,
 },

 {
@@ -4564,7 +4564,7 @@ static struct btf_raw_test pprint_test_template[] = {
        .value_size = sizeof(struct pprint_mapv),
        .key_type_id = 3,       /* unsigned int */
        .value_type_id = 16,    /* struct pprint_mapv */
-       .max_entries = 128 * 1024,
+       .max_entries = 128,
 },

Martin,
do you remember why you picked such large numbers of entries
for the test?
If I read the code correctly smaller number doesn't reduce the test coverage.

> All the test_btf tests that were moved are modeled as proper sub-tests in
> test_progs framework for ease of debugging and reporting.
> 
> No functional or behavioral changes were intended, I tried to preserve
> original behavior as close to the original as possible. `test_progs -v` will
> activate "always_log" flag to emit BTF validation log.
> 
> Signed-off-by: Andrii Nakryiko <andriin@fb.com>
> ---
> 
> v1->v2:
>  - pretty-print BTF tests were renamed test_btf -> test_btf_pprint, which
>    allowed GIT to detect that majority of  test_btf code was moved into
>    prog_tests/btf.c; so diff is much-much smaller;

Thanks. I hope with addition to pprint test the diff will be even smaller.
I think it's worth to investigate why they're failing if moved to test_progs.
I think they're the only tests that exercise seq_read logic.
Clearly the bug:
[   25.960993] WARNING: CPU: 2 PID: 1995 at kernel/bpf/hashtab.c:717 htab_map_get_next_key+0x7fc/0xab0
is still there.
If pprint tests were part of test_progs we would have caught that earlier.

Yonghong,
please take a look at that issue.
