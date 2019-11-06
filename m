Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3761AF0BC0
	for <lists+netdev@lfdr.de>; Wed,  6 Nov 2019 02:46:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730797AbfKFBqs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Nov 2019 20:46:48 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:41766 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730764AbfKFBqr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Nov 2019 20:46:47 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id F168A150BD0EC;
        Tue,  5 Nov 2019 17:46:46 -0800 (PST)
Date:   Tue, 05 Nov 2019 17:46:46 -0800 (PST)
Message-Id: <20191105.174646.876955038047137615.davem@davemloft.net>
To:     nishadkamdar@gmail.com
Cc:     yisen.zhuang@huawei.com, salil.mehta@huawei.com,
        gregkh@linuxfoundation.org, joe@perches.com,
        u.kleine-koenig@pengutronix.de, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: hns3: Use the correct style for SPDX License
 Identifier
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191102114436.GA4375@nishad>
References: <20191102114436.GA4375@nishad>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 05 Nov 2019 17:46:47 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Nishad Kamdar <nishadkamdar@gmail.com>
Date: Sat, 2 Nov 2019 17:14:42 +0530

> This patch corrects the SPDX License Identifier style in
> header files related to Hisilicon network devices. For C header files
> Documentation/process/license-rules.rst mandates C-like comments
> (opposed to C source files where C++ style should be used)
> 
> Changes made by using a script provided by Joe Perches here:
> https://lkml.org/lkml/2019/2/7/46.
> 
> Suggested-by: Joe Perches <joe@perches.com>
> Signed-off-by: Nishad Kamdar <nishadkamdar@gmail.com>

Applied.
