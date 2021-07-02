Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BEE983BA4C1
	for <lists+netdev@lfdr.de>; Fri,  2 Jul 2021 22:40:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231618AbhGBUnP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Jul 2021 16:43:15 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:38070 "EHLO
        mail.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230434AbhGBUnO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Jul 2021 16:43:14 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        by mail.monkeyblade.net (Postfix) with ESMTPSA id A09214D252307;
        Fri,  2 Jul 2021 13:40:41 -0700 (PDT)
Date:   Fri, 02 Jul 2021 13:40:41 -0700 (PDT)
Message-Id: <20210702.134041.2064148932022807436.davem@davemloft.net>
To:     pei.lee.ling@intel.com
Cc:     linux@armlinux.org.uk, andrew@lunn.ch, hkallweit1@gmail.com,
        kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, marek.behun@nic.cz,
        weifeng.voon@intel.com, vee.khee.wong@linux.intel.com,
        vee.khee.wong@intel.com
Subject: Re: [PATCH net-next V3] net: phy: marvell10g: enable WoL for
 88X3310 and 88E2110
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20210702080454.1688190-1-pei.lee.ling@intel.com>
References: <20210702080454.1688190-1-pei.lee.ling@intel.com>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.6.2 (mail.monkeyblade.net [0.0.0.0]); Fri, 02 Jul 2021 13:40:42 -0700 (PDT)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ling Pei Lee <pei.lee.ling@intel.com>
Date: Fri,  2 Jul 2021 16:04:54 +0800

> From: Voon Weifeng <weifeng.voon@intel.com>
> 
> Implement Wake-on-LAN feature for 88X3310 and 88E2110.
> 
> This is done by enabling WoL interrupt and WoL detection and
> configuring MAC address into WoL magic packet registers
> 
> Signed-off-by: Voon Weifeng <weifeng.voon@intel.com>
> Signed-off-by: Ling PeiLee <pei.lee.ling@intel.com>

Please resubmit this when net-next opens back up, thank you.
