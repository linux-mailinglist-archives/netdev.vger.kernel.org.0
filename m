Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA3F03234CA
	for <lists+netdev@lfdr.de>; Wed, 24 Feb 2021 02:20:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231143AbhBXA4R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Feb 2021 19:56:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:59316 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234982AbhBXAbM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 23 Feb 2021 19:31:12 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E24D764DAF;
        Tue, 23 Feb 2021 23:46:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614123969;
        bh=YpnspKf25v9kzFrBwfaJ6e6sH4o+qxbqGQg+T9/x7J0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=saEOfLk6BF5SgtZzQzfxddA2ZW4SVPmT0VuNs3Iy8EVEEvMj0A2S0wKfKMXtNT0IG
         0jTvBSndMVZfLJcrPfSE93UETOLfdSsnxT7qR2F7BvHpHPSqhnmzO2pmlMDKR5LLKH
         9LN5qswjsPGWpuVrRl0a3ayoHtW3GnA/UngUFzFbrbqI8uw1gN6ACXN7ecQyQNl/zX
         Tt66phBbx0L85+fqLm3uQAzK72IcEBPKTJHzHTliQGdYAoLR72a+sPiImD6lSDktjg
         Ko+SaKyWu0fNSleXOkWTzhwlkF8EmBYsOLuICfxwrKk65WWUzZQg7+M9LxK27s/YUX
         LaiR3eQU45lTg==
Date:   Tue, 23 Feb 2021 15:46:05 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Yang Li <yang.lee@linux.alibaba.com>
Cc:     mpe@ellerman.id.au, benh@kernel.crashing.org, paulus@samba.org,
        cforno12@linux.ibm.com, davem@davemloft.net,
        linuxppc-dev@lists.ozlabs.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ibmveth: Switch to using the new API kobj_to_dev()
Message-ID: <20210223154605.3a658f4a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <1613980941-45992-1-git-send-email-yang.lee@linux.alibaba.com>
References: <1613980941-45992-1-git-send-email-yang.lee@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 22 Feb 2021 16:02:21 +0800 Yang Li wrote:
> fixed the following coccicheck:
> ./drivers/net/ethernet/ibm/ibmveth.c:1805:51-52: WARNING opportunity for
> kobj_to_dev()
> 
> Reported-by: Abaci Robot <abaci@linux.alibaba.com>
> Signed-off-by: Yang Li <yang.lee@linux.alibaba.com>

# Form letter - net-next is closed

We have already sent the networking pull request for 5.12 and therefore
net-next is closed for new drivers, features, code refactoring and
optimizations. We are currently accepting bug fixes only.

Please repost when net-next reopens after 5.12-rc1 is cut.

Look out for the announcement on the mailing list or check:
http://vger.kernel.org/~davem/net-next.html

RFC patches sent for review only are obviously welcome at any time.
