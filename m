Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ABA555A75B
	for <lists+netdev@lfdr.de>; Sat, 29 Jun 2019 01:03:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726791AbfF1XDk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jun 2019 19:03:40 -0400
Received: from mail-io1-f68.google.com ([209.85.166.68]:46319 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726563AbfF1XDj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Jun 2019 19:03:39 -0400
Received: by mail-io1-f68.google.com with SMTP id i10so2084345iol.13
        for <netdev@vger.kernel.org>; Fri, 28 Jun 2019 16:03:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=bEJtEj7081MHo82AwTAmIk+tEAZMBQNViYUUZdRFqBo=;
        b=QiRWpY29vpP6HzKs0fPFKylB25xyfqd+/LTcAjVkpyLRRyuTVsMmdboiRvlRMG1d3z
         BMu51tzsJgm93RiQ3hGTDRby4HZBmfkshqhPsiXOJQpc89R5Doco4MNjUPdtjneX9lPA
         wOWhu9/mxKVEE0HiclN+z7T/HVrXZpNLsyPvdQu0lb85hsbxi09eR+bxZYNUVrhF1VtL
         CdNf0+6cZkBYWRXaKrWR0gCjRcWLZHpkk80JlakTRWOA0Y/E2nU+AWdqIESm3tbhJIZX
         R8D+NaQ99n3hNgTppiGV20gWMs7gdKTRpWjGNnK5Rno5wdzRIMMcybA6o2uOU5HSLQH0
         CkkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=bEJtEj7081MHo82AwTAmIk+tEAZMBQNViYUUZdRFqBo=;
        b=R8Sb6lRKM+biv1vD//p68ImJlK8JTKyz2RNcdR5SUY9WWkKjRLPr9TcUw/uFcAinwd
         sIzLDtE+JRfjssImXmenlYC2aFdtMEVvdH1bYDTs98Qh4/pd+m7X3M9HAU3OEwbLGH5q
         aLXouSO6RoDVgMvba7vRaEXVG4claexemyw1xxIcxWPx67fLl82ylq3fuhbx7RSqnwE2
         4T9wuECgPMb1NCpM0Ggn9gJeTLn5idlBQaWmAC8Wic81p9RqDUKdIBexd8/x2pyiNPJG
         II406h6LxSzocqI6yjqQyf2M6OqHBvZ8KAFXM93uLPlxjk0LneI+X7qf49UWbP/4SzcM
         5j+g==
X-Gm-Message-State: APjAAAUf2/TMIzOTR1hBtjHRWwcz4AvBQ/RzXcYDPzBgiVvpZ5P/ZopL
        yNUKan9GODpsGV4umf2YRRQcflAp
X-Google-Smtp-Source: APXvYqyOmCffAryr+Zk4P7T6ym84rEjLviMX4jmG2JLRtDF5Fzze8Zy7mVnK0xaGSMmCROo1dGw+eA==
X-Received: by 2002:a5d:9643:: with SMTP id d3mr14203066ios.227.1561763019156;
        Fri, 28 Jun 2019 16:03:39 -0700 (PDT)
Received: from ?IPv6:2601:282:800:fd80:a468:85d6:9e2b:8578? ([2601:282:800:fd80:a468:85d6:9e2b:8578])
        by smtp.googlemail.com with ESMTPSA id s6sm2719225ioo.31.2019.06.28.16.03.37
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 28 Jun 2019 16:03:37 -0700 (PDT)
Subject: Re: [iproute2-next v6] tipc: support interface name when activating
 UDP bearer
To:     Hoang Le <hoang.h.le@dektech.com.au>, dsahern@gmail.com,
        jon.maloy@ericsson.com, maloy@donjonn.com, ying.xue@windriver.com,
        netdev@vger.kernel.org, tipc-discussion@lists.sourceforge.net
References: <20190625043439.6691-1-hoang.h.le@dektech.com.au>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <c9f82d53-9908-088d-7d42-a2acb01655b8@gmail.com>
Date:   Fri, 28 Jun 2019 17:03:36 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:52.0)
 Gecko/20100101 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <20190625043439.6691-1-hoang.h.le@dektech.com.au>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/24/19 10:34 PM, Hoang Le wrote:
> Support for indicating interface name has an ip address in parallel
> with specifying ip address when activating UDP bearer.
> This liberates the user from keeping track of the current ip address
> for each device.
> 
> Old command syntax:
> $tipc bearer enable media udp name NAME localip IP
> 
> New command syntax:
> $tipc bearer enable media udp name NAME [localip IP|dev DEVICE]
> 
> v2:
>     - Removed initial value for fd
>     - Fixed the returning value for cmd_bearer_validate_and_get_addr
>       to make its consistent with using: zero or non-zero
> v3: - Switch to use helper 'get_ifname' to retrieve interface name
> v4: - Replace legacy SIOCGIFADDR by netlink
> v5: - Fix leaky rtnl_handle
> 
> Acked-by: Ying Xue <ying.xue@windriver.com>
> Signed-off-by: Hoang Le <hoang.h.le@dektech.com.au>
> ---
>  tipc/bearer.c | 94 ++++++++++++++++++++++++++++++++++++++++++++++++---
>  1 file changed, 89 insertions(+), 5 deletions(-)
> 

applied to iproute2-next. Thanks


