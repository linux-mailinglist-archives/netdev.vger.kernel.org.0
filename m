Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 68EDE126F48
	for <lists+netdev@lfdr.de>; Thu, 19 Dec 2019 22:01:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727024AbfLSVBF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Dec 2019 16:01:05 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:33974 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726880AbfLSVBF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 19 Dec 2019 16:01:05 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=Y2rAcYey8tO0y2ZYhyJFZqSqoF6GkKKd40qZIhlQ+OY=; b=xPglZwHfkanQavHv1J5lI0sRg+
        rwum6o4NR0azt+IwWpRNl9KbXZysCjpQDxNQ5XsyYEBtIzlN1l52EaD9w6OcHiEyeDW30H7vfJueB
        Tn+8ErzzunfL8uFvCfRaIjO/DjvkJ3ovSS8tQPc5tDl/gvKxAo2Emo6PeWXesbThE/1U=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1ii2uq-0005va-59; Thu, 19 Dec 2019 22:01:00 +0100
Date:   Thu, 19 Dec 2019 22:01:00 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Russell King <rmk+kernel@armlinux.org.uk>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: Re: [PATCH] net: phy: ensure that phy IDs are correctly typed
Message-ID: <20191219210100.GQ17475@lunn.ch>
References: <E1ihsvI-0001bz-3t@rmk-PC.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1ihsvI-0001bz-3t@rmk-PC.armlinux.org.uk>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 19, 2019 at 10:20:48AM +0000, Russell King wrote:
> PHY IDs are 32-bit unsigned quantities. Ensure that they are always
> treated as such, and not passed around as "int"s.

Hi Russell

Do we want to fix all cases?

struct phy_device *phy_device_create(struct mii_bus *bus, int addr, int phy_id,

       Andrew
