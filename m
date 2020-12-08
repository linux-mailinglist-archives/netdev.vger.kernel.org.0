Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 140CA2D3336
	for <lists+netdev@lfdr.de>; Tue,  8 Dec 2020 21:27:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731291AbgLHUQK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Dec 2020 15:16:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:33756 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730967AbgLHUMu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 8 Dec 2020 15:12:50 -0500
Date:   Tue, 8 Dec 2020 12:00:15 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1607457617;
        bh=ZVlw7gmDdZD3U7eBLVJndVdY0Lq0XV6auCkNekqtCII=;
        h=From:To:Cc:Subject:In-Reply-To:References:From;
        b=eJ7DUfOEVIlpGPE2c8sZIQv/VzhrwjFCWv+mBWOfpSOa7skcNhh0xC/f+Q18NJhH9
         px5W6pRvQOBLtK6w/EFR2oegSyy75urFOqtbbGUeQ9YLE5SKRNMONPfwk9ZaRyqK6q
         UZMpBRAq7KykuP5FSydQBdHHTr7L1uSZ8OUTnjE8YG+hoYjisb1nwEtGd9YnAPS0nn
         Om3XOAW55G8YYU0d5Zgbzg5FYXP6M/OiPjQkE6haiU6HWY0Kv3gjJ+hPPvtK3PQZCT
         cwbkIh5bpR0VK53+GKYnq60OTVT5TV3oBxIK9od9T0ao9WO2vJmy7rlXITYDQbKSE0
         ylHuakHNseUyQ==
From:   Jakub Kicinski <kuba@kernel.org>
To:     Huazhong Tan <tanhuazhong@huawei.com>
Cc:     <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <salil.mehta@huawei.com>,
        <yisen.zhuang@huawei.com>, <linuxarm@huawei.com>,
        <huangdaode@huawei.com>, <shenjian15@huawei.com>
Subject: Re: [PATCH V2 net-next 0/3] net: hns3: updates for -next
Message-ID: <20201208120015.00cf10a4@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
In-Reply-To: <1607227575-56689-1-git-send-email-tanhuazhong@huawei.com>
References: <1607227575-56689-1-git-send-email-tanhuazhong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 6 Dec 2020 12:06:12 +0800 Huazhong Tan wrote:
> There are some updates for the HNS3 ethernet driver.
> 
> #1 supports an extended promiscuous command which makes
> promiscuous configuration more flexible, #2 adds ethtool
> private flags to control whether enable tx unicast promisc.
> #3 refine the vlan tag handling for port based vlan.

Applied, thanks!
