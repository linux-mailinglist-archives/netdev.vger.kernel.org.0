Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 732303ABC5
	for <lists+netdev@lfdr.de>; Sun,  9 Jun 2019 22:30:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727697AbfFIUav (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 Jun 2019 16:30:51 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:45430 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725933AbfFIUav (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 9 Jun 2019 16:30:51 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 7E48614DF40B9;
        Sun,  9 Jun 2019 13:30:50 -0700 (PDT)
Date:   Sun, 09 Jun 2019 13:30:49 -0700 (PDT)
Message-Id: <20190609.133049.329493904557757962.davem@davemloft.net>
To:     nirranjan@chelsio.com
Cc:     netdev@vger.kernel.org, vishal@chelsio.com, dt@chelsio.com,
        indranil@chelsio.com
Subject: Re: [PATCH net-next v2] cxgb4: Set initial IRQ affinity hints
From:   David Miller <davem@davemloft.net>
In-Reply-To: <4733c676ad43301a4865f87117245aede50cf27a.1559907407.git.nirranjan@chelsio.com>
References: <4733c676ad43301a4865f87117245aede50cf27a.1559907407.git.nirranjan@chelsio.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 09 Jun 2019 13:30:50 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Nirranjan Kirubaharan <nirranjan@chelsio.com>
Date: Fri,  7 Jun 2019 04:56:45 -0700

> Spread initial IRQ affinity hints across the device node CPUs,
> for nic queue and uld queue IRQs, to load balance and avoid
> all interrupts on CPU0.
> 
> Signed-off-by: Nirranjan Kirubaharan <nirranjan@chelsio.com>
> ---
> v2:
> - Used post increment of msi_index instead of pre increment in
>   request_msix_queue_irqs() during unwind.
> - Fixed build error Reported-by: kbuild test robot <lkp@intel.com>
>   on xtensa architecture.

Applied.
