Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 73E091147FA
	for <lists+netdev@lfdr.de>; Thu,  5 Dec 2019 21:11:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729703AbfLEULL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Dec 2019 15:11:11 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:46914 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729154AbfLEULK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Dec 2019 15:11:10 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1c3::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 0020015039427;
        Thu,  5 Dec 2019 12:11:09 -0800 (PST)
Date:   Thu, 05 Dec 2019 12:11:09 -0800 (PST)
Message-Id: <20191205.121109.1735662506707982549.davem@davemloft.net>
To:     ykaukab@suse.de
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, tharvey@gateworks.com,
        rric@kernel.org, sgoutham@cavium.com,
        sergei.shtylyov@cogentembedded.com, andrew@lunn.ch
Subject: Re: [PATCH net v2] net: thunderx: start phy before starting
 autonegotiation
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191205094116.4904-1-ykaukab@suse.de>
References: <20191205094116.4904-1-ykaukab@suse.de>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 05 Dec 2019 12:11:10 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Mian Yousaf Kaukab <ykaukab@suse.de>
Date: Thu,  5 Dec 2019 10:41:16 +0100

> Since commit 2b3e88ea6528 ("net: phy: improve phy state checking")
> phy_start_aneg() expects phy state to be >= PHY_UP. Call phy_start()
> before calling phy_start_aneg() during probe so that autonegotiation
> is initiated.
> 
> As phy_start() takes care of calling phy_start_aneg(), drop the explicit
> call to phy_start_aneg().
> 
> Network fails without this patch on Octeon TX.
> 
> Fixes: 2b3e88ea6528 ("net: phy: improve phy state checking")
> Signed-off-by: Mian Yousaf Kaukab <ykaukab@suse.de>

Applied and queued up for -stable, thanks.
