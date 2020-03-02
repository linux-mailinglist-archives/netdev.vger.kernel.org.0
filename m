Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C7563175BD8
	for <lists+netdev@lfdr.de>; Mon,  2 Mar 2020 14:37:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727823AbgCBNgs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Mar 2020 08:36:48 -0500
Received: from mail-wr1-f67.google.com ([209.85.221.67]:40810 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727627AbgCBNgs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Mar 2020 08:36:48 -0500
Received: by mail-wr1-f67.google.com with SMTP id r17so12614486wrj.7
        for <netdev@vger.kernel.org>; Mon, 02 Mar 2020 05:36:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isovalent-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=oOVukgQPBydjnJCxW+4gYcPUXKTa04CMNoaKoUzYN3Q=;
        b=NmRYo5iZUCxGuMcKwie/TTawx7bTfmpIl/iLhDmZj21vUCASDJ7gZpFnmewn3O3GLb
         T0oF0aBGtYUAfQb07cljF4rVPSWwfSbxjoziHPXXuNrruoswNKjj4hjzdK5Bl4R+XpOB
         UfcFvp9ZJXlruYToRxG6AE/vcmyiU/AAYtlE+zu432pqocHDEr1MgS63tv2X5hOq///8
         4z82j/+sJpkI5OCDDTfOlIlrEEGSx/MEvZDhGGEqSHAeGE+LcbUvUrfvkeEHFqsK15BK
         yOky4LapXfJK7o2Cl9czmh3evWl47iXbn90f85TxndwUh6VQ5WKv1liWlJo0n+ZEz/kw
         TAow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=oOVukgQPBydjnJCxW+4gYcPUXKTa04CMNoaKoUzYN3Q=;
        b=RitJ1lJhEuxppK0M+Y+YJV8xgl25VHHE3gHRneH5zt4WbXl/yTYXbdMB9Hoy7YKa9x
         lQ2H95Op/RiL9OcZ2fsMBSUb2CvMVK2Hkuadp6TFfqciiXnbN2nPPN+RbjmFXjlpj3wf
         7Afp6fcJC43hz2xwpFTFyjYRKMmnX4hnVn52KpNhTCpQLmlZlOUajSjUgTMSiF6nCjcr
         U7OXpsQgARj/wbKtmFaNn8r++PoCpweRDLmqBzVLPjLSPJ+4Pe6XEHaSkDpgCP1qMYqW
         OaMNJQskJJuZjfs1NIsgjl3dirIz4Q9kKhL27P8rHjDqdq/B9an2OjpBv6U+9/qvls9B
         YyGA==
X-Gm-Message-State: APjAAAU4LtS2o4qYd/hTNfItEtb/CyiWY4AqFiSTAdKGup+tVUd1F3zD
        KVIqyCAua6O79EOmFPbOEolEOA==
X-Google-Smtp-Source: APXvYqwunAX+OZEEUqddYTAqTi3pHmbeexwD+kyrwZAWuEfPqLrmvaowI+Gfzxfb05rP12/6r9v/bA==
X-Received: by 2002:adf:b6a2:: with SMTP id j34mr23348035wre.277.1583156206278;
        Mon, 02 Mar 2020 05:36:46 -0800 (PST)
Received: from [192.168.1.10] ([194.35.116.171])
        by smtp.gmail.com with ESMTPSA id y139sm17277845wmd.24.2020.03.02.05.36.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 02 Mar 2020 05:36:45 -0800 (PST)
Subject: Re: [PATCH v2 bpf-next 2/2] bpftool: Documentation for bpftool prog
 profile
To:     Song Liu <songliubraving@fb.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Cc:     kernel-team@fb.com, ast@kernel.org, daniel@iogearbox.net,
        arnaldo.melo@gmail.com, jolsa@kernel.org
References: <20200228234058.634044-1-songliubraving@fb.com>
 <20200228234058.634044-3-songliubraving@fb.com>
From:   Quentin Monnet <quentin@isovalent.com>
Message-ID: <18194adf-2f74-6cf1-42c4-4645aec863ae@isovalent.com>
Date:   Mon, 2 Mar 2020 13:36:45 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200228234058.634044-3-songliubraving@fb.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

2020-02-28 15:40 UTC-0800 ~ Song Liu <songliubraving@fb.com>
> Add documentation for the new bpftool prog profile command.
> 
> Signed-off-by: Song Liu <songliubraving@fb.com>
> ---
>  .../bpf/bpftool/Documentation/bpftool-prog.rst  | 17 +++++++++++++++++
>  1 file changed, 17 insertions(+)
> 
> diff --git a/tools/bpf/bpftool/Documentation/bpftool-prog.rst b/tools/bpf/bpftool/Documentation/bpftool-prog.rst
> index 46862e85fed2..1e2549dcd926 100644
> --- a/tools/bpf/bpftool/Documentation/bpftool-prog.rst
> +++ b/tools/bpf/bpftool/Documentation/bpftool-prog.rst
> @@ -30,6 +30,7 @@ PROG COMMANDS
>  |	**bpftool** **prog detach** *PROG* *ATTACH_TYPE* [*MAP*]
>  |	**bpftool** **prog tracelog**
>  |	**bpftool** **prog run** *PROG* **data_in** *FILE* [**data_out** *FILE* [**data_size_out** *L*]] [**ctx_in** *FILE* [**ctx_out** *FILE* [**ctx_size_out** *M*]]] [**repeat** *N*]
> +|	**bpftool** **prog profile** [*DURATION*] *PROG* *METRICs*
>  |	**bpftool** **prog help**
>  |
>  |	*MAP* := { **id** *MAP_ID* | **pinned** *FILE* }
> @@ -48,6 +49,9 @@ PROG COMMANDS
>  |       *ATTACH_TYPE* := {
>  |		**msg_verdict** | **stream_verdict** | **stream_parser** | **flow_dissector**
>  |	}
> +|	*METRIC* := {
> +|		**cycles** | **instructions** | **l1d_loads** | **llc_misses**
> +|	}
>  
>  
>  DESCRIPTION
> @@ -189,6 +193,10 @@ DESCRIPTION
>  		  not all of them can take the **ctx_in**/**ctx_out**
>  		  arguments. bpftool does not perform checks on program types.
>  
> +	**bpftool prog profile** *DURATION* *PROG* *METRICs*

If I understand correctly DURATION is optional. Could you please add
square brackets around it? Could you please also specify what it
defaults to if user does not pass the value?

> +		  Profile *METRICs* for bpf program *PROG* for *DURATION*
> +		  seconds.
> +
>  	**bpftool prog help**
>  		  Print short help message.
>  
> @@ -311,6 +319,15 @@ EXAMPLES
>  
>  **# rm /sys/fs/bpf/xdp1**
>  
> +|
> +| **# bpftool prog profile 10 id 337 cycles instructions llc_misses**
> +
> +::
> +         51397 run_cnt
> +      40176203 cycles                                                 (83.05%)
> +      42518139 instructions    #   1.06 insn per cycle                (83.39%)
> +           123 llc_misses      #   2.89 LLC misses per million isns   (83.15%)
> +
>  SEE ALSO
>  ========
>  	**bpf**\ (2),
> 

Could you please also add bash completion for the new subcommand?

Thanks,
Quentin
