Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 585A93DDFD7
	for <lists+netdev@lfdr.de>; Mon,  2 Aug 2021 21:07:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229677AbhHBTHr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Aug 2021 15:07:47 -0400
Received: from gateway22.websitewelcome.com ([192.185.47.168]:49284 "EHLO
        gateway22.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229537AbhHBTHq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Aug 2021 15:07:46 -0400
X-Greylist: delayed 1423 seconds by postgrey-1.27 at vger.kernel.org; Mon, 02 Aug 2021 15:07:46 EDT
Received: from cm16.websitewelcome.com (cm16.websitewelcome.com [100.42.49.19])
        by gateway22.websitewelcome.com (Postfix) with ESMTP id 97DF49356
        for <netdev@vger.kernel.org>; Mon,  2 Aug 2021 13:43:29 -0500 (CDT)
Received: from gator4166.hostgator.com ([108.167.133.22])
        by cmsmtp with SMTP
        id AcuPmHaQnjSwzAcuPmq7qk; Mon, 02 Aug 2021 13:43:29 -0500
X-Authority-Reason: nr=8
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=embeddedor.com; s=default; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:Subject:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=8InOL0ejiLyEWxVwkpX8eoucd2mZJBACbDxgmHEzhOQ=; b=mXWctaOzd7dzUuPAn2aONxs6zB
        lUstrMJu7NbagAng6LNdnkXEAmwi4teiwaRfl4UlADHBBpbDzU3CtkzCyrFe73oxSZGkuDohYR2UC
        KsvwbFiY02wbmqP0R8HT1MTtWNWwANFFBH13dnEFxBKTuTUxBQHUyoBjDFLi58CLYebvt2YZMoVFq
        3ec/7rgnQ82F6vKDWziQhZWeQDI9O979COBvEq5VnLv1Dq0ClbrtGN/21fEJHx8T7XkT9A46aelK+
        nXqaiTpkqWa4Sl80osGgcsfNfbefTkOQbL+Uopr8BGlYjKiuPM7D/K+SZqh5rSSOn04RTwnogSBE3
        IbGxyIKg==;
Received: from 187-162-31-110.static.axtel.net ([187.162.31.110]:57258 helo=[192.168.15.8])
        by gator4166.hostgator.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.94.2)
        (envelope-from <gustavo@embeddedor.com>)
        id 1mAcuP-003Q28-2T; Mon, 02 Aug 2021 13:43:29 -0500
Subject: Re: [PATCH][next] net/ipv4: Replace one-element array with
 flexible-array member
To:     patchwork-bot+netdevbpf@kernel.org,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>
Cc:     davem@davemloft.net, kuba@kernel.org, yoshfuji@linux-ipv6.org,
        dsahern@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org
References: <20210731170830.GA48844@embeddedor>
 <162791400741.18419.5941105433257893840.git-patchwork-notify@kernel.org>
From:   "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Message-ID: <6d3c2ba1-ea01-dbc1-1e18-1ba9c7a15181@embeddedor.com>
Date:   Mon, 2 Aug 2021 13:46:08 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <162791400741.18419.5941105433257893840.git-patchwork-notify@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - gator4166.hostgator.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - embeddedor.com
X-BWhitelist: no
X-Source-IP: 187.162.31.110
X-Source-L: No
X-Exim-ID: 1mAcuP-003Q28-2T
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: 187-162-31-110.static.axtel.net ([192.168.15.8]) [187.162.31.110]:57258
X-Source-Auth: gustavo@embeddedor.com
X-Email-Count: 7
X-Source-Cap: Z3V6aWRpbmU7Z3V6aWRpbmU7Z2F0b3I0MTY2Lmhvc3RnYXRvci5jb20=
X-Local-Domain: yes
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 8/2/21 09:20, patchwork-bot+netdevbpf@kernel.org wrote:
> Hello:
> 
> This patch was applied to netdev/net-next.git (refs/heads/master):
> 
> On Sat, 31 Jul 2021 12:08:30 -0500 you wrote:
>> There is a regular need in the kernel to provide a way to declare having
>> a dynamically sized set of trailing elements in a structure. Kernel code
>> should always use “flexible array members”[1] for these cases. The older
>> style of one-element or zero-length arrays should no longer be used[2].
>>
>> Use an anonymous union with a couple of anonymous structs in order to
>> keep userspace unchanged:
>>
>> [...]
> 
> Here is the summary with links:
>   - [next] net/ipv4: Replace one-element array with flexible-array member
>     https://git.kernel.org/netdev/net-next/c/2d3e5caf96b9

arghh... this has a bug. Sorry, Dave. I will send a fix for this, shortly.

--
Gustavo
