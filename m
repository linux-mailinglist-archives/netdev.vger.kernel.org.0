Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CD87670857
	for <lists+netdev@lfdr.de>; Mon, 22 Jul 2019 20:22:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731490AbfGVSVo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Jul 2019 14:21:44 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:38247 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726907AbfGVSVn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Jul 2019 14:21:43 -0400
Received: by mail-pf1-f196.google.com with SMTP id y15so17773433pfn.5
        for <netdev@vger.kernel.org>; Mon, 22 Jul 2019 11:21:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=4lLoLGx2NAdGQHIXBm/Mpz3LZx5lcu8xL5l7rMjyPd8=;
        b=n6eN2XrDXgSOtWns6Mg3aWw2I2iq107RAP0EkwTTUYy6afhhlEaqll4wixXI4U+icF
         2otsoJiLtZ9ocQorX/HPtX1EZitzoo3EuTuaPtzE9yG8P8RLkd2yVJezjCGCd4sWrAdh
         PW8F0m81qBykgmtu+d+j9qpMwhBAeAB6ZBBVIJclBJZ3xbyB6PPPhEU+fLe2uSMhPBaO
         2Es/NuPapWjCZqwL2SIeoI4O3CWDHDDz99RRU9RYy8Y5MoIhYJTPDWSnkImmdMjCn0Xx
         5Tpnz0OMneseZvI9ShhuZYDZ5uFJVF1t3HaWCmtDmlE8ovMR8mx0txmsQGGnNHUQBXqj
         XF4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=4lLoLGx2NAdGQHIXBm/Mpz3LZx5lcu8xL5l7rMjyPd8=;
        b=Bd5YwfpVkGX6k018LX706gxXDgiDYCO+JvsDk+czKYt+gdsWarGEcSlhZqO3+fWxJu
         wXm2QrNaLXVs/Tr9SzR4qNgT5LsZjEJkx6BkYKoYd7KHvWbPB18X1QAK06WIxWOFOMli
         e/VPDGCSWwBcOoKyqgekToeAsiBiFzz4oI/ZQjIKRFKtQdQcmukGiEX02AiGdevbokCo
         MJEX1tou0z5ClRRWPxqH/RBmIEsXsHnM9Gnm2AWa/d51Uo5ak1+Ffk1AVl+ZhN5uBhr+
         gTc9wxAU6+gxZfU9uDeF6Fke+r2DYEFDxiUwhjWkICMjhfpTek2BMq55fKze3mtp+lHh
         n74g==
X-Gm-Message-State: APjAAAUZZ0M3jiO6BgQpVM7lkE5zsACplU5eIKEEDhb7K0kzXrpBbpvB
        0f4q+qop306pqAEYzZrkdmOrwaxdHNU=
X-Google-Smtp-Source: APXvYqyn33vErbYZnpX9CrhGuVjdkPjbJMFfAFeQ59jviogwTACawWMnM5ftQbXzQKiFbq7l9VBBTw==
X-Received: by 2002:a63:ea50:: with SMTP id l16mr73850399pgk.160.1563819703252;
        Mon, 22 Jul 2019 11:21:43 -0700 (PDT)
Received: from [172.27.227.205] ([216.129.126.118])
        by smtp.googlemail.com with ESMTPSA id s11sm12201379pgc.78.2019.07.22.11.21.40
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 22 Jul 2019 11:21:42 -0700 (PDT)
Subject: Re: [PATCH iproute2] etf: make printing of variable JSON friendly
To:     Vedang Patel <vedang.patel@intel.com>, netdev@vger.kernel.org
Cc:     jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        stephen@networkplumber.org, vinicius.gomes@intel.com,
        leandro.maciel.dorileo@intel.com
References: <1563572443-10879-1-git-send-email-vedang.patel@intel.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <a7c60706-562a-429d-400f-af2ad1606ba3@gmail.com>
Date:   Mon, 22 Jul 2019 12:21:39 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:52.0)
 Gecko/20100101 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <1563572443-10879-1-git-send-email-vedang.patel@intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/19/19 3:40 PM, Vedang Patel wrote:
> In iproute2 txtime-assist series, it was pointed out that print_bool()
> should be used to print binary values. This is to make it JSON friendly.
> 
> So, make the corresponding changes in ETF.
> 
> Fixes: 8ccd49383cdc ("etf: Add skip_sock_check")
> Reported-by: Stephen Hemminger <stephen@networkplumber.org>
> Signed-off-by: Vedang Patel <vedang.patel@intel.com>
> ---
>  tc/q_etf.c | 12 ++++++------
>  1 file changed, 6 insertions(+), 6 deletions(-)
> 
> diff --git a/tc/q_etf.c b/tc/q_etf.c
> index c2090589bc64..307c50eed48b 100644
> --- a/tc/q_etf.c
> +++ b/tc/q_etf.c
> @@ -176,12 +176,12 @@ static int etf_print_opt(struct qdisc_util *qu, FILE *f, struct rtattr *opt)
>  		     get_clock_name(qopt->clockid));
>  
>  	print_uint(PRINT_ANY, "delta", "delta %d ", qopt->delta);
> -	print_string(PRINT_ANY, "offload", "offload %s ",
> -				(qopt->flags & TC_ETF_OFFLOAD_ON) ? "on" : "off");
> -	print_string(PRINT_ANY, "deadline_mode", "deadline_mode %s ",
> -				(qopt->flags & TC_ETF_DEADLINE_MODE_ON) ? "on" : "off");
> -	print_string(PRINT_ANY, "skip_sock_check", "skip_sock_check %s",
> -				(qopt->flags & TC_ETF_SKIP_SOCK_CHECK) ? "on" : "off");
> +	if (qopt->flags & TC_ETF_OFFLOAD_ON)
> +		print_bool(PRINT_ANY, "offload", "offload ", true);
> +	if (qopt->flags & TC_ETF_DEADLINE_MODE_ON)
> +		print_bool(PRINT_ANY, "deadline_mode", "deadline_mode ", true);
> +	if (qopt->flags & TC_ETF_SKIP_SOCK_CHECK)
> +		print_bool(PRINT_ANY, "skip_sock_check", "skip_sock_check", true);
>  
>  	return 0;
>  }
> 

This changes existing output for TC_ETF_OFFLOAD_ON and
TC_ETF_DEADLINE_MODE_ON which were added a year ago.
