Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 977C947E17A
	for <lists+netdev@lfdr.de>; Thu, 23 Dec 2021 11:31:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347720AbhLWKbx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Dec 2021 05:31:53 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:39804 "EHLO
        mail.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243143AbhLWKbw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Dec 2021 05:31:52 -0500
Received: from localhost (cpc147930-brnt3-2-0-cust60.4-2.cable.virginm.net [86.15.196.61])
        by mail.monkeyblade.net (Postfix) with ESMTPSA id 2C925822C719;
        Thu, 23 Dec 2021 02:31:51 -0800 (PST)
Date:   Thu, 23 Dec 2021 10:31:49 +0000 (GMT)
Message-Id: <20211223.103149.825735146093627307.davem@davemloft.net>
To:     saeed@kernel.org
Cc:     kuba@kernel.org, netdev@vger.kernel.org, roid@nvidia.com,
        saeedm@nvidia.com
Subject: Re: [pull request][net 00/11] mlx5 fixes 2021-12-22
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20211222211201.77469-1-saeed@kernel.org>
References: <20211222211201.77469-1-saeed@kernel.org>
X-Mailer: Mew version 6.8 on Emacs 27.2
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.6.2 (mail.monkeyblade.net [0.0.0.0]); Thu, 23 Dec 2021 02:31:52 -0800 (PST)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Saeed Mahameed <saeed@kernel.org>
Date: Wed, 22 Dec 2021 13:11:50 -0800

> From: Saeed Mahameed <saeedm@nvidia.com>
> 
> Hi Dave, Hi Jakub,
> 
> This series provides bug fixes to mlx5 driver.
> Please pull and let me know if there is any problem.
> 
> Additionally and unrelated to this pull, I would like to kindly request
> to cherry-pick the following fix commit from net-next branch into net:
> 31108d142f36 ("net/mlx5: Fix some error handling paths in ...")
> 
> The following changes since commit 9b8bdd1eb5890aeeab7391dddcf8bd51f7b07216:
> 
>   sfc: falcon: Check null pointer of rx_queue->page_ring (2021-12-22 12:25:18 -0800)
> 
> are available in the Git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/saeed/linux.git tags/mlx5-fixes-2021-12-22

Pulled.

That cherry pick doesn't come close to applying to the current tree.

Could you submit it yourself after fixing that?

Thank you.
