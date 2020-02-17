Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 016CB160864
	for <lists+netdev@lfdr.de>; Mon, 17 Feb 2020 04:00:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727362AbgBQDAA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 16 Feb 2020 22:00:00 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:48032 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726672AbgBQC77 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 16 Feb 2020 21:59:59 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 35034155240A6;
        Sun, 16 Feb 2020 18:59:59 -0800 (PST)
Date:   Sun, 16 Feb 2020 18:59:58 -0800 (PST)
Message-Id: <20200216.185958.576122723709663295.davem@davemloft.net>
To:     qiwuchen55@gmail.com
Cc:     andrew.hendry@gmail.com, kuba@kernel.org, allison@lohutok.net,
        tglx@linutronix.de, linux-x25@vger.kernel.org,
        netdev@vger.kernel.org, chenqiwu@xiaomi.com
Subject: Re: [PATCH] net: x25: convert to list_for_each_entry_safe()
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1581671906-25193-1-git-send-email-qiwuchen55@gmail.com>
References: <1581671906-25193-1-git-send-email-qiwuchen55@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 16 Feb 2020 18:59:59 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: qiwuchen55@gmail.com
Date: Fri, 14 Feb 2020 17:18:26 +0800

> From: chenqiwu <chenqiwu@xiaomi.com>
> 
> Use list_for_each_entry_safe() instead of list_for_each_safe()
> to simplify the code.
> 
> Signed-off-by: chenqiwu <chenqiwu@xiaomi.com>

Applied to net-next.
