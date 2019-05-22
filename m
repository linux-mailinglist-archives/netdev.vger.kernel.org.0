Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 214FE26E2B
	for <lists+netdev@lfdr.de>; Wed, 22 May 2019 21:47:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387613AbfEVTqo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 May 2019 15:46:44 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:39979 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732380AbfEVT1p (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 May 2019 15:27:45 -0400
Received: by mail-pf1-f194.google.com with SMTP id u17so1835130pfn.7;
        Wed, 22 May 2019 12:27:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=6HMpFkYMLAkJcnVu/PqYynDR+iNuf0Dhku5h2gLjvOk=;
        b=p6eYoj7X129vSeuFFybTFfzZFwJjIRgE1o2MFLjWEL4dDUC8AOFzc8M82xgTFh2PGg
         qZPoEGurlVnGRRA6IGQ1fRItBghPRbkwei9a3OVtmevX6D70IqGZjWeE+/TMGdIcn4/D
         M+2dKrktd0yUIvGmGDyCks1w1o2klhVIbD6/eYtuEpSxoYiUzYuB/vNq0tMVBb7vFCsf
         QVcKplC3uQ+0YmZy7WdCxRKe+J450QxSqmMrUtamjTcfngLc/CL4vyHbsnbiogU0s6xo
         hha5oDSA/zJJ0ctY+B48By+45LFen3dgF7BnOEma1xx8I7DyLL41ePFwewxMZYM0ClRO
         GQ7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=6HMpFkYMLAkJcnVu/PqYynDR+iNuf0Dhku5h2gLjvOk=;
        b=AaYIQEdKmpm8Jw75bYE1JUDSCuLcJ3WV/HAWWaXlo7nH6QFcwX5ivqZvISzzZf5dVn
         lePN70DmN7KytyBKo5oDpC7VPEphZwsddMgETsc2KcCHOR0BHkAvsvdGQsG2AkTJE7cY
         YeS2NGYIUNxX4PLwqZKUWySpnAZRfajejM8bTeLr9StWMxLg+MZiZWqjdBPPrOmxGtET
         ox/CfDwlmm+HRD1zvjgpaL+UcYzZ5Ft1e1axLFuHgKV64Rgimf30RjVwqfT9Pd+pVcn0
         wNsfHr9Xg8TCAtxxclGH1CtD9NspIatJ01OBWVhiUcta7D4aWDLOTSr92hlSwjRq8VyG
         Drow==
X-Gm-Message-State: APjAAAWQeWnQbtrFkVSs/YJO3TFKVi0j0Wx/wX2nxijqptJCOQEIsfBd
        oh0ksuSqWtOnwSQeESzS0P2YhweC
X-Google-Smtp-Source: APXvYqy0+W6pCtcQ81NLeFLQ34/AenkcgMa4SwKkkt1YemhDIVil3IDNXhAoy1wgnKjNjU5wTtCW3Q==
X-Received: by 2002:a63:465b:: with SMTP id v27mr91368935pgk.38.1558553263948;
        Wed, 22 May 2019 12:27:43 -0700 (PDT)
Received: from ?IPv6:2601:282:800:fd80:f892:82c5:66c:c52c? ([2601:282:800:fd80:f892:82c5:66c:c52c])
        by smtp.googlemail.com with ESMTPSA id u20sm33577328pfm.145.2019.05.22.12.27.42
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 22 May 2019 12:27:43 -0700 (PDT)
Subject: Re: [PATCH AUTOSEL 5.0 095/317] mlxsw: spectrum_router: Prevent ipv6
 gateway with v4 route via replace and append
To:     Sasha Levin <sashal@kernel.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Cc:     "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org
References: <20190522192338.23715-1-sashal@kernel.org>
 <20190522192338.23715-95-sashal@kernel.org>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <a953cd53-c396-f20d-73b4-9e06ada0e3ad@gmail.com>
Date:   Wed, 22 May 2019 13:27:41 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:52.0)
 Gecko/20100101 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <20190522192338.23715-95-sashal@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/22/19 1:19 PM, Sasha Levin wrote:
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
> 

Not needed for 5.0. IPv6 nexthops with an IPv4 gateway is a 5.2 feature.
