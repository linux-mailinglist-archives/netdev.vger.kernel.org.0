Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D98934500A
	for <lists+netdev@lfdr.de>; Mon, 22 Mar 2021 20:39:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232299AbhCVTio (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Mar 2021 15:38:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232090AbhCVTic (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Mar 2021 15:38:32 -0400
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED3B8C061574;
        Mon, 22 Mar 2021 12:38:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=Content-Transfer-Encoding:Content-Type
        :In-Reply-To:MIME-Version:Date:Message-ID:From:References:To:Subject:Sender:
        Reply-To:Cc:Content-ID:Content-Description;
        bh=Wg1p1SlksmUzSxx9om/IR8uOZYlyIdBFyKryY0n4pZg=; b=i2rcNXlaQXxsrwUwpw6rYTsgfH
        FyE5TPFGEUtYNHelROfrGON6sG0jtux4JoTe0ZoKzQbNAB/7dAaLkI3kK8dbq/vaPUDSPllhRjQVd
        Jbhe95fTN+zAQ3nXjlifmMXBAmjvzGwcgWdlqrIK5MXnjsBz24d33h8i3RMuxbiJyAVr2GuMFMZab
        n52abNad05YOkfHEhRipA9eGh1ksnIDR7YVfr1+0MdJQVO8/1WJ9Ioqq/ydtriJzGLJlgU1OU4q0f
        oovmjLr5ZhIUbWhn+ZXqlDUI4L9JfnkrlgVGWzyore6gs9ZasXqygnOzuqHU/OCWsO2iRknYrcvq/
        DIrkYwFA==;
Received: from [2601:1c0:6280:3f0::3ba4]
        by desiato.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1lOQNg-00CRV7-28; Mon, 22 Mar 2021 19:38:28 +0000
Subject: Re: [PATCH] net: l2tp: Fix a typo
To:     Bhaskar Chowdhury <unixbhaskar@gmail.com>, davem@davemloft.net,
        kuba@kernel.org, tparkin@katalix.com,
        mschiffer@universe-factory.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20210322122155.2420640-1-unixbhaskar@gmail.com>
From:   Randy Dunlap <rdunlap@infradead.org>
Message-ID: <80dcf150-dafd-9ba7-24f3-2232fdc11942@infradead.org>
Date:   Mon, 22 Mar 2021 12:38:25 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <20210322122155.2420640-1-unixbhaskar@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/22/21 5:21 AM, Bhaskar Chowdhury wrote:
> 
> s/verifed/verified/
> 
> Signed-off-by: Bhaskar Chowdhury <unixbhaskar@gmail.com>

Acked-by: Randy Dunlap <rdunlap@infradead.org>

> ---
>  net/l2tp/l2tp_core.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/net/l2tp/l2tp_core.c b/net/l2tp/l2tp_core.c
> index 203890e378cb..2ee20743cb41 100644
> --- a/net/l2tp/l2tp_core.c
> +++ b/net/l2tp/l2tp_core.c
> @@ -802,7 +802,7 @@ static int l2tp_udp_recv_core(struct l2tp_tunnel *tunnel, struct sk_buff *skb)
>  	u16 version;
>  	int length;
> 
> -	/* UDP has verifed checksum */
> +	/* UDP has verified checksum */
> 
>  	/* UDP always verifies the packet length. */
>  	__skb_pull(skb, sizeof(struct udphdr));
> --


-- 
~Randy

