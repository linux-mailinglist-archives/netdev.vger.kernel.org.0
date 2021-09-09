Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 29432405F9D
	for <lists+netdev@lfdr.de>; Fri, 10 Sep 2021 00:33:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240907AbhIIWeb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Sep 2021 18:34:31 -0400
Received: from mga12.intel.com ([192.55.52.136]:61387 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1346632AbhIIWeY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 9 Sep 2021 18:34:24 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10102"; a="200455911"
X-IronPort-AV: E=Sophos;i="5.85,281,1624345200"; 
   d="scan'208";a="200455911"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Sep 2021 15:33:03 -0700
X-IronPort-AV: E=Sophos;i="5.85,281,1624345200"; 
   d="scan'208";a="470280978"
Received: from jabusaid-mobl.amr.corp.intel.com ([10.255.231.212])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Sep 2021 15:33:03 -0700
Date:   Thu, 9 Sep 2021 15:33:02 -0700 (PDT)
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     Sasha Levin <sashal@kernel.org>
cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Yonglong Li <liyonglong@chinatelecom.cn>,
        Geliang Tang <geliangtang@gmail.com>,
        "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        mptcp@lists.linux.dev
Subject: Re: [PATCH AUTOSEL 5.14 209/252] mptcp: fix ADD_ADDR and RM_ADDR
 maybe flush addr_signal each other
In-Reply-To: <20210909114106.141462-209-sashal@kernel.org>
Message-ID: <3a6c39db-8aca-b64b-51db-cd1544daf9dc@linux.intel.com>
References: <20210909114106.141462-1-sashal@kernel.org> <20210909114106.141462-209-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII; format=flowed
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On Thu, 9 Sep 2021, Sasha Levin wrote:

> From: Yonglong Li <liyonglong@chinatelecom.cn>
>
> [ Upstream commit 119c022096f5805680c79dfa74e15044c289856d ]
>
> ADD_ADDR shares pm.addr_signal with RM_ADDR, so after RM_ADDR/ADD_ADDR
> has done, we should not clean ADD_ADDR/RM_ADDR's addr_signal.
>
> Co-developed-by: Geliang Tang <geliangtang@gmail.com>
> Signed-off-by: Geliang Tang <geliangtang@gmail.com>
> Signed-off-by: Yonglong Li <liyonglong@chinatelecom.cn>
> Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
> Signed-off-by: David S. Miller <davem@davemloft.net>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
> net/mptcp/pm.c | 13 ++++++++++---
> 1 file changed, 10 insertions(+), 3 deletions(-)

Hi Sasha,

This patch is part of a 5-patch series, and was not intended for 
backporting. Please drop the patch from all stable branches.


Thanks!

--
Mat Martineau
Intel
