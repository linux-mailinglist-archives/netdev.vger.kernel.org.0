Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A4FE85B248
	for <lists+netdev@lfdr.de>; Mon,  1 Jul 2019 01:01:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727199AbfF3XBH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 30 Jun 2019 19:01:07 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:59438 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727167AbfF3XBH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 30 Jun 2019 19:01:07 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 8FAAC1492090C;
        Sun, 30 Jun 2019 16:01:06 -0700 (PDT)
Date:   Sun, 30 Jun 2019 16:01:04 -0700 (PDT)
Message-Id: <20190630.160104.1315931359300425036.davem@davemloft.net>
To:     michael.chan@broadcom.com
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH net 0/5] bnxt_en: Bug fixes.
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1561821408-17418-1-git-send-email-michael.chan@broadcom.com>
References: <1561821408-17418-1-git-send-email-michael.chan@broadcom.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 30 Jun 2019 16:01:06 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Michael Chan <michael.chan@broadcom.com>
Date: Sat, 29 Jun 2019 11:16:43 -0400

> Miscellaneous bug fix patches, including two resource handling fixes for
> the RDMA driver, a PCI shutdown patch to add pci_disable_device(), a patch
> to fix ethtool selftest crash, and the last one suppresses an unnecessry
> error message.

Series applied.

> Please also queue patches 1, 2, and 3 for -stable.  Thanks.

Queued up.
