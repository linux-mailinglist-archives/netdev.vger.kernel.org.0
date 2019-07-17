Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AEA606C13E
	for <lists+netdev@lfdr.de>; Wed, 17 Jul 2019 21:00:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727058AbfGQS7m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Jul 2019 14:59:42 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:40820 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725948AbfGQS7m (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Jul 2019 14:59:42 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 0E66B14711CA2;
        Wed, 17 Jul 2019 11:59:42 -0700 (PDT)
Date:   Wed, 17 Jul 2019 11:59:39 -0700 (PDT)
Message-Id: <20190717.115939.4677562145627160.davem@davemloft.net>
To:     ap420073@gmail.com
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH net] caif-hsi: fix possible deadlock in
 cfhsi_exit_module()
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190715051017.7514-1-ap420073@gmail.com>
References: <20190715051017.7514-1-ap420073@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 17 Jul 2019 11:59:42 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Taehee Yoo <ap420073@gmail.com>
Date: Mon, 15 Jul 2019 14:10:17 +0900

> cfhsi_exit_module() calls unregister_netdev() under rtnl_lock().
> but unregister_netdev() internally calls rtnl_lock().
> So deadlock would occur.
> 
> Fixes: c41254006377 ("caif-hsi: Add rtnl support")
> Signed-off-by: Taehee Yoo <ap420073@gmail.com>

Applied and queued up for -stable, thank you.
