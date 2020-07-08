Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C4C4B2190E4
	for <lists+netdev@lfdr.de>; Wed,  8 Jul 2020 21:39:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726265AbgGHTjY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jul 2020 15:39:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725446AbgGHTjY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jul 2020 15:39:24 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72EDDC061A0B;
        Wed,  8 Jul 2020 12:39:24 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 415E21276B432;
        Wed,  8 Jul 2020 12:39:23 -0700 (PDT)
Date:   Wed, 08 Jul 2020 12:39:22 -0700 (PDT)
Message-Id: <20200708.123922.2185175821299781158.davem@davemloft.net>
To:     f.fainelli@gmail.com
Cc:     netdev@vger.kernel.org, andrew@lunn.ch, hkallweit1@gmail.com,
        linux@armlinux.org.uk, kuba@kernel.org, mkubecek@suse.cz,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 0/2] net: phy: Uninline PHY ethtool statistics
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200708164625.40180-1-f.fainelli@gmail.com>
References: <20200708164625.40180-1-f.fainelli@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 08 Jul 2020 12:39:23 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florian Fainelli <f.fainelli@gmail.com>
Date: Wed,  8 Jul 2020 09:46:23 -0700

> Now that we have introduced ethtool_phy_ops we can uninline those
> operations and move them back into phy.c where they belong. Since those
> functions are used by DSA, we need to continue exporting those symbols.
> 
> It might be possible to remove ndo_get_ethtool_phy_stats in a subsequent
> patch since we could have DSA register its own ethtool_phy_ops instance
> instead of overloading the ethtool_ops.

Series applied, thanks Florian.
