Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 67FE6167C1C
	for <lists+netdev@lfdr.de>; Fri, 21 Feb 2020 12:29:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728137AbgBUL3f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Feb 2020 06:29:35 -0500
Received: from mail-wr1-f65.google.com ([209.85.221.65]:42214 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726989AbgBUL3e (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Feb 2020 06:29:34 -0500
Received: by mail-wr1-f65.google.com with SMTP id k11so1623472wrd.9
        for <netdev@vger.kernel.org>; Fri, 21 Feb 2020 03:29:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isovalent-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=ISb1ahsdqyDpNndMm9k4MryKRAmuNFLa5XvM/5lEHrM=;
        b=dpFq32bbS0i4OObcZqRN90dmE8bmajzsSxDy61W8dRwMlROs5qvrRFewu5bvvNGQwH
         evC7XBjXob68qVSuMV/FMf4yN3XuF28WTjpUOFuriHFkV7abah/OQ4jbUb9sPFzDwGYB
         yU7wKUd9dWBI7g+Mq4OI88Hj3IWl+IpYk2PP1N4JGVytif996cxOMj8SU4B7cTewf8aZ
         AXYvPiHn3UbgKBkRwxBXF2pqjJfMpUxF0nTh5UwWjwZuE2gzSKEcWpawwR/7TcZ68FYs
         a1FngtGWi1XoJwbhc1fz2QPf8MHto/MwLRz6drRhsvH+kkCAaYBglHURSEsCVdyJ1RSy
         nH2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ISb1ahsdqyDpNndMm9k4MryKRAmuNFLa5XvM/5lEHrM=;
        b=HAcR1sO29E7HZXYUOXWPUEGrj7EyhUPKftTRGuFDBSzN9F46aiXEUAeC3TZg29qTWJ
         PTv8CqqegJpDPN0sjghQoaULVJFXUzs8WNGYIEWuroIFWe+gQKkNY2efNSIRzHUIa4+K
         PALuMFiQrJ4kLW9STuuhDN5nEINBAtZ9E9AnPTKtUp9Pp42VcnhdTKOkgpiF2lNoXkn+
         SIH9WPxa2vv2eSXDq0FvycoX6gh3d8w3OWN08mDcAzTfHcRx6kJdZ4ruHxix2AdDFSE4
         e/WakT5pGm5S9RyyS4fSsNc0Nincu2eemXPNarCQrT9JygtoLKAaf4ilv9wSx41aOpcy
         4XjA==
X-Gm-Message-State: APjAAAWvKU0yIpfR8LiFHaeiqcbc40l/euluTGrG/1mbpAUnVUip5bdJ
        44rV7z4ZXnTryjiuZldSq9hDBQ==
X-Google-Smtp-Source: APXvYqwo/wcsiFTfCaz7K7GiNYnP+aK8Ly6FiMLPGG1YRCamaaEnYkndZlGCFD7DwIS5uBFCL1v9wg==
X-Received: by 2002:a05:6000:10c:: with SMTP id o12mr49019570wrx.106.1582284571520;
        Fri, 21 Feb 2020 03:29:31 -0800 (PST)
Received: from [192.168.1.23] ([91.143.66.155])
        by smtp.gmail.com with ESMTPSA id b13sm3838699wrq.48.2020.02.21.03.29.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 21 Feb 2020 03:29:31 -0800 (PST)
Subject: Re: [PATCH bpf-next v2 4/5] bpftool: Update bash completion for
 "bpftool feature" command
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
 <20200221031702.25292-5-mrostecki@opensuse.org>
From:   Quentin Monnet <quentin@isovalent.com>
Message-ID: <7e37246c-a154-1cd6-fbae-ed29497903e8@isovalent.com>
Date:   Fri, 21 Feb 2020 11:29:30 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200221031702.25292-5-mrostecki@opensuse.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

2020-02-21 04:16 UTC+0100 ~ Michal Rostecki <mrostecki@opensuse.org>
> Update bash completion for "bpftool feature" command with the new
> argument: "full".
> 
> Signed-off-by: Michal Rostecki <mrostecki@opensuse.org>
> ---
>   tools/bpf/bpftool/bash-completion/bpftool | 27 ++++++++++++++++-------
>   1 file changed, 19 insertions(+), 8 deletions(-)
> 
> diff --git a/tools/bpf/bpftool/bash-completion/bpftool b/tools/bpf/bpftool/bash-completion/bpftool
> index 754d8395e451..f2bcc4bacee2 100644
> --- a/tools/bpf/bpftool/bash-completion/bpftool
> +++ b/tools/bpf/bpftool/bash-completion/bpftool
> @@ -981,14 +981,25 @@ _bpftool()
>           feature)
>               case $command in
>                   probe)
> -                    [[ $prev == "prefix" ]] && return 0
> -                    if _bpftool_search_list 'macros'; then
> -                        COMPREPLY+=( $( compgen -W 'prefix' -- "$cur" ) )
> -                    else
> -                        COMPREPLY+=( $( compgen -W 'macros' -- "$cur" ) )
> -                    fi
> -                    _bpftool_one_of_list 'kernel dev'
> -                    return 0
> +                    case $prev in
> +                        $command)
> +                            COMPREPLY+=( $( compgen -W 'kernel dev full macros' -- \
> +                                "$cur" ) )
> +                            return 0
> +                            ;;
> +                        prefix)
> +                            return 0
> +                            ;;
> +                        macros)
> +                            COMPREPLY+=( $( compgen -W 'prefix' -- "$cur" ) )
> +                            return 0

I have not tested, but I think because of the "return 0" this will 
propose only "prefix" after "macros". But "kernel" or "dev" should also 
be in the list.

Maybe just add "_bpftool_once_attr 'full'" under the 
"_bpftool_one_of_list 'kernel dev'" instead of changing to the "case 
$prev in" structure?

> +                            ;;
> +                        *)
> +                            _bpftool_one_of_list 'kernel dev'
> +                            _bpftool_once_attr 'full macros'
> +                            return 0
> +                            ;;
> +                    esac
>                       ;;
>                   *)
>                       [[ $prev == $object ]] && \
> 

