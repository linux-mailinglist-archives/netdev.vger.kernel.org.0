Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 518398F4CB
	for <lists+netdev@lfdr.de>; Thu, 15 Aug 2019 21:38:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732916AbfHOThz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Aug 2019 15:37:55 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:49114 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732777AbfHOThy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Aug 2019 15:37:54 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id C449B1400EC46;
        Thu, 15 Aug 2019 12:37:53 -0700 (PDT)
Date:   Thu, 15 Aug 2019 12:37:53 -0700 (PDT)
Message-Id: <20190815.123753.513875593712522152.davem@davemloft.net>
To:     wenwen@cs.uga.edu
Cc:     dchickles@marvell.com, sburla@marvell.com, fmanlunas@marvell.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] liquidio: add cleanup in octeon_setup_iq()
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1565759689-5941-1-git-send-email-wenwen@cs.uga.edu>
References: <1565759689-5941-1-git-send-email-wenwen@cs.uga.edu>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 15 Aug 2019 12:37:54 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Wenwen Wang <wenwen@cs.uga.edu>
Date: Wed, 14 Aug 2019 00:14:49 -0500

> If oct->fn_list.enable_io_queues() fails, no cleanup is executed, leading
> to memory/resource leaks. To fix this issue, invoke
> octeon_delete_instr_queue() before returning from the function.
> 
> Signed-off-by: Wenwen Wang <wenwen@cs.uga.edu>

Applied.
