Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C0EC9198A1E
	for <lists+netdev@lfdr.de>; Tue, 31 Mar 2020 04:44:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729358AbgCaCol (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Mar 2020 22:44:41 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:45822 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727464AbgCaCok (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Mar 2020 22:44:40 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id A4A8A15D1582B;
        Mon, 30 Mar 2020 19:44:39 -0700 (PDT)
Date:   Mon, 30 Mar 2020 19:44:24 -0700 (PDT)
Message-Id: <20200330.194424.1566124309061632230.davem@davemloft.net>
To:     haiyangz@microsoft.com
Cc:     sashal@kernel.org, linux-hyperv@vger.kernel.org,
        netdev@vger.kernel.org, kys@microsoft.com, sthemmin@microsoft.com,
        olaf@aepfle.de, vkuznets@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] hv_netvsc: Remove unnecessary round_up for
 recv_completion_cnt
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1585596553-22721-1-git-send-email-haiyangz@microsoft.com>
References: <1585596553-22721-1-git-send-email-haiyangz@microsoft.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 30 Mar 2020 19:44:40 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Haiyang Zhang <haiyangz@microsoft.com>
Date: Mon, 30 Mar 2020 12:29:13 -0700

> The vzalloc_node(), already rounds the total size to whole pages, and
> sizeof(u64) is smaller than sizeof(struct recv_comp_data). So
> round_up of recv_completion_cnt is not necessary, and may cause extra
> memory allocation.
> 
> To save memory, remove this unnecessary round_up for recv_completion_cnt.
> 
> Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>

Applied, thanks.
