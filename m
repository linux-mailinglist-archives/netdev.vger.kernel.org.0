Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D8E62180C60
	for <lists+netdev@lfdr.de>; Wed, 11 Mar 2020 00:29:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727397AbgCJX3O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Mar 2020 19:29:14 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:44088 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726463AbgCJX3O (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Mar 2020 19:29:14 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 421DB14DA849B;
        Tue, 10 Mar 2020 16:29:12 -0700 (PDT)
Date:   Tue, 10 Mar 2020 16:29:11 -0700 (PDT)
Message-Id: <20200310.162911.957609713972539003.davem@davemloft.net>
To:     kuba@kernel.org
Cc:     netdev@vger.kernel.org, akiyano@amazon.com, netanel@amazon.com,
        gtzalik@amazon.com, irusskikh@marvell.com, f.fainelli@gmail.com,
        bcm-kernel-feedback-list@broadcom.com, rmody@marvell.com,
        GR-Linux-NIC-Dev@marvell.com, aelior@marvell.com,
        skalluru@marvell.com, GR-everest-linux-l2@marvell.com,
        opendmb@gmail.com, siva.kallam@broadcom.com, prashant@broadcom.com,
        mchan@broadcom.com, dchickles@marvell.com, sburla@marvell.com,
        fmanlunas@marvell.com, tariqt@mellanox.com, vishal@chelsio.com,
        leedom@chelsio.com, ulli.kroll@googlemail.com,
        linus.walleij@linaro.org
Subject: Re: [PATCH net-next 00/15] ethtool: consolidate irq coalescing -
 part 3
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200310021512.1861626-1-kuba@kernel.org>
References: <20200310021512.1861626-1-kuba@kernel.org>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 10 Mar 2020 16:29:13 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jakub Kicinski <kuba@kernel.org>
Date: Mon,  9 Mar 2020 19:14:57 -0700

> Convert more drivers following the groundwork laid in a recent
> patch set [1] and continued in [2]. The aim of the effort is to
> consolidate irq coalescing parameter validation in the core.
> 
> This set converts 15 drivers in drivers/net/ethernet.
> 3 more conversion sets to come.
> 
> None of the drivers here checked all unsupported parameters.
> 
> [1] https://lore.kernel.org/netdev/20200305051542.991898-1-kuba@kernel.org/
> [2] https://lore.kernel.org/netdev/20200306010602.1620354-1-kuba@kernel.org/

Series applied, thank you.
