Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4D5AEE8F0D
	for <lists+netdev@lfdr.de>; Tue, 29 Oct 2019 19:11:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731015AbfJ2SLj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Oct 2019 14:11:39 -0400
Received: from mail-pl1-f195.google.com ([209.85.214.195]:44773 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731001AbfJ2SLj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Oct 2019 14:11:39 -0400
Received: by mail-pl1-f195.google.com with SMTP id q16so7779249pll.11
        for <netdev@vger.kernel.org>; Tue, 29 Oct 2019 11:11:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=jbQ7pz86X1iiboU3cdGxpqzWGnWZ4lFtYHMWEz+Utcw=;
        b=dlWPnhkiE+Nk+EdfiHUfS8zOLmB1WoYJND5gSLHr/n58Q0naCTHfu9tUEFdQySLRh5
         ZGLTtmbT6LCS0gQIx8VjaybiKhSYzCqTU75eDO2U0haCK9exIzARJ7gghhl1hxN3QkQI
         IU6IZUQu5UIE/5y9ixaQsM3r0AwvpOVgThMt4gSR3kXw3hpRfDjasmbJZNGL3Xq16cmE
         LVJm/veQk122crdLtbN5du2yxT33pPQAodQRYPXAUCin9C8Hxu4sx9LfJJTWW33XDW0K
         O8fUl+252aRySjBASCl8Diq2R0OtTz9FcCnpZRrUez/ofwA3Qk1tJGG/PMYoII5r7jl0
         Lohg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=jbQ7pz86X1iiboU3cdGxpqzWGnWZ4lFtYHMWEz+Utcw=;
        b=YfrxX3aSCgKC8TgJK9L/6VCJ4ItuLPQGAxaPNFZhpDdACefxrOaW5DuVEvbAKOrVE9
         UD4DvRQa93CoJ8kG3ZfT+WvC+X6wYcDULePEVnibFJ7yQJxTV5ysv40lAmoDss5ZJXv8
         f1O0NqOy7t8+z5vMR5s/M0hWfFZYEJ3aQGzMwaJdSQlJz5BS7Ta3MtdCl6MB7i1OiH9J
         8galrLm7WSjeU3/4Ia+Lp2PcHTkPErJlqciu3+tH+yboBP11P201aQLXboINFOW05A7L
         8noNPyvZGkCrlBtqyDBAC6jXaVbGgWbbr0ycEILK+Q6/oj0klX2Uv3Cg9pB/Kqu5Uoqs
         YbWA==
X-Gm-Message-State: APjAAAU5wYYogmYLmXt8v3y66tTH8Td15ZQnjhDtbfW/P0Ydu8U1wi2z
        AnB1k3AvbmPE2PDFeWVAX9WVaDYi
X-Google-Smtp-Source: APXvYqwduDOI6TASiTy5s/9Tj5EPzV0vzFQTzdyhET6cl+d5glekXlwsRV/v8GqVHIUuVGj2rrrvrQ==
X-Received: by 2002:a17:902:5a06:: with SMTP id q6mr5508680pli.246.1572372698461;
        Tue, 29 Oct 2019 11:11:38 -0700 (PDT)
Received: from dahern-DO-MB.local ([2601:282:800:fd80:850c:8c04:b28e:fe4])
        by smtp.googlemail.com with ESMTPSA id j126sm15953886pfb.186.2019.10.29.11.11.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 29 Oct 2019 11:11:37 -0700 (PDT)
Subject: Re: [PATCH net] net: rtnetlink: fix a typo fbd -> fdb
To:     Nikolay Aleksandrov <nikolay@cumulusnetworks.com>,
        netdev@vger.kernel.org
Cc:     davem@davemloft.net
References: <20191029115932.399-1-nikolay@cumulusnetworks.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <6b4e8885-6aba-ebad-e687-1ebbb0acffa9@gmail.com>
Date:   Tue, 29 Oct 2019 12:11:36 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <20191029115932.399-1-nikolay@cumulusnetworks.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/29/19 5:59 AM, Nikolay Aleksandrov wrote:
> A simple typo fix in the nl error message (fbd -> fdb).
> 
> CC: David Ahern <dsahern@gmail.com>
> Fixes: 8c6e137fbc7f ("rtnetlink: Update rtnl_fdb_dump for strict data checking")
> Signed-off-by: Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
> ---
>  net/core/rtnetlink.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
> index 1ee6460f8275..05bdf5908472 100644
> --- a/net/core/rtnetlink.c
> +++ b/net/core/rtnetlink.c
> @@ -3916,7 +3916,7 @@ static int valid_fdb_dump_strict(const struct nlmsghdr *nlh,
>  	ndm = nlmsg_data(nlh);
>  	if (ndm->ndm_pad1  || ndm->ndm_pad2  || ndm->ndm_state ||
>  	    ndm->ndm_flags || ndm->ndm_type) {
> -		NL_SET_ERR_MSG(extack, "Invalid values in header for fbd dump request");
> +		NL_SET_ERR_MSG(extack, "Invalid values in header for fdb dump request");
>  		return -EINVAL;
>  	}
>  
> 

thanks, Nik.

Reviewed-by: David Ahern <dsahern@gmail.com>
