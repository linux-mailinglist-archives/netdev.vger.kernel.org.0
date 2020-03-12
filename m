Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 32F7B1838BD
	for <lists+netdev@lfdr.de>; Thu, 12 Mar 2020 19:33:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726553AbgCLSdc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Mar 2020 14:33:32 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:33630 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726328AbgCLSdc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Mar 2020 14:33:32 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 2C2E81574167D;
        Thu, 12 Mar 2020 11:33:31 -0700 (PDT)
Date:   Thu, 12 Mar 2020 11:33:30 -0700 (PDT)
Message-Id: <20200312.113330.879490518295928973.davem@davemloft.net>
To:     kuba@kernel.org
Cc:     netdev@vger.kernel.org, mkubecek@suse.cz,
        sathya.perla@broadcom.com, ajit.khaparde@broadcom.com,
        sriharsha.basavapatna@broadcom.com, somnath.kotur@broadcom.com,
        madalin.bucur@nxp.com, fugang.duan@nxp.com, claudiu.manoil@nxp.com,
        yisen.zhuang@huawei.com, salil.mehta@huawei.com,
        jeffrey.t.kirsher@intel.com, jacob.e.keller@intel.com,
        alexander.h.duyck@linux.intel.com
Subject: Re: [PATCH net-next 00/15] ethtool: consolidate irq coalescing -
 part 4
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200311223302.2171564-1-kuba@kernel.org>
References: <20200311223302.2171564-1-kuba@kernel.org>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 12 Mar 2020 11:33:31 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jakub Kicinski <kuba@kernel.org>
Date: Wed, 11 Mar 2020 15:32:47 -0700

> Convert more drivers following the groundwork laid in a recent
> patch set [1] and continued in [2], [3]. The aim of the effort
> is to consolidate irq coalescing parameter validation in the core.
> 
> This set converts 15 drivers in drivers/net/ethernet - remaining
> Intel drivers, Freescale/NXP, and others.
> 2 more conversion sets to come.
> 
> [1] https://lore.kernel.org/netdev/20200305051542.991898-1-kuba@kernel.org/
> [2] https://lore.kernel.org/netdev/20200306010602.1620354-1-kuba@kernel.org/
> [3] https://lore.kernel.org/netdev/20200310021512.1861626-1-kuba@kernel.org/

Series applied, thanks Jakub.
