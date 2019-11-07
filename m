Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DA185F2722
	for <lists+netdev@lfdr.de>; Thu,  7 Nov 2019 06:30:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725945AbfKGFad (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Nov 2019 00:30:33 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:33868 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725763AbfKGFad (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Nov 2019 00:30:33 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 07C36151114EC;
        Wed,  6 Nov 2019 21:30:32 -0800 (PST)
Date:   Wed, 06 Nov 2019 21:30:32 -0800 (PST)
Message-Id: <20191106.213032.322816326269906366.davem@davemloft.net>
To:     ioana.ciornei@nxp.com
Cc:     netdev@vger.kernel.org, andrew@lunn.ch, dan.carpenter@oracle.com
Subject: Re: [PATCH] dpaa2-eth: fix an always true condition in
 dpaa2_mac_get_if_mode
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1573060010-24260-1-git-send-email-ioana.ciornei@nxp.com>
References: <1573060010-24260-1-git-send-email-ioana.ciornei@nxp.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 06 Nov 2019 21:30:33 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ioana Ciornei <ioana.ciornei@nxp.com>
Date: Wed,  6 Nov 2019 19:06:50 +0200

> Convert the phy_mode() function to return the if_mode through an
> argument, similar to the new form of of_get_phy_mode().
> This will help with handling errors in a common manner and also will fix
> an always true condition.
> 
> Fixes: 0c65b2b90d13 ("net: of_get_phy_mode: Change API to solve int/unit warnings")
> Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
> Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>

Applied to net-next, thanks.

Please specify the appropriate target GIT tree when posting patches by listing
it in the Subject line, f.e.

	Subject: [PATCH net-next] ...

Thank you.
