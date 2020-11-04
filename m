Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 603832A5C22
	for <lists+netdev@lfdr.de>; Wed,  4 Nov 2020 02:46:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730546AbgKDBqH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Nov 2020 20:46:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:37358 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728534AbgKDBqH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 3 Nov 2020 20:46:07 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AD9E420870;
        Wed,  4 Nov 2020 01:46:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604454366;
        bh=FnKoisWTX/ee1bsgKatEBjM+73m01swI7uYjuGuSuPM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=juR9jqLpgi9tBQoGxmks2rJ7sxh0OChrS5hjSfqtNvKcOoKX4ktKQOP7R/gXlgZwX
         9p/g5aoHzkeVP7MGU/BvqOPLN9HRUAajDGKQdx5GUmBri7WU/Af3DvmUR8u2hMvEpy
         tRBxzy+ZjIBiK+DU4VV5KkQAPcMkGroUAZJEeaBI=
Date:   Tue, 3 Nov 2020 17:46:04 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Willy Liu <willy.liu@realtek.com>
Cc:     <andrew@lunn.ch>, <hkallweit1@gmail.com>, <linux@armlinux.org.uk>,
        <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <ryankao@realtek.com>
Subject: Re: [PATCH net-next v2] net: phy: realtek: Add support for
 RTL8221B-CG series
Message-ID: <20201103174604.59debf73@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <1604281927-9874-1-git-send-email-willy.liu@realtek.com>
References: <1604281927-9874-1-git-send-email-willy.liu@realtek.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 2 Nov 2020 09:52:07 +0800 Willy Liu wrote:
> Realtek single-port 2.5Gbps Ethernet PHYs are list as below:
> RTL8226-CG: the 1st generation 2.5Gbps single port PHY
> RTL8226B-CG/RTL8221B-CG: the 2nd generation 2.5Gbps single port PHY
> RTL8221B-VB-CG: the 3rd generation 2.5Gbps single port PHY
> RTL8221B-VM-CG: the 2.5Gbps single port PHY with MACsec feature
> 
> This patch adds the minimal drivers to manage these transceivers.
> 
> Signed-off-by: Willy Liu <willy.liu@realtek.com>
> Reviewed-by: Andrew Lunn <andrew@lunn.ch>

Applied, thanks!
