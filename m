Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B271436B98
	for <lists+netdev@lfdr.de>; Thu, 21 Oct 2021 21:55:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231920AbhJUT6O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Oct 2021 15:58:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231898AbhJUT6M (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Oct 2021 15:58:12 -0400
Received: from mail-wm1-x332.google.com (mail-wm1-x332.google.com [IPv6:2a00:1450:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62AECC061764
        for <netdev@vger.kernel.org>; Thu, 21 Oct 2021 12:55:55 -0700 (PDT)
Received: by mail-wm1-x332.google.com with SMTP id l38-20020a05600c1d2600b0030d80c3667aso634731wms.5
        for <netdev@vger.kernel.org>; Thu, 21 Oct 2021 12:55:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isovalent-com.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=XYIxYzcJhG46dfQP6KRsrSctXdlVV4n7ho/KEOgFs7I=;
        b=gN3Ji9gdfyc8MKmJWDursDM0jko+iRPAbPEVU0YOhdBuiqhp1qVkbCHGhWnm1QeucD
         TTY7A2h4n7exEYm1oGgCi06rAeMDDQkD1eRynV8L/BwbsY2tRukQjAHWEyYJkEXf/sXL
         w+NjVd0eJMbSFxJyoE7akv0fsP+QrLzTjlHJb3dmz71CU4txKx4hUiiTGc3ejlVK5XKT
         I77jUoNIOipeuioU9D3jAMR43vKG8kaPjOqaXERuathi9zlcoEQMx6uKzrp3WQ76AVD9
         fC9iebtfoWj1GPM5L03E8HTPM+xlnfJguNRX0bK22OY7qgXC/uI2vAo8vy3QmNZrYdLc
         3uUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=XYIxYzcJhG46dfQP6KRsrSctXdlVV4n7ho/KEOgFs7I=;
        b=kgPrJ+no643M1sS5FdS5VnaLMDKtz5VkmnJGD+rEHSY+X7ilW59eDaZLk9P0gjO4z4
         BcmpUgGWpqJQiQ7Z7tUpRASUANTWCYcGfGpR4/ujx3eCoUIHDf+dhleNfcyqrqxRsUyq
         9eR4oNA1e+9YYJAkdeAdZ5/Y1sgzE09XQzbNL/dkT9fe53/hvRDR3X9zDtx4Oycmcsai
         bRaGHyw1NQzQEEEZmcIfZfv0/rhaEUDJepUE9UiXtbieVavrRxwNVb2t5+tXBdYKsZgL
         DpXCobpTIGB0e1mxQ5YHSr5el8MMPTyajbmE6vlrUlatUbj66DTBkz/A7JOXsfeL+UnH
         rzng==
X-Gm-Message-State: AOAM531hfOtwgGRCwPHyLeavUQWsPuPH35voKCsv8cKGuGvPqIVD2BMN
        fjfMYkSg6bPrBJSY8Dj5wScT6g==
X-Google-Smtp-Source: ABdhPJzm69MdfN1iaNvp5igcEeXW7V22oi0NRoWoiylgbRpLwsv0OjcHLKDgKCG5gio8j/avuV+53w==
X-Received: by 2002:a05:600c:2212:: with SMTP id z18mr8690844wml.39.1634846153980;
        Thu, 21 Oct 2021 12:55:53 -0700 (PDT)
Received: from [192.168.1.8] ([149.86.65.74])
        by smtp.gmail.com with ESMTPSA id p3sm5792839wrs.10.2021.10.21.12.55.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 21 Oct 2021 12:55:53 -0700 (PDT)
Message-ID: <2f2fd146-222a-ecdb-7fe1-d9f67f5ac1de@isovalent.com>
Date:   Thu, 21 Oct 2021 20:55:52 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [PATCH bpf-next v4 2/3] bpftool: conditionally append / to the
 progtype
Content-Language: en-US
To:     Stanislav Fomichev <sdf@google.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Cc:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org
References: <20211021165618.178352-1-sdf@google.com>
 <20211021165618.178352-3-sdf@google.com>
From:   Quentin Monnet <quentin@isovalent.com>
In-Reply-To: <20211021165618.178352-3-sdf@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

2021-10-21 09:56 UTC-0700 ~ Stanislav Fomichev <sdf@google.com>
> Otherwise, attaching with bpftool doesn't work with strict section names.
> 
> Also, switch to libbpf strict mode to use the latest conventions
> (note, I don't think we have any cli api guarantees?).
> 
> Cc: Quentin Monnet <quentin@isovalent.com>
> Signed-off-by: Stanislav Fomichev <sdf@google.com>
> ---
>  tools/bpf/bpftool/main.c | 4 ++++
>  tools/bpf/bpftool/prog.c | 9 +++++++--
>  2 files changed, 11 insertions(+), 2 deletions(-)
> 
> diff --git a/tools/bpf/bpftool/main.c b/tools/bpf/bpftool/main.c
> index 02eaaf065f65..8223bac1e401 100644
> --- a/tools/bpf/bpftool/main.c
> +++ b/tools/bpf/bpftool/main.c
> @@ -409,6 +409,10 @@ int main(int argc, char **argv)
>  	block_mount = false;
>  	bin_name = argv[0];
>  
> +	ret = libbpf_set_strict_mode(LIBBPF_STRICT_ALL);
> +	if (ret)
> +		p_err("failed to enable libbpf strict mode: %d", ret);
> +
>  	hash_init(prog_table.table);
>  	hash_init(map_table.table);
>  	hash_init(link_table.table);
> diff --git a/tools/bpf/bpftool/prog.c b/tools/bpf/bpftool/prog.c
> index 277d51c4c5d9..b04990588ccf 100644
> --- a/tools/bpf/bpftool/prog.c
> +++ b/tools/bpf/bpftool/prog.c
> @@ -1420,8 +1420,13 @@ static int load_with_options(int argc, char **argv, bool first_prog_only)
>  			err = get_prog_type_by_name(type, &common_prog_type,
>  						    &expected_attach_type);
>  			free(type);
> -			if (err < 0)
> -				goto err_free_reuse_maps;

Thanks a lot for the change! Can you please test it for e.g. an XDP
program? You should see that "bpftool prog load prog.o <path> type xdp"
prints a debug message from libbpf about the first attempt (above)
failing, before the second attempt (below) succeeds.

We need to get rid of this message. I think it should be easy, because
we explicitly "ask" for that message in get_prog_type_by_name(), in the
same file, if it fails to load in the first place.

Could you please update get_prog_type_by_name() to take an additional
switch as an argument, to tell if the debug-info should be retrieved
(then first attempt here would skip it, second would keep it)?
An alternative could be to move all the '/' and retries handling to that
function, and I think it would end up in bpftool keeping support for the
legacy object files with the former convention - but that would somewhat
defeat the objectives of the strict mode, so maybe not the best option.


> +			if (err < 0) {

We could run the second attempt only on libbpf returning -ESRCH, maybe?

> +				err = get_prog_type_by_name(*argv, &common_prog_type,
> +							    &expected_attach_type);
> +				if (err < 0)
> +
> +					goto err_free_reuse_maps;
> +			}
>  
>  			NEXT_ARG();
>  		} else if (is_prefix(*argv, "map")) {
> 

