Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0661C438B80
	for <lists+netdev@lfdr.de>; Sun, 24 Oct 2021 20:43:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231995AbhJXSpy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 Oct 2021 14:45:54 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:55870 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231564AbhJXSpx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 24 Oct 2021 14:45:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=Yrjp+brNEVJN32bKJXZtZi6j4endTNV4LbvcbKzWvQ4=; b=ZIw5p+Ca8EihXLtwXd8p7tJ1FS
        KekNjwKMLnWPnFGhkQ3+i8euWdIAdLTpQDhrQwoqevL9g1k6+FUAtkZn00VNtJRCgNBD5Z6y+xSaq
        ZmdSwmqGjM52HQB8aaSXe9tyCqq67aVXuYsKzDJZfRTl8Tbx/ZwPo0mcR2bVmylcDq68=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1meiSu-00Ba5y-Dz; Sun, 24 Oct 2021 20:43:28 +0200
Date:   Sun, 24 Oct 2021 20:43:28 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Luo Jie <luoj@codeaurora.org>
Cc:     hkallweit1@gmail.com, linux@armlinux.org.uk, davem@davemloft.net,
        kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, sricharan@codeaurora.org
Subject: Re: [PATCH v7 14/14] net: phy: add qca8081 cdt feature
Message-ID: <YXWpUPid8rYyJtYJ@lunn.ch>
References: <20211024082738.849-1-luoj@codeaurora.org>
 <20211024082738.849-15-luoj@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211024082738.849-15-luoj@codeaurora.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Oct 24, 2021 at 04:27:38PM +0800, Luo Jie wrote:
> To perform CDT of qca8081 phy:
> 1. disable hibernation.
> 2. force phy working in MDI mode.
> 3. force phy working in 1000BASE-T mode.
> 4. configure the related thresholds.
> 
> Signed-off-by: Luo Jie <luoj@codeaurora.org>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
