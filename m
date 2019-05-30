Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EE8ED3049C
	for <lists+netdev@lfdr.de>; Fri, 31 May 2019 00:08:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726674AbfE3WIv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 May 2019 18:08:51 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:32992 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726100AbfE3WIv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 May 2019 18:08:51 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id E07F314DB0980;
        Thu, 30 May 2019 14:31:50 -0700 (PDT)
Date:   Thu, 30 May 2019 14:31:50 -0700 (PDT)
Message-Id: <20190530.143150.592829291503380971.davem@davemloft.net>
To:     antoine.tenart@bootlin.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        thomas.petazzoni@bootlin.com, maxime.chevallier@bootlin.com,
        gregory.clement@bootlin.com, miquel.raynal@bootlin.com,
        nadavh@marvell.com, stefanc@marvell.com, mw@semihalf.com
Subject: Re: [PATCH net] net: mvpp2: fix bad MVPP2_TXQ_SCHED_TOKEN_CNTR_REG
 queue value
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190529135948.32483-1-antoine.tenart@bootlin.com>
References: <20190529135948.32483-1-antoine.tenart@bootlin.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 30 May 2019 14:31:51 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Antoine Tenart <antoine.tenart@bootlin.com>
Date: Wed, 29 May 2019 15:59:48 +0200

> MVPP2_TXQ_SCHED_TOKEN_CNTR_REG() expects the logical queue id but
> the current code is passing the global tx queue offset, so it ends
> up writing to unknown registers (between 0x8280 and 0x82fc, which
> seemed to be unused by the hardware). This fixes the issue by using
> the logical queue id instead.
> 
> Fixes: 3f518509dedc ("ethernet: Add new driver for Marvell Armada 375 network unit")
> Signed-off-by: Antoine Tenart <antoine.tenart@bootlin.com>

Applied and queued up for -stable.
