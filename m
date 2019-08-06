Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9B121838E4
	for <lists+netdev@lfdr.de>; Tue,  6 Aug 2019 20:44:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726395AbfHFSnx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Aug 2019 14:43:53 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:47920 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726009AbfHFSnx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Aug 2019 14:43:53 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 4C3F2152488FD;
        Tue,  6 Aug 2019 11:43:52 -0700 (PDT)
Date:   Tue, 06 Aug 2019 11:43:51 -0700 (PDT)
Message-Id: <20190806.114351.538219207946033327.davem@davemloft.net>
To:     ptpt52@gmail.com
Cc:     kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net/ipv4: reset mac head before call ip_tunnel_rcv()
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190806104731.30603-1-ptpt52@gmail.com>
References: <20190806104731.30603-1-ptpt52@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 06 Aug 2019 11:43:52 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Chen Minqiang <ptpt52@gmail.com>
Date: Tue,  6 Aug 2019 18:47:31 +0800

> Signed-off-by: Chen Minqiang <ptpt52@gmail.com>

No commit message means I'm not even going to look at this patch and
try to understand it.

You must always completely explain, in detail, what change you are
making, how you are making it, and above all why you are making this
change.

Is there some bug you are fixing?  What is that bug and what does that
bug cause to happen?  Are there potential negative side effects to
your fix?  What are they and what was the cost/benefit analysis for
that?

Where was the bug introduced?  You must provide a proper Fixes: tag
which shows this.

Thank you.
