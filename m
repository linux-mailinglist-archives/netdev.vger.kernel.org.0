Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A181626D08
	for <lists+netdev@lfdr.de>; Wed, 22 May 2019 21:39:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733298AbfEVTjA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 May 2019 15:39:00 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:40472 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731503AbfEVT3o (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 May 2019 15:29:44 -0400
Received: by mail-pg1-f195.google.com with SMTP id d30so1806654pgm.7;
        Wed, 22 May 2019 12:29:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=N1lt5YyedYDYRxDOevOGqSo7gsUd5bOy8cykHjsLtD4=;
        b=bY2LHNLCRmlqE7LZ2ALn4Q1gh+SLFN3JLiF2C7Ru1QyZWI8hRcAfSxfGENzxsOGd9X
         6ReaQDGqY3unNPurFzVA3zpBAQGilVoYCMiZXEWqkWIyI5/h8y92antbZieW37hZGXlL
         s2xqlbVdokYNc5NtaVdB0hxtLUZQDYvrujL6SjXophticu47GzYEFA2YljihX75dHsp5
         EwLod7515r5VerNSBs+o2zTOEf3Q2Z64i8umWxxQj8EOGhyWocqyIXHSC0xQqLI6IWx1
         skdMPrx2Kq1wSG7FmqrTadMHXkHOs0l59PDpeUltrH2bIFhzgui5wPxUX84bKue8CIGa
         w68A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=N1lt5YyedYDYRxDOevOGqSo7gsUd5bOy8cykHjsLtD4=;
        b=BzQ42hys0EmVlTeUrzyy6YHOOkxD2Va2lncI4vmic0QwVRVAF2LPSLvsQw2CsrFokT
         GT/Rk8MVJ5FsQLjcFtCxEV9dDWIWYW6mcRBnLM9enZ7olFcR+nF60I3wBtYFlEXMFdJQ
         l69+qVObPuOFPKTJaJnni12dAdhoChLc2IH87C+UOf8SfhQm65784F2MGYpbjiRrCUwA
         SDZT2l3RwWHWM+A3SeZCNnTc0c9HVSkH1Ng/d35l88KyYkGWIsDj/QTV7Oivbb+1c+/d
         1zbQhjTIVzvMxjmxqjhIctWEAIRtNYnMHkaNkxA1lnhH9bSpPFSBuu/1Xy8WLniVcY5J
         a3vA==
X-Gm-Message-State: APjAAAW9J38MbzS4r9FWVDvBTkRSlOGk6X4PxsYKcL8qXEwmUlVp8kmp
        ch2FS8tHal9gou+eghEKZWiH+7Uy
X-Google-Smtp-Source: APXvYqzEfaOkdYrAL9gJoOJDFyg+POabiHIwhe6pRwJkDrCakMPc5mlZ+G9QyXHGTSMVI1JnZQ5BUQ==
X-Received: by 2002:a63:cf01:: with SMTP id j1mr87053467pgg.97.1558553383396;
        Wed, 22 May 2019 12:29:43 -0700 (PDT)
Received: from ?IPv6:2601:282:800:fd80:f892:82c5:66c:c52c? ([2601:282:800:fd80:f892:82c5:66c:c52c])
        by smtp.googlemail.com with ESMTPSA id 85sm35545612pgb.52.2019.05.22.12.29.41
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 22 May 2019 12:29:42 -0700 (PDT)
Subject: Re: [PATCH AUTOSEL 4.19 077/244] mlxsw: spectrum_router: Prevent ipv6
 gateway with v4 route via replace and append
To:     Sasha Levin <sashal@kernel.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Cc:     "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org
References: <20190522192630.24917-1-sashal@kernel.org>
 <20190522192630.24917-77-sashal@kernel.org>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <2fbc186d-3ec6-f3d1-a3aa-cf9b36b2fd88@gmail.com>
Date:   Wed, 22 May 2019 13:29:41 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:52.0)
 Gecko/20100101 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <20190522192630.24917-77-sashal@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/22/19 1:23 PM, Sasha Levin wrote:
> From: David Ahern <dsahern@gmail.com>
> 
> [ Upstream commit 7973d9e76727aa42f0824f5569e96248a572d50b ]
> 
> mlxsw currently does not support v6 gateways with v4 routes. Commit
> 19a9d136f198 ("ipv4: Flag fib_info with a fib_nh using IPv6 gateway")
> prevents a route from being added, but nothing stops the replace or
> append. Add a catch for them too.
>     $ ip  ro add 172.16.2.0/24 via 10.99.1.2
>     $ ip  ro replace 172.16.2.0/24 via inet6 fe80::202:ff:fe00:b dev swp1s0
>     Error: mlxsw_spectrum: IPv6 gateway with IPv4 route is not supported.
>     $ ip  ro append 172.16.2.0/24 via inet6 fe80::202:ff:fe00:b dev swp1s0
>     Error: mlxsw_spectrum: IPv6 gateway with IPv4 route is not supported.
> 
> Signed-off-by: David Ahern <dsahern@gmail.com>
> Signed-off-by: David S. Miller <davem@davemloft.net>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>  drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c | 2 ++
>  1 file changed, 2 insertions(+)

This patch is not needed for any release prior to 5.2.

IPv6 nexthops with an IPv4 route is a 5.2 feature.

