Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 22E9CC3A6D
	for <lists+netdev@lfdr.de>; Tue,  1 Oct 2019 18:26:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728536AbfJAQY5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Oct 2019 12:24:57 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:49306 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725843AbfJAQY4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Oct 2019 12:24:56 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id C7EAF154B2B38;
        Tue,  1 Oct 2019 09:24:55 -0700 (PDT)
Date:   Tue, 01 Oct 2019 09:24:55 -0700 (PDT)
Message-Id: <20191001.092455.1322622179723053160.davem@davemloft.net>
To:     arnd@arndb.de
Cc:     snelson@pensando.io, drivers@pensando.io, krzk@kernel.org,
        leon@kernel.org, kvalo@codeaurora.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ionic: select CONFIG_NET_DEVLINK
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191001142151.1206987-1-arnd@arndb.de>
References: <20191001142151.1206987-1-arnd@arndb.de>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 01 Oct 2019 09:24:56 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>
Date: Tue,  1 Oct 2019 16:21:40 +0200

> When no other driver selects the devlink library code, ionic
> produces a link failure:
> 
> drivers/net/ethernet/pensando/ionic/ionic_devlink.o: In function `ionic_devlink_alloc':
> ionic_devlink.c:(.text+0xd): undefined reference to `devlink_alloc'
> drivers/net/ethernet/pensando/ionic/ionic_devlink.o: In function `ionic_devlink_register':
> ionic_devlink.c:(.text+0x71): undefined reference to `devlink_register'
> 
> Add the same 'select' statement that the other drivers use here.
> 
> Fixes: fbfb8031533c ("ionic: Add hardware init and device commands")
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

Applied, thanks.
