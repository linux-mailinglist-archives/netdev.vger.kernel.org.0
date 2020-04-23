Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD2421B674C
	for <lists+netdev@lfdr.de>; Fri, 24 Apr 2020 00:57:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727997AbgDWW5L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Apr 2020 18:57:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727065AbgDWW5K (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Apr 2020 18:57:10 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBB67C09B042;
        Thu, 23 Apr 2020 15:57:10 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id CE580127E2661;
        Thu, 23 Apr 2020 15:57:09 -0700 (PDT)
Date:   Thu, 23 Apr 2020 15:57:09 -0700 (PDT)
Message-Id: <20200423.155709.424252739885282745.davem@davemloft.net>
To:     colin.king@canonical.com
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, hkallweit1@gmail.com,
        linux@armlinux.org.uk, michael@walle.cc, linux@roeck-us.net,
        netdev@vger.kernel.org, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH][next] net: phy: bcm54140: fix less than zero
 comparison on an unsigned
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200423141016.19666-1-colin.king@canonical.com>
References: <20200423141016.19666-1-colin.king@canonical.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 23 Apr 2020 15:57:10 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Colin King <colin.king@canonical.com>
Date: Thu, 23 Apr 2020 15:10:16 +0100

> From: Colin Ian King <colin.king@canonical.com>
> 
> Currently the unsigned variable tmp is being checked for an negative
> error return from the call to bcm_phy_read_rdb and this can never
> be true since tmp is unsigned.  Fix this by making tmp a plain int.
> 
> Addresses-Coverity: ("Unsigned compared against 0")
> Fixes: 4406d36dfdf1 ("net: phy: bcm54140: add hwmon support")
> Signed-off-by: Colin Ian King <colin.king@canonical.com>

Applied.
