Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E32202B6F6D
	for <lists+netdev@lfdr.de>; Tue, 17 Nov 2020 20:57:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731053AbgKQT4l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Nov 2020 14:56:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:60212 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729524AbgKQT4l (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 17 Nov 2020 14:56:41 -0500
Received: from kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net (c-67-180-217-166.hsd1.ca.comcast.net [67.180.217.166])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 40A4F2222E;
        Tue, 17 Nov 2020 19:56:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605643000;
        bh=XLIB+pTJOfThBA+5uOg3dVvB7wPEvLHGRnKx33rk3zU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=U7Ccf9Q92A9bK5MaqPG+H9qV4duReLhsFbWhuJUK1ZPPCIOR++NlPYwIbQvz6vgNz
         FLZRUy7c8M7ZbbTQh1DFA7Rcd2kCYtd2Gyip6TpTbY3HyjzkWp0ojKJlVsN26pXT5G
         e4vaZCDKE9uUxTSDe9HLiT5Rb6OPR7TnOS19Dbnk=
Date:   Tue, 17 Nov 2020 11:56:39 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Wong Vee Khee <vee.khee.wong@intel.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Ong Boon Leong <boon.leong.ong@intel.com>,
        Voon Wei Feng <weifeng.voon@intel.com>
Subject: Re: [PATCH net-next 1/1] net: phy: Add additional logics on probing
 C45 PHY devices
Message-ID: <20201117115639.4b492863@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20201112150351.12662-1-vee.khee.wong@intel.com>
References: <20201112150351.12662-1-vee.khee.wong@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 12 Nov 2020 23:03:51 +0800 Wong Vee Khee wrote:
> For clause 45 PHY, introduce additional logics in get_phy_c45_ids() to
> check if there is at least one valid device ID, return 0 on true, and
> -ENODEV otherwise.
> 
> Signed-off-by: Wong Vee Khee <vee.khee.wong@intel.com>

I don't see any response to Andrew's questions, so I'm dropping this
from patchwork.
