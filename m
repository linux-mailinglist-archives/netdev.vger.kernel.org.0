Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D3362FF561
	for <lists+netdev@lfdr.de>; Sat, 16 Nov 2019 21:14:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727399AbfKPUOh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 Nov 2019 15:14:37 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:53190 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727115AbfKPUOh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 16 Nov 2019 15:14:37 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 9B0B01517207F;
        Sat, 16 Nov 2019 12:14:36 -0800 (PST)
Date:   Sat, 16 Nov 2019 12:14:36 -0800 (PST)
Message-Id: <20191116.121436.1558075110852883724.davem@davemloft.net>
To:     nishadkamdar@gmail.com
Cc:     sgoutham@marvell.com, lcherian@marvell.com, gakula@marvell.com,
        jerinj@marvell.com, gregkh@linuxfoundation.org, joe@perches.com,
        u.kleine-koenig@pengutronix.de, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] octeontx2-af: Use the correct style for SPDX License
 Identifier
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191116092042.GA4313@nishad>
References: <20191116092042.GA4313@nishad>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sat, 16 Nov 2019 12:14:37 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Nishad Kamdar <nishadkamdar@gmail.com>
Date: Sat, 16 Nov 2019 14:50:45 +0530

> This patch corrects the SPDX License Identifier style in
> header files related to Marvell OcteonTX2 network devices.
> It uses an expilict block comment for the SPDX License
> Identifier.
> 
> Changes made by using a script provided by Joe Perches here:
> https://lkml.org/lkml/2019/2/7/46.
> 
> Suggested-by: Joe Perches <joe@perches.com>
> Signed-off-by: Nishad Kamdar <nishadkamdar@gmail.com>

Applied.
