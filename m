Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE5341D42A3
	for <lists+netdev@lfdr.de>; Fri, 15 May 2020 03:03:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727882AbgEOBDc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 May 2020 21:03:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726122AbgEOBDb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 May 2020 21:03:31 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E090BC061A0C
        for <netdev@vger.kernel.org>; Thu, 14 May 2020 18:03:31 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 8B47914DDDEE5;
        Thu, 14 May 2020 18:03:31 -0700 (PDT)
Date:   Thu, 14 May 2020 18:03:30 -0700 (PDT)
Message-Id: <20200514.180330.702669172845422266.davem@davemloft.net>
To:     hkallweit1@gmail.com
Cc:     nic_swsd@realtek.com, kuba@kernel.org, netdev@vger.kernel.org
Subject: Re: r8169: remove not needed checks in rtl8169_set_eee
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1f4a9d3c-3c56-499b-1c69-c12031dd0adf@gmail.com>
References: <1f4a9d3c-3c56-499b-1c69-c12031dd0adf@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 14 May 2020 18:03:31 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Heiner Kallweit <hkallweit1@gmail.com>
Date: Thu, 14 May 2020 23:39:34 +0200

> After 9de5d235b60a ("net: phy: fix aneg restart in phy_ethtool_set_eee")
> we don't need the check for aneg being enabled any longer, and as
> discussed with Russell configuring the EEE advertisement should be
> supported even if we're in a half-duplex mode currently.
> 
> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>

Applied.
