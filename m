Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 675AA142294
	for <lists+netdev@lfdr.de>; Mon, 20 Jan 2020 06:04:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725872AbgATFE4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jan 2020 00:04:56 -0500
Received: from mail-io1-f65.google.com ([209.85.166.65]:35032 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725783AbgATFE4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jan 2020 00:04:56 -0500
Received: by mail-io1-f65.google.com with SMTP id h8so32329734iob.2
        for <netdev@vger.kernel.org>; Sun, 19 Jan 2020 21:04:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=IlXRS2qstI+wHO+Vs4VR8xm8hbOiSW+Xsm6IfWkA0D4=;
        b=mkDUBjqDIUVzCz5uVBwH/3r/BJKyFzq6h8QX7ump3Ru4zpDgYEcGF5QsS7YN6N5OIT
         B1ijKj8R93sN5udP3Ono0IYtQ7armKD2h97yHOYXmuS0RJ2qaaUrzXwvoOvyBzi6RFcB
         5DHFfMkbFP90DXHxtZ0NiN418ypYTmygn0WQSwVYn2YZyrIeyX92dvf0Vv/i8rKwwQ8O
         BCwTmUrdyuKuc8bCiFi9fQbBEa3PYoN7Fry0XQ1hQIOE7aALbqNYHeBNho+V54NZPJin
         ZC+fS04hi+riUqbP/jdT8Y71IV4zgxlwHJogDT3bCvBh8zkPNuB2umJPId7+RJXyJyCX
         Yg1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=IlXRS2qstI+wHO+Vs4VR8xm8hbOiSW+Xsm6IfWkA0D4=;
        b=lr0FeQj6OFDo4St6EYKFdYuU16SGUpVsY99aXw7QoMwBKHSEghFLSZrwl+JeCxWyHW
         Z/U4MewYGGBOl54+wbHgeoskn1ciR00vJxit2Gn/bq7aKjjMlxAPkUfdCQXH6K0Iy6Zq
         qxA3g3emaWdf2OJ/XEX6E7lb35moYGoBQljnnIs0MIqwURCxzL4xPkROzsjStJXl7iZp
         uqve1nKOAS8ZQGNdXAmN1wrLUo3D3/h0Dva7+o2tAkqT6DEuxGvMTlb5r8lTXAU7jIa2
         3/1QAtncBcE7NdfnsREb3ddImlTQZGmz8t7Dyu7Ve0M1tG1HHSNHxGze5ehkamIaq/qT
         dc6g==
X-Gm-Message-State: APjAAAUf/bk+kCFoVMeY+XUl3rHuTnQN5x2Fk6sbw/5McH4Hqnljy7ja
        ymrI2l9uM4824ex2T/LSxzA=
X-Google-Smtp-Source: APXvYqw/bK6UYTPRr6GyPjaL4vPkEswx26WpxZtTJncfnnGTsvI+nTVhcBv06mGqz6ik/7XxaU+m1g==
X-Received: by 2002:a5d:8146:: with SMTP id f6mr16494454ioo.93.1579496695218;
        Sun, 19 Jan 2020 21:04:55 -0800 (PST)
Received: from localhost ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id z20sm8170375iof.48.2020.01.19.21.04.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 19 Jan 2020 21:04:54 -0800 (PST)
Date:   Sun, 19 Jan 2020 21:04:46 -0800
From:   John Fastabend <john.fastabend@gmail.com>
To:     Hangbin Liu <liuhangbin@gmail.com>, netdev@vger.kernel.org
Cc:     Song Liu <songliubraving@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Hangbin Liu <liuhangbin@gmail.com>
Message-ID: <5e2534ee4cf7b_3d922aba572005bc10@john-XPS-13-9370.notmuch>
In-Reply-To: <20200117100656.10359-1-liuhangbin@gmail.com>
References: <20200117100656.10359-1-liuhangbin@gmail.com>
Subject: RE: [PATCH bpf] selftests/bpf: skip perf hw events test if the setup
 disabled it
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hangbin Liu wrote:
> The same with commit 4e59afbbed96 ("selftests/bpf: skip nmi test when perf
> hw events are disabled"), it would make more sense to skip the
> test_stacktrace_build_id_nmi test if the setup (e.g. virtual machines) has
> disabled hardware perf events.
> 
> Fixes: 13790d1cc72c ("bpf: add selftest for stackmap with build_id in NMI context")
> Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
> ---
>  .../selftests/bpf/prog_tests/stacktrace_build_id_nmi.c    | 8 ++++++--
>  1 file changed, 6 insertions(+), 2 deletions(-)
> 
> diff --git a/tools/testing/selftests/bpf/prog_tests/stacktrace_build_id_nmi.c b/tools/testing/selftests/bpf/prog_tests/stacktrace_build_id_nmi.c
> index f62aa0eb959b..437cb93e72ac 100644
> --- a/tools/testing/selftests/bpf/prog_tests/stacktrace_build_id_nmi.c
> +++ b/tools/testing/selftests/bpf/prog_tests/stacktrace_build_id_nmi.c
> @@ -49,8 +49,12 @@ void test_stacktrace_build_id_nmi(void)
>  	pmu_fd = syscall(__NR_perf_event_open, &attr, -1 /* pid */,
>  			 0 /* cpu 0 */, -1 /* group id */,
>  			 0 /* flags */);
> -	if (CHECK(pmu_fd < 0, "perf_event_open",
> -		  "err %d errno %d. Does the test host support PERF_COUNT_HW_CPU_CYCLES?\n",
> +	if (pmu_fd < 0 && errno == ENOENT) {
> +		printf("%s:SKIP:no PERF_COUNT_HW_CPU_CYCLES\n", __func__);
> +		test__skip();
> +		goto close_prog;
> +	}
> +	if (CHECK(pmu_fd < 0, "perf_event_open", "err %d errno %d\n",
>  		  pmu_fd, errno))
>  		goto close_prog;
>  

Acked-by: John Fastabend <john.fastabend@gmail.com>
