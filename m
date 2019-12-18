Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7A4CE123F73
	for <lists+netdev@lfdr.de>; Wed, 18 Dec 2019 07:14:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726682AbfLRGO3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Dec 2019 01:14:29 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:47170 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725811AbfLRGO3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Dec 2019 01:14:29 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1c3::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 2FB0B15004EB7;
        Tue, 17 Dec 2019 22:14:29 -0800 (PST)
Date:   Tue, 17 Dec 2019 22:14:28 -0800 (PST)
Message-Id: <20191217.221428.938880317822545293.davem@davemloft.net>
To:     rdunlap@infradead.org
Cc:     netdev@vger.kernel.org, ap420073@gmail.com
Subject: Re: [PATCH] net: fix kernel-doc warning in <linux/netdevice.h>
From:   David Miller <davem@davemloft.net>
In-Reply-To: <c576bade-11b1-8962-2330-c7ea72088b18@infradead.org>
References: <c576bade-11b1-8962-2330-c7ea72088b18@infradead.org>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 17 Dec 2019 22:14:29 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Randy Dunlap <rdunlap@infradead.org>
Date: Mon, 16 Dec 2019 18:52:45 -0800

> From: Randy Dunlap <rdunlap@infradead.org>
> 
> Fix missing '*' kernel-doc notation that causes this warning:
> 
> ../include/linux/netdevice.h:1779: warning: bad line:                                 spinlock
> 
> Fixes: ab92d68fc22f ("net: core: add generic lockdep keys")
> Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
> Cc: Taehee Yoo <ap420073@gmail.com>

Applied, thanks.
