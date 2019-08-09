Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 264B8871A1
	for <lists+netdev@lfdr.de>; Fri,  9 Aug 2019 07:41:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405336AbfHIFlY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Aug 2019 01:41:24 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:56274 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725879AbfHIFlX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Aug 2019 01:41:23 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id F019C14470BBA;
        Thu,  8 Aug 2019 22:41:22 -0700 (PDT)
Date:   Thu, 08 Aug 2019 22:41:22 -0700 (PDT)
Message-Id: <20190808.224122.502527952774552494.davem@davemloft.net>
To:     efremov@linux.com
Cc:     bjorn.helgaas@gmail.com, dchickles@marvell.com, sburla@marvell.com,
        fmanlunas@marvell.com, netdev@vger.kernel.org,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] liquidio: Use pcie_flr() instead of reimplementing it
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190808045753.5474-1-efremov@linux.com>
References: <20190808045753.5474-1-efremov@linux.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 08 Aug 2019 22:41:23 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Denis Efremov <efremov@linux.com>
Date: Thu,  8 Aug 2019 07:57:53 +0300

> octeon_mbox_process_cmd() directly writes the PCI_EXP_DEVCTL_BCR_FLR
> bit, which bypasses timing requirements imposed by the PCIe spec.
> This patch fixes the function to use the pcie_flr() interface instead.
> 
> Signed-off-by: Denis Efremov <efremov@linux.com>

Applied to net-next.
