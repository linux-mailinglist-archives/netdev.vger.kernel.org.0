Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7987F2DB9E6
	for <lists+netdev@lfdr.de>; Wed, 16 Dec 2020 05:09:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725385AbgLPEIZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Dec 2020 23:08:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725274AbgLPEIZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Dec 2020 23:08:25 -0500
Received: from mail-oo1-xc43.google.com (mail-oo1-xc43.google.com [IPv6:2607:f8b0:4864:20::c43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AAE90C0613D6
        for <netdev@vger.kernel.org>; Tue, 15 Dec 2020 20:07:44 -0800 (PST)
Received: by mail-oo1-xc43.google.com with SMTP id s19so1193340oos.2
        for <netdev@vger.kernel.org>; Tue, 15 Dec 2020 20:07:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=0w5Sa0S20Y4OhKDnr9stgh0BtUWJloDR3VVJjgCYNkU=;
        b=bMtJfAeDBh/7Mz8nPPWKghVgJWnna2BOTCtkMYu3nEcd/x3tEqsybyTgvI/1pzO7gy
         u9CEaQy4L6z7vaVLdgCcXcMQDaRwa1JT4AO2I+cqXv+4HML2Awsu3tkeFKOP+wZ6SAfI
         AjA78pQ3IHyDodgf3mY49QoFFOrZQ401kR+Hleoty7fFH0+jvdaLvhtdGDceSFzM+i8H
         0PyACi+Q8nc57wzQJMLcQgL4cFG0afGVwK/rKpVMczMP1f+ziYgcQlw135zUm1Owrsrd
         t7wwNKHwMYGQ9mdw/gCn8H6hvDPcgcQcY2IloI5LHBPbqnvM2yq40YCCvNPfQghf/18D
         KazQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=0w5Sa0S20Y4OhKDnr9stgh0BtUWJloDR3VVJjgCYNkU=;
        b=DgCf4k5OsadXox+wZwD1GOmhicv8bK9ckUeGgXnWY0miaoMq5YcraVbFQlDmCDPjKq
         EKU8hlF7Jq4ru1R92zs0b42KGhzNVffDV3ahZXa/m/afctPRWSthoexvNdXceNu2Q8Ku
         zo/3W7H89wViQ0BAHZn6Hq2uMoaemFjtfY3iOkQnFXZ5EmBLDHT/8vpq1xHuSVwEY86h
         9jIj8oARLlF6uvV1N2wSQJrPgNkf5Gj4sMpt7Cz4Zh0M7XblrwTEx0q4AnAWVTDcs3ag
         A/6yR3VkH0kJiq/cIw43y1RpCmyuHSqXqasYajC/bon8Z+ltmJufG/cGjpPg+ZUUTVrR
         xEQQ==
X-Gm-Message-State: AOAM533GYUEB3qOhHky3GwVm2FyL2IG6mGXTxhlkoeEzU9HlnFqVzevE
        3xr9b9GumY0U0VOYDR3z2P4=
X-Google-Smtp-Source: ABdhPJwLHtgK+XgqSkIHKIJmNqZ+79ZtZ1ETnmnDT6UQotWJHYUNABsqj3DnS8G2KofSX6o4xQaD0Q==
X-Received: by 2002:a4a:8c73:: with SMTP id v48mr9362788ooj.53.1608091663940;
        Tue, 15 Dec 2020 20:07:43 -0800 (PST)
Received: from Davids-MacBook-Pro.local ([2601:282:800:dc80:1f6:1ed:9027:4e75])
        by smtp.googlemail.com with ESMTPSA id p28sm173892ota.14.2020.12.15.20.07.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 15 Dec 2020 20:07:43 -0800 (PST)
Subject: Re: [PATCH iproute2-next v2] iplink:macvlan: Added bcqueuelen
 parameter
To:     Thomas Karlsson <thomas.karlsson@paneda.se>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        dsahern@gmail.com
Cc:     "davem@davemloft.net" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, stephen@networkplumber.org,
        kuznet@ms2.inr.ac.ru
References: <485531aec7e243659ee4e3bb7fa2186d@paneda.se>
 <147b704ac1d5426fbaa8617289dad648@paneda.se>
 <20201123143052.1176407d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <892be191-c948-4538-e46d-437c3f3a118c@paneda.se>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <943f08d6-f9c1-916c-ef95-d1020c4cf7a5@gmail.com>
Date:   Tue, 15 Dec 2020 21:07:42 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.5.1
MIME-Version: 1.0
In-Reply-To: <892be191-c948-4538-e46d-437c3f3a118c@paneda.se>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/14/20 3:42 AM, Thomas Karlsson wrote:
> This patch allows the user to set and retrieve the
> IFLA_MACVLAN_BC_QUEUE_LEN parameter via the bcqueuelen
> command line argument
> 
> This parameter controls the requested size of the queue for
> broadcast and multicast packages in the macvlan driver.
> 
> If not specified, the driver default (1000) will be used.
> 
> Note: The request is per macvlan but the actually used queue
> length per port is the maximum of any request to any macvlan
> connected to the same port.
> 
> For this reason, the used queue length IFLA_MACVLAN_BC_QUEUE_LEN_USED
> is also retrieved and displayed in order to aid in the understanding
> of the setting. However, it can of course not be directly set.
> 
> Signed-off-by: Thomas Karlsson <thomas.karlsson@paneda.se>
> ---
> 
> Note: This patch controls the parameter added in net-next
> with commit d4bff72c8401e6f56194ecf455db70ebc22929e2
> 
> v2 Rebased on origin/main
> v1 Initial version
> 
>  ip/iplink_macvlan.c   | 33 +++++++++++++++++++++++++++++++--
>  man/man8/ip-link.8.in | 33 +++++++++++++++++++++++++++++++++
>  2 files changed, 64 insertions(+), 2 deletions(-)
> 

applied to iproute2-next.
