Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BFDB73B4CB2
	for <lists+netdev@lfdr.de>; Sat, 26 Jun 2021 06:47:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229975AbhFZEuF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Jun 2021 00:50:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229451AbhFZEuF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 26 Jun 2021 00:50:05 -0400
Received: from mail-oo1-xc2a.google.com (mail-oo1-xc2a.google.com [IPv6:2607:f8b0:4864:20::c2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81206C061574
        for <netdev@vger.kernel.org>; Fri, 25 Jun 2021 21:47:43 -0700 (PDT)
Received: by mail-oo1-xc2a.google.com with SMTP id 128-20020a4a11860000b029024b19a4d98eso3095211ooc.5
        for <netdev@vger.kernel.org>; Fri, 25 Jun 2021 21:47:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=VO26GknPa60sF3VhnbBpsAy4F52G3DyMHK7N+bDbPrU=;
        b=UCj8s0mBPSqraRIg0MSHgIPNwVKJiWFG5it2c3GRuwxrnRRXrLoIqEL9lURVsjEECJ
         jDKFIpfrZXCrDzE8DdUwFK414G21vds/F/PrCoHOQi99XEN8g+0W+i6f3T1X/i2niybZ
         AwXBH1a7sdN27xtozX90rX1OPJV8YrdZExvmQaZEbaMNJ7VFMZM6yP/hc7EZJkxdeG8i
         YkzPzFOmCPNiLCMldAhgxXzPPBqHweGBR4ERFNh/CCPZX2vFgfZMtpHpOh3Dgk6aw1BY
         sJnFp5gMQZcPDGGnETeWzkWjcaFdvtmzLqYbRG8027IvxmYBqQWZE1cWZTZvxuCqC1oR
         6jxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=VO26GknPa60sF3VhnbBpsAy4F52G3DyMHK7N+bDbPrU=;
        b=NsRbNq0AJgeoL9FpfOg9VMKNqZwOgttjtwrpGvgmjrVVVVC2M3d7fuxPUV3kCPrIyV
         1Q0TUUxElTEXm65lDu9XZRg4X89AyhySJ4MWqTBfMnvKwNu9RE2zSgdM/6L+ytrW7D0Z
         8JZLEHGMl2NKkjvahQ9ROPdcWL6jG4DCt0HBw3gbKLncERXH9aAuzciHYl1XhkHRcDlX
         nfqlwSrqI4HaPXaOkKx9UmVS66LHPkzaha6QzWi9qRVxwlug6R5z1lsf/cRkeTRjRbj2
         iHjF7YuUpa2J6h6ZlTiBXuNbgSSB7rNdlsq0pH5SplK56i5alCSdhkdV1XPL/UokrtCo
         xqdA==
X-Gm-Message-State: AOAM53281rRqTo1Q/I+nKKcbIbB7QJ6vQjfkYQt+QQV2N3UQ+QOo74FD
        2haXnReSnE8ET5CeQWTRggM=
X-Google-Smtp-Source: ABdhPJyLeXlhV58ZrSpB1j2js9d2PEbreblNbwzWg2YLOfCzVe+739gCua51VECHbJ1HMwQYevrYxw==
X-Received: by 2002:a4a:b443:: with SMTP id h3mr11906536ooo.24.1624682862909;
        Fri, 25 Jun 2021 21:47:42 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([8.48.134.38])
        by smtp.googlemail.com with ESMTPSA id n16sm1216718oor.47.2021.06.25.21.47.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 25 Jun 2021 21:47:42 -0700 (PDT)
Subject: Re: [PATCH net-next] ipv6: Add sysctl for RA default route table
 number
To:     antony.antony@secunet.com, "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>
Cc:     netdev@vger.kernel.org,
        Christian Perle <christian.perle@secunet.com>
References: <cover.1619775297.git.antony.antony@secunet.com>
 <32de887afdc7d6851e7c53d27a21f1389bb0bd0f.1624604535.git.antony.antony@secunet.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <95b096f7-8ece-46be-cedb-5ee4fc011477@gmail.com>
Date:   Fri, 25 Jun 2021 22:47:41 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <32de887afdc7d6851e7c53d27a21f1389bb0bd0f.1624604535.git.antony.antony@secunet.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/25/21 1:04 AM, Antony Antony wrote:
> From: Christian Perle <christian.perle@secunet.com>
> 
> Default routes learned from router advertisements(RA) are always placed
> in main routing table. For policy based routing setups one may
> want a different table for default routes. This commit adds a sysctl
> to make table number for RA default routes configurable.
> 
> examples:
> sysctl net.ipv6.route.defrtr_table
> sysctl -w net.ipv6.route.defrtr_table=42
> ip -6 route show table 42

How are the routing tables managed? If the netdevs are connected to a
VRF this just works.




