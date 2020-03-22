Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ADE6B18E624
	for <lists+netdev@lfdr.de>; Sun, 22 Mar 2020 03:54:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728281AbgCVCyU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 21 Mar 2020 22:54:20 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:34292 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727851AbgCVCyU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 21 Mar 2020 22:54:20 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 3FE8515ABF028;
        Sat, 21 Mar 2020 19:54:19 -0700 (PDT)
Date:   Sat, 21 Mar 2020 19:54:18 -0700 (PDT)
Message-Id: <20200321.195418.967663426701728390.davem@davemloft.net>
To:     lukas.bulwahn@gmail.com
Cc:     snelson@pensando.io, netdev@vger.kernel.org,
        linux-spdx@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ionic: make spdxcheck.py happy
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200321120514.10464-1-lukas.bulwahn@gmail.com>
References: <20200321120514.10464-1-lukas.bulwahn@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sat, 21 Mar 2020 19:54:19 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Lukas Bulwahn <lukas.bulwahn@gmail.com>
Date: Sat, 21 Mar 2020 13:05:14 +0100

> Headers ionic_if.h and ionic_regs.h are licensed under three alternative
> licenses and the used SPDX-License-Identifier expression makes
> ./scripts/spdxcheck.py complain:
> 
> drivers/net/ethernet/pensando/ionic/ionic_if.h: 1:52 Syntax error: OR
> drivers/net/ethernet/pensando/ionic/ionic_regs.h: 1:52 Syntax error: OR
> 
> As OR is associative, it is irrelevant if the parentheses are put around
> the first or the second OR-expression.
> 
> Simply add parentheses to make spdxcheck.py happy.
> 
> Signed-off-by: Lukas Bulwahn <lukas.bulwahn@gmail.com>

Applied, thank you.
