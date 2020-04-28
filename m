Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A7331BCDB7
	for <lists+netdev@lfdr.de>; Tue, 28 Apr 2020 22:54:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726520AbgD1UyT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Apr 2020 16:54:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726413AbgD1UyS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Apr 2020 16:54:18 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73A14C03C1AC;
        Tue, 28 Apr 2020 13:54:18 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 9B4B9120F52B8;
        Tue, 28 Apr 2020 13:54:16 -0700 (PDT)
Date:   Tue, 28 Apr 2020 13:54:15 -0700 (PDT)
Message-Id: <20200428.135415.1205625453935613273.davem@davemloft.net>
To:     chentao107@huawei.com
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, hkallweit1@gmail.com,
        linux@armlinux.org.uk, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH-next] net: phy: bcm54140: Make a bunch of functions
 static
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200428014804.54944-1-chentao107@huawei.com>
References: <20200428014804.54944-1-chentao107@huawei.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 28 Apr 2020 13:54:16 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: ChenTao <chentao107@huawei.com>
Date: Tue, 28 Apr 2020 09:48:04 +0800

> Fix the following warning:
> 
> drivers/net/phy/bcm54140.c:663:5: warning:
> symbol 'bcm54140_did_interrupt' was not declared. Should it be static?
> drivers/net/phy/bcm54140.c:672:5: warning:
> symbol 'bcm54140_ack_intr' was not declared. Should it be static?
> drivers/net/phy/bcm54140.c:684:5: warning:
> symbol 'bcm54140_config_intr' was not declared. Should it be static?
> 
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: ChenTao <chentao107@huawei.com>

Applied, thank you.
