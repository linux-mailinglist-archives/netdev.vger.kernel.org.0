Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA301254660
	for <lists+netdev@lfdr.de>; Thu, 27 Aug 2020 16:02:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728241AbgH0OBl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Aug 2020 10:01:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727980AbgH0N7H (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Aug 2020 09:59:07 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29541C061264
        for <netdev@vger.kernel.org>; Thu, 27 Aug 2020 06:58:44 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id D03CF1273AC63;
        Thu, 27 Aug 2020 06:41:51 -0700 (PDT)
Date:   Thu, 27 Aug 2020 06:58:35 -0700 (PDT)
Message-Id: <20200827.065835.938757148777309712.davem@davemloft.net>
To:     andrew@lunn.ch
Cc:     netdev@vger.kernel.org, f.fainelli@gmail.com,
        rmk+kernel@armlinux.org.uk, hkallweit1@gmail.com
Subject: Re: [PATCH net-next v4 0/5] Move MDIO drivers into their own
 directory
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200827020032.2866339-1-andrew@lunn.ch>
References: <20200827020032.2866339-1-andrew@lunn.ch>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 27 Aug 2020 06:41:52 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Andrew Lunn <andrew@lunn.ch>
Date: Thu, 27 Aug 2020 04:00:27 +0200

> The phy subdirectory is getting cluttered. It has both PHY drivers and
> MDIO drivers, plus a stray switch driver. Soon more PCS drivers are
> likely to appear.
> 
> Move MDIO and PCS drivers into new directories. This requires fixing
> up the xgene driver which uses a relative include path.
> 
> v2:
> Move the subdirs to drivers/net, rather than drivers/net/phy.
> 
> v3:
> Add subdirectories under include/linux for mdio and pcs
> 
> v4:
> there->their
> include path fix
> No new kconfig prompts

Series applied, thanks Andrew.
