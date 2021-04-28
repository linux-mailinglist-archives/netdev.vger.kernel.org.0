Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 212CB36DC0C
	for <lists+netdev@lfdr.de>; Wed, 28 Apr 2021 17:41:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240856AbhD1Plf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Apr 2021 11:41:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240855AbhD1Pjg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Apr 2021 11:39:36 -0400
Received: from mail-oi1-x22c.google.com (mail-oi1-x22c.google.com [IPv6:2607:f8b0:4864:20::22c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6BB2C061343;
        Wed, 28 Apr 2021 08:38:20 -0700 (PDT)
Received: by mail-oi1-x22c.google.com with SMTP id k25so63460388oic.4;
        Wed, 28 Apr 2021 08:38:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=0WptjyXS6/FeNncYBoJN3uRnsgQI82+Frjd4e/WulQ4=;
        b=qD3bHSs2GWjMZN7e8HFHZ9MxdNXBrsTvMQjG37BiEsoMb6hHhC8n1nKX2WcrnLL+S2
         WZeLeLbFg5KhJS0pizbpWXWD7VASeTLxHxrlbZNznDlaYfEqH9XHaFh5elxMfhSlxwA/
         TiSqT7XYlojBo/geSC5PEB5dSrmEGTtV5UlbUStypYInvy4xW77zLM0NYp0yA6CDfpuK
         UvSek5mOBsquLcUXlHzOnOM9BdcYeJDqu44lDa4TspzMI/8XW2PQdm2O/3mWsubXhmdk
         EZE9/EHKIhloBtSbma3UyHqCxTlU64uaDs4ulkwz7WgP+iIFxx+WzdQT/NS+BBheL2Qf
         gIOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=0WptjyXS6/FeNncYBoJN3uRnsgQI82+Frjd4e/WulQ4=;
        b=J52xq7cKR9wvcPtIlkD3pDMyPXj3J7EpAEp+Gl9BZK376ol9dh5pmyByz9Leerjs+m
         eiPuhQLcCgyJNqFL7NQCZQLXahK62FWMwL4AZU58ccxjvN6HdYt3boBhYyWEoVgSjmxy
         M7K8V0g2RsgE8swqqiLJ3O0RQgcbCI2hwx9YvqmN+KKZxbOTNqYogZdaZkrRLVDPq+vZ
         vNVe0hpkRE6foDiMk9dn2fKzX3g1Hyg6tpGXzbHksKQQVoUNjbKVKKPVOBwAxGFOxdEI
         HAEfifnPWRgeRQ8xn21K36fcdfTsHP7ivDqu6ufERITcubrzIdN5jZYRRUHAKFM04iZG
         +hjA==
X-Gm-Message-State: AOAM5337eOacCA+k6KNxij4OwhPn7K56tRsJBU86MQiR+1jTj/lK6DlI
        UJs2lFwAMMBTSnGRdil1FzLGQjxNBJ4=
X-Google-Smtp-Source: ABdhPJz5p/u9tm8/sZ/GbvngOg3qyimwIYOUnQM9Bwnw6dcWyqnJW1oYC/KrDJq4jeMI5ZEU9UlGBA==
X-Received: by 2002:aca:53c6:: with SMTP id h189mr382871oib.27.1619624299896;
        Wed, 28 Apr 2021 08:38:19 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([8.48.134.33])
        by smtp.googlemail.com with ESMTPSA id n105sm64731ota.45.2021.04.28.08.38.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 28 Apr 2021 08:38:19 -0700 (PDT)
Subject: Re: [PATCH iproute2-next 0/3] Add context and SRQ information to
 rdmatool
To:     Leon Romanovsky <leon@kernel.org>
Cc:     Leon Romanovsky <leonro@nvidia.com>, Ido Kalir <idok@nvidia.com>,
        linux-netdev <netdev@vger.kernel.org>,
        Mark Zhang <markz@mellanox.com>,
        Neta Ostrovsky <netao@nvidia.com>,
        RDMA mailing list <linux-rdma@vger.kernel.org>
References: <cover.1619351025.git.leonro@nvidia.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <5914c535-7b2f-3dbc-f804-41fd0ce37488@gmail.com>
Date:   Wed, 28 Apr 2021 09:38:16 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.10.0
MIME-Version: 1.0
In-Reply-To: <cover.1619351025.git.leonro@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/25/21 5:53 AM, Leon Romanovsky wrote:
> From: Leon Romanovsky <leonro@nvidia.com>
> 
> Hi,
> 
> This is the user space part of already accepted to the kernel series
> that extends RDMA netlink interface to return uverbs context and SRQ
> information.
> 
> The accepted kernel series can be seen here:
> https://lore.kernel.org/linux-rdma/20210422133459.GA2390260@nvidia.com/
> 
> Thanks
> 
> Neta Ostrovsky (2):
>   rdma: Update uapi headers
>   rdma: Add context resource tracking information
>   rdma: Add SRQ resource tracking information
> 
>  man/man8/rdma-resource.8              |  12 +-
>  rdma/Makefile                         |   2 +-
>  rdma/include/uapi/rdma/rdma_netlink.h |  13 ++
>  rdma/res-ctx.c                        | 103 ++++++++++
>  rdma/res-srq.c                        | 274 ++++++++++++++++++++++++++
>  rdma/res.c                            |   8 +-
>  rdma/res.h                            |  28 +++
>  rdma/utils.c                          |   8 +
>  8 files changed, 445 insertions(+), 3 deletions(-)
>  create mode 100644 rdma/res-ctx.c
>  create mode 100644 rdma/res-srq.c
> 

applied to iproute2-next.
