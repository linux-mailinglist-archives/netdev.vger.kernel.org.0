Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 526A0381B17
	for <lists+netdev@lfdr.de>; Sat, 15 May 2021 22:50:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234993AbhEOUwB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 15 May 2021 16:52:01 -0400
Received: from gateway31.websitewelcome.com ([192.185.143.36]:28866 "EHLO
        gateway31.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234997AbhEOUv4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 15 May 2021 16:51:56 -0400
Received: from cm13.websitewelcome.com (cm13.websitewelcome.com [100.42.49.6])
        by gateway31.websitewelcome.com (Postfix) with ESMTP id 2B38D61294
        for <netdev@vger.kernel.org>; Sat, 15 May 2021 15:50:39 -0500 (CDT)
Received: from gator4166.hostgator.com ([108.167.133.22])
        by cmsmtp with SMTP
        id i1F9lEJrgAEP6i1F9lrgpN; Sat, 15 May 2021 15:50:39 -0500
X-Authority-Reason: nr=8
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=embeddedor.com; s=default; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:Subject:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=sDv7533fJ1Jh0SB9Oldb7u8J3ATKjHKiiLr7bcd/BjU=; b=aNK6UN5jnEUebgHmWXzHpHApMK
        LATBBxaW6BNJof+vibX4Esr+yDsu/EQJTK8XqhOALEoIwNE4FUhHt+RwuvhhzhSsW+fsoUnbb+I3X
        nKdnM4ces1ohCsIIR8RILuqhDxTrmccUNY5zttUdslURgdFZNAawokwQAa6dKEfKzaHJbj/+Dp6Kq
        X+ImYvl2WGpQxyMUVBp6go2ZZn8cUt+wXgATik6JmB946foKmOzqIqyCPyZKMUGudk4Cnfysm6ZaU
        uye3Yg3LNePTromt9hKbn0uq4+MSi8wCLm72qPAQs7bWAojEuI43ZOrV61/VkvZks1RGWSTLsEMA4
        QhNWP2TQ==;
Received: from 187-162-31-110.static.axtel.net ([187.162.31.110]:47424 helo=[192.168.15.8])
        by gator4166.hostgator.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.94.2)
        (envelope-from <gustavo@embeddedor.com>)
        id 1li1F4-0005hh-WA; Sat, 15 May 2021 15:50:35 -0500
Subject: Re: [PATCH][next] ceph: Replace zero-length array with flexible array
 member
To:     Ilya Dryomov <idryomov@gmail.com>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>
Cc:     Jeff Layton <jlayton@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Ceph Development <ceph-devel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-hardening@vger.kernel.org
References: <20210514215209.GA33310@embeddedor>
 <CAOi1vP8NARpXVsK2AVOZ4_m58gXMKVQSi_okZVcrLsew1nLizg@mail.gmail.com>
From:   "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Message-ID: <e1b6364c-e73e-fdc8-1fc0-9f35b181c288@embeddedor.com>
Date:   Sat, 15 May 2021 15:50:44 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <CAOi1vP8NARpXVsK2AVOZ4_m58gXMKVQSi_okZVcrLsew1nLizg@mail.gmail.com>
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
X-Exim-ID: 1li1F4-0005hh-WA
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: 187-162-31-110.static.axtel.net ([192.168.15.8]) [187.162.31.110]:47424
X-Source-Auth: gustavo@embeddedor.com
X-Email-Count: 7
X-Source-Cap: Z3V6aWRpbmU7Z3V6aWRpbmU7Z2F0b3I0MTY2Lmhvc3RnYXRvci5jb20=
X-Local-Domain: yes
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/15/21 05:42, Ilya Dryomov wrote:
> 
> Hi Gustavo,
> 
> I went ahead and removed reply_buf.  We never receive authorizer
> replies in auth_none mode, so patching it to be a flexible array
> is rather pointless.

Sounds great. :)

Thanks, Ilya.
--
Gustavo
