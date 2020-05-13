Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC5561D21EF
	for <lists+netdev@lfdr.de>; Thu, 14 May 2020 00:23:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731252AbgEMWXM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 May 2020 18:23:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1731135AbgEMWXL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 May 2020 18:23:11 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F459C061A0C
        for <netdev@vger.kernel.org>; Wed, 13 May 2020 15:23:11 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id BEECF12118550;
        Wed, 13 May 2020 15:23:10 -0700 (PDT)
Date:   Wed, 13 May 2020 15:23:10 -0700 (PDT)
Message-Id: <20200513.152310.1761379266532416158.davem@davemloft.net>
To:     hkallweit1@gmail.com
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, linux@armlinux.org.uk,
        netdev@vger.kernel.org
Subject: Re: [PATCH net] net: phy: fix aneg restart in phy_ethtool_set_eee
From:   David Miller <davem@davemloft.net>
In-Reply-To: <2a8c3ca7-4ef3-3dd7-6276-759f66ab8b5e@gmail.com>
References: <2a8c3ca7-4ef3-3dd7-6276-759f66ab8b5e@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 13 May 2020 15:23:11 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Heiner Kallweit <hkallweit1@gmail.com>
Date: Tue, 12 May 2020 21:45:53 +0200

> phy_restart_aneg() enables aneg in the PHY. That's not what we want
> if phydev->autoneg is disabled. In this case still update EEE
> advertisement register, but don't enable aneg and don't trigger an
> aneg restart.
> 
> Fixes: f75abeb8338e ("net: phy: restart phy autonegotiation after EEE advertisment change")
> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>

Applied and queued up for -stable, thanks.
