Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 56D19148EDE
	for <lists+netdev@lfdr.de>; Fri, 24 Jan 2020 20:46:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392305AbgAXTqh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jan 2020 14:46:37 -0500
Received: from mail-pf1-f193.google.com ([209.85.210.193]:42657 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388136AbgAXTqg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Jan 2020 14:46:36 -0500
Received: by mail-pf1-f193.google.com with SMTP id 4so1596823pfz.9;
        Fri, 24 Jan 2020 11:46:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=Gm6lkD9sgLgV2qomq3AVkOddktzWkFTVKTvDd8uS+fY=;
        b=gbjNskUVs0oggd3PuIth0/LTXovEQWs0mr9H826lTDiDQ5sP7y1S0343j9NYv2mGlQ
         Hl0xhETQzmCexNNWGioPLcRr2u7hWxgNnuT76C8FjjwpvXPOxCmMH7Qr6HZMyCMmHbUX
         2sUFtPJV6FqPN0gIf437fBc+lehyOD3O8s7v2BNE57ItfYIeaR9l7AL4WWSE7oDoupJ1
         xie2TSJkSEnoRPgwd4Kt/6zXn+UB53KmznPkPtj99M5lA0v0Y+5189Dy/s+PJKU7CwBa
         ekczY6SR2sJa0cBo9YVP9a6Jg988v7t5PLTu7Hn2MXW4astkbKzLqoOwg2BapYXRHBdW
         vQ3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=Gm6lkD9sgLgV2qomq3AVkOddktzWkFTVKTvDd8uS+fY=;
        b=QYxUWz5GXON5KYn5a+aujtrvMW0GIr2DFMfe69XcoZai+aFx3yoGTMQKSdHpN/5Yd1
         CsTAZ5LHNdb09FjotjgT20iFZ/+uZnYFbFR8+26PEq85dHhZE9XrpFYotAaKQkSzc5En
         S/6UibScLkEcOx7BVJFXQrgKiU/4bJy8BvD0/RVikQBhHGNX0ZdGUFfod8qB1PUpa/od
         WaQbaVPhqtYaY81Gr6Ggq/nSVN4mmrs7p2FAieDky0ry36F4KW+u+BX/3O6vLFEoQJP3
         7CrTzS5tQqaNKTLPWUk7J3THCPDdRxrGu+1i5vtxQSQ+xUCpW9kj85Hr8Sab6maZ3CjL
         f0xw==
X-Gm-Message-State: APjAAAWupYlneuX+ytPvmvzwSabzqiIIsQFSrHJq3SpE3z5ONcCEFNlT
        CCvh7DHbh5rYY7f5yH1e/h8=
X-Google-Smtp-Source: APXvYqxU/J6koi+2oe+gS6t+6wkUR/gjAJhREb+DoZ0/U1bRN0AUcRz2isrWa1VYAkPFrMGjz7AuCg==
X-Received: by 2002:a62:8247:: with SMTP id w68mr4852040pfd.2.1579895195986;
        Fri, 24 Jan 2020 11:46:35 -0800 (PST)
Received: from localhost ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id x21sm7125201pfn.164.2020.01.24.11.46.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Jan 2020 11:46:35 -0800 (PST)
Date:   Fri, 24 Jan 2020 11:46:27 -0800
From:   John Fastabend <john.fastabend@gmail.com>
To:     Lorenz Bauer <lmb@cloudflare.com>, Shuah Khan <shuah@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Cc:     Lorenz Bauer <lmb@cloudflare.com>, linux-kselftest@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org
Message-ID: <5e2b4993c633c_551b2aaf5fbda5b826@john-XPS-13-9370.notmuch>
In-Reply-To: <20200123165934.9584-4-lmb@cloudflare.com>
References: <20200123165934.9584-1-lmb@cloudflare.com>
 <20200123165934.9584-4-lmb@cloudflare.com>
Subject: RE: [PATCH bpf 3/4] selftests: bpf: make reuseport test output more
 legible
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Lorenz Bauer wrote:
> Include the name of the mismatching result in human readable format
> when reporting an error. The new output looks like the following:
> 
>   unexpected result
>    result: [1, 0, 0, 0, 0, 0]
>   expected: [0, 0, 0, 0, 0, 0]
>   mismatch on DROP_ERR_INNER_MAP (bpf_prog_linum:153)
>   check_results:FAIL:382
> 
> Signed-off-by: Lorenz Bauer <lmb@cloudflare.com>
> ---
>  .../bpf/prog_tests/select_reuseport.c         | 30 ++++++++++++++++---
>  1 file changed, 26 insertions(+), 4 deletions(-)
> 
> diff --git a/tools/testing/selftests/bpf/prog_tests/select_reuseport.c b/tools/testing/selftests/bpf/prog_tests/select_reuseport.c
> index 2c37ae7dc214..09a536af139a 100644
> --- a/tools/testing/selftests/bpf/prog_tests/select_reuseport.c
> +++ b/tools/testing/selftests/bpf/prog_tests/select_reuseport.c
> @@ -316,6 +316,28 @@ static void check_data(int type, sa_family_t family, const struct cmd *cmd,
>  		       expected.len, result.len, get_linum());
>  }
>  
> +static const char *result_to_str(enum result res)
> +{
> +	switch (res) {
> +	case DROP_ERR_INNER_MAP:
> +		return "DROP_ERR_INNER_MAP";
> +	case DROP_ERR_SKB_DATA:
> +		return "DROP_ERR_SKB_DATA";
> +	case DROP_ERR_SK_SELECT_REUSEPORT:
> +		return "DROP_ERR_SK_SELECT_REUSEPORT";
> +	case DROP_MISC:
> +		return "DROP_MISC";
> +	case PASS:
> +		return "PASS";
> +	case PASS_ERR_SK_SELECT_REUSEPORT:
> +		return "PASS_ERR_SK_SELECT_REUSEPORT";
> +	case NR_RESULTS:
> +		return "NR_RESULTS";
> +	default:
> +		return "UNKNOWN";
> +	}
> +}
> +
>  static void check_results(void)
>  {
>  	__u32 results[NR_RESULTS];
> @@ -351,10 +373,10 @@ static void check_results(void)
>  		printf(", %u", expected_results[i]);
>  	printf("]\n");
>  
> -	RET_IF(expected_results[broken] != results[broken],
> -	       "unexpected result",
> -	       "expected_results[%u] != results[%u] bpf_prog_linum:%ld\n",
> -	       broken, broken, get_linum());
> +	printf("mismatch on %s (bpf_prog_linum:%ld)\n", result_to_str(broken),
> +	       get_linum());
> +
> +	CHECK_FAIL(true);
>  }
>  
>  static int send_data(int type, sa_family_t family, void *data, size_t len,
> -- 
> 2.20.1
> 

Acked-by: John Fastabend <john.fastabend@gmail.com>
