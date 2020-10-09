Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0EAA4289023
	for <lists+netdev@lfdr.de>; Fri,  9 Oct 2020 19:40:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387441AbgJIRkN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Oct 2020 13:40:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:36618 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729598AbgJIRkK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 9 Oct 2020 13:40:10 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D616C22277;
        Fri,  9 Oct 2020 17:40:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602265210;
        bh=MFhZP0c2/aTkXHEw4PCm2HsNbJF5EqsrH+5E9AZK3/E=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ULQwiTELnkNVMAqPll1iF1ll/MrTYdBZz4cXHmgfIfpKkN8vYI6ZfcMZJemPR4RXj
         QQbpwfBzSklMwJsKCAdIqi739Kcd/NMJKQnBgpagjPPQ7w24W25P501/GmgSLqPmK5
         Lg68uSRdR7qATYGitRZpn89VO07GyTF7Vlb+aYL0=
Date:   Fri, 9 Oct 2020 10:40:08 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Arnd Bergmann <arnd@arndb.de>
Cc:     linux-kernel@vger.kernel.org, Russell King <linux@armlinux.org.uk>,
        Thomas Gleixner <tglx@linutronix.de>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        John Stultz <john.stultz@linaro.org>,
        Stephen Boyd <sboyd@kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 2/3] net: remove am79c961a driver
Message-ID: <20201009104008.2a975cce@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201008154601.1901004-3-arnd@arndb.de>
References: <20201008154601.1901004-1-arnd@arndb.de>
        <20201008154601.1901004-3-arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu,  8 Oct 2020 17:46:00 +0200 Arnd Bergmann wrote:
> This driver was only used on the EBSA110 platform, which is now
> getting removed, so the driver is no longer needed either.
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

FWIW

Acked-by: Jakub Kicinski <kuba@kernel.org>
