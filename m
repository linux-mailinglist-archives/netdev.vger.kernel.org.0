Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 135A83176C
	for <lists+netdev@lfdr.de>; Sat,  1 Jun 2019 01:06:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726798AbfEaXGU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 May 2019 19:06:20 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:43526 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726450AbfEaXGU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 May 2019 19:06:20 -0400
Received: by mail-pf1-f196.google.com with SMTP id c6so7047265pfa.10
        for <netdev@vger.kernel.org>; Fri, 31 May 2019 16:06:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=LhMyW6roH1+ZlH0tbUdU2TUBe388AYVLW0Cl+6EuvAM=;
        b=HBjYc3CBix0G6BLM4kDJHsY6Thy7pBbS5CSWK6VrWY+XMswqJXWYgRfJQZd62vKt+3
         oJgbagz35j9l9QJVe/gFbMTrZc2ZCiU2WQDIvHGew1Z+Lk44Ww7GTQerF/9Njujg6C6d
         rWfYNuwpHwSowbrV1+qelZdjOqQ8AlnLjYkFMVGFW+sTsNX4rdtwlogkVOnh4hy/rahd
         aB1viuPtDrrraDYTIB2fVx1TUaf+S+xDGZhK+QnjMK9Z+1LX4eY/ypKHAesX574uhELq
         d+Wobf7PGtWFxAXfPVc/Onvgmj0TF/xkOVfy9Z2m9jn4Kc7icPav/DrcVKKR/AA7sgDM
         Xrkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=LhMyW6roH1+ZlH0tbUdU2TUBe388AYVLW0Cl+6EuvAM=;
        b=pxQIrq2zfdXYn5AuwqQBzzEGynyJtYX5/Z+jjJkWGG7vYLyv0RS0/oTZluS25sIeal
         wa/q+KojM9eXSm4ahkAD9gsFBxqLLQ1e6cm94AAt/V8iTZGShfsFIF4MLEe6r5EAUpYF
         /UCn43JukTNYKum+luqur49O7ZUwS6QQKTFkUfpe5w6NX2EE+pajwA//JdszPsLXbPzy
         rtHfv5spoDAyYr78So2y25OWVkgLm0yly9H/C1Ba2CyNGHZZ9ijt9QO+M8HPQ10p2lv7
         EtBz/T+WkPLvG8RbEZ+eDRTxyWOK2lScllpbXbYDySvzHnZjTEdALPPD1crFS6CBFMxp
         ajCw==
X-Gm-Message-State: APjAAAXtSFxqiNmNMmyIqXaeTGvMdG0CdigTGDAZ4auE690eETdX++3+
        siZTlJhKmtiZFzRnwdFClZHfQMneARQ=
X-Google-Smtp-Source: APXvYqw+17oWohuim3pyav4HfbDZMPLmSIvwc/Cxz3viq6e+sh5Nhda7RdhX1Nyf9cLDzlTdGUXFtQ==
X-Received: by 2002:aa7:824b:: with SMTP id e11mr11366663pfn.33.1559343979073;
        Fri, 31 May 2019 16:06:19 -0700 (PDT)
Received: from [172.27.227.252] ([216.129.126.118])
        by smtp.googlemail.com with ESMTPSA id z125sm9433085pfb.75.2019.05.31.16.06.17
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 31 May 2019 16:06:18 -0700 (PDT)
Subject: Re: [PATCH net] vrf: Increment Icmp6InMsgs on the original netdev
To:     Stephen Suryaputra <ssuryaextr@gmail.com>, netdev@vger.kernel.org
References: <20190530050815.20352-1-ssuryaextr@gmail.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <c438f6b0-bb3c-7568-005e-68d7fcd406c3@gmail.com>
Date:   Fri, 31 May 2019 17:06:16 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:52.0)
 Gecko/20100101 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <20190530050815.20352-1-ssuryaextr@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/29/19 11:08 PM, Stephen Suryaputra wrote:
> diff --git a/net/ipv6/reassembly.c b/net/ipv6/reassembly.c
> index 1a832f5e190b..9b365c345c34 100644
> --- a/net/ipv6/reassembly.c
> +++ b/net/ipv6/reassembly.c
> @@ -260,6 +260,9 @@ static int ip6_frag_reasm(struct frag_queue *fq, struct sk_buff *skb,
>  	int payload_len;
>  	u8 ecn;
>  
> +	if (netif_is_l3_master(dev))
> +		dev = dev_get_by_index_rcu(net, inet6_iif(skb));
> +
>  	inet_frag_kill(&fq->q);
>  
>  	ecn = ip_frag_ecn_table[fq->ecn];
> 

this part changes skb->dev. Seems like it has an unintended effect if
the packet is delivered locally.
