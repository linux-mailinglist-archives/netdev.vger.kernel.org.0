Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F3007D84CE
	for <lists+netdev@lfdr.de>; Wed, 16 Oct 2019 02:27:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388078AbfJPA1D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Oct 2019 20:27:03 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:42314 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728556AbfJPA1D (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Oct 2019 20:27:03 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 5E550120477A4;
        Tue, 15 Oct 2019 17:27:02 -0700 (PDT)
Date:   Tue, 15 Oct 2019 17:27:01 -0700 (PDT)
Message-Id: <20191015.172701.464446938727284882.davem@davemloft.net>
To:     mikelley@microsoft.com
Cc:     kys@microsoft.com, haiyangz@microsoft.com, sthemmin@microsoft.com,
        sashal@kernel.org, linux-hyperv@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        himadrispandya@gmail.com
Subject: Re: [PATCH net-next v2] hv_sock: use HV_HYP_PAGE_SIZE for Hyper-V
 communication
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1570926595-8877-1-git-send-email-mikelley@microsoft.com>
References: <1570926595-8877-1-git-send-email-mikelley@microsoft.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 15 Oct 2019 17:27:02 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Michael Kelley <mikelley@microsoft.com>
Date: Sun, 13 Oct 2019 00:30:21 +0000

> From: Himadri Pandya <himadrispandya@gmail.com>
> 
> Current code assumes PAGE_SIZE (the guest page size) is equal
> to the page size used to communicate with Hyper-V (which is
> always 4K). While this assumption is true on x86, it may not
> be true for Hyper-V on other architectures. For example,
> Linux on ARM64 may have PAGE_SIZE of 16K or 64K. A new symbol,
> HV_HYP_PAGE_SIZE, has been previously introduced to use when
> the Hyper-V page size is intended instead of the guest page size.
> 
> Make this code work on non-x86 architectures by using the new
> HV_HYP_PAGE_SIZE symbol instead of PAGE_SIZE, where appropriate.
> Also replace the now redundant PAGE_SIZE_4K with HV_HYP_PAGE_SIZE.
> The change has no effect on x86, but lays the groundwork to run
> on ARM64 and others.
> 
> Signed-off-by: Himadri Pandya <himadrispandya@gmail.com>
> Reviewed-by: Michael Kelley <mikelley@microsoft.com>
> ---
> 
> Changes in v2:
> * Revised commit message and subject [Jakub Kicinski]

Applied, thank you.
