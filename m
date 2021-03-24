Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 855A9347E69
	for <lists+netdev@lfdr.de>; Wed, 24 Mar 2021 18:02:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236997AbhCXRBh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Mar 2021 13:01:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236257AbhCXRBE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Mar 2021 13:01:04 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3A73C061763;
        Wed, 24 Mar 2021 10:01:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:Subject:Sender
        :Reply-To:Content-ID:Content-Description;
        bh=EG9LDv4W3Ex/KXnPhz4kq030LKHC8Q1jYXZyuVd6cDU=; b=vAOLmBWQ30YkFTR2VeKR7UGXym
        msbuNCqxvw4hgRBosX1T6QKNXQFNeyvcecGO2y7RCsGvNA4wVW1yRMha/ES4NCGD1uXJRKkd7HNWD
        dIcbSXNGZkIroglxDHUWt8UI/a8zOGUjcAMzsDPGJ/SDmXJkMmWETXpK6DMqSt1R4ALDkEdvgWsfs
        QfQd4g1SX27gqPK5XLIOi6XfqTwLiV8Zq8CVvCHUrNiZWZx7UuJkUlRt6sez3NEG6pXPeu0F+U6FP
        UK7NBXiQW8QzAZSKR0HlBetbpjLMlRMQx/zX6Z0Y/JzNLOXl/yNocSihHa3M7h3iVQJoe2yHbXqSh
        pDQpzvEw==;
Received: from [2601:1c0:6280:3f0::3ba4]
        by casper.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1lP6rV-00BboM-Bf; Wed, 24 Mar 2021 17:00:14 +0000
Subject: Re: [PATCH net-next] net/packet: Fix a typo in af_packet.c
To:     Wang Hai <wanghai38@huawei.com>, davem@davemloft.net,
        kuba@kernel.org, willemb@google.com, xie.he.0141@gmail.com,
        john.ogness@linutronix.de, yonatanlinik@gmail.com,
        gustavoars@kernel.org, tannerlove@google.com,
        eyal.birger@gmail.com, orcohen@paloaltonetworks.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20210324061931.11012-1-wanghai38@huawei.com>
From:   Randy Dunlap <rdunlap@infradead.org>
Message-ID: <ee0cfada-84d9-1502-1f49-489dfa3c8221@infradead.org>
Date:   Wed, 24 Mar 2021 10:00:00 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <20210324061931.11012-1-wanghai38@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/23/21 11:19 PM, Wang Hai wrote:
> s/sequencially/sequentially/
> 
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: Wang Hai <wanghai38@huawei.com>

Acked-by: Randy Dunlap <rdunlap@infradead.org>

> ---
>  net/packet/af_packet.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/net/packet/af_packet.c b/net/packet/af_packet.c
> index 6bbc7a448593..fe29fc1b8b9d 100644
> --- a/net/packet/af_packet.c
> +++ b/net/packet/af_packet.c
> @@ -2057,7 +2057,7 @@ static int packet_rcv_vnet(struct msghdr *msg, const struct sk_buff *skb,
>   * and skb->cb are mangled. It works because (and until) packets
>   * falling here are owned by current CPU. Output packets are cloned
>   * by dev_queue_xmit_nit(), input packets are processed by net_bh
> - * sequencially, so that if we return skb to original state on exit,
> + * sequentially, so that if we return skb to original state on exit,
>   * we will not harm anyone.
>   */
>  
> 


-- 
~Randy

