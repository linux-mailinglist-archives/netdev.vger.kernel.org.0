Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E89061EAF6C
	for <lists+netdev@lfdr.de>; Mon,  1 Jun 2020 21:03:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728587AbgFATDV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Jun 2020 15:03:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726113AbgFATDU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Jun 2020 15:03:20 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8E3AC061A0E;
        Mon,  1 Jun 2020 12:03:20 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id E253311D53F8B;
        Mon,  1 Jun 2020 12:03:19 -0700 (PDT)
Date:   Mon, 01 Jun 2020 12:03:19 -0700 (PDT)
Message-Id: <20200601.120319.155959182283528175.davem@davemloft.net>
To:     michael@walle.cc
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        andrew@lunn.ch, f.fainelli@gmail.com, hkallweit1@gmail.com,
        linux@armlinux.org.uk, kuba@kernel.org, lkp@intel.com
Subject: Re: [PATCH net-next] net: phy: broadcom: don't export RDB/legacy
 access methods
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200530203404.1665-1-michael@walle.cc>
References: <20200530203404.1665-1-michael@walle.cc>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 01 Jun 2020 12:03:20 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Michael Walle <michael@walle.cc>
Date: Sat, 30 May 2020 22:34:04 +0200

> Don't export __bcm_phy_enable_rdb_access() and
> __bcm_phy_enable_legacy_access() functions. They aren't used outside this
> module and it was forgotten to provide a prototype for these functions.
> Just make them static for now.
> 
> Fixes: 11ecf8c55b91 ("net: phy: broadcom: add cable test support")
> Reported-by: kbuild test robot <lkp@intel.com>
> Signed-off-by: Michael Walle <michael@walle.cc>

Applied.
