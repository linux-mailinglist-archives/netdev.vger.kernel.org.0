Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F98126170D
	for <lists+netdev@lfdr.de>; Tue,  8 Sep 2020 19:24:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731955AbgIHRYj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Sep 2020 13:24:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731365AbgIHQRN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Sep 2020 12:17:13 -0400
Received: from mail-il1-x143.google.com (mail-il1-x143.google.com [IPv6:2607:f8b0:4864:20::143])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BEC86C09B049
        for <netdev@vger.kernel.org>; Tue,  8 Sep 2020 07:43:12 -0700 (PDT)
Received: by mail-il1-x143.google.com with SMTP id t16so15569347ilf.13
        for <netdev@vger.kernel.org>; Tue, 08 Sep 2020 07:43:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Q+8ABrFDNcexJvEX/IKHlJIkLywl0jju4ns637vUG/k=;
        b=GfMSDimQ8VwGbbqyQf+pj6de6+w5lx7UGljaK8tNsz4pqdUUyfgfoPVXx/JGIKIvYA
         YO8TzJ1g6vCZDo/KdIWKgnVQnHB1pY6uhHZGh0CmmjmUITYL/c4DumZ4D5WUnaTdRAzc
         lE9C2VfFXjmGHGrFkhB1d1mLj0rP//I4SfhocqCILOuRCp2outAApQAS+glXaWbrm62Q
         IlkcjozPBVfAXxaBQpRoC4BmTyeiqXJBWGZOyeywXEU6f4bwz3W2e0smJM+YtTqFmeRS
         5/eny9+lXlmn+La1CwV4zrMkEHl3pGg0Ewb48T4+jEzX0V4muZXP8tG3g3IYTHEetQsy
         Qrcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Q+8ABrFDNcexJvEX/IKHlJIkLywl0jju4ns637vUG/k=;
        b=qlEJO5DlQhrrG1Us8STy7wteNKnS0/NeK6wmOqPnhfc5lCegtETIi2NHGkWX8kbzdU
         oFjTYdaQAiX+Cy8K07zSrWAWj0nkxXLkA5Uc1a78JxVWBRgiCrZh1tVIgG+NBF16UycZ
         fc+G4tl5ZQXVOTW+uN2A3kGJq2TR2kCO66Y5eF3lyAbNR8Xr/zzGTGolFX1Mgm9SvViJ
         xJMByjH8tOiBi0QDgF9lANuo2PXAjbII42LqJ0Vg7mIm16E7ItZH8d0AwZnIdRx9ItED
         X1KjDsrunC54O8o2WTKS/eLR1FvL1Pfhwt31E5r+fQB1KPuVnW+MEp1X4FsUcrLZ5Sdu
         uxHA==
X-Gm-Message-State: AOAM533GoDeyOUfaL3WIqX9W4r7VtQDVbZHJt6VkG8C7J/9PR0TPCa9P
        r8xeIjkQvSE/MHg660qJ8ho=
X-Google-Smtp-Source: ABdhPJzD+7/ZDT0V5Jh9JEzxZ+rpp07PaKgZB6MUMQOzWe9pYKLvhN4B2xpGQKrFVYYwrFtbgsoi+A==
X-Received: by 2002:a92:2515:: with SMTP id l21mr22528927ill.268.1599576192117;
        Tue, 08 Sep 2020 07:43:12 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([2601:282:803:7700:ec70:7b06:eed6:6e35])
        by smtp.googlemail.com with ESMTPSA id s13sm5813064ilq.16.2020.09.08.07.43.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 08 Sep 2020 07:43:10 -0700 (PDT)
Subject: Re: [RFC PATCH net-next 05/22] nexthop: Add nexthop notification data
 structures
To:     Ido Schimmel <idosch@idosch.org>, netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, roopa@nvidia.com,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
References: <20200908091037.2709823-1-idosch@idosch.org>
 <20200908091037.2709823-6-idosch@idosch.org>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <bd4902d0-3e69-aca8-c59c-9c2496b75173@gmail.com>
Date:   Tue, 8 Sep 2020 08:43:10 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <20200908091037.2709823-6-idosch@idosch.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/8/20 3:10 AM, Ido Schimmel wrote:
> From: Ido Schimmel <idosch@nvidia.com>
> 
> Add data structures that will be used for nexthop replace and delete
> notifications in the previously introduced nexthop notification chain.
> 
> New data structures are added instead of passing the existing nexthop
> code structures directly for several reasons.
> 
> First, the existing structures encode a lot of bookkeeping information
> which is irrelevant for listeners of the notification chain.
> 
> Second, the existing structures can be changed without worrying about
> introducing regressions in listeners since they are not accessed
> directly by them.
> 
> Third, listeners of the notification chain do not need to each parse the
> relatively complex nexthop code structures. They are passing the
> required information in a simplified way.

agreed. My preference is for only nexthop.{c,h} to understand and parse
the nexthop structs.


> 
> Signed-off-by: Ido Schimmel <idosch@nvidia.com>
> ---
>  include/net/nexthop.h | 35 +++++++++++++++++++++++++++++++++++
>  1 file changed, 35 insertions(+)
> 
> diff --git a/include/net/nexthop.h b/include/net/nexthop.h
> index 2e44efe5709b..0bde1aa867c0 100644
> --- a/include/net/nexthop.h
> +++ b/include/net/nexthop.h
> @@ -109,6 +109,41 @@ enum nexthop_event_type {
>  	NEXTHOP_EVENT_DEL
>  };
>  
> +struct nh_notifier_single_info {
> +	struct net_device *dev;
> +	u8 gw_family;
> +	union {
> +		__be32 ipv4;
> +		struct in6_addr ipv6;
> +	};
> +	u8 is_reject:1,
> +	   is_fdb:1,
> +	   is_encap:1;

use has_encap since it refers to a configuration of a nexthop versus a
nexthop type.

I take it this is a placeholder until lwt offload is supported?

besides the naming nit,

Reviewed-by: David Ahern <dsahern@gmail.com>

