Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B04C1F71AB
	for <lists+netdev@lfdr.de>; Fri, 12 Jun 2020 03:26:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726510AbgFLB0j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Jun 2020 21:26:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726505AbgFLB0g (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Jun 2020 21:26:36 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FF7CC03E96F
        for <netdev@vger.kernel.org>; Thu, 11 Jun 2020 18:26:36 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 127A8128B13FF;
        Thu, 11 Jun 2020 18:26:36 -0700 (PDT)
Date:   Thu, 11 Jun 2020 18:26:35 -0700 (PDT)
Message-Id: <20200611.182635.1261447111472536789.davem@davemloft.net>
To:     snelson@pensando.io
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH net] ionic: add pcie_print_link_status
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200612001815.48182-1-snelson@pensando.io>
References: <20200612001815.48182-1-snelson@pensando.io>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 11 Jun 2020 18:26:36 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Shannon Nelson <snelson@pensando.io>
Date: Thu, 11 Jun 2020 17:18:15 -0700

> Print the PCIe link information for our device.
> 
> Fixes: 77f972a7077d ("ionic: remove support for mgmt device")
> Signed-off-by: Shannon Nelson <snelson@pensando.io>

Applied, thank you.
