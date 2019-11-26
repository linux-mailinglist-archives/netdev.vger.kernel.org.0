Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DA4EF10A6B9
	for <lists+netdev@lfdr.de>; Tue, 26 Nov 2019 23:43:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726926AbfKZWnZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Nov 2019 17:43:25 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:43554 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726103AbfKZWnZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Nov 2019 17:43:25 -0500
Received: from localhost (c-73-35-209-67.hsd1.wa.comcast.net [73.35.209.67])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 5EABD14D78B39;
        Tue, 26 Nov 2019 14:43:24 -0800 (PST)
Date:   Tue, 26 Nov 2019 14:43:23 -0800 (PST)
Message-Id: <20191126.144323.1762864682894965078.davem@davemloft.net>
To:     dmurphy@ti.com
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, hkallweit1@gmail.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] net: phy: dp83869: Fix return paths to return proper
 values
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191126143856.26451-1-dmurphy@ti.com>
References: <20191126143856.26451-1-dmurphy@ti.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 26 Nov 2019 14:43:24 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dan Murphy <dmurphy@ti.com>
Date: Tue, 26 Nov 2019 08:38:56 -0600

> Fix the return paths for all I/O operations to ensure
> that the I/O completed successfully.  Then pass the return
> to the caller for further processing
> 
> Reported-by: Andrew Lunn <andrew@lunn.ch>
> Fixes: 01db923e8377 ("net: phy: dp83869: Add TI dp83869 phy")
> Signed-off-by: Dan Murphy <dmurphy@ti.com>

Please specify the Fixes: tag as the first tag in the future.

Applied, thanks.
