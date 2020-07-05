Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 38910214D47
	for <lists+netdev@lfdr.de>; Sun,  5 Jul 2020 17:02:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726942AbgGEPCq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Jul 2020 11:02:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726826AbgGEPCp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 Jul 2020 11:02:45 -0400
Received: from mail-qk1-x743.google.com (mail-qk1-x743.google.com [IPv6:2607:f8b0:4864:20::743])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C9C1C061794;
        Sun,  5 Jul 2020 08:02:45 -0700 (PDT)
Received: by mail-qk1-x743.google.com with SMTP id b4so32666098qkn.11;
        Sun, 05 Jul 2020 08:02:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=EUv+aKwDqAjedJH2468a1PbmmVjr517j6wGA0T5ZQjg=;
        b=m6ddHBuhm40RpyQcYhOweQg/xgucx05pLUrqXUr1OOfiwbr7nGBjKJq19bY2V3vALQ
         px0Wpea/sgkijwWwxIK2ejAD5EChYRpmt3UvR/YqU4vtsIjuZQf5+ol0V716/rFY1R9F
         ZjAWo4RCoPDAQJEPbVziRl/tz/kppHvpodmYLzxmTZ4xvhBJhHiVruRdbVsM4pcNd+kY
         diZ1nH9wS/yfPj5JCDY2SCa6fmJLG+D8TFRORHMjr6asS2hZIaKBrLWOEoaGT+0Jve3h
         /I2htadTYWDjfiGr8U67TIFUXf1cUKPjSVokC28P3An4F8YJdylENmB45f9ZaxB55QCT
         5oKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=EUv+aKwDqAjedJH2468a1PbmmVjr517j6wGA0T5ZQjg=;
        b=phM3rRexopU+P23KU9DudP6cM4szvOQRN7FKlAuhNKrODG25v7RWxGJ+MKlfy3qgjh
         0HfNkSc34PRVIpW9td7k/VWOcG4rghKDXQCjtgKEakuwpB+P/gnKUHXAcUkLX1YYwCIq
         ZJxTIaLEENv0xxu9njlTqanvgWjGt1+RHbP0gCcPqwTjV0GbxnrtsLkBliz89LN9vKe7
         ZZlkcv9GBo+yOgmpqw9LwrsRnNkSjHDAnUHeGtLLzvvsUp1JEMTTToDryXwnmiXVZrCc
         VDz6YwEskdYE3sE4kSgDFp+gaH1NwHpEcZX6qHIwhxL/j71oEbQT69COXLJLSOdYlHfU
         sOiQ==
X-Gm-Message-State: AOAM53196LOrjVMuGRDAjEwPD8tsDWCwfPXBybe4Unzn1vMYl5jtXKxb
        5WVp4Zaqq8CMOgZeuAx4+2FQwwwL
X-Google-Smtp-Source: ABdhPJwFQKE0BmI2mhhXHWBE51n7hcwcQAGJ8DslL0ENF/DebT63fWlSqoEyjOZTBRFpyXo6zu3f/g==
X-Received: by 2002:a05:620a:9c7:: with SMTP id y7mr41431308qky.55.1593961364487;
        Sun, 05 Jul 2020 08:02:44 -0700 (PDT)
Received: from ?IPv6:2601:282:803:7700:f517:b957:b896:7107? ([2601:282:803:7700:f517:b957:b896:7107])
        by smtp.googlemail.com with ESMTPSA id b186sm15724942qkd.28.2020.07.05.08.02.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 05 Jul 2020 08:02:43 -0700 (PDT)
Subject: Re: [PATCH iproute2-next v1 1/4] rdma: update uapi headers
To:     Leon Romanovsky <leon@kernel.org>
Cc:     Maor Gottlieb <maorg@mellanox.com>,
        Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@mellanox.com>,
        linux-netdev <netdev@vger.kernel.org>,
        RDMA mailing list <linux-rdma@vger.kernel.org>
References: <20200624104012.1450880-1-leon@kernel.org>
 <20200624104012.1450880-2-leon@kernel.org>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <e91ebfe0-87aa-0dc4-7c2c-48004cc761c7@gmail.com>
Date:   Sun, 5 Jul 2020 09:02:42 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200624104012.1450880-2-leon@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/24/20 4:40 AM, Leon Romanovsky wrote:
> diff --git a/rdma/include/uapi/rdma/rdma_netlink.h b/rdma/include/uapi/rdma/rdma_netlink.h
> index ae5a77a1..fe127b88 100644
> --- a/rdma/include/uapi/rdma/rdma_netlink.h
> +++ b/rdma/include/uapi/rdma/rdma_netlink.h
> @@ -287,6 +287,12 @@ enum rdma_nldev_command {
>  
>  	RDMA_NLDEV_CMD_STAT_DEL,
>  
> +	RDMA_NLDEV_CMD_RES_QP_GET_RAW, /* can dump */
> +
> +	RDMA_NLDEV_CMD_RES_CQ_GET_RAW, /* can dump */
> +
> +	RDMA_NLDEV_CMD_RES_MR_GET_RAW, /* can dump */
> +
>  	RDMA_NLDEV_NUM_OPS
>  };

you are inserting new commands in the middle which breaks existing users
of this API.

