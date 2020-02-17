Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DFEE0161B37
	for <lists+netdev@lfdr.de>; Mon, 17 Feb 2020 20:07:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728991AbgBQTHL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Feb 2020 14:07:11 -0500
Received: from mail-qt1-f196.google.com ([209.85.160.196]:44094 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728054AbgBQTHK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Feb 2020 14:07:10 -0500
Received: by mail-qt1-f196.google.com with SMTP id k7so12745200qth.11
        for <netdev@vger.kernel.org>; Mon, 17 Feb 2020 11:07:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Xc/8Y37laiaktHHfmAYSRHTTBTzj7tz0tagnhkkhPrw=;
        b=EMF9R/zwuzbjONBev0Yypuc0IrlPXbw+YxGR7ibmbJIiSir4dIfkuD2wGWOj+bqF48
         vrU9r02xBBZ3+Ccq0f5n9LFLB3H8iCh+ruKS3103RYjXrZTQPopYrLywN6h/prZ0bdjL
         os1DpCv82qaywiKJr30Ht4j5QgUftfO5T9iFgffRa75KHwjzjB7Nmf1ghNuvk/JhUcka
         AKU/vAe3bF0WkjZBMwxDkFKECowYAncf46zy1+CBUOn1qB1Z0wecf5eEi9vQlqWJN+XG
         2FFK1TW501YBJdjkLqhnbeTb4e2mb2IVFQrghgX66zQ22VgRAo3o2agQdnNpmdxkaIB0
         YAiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Xc/8Y37laiaktHHfmAYSRHTTBTzj7tz0tagnhkkhPrw=;
        b=HuIXFZ2loMJVMd5uRQUH3ChywuVN67n2xZA6/QBbAiQ3P0TgXFUCl5H8PDN/hVcsW1
         TZhRsHHoAIerSBAacm2SQb5Ujv66bDCNRmdUtujjE2GqoYjbGs/FaycDOUbj2MVXXlrG
         GlVuOA1NKpBEFGcL2nSYLwdnRDIuZlJXjJcsrpUlQEO6U2iCZ0W6jJozImwDZSPVBA4g
         ArbjOMUyMJYJPTgS8eLkrTzl5nOzrOQqDY2qMpbHxlwWDHGkxJkZL7R6v2M2S5n53aG4
         k2175ADu9W6n4xxq/lx2us3h0kuQFJIAAOFjOBi6g4WQR+GjYDtPP0NGBg4ohO6urzuY
         opwg==
X-Gm-Message-State: APjAAAW9Xp14U3z1f4Qq1rWp3jVdhx3XeAYkBqkKXWTAzMZCC13dZvSP
        g/arhmQz3ToEuUlRoAq6s6ZX0mXR
X-Google-Smtp-Source: APXvYqwtgNdU5l2qWBdYnpapO+BF6xZus/ClOXPaZ1Fq8ep2wYuJSfDdkuAIdeuDLoAzeQavZQIdPg==
X-Received: by 2002:ac8:1952:: with SMTP id g18mr14473920qtk.157.1581966429909;
        Mon, 17 Feb 2020 11:07:09 -0800 (PST)
Received: from ?IPv6:2601:282:803:7700:65d1:a3b2:d15f:79af? ([2601:282:803:7700:65d1:a3b2:d15f:79af])
        by smtp.googlemail.com with ESMTPSA id w2sm620148qto.73.2020.02.17.11.07.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 17 Feb 2020 11:07:09 -0800 (PST)
Subject: Re: [PATCH iproute2] erspan: set erspan_ver to 1 by default
To:     Xin Long <lucien.xin@gmail.com>,
        network dev <netdev@vger.kernel.org>,
        stephen@networkplumber.org
Cc:     William Tu <u9012063@gmail.com>
References: <0abbe3fb8e20741c17fe3a0ecbca9ccd4f8ab96b.1581933223.git.lucien.xin@gmail.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <34272893-fce7-4ad7-8f07-57ae01493b39@gmail.com>
Date:   Mon, 17 Feb 2020 12:07:07 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.4.2
MIME-Version: 1.0
In-Reply-To: <0abbe3fb8e20741c17fe3a0ecbca9ccd4f8ab96b.1581933223.git.lucien.xin@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/17/20 2:53 AM, Xin Long wrote:
> Commit 289763626721 ("erspan: add erspan version II support")
> breaks the command:
> 
>  # ip link add erspan1 type erspan key 1 seq erspan 123 \
>     local 10.1.0.2 remote 10.1.0.1
> 
> as erspan_ver is set to 0 by default, then IFLA_GRE_ERSPAN_INDEX
> won't be set in gre_parse_opt().
> 
>   # ip -d link show erspan1
>     ...
>     erspan remote 10.1.0.1 local 10.1.0.2 ... erspan_index 0 erspan_ver 1
>                                               ^^^^^^^^^^^^^^
> 
> This patch is to change to set erspan_ver to 1 by default.
> 
> Fixes: 289763626721 ("erspan: add erspan version II support")
> Signed-off-by: Xin Long <lucien.xin@gmail.com>
> ---
>  ip/link_gre.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/ip/link_gre.c b/ip/link_gre.c
> index 15beb73..e42f21a 100644
> --- a/ip/link_gre.c
> +++ b/ip/link_gre.c
> @@ -94,7 +94,7 @@ static int gre_parse_opt(struct link_util *lu, int argc, char **argv,
>  	__u8 metadata = 0;
>  	__u32 fwmark = 0;
>  	__u32 erspan_idx = 0;
> -	__u8 erspan_ver = 0;
> +	__u8 erspan_ver = 1;
>  	__u8 erspan_dir = 0;
>  	__u16 erspan_hwid = 0;
>  
> 

that seems correct to me.

What about the v6 version? It defaults to 0 as well by the same Fixes tag.
