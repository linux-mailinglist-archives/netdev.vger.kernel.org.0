Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3DDD22B6DE0
	for <lists+netdev@lfdr.de>; Tue, 17 Nov 2020 19:54:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729428AbgKQSxB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Nov 2020 13:53:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:46444 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726948AbgKQSxA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 17 Nov 2020 13:53:00 -0500
Received: from kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net (c-67-180-217-166.hsd1.ca.comcast.net [67.180.217.166])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F09D924181;
        Tue, 17 Nov 2020 18:52:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605639180;
        bh=2AJJkkWk/WV+BEtOV196BufSoVqKhHE8CXzkzM/u6fw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=MlLQoLRlsPvOU7LzhkO1nY7OAyUkhqzXwOr6Zxc2gZqhCRJzwim57nhyqQD/asBXu
         M7/rmJRb9mxyU4Z4vppt3JTvnLxIl5dL2AT5jwPwrP8+12Y7DKPcvfoIGaXcDE6F0Q
         nKar5CSm6ZemrdNNyLU7kMH0NxYSOeF7RJctUcCU=
Date:   Tue, 17 Nov 2020 10:52:59 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Michael Chan <michael.chan@broadcom.com>
Cc:     Zhang Changzhong <zhangchangzhong@huawei.com>,
        David Miller <davem@davemloft.net>, Larry.Finger@lwfinger.net,
        akpm@linux-foundation.org, fujita.tomonori@lab.ntt.co.jp,
        "John W. Linville" <linville@tuxdriver.com>,
        Netdev <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net] net: b44: fix error return code in b44_init_one()
Message-ID: <20201117105259.09a6e011@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <CACKFLikSSW+dozWu9TWH1CVqxOCBjq4GiUQBbL5JSprg6H2qVA@mail.gmail.com>
References: <1605582131-36735-1-git-send-email-zhangchangzhong@huawei.com>
        <CACKFLikSSW+dozWu9TWH1CVqxOCBjq4GiUQBbL5JSprg6H2qVA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 16 Nov 2020 20:13:43 -0800 Michael Chan wrote:
> On Mon, Nov 16, 2020 at 7:01 PM Zhang Changzhong wrote:
> >
> > Fix to return a negative error code from the error handling
> > case instead of 0, as done elsewhere in this function.
> >
> > Fixes: 39a6f4bce6b4 ("b44: replace the ssb_dma API with the generic DMA API")
> > Reported-by: Hulk Robot <hulkci@huawei.com>
> > Signed-off-by: Zhang Changzhong <zhangchangzhong@huawei.com>  
> 
> Reviewed-by: Michael Chan <michael.chan@broadcom.com>

Applied, thanks!
