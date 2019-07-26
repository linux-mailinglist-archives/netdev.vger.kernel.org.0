Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 31D8275BF4
	for <lists+netdev@lfdr.de>; Fri, 26 Jul 2019 02:10:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727126AbfGZAKj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Jul 2019 20:10:39 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:41178 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726942AbfGZAKj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Jul 2019 20:10:39 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 9CC8B1264FD96;
        Thu, 25 Jul 2019 17:10:38 -0700 (PDT)
Date:   Thu, 25 Jul 2019 17:10:35 -0700 (PDT)
Message-Id: <20190725.171035.1763189160830260893.davem@davemloft.net>
To:     skalluru@marvell.com
Cc:     netdev@vger.kernel.org, manishc@marvell.com, mkalderon@marvell.com
Subject: Re: [PATCH net 1/1] bnx2x: Disable multi-cos feature.
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190724023241.24794-1-skalluru@marvell.com>
References: <20190724023241.24794-1-skalluru@marvell.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 25 Jul 2019 17:10:38 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sudarsana Reddy Kalluru <skalluru@marvell.com>
Date: Tue, 23 Jul 2019 19:32:41 -0700

> Commit 3968d38917eb ("bnx2x: Fix Multi-Cos.") which enabled multi-cos
> feature after prolonged time in driver added some regression causing
> numerous issues (sudden reboots, tx timeout etc.) reported by customers.
> We plan to backout this commit and submit proper fix once we have root
> cause of issues reported with this feature enabled.
> 
> Fixes: 3968d38917eb ("bnx2x: Fix Multi-Cos.")
> Signed-off-by: Sudarsana Reddy Kalluru <skalluru@marvell.com>
> Signed-off-by: Manish Chopra <manishc@marvell.com>

Applied and queued up for -stable.
