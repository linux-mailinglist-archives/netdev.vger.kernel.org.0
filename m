Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F140633A574
	for <lists+netdev@lfdr.de>; Sun, 14 Mar 2021 16:30:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233103AbhCNPaO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 14 Mar 2021 11:30:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229495AbhCNP3n (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 14 Mar 2021 11:29:43 -0400
Received: from mail-ot1-x32e.google.com (mail-ot1-x32e.google.com [IPv6:2607:f8b0:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D09FBC061574
        for <netdev@vger.kernel.org>; Sun, 14 Mar 2021 08:29:42 -0700 (PDT)
Received: by mail-ot1-x32e.google.com with SMTP id h6-20020a0568300346b02901b71a850ab4so3908147ote.6
        for <netdev@vger.kernel.org>; Sun, 14 Mar 2021 08:29:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=6QVL/cOTZT6KwW6BOPWLNkl8bZCWV/ZhLoIZL6vyc98=;
        b=Mx2VK9NA1DB6yWqoFu1w7SPNFxCurbbJFnGio3qs8OfqmfdLa4Z6pozyHmtYOo5pDk
         CQ0htKYu7/gA3lqRpbcRyD1l0ZI14GDjry+3OsI0e9cpARvv2ZBLZvwMJ6SBqKkGCYMg
         oQvDdESdc8pL84BKMlCL1ztlALIWAWRQJ3VnN9YAx8kArfNm1WiNStHIwWZmeEtSRa88
         uTeok0myVH0+q7MZ6f4sH3NA4gcQv9AU0bMpBretWc5VIMqT2KrJK3vJjTmuH/pxGu+J
         u7fWNbOr6Y1dxccU+Wi5GVaX0AFhr09dxYlEwmhaUGgexWEBMnSL9ZZJtyQAk93bVIH8
         BnJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=6QVL/cOTZT6KwW6BOPWLNkl8bZCWV/ZhLoIZL6vyc98=;
        b=OjYsBRVYxWG3iZm0mQbmzY25B1LGIVx6r3/sB7KB0EShNvvsvnVq5lkbTXYk4P1QyD
         csEhG+BpysAaUqy4uRjZLtjNhLnusn3+yxNovIbQC5tKTsxMy3PTdN3KAVKC10m2/Eb2
         0sNktPY3NlbUfsWg6u9flNAkellhAbnr3jjJmldEa8Hs7Nosp826s08Eidp8HbeJZY/A
         rsxK7p6P/ZtO4dTGAdwiNfJc3n2U+Sr85y/1de6NS430QYcU4n4/3hyVLCBbexlWH0tI
         PWGJNfqWz8ZNu9VnARdlRgOnDCn96BiBdpdaULyw58B/+T3iFSevaHsf9mXS7jVVOoTn
         L2sw==
X-Gm-Message-State: AOAM530/Oovi43ib2/NO6A4yk/aCBuibkyF5SgtgIGFT1Fb7MF2zMjtV
        fx9BGhT754wfox9rtZP0oK3v5cez28c=
X-Google-Smtp-Source: ABdhPJzz1+tgHPkOhPs/nhuIdm6RJu1Z8ib+NkK6OV9XFadCjstL9n8hwwfjEi6MVdXVpYO8DmOtQg==
X-Received: by 2002:a9d:d4e:: with SMTP id 72mr11045740oti.124.1615735782224;
        Sun, 14 Mar 2021 08:29:42 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([8.48.134.56])
        by smtp.googlemail.com with ESMTPSA id l191sm5222490oih.16.2021.03.14.08.29.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 14 Mar 2021 08:29:41 -0700 (PDT)
Subject: Re: [PATCH net-next 05/10] selftests: fib_nexthops: Declutter test
 output
To:     Petr Machata <petrm@nvidia.com>, netdev@vger.kernel.org
Cc:     Ido Schimmel <idosch@nvidia.com>, David Ahern <dsahern@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
References: <cover.1615563035.git.petrm@nvidia.com>
 <74fabd4da36cc447239e81e60b6b0266d3d11634.1615563035.git.petrm@nvidia.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <514b98df-e93d-4883-3d98-18d6697669f1@gmail.com>
Date:   Sun, 14 Mar 2021 09:29:40 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <74fabd4da36cc447239e81e60b6b0266d3d11634.1615563035.git.petrm@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/12/21 9:50 AM, Petr Machata wrote:
> From: Ido Schimmel <idosch@nvidia.com>
> 
> Before:
> 
>  # ./fib_nexthops.sh -t ipv4_torture
> 
> IPv4 runtime torture
> --------------------
> TEST: IPv4 torture test                                             [ OK ]
> ./fib_nexthops.sh: line 213: 19376 Killed                  ipv4_del_add_loop1
> ./fib_nexthops.sh: line 213: 19377 Killed                  ipv4_grp_replace_loop
> ./fib_nexthops.sh: line 213: 19378 Killed                  ip netns exec me ping -f 172.16.101.1 > /dev/null 2>&1
> ./fib_nexthops.sh: line 213: 19380 Killed                  ip netns exec me ping -f 172.16.101.2 > /dev/null 2>&1
> ./fib_nexthops.sh: line 213: 19381 Killed                  ip netns exec me mausezahn veth1 -B 172.16.101.2 -A 172.16.1.1 -c 0 -t tcp "dp=1-1023, flags=syn" > /dev/null 2>&1
> 
> Tests passed:   1
> Tests failed:   0
> 
>  # ./fib_nexthops.sh -t ipv6_torture
> 
> IPv6 runtime torture
> --------------------
> TEST: IPv6 torture test                                             [ OK ]
> ./fib_nexthops.sh: line 213: 24453 Killed                  ipv6_del_add_loop1
> ./fib_nexthops.sh: line 213: 24454 Killed                  ipv6_grp_replace_loop
> ./fib_nexthops.sh: line 213: 24456 Killed                  ip netns exec me ping -f 2001:db8:101::1 > /dev/null 2>&1
> ./fib_nexthops.sh: line 213: 24457 Killed                  ip netns exec me ping -f 2001:db8:101::2 > /dev/null 2>&1
> ./fib_nexthops.sh: line 213: 24458 Killed                  ip netns exec me mausezahn -6 veth1 -B 2001:db8:101::2 -A 2001:db8:91::1 -c 0 -t tcp "dp=1-1023, flags=syn" > /dev/null 2>&1
> 
> Tests passed:   1
> Tests failed:   0
> 
> After:
> 
>  # ./fib_nexthops.sh -t ipv4_torture
> 
> IPv4 runtime torture
> --------------------
> TEST: IPv4 torture test                                             [ OK ]
> 
> Tests passed:   1
> Tests failed:   0
> 
>  # ./fib_nexthops.sh -t ipv6_torture
> 
> IPv6 runtime torture
> --------------------
> TEST: IPv6 torture test                                             [ OK ]
> 
> Tests passed:   1
> Tests failed:   0
> 
> Signed-off-by: Ido Schimmel <idosch@nvidia.com>
> Reviewed-by: Petr Machata <petrm@nvidia.com>
> Signed-off-by: Petr Machata <petrm@nvidia.com>
> ---
>  tools/testing/selftests/net/fib_nexthops.sh | 2 ++
>  1 file changed, 2 insertions(+)
> 

Reviewed-by: David Ahern <dsahern@kernel.org>


