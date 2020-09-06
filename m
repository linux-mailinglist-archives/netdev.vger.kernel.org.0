Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D0E3F25F006
	for <lists+netdev@lfdr.de>; Sun,  6 Sep 2020 21:10:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726259AbgIFTKL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 6 Sep 2020 15:10:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:40224 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725773AbgIFTKK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 6 Sep 2020 15:10:10 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 90BF32080A;
        Sun,  6 Sep 2020 19:10:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599419410;
        bh=b2hffITCQLHVhSCzjb+Yhuwv2ukX2lqF/tVgU+8ruBw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Pr+DXxLfs4uVqqdJ3J2q85QUhBumPL2DGZZl3vnDNBbq1MXqkQObO3/IEmDux7i/X
         zmAI9pq7UfNwQrXFNmCUPL2DZ4LDucdhdk3gqJ9n8QVLGvoiD8BKZbJW6ZQQjnuOph
         uVrGJm3Lw3vMz0Cgs7UfwvanlEgwKBaA2OHKXK1s=
Date:   Sun, 6 Sep 2020 12:10:07 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Miaohe Lin <linmiaohe@huawei.com>
Cc:     <davem@davemloft.net>, <steffen.klassert@secunet.com>,
        <willemb@google.com>, <mstarovoitov@marvell.com>,
        <mchehab+huawei@kernel.org>, <antoine.tenart@bootlin.com>,
        <edumazet@google.com>, <Jason@zx2c4.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] net: Fix some comments
Message-ID: <20200906121007.60e278e8@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200905091448.48165-1-linmiaohe@huawei.com>
References: <20200905091448.48165-1-linmiaohe@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 5 Sep 2020 05:14:48 -0400 Miaohe Lin wrote:
> Since commit 8d7017fd621d ("blackhole_netdev: use blackhole_netdev to
> invalidate dst entries"), we use blackhole_netdev to invalidate dst entries
> instead of loopback device anymore. Also fix broken NETIF_F_HW_CSUM spell.
> 
> Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>

Well spotted, but these two changes are in no way related, could you
please send two separate patches?
