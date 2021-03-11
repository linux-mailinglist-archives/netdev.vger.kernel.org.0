Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7300333693E
	for <lists+netdev@lfdr.de>; Thu, 11 Mar 2021 01:51:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229570AbhCKAum (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Mar 2021 19:50:42 -0500
Received: from gateway20.websitewelcome.com ([192.185.65.13]:21778 "EHLO
        gateway20.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229813AbhCKAuW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Mar 2021 19:50:22 -0500
X-Greylist: delayed 1214 seconds by postgrey-1.27 at vger.kernel.org; Wed, 10 Mar 2021 19:50:22 EST
Received: from cm12.websitewelcome.com (cm12.websitewelcome.com [100.42.49.8])
        by gateway20.websitewelcome.com (Postfix) with ESMTP id 2A109400C7B52
        for <netdev@vger.kernel.org>; Wed, 10 Mar 2021 18:21:08 -0600 (CST)
Received: from gator4166.hostgator.com ([108.167.133.22])
        by cmsmtp with SMTP
        id K9DIlUkkXiQiZK9DIlYRXF; Wed, 10 Mar 2021 18:30:04 -0600
X-Authority-Reason: nr=8
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=embeddedor.com; s=default; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:Subject:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=IVp+D5ngPgJh67ftvyE6xrk8nW5+K74JaggZY6ytuHk=; b=xn5E9POAef9bJ+ptTGbDK0Zwwj
        ffMrR++GHjre1gaFyd5b5gc2FVbHGvnt++KhIf6vE+V6Ix3Wn27kvEUFfd3wL024v2XaUKRx+MBtV
        MhWn4CXLLkaMJYS2KuLwfZ9Sqt8hZLvaDMzrLU20Kl/Tm0ss4tBxaPBigQfcURPx/49wkXJDy4DhS
        /I4fmsOZ8scZg8w7ZmxqZElDdtEbxtnbwnjUp4BwfCbieuQX9afayJdy94pO3ufimgPFaZcbD8nLE
        jLtC4FyCLd0fF9HoMxM4MPTau2WWF/CA9dLuTHDIFWV/UPq4wfdG97BerjoQHGXvDGCLVnm4NOHol
        SW8qJMpw==;
Received: from 187-162-31-110.static.axtel.net ([187.162.31.110]:37248 helo=[192.168.15.8])
        by gator4166.hostgator.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.93)
        (envelope-from <gustavo@embeddedor.com>)
        id 1lK9DF-000C5R-8Q; Wed, 10 Mar 2021 18:30:01 -0600
Subject: Re: [PATCH RESEND][next] net: fddi: skfp: smt: Replace one-element
 array with flexible-array member
To:     patchwork-bot+netdevbpf@kernel.org,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org
References: <20210310053020.GA285050@embeddedor>
 <161541001322.4631.9353418857570325428.git-patchwork-notify@kernel.org>
From:   "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Message-ID: <64f31d62-7c2b-dccd-2461-ee07c79a55ab@embeddedor.com>
Date:   Wed, 10 Mar 2021 18:30:00 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <161541001322.4631.9353418857570325428.git-patchwork-notify@kernel.org>
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
X-Exim-ID: 1lK9DF-000C5R-8Q
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: 187-162-31-110.static.axtel.net ([192.168.15.8]) [187.162.31.110]:37248
X-Source-Auth: gustavo@embeddedor.com
X-Email-Count: 16
X-Source-Cap: Z3V6aWRpbmU7Z3V6aWRpbmU7Z2F0b3I0MTY2Lmhvc3RnYXRvci5jb20=
X-Local-Domain: yes
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 3/10/21 15:00, patchwork-bot+netdevbpf@kernel.org wrote:

> This patch was applied to netdev/net-next.git (refs/heads/master):

Thanks for this and for the others!
--
Gustavo
