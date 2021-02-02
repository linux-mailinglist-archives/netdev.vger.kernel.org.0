Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 057F630B55F
	for <lists+netdev@lfdr.de>; Tue,  2 Feb 2021 03:42:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231349AbhBBCmE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Feb 2021 21:42:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:59804 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231156AbhBBCmD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 1 Feb 2021 21:42:03 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6E36F64DD4;
        Tue,  2 Feb 2021 02:41:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612233682;
        bh=B227yCF3UE9iE4vX5tY1JizbCwc43jH9cL6KonQN1LY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=m7Y9syq7iwD0U29UVy0PeWDF7olP7uhYdnZ3DuHPwMnmQCTS/8NGZIUsKigyFEdXU
         jWWn7QPqLXxym5XCXjLS5jvxL0aENyie9qjYN2GcodzY4SiQvvfnKKuNjLvEDEQd76
         7V9KgzpfiwIPLA+Nsa6uFr9eOpNMoFe7c5YThbBBW4QTWfTaRvDJ7XGCUJPSOVkaBT
         G4E6edgT9JpTQs91RRQMZ6LJmONv0uan0LDl1sZ2SSbAXgp2B3sSay8icRV/QhQoH+
         KmyCn3Vbjdqsn2NFbYzLg6Y8uccsqFa7CbjIBjJjsONUtuj14vZPZTX1WalNO1lDYa
         5ly+oJopCeRrg==
Date:   Mon, 1 Feb 2021 18:41:21 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Alexander Ovechkin <ovov@yandex-team.ru>
Cc:     netdev@vger.kernel.org, pabeni@redhat.com, davem@davemloft.net,
        jhs@mojatatu.com, xiyou.wangcong@gmail.com, zeil@yandex-team.ru,
        dmtrmonakhov@yandex-team.ru
Subject: Re: [PATCH net] net: sched: replaced invalid qdisc tree flush
 helper in qdisc_replace
Message-ID: <20210201184121.09c4539a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210201200049.299153-1-ovov@yandex-team.ru>
References: <20210201200049.299153-1-ovov@yandex-team.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon,  1 Feb 2021 23:00:49 +0300 Alexander Ovechkin wrote:
> Commit e5f0e8f8e456 ("net: sched: introduce and use qdisc tree flush/purge helpers")
> introduced qdisc tree flush/purge helpers, but erroneously used flush helper
> instead of purge helper in qdisc_replace function.
> This issue was found in our CI, that tests various qdisc setups by configuring
> qdisc and sending data through it. Call of invalid helper sporadically leads
> to corruption of vt_tree/cf_tree of hfsc_class that causes kernel oops:

> Fixes: e5f0e8f8e456 ("net: sched: introduce and use qdisc tree flush/purge helpers")
> Signed-off-by: Alexander Ovechkin <ovov@yandex-team.ru>
> Reported-by: Alexander Kuznetsov <wwfq@yandex-team.ru>
> Acked-by: Dmitry Monakhov <dmtrmonakhov@yandex-team.ru>
> Acked-by: Dmitry Yakunin <zeil@yandex-team.ru>
> Acked-by: Cong Wang <xiyou.wangcong@gmail.com>

No need to repost just to add the ack, patchwork will pick the tags up
automatically.

Applied, thanks!
