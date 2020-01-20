Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E2471142A79
	for <lists+netdev@lfdr.de>; Mon, 20 Jan 2020 13:21:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727403AbgATMVk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jan 2020 07:21:40 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:56248 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726589AbgATMVk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jan 2020 07:21:40 -0500
Received: from localhost (82-95-191-104.ip.xs4all.nl [82.95.191.104])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 0E59614E20F85;
        Mon, 20 Jan 2020 04:21:37 -0800 (PST)
Date:   Mon, 20 Jan 2020 13:21:36 +0100 (CET)
Message-Id: <20200120.132136.1992070505971817725.davem@davemloft.net>
To:     xiaofeng.yan2012@gmail.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        ap420073@gmail.com, yanxiaofeng7@jd.com
Subject: Re: [PATCH v2] hsr: Fix a compilation error
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200120062639.3074-1-xiaofeng.yan2012@gmail.com>
References: <20200120062639.3074-1-xiaofeng.yan2012@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 20 Jan 2020 04:21:39 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: "xiaofeng.yan" <xiaofeng.yan2012@gmail.com>
Date: Mon, 20 Jan 2020 14:26:39 +0800

> From: "xiaofeng.yan" <yanxiaofeng7@jd.com>
> 
> A compliation error happen when building branch 5.5-rc7
> 
> In file included from net/hsr/hsr_main.c:12:0:
> net/hsr/hsr_main.h:194:20: error: two or more data types in declaration specifiers
>  static inline void void hsr_debugfs_rename(struct net_device *dev)
> 
> So Removed one void.
> 
> Fixes: 4c2d5e33dcd3 ("hsr: rename debugfs file when interface name is changed")
> Signed-off-by: xiaofeng.yan <yanxiaofeng7@jd.com>
> Acked-by: Taehee Yoo <ap420073@gmail.com>

Applied, thank you.
