Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 477716F809
	for <lists+netdev@lfdr.de>; Mon, 22 Jul 2019 05:42:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728032AbfGVDmR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 21 Jul 2019 23:42:17 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:38278 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726106AbfGVDmR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 21 Jul 2019 23:42:17 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 75E5714EC8285;
        Sun, 21 Jul 2019 20:42:16 -0700 (PDT)
Date:   Sun, 21 Jul 2019 20:41:56 -0700 (PDT)
Message-Id: <20190721.204156.403753211415246792.davem@davemloft.net>
To:     haiyangz@microsoft.com
Cc:     sashal@kernel.org, linux-hyperv@vger.kernel.org,
        netdev@vger.kernel.org, kys@microsoft.com, sthemmin@microsoft.com,
        olaf@aepfle.de, vkuznets@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net] hv_netvsc: Fix extra rcu_read_unlock in
 netvsc_recv_callback()
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1563557581-17669-1-git-send-email-haiyangz@microsoft.com>
References: <1563557581-17669-1-git-send-email-haiyangz@microsoft.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 21 Jul 2019 20:42:16 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Haiyang Zhang <haiyangz@microsoft.com>
Date: Fri, 19 Jul 2019 17:33:51 +0000

> There is an extra rcu_read_unlock left in netvsc_recv_callback(),
> after a previous patch that removes RCU from this function.
> This patch removes the extra RCU unlock.
> 
> Fixes: 345ac08990b8 ("hv_netvsc: pass netvsc_device to receive callback")
> Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>

Applied and queued up for -stable.
