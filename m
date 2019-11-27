Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2553E10B6B7
	for <lists+netdev@lfdr.de>; Wed, 27 Nov 2019 20:27:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727377AbfK0T1M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Nov 2019 14:27:12 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:56746 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727355AbfK0T1M (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Nov 2019 14:27:12 -0500
Received: from localhost (c-73-35-209-67.hsd1.wa.comcast.net [73.35.209.67])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 060A214A6FD55;
        Wed, 27 Nov 2019 11:27:11 -0800 (PST)
Date:   Wed, 27 Nov 2019 11:27:11 -0800 (PST)
Message-Id: <20191127.112711.1617895592145395712.davem@davemloft.net>
To:     nishadkamdar@gmail.com
Cc:     gregkh@linuxfoundation.org, joe@perches.com,
        u.kleine-koenig@pengutronix.de, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: usb: aqc111: Use the correct style for SPDX
 License Identifier
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191127134548.GA29603@nishad>
References: <20191127134548.GA29603@nishad>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 27 Nov 2019 11:27:12 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Nishad Kamdar <nishadkamdar@gmail.com>
Date: Wed, 27 Nov 2019 19:15:52 +0530

> This patch corrects the SPDX License Identifier style in
> header files related to drivers for USB Network devices.
> This patch gives an explicit block comment to the
> SPDX License Identifier.
> 
> Changes made by using a script provided by Joe Perches here:
> https://lkml.org/lkml/2019/2/7/46.
> 
> Suggested-by: Joe Perches <joe@perches.com>
> Signed-off-by: Nishad Kamdar <nishadkamdar@gmail.com>

Applied.
