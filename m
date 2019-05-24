Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0E1812944F
	for <lists+netdev@lfdr.de>; Fri, 24 May 2019 11:14:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389880AbfEXJOQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 May 2019 05:14:16 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:36247 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389425AbfEXJOP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 May 2019 05:14:15 -0400
Received: by mail-wr1-f66.google.com with SMTP id s17so9219223wru.3
        for <netdev@vger.kernel.org>; Fri, 24 May 2019 02:14:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=doGA1FEZ8RteuV0ofOpxFaHOT/fVKBd1QM5RUpYKD7Q=;
        b=RkE8OVJ+SqADZUhxPX2N1o0YwezvkJz/2Vlkn953jE50VUYoqX7dw2BLPA4hr+vlwM
         P+lZLHWIq5qBLrY6YCNQAoGLCiE/OloY5Ee2oU2uQouRtTTHsnzxXyP1uwc3mzylcgSK
         ABby1bmrXfLt0aLgd71HPt2FHCu3M9zxitXydNXEteKtC59ZhnkgFVJxFiEtBH915Mmp
         4RXhzMMZGt/MN2Qz8iaonjs8My8mqBV+TtSMUzlIcybkTGIuLZ2cqhAcodv+xKWCnKmU
         XZzLumtbVsSoMnUel5LCb+rfC0M5jpm2XHY3zjElyLiAXfQyP4r9+tTV3QswKCh8nZoh
         zFLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=doGA1FEZ8RteuV0ofOpxFaHOT/fVKBd1QM5RUpYKD7Q=;
        b=Cuyswa4fenr3vAIwnOuiF/pmbKA3r3QCxBu1fVh1lt2cd+VYu0y1u+WTq5Gz0px5Ib
         02+xpxSAvOKaKmjvpvYdZLiu6eaR+CZi8EWhHCUtc7UlaEtKjsFhW0TY64C5hAh2MTlA
         Nb5Ps/k0WMpzjPmiXtsOZqooBugckaqa3Blq9SyNjWIuTTJ4pu7aqJ5vDj1FwXRub/WJ
         mOPRvuo71LosswreVX+IFR8YASg6QWiF7STmoNqwOChNIpEevtdmMne7ToCtclsX5y6I
         PTVhKhh4ptjJ2zSWHlIZxI035zV3xGl0eRKj1utHKdUuUqrIBT2mAAkEkLIaGcdQhOSG
         klIg==
X-Gm-Message-State: APjAAAX1ClRKT9I0ts+VMo/RCcfyODMCuD9729ci9nZu3rNN30i5/im8
        HzN/49UblhgHt5M40zEE2I3H/g==
X-Google-Smtp-Source: APXvYqx9XQki1kHtv8jdCbXNmtjffa68HRbV0vgJzBvCmK931zzz7KUnWzja0EDupnEADI+ZW2L8sA==
X-Received: by 2002:adf:b456:: with SMTP id v22mr11097937wrd.55.1558689253812;
        Fri, 24 May 2019 02:14:13 -0700 (PDT)
Received: from [192.168.1.2] ([194.53.186.20])
        by smtp.gmail.com with ESMTPSA id t12sm2223223wro.2.2019.05.24.02.14.12
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 24 May 2019 02:14:13 -0700 (PDT)
Subject: Re: [PATCH v2 bpf-next 11/12] bpftool/docs: add description of btf
 dump C option
To:     Andrii Nakryiko <andriin@fb.com>, andrii.nakryiko@gmail.com,
        netdev@vger.kernel.org, bpf@vger.kernel.org, ast@fb.com,
        daniel@iogearbox.net, kernel-team@fb.com
References: <20190523204222.3998365-1-andriin@fb.com>
 <20190523204222.3998365-12-andriin@fb.com>
From:   Quentin Monnet <quentin.monnet@netronome.com>
Message-ID: <062aa21a-f14a-faf7-adf1-cd2e5023fc90@netronome.com>
Date:   Fri, 24 May 2019 10:14:12 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190523204222.3998365-12-andriin@fb.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

2019-05-23 13:42 UTC-0700 ~ Andrii Nakryiko <andriin@fb.com>
> Document optional **c** option for btf dump subcommand.
> 
> Cc: Quentin Monnet <quentin.monnet@netronome.com>
> Signed-off-by: Andrii Nakryiko <andriin@fb.com>
> ---
>  tools/bpf/bpftool/Documentation/bpftool-btf.rst | 7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
> 
> diff --git a/tools/bpf/bpftool/Documentation/bpftool-btf.rst b/tools/bpf/bpftool/Documentation/bpftool-btf.rst
> index 2dbc1413fabd..1aec7dc039e9 100644
> --- a/tools/bpf/bpftool/Documentation/bpftool-btf.rst
> +++ b/tools/bpf/bpftool/Documentation/bpftool-btf.rst
> @@ -19,10 +19,11 @@ SYNOPSIS
>  BTF COMMANDS
>  =============
>  
> -|	**bpftool** **btf dump** *BTF_SRC*
> +|	**bpftool** **btf dump** *BTF_SRC* [**format** *FORMAT*]
>  |	**bpftool** **btf help**
>  |
>  |	*BTF_SRC* := { **id** *BTF_ID* | **prog** *PROG* | **map** *MAP* [{**key** | **value** | **kv** | **all**}] | **file** *FILE* }
> +|       *FORMAT* := { **raw** | **c** }

Nit: This line should use a tab for indent (Do not respin just for that,
though!).

>  |	*MAP* := { **id** *MAP_ID* | **pinned** *FILE* }
>  |	*PROG* := { **id** *PROG_ID* | **pinned** *FILE* | **tag** *PROG_TAG* }
>  
> @@ -49,6 +50,10 @@ DESCRIPTION
>                    .BTF section with well-defined BTF binary format data,
>                    typically produced by clang or pahole.
>  
> +                  **format** option can be used to override default (raw)
> +                  output format. Raw (**raw**) or C-syntax (**c**) output
> +                  formats are supported.
> +

Other files use tabs here as well, but most of the description here
already uses spaces, so ok.

>  	**bpftool btf help**
>  		  Print short help message.
>  
> 

