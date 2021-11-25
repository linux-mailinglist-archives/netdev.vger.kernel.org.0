Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B7DF45E33C
	for <lists+netdev@lfdr.de>; Fri, 26 Nov 2021 00:15:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238104AbhKYXSO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Nov 2021 18:18:14 -0500
Received: from www62.your-server.de ([213.133.104.62]:58356 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235289AbhKYXQK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Nov 2021 18:16:10 -0500
Received: from sslproxy01.your-server.de ([78.46.139.224])
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1mqNvA-000D4z-L2; Fri, 26 Nov 2021 00:12:52 +0100
Received: from [85.1.206.226] (helo=linux.home)
        by sslproxy01.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1mqNvA-000Opl-A3; Fri, 26 Nov 2021 00:12:52 +0100
Subject: Re: [PATCH] libbpf: remove unneeded conversion to bool
To:     davidcomponentone@gmail.com, ast@kernel.org,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org, Yang Guang <yang.guang5@zte.com.cn>,
        Zeal Robot <zealci@zte.com.cn>
References: <b7449bd983892bb5a7a76493daa41410ff19bb7d.1637736798.git.yang.guang5@zte.com.cn>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <3b1080c7-c7af-af8c-a7d0-34f7e5ff8e51@iogearbox.net>
Date:   Fri, 26 Nov 2021 00:12:51 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <b7449bd983892bb5a7a76493daa41410ff19bb7d.1637736798.git.yang.guang5@zte.com.cn>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.3/26364/Thu Nov 25 10:20:31 2021)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/25/21 1:54 AM, davidcomponentone@gmail.com wrote:
> From: Yang Guang <yang.guang5@zte.com.cn>
> 
> The coccinelle report
> ./tools/lib/bpf/libbpf.c:1644:43-48:
> WARNING: conversion to bool not needed here
> Relational and logical operators evaluate to bool,
> explicit conversion is overly verbose and unneeded.
> 
> Reported-by: Zeal Robot <zealci@zte.com.cn>
> Signed-off-by: Yang Guang <yang.guang5@zte.com.cn>

Nak, dup of: https://lore.kernel.org/bpf/CAEf4BzaADXguVoh0KXxGYhzG68eA1bqfKH1T1SWyPvkE5BHa5g@mail.gmail.com/

> ---
>   tools/lib/bpf/libbpf.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
> index 14a89dc99937..33eb365a0b7f 100644
> --- a/tools/lib/bpf/libbpf.c
> +++ b/tools/lib/bpf/libbpf.c
> @@ -1641,7 +1641,7 @@ static int set_kcfg_value_tri(struct extern_desc *ext, void *ext_val,
>   				ext->name, value);
>   			return -EINVAL;
>   		}
> -		*(bool *)ext_val = value == 'y' ? true : false;
> +		*(bool *)ext_val = value == 'y';
>   		break;
>   	case KCFG_TRISTATE:
>   		if (value == 'y')
> 

