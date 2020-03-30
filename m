Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 88C04197393
	for <lists+netdev@lfdr.de>; Mon, 30 Mar 2020 06:50:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728088AbgC3Eul (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Mar 2020 00:50:41 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:33098 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726085AbgC3Euk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Mar 2020 00:50:40 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 62EFC15C54861;
        Sun, 29 Mar 2020 21:50:40 -0700 (PDT)
Date:   Sun, 29 Mar 2020 21:50:39 -0700 (PDT)
Message-Id: <20200329.215039.1358234093708415942.davem@davemloft.net>
To:     ybason@marvell.com
Cc:     netdev@vger.kernel.org, dbolotin@marvell.com, mkalderon@marvell.com
Subject: Re: [PATCH v2 net-next] qed: Fix race condition between scheduling
 and destroying the slowpath workqueue
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200325205043.23157-1-ybason@marvell.com>
References: <20200325205043.23157-1-ybason@marvell.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 29 Mar 2020 21:50:40 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yuval Basson <ybason@marvell.com>
Date: Wed, 25 Mar 2020 22:50:43 +0200

> Calling queue_delayed_work concurrently with
> destroy_workqueue might race to an unexpected outcome -
> scheduled task after wq is destroyed or other resources
> (like ptt_pool) are freed (yields NULL pointer dereference).
> cancel_delayed_work prevents the race by cancelling
> the timer triggered for scheduling a new task.
> 
> Fixes: 59ccf86fe ("qed: Add driver infrastucture for handling mfw requests")
> Signed-off-by: Denis Bolotin <dbolotin@marvell.com>
> Signed-off-by: Michal Kalderon <mkalderon@marvell.com>
> Signed-off-by: Yuval Basson <ybason@marvell.com>

Applied.
