Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E81E1E94CC
	for <lists+netdev@lfdr.de>; Sun, 31 May 2020 02:50:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729571AbgEaAuD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 30 May 2020 20:50:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729356AbgEaAuD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 30 May 2020 20:50:03 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3B04C03E969
        for <netdev@vger.kernel.org>; Sat, 30 May 2020 17:50:02 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 46CF7128DAB18;
        Sat, 30 May 2020 17:50:02 -0700 (PDT)
Date:   Sat, 30 May 2020 17:50:01 -0700 (PDT)
Message-Id: <20200530.175001.2096700764244962044.davem@davemloft.net>
To:     yangyingliang@huawei.com
Cc:     xiyou.wangcong@gmail.com, netdev@vger.kernel.org
Subject: Re: [PATCH net] devinet: fix memleak in inetdev_init()
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1590809673-105923-1-git-send-email-yangyingliang@huawei.com>
References: <1590809673-105923-1-git-send-email-yangyingliang@huawei.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sat, 30 May 2020 17:50:02 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yang Yingliang <yangyingliang@huawei.com>
Date: Sat, 30 May 2020 11:34:33 +0800

> When devinet_sysctl_register() failed, the memory allocated
> in neigh_parms_alloc() should be freed.
> 
> Fixes: 20e61da7ffcf ("ipv4: fail early when creating netdev named all or default")
> Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>

Applied and queued up for -stable, thanks.
