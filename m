Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DE83A170FBC
	for <lists+netdev@lfdr.de>; Thu, 27 Feb 2020 05:42:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728384AbgB0Emh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Feb 2020 23:42:37 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:37060 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728284AbgB0Emh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Feb 2020 23:42:37 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 879FC15B478CF;
        Wed, 26 Feb 2020 20:42:36 -0800 (PST)
Date:   Wed, 26 Feb 2020 20:42:35 -0800 (PST)
Message-Id: <20200226.204235.562376715230267077.davem@davemloft.net>
To:     sudheesh.mavila@amd.com
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, hkallweit1@gmail.com,
        linux@armlinux.org.uk, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH =?iso-8859-1?Q?v2=A0]?= net: phy: corrected the return
 value for genphy_check_and_restart_aneg and
 genphy_c45_check_and_restart_aneg
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200226071045.79090-1-sudheesh.mavila@amd.com>
References: <20200226071045.79090-1-sudheesh.mavila@amd.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 26 Feb 2020 20:42:36 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sudheesh Mavila <sudheesh.mavila@amd.com>
Date: Wed, 26 Feb 2020 12:40:45 +0530

> When auto-negotiation is not required, return value should be zero.
> 
> Changes v1->v2:
> - improved comments and code as Andrew Lunn and Heiner Kallweit suggestion
> - fixed issue in genphy_c45_check_and_restart_aneg as Russell King
>   suggestion.
> 
> Fixes: 2a10ab043ac5 ("net: phy: add genphy_check_and_restart_aneg()")
> Fixes: 1af9f16840e9 ("net: phy: add genphy_c45_check_and_restart_aneg()")
> Signed-off-by: Sudheesh Mavila <sudheesh.mavila@amd.com>

Applied and queued up for -stable, thanks.
