Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 35E671665BF
	for <lists+netdev@lfdr.de>; Thu, 20 Feb 2020 19:02:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728680AbgBTSCw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Feb 2020 13:02:52 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:56778 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728576AbgBTSCw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Feb 2020 13:02:52 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id D67F115AC0C05;
        Thu, 20 Feb 2020 10:02:51 -0800 (PST)
Date:   Thu, 20 Feb 2020 10:02:51 -0800 (PST)
Message-Id: <20200220.100251.1381618479382383167.davem@davemloft.net>
To:     lirongqing@baidu.com
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH][net-next] net: remove unused macro from fib_trie.c
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1582181419-25079-1-git-send-email-lirongqing@baidu.com>
References: <1582181419-25079-1-git-send-email-lirongqing@baidu.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 20 Feb 2020 10:02:52 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Li RongQing <lirongqing@baidu.com>
Date: Thu, 20 Feb 2020 14:50:19 +0800

> TNODE_KMALLOC_MAX and VERSION are not used, so remove them
> 
> Signed-off-by: Li RongQing <lirongqing@baidu.com>

Applied.
