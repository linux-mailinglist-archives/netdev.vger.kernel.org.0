Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CD9457D1A9
	for <lists+netdev@lfdr.de>; Thu,  1 Aug 2019 01:04:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730094AbfGaXEP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Jul 2019 19:04:15 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:45206 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726417AbfGaXEO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Jul 2019 19:04:14 -0400
Received: from localhost (c-24-20-22-31.hsd1.or.comcast.net [24.20.22.31])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 38EBD1254613D;
        Wed, 31 Jul 2019 16:04:14 -0700 (PDT)
Date:   Wed, 31 Jul 2019 19:04:13 -0400 (EDT)
Message-Id: <20190731.190413.1782006239456872904.davem@davemloft.net>
To:     nikolay@cumulusnetworks.com
Cc:     netdev@vger.kernel.org, roopa@cumulusnetworks.com,
        bridge@lists.linux-foundation.org
Subject: Re: [PATCH net] net: bridge: mcast: don't delete permanent entries
 when fast leave is enabled
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190730112100.18156-1-nikolay@cumulusnetworks.com>
References: <20190730112100.18156-1-nikolay@cumulusnetworks.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 31 Jul 2019 16:04:14 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
Date: Tue, 30 Jul 2019 14:21:00 +0300

> When permanent entries were introduced by the commit below, they were
> exempt from timing out and thus igmp leave wouldn't affect them unless
> fast leave was enabled on the port which was added before permanent
> entries existed. It shouldn't matter if fast leave is enabled or not
> if the user added a permanent entry it shouldn't be deleted on igmp
> leave.
 ...
> Fixes: ccb1c31a7a87 ("bridge: add flags to distinguish permanent mdb entires")
> Signed-off-by: Nikolay Aleksandrov <nikolay@cumulusnetworks.com>

Applied and queued up for -stable.
