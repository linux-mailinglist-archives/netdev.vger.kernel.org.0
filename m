Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C9E72113F6
	for <lists+netdev@lfdr.de>; Wed,  1 Jul 2020 21:59:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727014AbgGAT7A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Jul 2020 15:59:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726956AbgGAT66 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Jul 2020 15:58:58 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90F13C08C5C1;
        Wed,  1 Jul 2020 12:58:58 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 2903213B1B225;
        Wed,  1 Jul 2020 12:58:55 -0700 (PDT)
Date:   Wed, 01 Jul 2020 12:58:53 -0700 (PDT)
Message-Id: <20200701.125853.2256200190486287898.davem@davemloft.net>
To:     vaibhavgupta40@gmail.com
Cc:     helgaas@kernel.org, bhelgaas@google.com, bjorn@helgaas.com,
        vaibhav.varodek@gmail.com, kuba@kernel.org, dave@thedillows.org,
        ionut@badula.org, netanel@amazon.com, akiyano@amazon.com,
        gtzalik@amazon.com, saeedb@amazon.com, zorik@amazon.com,
        dchickles@marvell.com, sburla@marvell.com, fmanlunas@marvell.com,
        kda@linux-powerpc.org, ajit.khaparde@broadcom.com,
        sriharsha.basavapatna@broadcom.com, somnath.kotur@broadcom.com,
        tariqt@mellanox.com, jdmason@kudzu.us, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        linux-kernel-mentees@lists.linuxfoundation.org,
        skhan@linuxfoundation.org
Subject: Re: [PATCH v2 00/11] net: ethernet: use generic power management
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200701165057.667799-1-vaibhavgupta40@gmail.com>
References: <20200701165057.667799-1-vaibhavgupta40@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 01 Jul 2020 12:58:56 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vaibhav Gupta <vaibhavgupta40@gmail.com>
Date: Wed,  1 Jul 2020 22:20:46 +0530

> Linux Kernel Mentee: Remove Legacy Power Management.
> 
> The purpose of this patch series is to remove legacy power management callbacks
> from net ethernet drivers.
> 
> The callbacks performing suspend() and resume() operations are still calling
> pci_save_state(), pci_set_power_state(), etc. and handling the power management
> themselves, which is not recommended.
> 
> The conversion requires the removal of the those function calls and change the
> callback definition accordingly and make use of dev_pm_ops structure.
> 
> All patches are compile-tested only.

Series applied, thanks.
