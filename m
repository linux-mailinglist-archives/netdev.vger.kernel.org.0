Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 98333E7A51
	for <lists+netdev@lfdr.de>; Mon, 28 Oct 2019 21:41:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387735AbfJ1UlP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Oct 2019 16:41:15 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:44686 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726508AbfJ1UlP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Oct 2019 16:41:15 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 0AD3414B79F60;
        Mon, 28 Oct 2019 13:41:15 -0700 (PDT)
Date:   Mon, 28 Oct 2019 13:41:14 -0700 (PDT)
Message-Id: <20191028.134114.649252463782512540.davem@davemloft.net>
To:     nishadkamdar@gmail.com
Cc:     yangbo.lu@nxp.com, gregkh@linuxfoundation.org, joe@perches.com,
        u.kleine-koenig@pengutronix.de, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: dpaa2: Use the correct style for SPDX License
 Identifier
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191024151155.GA3340@nishad>
References: <20191024151155.GA3340@nishad>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 28 Oct 2019 13:41:15 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Nishad Kamdar <nishadkamdar@gmail.com>
Date: Thu, 24 Oct 2019 20:42:00 +0530

> This patch corrects the SPDX License Identifier style in
> header files related to DPAA2 Ethernet driver supporting
> Freescale SoCs with DPAA2. For C header files
> Documentation/process/license-rules.rst mandates C-like comments
> (opposed to C source files where C++ style should be used)
> 
> Changes made by using a script provided by Joe Perches here:
> https://lkml.org/lkml/2019/2/7/46.
> 
> Suggested-by: Joe Perches <joe@perches.com>
> Signed-off-by: Nishad Kamdar <nishadkamdar@gmail.com>

Applied.
