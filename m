Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 906FD1787C7
	for <lists+netdev@lfdr.de>; Wed,  4 Mar 2020 02:55:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387508AbgCDBzV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Mar 2020 20:55:21 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:38238 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387406AbgCDBzV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Mar 2020 20:55:21 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 90AF515AD9731;
        Tue,  3 Mar 2020 17:55:18 -0800 (PST)
Date:   Tue, 03 Mar 2020 17:55:17 -0800 (PST)
Message-Id: <20200303.175517.2166029762450403219.davem@davemloft.net>
To:     leon@kernel.org
Cc:     kuba@kernel.org, leonro@mellanox.com, ajit.khaparde@broadcom.com,
        aelior@marvell.com, bcm-kernel-feedback-list@broadcom.com,
        leedom@chelsio.com, benve@cisco.com, claudiu.manoil@nxp.com,
        kda@linux-powerpc.org, dchickles@marvell.com, opendmb@gmail.com,
        fmanlunas@marvell.com, f.fainelli@gmail.com, fugang.duan@nxp.com,
        _govind@gmx.com, GR-everest-linux-l2@marvell.com,
        GR-Linux-NIC-Dev@marvell.com, ulli.kroll@googlemail.com,
        hsweeten@visionengravers.com, linus.walleij@linaro.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-parisc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        leoyang.li@nxp.com, madalin.bucur@nxp.com,
        michael.chan@broadcom.com, netdev@vger.kernel.org,
        pantelis.antoniou@gmail.com, pkaustub@cisco.com,
        prashant@broadcom.com, rvatsavayi@caviumnetworks.com,
        rmody@marvell.com, rrichter@marvell.com, sburla@marvell.com,
        sathya.perla@broadcom.com, siva.kallam@broadcom.com,
        somnath.kotur@broadcom.com, sriharsha.basavapatna@broadcom.com,
        skalluru@marvell.com, sgoutham@marvell.com, vishal@chelsio.com
Subject: Re: [PATCH net-next 00/23] Clean driver, module and FW versions
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200301144457.119795-1-leon@kernel.org>
References: <20200301144457.119795-1-leon@kernel.org>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 03 Mar 2020 17:55:20 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Leon Romanovsky <leon@kernel.org>
Date: Sun,  1 Mar 2020 16:44:33 +0200

> From: Leon Romanovsky <leonro@mellanox.com>
> 
> Hi,
> 
> This is second batch of the series which removes various static versions
> in favour of globaly defined Linux kernel version.
> 
> The first part with better cover letter can be found here
> https://lore.kernel.org/lkml/20200224085311.460338-1-leon@kernel.org
> 
> The code is based on
> 68e2c37690b0 ("Merge branch 'hsr-several-code-cleanup-for-hsr-module'")
> 
> and WIP branch is
> https://git.kernel.org/pub/scm/linux/kernel/git/leon/linux-rdma.git/log/?h=ethtool

Series applied, thanks.
