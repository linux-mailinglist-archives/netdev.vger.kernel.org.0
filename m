Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C8DF2F655B
	for <lists+netdev@lfdr.de>; Thu, 14 Jan 2021 17:03:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729393AbhANQAe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jan 2021 11:00:34 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:49084 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727838AbhANQAe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Jan 2021 11:00:34 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1610639960;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=N1jiFZ+BTbOnp7BDFCcT1kr+iDpCrn9geTo5A349Jxs=;
        b=h6sc5S/e8WzriJZeodn/zeb8/IbMuL8U3MO26ic5tcYgJyPFe6aJyteTV9AShn2RE3xLZs
        wOQKJKLqB2nYBRwt9vCxBGfS9gqIsBFdmNXmyWSJ8QEwEqkRfy73XvBFP9FyiLmrtPuFx7
        WfGdAJ3iT588pAwK7KhJzWzjqGaz7Ik=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-547-WJoENA_jPsCQCmvq4JJr6Q-1; Thu, 14 Jan 2021 10:59:15 -0500
X-MC-Unique: WJoENA_jPsCQCmvq4JJr6Q-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id CF028107565A;
        Thu, 14 Jan 2021 15:59:10 +0000 (UTC)
Received: from [10.10.119.172] (ovpn-119-172.rdu2.redhat.com [10.10.119.172])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 933F718A50;
        Thu, 14 Jan 2021 15:59:09 +0000 (UTC)
Subject: Re: [PATCH v6 12/16] net: tip: fix a couple kernel-doc markups
To:     Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        Jonathan Corbet <corbet@lwn.net>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Ying Xue <ying.xue@windriver.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        tipc-discussion@lists.sourceforge.net
References: <cover.1610610937.git.mchehab+huawei@kernel.org>
 <9d205b0e080153af0fbddee06ad0eb23457e1b1b.1610610937.git.mchehab+huawei@kernel.org>
From:   Jon Maloy <jmaloy@redhat.com>
Message-ID: <da52ef69-753a-7aa8-a2b1-1b5ef48df94e@redhat.com>
Date:   Thu, 14 Jan 2021 10:59:08 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.0
MIME-Version: 1.0
In-Reply-To: <9d205b0e080153af0fbddee06ad0eb23457e1b1b.1610610937.git.mchehab+huawei@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 1/14/21 3:04 AM, Mauro Carvalho Chehab wrote:
> A function has a different name between their prototype
> and its kernel-doc markup:
>
> 	../net/tipc/link.c:2551: warning: expecting prototype for link_reset_stats(). Prototype was for tipc_link_reset_stats() instead
> 	../net/tipc/node.c:1678: warning: expecting prototype for is the general link level function for message sending(). Prototype was for tipc_node_xmit() instead
>
> Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
> ---
>   net/tipc/link.c | 2 +-
>   net/tipc/node.c | 2 +-
>   2 files changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/net/tipc/link.c b/net/tipc/link.c
> index a6a694b78927..115109259430 100644
> --- a/net/tipc/link.c
> +++ b/net/tipc/link.c
> @@ -2544,7 +2544,7 @@ void tipc_link_set_queue_limits(struct tipc_link *l, u32 min_win, u32 max_win)
>   }
>   
>   /**
> - * link_reset_stats - reset link statistics
> + * tipc_link_reset_stats - reset link statistics
>    * @l: pointer to link
>    */
>   void tipc_link_reset_stats(struct tipc_link *l)
> diff --git a/net/tipc/node.c b/net/tipc/node.c
> index 83d9eb830592..008670d1f43e 100644
> --- a/net/tipc/node.c
> +++ b/net/tipc/node.c
> @@ -1665,7 +1665,7 @@ static void tipc_lxc_xmit(struct net *peer_net, struct sk_buff_head *list)
>   }
>   
>   /**
> - * tipc_node_xmit() is the general link level function for message sending
> + * tipc_node_xmit() - general link level function for message sending
>    * @net: the applicable net namespace
>    * @list: chain of buffers containing message
>    * @dnode: address of destination node
Acked-by: Jon Maloy <jmaloy@redhat.com>

