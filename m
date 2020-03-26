Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B405C194D92
	for <lists+netdev@lfdr.de>; Fri, 27 Mar 2020 00:54:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727699AbgCZXyc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Mar 2020 19:54:32 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:38488 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726067AbgCZXyc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Mar 2020 19:54:32 -0400
Received: by mail-pg1-f196.google.com with SMTP id x7so3705602pgh.5;
        Thu, 26 Mar 2020 16:54:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=7CVUJ19v0pY389uYsPOimGpmTd+8zgk3ZoECLlak5lM=;
        b=INFMJGFcMVQGmxapcKuRntC2Hu7Scihi/K2WIqPinYkE7x1TAkiXXc/d9BNnWaPns4
         L5Yjl1/AowBiF15atWfviywBhgO0UTCApRKD1MEGRqOaNjJrO5D5tVfDDz4cE2trvw7l
         bVlE0Rmf+Rh4whilo56Bl9iTZHvA/Je7qZtsq+R12rNvESruWl2DpeWOyGkOP8bTUtJl
         /o2zXLz1MMGyJ7Kxl3bLSSodp3GyaoJKNprYHm99xSQEbaB3llKIkqNDETYReSsVx9nE
         FnvPXwu9d7nsGvcDwKRbA8+6i5NN5ibUQbL2vPleW6nU335BCJvH52SJ0grrfZk7KwSi
         8EvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=7CVUJ19v0pY389uYsPOimGpmTd+8zgk3ZoECLlak5lM=;
        b=WODTFPEOQnnMYBo9VCxkSA5i0evU3VthziUjDUZg9HUk6iR90FQZScpW/IQHZg/z6p
         Pr+D5TiiAZGmq4ptlNOjqwfDdh5iUHFowZumTujom0Z15ApS+6iqYrg9CuLa7I+KIS9o
         wnl1SzQOmmmK/jKI/AjZBKhNC7uL7BJJm+G4e2oe1uaGpRaU/8zGJM/cKRiB0WcXvn2M
         NB0+m//El3bn13q+8lnbdSmGXB6ZVqHNtec2HhrZmRH0sGL/YoNh40THmareWlau5xUB
         yIKGCD6Gv/MwyQxM5HbMNs3iX3exjExLe4wMya74QdS2YmT3DNTTxo5tVtJAyGjvshGq
         8bkg==
X-Gm-Message-State: ANhLgQ15N5sneQW/xMREsldks7Ms6CIYwaNux0ZMcDi5czpyLJ3LUibf
        frirDRhqZOvZR3fBpx5MXok=
X-Google-Smtp-Source: ADFU+vtHItp+nWzngvwdD8m8gR416+z5AIiqRHKH0JSJZuOyBE5OslhJKwILx7T9X+o7ZOXp/Dq6XA==
X-Received: by 2002:a63:1517:: with SMTP id v23mr10800809pgl.89.1585266871010;
        Thu, 26 Mar 2020 16:54:31 -0700 (PDT)
Received: from ast-mbp ([2620:10d:c090:400::5:c7d9])
        by smtp.gmail.com with ESMTPSA id p70sm2417463pjp.47.2020.03.26.16.54.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Mar 2020 16:54:30 -0700 (PDT)
Date:   Thu, 26 Mar 2020 16:54:26 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Jean-Philippe Menil <jpmenil@gmail.com>
Cc:     yhs@fb.com, kernel-janitors@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>,
        Andrii Nakryiko <andriin@fb.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] bpf: fix build warning - missing prototype
Message-ID: <20200326235426.ei6ae2z5ek6uq3tt@ast-mbp>
References: <7c27e51f-6a64-7374-b705-450cad42146c@fb.com>
 <20200324072231.5780-1-jpmenil@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200324072231.5780-1-jpmenil@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 24, 2020 at 08:22:31AM +0100, Jean-Philippe Menil wrote:
> Fix build warnings when building net/bpf/test_run.o with W=1 due
> to missing prototype for bpf_fentry_test{1..6}.
> 
> Declare prototypes in order to silence warnings.
> 
> Signed-off-by: Jean-Philippe Menil <jpmenil@gmail.com>
> ---
>  net/bpf/test_run.c | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/net/bpf/test_run.c b/net/bpf/test_run.c
> index d555c0d8657d..cdf87fb0b6eb 100644
> --- a/net/bpf/test_run.c
> +++ b/net/bpf/test_run.c
> @@ -113,31 +113,37 @@ static int bpf_test_finish(const union bpf_attr *kattr,
>   * architecture dependent calling conventions. 7+ can be supported in the
>   * future.
>   */
> +int noinline bpf_fentry_test1(int a);
>  int noinline bpf_fentry_test1(int a)
>  {
>  	return a + 1;
>  }
>  
> +int noinline bpf_fentry_test2(int a, u64 b);
>  int noinline bpf_fentry_test2(int a, u64 b)
>  {
>  	return a + b;
>  }
>  
> +int noinline bpf_fentry_test3(char a, int b, u64 c);
>  int noinline bpf_fentry_test3(char a, int b, u64 c)
>  {
>  	return a + b + c;
>  }
>  
> +int noinline bpf_fentry_test4(void *a, char b, int c, u64 d);
>  int noinline bpf_fentry_test4(void *a, char b, int c, u64 d)
>  {
>  	return (long)a + b + c + d;
>  }
>  
> +int noinline bpf_fentry_test5(u64 a, void *b, short c, int d, u64 e);
>  int noinline bpf_fentry_test5(u64 a, void *b, short c, int d, u64 e)
>  {
>  	return a + (long)b + c + d + e;
>  }
>  
> +int noinline bpf_fentry_test6(u64 a, void *b, short c, int d, void *e, u64 f);
>  int noinline bpf_fentry_test6(u64 a, void *b, short c, int d, void *e, u64 f)

That's a bit too much of "watery water".
Have you considered
__diag_push();
__diag_ignore(GCC, "-Wwhatever specific flag will shut up this warn")
__diag_pop();
approach ?
It will be self documenting as well.
