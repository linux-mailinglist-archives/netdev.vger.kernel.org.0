Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 217B762CAD
	for <lists+netdev@lfdr.de>; Tue,  9 Jul 2019 01:33:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727710AbfGHXd1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jul 2019 19:33:27 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:60240 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727305AbfGHXd0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Jul 2019 19:33:26 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 3F3EF12E4E44D;
        Mon,  8 Jul 2019 16:33:26 -0700 (PDT)
Date:   Mon, 08 Jul 2019 16:33:25 -0700 (PDT)
Message-Id: <20190708.163325.1977216943079953279.davem@davemloft.net>
To:     wen.yang99@zte.com.cn
Cc:     linux-kernel@vger.kernel.org, xue.zhihong@zte.com.cn,
        wang.yi59@zte.com.cn, cheng.shengyu@zte.com.cn, tglx@linutronix.de,
        mcgrof@kernel.org, mpe@ellerman.id.au, netdev@vger.kernel.org
Subject: Re: [PATCH] net: pasemi: fix an use-after-free in
 pasemi_mac_phy_init()
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1562387021-951-1-git-send-email-wen.yang99@zte.com.cn>
References: <1562387021-951-1-git-send-email-wen.yang99@zte.com.cn>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 08 Jul 2019 16:33:26 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Wen Yang <wen.yang99@zte.com.cn>
Date: Sat, 6 Jul 2019 12:23:41 +0800

> The phy_dn variable is still being used in of_phy_connect() after the
> of_node_put() call, which may result in use-after-free.
> 
> Fixes: 1dd2d06c0459 ("net: Rework pasemi_mac driver to use of_mdio infrastructure")
> Signed-off-by: Wen Yang <wen.yang99@zte.com.cn>

Applied.
