Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3099B7B4FA
	for <lists+netdev@lfdr.de>; Tue, 30 Jul 2019 23:25:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387762AbfG3VZL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jul 2019 17:25:11 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:55518 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387649AbfG3VZL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Jul 2019 17:25:11 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 2F9E7143750FA;
        Tue, 30 Jul 2019 14:25:10 -0700 (PDT)
Date:   Tue, 30 Jul 2019 14:25:09 -0700 (PDT)
Message-Id: <20190730.142509.1116873625739020925.davem@davemloft.net>
To:     swboyd@chromium.org
Cc:     linux-kernel@vger.kernel.org, kvalo@codeaurora.org,
        saeedm@mellanox.com, jeffrey.t.kirsher@intel.com, nbd@nbd.name,
        lorenzo@kernel.org, netdev@vger.kernel.org,
        gregkh@linuxfoundation.org
Subject: Re: [PATCH v6 51/57] net: Remove dev_err() usage after
 platform_get_irq()
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190730181557.90391-52-swboyd@chromium.org>
References: <20190730181557.90391-1-swboyd@chromium.org>
        <20190730181557.90391-52-swboyd@chromium.org>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 30 Jul 2019 14:25:10 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Stephen Boyd <swboyd@chromium.org>
Date: Tue, 30 Jul 2019 11:15:51 -0700

> We don't need dev_err() messages when platform_get_irq() fails now that
> platform_get_irq() prints an error message itself when something goes
> wrong. Let's remove these prints with a simple semantic patch.
 ...
> While we're here, remove braces on if statements that only have one
> statement (manually).
 ...
> Signed-off-by: Stephen Boyd <swboyd@chromium.org>
> ---
> 
> Please apply directly to subsystem trees

I'll take this into net-next.
