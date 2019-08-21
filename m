Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6779998622
	for <lists+netdev@lfdr.de>; Wed, 21 Aug 2019 23:00:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730659AbfHUVAP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Aug 2019 17:00:15 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:33778 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728571AbfHUVAP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Aug 2019 17:00:15 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id C11EF14DAD6A8;
        Wed, 21 Aug 2019 14:00:14 -0700 (PDT)
Date:   Wed, 21 Aug 2019 14:00:14 -0700 (PDT)
Message-Id: <20190821.140014.255300007478960933.davem@davemloft.net>
To:     antoine.tenart@bootlin.com
Cc:     grygorii.strashko@ti.com, netdev@vger.kernel.org,
        linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org,
        maxime.chevallier@bootlin.com
Subject: Re: [PATCH net] net: cpsw: fix NULL pointer exception in the probe
 error path
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190821144123.22248-1-antoine.tenart@bootlin.com>
References: <20190821144123.22248-1-antoine.tenart@bootlin.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 21 Aug 2019 14:00:15 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Antoine Tenart <antoine.tenart@bootlin.com>
Date: Wed, 21 Aug 2019 16:41:23 +0200

> In certain cases when the probe function fails the error path calls
> cpsw_remove_dt() before calling platform_set_drvdata(). This is an
> issue as cpsw_remove_dt() uses platform_get_drvdata() to retrieve the
> cpsw_common data and leds to a NULL pointer exception. This patches
> fixes it by calling platform_set_drvdata() earlier in the probe.
> 
> Fixes: 83a8471ba255 ("net: ethernet: ti: cpsw: refactor probe to group common hw initialization")
> Reported-by: Maxime Chevallier <maxime.chevallier@bootlin.com>
> Signed-off-by: Antoine Tenart <antoine.tenart@bootlin.com>

Applied and queued up for -stable, thanks.
