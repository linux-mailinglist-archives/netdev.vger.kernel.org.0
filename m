Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B1851AE8B4
	for <lists+netdev@lfdr.de>; Sat, 18 Apr 2020 01:50:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726055AbgDQXt1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Apr 2020 19:49:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725988AbgDQXt1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Apr 2020 19:49:27 -0400
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21614C061A0C
        for <netdev@vger.kernel.org>; Fri, 17 Apr 2020 16:49:27 -0700 (PDT)
Received: by mail-pf1-x442.google.com with SMTP id c138so1827487pfc.0
        for <netdev@vger.kernel.org>; Fri, 17 Apr 2020 16:49:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Sc8nVNakP82IHL/8bh11Gv353nwYW4DMOIYCh5TNMWI=;
        b=DbScmvY7M+VjjmZ5OU8ibSRm245bXhixIBiiF1bl/F+SgdkdEWTAHkeEXHF3gTRe1F
         I+kFDNftgiJKBaVXPBBeed+1PRtme2b/ZPVMKw6gRB3p+BLvgb5ct6Mq4GR+so7ip5R9
         q7IUmYNqHM4iOa+QqJkF0MSQyId/p4DCzwvX+xwAW2Ay4oZCBIsiEy3cgOybmRtcWQJy
         9XO+e5PP+YeYqzLJ+2vysasp2AEMSo+b/xG0m3I332WC7pe9RMcd+DuwePAMJC9aYPjw
         BOb9hgyOHCX8ZEWm5EzLYIBKLcR4WQehxrR6yMFNMm1QQFQnoq5qRvCQcAAG6cwcqxJD
         d4QA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Sc8nVNakP82IHL/8bh11Gv353nwYW4DMOIYCh5TNMWI=;
        b=V1xgR06xI4rPU0jGNK2seShce8K8Gj4RvGLkjSe2nwlNtGkiqdSxzWmFTjdoplcuLG
         YMxVIxKyNRarnwqiKnTGpx85eDEz4Lyf6XWGcDS8RwFaGIfECBIk7Ojs6cfEfvMBkT3j
         stShHlc++kGO8D6FVN2fev4LlmT8hXxuzOZMjXwfQGklRY7ptR3s9gl04SbH1YsequYx
         UpqVmmvOsZqULiN9pRA1LmIn0sRTyq/LzQWB+OgfAQFVZW3rEhVM7o/lpf95S9rhZa/U
         NULlrjJ3q9BXoA3wwtU5qXPqcOaXSZhvq8CJO13t35ard+4G7kXhX5i0pNdjVshBKD8M
         B9QQ==
X-Gm-Message-State: AGi0Pubrljqnfi9APfkla0srs6GcGllGYmnoYvRKyy27NuHcEmZNT2w4
        e+tA01cBakfc3HUNxJXkbkxEWXkY
X-Google-Smtp-Source: APiQypKqapFgm9YPQnQc8posMEyWg+03DHJr61I4M0soqncgHD2VYo9kxiFWNLmrGt7ntm0nGGXtLA==
X-Received: by 2002:a63:735c:: with SMTP id d28mr5434572pgn.408.1587167365975;
        Fri, 17 Apr 2020 16:49:25 -0700 (PDT)
Received: from [10.230.188.26] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id u7sm18824305pfu.90.2020.04.17.16.49.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 17 Apr 2020 16:49:24 -0700 (PDT)
Subject: Re: [PATCH net-next 2/3] net: Add testing sysfs attribute
To:     Andrew Lunn <andrew@lunn.ch>, David Miller <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>
References: <20200417230350.802675-1-andrew@lunn.ch>
 <20200417230350.802675-3-andrew@lunn.ch>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <cbecabd6-391c-88e4-6d4e-2ec7b43650fa@gmail.com>
Date:   Fri, 17 Apr 2020 16:49:23 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Firefox/68.0 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200417230350.802675-3-andrew@lunn.ch>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 4/17/2020 4:03 PM, Andrew Lunn wrote:
> Similar to speed, duplex and dorment, report the testing status
> in sysfs.
> 
> Signed-off-by: Andrew Lunn <andrew@lunn.ch>
> ---
>   Documentation/ABI/testing/sysfs-class-net | 13 +++++++++++++
>   net/core/net-sysfs.c                      | 15 ++++++++++++++-
>   2 files changed, 27 insertions(+), 1 deletion(-)
> 
> diff --git a/Documentation/ABI/testing/sysfs-class-net b/Documentation/ABI/testing/sysfs-class-net
> index 664a8f6a634f..5e8b09743e04 100644
> --- a/Documentation/ABI/testing/sysfs-class-net
> +++ b/Documentation/ABI/testing/sysfs-class-net
> @@ -124,6 +124,19 @@ Description:
>   		authentication is performed (e.g: 802.1x). 'link_mode' attribute
>   		will also reflect the dormant state.
>   
> +What:		/sys/class/net/<iface>/testing
> +Date:		Jun 2019
> +KernelVersion:	5.2

This should probably be 5.8 now, other than that:

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
