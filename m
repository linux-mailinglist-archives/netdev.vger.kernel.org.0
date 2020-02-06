Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 409171544BE
	for <lists+netdev@lfdr.de>; Thu,  6 Feb 2020 14:20:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727753AbgBFNUy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Feb 2020 08:20:54 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:59472 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726744AbgBFNUy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Feb 2020 08:20:54 -0500
Received: from localhost (unknown [IPv6:2001:982:756:1:57a7:3bfd:5e85:defb])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 4F57214C7E034;
        Thu,  6 Feb 2020 05:20:53 -0800 (PST)
Date:   Thu, 06 Feb 2020 14:20:51 +0100 (CET)
Message-Id: <20200206.142051.1794009874626339490.davem@davemloft.net>
To:     hkallweit1@gmail.com
Cc:     nic_swsd@realtek.com, netdev@vger.kernel.org
Subject: Re: [PATCH net] r8169: fix performance regression related to PCIe
 max read request size
From:   David Miller <davem@davemloft.net>
In-Reply-To: <342eb05f-0376-cb0f-5fea-cb1f171b4fdb@gmail.com>
References: <342eb05f-0376-cb0f-5fea-cb1f171b4fdb@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 06 Feb 2020 05:20:53 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Heiner Kallweit <hkallweit1@gmail.com>
Date: Wed, 5 Feb 2020 21:22:46 +0100

> It turned out that on low performance systems the original change can
> cause lower tx performance. On a N3450-based mini-PC tx performance
> in iperf3 was reduced from 950Mbps to ~900Mbps. Therefore effectively
> revert the original change, just use pcie_set_readrq() now instead of
> changing the PCIe capability register directly.
> 
> Fixes: 2df49d365498 ("r8169: remove fiddling with the PCIe max read request size")
> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>

Applied and queued up for v5.5 -stable, thanks.
