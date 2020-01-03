Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5B96412FE01
	for <lists+netdev@lfdr.de>; Fri,  3 Jan 2020 21:38:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727917AbgACUif (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Jan 2020 15:38:35 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:47534 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727400AbgACUie (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Jan 2020 15:38:34 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1c3::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 088611584568B;
        Fri,  3 Jan 2020 12:38:34 -0800 (PST)
Date:   Fri, 03 Jan 2020 12:38:33 -0800 (PST)
Message-Id: <20200103.123833.770079687620914019.davem@davemloft.net>
To:     rmk+kernel@armlinux.org.uk
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, hkallweit1@gmail.com,
        netdev@vger.kernel.org
Subject: Re: [PATCH net] net: phylink: fix failure to register on x86
 systems
From:   David Miller <davem@davemloft.net>
In-Reply-To: <E1inOeC-00004q-18@rmk-PC.armlinux.org.uk>
References: <E1inOeC-00004q-18@rmk-PC.armlinux.org.uk>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 03 Jan 2020 12:38:34 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Russell King <rmk+kernel@armlinux.org.uk>
Date: Fri, 03 Jan 2020 15:13:56 +0000

> The kernel test robot reports a boot failure with qemu in 5.5-rc,
> referencing commit 2203cbf2c8b5 ("net: sfp: move fwnode parsing into
> sfp-bus layer"). This is caused by phylink_create() being passed a
> NULL fwnode, causing fwnode_property_get_reference_args() to return
> -EINVAL.
> 
> Don't attempt to attach to a SFP bus if we have no fwnode, which
> avoids this issue.
> 
> Reported-by: kernel test robot <rong.a.chen@intel.com>
> Fixes: 2203cbf2c8b5 ("net: sfp: move fwnode parsing into sfp-bus layer")
> Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>

Applied, thanks Russell.
