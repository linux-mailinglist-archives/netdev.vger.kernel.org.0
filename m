Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A1C9D39E881
	for <lists+netdev@lfdr.de>; Mon,  7 Jun 2021 22:33:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231288AbhFGUfk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Jun 2021 16:35:40 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:53192 "EHLO
        mail.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230454AbhFGUfj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Jun 2021 16:35:39 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        by mail.monkeyblade.net (Postfix) with ESMTPSA id 567894F5F1FDD;
        Mon,  7 Jun 2021 13:33:47 -0700 (PDT)
Date:   Mon, 07 Jun 2021 13:33:46 -0700 (PDT)
Message-Id: <20210607.133346.155691512247470187.davem@davemloft.net>
To:     kgraul@linux.ibm.com
Cc:     kuba@kernel.org, hca@linux.ibm.com, raspl@linux.ibm.com,
        netdev@vger.kernel.org, linux-s390@vger.kernel.org
Subject: Re: [PATCH net-next 0/4] net/smc: Add SMC statistic support
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20210607182014.3384922-1-kgraul@linux.ibm.com>
References: <20210607182014.3384922-1-kgraul@linux.ibm.com>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.6.2 (mail.monkeyblade.net [0.0.0.0]); Mon, 07 Jun 2021 13:33:47 -0700 (PDT)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Karsten Graul <kgraul@linux.ibm.com>
Date: Mon,  7 Jun 2021 20:20:10 +0200

> Please apply the following patch series for smc to netdev's net-next tree.
> 
> The patchset adds statistic support to the SMC protocol. Per-cpu
> variables are used to collect the statistic information for better
> performance and for reducing concurrency pitfalls. The code that is
> collecting statistic data is implemented in macros to increase code
> reuse and readability.
> The generic netlink mechanism in SMC is extended to provide the
> collected statistics to userspace.
> Network namespace awareness is also part of the statistics
> implementation.

Why not use ethtool stats?

Thank you.
