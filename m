Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 25CD92C4918
	for <lists+netdev@lfdr.de>; Wed, 25 Nov 2020 21:31:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729993AbgKYUaQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Nov 2020 15:30:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:59848 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729957AbgKYUaQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 25 Nov 2020 15:30:16 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E62C2206F7;
        Wed, 25 Nov 2020 20:30:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1606336215;
        bh=eAQmp5GZGUdkf04vSOwtkPQYMmhghulNucwaE29RuR0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=oYKUyxis/nHy8FReftxkimZWOWuWMj9JA5cLvpjpBA9/HoLk6xLwY9+mGZQ17NcIS
         r6J6TJHDimtnfExA6cJFSDDV5CcoT+5bRVxVbjRo0yCcDNhcaiqNrk1VX3czGlFng6
         BJrVPxQW4rECcSSthzkLBlkQ8WYJWUfMe9kVm5L8=
Date:   Wed, 25 Nov 2020 12:30:13 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Antonio Borneo <antonio.borneo@st.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>, <netdev@vger.kernel.org>,
        Yonglong Liu <liuyonglong@huawei.com>,
        Willy Liu <willy.liu@realtek.com>, <linuxarm@huawei.com>,
        Salil Mehta <salil.mehta@huawei.com>,
        <linux-stm32@st-md-mailman.stormreply.com>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 net-next] net: phy: realtek: read actual speed on
 rtl8211f to detect downshift
Message-ID: <20201125123013.0a59c23b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201124230756.887925-1-antonio.borneo@st.com>
References: <20201124143848.874894-1-antonio.borneo@st.com>
        <20201124230756.887925-1-antonio.borneo@st.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 25 Nov 2020 00:07:56 +0100 Antonio Borneo wrote:
> The rtl8211f supports downshift and before commit 5502b218e001
> ("net: phy: use phy_resolve_aneg_linkmode in genphy_read_status")
> the read-back of register MII_CTRL1000 was used to detect the
> negotiated link speed.
> The code added in commit d445dff2df60 ("net: phy: realtek: read
> actual speed to detect downshift") is working fine also for this
> phy and it's trivial re-using it to restore the downshift
> detection on rtl8211f.
> 
> Add the phy specific read_status() pointing to the existing
> function rtlgen_read_status().
> 
> Signed-off-by: Antonio Borneo <antonio.borneo@st.com>
> Link: https://lore.kernel.org/r/478f871a-583d-01f1-9cc5-2eea56d8c2a7@huawei.com

Applied, thanks everyone!
