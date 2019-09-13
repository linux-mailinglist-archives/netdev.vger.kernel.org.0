Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 19B65B2667
	for <lists+netdev@lfdr.de>; Fri, 13 Sep 2019 22:04:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730962AbfIMUDs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Sep 2019 16:03:48 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:48654 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729118AbfIMUDs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Sep 2019 16:03:48 -0400
Received: from localhost (93-63-141-166.ip28.fastwebnet.it [93.63.141.166])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 963BC1539AD18;
        Fri, 13 Sep 2019 13:03:45 -0700 (PDT)
Date:   Fri, 13 Sep 2019 21:03:43 +0100 (WEST)
Message-Id: <20190913.210343.724088723062134961.davem@davemloft.net>
To:     decui@microsoft.com
Cc:     kys@microsoft.com, haiyangz@microsoft.com, sthemmin@microsoft.com,
        sashal@kernel.org, linux-hyperv@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        mikelley@microsoft.com
Subject: Re: [PATCH][PATCH net-next] hv_sock: Add the support of hibernation
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1568245042-66967-1-git-send-email-decui@microsoft.com>
References: <1568245042-66967-1-git-send-email-decui@microsoft.com>
X-Mailer: Mew version 6.8 on Emacs 26.2
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 13 Sep 2019 13:03:47 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dexuan Cui <decui@microsoft.com>
Date: Wed, 11 Sep 2019 23:37:27 +0000

> Add the necessary dummy callbacks for hibernation.
> 
> Signed-off-by: Dexuan Cui <decui@microsoft.com>
> ---
> This patch is basically a pure Hyper-V specific change and it has a
> build dependency on the commit 271b2224d42f ("Drivers: hv: vmbus: Implement
> suspend/resume for VSC drivers for hibernation"), which is on Sasha Levin's
> Hyper-V tree's hyperv-next branch:
> https://git.kernel.org/pub/scm/linux/kernel/git/hyperv/linux.git/log/?h=hyperv-next
> 
> I request this patch should go through Sasha's tree rather than the
> net-next tree.

That's fine:

Acked-by: David S. Miller <davem@davemloft.net>
