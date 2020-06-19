Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A078201C87
	for <lists+netdev@lfdr.de>; Fri, 19 Jun 2020 22:40:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390527AbgFSUk0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Jun 2020 16:40:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390097AbgFSUk0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Jun 2020 16:40:26 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4ECBCC06174E;
        Fri, 19 Jun 2020 13:40:26 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 5AF6C120ED481;
        Fri, 19 Jun 2020 13:40:25 -0700 (PDT)
Date:   Fri, 19 Jun 2020 13:40:24 -0700 (PDT)
Message-Id: <20200619.134024.2085536608235933676.davem@davemloft.net>
To:     f.fainelli@gmail.com
Cc:     netdev@vger.kernel.org, andrew@lunn.ch, hkallweit1@gmail.com,
        linux@armlinux.org.uk, kuba@kernel.org, robh+dt@kernel.org,
        frowand.list@gmail.com, adajunjin@gmail.com,
        alexandre.belloni@bootlin.com, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: Re: [PATCH net v2 0/2] net: phy: MDIO bus scanning fixes
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200619184747.16606-1-f.fainelli@gmail.com>
References: <20200619184747.16606-1-f.fainelli@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 19 Jun 2020 13:40:25 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florian Fainelli <f.fainelli@gmail.com>
Date: Fri, 19 Jun 2020 11:47:45 -0700

> This patch series fixes two problems with the current MDIO bus scanning
> logic which was identified while moving from 4.9 to 5.4 on devices that
> do rely on scanning the MDIO bus at runtime because they use pluggable
> cards.
> 
> Changes in v2:
> 
> - added comment explaining the special value of -ENODEV
> - added Andrew's Reviewed-by tag

Series applied and queued up for -stable, thanks.
