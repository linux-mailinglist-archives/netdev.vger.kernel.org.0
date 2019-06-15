Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BCE6F46D4D
	for <lists+netdev@lfdr.de>; Sat, 15 Jun 2019 02:49:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725942AbfFOAtx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Jun 2019 20:49:53 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:38983 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725809AbfFOAtx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Jun 2019 20:49:53 -0400
Received: by mail-pg1-f196.google.com with SMTP id 196so2439823pgc.6
        for <netdev@vger.kernel.org>; Fri, 14 Jun 2019 17:49:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Gx0W3TBKW2RMEHnT4nHfHFMIsk+81piF1Pzz6rYPlgA=;
        b=Mf05CBy+FeLlQUE3hHjwhB9hFqB+EznYiG6iENsMRGtvnjsGoYmoIUvxDtsgo35csF
         nt9pYQDAMfaXFR6jMdBjHgftGPrY4t7LGo9fb4gdV/AWhZgfEkqc3c69saprZ+XxVyLu
         oNBbUeodU+SEocIjBw5nXJTuApINwFLrG7OKhfjPHjF7tVKpCKSlHab5ckC1Zbma6nyB
         4DDZSmGo0+AhungvHr1UTL6oBBHE2NsOqNg9tz3YlOaUvq3uYEPzmYb1fMF0fRNswqRS
         KVYU3fwnl6gbAsGqD48vaIAZeGq0YspfzeCHi3liQ6Zdz8QVx4ezokGg+5yBv6x0k3cv
         5ucA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Gx0W3TBKW2RMEHnT4nHfHFMIsk+81piF1Pzz6rYPlgA=;
        b=sNSf2ajdK6SGR86Ee2JMJvJjRH8ocByqAJAD/77czAWJqBdddlolKPR6l48pog7jnR
         lVXpdfcUzERrGRbxojEzVlGonafDjnMLGp3onBWNEc7hkoD9au4plxYXgtaZVD18Aqz3
         CAQdO9B5g8rylp9nr1S5FSh0RitZNp0LzxVflyUb0P53GdC0ozwwhzL4TbTh6S0Apagm
         j6cNAybF/j767rCALDxq9vkONpyvm6CGXqdReB+vrVGXo80JovjoowZDZdV29Ki3KoUB
         fFiPqcZWni/aDvYLUWnZBRg2oM9QIiiiLRuuMadLVwYF7ZILXW4j1ZfgTpU3JhAleg76
         3LZg==
X-Gm-Message-State: APjAAAXjnjbCFJ8/pT7QDOCXTndBSoqLMR7p1bUSsgOLASh9dbJF70sY
        K6NZP1gg8Xxp9AJnjusiF1o=
X-Google-Smtp-Source: APXvYqx/bKaibmqcP7O4bUE9m+oM8qnmfSSjsdkTcGwk7RUN/EhAVj9xn4GJxyU/0AlQJ18x4/9Kgw==
X-Received: by 2002:a63:4509:: with SMTP id s9mr37592145pga.231.1560559793011;
        Fri, 14 Jun 2019 17:49:53 -0700 (PDT)
Received: from [172.27.227.153] ([216.129.126.118])
        by smtp.googlemail.com with ESMTPSA id z14sm4178082pgs.79.2019.06.14.17.49.51
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 14 Jun 2019 17:49:52 -0700 (PDT)
Subject: Re: [PATCH net next 1/2] udp: Remove unused parameter (exact_dif)
To:     Tim Beale <timbeale@catalyst.net.nz>, netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org
References: <1560487287-198694-1-git-send-email-timbeale@catalyst.net.nz>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <2be08d22-875a-7c8c-9b8b-69b4c5365515@gmail.com>
Date:   Fri, 14 Jun 2019 18:49:50 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:52.0)
 Gecko/20100101 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <1560487287-198694-1-git-send-email-timbeale@catalyst.net.nz>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/13/19 10:41 PM, Tim Beale wrote:
> Originally this was used by the VRF logic in compute_score(), but that
> was later replaced by udp_sk_bound_dev_eq() and the parameter became
> unused.
> 
> Note this change adds an 'unused variable' compiler warning that will be
> removed in the next patch (I've split the removal in two to make review
> slightly easier).
> 
> Signed-off-by: Tim Beale <timbeale@catalyst.net.nz>
> ---
>  net/ipv4/udp.c | 10 +++++-----
>  net/ipv6/udp.c | 13 ++++++-------
>  2 files changed, 11 insertions(+), 12 deletions(-)
> 

Reviewed-by: David Ahern <dsahern@gmail.com>


