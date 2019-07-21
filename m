Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2A8E76F4FC
	for <lists+netdev@lfdr.de>; Sun, 21 Jul 2019 21:30:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726907AbfGUTao (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 21 Jul 2019 15:30:44 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:34200 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726441AbfGUTao (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 21 Jul 2019 15:30:44 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id E3EE91525F73D;
        Sun, 21 Jul 2019 12:30:43 -0700 (PDT)
Date:   Sun, 21 Jul 2019 12:29:58 -0700 (PDT)
Message-Id: <20190721.122958.2149147089244843871.davem@davemloft.net>
To:     brking@linux.vnet.ibm.com
Cc:     GR-everest-linux-l2@marvell.com, skalluru@marvell.com,
        aelior@marvell.com, netdev@vger.kernel.org
Subject: Re: [PATCH] bnx2x: Prevent load reordering in tx completion
 processing
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1563226910-21660-1-git-send-email-brking@linux.vnet.ibm.com>
References: <1563226910-21660-1-git-send-email-brking@linux.vnet.ibm.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 21 Jul 2019 12:30:44 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Brian King <brking@linux.vnet.ibm.com>
Date: Mon, 15 Jul 2019 16:41:50 -0500

> This patch fixes an issue seen on Power systems with bnx2x which results
> in the skb is NULL WARN_ON in bnx2x_free_tx_pkt firing due to the skb
> pointer getting loaded in bnx2x_free_tx_pkt prior to the hw_cons
> load in bnx2x_tx_int. Adding a read memory barrier resolves the issue.
> 
> Signed-off-by: Brian King <brking@linux.vnet.ibm.com>

Applied and queued up for -stable.
