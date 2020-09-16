Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D6DEF26CBB5
	for <lists+netdev@lfdr.de>; Wed, 16 Sep 2020 22:32:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728367AbgIPUcp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Sep 2020 16:32:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:49514 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728260AbgIPUck (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 16 Sep 2020 16:32:40 -0400
Received: from sx1.lan (c-24-6-56-119.hsd1.ca.comcast.net [24.6.56.119])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F30302087D;
        Wed, 16 Sep 2020 20:32:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600288360;
        bh=d/8hIoJcpw6lciK0UiA5WK7VZIO5zilcrzUREDvRU6U=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=SWXsUoAijFtauzg8g+pC2BICLnwNeTpOCcymAudpSlGmcFXM3zNZY6PvG0u+cg7EJ
         3mUIKWbemWlt7sB5nCah3Dvwx64txyXqqddhAAlH5rxfOrPgOEK85IS9qDI3HZukV5
         K0kBzQBYuOLNoQn9UadFkR0nFzDvT9lowUKalS0g=
Message-ID: <37c7b88261ad99c038764256a6e4d1ba995d3cdd.camel@kernel.org>
Subject: Re: [PATCH net-next] netdev: Remove unused funtions
From:   Saeed Mahameed <saeed@kernel.org>
To:     YueHaibing <yuehaibing@huawei.com>, davem@davemloft.net,
        kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Date:   Wed, 16 Sep 2020 13:32:38 -0700
In-Reply-To: <20200916141814.7376-1-yuehaibing@huawei.com>
References: <20200916141814.7376-1-yuehaibing@huawei.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2020-09-16 at 22:18 +0800, YueHaibing wrote:
> There is no callers in tree, so can remove it.
> 

You have a typo in the patch title:
funtions -> functions

> Signed-off-by: YueHaibing <yuehaibing@huawei.com>

Please feel free to add my R.B tag after on V2.
Reviewed-by: Saeed Mahameed <saeedm@nvidia.com>

And by the way, you have 3 patches doing similar things, please
consider submitting them as one series on V2:

$ git format-patch --cover-letter \
    --subject-prefix="PATCH net-next"  HEAD~3.. -o patches/ 


> ---
>  include/linux/netdevice.h | 10 ----------
>  1 file changed, 10 deletions(-)
> 
> diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
> index 157e0242e9ee..909b1fbb0481 100644
> --- a/include/linux/netdevice.h
> +++ b/include/linux/netdevice.h
> @@ -4677,16 +4677,6 @@ int netdev_class_create_file_ns(const struct
> class_attribute *class_attr,
>  void netdev_class_remove_file_ns(const struct class_attribute
> *class_attr,
>  				 const void *ns);
>  
> -static inline int netdev_class_create_file(const struct
> class_attribute *class_attr)
> -{
> -	return netdev_class_create_file_ns(class_attr, NULL);
> -}
> -
> -static inline void netdev_class_remove_file(const struct
> class_attribute *class_attr)
> -{
> -	netdev_class_remove_file_ns(class_attr, NULL);
> -}
> -
>  extern const struct kobj_ns_type_operations net_ns_type_operations;
>  
>  const char *netdev_drivername(const struct net_device *dev);

