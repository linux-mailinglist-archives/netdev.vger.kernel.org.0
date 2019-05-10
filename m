Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9859A1A534
	for <lists+netdev@lfdr.de>; Sat, 11 May 2019 00:22:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727909AbfEJWV7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 May 2019 18:21:59 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:58848 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727703AbfEJWV7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 May 2019 18:21:59 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d8])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id B3940133E975E;
        Fri, 10 May 2019 15:21:58 -0700 (PDT)
Date:   Fri, 10 May 2019 15:21:58 -0700 (PDT)
Message-Id: <20190510.152158.68128720035934217.davem@davemloft.net>
To:     hkallweit1@gmail.com
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, netdev@vger.kernel.org
Subject: Re: [PATCH net-next] net: phy: realtek: add missing page operations
From:   David Miller <davem@davemloft.net>
In-Reply-To: <6dce0e4a-386e-af4e-4f9c-ee6dd2376957@gmail.com>
References: <6dce0e4a-386e-af4e-4f9c-ee6dd2376957@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 10 May 2019 15:21:58 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Heiner Kallweit <hkallweit1@gmail.com>
Date: Fri, 10 May 2019 22:11:26 +0200

> Add missing page operation callbacks to few Realtek drivers.
> This also fixes a NPE after the referenced commit added code to the
> RTL8211E driver that uses phy_select_page().
> 
> Fixes: f81dadbcf7fd ("net: phy: realtek: Add rtl8211e rx/tx delays config")
> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>

Applied, thanks Heiner.

After Linus takes in my net-next tree for the merge window you should target
'net' for bug fixes.

Thanks again.
