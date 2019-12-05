Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6805F1138E3
	for <lists+netdev@lfdr.de>; Thu,  5 Dec 2019 01:36:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728539AbfLEAgl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Dec 2019 19:36:41 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:38198 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728011AbfLEAgk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Dec 2019 19:36:40 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1c3::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id C4EA114F1EDA3;
        Wed,  4 Dec 2019 16:36:39 -0800 (PST)
Date:   Wed, 04 Dec 2019 16:36:39 -0800 (PST)
Message-Id: <20191204.163639.1986460530334668542.davem@davemloft.net>
To:     jonathan.lemon@gmail.com
Cc:     netdev@vger.kernel.org, kernel-team@fb.com, brouer@redhat.com,
        grygorii.strashko@ti.com
Subject: Re: [net PATCH] xdp: obtain the mem_id mutex before trying to
 remove an entry.
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191203220114.1524992-1-jonathan.lemon@gmail.com>
References: <20191203220114.1524992-1-jonathan.lemon@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 04 Dec 2019 16:36:40 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jonathan Lemon <jonathan.lemon@gmail.com>
Date: Tue, 3 Dec 2019 14:01:14 -0800

> A lockdep splat was observed when trying to remove an xdp memory
> model from the table since the mutex was obtained when trying to
> remove the entry, but not before the table walk started:
> 
> Fix the splat by obtaining the lock before starting the table walk.
> 
> Fixes: c3f812cea0d7 ("page_pool: do not release pool until inflight == 0.")
> Reported-by: Grygorii Strashko <grygorii.strashko@ti.com>
> Signed-off-by: Jonathan Lemon <jonathan.lemon@gmail.com>

Applied, and since this fixes a bug fix that went back to v5.3 in -stable
I will queue it there as well.

Thanks.
