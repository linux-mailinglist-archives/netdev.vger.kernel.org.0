Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A6821CC4FC
	for <lists+netdev@lfdr.de>; Sun, 10 May 2020 00:38:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728795AbgEIWiB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 May 2020 18:38:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:46270 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726472AbgEIWiB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 9 May 2020 18:38:01 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5B38120A8B;
        Sat,  9 May 2020 22:38:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589063880;
        bh=oYS8pVpHubeMt4zEQd8UsCbdge9BawlUQxDDV0KFlDk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=egFYyFb1Tjbb4GrOWuBSjp7vwxmTL4s1uXvdg9nB2bMRfG/WAw6EeA52jhMpqVHUF
         XECCMGaEILcRfW0grNMzxVQWGdZdJkOfuGdF69XeX9POBHnZp2k4I8TZLu9Shu2xyy
         0Sczu/55o3TMgGYI8wdclfd+eqOTR+ST5BA5lFVA=
Date:   Sat, 9 May 2020 15:37:58 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Luo bin <luobin9@huawei.com>
Cc:     <davem@davemloft.net>, <linux-kernel@vger.kernel.org>,
        <netdev@vger.kernel.org>, <luoxianjun@huawei.com>,
        <yin.yinshi@huawei.com>, <cloud.wangxiaoyun@huawei.com>
Subject: Re: [PATCH net v2] hinic: fix a bug of ndo_stop
Message-ID: <20200509153758.06f6947f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200508201933.5054-1-luobin9@huawei.com>
References: <20200508201933.5054-1-luobin9@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 8 May 2020 20:19:33 +0000 Luo bin wrote:
> if some function in ndo_stop interface returns failure because of
> hardware fault, must go on excuting rest steps rather than return
> failure directly, otherwise will cause memory leak.And bump the
> timeout for SET_FUNC_STATE to ensure that cmd won't return failure
> when hw is busy. Otherwise hw may stomp host memory if we free
> memory regardless of the return value of SET_FUNC_STATE.
> 
> Signed-off-by: Luo bin <luobin9@huawei.com>

Doesn't apply to the net tree:

error: patch failed: drivers/net/ethernet/huawei/hinic/hinic_hw_mgmt.c:353
error: drivers/net/ethernet/huawei/hinic/hinic_hw_mgmt.c: patch does not apply
error: patch failed: drivers/net/ethernet/huawei/hinic/hinic_main.c:504
error: drivers/net/ethernet/huawei/hinic/hinic_main.c: patch does not apply
hint: Use 'git am --show-current-patch' to see the failed patch
Applying: hinic: fix a bug of ndo_stop

Please also include a Fixes tag when you repost.
