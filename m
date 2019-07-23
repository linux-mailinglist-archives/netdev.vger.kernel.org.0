Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4FB297212E
	for <lists+netdev@lfdr.de>; Tue, 23 Jul 2019 22:58:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391874AbfGWU6x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jul 2019 16:58:53 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:36686 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389103AbfGWU6x (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Jul 2019 16:58:53 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id D8728153BE46A;
        Tue, 23 Jul 2019 13:58:52 -0700 (PDT)
Date:   Tue, 23 Jul 2019 13:58:52 -0700 (PDT)
Message-Id: <20190723.135852.749823613047584607.davem@davemloft.net>
To:     andriy.shevchenko@linux.intel.com
Cc:     haiyangz@microsoft.com, kys@microsoft.com, sthemmin@microsoft.com,
        sashal@kernel.org, linux-hyperv@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH v1] hv_sock: Use consistent types for UUIDs
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190723163943.65991-1-andriy.shevchenko@linux.intel.com>
References: <20190723163943.65991-1-andriy.shevchenko@linux.intel.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 23 Jul 2019 13:58:53 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Date: Tue, 23 Jul 2019 19:39:43 +0300

> The rest of Hyper-V code is using new types for UUID handling.
> Convert hv_sock as well.
> 
> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

Applied to net-next.
