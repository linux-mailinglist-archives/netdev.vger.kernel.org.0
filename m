Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D7A194307E
	for <lists+netdev@lfdr.de>; Wed, 12 Jun 2019 21:59:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388615AbfFLT7U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Jun 2019 15:59:20 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:41494 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387605AbfFLT7T (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Jun 2019 15:59:19 -0400
Received: by mail-pl1-f194.google.com with SMTP id s24so7058265plr.8
        for <netdev@vger.kernel.org>; Wed, 12 Jun 2019 12:59:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fomichev-me.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=YXo2pGsL2sbCtFbNaUybVNbLhzgrUMJfssd/0MYAwv4=;
        b=Mk6XLOnnW4QppyMWHCS0NldCM8XQo6tVC9topS+WELsexNMe1y/C8KGilpQerlBFJj
         DnMOKyWFt6WUWMIFAnQBHRl8CdlY9s88IvfWGPjXTPF5fsSUMfuxHbvywegHVYu1pYy0
         AM2CwytV9VdN9jArYV/n/+/GIWwBddUm0k7CFA5I8Yw+h1LUl+FWSkBzyS+0OSbT185d
         rYi/neTA5heUcGU9CBaFVvzl9xTEN1nPt8s9iJ0n+Hi6rSf/TbLLpTiO+ubt12Nn8QAk
         bwA2EXVL1wepKJYli61odG4XLR/Ux9PscZw9z2cEgtx/Ce3lrFo0eetZ08EgMjQkE5cA
         54CA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=YXo2pGsL2sbCtFbNaUybVNbLhzgrUMJfssd/0MYAwv4=;
        b=iDTZgxftxc7Ty7RH8VXQVreytoD4SKZD3qNjSlDqB4yrLJuVVAZ0LYNvDVtacKPnIr
         5+HlPWCkyg0DNIlE/423teI82llA4xKZw8DxQUWOyt+6jbBq2fjbe82UHVO2wPXXqnei
         kz3wISFZJJMycLuqF3sh+h9iWMkWAjMGoLueuuZbzEFccH/deQUY6QPib1Tu5ODK+B4+
         OVqDGLOyGcLLvtIejdYcgDb1tMXYPoz9Uv6HiJkbVeCGcd9EnCaz7oIXPd7HxYjnoClN
         oiRXm/htQ/cMYqTz906OFfkcKiDhNNJFcYFDPM94J8rROvWN5FuvmC7qEH4mwrohgZ9o
         RX6g==
X-Gm-Message-State: APjAAAVoCp++CeX5x8cDmcPOok4gbhDgMgEixEw5YLEr6TOWg+iKdmcO
        8FFoBTxIdNMTxf0m2q6p/gq8cQ==
X-Google-Smtp-Source: APXvYqzD31Hsp4P/+qMUXYuo1N6szXTfwcLhfCZBVbKOe5ErKLSWoOUqoIIRNFREzuTBc7uVhVv+vA==
X-Received: by 2002:a17:902:848c:: with SMTP id c12mr82093141plo.17.1560369558603;
        Wed, 12 Jun 2019 12:59:18 -0700 (PDT)
Received: from localhost ([2601:646:8f00:18d9:d0fa:7a4b:764f:de48])
        by smtp.gmail.com with ESMTPSA id u20sm283242pgm.56.2019.06.12.12.59.17
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Wed, 12 Jun 2019 12:59:18 -0700 (PDT)
Date:   Wed, 12 Jun 2019 12:59:17 -0700
From:   Stanislav Fomichev <sdf@fomichev.me>
To:     Martin KaFai Lau <kafai@fb.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        David Miller <davem@davemloft.net>, kernel-team@fb.com
Subject: Re: [PATCH bpf-next 2/2] bpf: Add test for SO_REUSEPORT_DETACH_BPF
Message-ID: <20190612195917.GB9056@mini-arch>
References: <20190612190536.2340077-1-kafai@fb.com>
 <20190612190539.2340343-1-kafai@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190612190539.2340343-1-kafai@fb.com>
User-Agent: Mutt/1.12.0 (2019-05-25)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 06/12, Martin KaFai Lau wrote:
> This patch adds a test for the new sockopt SO_REUSEPORT_DETACH_BPF.
> 
> '-I../../../../usr/include/' is added to the Makefile to get
> the newly added SO_REUSEPORT_DETACH_BPF.
> 
> Signed-off-by: Martin KaFai Lau <kafai@fb.com>
> ---
>  tools/testing/selftests/bpf/Makefile          |  1 +
>  .../selftests/bpf/test_select_reuseport.c     | 50 +++++++++++++++++++
>  2 files changed, 51 insertions(+)
> 
> diff --git a/tools/testing/selftests/bpf/Makefile b/tools/testing/selftests/bpf/Makefile
> index 44fb61f4d502..c7370361fa81 100644
> --- a/tools/testing/selftests/bpf/Makefile
> +++ b/tools/testing/selftests/bpf/Makefile
> @@ -16,6 +16,7 @@ LLVM_OBJCOPY	?= llvm-objcopy
>  LLVM_READELF	?= llvm-readelf
>  BTF_PAHOLE	?= pahole
>  CFLAGS += -Wall -O2 -I$(APIDIR) -I$(LIBDIR) -I$(BPFDIR) -I$(GENDIR) $(GENFLAGS) -I../../../include \
> +	  -I../../../../usr/include/ \
Why not copy inlude/uapi/asm-generic/socket.h into tools/include
instead? Will that work?

>  	  -Dbpf_prog_load=bpf_prog_test_load \
>  	  -Dbpf_load_program=bpf_test_load_program
>  LDLIBS += -lcap -lelf -lrt -lpthread
> diff --git a/tools/testing/selftests/bpf/test_select_reuseport.c b/tools/testing/selftests/bpf/test_select_reuseport.c
> index 75646d9b34aa..5aa00b4a4702 100644
> --- a/tools/testing/selftests/bpf/test_select_reuseport.c
> +++ b/tools/testing/selftests/bpf/test_select_reuseport.c
> @@ -523,6 +523,54 @@ static void test_pass_on_err(int type, sa_family_t family)
>  	printf("OK\n");
>  }
>  
> +static void test_detach_bpf(int type, sa_family_t family)
> +{
> +	__u32 nr_run_before = 0, nr_run_after = 0, tmp, i;
> +	struct epoll_event ev;
> +	int cli_fd, err, nev;
> +	struct cmd cmd = {};
> +	int optvalue = 0;
> +
> +	printf("%s: ", __func__);
> +	err = setsockopt(sk_fds[0], SOL_SOCKET, SO_DETACH_REUSEPORT_BPF,
> +			 &optvalue, sizeof(optvalue));
> +	CHECK(err == -1, "setsockopt(SO_DETACH_REUSEPORT_BPF)",
> +	      "err:%d errno:%d\n", err, errno);
> +
> +	err = setsockopt(sk_fds[1], SOL_SOCKET, SO_DETACH_REUSEPORT_BPF,
> +			 &optvalue, sizeof(optvalue));
> +	CHECK(err == 0 || errno != ENOENT, "setsockopt(SO_DETACH_REUSEPORT_BPF)",
> +	      "err:%d errno:%d\n", err, errno);
> +
> +	for (i = 0; i < NR_RESULTS; i++) {
> +		err = bpf_map_lookup_elem(result_map, &i, &tmp);
> +		CHECK(err == -1, "lookup_elem(result_map)",
> +		      "i:%u err:%d errno:%d\n", i, err, errno);
> +		nr_run_before += tmp;
> +	}
> +
> +	cli_fd = send_data(type, family, &cmd, sizeof(cmd), PASS);
> +	nev = epoll_wait(epfd, &ev, 1, 5);
> +	CHECK(nev <= 0, "nev <= 0",
> +	      "nev:%d expected:1 type:%d family:%d data:(0, 0)\n",
> +	      nev,  type, family);
> +
> +	for (i = 0; i < NR_RESULTS; i++) {
> +		err = bpf_map_lookup_elem(result_map, &i, &tmp);
> +		CHECK(err == -1, "lookup_elem(result_map)",
> +		      "i:%u err:%d errno:%d\n", i, err, errno);
> +		nr_run_after += tmp;
> +	}
> +
> +	CHECK(nr_run_before != nr_run_after,
> +	      "nr_run_before != nr_run_after",
> +	      "nr_run_before:%u nr_run_after:%u\n",
> +	      nr_run_before, nr_run_after);
> +
> +	printf("OK\n");
> +	close(cli_fd);
> +}
> +
>  static void prepare_sk_fds(int type, sa_family_t family, bool inany)
>  {
>  	const int first = REUSEPORT_ARRAY_SIZE - 1;
> @@ -664,6 +712,8 @@ static void test_all(void)
>  			test_pass(type, family);
>  			test_syncookie(type, family);
>  			test_pass_on_err(type, family);
> +			/* Must be the last test */
> +			test_detach_bpf(type, family);
>  
>  			cleanup_per_test();
>  			printf("\n");
> -- 
> 2.17.1
> 
