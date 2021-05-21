Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3EF8038C77F
	for <lists+netdev@lfdr.de>; Fri, 21 May 2021 15:10:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231971AbhEUNMH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 May 2021 09:12:07 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:51200 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230137AbhEUNME (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 21 May 2021 09:12:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=A89kgDUuHxPAjn/UvIwlMnHtkkaJa6w9zzkobeXjdNg=; b=Y5CCyGaBVUB6jqiNLOYkaMS9ix
        zsGnAoOyY1d52rFDwbrC4WJk9iLC0wnjDjRrhJNb4GlidAEVyfwN+SntT82uTr89PsNNyvU+7RRx0
        1W5pjVyjdjziAqyMpl4xnzZwz5r5kDwpJeehdoO+Jt2xTIyTXmL93ZuOvUSIvafNc8Uw=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1lk4uw-005Gs5-Kv; Fri, 21 May 2021 15:10:18 +0200
Date:   Fri, 21 May 2021 15:10:18 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
Cc:     hkallweit1@gmail.com, linux@armlinux.org.uk, davem@davemloft.net,
        kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: phy: Fix inconsistent indenting
Message-ID: <YKexOorwNpoi4VaA@lunn.ch>
References: <1621590014-66912-1-git-send-email-jiapeng.chong@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1621590014-66912-1-git-send-email-jiapeng.chong@linux.alibaba.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 21, 2021 at 05:40:14PM +0800, Jiapeng Chong wrote:
> Eliminate the follow smatch warning:
> 
> drivers/net/phy/phy_device.c:2886 phy_probe() warn: inconsistent
> indenting.
> 
> Reported-by: Abaci Robot <abaci@linux.alibaba.com>
> Signed-off-by: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
