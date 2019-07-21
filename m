Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 513736F595
	for <lists+netdev@lfdr.de>; Sun, 21 Jul 2019 22:30:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727559AbfGUUaR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 21 Jul 2019 16:30:17 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:34694 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725944AbfGUUaQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 21 Jul 2019 16:30:16 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 1321C1526593A;
        Sun, 21 Jul 2019 13:30:16 -0700 (PDT)
Date:   Sun, 21 Jul 2019 13:30:15 -0700 (PDT)
Message-Id: <20190721.133015.1866356980405870780.davem@davemloft.net>
To:     fred@fredlawl.com
Cc:     aelior@marvell.com, GR-everest-linux-l2@marvell.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        bhelgaas@google.com
Subject: Re: [PATCH] qed: Prefer pcie_capability_read_word()
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190718020745.8867-7-fred@fredlawl.com>
References: <20190718020745.8867-1-fred@fredlawl.com>
        <20190718020745.8867-7-fred@fredlawl.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 21 Jul 2019 13:30:16 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Frederick Lawler <fred@fredlawl.com>
Date: Wed, 17 Jul 2019 21:07:42 -0500

> Commit 8c0d3a02c130 ("PCI: Add accessors for PCI Express Capability")
> added accessors for the PCI Express Capability so that drivers didn't
> need to be aware of differences between v1 and v2 of the PCI
> Express Capability.
> 
> Replace pci_read_config_word() and pci_write_config_word() calls with
> pcie_capability_read_word() and pcie_capability_write_word().
> 
> Signed-off-by: Frederick Lawler <fred@fredlawl.com>

Applied.
