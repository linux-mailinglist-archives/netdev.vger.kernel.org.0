Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1965A1CE990
	for <lists+netdev@lfdr.de>; Tue, 12 May 2020 02:21:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728102AbgELAVN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 May 2020 20:21:13 -0400
Received: from fieldses.org ([173.255.197.46]:55234 "EHLO fieldses.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725854AbgELAVN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 11 May 2020 20:21:13 -0400
Received: by fieldses.org (Postfix, from userid 2815)
        id DD4588A6; Mon, 11 May 2020 20:21:12 -0400 (EDT)
Date:   Mon, 11 May 2020 20:21:12 -0400
From:   "J. Bruce Fields" <bfields@fieldses.org>
To:     Xiongfeng Wang <wangxiongfeng2@huawei.com>
Cc:     chuck.lever@oracle.com, trond.myklebust@hammerspace.com,
        anna.schumaker@netapp.com, davem@davemloft.net, kuba@kernel.org,
        linux-nfs@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] sunrpc: add missing newline when printing parameter
 'pool_mode' by sysfs
Message-ID: <20200512002112.GA17212@fieldses.org>
References: <1588901580-44687-1-git-send-email-wangxiongfeng2@huawei.com>
 <1588901580-44687-2-git-send-email-wangxiongfeng2@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1588901580-44687-2-git-send-email-wangxiongfeng2@huawei.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 08, 2020 at 09:32:59AM +0800, Xiongfeng Wang wrote:
> When I cat parameter '/sys/module/sunrpc/parameters/pool_mode', it
> displays as follows. It is better to add a newline for easy reading.

Applying for 5.8.  I assume Trond's getting the other patch.

--b.

> 
> [root@hulk-202 ~]# cat /sys/module/sunrpc/parameters/pool_mode
> global[root@hulk-202 ~]#
> 
> Signed-off-by: Xiongfeng Wang <wangxiongfeng2@huawei.com>
> ---
>  net/sunrpc/svc.c | 10 +++++-----
>  1 file changed, 5 insertions(+), 5 deletions(-)
> 
> diff --git a/net/sunrpc/svc.c b/net/sunrpc/svc.c
> index 187dd4e..d8ef47f 100644
> --- a/net/sunrpc/svc.c
> +++ b/net/sunrpc/svc.c
> @@ -88,15 +88,15 @@ struct svc_pool_map svc_pool_map = {
>  	switch (*ip)
>  	{
>  	case SVC_POOL_AUTO:
> -		return strlcpy(buf, "auto", 20);
> +		return strlcpy(buf, "auto\n", 20);
>  	case SVC_POOL_GLOBAL:
> -		return strlcpy(buf, "global", 20);
> +		return strlcpy(buf, "global\n", 20);
>  	case SVC_POOL_PERCPU:
> -		return strlcpy(buf, "percpu", 20);
> +		return strlcpy(buf, "percpu\n", 20);
>  	case SVC_POOL_PERNODE:
> -		return strlcpy(buf, "pernode", 20);
> +		return strlcpy(buf, "pernode\n", 20);
>  	default:
> -		return sprintf(buf, "%d", *ip);
> +		return sprintf(buf, "%d\n", *ip);
>  	}
>  }
>  
> -- 
> 1.7.12.4
