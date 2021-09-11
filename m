Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E4764078DC
	for <lists+netdev@lfdr.de>; Sat, 11 Sep 2021 16:38:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231234AbhIKOjJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Sep 2021 10:39:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:44214 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229633AbhIKOjJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 11 Sep 2021 10:39:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5737260FDC;
        Sat, 11 Sep 2021 14:37:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631371076;
        bh=ZssWQoic4PisY8fQmXOLRjIwa7pajjw3kzIi0Ufi/3k=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=A7u4Ht1KPQGsvmyBYLrHZUIUcnqWdXIB10/19PcnoUpbQk5yQEgPZRe805dJgcRSl
         J8PVFTJL4YY4m6rd9Q/SGu6hdFFxiAxxKodv0hoxNxAmW9G0H4EuHzCyf8PlUGfTm8
         zcVifwyPzNBhpatuJxLI1CqFONiUqw7zh5PS39nPPnFYzVAAKxVDTjFO0zw18dff81
         1rCa7i7ExmXsNBQaWbd2lVr/7klFPWIGZSmPc7ns6rT5/H6Rd4bRPi5ebzM5R6uYi9
         Waxcks05SQEbu42/Wc77Gkqx2TbiDKHUZJlDXFkZoP9Zh0bFrXf8kuVsITS43wYb8d
         WAoKDQzDNceng==
Date:   Sat, 11 Sep 2021 10:37:55 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Mat Martineau <mathew.j.martineau@linux.intel.com>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Yonglong Li <liyonglong@chinatelecom.cn>,
        Geliang Tang <geliangtang@gmail.com>,
        "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        mptcp@lists.linux.dev
Subject: Re: [PATCH AUTOSEL 5.14 209/252] mptcp: fix ADD_ADDR and RM_ADDR
 maybe flush addr_signal each other
Message-ID: <YTy/Q//PQjz6c4Ip@sashalap>
References: <20210909114106.141462-1-sashal@kernel.org>
 <20210909114106.141462-209-sashal@kernel.org>
 <3a6c39db-8aca-b64b-51db-cd1544daf9dc@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <3a6c39db-8aca-b64b-51db-cd1544daf9dc@linux.intel.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 09, 2021 at 03:33:02PM -0700, Mat Martineau wrote:
>
>On Thu, 9 Sep 2021, Sasha Levin wrote:
>
>>From: Yonglong Li <liyonglong@chinatelecom.cn>
>>
>>[ Upstream commit 119c022096f5805680c79dfa74e15044c289856d ]
>>
>>ADD_ADDR shares pm.addr_signal with RM_ADDR, so after RM_ADDR/ADD_ADDR
>>has done, we should not clean ADD_ADDR/RM_ADDR's addr_signal.
>>
>>Co-developed-by: Geliang Tang <geliangtang@gmail.com>
>>Signed-off-by: Geliang Tang <geliangtang@gmail.com>
>>Signed-off-by: Yonglong Li <liyonglong@chinatelecom.cn>
>>Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
>>Signed-off-by: David S. Miller <davem@davemloft.net>
>>Signed-off-by: Sasha Levin <sashal@kernel.org>
>>---
>>net/mptcp/pm.c | 13 ++++++++++---
>>1 file changed, 10 insertions(+), 3 deletions(-)
>
>Hi Sasha,
>
>This patch is part of a 5-patch series, and was not intended for 
>backporting. Please drop the patch from all stable branches.

Dropped, thanks!

-- 
Thanks,
Sasha
