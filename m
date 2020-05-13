Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B61F1D1FA1
	for <lists+netdev@lfdr.de>; Wed, 13 May 2020 21:49:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403776AbgEMTtx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 May 2020 15:49:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S2390696AbgEMTtx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 May 2020 15:49:53 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CFD1C061A0C;
        Wed, 13 May 2020 12:49:51 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 09E53127F6662;
        Wed, 13 May 2020 12:49:50 -0700 (PDT)
Date:   Wed, 13 May 2020 12:49:49 -0700 (PDT)
Message-Id: <20200513.124949.1617913655712734321.davem@davemloft.net>
To:     f.fainelli@gmail.com
Cc:     netdev@vger.kernel.org, m.szyprowski@samsung.com,
        nsaenzjulienne@suse.de, wahrenst@gmx.net,
        michael.chan@broadcom.com, saeedm@mellanox.com, gospo@broadcom.com,
        rdunlap@infradead.org, geert+renesas@glider.be, tglx@linutronix.de,
        talgi@mellanox.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net v2] net: broadcom: Select BROADCOM_PHY for BCMGENET
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200513155158.26110-1-f.fainelli@gmail.com>
References: <20200513155158.26110-1-f.fainelli@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 13 May 2020 12:49:50 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florian Fainelli <f.fainelli@gmail.com>
Date: Wed, 13 May 2020 08:51:51 -0700

> The GENET controller on the Raspberry Pi 4 (2711) is typically
> interfaced with an external Broadcom PHY via a RGMII electrical
> interface. To make sure that delays are properly configured at the PHY
> side, ensure that we the dedicated Broadcom PHY driver
> (CONFIG_BROADCOM_PHY) is enabled for this to happen.
> 
> Fixes: 402482a6a78e ("net: bcmgenet: Clear ID_MODE_DIS in EXT_RGMII_OOB_CTRL when not needed")
> Reported-by: Marek Szyprowski <m.szyprowski@samsung.com>
> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>

Applied and queued up for -stable, thanks Florian.
