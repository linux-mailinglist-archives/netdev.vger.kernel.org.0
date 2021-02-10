Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF54131696B
	for <lists+netdev@lfdr.de>; Wed, 10 Feb 2021 15:51:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230160AbhBJOvV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Feb 2021 09:51:21 -0500
Received: from www62.your-server.de ([213.133.104.62]:56236 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229934AbhBJOvU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Feb 2021 09:51:20 -0500
Received: from sslproxy06.your-server.de ([78.46.172.3])
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1l9qp6-0006A6-SW; Wed, 10 Feb 2021 15:50:32 +0100
Received: from [85.7.101.30] (helo=pc-9.home)
        by sslproxy06.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1l9qp6-0001Wp-I3; Wed, 10 Feb 2021 15:50:32 +0100
Subject: Re: [PATCH net-next] net: initialize net->net_cookie at netns setup
To:     Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Lorenz Bauer <lmb@cloudflare.com>
References: <20210210144144.24284-1-eric.dumazet@gmail.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <6e49fb4c-5110-417d-6b2b-3176f609cd7c@iogearbox.net>
Date:   Wed, 10 Feb 2021 15:50:32 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20210210144144.24284-1-eric.dumazet@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.4/26076/Wed Feb 10 13:25:58 2021)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/10/21 3:41 PM, Eric Dumazet wrote:
> From: Eric Dumazet <edumazet@google.com>
> 
> It is simpler to make net->net_cookie a plain u64
> written once in setup_net() instead of looping
> and using atomic64 helpers.
> 
> Lorenz Bauer wants to add SO_NETNS_COOKIE socket option
> and this patch would makes his patch series simpler.
> 
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Cc: Daniel Borkmann <daniel@iogearbox.net>
> Cc: Lorenz Bauer <lmb@cloudflare.com>

Acked-by: Daniel Borkmann <daniel@iogearbox.net>
