Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C84072A09E9
	for <lists+netdev@lfdr.de>; Fri, 30 Oct 2020 16:34:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726642AbgJ3PeB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Oct 2020 11:34:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:36100 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726178AbgJ3PeA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 30 Oct 2020 11:34:00 -0400
Received: from kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net (unknown [163.114.132.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8DA9820729;
        Fri, 30 Oct 2020 15:33:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604072040;
        bh=Z7SRMfuJisg3ggE1ffAvXBb3KOmwKf84SzcGF1MS5VU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=0/RKZUaYY3+WofIVuqRQMr8kkEr4Uif8LfqRaH0mdXE9+yAamB28eJjgRY/1haCBP
         y0rzqvD/QccWqvUHkUtAYFLKhCh8HcgI+geoSuPBYQm93bkQnOQ4CEsZqAXGAcAGjU
         8jKF2AJ3/DN5TSAz9nX1k3jsSCKNHieEzyXbguz0=
Date:   Fri, 30 Oct 2020 08:33:58 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Willy Liu <willy.liu@realtek.com>
Cc:     <andrew@lunn.ch>, <hkallweit1@gmail.com>, <linux@armlinux.org.uk>,
        <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <ryankao@realtek.com>
Subject: Re: [PATCH net-next] net: phy: realtek: Add support for RTL8221B-CG
 series
Message-ID: <20201030083358.743ad4ea@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <1604037380-16735-1-git-send-email-willy.liu@realtek.com>
References: <1604037380-16735-1-git-send-email-willy.liu@realtek.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 30 Oct 2020 13:56:20 +0800 Willy Liu wrote:
> diff --git a/drivers/net/phy/realtek.c b/drivers/net/phy/realtek.c
> old mode 100644
> new mode 100755
> index fb1db71..2ba0d73

checkpatch says:

ERROR: do not set execute permissions for source files
#23: FILE: drivers/net/phy/realtek.c

total: 1 errors, 0 warnings, 0 checks, 46 lines checked
