Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 282EF134E83
	for <lists+netdev@lfdr.de>; Wed,  8 Jan 2020 22:11:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727347AbgAHVKF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jan 2020 16:10:05 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:47856 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726155AbgAHVKF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jan 2020 16:10:05 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1c3::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 925F61584D0BE;
        Wed,  8 Jan 2020 13:10:04 -0800 (PST)
Date:   Wed, 08 Jan 2020 13:10:04 -0800 (PST)
Message-Id: <20200108.131004.491620925338376038.davem@davemloft.net>
To:     arnd@arndb.de
Cc:     arvid.brodin@alten.se, ap420073@gmail.com, m-karicheri2@ti.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] hsr: fix dummy hsr_debugfs_rename()
 declaration
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200107200347.3374445-1-arnd@arndb.de>
References: <20200107200347.3374445-1-arnd@arndb.de>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 08 Jan 2020 13:10:04 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>
Date: Tue,  7 Jan 2020 21:03:39 +0100

> The hsr_debugfs_rename prototype got an extra 'void' that needs to
> be removed again:
> 
> In file included from /git/arm-soc/net/hsr/hsr_main.c:12:
> net/hsr/hsr_main.h:194:20: error: two or more data types in declaration specifiers
>  static inline void void hsr_debugfs_rename(struct net_device *dev)
> 
> Fixes: 4c2d5e33dcd3 ("hsr: rename debugfs file when interface name is changed")
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

Applied, thanks Arnd.
