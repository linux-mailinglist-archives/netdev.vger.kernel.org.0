Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 46331ED80A
	for <lists+netdev@lfdr.de>; Mon,  4 Nov 2019 04:26:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729133AbfKDD0C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 3 Nov 2019 22:26:02 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:41180 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728847AbfKDD0C (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 3 Nov 2019 22:26:02 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id E6C601503D3C6;
        Sun,  3 Nov 2019 19:26:01 -0800 (PST)
Date:   Sun, 03 Nov 2019 19:26:01 -0800 (PST)
Message-Id: <20191103.192601.443764119268490765.davem@davemloft.net>
To:     andrew@lunn.ch
Cc:     netdev@vger.kernel.org, dan.carpenter@oracle.com
Subject: Re: [PATCH v2 net-next] net: of_get_phy_mode: Change API to solve
 int/unit warnings
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191101220756.2626-1-andrew@lunn.ch>
References: <20191101220756.2626-1-andrew@lunn.ch>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 03 Nov 2019 19:26:02 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Andrew Lunn <andrew@lunn.ch>
Date: Fri,  1 Nov 2019 23:07:56 +0100

> Before this change of_get_phy_mode() returned an enum,
> phy_interface_t. On error, -ENODEV etc, is returned. If the result of
> the function is stored in a variable of type phy_interface_t, and the
> compiler has decided to represent this as an unsigned int, comparision
> with -ENODEV etc, is a signed vs unsigned comparision.
> 
> Fix this problem by changing the API. Make the function return an
> error, or 0 on success, and pass a pointer, of type phy_interface_t,
> where the phy mode should be stored.
> 
> v2:
> Return with *interface set to PHY_INTERFACE_MODE_NA on error.
> Add error checks to all users of of_get_phy_mode()
> Fixup a few reverse christmas tree errors
> Fixup a few slightly malformed reverse christmas trees
> 
> Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
> Signed-off-by: Andrew Lunn <andrew@lunn.ch>

Applied, thanks Andrew.
