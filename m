Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1FDF044B51C
	for <lists+netdev@lfdr.de>; Tue,  9 Nov 2021 23:06:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235383AbhKIWI4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Nov 2021 17:08:56 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:53516 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229811AbhKIWIw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 9 Nov 2021 17:08:52 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Transfer-Encoding:Content-Disposition:
        Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:From:
        Sender:Reply-To:Subject:Date:Message-ID:To:Cc:MIME-Version:Content-Type:
        Content-Transfer-Encoding:Content-ID:Content-Description:Content-Disposition:
        In-Reply-To:References; bh=XZSmerSMps76qJRNYx5PC9xWZatGJl3orf1RhmBjJts=; b=VI
        r1bqh2i79KQY4iWD4oH7/0PwKZnEsh/uGE/dEck+jfxFkca91rNLGkGPxAtjzWLWby/iZ077iYmni
        tRP6pcbrTwEQy0Hqk+uTIXkNafJ6M/xZzRul2d8TASpe8t7PV0GPtT1SR5+tBQfYMl01Ftsq1nTQO
        JmZ/rtlSEIIHyK4=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mkZFk-00D1jJ-MP; Tue, 09 Nov 2021 23:06:04 +0100
Date:   Tue, 9 Nov 2021 23:06:04 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Marek =?iso-8859-1?Q?Beh=FAn?= <kabel@kernel.org>
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Russell King <rmk+kernel@armlinux.org.uk>
Subject: Re: [PATCH net] net: dsa: mv88e6xxx: Don't support >1G speeds on
 6191X on ports other than 10
Message-ID: <YYrwzC5mb6zINA27@lunn.ch>
References: <20211104171747.10509-1-kabel@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20211104171747.10509-1-kabel@kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 04, 2021 at 06:17:47PM +0100, Marek Behún wrote:
> Model 88E6191X only supports >1G speeds on port 10. Port 0 and 9 are
> only 1G.
> 
> Fixes: de776d0d316f ("net: dsa: mv88e6xxx: add support for mv88e6393x family")
> Signed-off-by: Marek Behún <kabel@kernel.org>
> Cc: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
