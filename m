Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 38C66167C03
	for <lists+netdev@lfdr.de>; Fri, 21 Feb 2020 12:28:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727794AbgBUL20 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Feb 2020 06:28:26 -0500
Received: from mail-wr1-f66.google.com ([209.85.221.66]:41367 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727576AbgBUL2Z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Feb 2020 06:28:25 -0500
Received: by mail-wr1-f66.google.com with SMTP id c9so1620722wrw.8
        for <netdev@vger.kernel.org>; Fri, 21 Feb 2020 03:28:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isovalent-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=MmlIuWAhG574pRgwa2zTd9boc50vLeKyqoHfRi2itEU=;
        b=YKUQdaBbggWW6llIQTJxlrtrnqsyXplrQDdDUNJHbpsAcIB2ml073JtDPuknhQ25To
         X0b0jh80UPZ/YXbi4B9Z6xzv5bBYVs7tD7nmc21q7a3Qx4I7xvpCaImxvIJTVXVRUpAq
         MVS+AHVq75/Ph0hOQn/jL6c1nIqYtCerq5Vsa+etZY0Dz5ALh1MjY4u90FvIyG95n4xv
         uPD+hTWmiMAdgIOgGxjRP7fLYcHQ5IbxY+zYZkYRrAm1+4cYzHKA9ZPodJthRM5Am/H2
         T8HXJVqxfhVAU4kPyU1/hCmw5fFW2vHAG5vhUoG1QNoHN6meJjBBPC8c0DJXPQNDzwrj
         uiNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=MmlIuWAhG574pRgwa2zTd9boc50vLeKyqoHfRi2itEU=;
        b=ZG9frRRHiEyoojSILQsTm1VF2oWCmywaIRdiEP7szSWesgu96HDf0xDHAZFESGBc87
         Qh4OTGwZJB5/YwRPitN2xAkcCobZ3AHvpKV2VMkO+cPTlIM2T7oKxFoq5fn1id+ErjMt
         viBaxDGikpg2Pm7bejoX9uynryq9Ovo6MPQCZfSeX268FRYHwsTDoBHp10rgWpweGiIE
         2DX2/3RIvRMRkT+1njoX6nLktdI3XHKtFwExpplFN9IdXIkDsTNF/AuqTnkDydZyaeHK
         f6Oc8juKLFi8N3cbp2FKykwE8mm1XRg9FKLAJwdFfR1w7gjiRhKkYaomk/33BIuiumjU
         HIUg==
X-Gm-Message-State: APjAAAUdri8eAMXDjS7GxoOVDN+jMwYGrVPhxR8FvCHKYH5gowtlWCwb
        riZDeZk2U/n8Ne5SyNRyRGiESQ==
X-Google-Smtp-Source: APXvYqxlRq13BDDwBEWuDJjB0z/6G0z+UyZMu7ABeU3PZHVzjkvsXbK8jMbIsdAUZkjltC03HpdAbw==
X-Received: by 2002:a05:6000:1206:: with SMTP id e6mr21158926wrx.410.1582284502523;
        Fri, 21 Feb 2020 03:28:22 -0800 (PST)
Received: from [192.168.1.23] ([91.143.66.155])
        by smtp.gmail.com with ESMTPSA id a13sm3591825wrp.93.2020.02.21.03.28.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 21 Feb 2020 03:28:22 -0800 (PST)
Subject: Re: [PATCH bpf-next v2 3/5] bpftool: Update documentation of "bpftool
 feature" command
To:     Michal Rostecki <mrostecki@opensuse.org>, bpf@vger.kernel.org
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Shuah Khan <shuah@kernel.org>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>
References: <20200221031702.25292-1-mrostecki@opensuse.org>
 <20200221031702.25292-4-mrostecki@opensuse.org>
From:   Quentin Monnet <quentin@isovalent.com>
Message-ID: <85e7fcf3-0ad3-28e3-ef6f-a19669fd6c7f@isovalent.com>
Date:   Fri, 21 Feb 2020 11:28:21 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200221031702.25292-4-mrostecki@opensuse.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

2020-02-21 04:16 UTC+0100 ~ Michal Rostecki <mrostecki@opensuse.org>
> Update documentation of "bpftool feature" command with information about
> new arguments: "full".
> 
> Signed-off-by: Michal Rostecki <mrostecki@opensuse.org>
> ---
>   .../bpf/bpftool/Documentation/bpftool-feature.rst | 15 ++++++++++-----
>   1 file changed, 10 insertions(+), 5 deletions(-)
> 
> diff --git a/tools/bpf/bpftool/Documentation/bpftool-feature.rst b/tools/bpf/bpftool/Documentation/bpftool-feature.rst
> index 4d08f35034a2..2e8f66ee1e77 100644
> --- a/tools/bpf/bpftool/Documentation/bpftool-feature.rst
> +++ b/tools/bpf/bpftool/Documentation/bpftool-feature.rst
> @@ -19,19 +19,24 @@ SYNOPSIS
>   FEATURE COMMANDS
>   ================
>   
> -|	**bpftool** **feature probe** [*COMPONENT*] [**macros** [**prefix** *PREFIX*]]
> +|	**bpftool** **feature probe** [*COMPONENT*] [**full**] [**macros** [**prefix** *PREFIX*]]
>   |	**bpftool** **feature help**
>   |
>   |	*COMPONENT* := { **kernel** | **dev** *NAME* }
>   
>   DESCRIPTION
>   ===========
> -	**bpftool feature probe** [**kernel**] [**macros** [**prefix** *PREFIX*]]
> +	**bpftool feature probe** [**kernel**] [**full**] [**macros** [**prefix** *PREFIX*]]
>   		  Probe the running kernel and dump a number of eBPF-related
>   		  parameters, such as availability of the **bpf()** system call,
>   		  JIT status, eBPF program types availability, eBPF helper
>   		  functions availability, and more.
>   
> +		  By default, bpftool does not run probes for
> +		  bpf_probe_write_user and bpf_trace_printk helpers which emit

Please use formatting on helper function names, for readability and 
consistency.

I would even be tempted to highlight part or all of the sentence, with 
caps or bold, as some users may be surprised not to see those helpers in 
the list of available helpers on their system.

> +		  dmesg warnings. To enable them and run all probes, the
> +		  **full** keyword should be used.
> +
>   		  If the **macros** keyword (but not the **-j** option) is
>   		  passed, a subset of the output is dumped as a list of
>   		  **#define** macros that are ready to be included in a C
> @@ -48,12 +53,12 @@ DESCRIPTION
>   		  **bpf_trace_printk**\ () or **bpf_probe_write_user**\ ()) may
>   		  print warnings to kernel logs.

This should maybe be moved upwards and combined with your new paragraph?

>   
> -	**bpftool feature probe dev** *NAME* [**macros** [**prefix** *PREFIX*]]
> +	**bpftool feature probe dev** *NAME* [**full**] [**macros** [**prefix** *PREFIX*]]
>   		  Probe network device for supported eBPF features and dump
>   		  results to the console.
>   
> -		  The two keywords **macros** and **prefix** have the same
> -		  role as when probing the kernel.
> +		  The keywords **full**, **macros** and **prefix** have the
> +		  same role as when probing the kernel.
>   
>   	**bpftool feature help**
>   		  Print short help message.
> 

