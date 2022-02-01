Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 42AC34A66B4
	for <lists+netdev@lfdr.de>; Tue,  1 Feb 2022 21:58:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242716AbiBAU56 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Feb 2022 15:57:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242674AbiBAU55 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Feb 2022 15:57:57 -0500
Received: from mail-wm1-x329.google.com (mail-wm1-x329.google.com [IPv6:2a00:1450:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 905F3C061744
        for <netdev@vger.kernel.org>; Tue,  1 Feb 2022 12:57:55 -0800 (PST)
Received: by mail-wm1-x329.google.com with SMTP id bg21-20020a05600c3c9500b0035283e7a012so2515606wmb.0
        for <netdev@vger.kernel.org>; Tue, 01 Feb 2022 12:57:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isovalent-com.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=6ryE+dCAEy+HtNDOnQjsgxlloDkHSKCHtP3WwpU7TLg=;
        b=PxuikIQkR0REoqg2a7eZ3HfsivzeiwdyqKGww73Wo4k1ltY3Ab4c0XmEBRwglfgQkj
         w875eNrVNMV+Sz6/tP9DV2ryzC5LtENg33GbpeCyF4TnohgAjj+VSrbBBtKCRdYkFOaF
         dMNTpu8WHAcXmbNE62SMch3zxDdeVermlnIOenLtoezq7IGBMAPaRymkqt7jxz+FaZZE
         euQubwAL0WsZp8fQxmsxk3h6X1MH8R1meTJFyHuYOtLrd0NKHWgRq7Jj2i3reHY4g3Hu
         PQaNl/jou9aU8AWG6Jz95WameoyyjeHY86bYUsf9mhyZljkChMbm1fTwls/zfanQ2JoZ
         2PaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=6ryE+dCAEy+HtNDOnQjsgxlloDkHSKCHtP3WwpU7TLg=;
        b=cJME360zYUt/EFP94vLb9eXE3ukhDEkWCBLQpRoJeVXU+krBUKoUmnAzlBU+adaah1
         ofQoxCTwzZ34Hv30eokeLVuM4/KlmyY8eme+nH1gPDFHK+HfBxaGTLazfeDxS7uEyAsD
         D8U5Za39hRp0PCs1g56aECUebHHkww+1eNhD7nUjeJwyi/jYSkQnuOHvfCtL4omhS0vm
         s4GOu7BCPGq4xKL2hACazg6nSMjQBKaxgXXsxABspFnC9gmi/lKWtU+xMOrRKu0z/wPB
         i9kR0awLZYsweIk0eS1n2PYqdhPF3g7O+Cwmh1MNMa275Lptf90Ikqzm9Ify9PvRThOO
         RmuA==
X-Gm-Message-State: AOAM530x6+uWbwdQ3jcC3FxAIpmNePE/ufzptyX10E2xTb1bG0Tdh/Sd
        i6cL6bG30eJBIOx4ti3dgDhazA==
X-Google-Smtp-Source: ABdhPJyATHrRFBZVgj3xDvxtilB++SVPoU95BK2ICwXcpMNtKDkDHLz/iLGDvbHqKBgr2Xg5hc4CKQ==
X-Received: by 2002:a05:600c:414a:: with SMTP id h10mr3387273wmm.89.1643749074189;
        Tue, 01 Feb 2022 12:57:54 -0800 (PST)
Received: from [192.168.1.8] ([149.86.72.139])
        by smtp.gmail.com with ESMTPSA id y6sm2815561wma.48.2022.02.01.12.57.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 01 Feb 2022 12:57:53 -0800 (PST)
Message-ID: <013a33d5-622e-b503-7a25-c77fbf1be1de@isovalent.com>
Date:   Tue, 1 Feb 2022 20:57:52 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.1
Subject: Re: [PATCH bpf-next v5 9/9] selftest/bpf: Implement tests for bpftool
 gen min_core_btf
Content-Language: en-GB
To:     =?UTF-8?Q?Mauricio_V=c3=a1squez?= <mauricio@kinvolk.io>,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Rafael David Tinoco <rafaeldtinoco@gmail.com>,
        Lorenzo Fontana <lorenzo.fontana@elastic.co>,
        Leonardo Di Donato <leonardo.didonato@elastic.co>
References: <20220128223312.1253169-1-mauricio@kinvolk.io>
 <20220128223312.1253169-10-mauricio@kinvolk.io>
From:   Quentin Monnet <quentin@isovalent.com>
In-Reply-To: <20220128223312.1253169-10-mauricio@kinvolk.io>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

2022-01-28 17:33 UTC-0500 ~ Mauricio Vásquez <mauricio@kinvolk.io>
> This commit implements some integration tests for "BTFGen". The goal
> of such tests is to verify that the generated BTF file contains the
> expected types.
> 
> Signed-off-by: Mauricio Vásquez <mauricio@kinvolk.io>
> Signed-off-by: Rafael David Tinoco <rafael.tinoco@aquasec.com>
> Signed-off-by: Lorenzo Fontana <lorenzo.fontana@elastic.co>
> Signed-off-by: Leonardo Di Donato <leonardo.didonato@elastic.co>
> ---
>  tools/testing/selftests/bpf/.gitignore        |   1 +
>  tools/testing/selftests/bpf/Makefile          |   4 +-
>  .../selftests/bpf/progs/btfgen_btf_source.c   |  12 +
>  .../bpf/progs/btfgen_primitives_array.c       |  39 +++
>  .../bpf/progs/btfgen_primitives_struct.c      |  40 +++
>  .../bpf/progs/btfgen_primitives_struct2.c     |  44 ++++
>  .../bpf/progs/btfgen_primitives_union.c       |  32 +++
>  tools/testing/selftests/bpf/test_bpftool.c    | 228 ++++++++++++++++++
>  8 files changed, 399 insertions(+), 1 deletion(-)
>  create mode 100644 tools/testing/selftests/bpf/progs/btfgen_btf_source.c
>  create mode 100644 tools/testing/selftests/bpf/progs/btfgen_primitives_array.c
>  create mode 100644 tools/testing/selftests/bpf/progs/btfgen_primitives_struct.c
>  create mode 100644 tools/testing/selftests/bpf/progs/btfgen_primitives_struct2.c
>  create mode 100644 tools/testing/selftests/bpf/progs/btfgen_primitives_union.c
>  create mode 100644 tools/testing/selftests/bpf/test_bpftool.c
> 
> diff --git a/tools/testing/selftests/bpf/.gitignore b/tools/testing/selftests/bpf/.gitignore
> index 1dad8d617da8..308cd5b9cfc4 100644
> --- a/tools/testing/selftests/bpf/.gitignore
> +++ b/tools/testing/selftests/bpf/.gitignore
> @@ -41,3 +41,4 @@ test_cpp
>  *.tmp
>  xdpxceiver
>  xdp_redirect_multi
> +test_bpftool
> diff --git a/tools/testing/selftests/bpf/Makefile b/tools/testing/selftests/bpf/Makefile
> index 945f92d71db3..afc9bff6545d 100644
> --- a/tools/testing/selftests/bpf/Makefile
> +++ b/tools/testing/selftests/bpf/Makefile
> @@ -38,7 +38,8 @@ TEST_GEN_PROGS = test_verifier test_tag test_maps test_lru_map test_lpm_map test
>  	test_sock test_sockmap get_cgroup_id_user \
>  	test_cgroup_storage \
>  	test_tcpnotify_user test_sysctl \
> -	test_progs-no_alu32
> +	test_progs-no_alu32 \
> +	test_bpftool

Do you think we could rename this file to something like
“test_bpftool_min_core_btf”? We already have a “test_bpftool.py” and I
fear it might lead to confusion.

>  
>  # Also test bpf-gcc, if present
>  ifneq ($(BPF_GCC),)
> @@ -212,6 +213,7 @@ $(OUTPUT)/xdping: $(TESTING_HELPERS)
>  $(OUTPUT)/flow_dissector_load: $(TESTING_HELPERS)
>  $(OUTPUT)/test_maps: $(TESTING_HELPERS)
>  $(OUTPUT)/test_verifier: $(TESTING_HELPERS)
> +$(OUTPUT)/test_bpftool:
>  
>  BPFTOOL ?= $(DEFAULT_BPFTOOL)
>  $(DEFAULT_BPFTOOL): $(wildcard $(BPFTOOLDIR)/*.[ch] $(BPFTOOLDIR)/Makefile)    \

> diff --git a/tools/testing/selftests/bpf/test_bpftool.c b/tools/testing/selftests/bpf/test_bpftool.c
> new file mode 100644
> index 000000000000..ca7facc582d5
> --- /dev/null
> +++ b/tools/testing/selftests/bpf/test_bpftool.c
> @@ -0,0 +1,228 @@
> +// SPDX-License-Identifier: GPL-2.0-only

Not sure if it is intentional to use “GPL-2.0-only” where the other
files in your patch have “GPL-2.0”. But I don't believe it matters much
anyway.
