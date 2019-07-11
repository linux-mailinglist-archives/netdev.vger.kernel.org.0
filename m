Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D5C93661B3
	for <lists+netdev@lfdr.de>; Fri, 12 Jul 2019 00:27:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728796AbfGKW1h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Jul 2019 18:27:37 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:47872 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726207AbfGKW1h (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Jul 2019 18:27:37 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 1A07014DB6E01;
        Thu, 11 Jul 2019 15:27:36 -0700 (PDT)
Date:   Thu, 11 Jul 2019 15:27:35 -0700 (PDT)
Message-Id: <20190711.152735.361922691427250351.davem@davemloft.net>
To:     santosh.shilimkar@oracle.com
Cc:     netdev@vger.kernel.org
Subject: Re: [net][PATCH 0/5] rds fixes
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1562736764-31752-1-git-send-email-santosh.shilimkar@oracle.com>
References: <1562736764-31752-1-git-send-email-santosh.shilimkar@oracle.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 11 Jul 2019 15:27:36 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Santosh Shilimkar <santosh.shilimkar@oracle.com>
Date: Tue,  9 Jul 2019 22:32:39 -0700

> Few rds fixes which makes rds rdma transport reliably working on mainline
> 
> First two fixes are applicable to v4.11+ stable versions and last
> three patches applies to only v5.1 stable and current mainline.
> 
> Patchset is re-based against 'net' and also available on below tree
> 
> The following changes since commit 1ff2f0fa450ea4e4f87793d9ed513098ec6e12be:
> 
>   net/mlx5e: Return in default case statement in tx_post_resync_params (2019-07-09 21:40:20 -0700)
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/ssantosh/linux.git net/rds-fixes

Pulled, thanks.
