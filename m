Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1525539493D
	for <lists+netdev@lfdr.de>; Sat, 29 May 2021 01:48:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229565AbhE1Xtz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 May 2021 19:49:55 -0400
Received: from gateway33.websitewelcome.com ([192.185.145.216]:47754 "EHLO
        gateway33.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229528AbhE1Xty (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 May 2021 19:49:54 -0400
Received: from cm12.websitewelcome.com (cm12.websitewelcome.com [100.42.49.8])
        by gateway33.websitewelcome.com (Postfix) with ESMTP id B736E1CB31EC
        for <netdev@vger.kernel.org>; Fri, 28 May 2021 18:48:18 -0500 (CDT)
Received: from gator4166.hostgator.com ([108.167.133.22])
        by cmsmtp with SMTP
        id mmDClEucaDedfmmDClM4Hx; Fri, 28 May 2021 18:48:18 -0500
X-Authority-Reason: nr=8
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=embeddedor.com; s=default; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:Subject:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=vNQAzILdbaZu9okTXrz7fEO5v+nZNI9nvkwtVw4o0fY=; b=I+j9lY1HbRn/FuPEjpErp3B7y7
        IxhoVDmu6VlspIfxw/S2ZHW4TQT5ZBd0eFgfn9S5yf/XddlDkMZvjjrWRU/poTGRZ8eNU9l7LQKDR
        D6Qye4wUALHxGs/MqcoQG+D+xlZekggSR2lqPWSU2uRWoFXurzQubCJiPp3yx3CnxzE1BQ7K4cKsi
        VyhUFzjwOHJ7fvXJdhwnJ6+ktEgyvgTnesb3DIzoB+UbNf/7/91l24zFqubJ2QAocq5/NaV2VECU2
        1swT1rv9zcGY9E6GIf5FI7byh4RAECiO6qaRnBCapnSZk5TCFxOeh92Dw/p1szTbG0liJz8mdKAkh
        /qP//7NA==;
Received: from 187-162-31-110.static.axtel.net ([187.162.31.110]:39272 helo=[192.168.15.8])
        by gator4166.hostgator.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.94.2)
        (envelope-from <gustavo@embeddedor.com>)
        id 1lmmD9-003mDh-4r; Fri, 28 May 2021 18:48:15 -0500
Subject: Re: [PATCH][next] r8169: Fix fall-through warning for Clang
To:     patchwork-bot+netdevbpf@kernel.org,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>
Cc:     hkallweit1@gmail.com, davem@davemloft.net, kuba@kernel.org,
        nic_swsd@realtek.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org
References: <20210528202327.GA39994@embeddedor>
 <162224100360.24905.9240842444695928219.git-patchwork-notify@kernel.org>
From:   "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Message-ID: <9565938f-ebf9-ead0-4feb-87744caa7abf@embeddedor.com>
Date:   Fri, 28 May 2021 18:49:12 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <162224100360.24905.9240842444695928219.git-patchwork-notify@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - gator4166.hostgator.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - embeddedor.com
X-BWhitelist: no
X-Source-IP: 187.162.31.110
X-Source-L: No
X-Exim-ID: 1lmmD9-003mDh-4r
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: 187-162-31-110.static.axtel.net ([192.168.15.8]) [187.162.31.110]:39272
X-Source-Auth: gustavo@embeddedor.com
X-Email-Count: 14
X-Source-Cap: Z3V6aWRpbmU7Z3V6aWRpbmU7Z2F0b3I0MTY2Lmhvc3RnYXRvci5jb20=
X-Local-Domain: yes
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/28/21 17:30, patchwork-bot+netdevbpf@kernel.org wrote:
> Hello:
> 
> This patch was applied to netdev/net-next.git (refs/heads/master):
> 
> On Fri, 28 May 2021 15:23:27 -0500 you wrote:
>> In preparation to enable -Wimplicit-fallthrough for Clang, fix a warning
>> by explicitly adding a break statement instead of letting the code fall
>> through to the next case.
>>
>> Link: https://github.com/KSPP/linux/issues/115
>> Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
>>
>> [...]
> 
> Here is the summary with links:
>   - [next] r8169: Fix fall-through warning for Clang
>     https://git.kernel.org/netdev/net-next/c/ffb35c679842

Awesome. :)

Thanks Heiner and Jakub.
--
Gustavo
