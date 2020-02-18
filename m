Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9F9D9161F39
	for <lists+netdev@lfdr.de>; Tue, 18 Feb 2020 04:12:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726283AbgBRDLy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Feb 2020 22:11:54 -0500
Received: from mail-qk1-f178.google.com ([209.85.222.178]:40691 "EHLO
        mail-qk1-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726240AbgBRDLy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Feb 2020 22:11:54 -0500
Received: by mail-qk1-f178.google.com with SMTP id b7so18207101qkl.7
        for <netdev@vger.kernel.org>; Mon, 17 Feb 2020 19:11:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=IqI4lHscBVdE+W9wNpAsf6/k27Hnu/Sn8heYJm8ql+o=;
        b=I/N7mQELMF5wrlxbFCYJTXo85Hgk6+5BMIQndBE8ystoUecS5RKNddkYROH1nty8w2
         dlNIN65nVlVe0xfb5aiwN85psDkPV+XKWVAvgpQm/G5X1RVYfIoF12dgd3V9tNfgMZB1
         M4XzMIt3zGdewn+PHuIHADnsFAvzsqQZa5FveHTqSUkh+9CmZGQD/YdHUpNGEJf1oeEH
         AEcZVLZNQjkP/Uzq6PTMZSz915NbGRL47qz0YyI8xfoLDjjHxlCj1rCRP7n+yCIXWuyK
         LZhi42sY6wULum7ur4qhrVzdcnN0sklMks5Q3SPbAjIUUAP4SnoGpHHEY3LHFjgLhvO+
         HOCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=IqI4lHscBVdE+W9wNpAsf6/k27Hnu/Sn8heYJm8ql+o=;
        b=Tdcr+sA8AWHZoZ7w9pM4V/5yaUuFF0P52fnqb79yrIY9QdxTdqX+nlajVKFojbWl1X
         M9l3r/uklZMxKAI2EAtrX8ZXbQNSA8CXXkvrQBJz81o3Phh41HOy4q0nRYQynxzPwuty
         qzbeuyhmLh/r4UjfhIMBHq8oO/ZHIUO73BAQnvv7glrjgNGeOjWdzzU2MImZBLwBKt3B
         gYPwbMSXKzrso3oxnY13q513cDbeWJEOiecZdFZJYveh1aNgnf6bvkqOvAOE0buD5t5a
         3N9FV4M3emxaYxQ+Ebme7p/bpCfWtLStCvwU605SYbwOgRtMmvaOqozn+ZODpXtvheMF
         6/LA==
X-Gm-Message-State: APjAAAVAq2Odrum4bowubIYRyXZg8EaO2ywAXUPWWru7ij6D7uz2dHQd
        ixK3R9IayYCKD951rvnF/Z8=
X-Google-Smtp-Source: APXvYqyzUTytSnk2bQu1H3fHf+Ym41OdfTixAI/3kCpyL1aiE74EpuQn5Q3rWu13KLbXKGtzMgybgA==
X-Received: by 2002:a37:ac17:: with SMTP id e23mr16972515qkm.80.1581995513031;
        Mon, 17 Feb 2020 19:11:53 -0800 (PST)
Received: from ?IPv6:2601:282:803:7700:5af:31c:27bd:ccb5? ([2601:282:803:7700:5af:31c:27bd:ccb5])
        by smtp.googlemail.com with ESMTPSA id x197sm1277537qkb.28.2020.02.17.19.11.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 17 Feb 2020 19:11:52 -0800 (PST)
Subject: Re: [PATCHv2 iproute2] erspan: set erspan_ver to 1 by default
To:     Xin Long <lucien.xin@gmail.com>,
        network dev <netdev@vger.kernel.org>,
        stephen@networkplumber.org
Cc:     William Tu <u9012063@gmail.com>
References: <0abbe3fb8e20741c17fe3a0ecbca9ccd4f8ab96b.1581994848.git.lucien.xin@gmail.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <35147ca5-3abf-c441-54be-faf08271fd7c@gmail.com>
Date:   Mon, 17 Feb 2020 20:11:51 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.4.2
MIME-Version: 1.0
In-Reply-To: <0abbe3fb8e20741c17fe3a0ecbca9ccd4f8ab96b.1581994848.git.lucien.xin@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/17/20 8:00 PM, Xin Long wrote:
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

re-send of v1? lacks the v6 change too.
