Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A07D34B186
	for <lists+netdev@lfdr.de>; Fri, 26 Mar 2021 22:50:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230180AbhCZVuM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Mar 2021 17:50:12 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:59572 "EHLO
        mail.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229957AbhCZVuA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Mar 2021 17:50:00 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        by mail.monkeyblade.net (Postfix) with ESMTPSA id 4AA6E4D254D1D;
        Fri, 26 Mar 2021 14:49:59 -0700 (PDT)
Date:   Fri, 26 Mar 2021 14:49:55 -0700 (PDT)
Message-Id: <20210326.144955.2174747206015428638.davem@davemloft.net>
To:     kuba@kernel.org
Cc:     netdev@vger.kernel.org, ecree.xilinx@gmail.com,
        michael.chan@broadcom.com, paul.greenwalt@intel.com,
        rajur@chelsio.com, jaroslawx.gawin@intel.com, vkochan@marvell.com,
        alobakin@pm.me, snelson@pensando.io, shayagr@amazon.com,
        ayal@nvidia.com, shenjian15@huawei.com, saeedm@nvidia.com,
        mkubecek@suse.cz, andrew@lunn.ch, roopa@nvidia.com
Subject: Re: [PATCH net-next v2 0/6] ethtool: clarify the ethtool FEC
 interface
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20210326020727.246828-1-kuba@kernel.org>
References: <20210326020727.246828-1-kuba@kernel.org>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.6.2 (mail.monkeyblade.net [0.0.0.0]); Fri, 26 Mar 2021 14:49:59 -0700 (PDT)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jakub Kicinski <kuba@kernel.org>
Date: Thu, 25 Mar 2021 19:07:21 -0700

> Our FEC configuration interface is one of the more confusing.
> It also lacks any error checking in the core. This certainly
> shows in the varying implementations across the drivers.
> 
> Improve the documentation and add most basic checks. Sadly, it's
> probably too late now to try to enforce much more uniformity.
> 
> Any thoughts & suggestions welcome. Next step is to add netlink
> for FEC, then stats.
> 
> v2: 
>  - fix patch 5
>  - adjust kdoc in patches 3 and 6

Jakub, I applied v1 so please send fiixups relative to that, thank you.
