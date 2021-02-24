Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CDD59324468
	for <lists+netdev@lfdr.de>; Wed, 24 Feb 2021 20:10:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235997AbhBXTJ1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Feb 2021 14:09:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:39974 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235923AbhBXTIx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 24 Feb 2021 14:08:53 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 764CA64D8F;
        Wed, 24 Feb 2021 18:55:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614192901;
        bh=Y9mdxkICHrBBGcay0H/okt4UecLOm6LUT1wvRzqBtos=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=sWr+TWuLIoQB01ILUU1TiOrsaDLnfyduLz2kO3+w7gEqoTxlRQU8d+aXt9Ogp1EHC
         CgIrmwnge/y2fJdM4zexPrKeMNt4m39PtOOOowt8Zo8Bem7opGH6bp9lmXafoxuMuF
         TXjDWvTuDP+S4f3O4ng7X7nN81m4CHDqRdZOScrF9B5aOx+XRFJUxyVYuHcYVej3Z1
         Qt8USoJxsx758NCmer69FL4pUzRUTb+0quO5qyOAIq+xk3caYmwUfP7w1aafuWqE/q
         VmTWi0WaLpUkqEMhE283gKbVQ/JegAyyEqQCoZsB4hvCkhdGWcCU1QfRidG3WihmMQ
         9SlUA3cR6vRUg==
Date:   Wed, 24 Feb 2021 10:54:58 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Kefeng Wang <wangkefeng.wang@huawei.com>
Cc:     Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] net: bridge: Fix jump_label config
Message-ID: <20210224105458.091842fa@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210224153803.91194-1-wangkefeng.wang@huawei.com>
References: <20210224153803.91194-1-wangkefeng.wang@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 24 Feb 2021 23:38:03 +0800 Kefeng Wang wrote:
> HAVE_JUMP_LABLE is removed by commit e9666d10a567 ("jump_label: move
> 'asm goto' support test to Kconfig"), use CONFIG_JUMP_LABLE instead
> of HAVE_JUMP_LABLE.
> 
> Fixes: 971502d77faa ("bridge: netfilter: unroll NF_HOOK helper in bridge input path")
> Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>

You need to CC the authors of the commit you're blaming. Please make
use of scripts/get_maintainers.pl and repost.
