Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7828D5EA597
	for <lists+netdev@lfdr.de>; Mon, 26 Sep 2022 14:08:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235337AbiIZMH5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Sep 2022 08:07:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240098AbiIZMGX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Sep 2022 08:06:23 -0400
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4F647EFFF
        for <netdev@vger.kernel.org>; Mon, 26 Sep 2022 03:55:46 -0700 (PDT)
Received: by mail-wr1-x42d.google.com with SMTP id c11so9545063wrp.11
        for <netdev@vger.kernel.org>; Mon, 26 Sep 2022 03:55:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isovalent-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date;
        bh=TkeJ6Fx1YX+DJ9RAwA8Kk9or3Gugtl5q1hK17knU0BA=;
        b=B9y43+TNPHZ/59uqH8nEbojremxQKTaJQoSInS8tVxC5USe5fb7hsS6Fmf7GLEGT9/
         NyXf6VhkDRrA2UJtKiQhl8Ohykck1m3tVA1GPk/7225r4haIcXNCsqRsPo4aagC270aZ
         dbxRA+/qHW9FQo6YhvNoVVYTjDwHIyKc3S5+p3tA5q1T57CpRhEmUiPEbUFnloMvqsVl
         iB8o0kiYLyA006xg3KXZK1hg73bLmKKZXqbG/w7vFrFAn9Fjwvxz2K3EowWuxfISeh0x
         LMYNZLRN11tRP0zy2n3Xt69VIHZCigxfqusfn+MUmdzreBZM5ZT81rNRcZY6w9typ4Rx
         v2OQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=TkeJ6Fx1YX+DJ9RAwA8Kk9or3Gugtl5q1hK17knU0BA=;
        b=iqroeVWrMGU1v0+x9EFDU4m/Moh2k6Af1azoT4FS7wJ8RrrAck9dEWPJTlmVi2y4cH
         l3vFKhYLWZen8effHRxOsO4lf+7x0cINM0WaI4NN2ztOkc/ND/ObbJZXF38Z/aLJ3j95
         DROTv8g5UxafbH5yZ6H3fqkvmdHZVOETjESE5vMI+1PInuleqJWF/A9zwbSozo6geojJ
         ZQzYZeh1z+7h25EYzzInPcQmpQwh09/TTL+bbBMVEHh+b3t7vWjfWPdUBS9qU7GF1AX0
         9m0sc/1FiGerTAWtLTvdFaJJS8uOBn5MZdZKoVFtkmSppsTmhxq2V4DOsj8uNSWYEeuo
         br6Q==
X-Gm-Message-State: ACrzQf1fMjNDIEytUN+TcoOm11l0xvLiKEmSm80IfMAM2t0A1PzrmAIM
        ub4wH8z93Xaw27OvAduLfsv0V1iGh1T9ow==
X-Google-Smtp-Source: AMsMyM4rI/LVbjbcwOi+ZBasDlj+u6afWRFcKSFN0LE8DC93MLu9289n4JIYLawB9nsOT0+CPltxSA==
X-Received: by 2002:a05:6000:1887:b0:22a:3c3d:75ea with SMTP id a7-20020a056000188700b0022a3c3d75eamr12324657wri.669.1664189191814;
        Mon, 26 Sep 2022 03:46:31 -0700 (PDT)
Received: from [192.168.178.32] ([51.155.200.13])
        by smtp.gmail.com with ESMTPSA id x8-20020adfdcc8000000b0022a2dbc80fdsm13971613wrm.10.2022.09.26.03.46.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 26 Sep 2022 03:46:31 -0700 (PDT)
Message-ID: <2f670f3f-4d91-9b74-4fbe-8ea1351444cb@isovalent.com>
Date:   Mon, 26 Sep 2022 11:46:29 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.0
Subject: Re: [bpf-next v6 1/3] bpftool: Add auto_attach for bpf prog
 load|loadall
Content-Language: en-GB
To:     Wang Yufen <wangyufen@huawei.com>, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org, martin.lau@linux.dev,
        song@kernel.org, yhs@fb.com, john.fastabend@gmail.com,
        kpsingh@kernel.org, sdf@google.com, haoluo@google.com,
        jolsa@kernel.org, davem@davemloft.net, kuba@kernel.org,
        hawk@kernel.org, nathan@kernel.org, ndesaulniers@google.com,
        trix@redhat.com
Cc:     bpf@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, llvm@lists.linux.dev
References: <1664014430-5286-1-git-send-email-wangyufen@huawei.com>
From:   Quentin Monnet <quentin@isovalent.com>
In-Reply-To: <1664014430-5286-1-git-send-email-wangyufen@huawei.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sat Sep 24 2022 11:13:48 GMT+0100 (British Summer Time) ~ Wang Yufen
<wangyufen@huawei.com>
> Add auto_attach optional to support one-step load-attach-pin_link.
> 
> For example,
>    $ bpftool prog loadall test.o /sys/fs/bpf/test autoattach
> 
>    $ bpftool link
>    26: tracing  name test1  tag f0da7d0058c00236  gpl
>    	loaded_at 2022-09-09T21:39:49+0800  uid 0
>    	xlated 88B  jited 55B  memlock 4096B  map_ids 3
>    	btf_id 55
>    28: kprobe  name test3  tag 002ef1bef0723833  gpl
>    	loaded_at 2022-09-09T21:39:49+0800  uid 0
>    	xlated 88B  jited 56B  memlock 4096B  map_ids 3
>    	btf_id 55
>    57: tracepoint  name oncpu  tag 7aa55dfbdcb78941  gpl
>    	loaded_at 2022-09-09T21:41:32+0800  uid 0
>    	xlated 456B  jited 265B  memlock 4096B  map_ids 17,13,14,15
>    	btf_id 82
> 
>    $ bpftool link
>    1: tracing  prog 26
>    	prog_type tracing  attach_type trace_fentry
>    3: perf_event  prog 28
>    10: perf_event  prog 57
> 
> The autoattach optional can support tracepoints, k(ret)probes,
> u(ret)probes.
> 
> Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
> Signed-off-by: Wang Yufen <wangyufen@huawei.com>
> ---
> v5 -> v6: skip the programs not supporting auto-attach,
> 	  and change optional name from "auto_attach" to "autoattach"
> v4 -> v5: some formatting nits of doc
> v3 -> v4: rename functions, update doc, bash and do_help()
> v2 -> v3: switch to extend prog load command instead of extend perf
> v2: https://patchwork.kernel.org/project/netdevbpf/patch/20220824033837.458197-1-weiyongjun1@huawei.com/
> v1: https://patchwork.kernel.org/project/netdevbpf/patch/20220816151725.153343-1-weiyongjun1@huawei.com/
>  tools/bpf/bpftool/prog.c | 76 ++++++++++++++++++++++++++++++++++++++--
>  1 file changed, 74 insertions(+), 2 deletions(-)
> 
> diff --git a/tools/bpf/bpftool/prog.c b/tools/bpf/bpftool/prog.c
> index c81362a001ba..b1cbd06dee19 100644
> --- a/tools/bpf/bpftool/prog.c
> +++ b/tools/bpf/bpftool/prog.c
> @@ -1453,6 +1453,67 @@ get_prog_type_by_name(const char *name, enum bpf_prog_type *prog_type,
>  	return ret;
>  }
>  
> +static int
> +auto_attach_program(struct bpf_program *prog, const char *path)
> +{
> +	struct bpf_link *link;
> +	int err;
> +
> +	link = bpf_program__attach(prog);
> +	if (!link)
> +		return -1;
> +
> +	err = bpf_link__pin(link, path);
> +	if (err) {
> +		bpf_link__destroy(link);
> +		return err;
> +	}
> +	return 0;
> +}
> +
> +static int pathname_concat(const char *path, const char *name, char *buf)
> +{
> +	int len;
> +
> +	len = snprintf(buf, PATH_MAX, "%s/%s", path, name);
> +	if (len < 0)
> +		return -EINVAL;
> +	if (len >= PATH_MAX)
> +		return -ENAMETOOLONG;
> +
> +	return 0;
> +}
> +
> +static int
> +auto_attach_programs(struct bpf_object *obj, const char *path)
> +{
> +	struct bpf_program *prog;
> +	char buf[PATH_MAX];
> +	int err;
> +
> +	bpf_object__for_each_program(prog, obj) {
> +		err = pathname_concat(path, bpf_program__name(prog), buf);
> +		if (err)
> +			goto err_unpin_programs;
> +
> +		err = auto_attach_program(prog, buf);
> +		if (err && errno != EOPNOTSUPP)
> +			goto err_unpin_programs;

If I read the above correctly, we skip entirely programs that couldn't
be auto-attached. I'm not sure what Andrii had in mind exactly, but it
would make sense to me to fallback to regular program pinning if the
program couldn't be attached/linked, so we still keep it loaded in the
kernel after bpftool exits. Probably with a p_info() message to let
users know?

> +	}
> +
> +	return 0;
> +
> +err_unpin_programs:
> +	while ((prog = bpf_object__prev_program(obj, prog))) {
> +		if (pathname_concat(path, bpf_program__name(prog), buf))
> +			continue;
> +
> +		bpf_program__unpin(prog, buf);
> +	}
> +
> +	return err;
> +}
