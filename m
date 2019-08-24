Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F23A69C100
	for <lists+netdev@lfdr.de>; Sun, 25 Aug 2019 01:35:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728211AbfHXXfB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 24 Aug 2019 19:35:01 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:48588 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728177AbfHXXfB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 24 Aug 2019 19:35:01 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id B1DB515260056;
        Sat, 24 Aug 2019 16:35:00 -0700 (PDT)
Date:   Sat, 24 Aug 2019 16:35:00 -0700 (PDT)
Message-Id: <20190824.163500.1308650294352576667.davem@davemloft.net>
To:     michael.chan@broadcom.com
Cc:     jonathan.lemon@gmail.com, netdev@vger.kernel.org
Subject: Re: [PATCH net-next] bnxt_en: Fix allocation of zero statistics
 block size regression.
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1566539501-5884-1-git-send-email-michael.chan@broadcom.com>
References: <1566539501-5884-1-git-send-email-michael.chan@broadcom.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sat, 24 Aug 2019 16:35:00 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Michael Chan <michael.chan@broadcom.com>
Date: Fri, 23 Aug 2019 01:51:41 -0400

> Recent commit added logic to determine the appropriate statistics block
> size to allocate and the size is stored in bp->hw_ring_stats_size.  But
> if the firmware spec is older than 1.6.0, it is 0 and not initialized.
> This causes the allocation to fail with size 0 and bnxt_open() to
> abort.  Fix it by always initializing bp->hw_ring_stats_size to the
> legacy default size value.
> 
> Fixes: 4e7485066373 ("bnxt_en: Allocate the larger per-ring statistics block for 57500 chips.")
> Reported-by: Jonathan Lemon <jonathan.lemon@gmail.com>
> Signed-off-by: Michael Chan <michael.chan@broadcom.com>

Applied.
