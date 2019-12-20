Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4E252128469
	for <lists+netdev@lfdr.de>; Fri, 20 Dec 2019 23:14:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727507AbfLTWOP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Dec 2019 17:14:15 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:54296 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727413AbfLTWOP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Dec 2019 17:14:15 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1c3::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 6DCA91504494F;
        Fri, 20 Dec 2019 14:14:14 -0800 (PST)
Date:   Fri, 20 Dec 2019 14:14:11 -0800 (PST)
Message-Id: <20191220.141411.1525508525740394923.davem@davemloft.net>
To:     rahul.lakkireddy@chelsio.com
Cc:     netdev@vger.kernel.org, nirranjan@chelsio.com, vishal@chelsio.com,
        dt@chelsio.com
Subject: Re: [PATCH net v2] cxgb4: fix refcount init for TC-MQPRIO offload
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1576640969-15807-1-git-send-email-rahul.lakkireddy@chelsio.com>
References: <1576640969-15807-1-git-send-email-rahul.lakkireddy@chelsio.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 20 Dec 2019 14:14:14 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Rahul Lakkireddy <rahul.lakkireddy@chelsio.com>
Date: Wed, 18 Dec 2019 09:19:29 +0530

> Properly initialize refcount to 1 when hardware queue arrays for
> TC-MQPRIO offload have been freshly allocated. Otherwise, following
> warning is observed. Also fix up error path to only free hardware
> queue arrays when refcount reaches 0.
 ...
> v2:
> - Move the refcount_set() closer to where the hardware queue arrays
>   are being allocated.
> - Fix up error path to only free hardware queue arrays when refcount
>   reaches 0.
> 
> Fixes: 2d0cb84dd973 ("cxgb4: add ETHOFLD hardware queue support")
> Signed-off-by: Rahul Lakkireddy <rahul.lakkireddy@chelsio.com>

Applied, thank you.
