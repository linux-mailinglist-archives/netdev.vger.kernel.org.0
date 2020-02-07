Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E21FD15586E
	for <lists+netdev@lfdr.de>; Fri,  7 Feb 2020 14:29:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726974AbgBGN3K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Feb 2020 08:29:10 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:42392 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726874AbgBGN3K (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Feb 2020 08:29:10 -0500
Received: from localhost (unknown [IPv6:2001:982:756:1:57a7:3bfd:5e85:defb])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 8B56F15AD58C8;
        Fri,  7 Feb 2020 05:29:08 -0800 (PST)
Date:   Fri, 07 Feb 2020 14:29:04 +0100 (CET)
Message-Id: <20200207.142904.27768216550942872.davem@davemloft.net>
To:     madalin.bucur@oss.nxp.com
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, hkallweit1@gmail.com,
        netdev@vger.kernel.org, ykaukab@suse.de
Subject: Re: [PATCH net v3] dpaa_eth: support all modes with rate adapting
 PHYs
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1580810938-21047-1-git-send-email-madalin.bucur@oss.nxp.com>
References: <1580810938-21047-1-git-send-email-madalin.bucur@oss.nxp.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 07 Feb 2020 05:29:09 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Madalin Bucur <madalin.bucur@oss.nxp.com>
Date: Tue,  4 Feb 2020 12:08:58 +0200

> Stop removing modes that are not supported on the system interface
> when the connected PHY is capable of rate adaptation. This addresses
> an issue with the LS1046ARDB board 10G interface no longer working
> with an 1G link partner after autonegotiation support was added
> for the Aquantia PHY on board in
> 
> commit 09c4c57f7bc4 ("net: phy: aquantia: add support for auto-negotiation configuration")
> 
> Before this commit the values advertised by the PHY were not
> influenced by the dpaa_eth driver removal of system-side unsupported
> modes as the aqr_config_aneg() was basically a no-op. After this
> commit, the modes removed by the dpaa_eth driver were no longer
> advertised thus autonegotiation with 1G link partners failed.
> 
> Reported-by: Mian Yousaf Kaukab <ykaukab@suse.de>
> Signed-off-by: Madalin Bucur <madalin.bucur@oss.nxp.com>
> ---
> 
> change in v3: no longer add an API for checking the capability,
>   rely on PHY vendor to determine if more modes may be available
>   through rate adaptation so stop removing them

Applied and queued up for -stable, thank you.
