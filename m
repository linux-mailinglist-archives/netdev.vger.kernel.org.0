Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0FD76E5815
	for <lists+netdev@lfdr.de>; Sat, 26 Oct 2019 04:30:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726079AbfJZCap (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Oct 2019 22:30:45 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:39842 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725955AbfJZCap (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Oct 2019 22:30:45 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 2123614B7A0B1;
        Fri, 25 Oct 2019 19:30:44 -0700 (PDT)
Date:   Fri, 25 Oct 2019 19:30:42 -0700 (PDT)
Message-Id: <20191025.193042.2056491201491217086.davem@davemloft.net>
To:     nishadkamdar@gmail.com
Cc:     ulli.kroll@googlemail.com, linus.walleij@linaro.org,
        gregkh@linuxfoundation.org, joe@perches.com,
        u.kleine-koenig@pengutronix.de,
        linux-arm-kernel@lists.infradead.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: ethernet: Use the correct style for SPDX License
 Identifier
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191023152634.GA3749@nishad>
References: <20191023152634.GA3749@nishad>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 25 Oct 2019 19:30:44 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Nishad Kamdar <nishadkamdar@gmail.com>
Date: Wed, 23 Oct 2019 20:56:38 +0530

> This patch corrects the SPDX License Identifier style in
> header file related to ethernet driver for Cortina Gemini
> devices. For C header files Documentation/process/license-rules.rst
> mandates C-like comments (opposed to C source files where
> C++ style should be used)
> 
> Changes made by using a script provided by Joe Perches here:
> https://lkml.org/lkml/2019/2/7/46.
> 
> Suggested-by: Joe Perches <joe@perches.com>
> Signed-off-by: Nishad Kamdar <nishadkamdar@gmail.com>

Applied, thanks.
