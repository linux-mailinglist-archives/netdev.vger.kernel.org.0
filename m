Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F79C2569DD
	for <lists+netdev@lfdr.de>; Sat, 29 Aug 2020 21:28:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728478AbgH2T2T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 29 Aug 2020 15:28:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728335AbgH2T2S (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 29 Aug 2020 15:28:18 -0400
Received: from mail-il1-x141.google.com (mail-il1-x141.google.com [IPv6:2607:f8b0:4864:20::141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6DD85C061236;
        Sat, 29 Aug 2020 12:28:18 -0700 (PDT)
Received: by mail-il1-x141.google.com with SMTP id q14so3440476ilj.8;
        Sat, 29 Aug 2020 12:28:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=MYeksI7pkYccpBPOaIhMC41dpt0mmv/5RTQ5WIGZNNw=;
        b=JqHqtB+ahol9VjbuRNUmo8PczCY8sgJaMxIW2w5uW0FZFrWVqJbNSbyfcNrnKczoNc
         BFZWGIJYI40zcbkOP6QQluJUyb+ib9su0NoBLCskm8XDET82Ofq5RgT/rLN7F14j+yHX
         l0076UHCB2obID6mQyxtsvP4tEyYkoTQ8dRio5IxElDzE7ddU09UDSh0jC4GyvvNx7O8
         iIZuwmeqPHM7RniR9KGhbZApxFpvXDdWavK9nYrq4RKEaWNz4ZaCjqtMMf3aAOoCQG+n
         jxgSf75LOEBStQfKrSiTwHIeYJUre3cHNijVGV7a5LMOHnJMg8N/OelRPOGuCJm4HVP7
         /1eQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=MYeksI7pkYccpBPOaIhMC41dpt0mmv/5RTQ5WIGZNNw=;
        b=uQrCtirJZwFvTyWBzU4svg6jibwYMJrpes2C+QxZJrFd2aaDzYY0WY8b6YitkJhtn2
         6H6p2hW3uTptEiVDWOSQl/0xij+QqvbKNZMpJEsnsMhxubL2+DQkQClW1am7I9RZ+R0n
         T2350V8f+to8/Lnb3nDF3DfxmuvIE1zIZ22jbrD6JuSUgTWicpt9iUleGV1ni+57heW9
         PgYTb6ipHiwVhK7k7qfznq4tnXqTARPwFpRywNCSU025HHp/OUzdKa1YroO7fvn/g43J
         xY5Hs6hIhaH4YbKxQ4+SpInEfURlcvdKwKt4zmLtdRl3FeXDQ8NDeP4pS07ljSo79HP4
         MySg==
X-Gm-Message-State: AOAM531AHXiZwF1xUEH7rMu08WKJ/2G94nn9wgQeXYDgGCBZYOqCN5Ex
        9dfPf9VyaezuvEkchrSHLVlCpf719hfb8w==
X-Google-Smtp-Source: ABdhPJwe2jB+YjrlISBhPE5QSm0vnm09ZxIebTRr2FT0zoGgRWhyDuTVJ++JX7zayrGmnaLwaUEdlg==
X-Received: by 2002:a05:6e02:ca3:: with SMTP id 3mr3574833ilg.8.1598729297698;
        Sat, 29 Aug 2020 12:28:17 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([2601:282:803:7700:21a5:5fc5:213b:a337])
        by smtp.googlemail.com with ESMTPSA id u81sm1822585ilc.52.2020.08.29.12.28.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 29 Aug 2020 12:28:17 -0700 (PDT)
Subject: Re: [PATCH] net: ipv6: remove unused arg exact_dif in compute_score
To:     Miaohe Lin <linmiaohe@huawei.com>, davem@davemloft.net,
        kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org, kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20200829090420.6351-1-linmiaohe@huawei.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <887af39d-2c79-f1a0-4e2c-4315c58ad029@gmail.com>
Date:   Sat, 29 Aug 2020 13:28:16 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <20200829090420.6351-1-linmiaohe@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/29/20 3:04 AM, Miaohe Lin wrote:
> @@ -138,15 +138,13 @@ static struct sock *inet6_lhash2_lookup(struct net *net,
>  		const __be16 sport, const struct in6_addr *daddr,
>  		const unsigned short hnum, const int dif, const int sdif)
>  {
> -	bool exact_dif = inet6_exact_dif_match(net, skb);

inet6_exact_dif_match is no longer needed after the above is removed.
