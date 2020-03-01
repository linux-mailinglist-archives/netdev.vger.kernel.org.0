Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8A16D174B7A
	for <lists+netdev@lfdr.de>; Sun,  1 Mar 2020 06:32:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726738AbgCAFcY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 1 Mar 2020 00:32:24 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:38748 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725887AbgCAFcY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 1 Mar 2020 00:32:24 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 92A4E15BD9520;
        Sat, 29 Feb 2020 21:32:23 -0800 (PST)
Date:   Sat, 29 Feb 2020 21:32:22 -0800 (PST)
Message-Id: <20200229.213222.240836419764284382.davem@davemloft.net>
To:     esben@geanix.com
Cc:     netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        andrew@lunn.ch, michal.simek@xilinx.com, ynezz@true.cz
Subject: Re: [PATCH net-next 0/4] net: ll_temac: RX/TX ring size and
 coalesce ethtool parameters
From:   David Miller <davem@davemloft.net>
In-Reply-To: <cover.1582875715.git.esben@geanix.com>
References: <cover.1582875715.git.esben@geanix.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sat, 29 Feb 2020 21:32:24 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Esben Haabendal <esben@geanix.com>
Date: Fri, 28 Feb 2020 08:56:42 +0100

> This series adds support for RX/TX ring size and irq coalesce ethtool
> parameters to ll_temac driver.
> 
> Esben Haabendal (4):
>   net: ll_temac: Remove unused tx_bd_next struct field
>   net: ll_temac: Remove unused start_p variable
>   net: ll_temac: Make RX/TX ring sizes configurable
>   net: ll_temac: Add ethtool support for coalesce parameters

Series applied, thanks.

I supposed not allowing the ring param change when the device is up is
one way to avoid the complexity of handling failures.

However, users may find this very limiting since most networking
devices allow this operation when the device is up and running.
