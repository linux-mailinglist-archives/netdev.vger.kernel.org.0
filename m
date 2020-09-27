Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5215627A410
	for <lists+netdev@lfdr.de>; Sun, 27 Sep 2020 22:30:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726610AbgI0UaG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 27 Sep 2020 16:30:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726387AbgI0UaG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 27 Sep 2020 16:30:06 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F7ECC0613CE;
        Sun, 27 Sep 2020 13:30:06 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 5CAF013BB09D6;
        Sun, 27 Sep 2020 13:13:18 -0700 (PDT)
Date:   Sun, 27 Sep 2020 13:30:05 -0700 (PDT)
Message-Id: <20200927.133005.1316398137119616816.davem@davemloft.net>
To:     yangbo.lu@nxp.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-next@vger.kernel.org, richardcochran@gmail.com,
        kurt@linutronix.de, f.fainelli@gmail.com, rdunlap@infradead.org
Subject: Re: [PATCH] ptp: add stub function for ptp_get_msgtype()
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200927080150.8479-1-yangbo.lu@nxp.com>
References: <20200927080150.8479-1-yangbo.lu@nxp.com>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Sun, 27 Sep 2020 13:13:18 -0700 (PDT)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yangbo Lu <yangbo.lu@nxp.com>
Date: Sun, 27 Sep 2020 16:01:50 +0800

> Added the missing stub function for ptp_get_msgtype().
> 
> Reported-by: Randy Dunlap <rdunlap@infradead.org>
> Fixes: 036c508ba95e ("ptp: Add generic ptp message type function")
> Signed-off-by: Yangbo Lu <yangbo.lu@nxp.com>

Applied to net-next, thanks.
