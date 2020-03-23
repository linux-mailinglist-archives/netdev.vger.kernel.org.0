Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0CF3918F064
	for <lists+netdev@lfdr.de>; Mon, 23 Mar 2020 08:42:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727461AbgCWHmv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Mar 2020 03:42:51 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:38619 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727430AbgCWHmv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Mar 2020 03:42:51 -0400
Received: by mail-wr1-f65.google.com with SMTP id s1so15619593wrv.5;
        Mon, 23 Mar 2020 00:42:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=UZh37ycoXEQPJvIa8TQQD4wS32qVanpxbiaipTPYPv4=;
        b=VVQvLgWT8eeBqcR18iurqJfr5XafnB3FvZhL24uObshAdADJo6ReTy467QzsXVgXJi
         uyg/c7WimX6uOBVdq3J79hkpu4KM84XT1MLjiUhTCggHFO5cjZZX7WVjXAaGq/IOcRgH
         lQL6tH4h6mItv8MJ5O/5cOeBjbNaZ+xAPQ81qpIG0p7GPBXbQJ9PuIK3X2KFykT96N4c
         9wblwjAzlTysTBvlUo7yrkpOK+ofL9/sCglExcYwgdoFQr1rtX0O7DOsK9VHyYygN9dV
         lRVKnItn8J3EIEvGoA85GpVVeXxLZct4suN75z8zbXbZFOj/0xlH8QJJj8AKrihMZocA
         EM2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=UZh37ycoXEQPJvIa8TQQD4wS32qVanpxbiaipTPYPv4=;
        b=HwOHjaNrLUQRt6B6m4gQyiUa29F4+Fg32+Zybx/LZ4i5Bk7obxyogo0/GBP1qNsXcf
         465Rj+02CnGkwJOLngvQrPd9YnFR0HDZAZ+62bmr7N1xav4pZWGUDGKixMf/ryvYPAgu
         BlOvKoVKMz5SxBgyG20dTKlHVG9k9JBBaQEoLQVOdBK899HhuzF2XRlGbh2ps0Xy/qnu
         f9vpJFxNggQAg2hXwJWxccxQKgEVhrz3Oqqu6NKXc12jmeza2guoxNyE3UyfzjMQ0CYI
         6UsxsMnk2niYzVPs+Q50M0oWMkSy53OVtvIwnPlck4BaRIOmp0wk6Xr9QRsnoUVyJAvK
         zhzQ==
X-Gm-Message-State: ANhLgQ1YsZQKhnwXvuToIWXbQlaTMOj+5SiE9vpsqs2v1KY0F+LNuLNS
        FwOYXE9SDxHzB4YcnzyQOjg=
X-Google-Smtp-Source: ADFU+vvFxqhBpEkdLzntmJHaBKuQ5PAxGVV3+E6+Y/U7zr7en2fbwBanlcdD4rH097js1JSaE/37og==
X-Received: by 2002:a5d:63d2:: with SMTP id c18mr6797923wrw.385.1584949368405;
        Mon, 23 Mar 2020 00:42:48 -0700 (PDT)
Received: from localhost ([2a02:21b0:9002:6131:e6f7:db0e:d6e9:e56e])
        by smtp.gmail.com with ESMTPSA id b7sm1569052wrn.67.2020.03.23.00.42.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Mar 2020 00:42:47 -0700 (PDT)
Date:   Mon, 23 Mar 2020 08:42:47 +0100
From:   Jean-Philippe Menil <jpmenil@gmail.com>
To:     Yonghong Song <yhs@fb.com>
Cc:     netdev@vger.kernel.org, kernel-janitors@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>,
        Andrii Nakryiko <andriin@fb.com>, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] bpf: fix build warning - missing prototype
Message-ID: <20200323074247.wdkfualyvf3n6vlo@macbook>
References: <20200322140844.4674-1-jpmenil@gmail.com>
 <b08375c6-81ce-b96d-0b87-299f966f4d84@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Disposition: inline
In-Reply-To: <b08375c6-81ce-b96d-0b87-299f966f4d84@fb.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 22/03/20 at 10:32pm, Yonghong Song wrote:
>
>
>On 3/22/20 7:08 AM, Jean-Philippe Menil wrote:
>>Fix build warning when building net/bpf/test_run.o with W=1 due
>>to missing prototype for bpf_fentry_test{1..6}.
>>
>>These functions are only used in test_run.c so just make them static.
>>Therefore inline keyword should sit between storage class and type.
>
>This won't work. These functions are intentionally global functions
>so that their definitions will be in vmlinux BTF and fentry/fexit kernel
>selftests can run against them.
>
>See file 
>linux/tools/testing/selftests/bpf/progs/{fentry_test.c,fexit_test.c}.
>

I can see now, thanks for the pointer.
I totally missed that.

So, in order to fix the warnings, better to declare the prototypes?
(compiling with W=1 may be a bit unusual).

>>
>>Signed-off-by: Jean-Philippe Menil <jpmenil@gmail.com>
>>---
>>  net/bpf/test_run.c | 12 ++++++------
>>  1 file changed, 6 insertions(+), 6 deletions(-)
>>
>>diff --git a/net/bpf/test_run.c b/net/bpf/test_run.c
>>index d555c0d8657d..c0dcd29f682c 100644
>>--- a/net/bpf/test_run.c
>>+++ b/net/bpf/test_run.c
>>@@ -113,32 +113,32 @@ static int bpf_test_finish(const union bpf_attr *kattr,
>>   * architecture dependent calling conventions. 7+ can be supported in the
>>   * future.
>>   */
>>-int noinline bpf_fentry_test1(int a)
>>+static noinline int bpf_fentry_test1(int a)
>>  {
>>  	return a + 1;
>>  }
>>-int noinline bpf_fentry_test2(int a, u64 b)
>>+static noinline int bpf_fentry_test2(int a, u64 b)
>>  {
>>  	return a + b;
>>  }
>>-int noinline bpf_fentry_test3(char a, int b, u64 c)
>>+static noinline int bpf_fentry_test3(char a, int b, u64 c)
>>  {
>>  	return a + b + c;
>>  }
>>-int noinline bpf_fentry_test4(void *a, char b, int c, u64 d)
>>+static noinline int bpf_fentry_test4(void *a, char b, int c, u64 d)
>>  {
>>  	return (long)a + b + c + d;
>>  }
>>-int noinline bpf_fentry_test5(u64 a, void *b, short c, int d, u64 e)
>>+static noinline int bpf_fentry_test5(u64 a, void *b, short c, int d, u64 e)
>>  {
>>  	return a + (long)b + c + d + e;
>>  }
>>-int noinline bpf_fentry_test6(u64 a, void *b, short c, int d, void *e, u64 f)
>>+static noinline int bpf_fentry_test6(u64 a, void *b, short c, int d, void *e, u64 f)
>>  {
>>  	return a + (long)b + c + d + (long)e + f;
>>  }
>>

-- 
Jean-Philippe Menil
