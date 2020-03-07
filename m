Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E546717CC87
	for <lists+netdev@lfdr.de>; Sat,  7 Mar 2020 07:46:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726138AbgCGGqV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 Mar 2020 01:46:21 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:41064 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725815AbgCGGqU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 7 Mar 2020 01:46:20 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:477::f0c])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 16A2C15538DB4;
        Fri,  6 Mar 2020 22:46:19 -0800 (PST)
Date:   Fri, 06 Mar 2020 22:46:18 -0800 (PST)
Message-Id: <20200306.224618.1734969802976525324.davem@davemloft.net>
To:     kuba@kernel.org
Cc:     jdike@addtoit.com, richard@nod.at, anton.ivanov@cambridgegreys.com,
        linux-um@lists.infradead.org, dledford@redhat.com, jgg@ziepe.ca,
        leon@kernel.org, linux-rdma@vger.kernel.org, edumazet@google.com,
        jasowang@redhat.com, mkubecek@suse.cz, hayeswang@realtek.com,
        doshir@vmware.com, pv-drivers@vmware.com, manishc@marvell.com,
        GR-Linux-NIC-Dev@marvell.com, gregkh@linuxfoundation.org,
        merez@codeaurora.org, kvalo@codeaurora.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH net-next 0/7] ethtool: consolidate irq coalescing -
 other drivers
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200306010602.1620354-1-kuba@kernel.org>
References: <20200306010602.1620354-1-kuba@kernel.org>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 06 Mar 2020 22:46:20 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jakub Kicinski <kuba@kernel.org>
Date: Thu,  5 Mar 2020 17:05:55 -0800

> Convert more drivers following the groundwork laid in a recent
> patch set [1]. The aim of the effort is to consolidate irq
> coalescing parameter validation in the core.
> 
> This set converts all the drivers outside of drivers/net/ethernet.
> 
> Only vmxnet3 them was checking unsupported parameters.
> 
> The aim is to merge this via the net-next tree so we can
> convert all drivers and make the checking mandatory.
> 
> [1] https://lore.kernel.org/netdev/20200305051542.991898-1-kuba@kernel.org/

Series applied, thanks Jakub.
