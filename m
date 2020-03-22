Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2D3F118E634
	for <lists+netdev@lfdr.de>; Sun, 22 Mar 2020 04:10:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728325AbgCVDK0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 21 Mar 2020 23:10:26 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:34390 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727296AbgCVDKZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 21 Mar 2020 23:10:25 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 4546215AC1030;
        Sat, 21 Mar 2020 20:10:24 -0700 (PDT)
Date:   Sat, 21 Mar 2020 20:10:22 -0700 (PDT)
Message-Id: <20200321.201022.719210614219273669.davem@davemloft.net>
To:     grygorii.strashko@ti.com
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, dmurphy@ti.com,
        hkallweit1@gmail.com, netdev@vger.kernel.org, nsekhar@ti.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: phy: dp83867: w/a for fld detect threshold
 bootstrapping issue
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200317180454.22393-1-grygorii.strashko@ti.com>
References: <20200317180454.22393-1-grygorii.strashko@ti.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sat, 21 Mar 2020 20:10:25 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Grygorii Strashko <grygorii.strashko@ti.com>
Date: Tue, 17 Mar 2020 20:04:54 +0200

> When the DP83867 PHY is strapped to enable Fast Link Drop (FLD) feature
> STRAP_STS2.STRAP_ FLD (reg 0x006F bit 10), the Energy Lost Threshold for
> FLD Energy Lost Mode FLD_THR_CFG.ENERGY_LOST_FLD_THR (reg 0x002e bits 2:0)
> will be defaulted to 0x2. This may cause the phy link to be unstable. The
> new DP83867 DM recommends to always restore ENERGY_LOST_FLD_THR to 0x1.
> 
> Hence, restore default value of FLD_THR_CFG.ENERGY_LOST_FLD_THR to 0x1 when
> FLD is enabled by bootstrapping as recommended by DM.
> 
> Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>

Applied, thank you.

Let me know if I should queue this up for -stable.
