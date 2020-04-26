Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 20C011B8BA9
	for <lists+netdev@lfdr.de>; Sun, 26 Apr 2020 05:36:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726116AbgDZDg0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Apr 2020 23:36:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725942AbgDZDg0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 25 Apr 2020 23:36:26 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1AF2AC061A0C
        for <netdev@vger.kernel.org>; Sat, 25 Apr 2020 20:36:26 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id EF2C3159FC560;
        Sat, 25 Apr 2020 20:36:24 -0700 (PDT)
Date:   Sat, 25 Apr 2020 20:36:23 -0700 (PDT)
Message-Id: <20200425.203623.416583354805973089.davem@davemloft.net>
To:     zhengbin13@huawei.com
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, hkallweit1@gmail.com,
        netdev@vger.kernel.org
Subject: Re: [PATCH -next] net: phy: dp83867: Remove unneeded semicolon
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200424090850.96778-1-zhengbin13@huawei.com>
References: <20200424090850.96778-1-zhengbin13@huawei.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sat, 25 Apr 2020 20:36:25 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Zheng Bin <zhengbin13@huawei.com>
Date: Fri, 24 Apr 2020 17:08:50 +0800

> Fixes coccicheck warning:
> 
> drivers/net/phy/dp83867.c:368:2-3: Unneeded semicolon
> drivers/net/phy/dp83867.c:403:2-3: Unneeded semicolon
> 
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: Zheng Bin <zhengbin13@huawei.com>

Applied, thanks.
