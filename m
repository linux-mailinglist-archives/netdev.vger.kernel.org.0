Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 42E063F9AD5
	for <lists+netdev@lfdr.de>; Fri, 27 Aug 2021 16:25:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245290AbhH0OZ0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Aug 2021 10:25:26 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:44790 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245124AbhH0OZZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 27 Aug 2021 10:25:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Transfer-Encoding:Content-Disposition:
        Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:From:
        Sender:Reply-To:Subject:Date:Message-ID:To:Cc:MIME-Version:Content-Type:
        Content-Transfer-Encoding:Content-ID:Content-Description:Content-Disposition:
        In-Reply-To:References; bh=RzRmHXMiMUltnkQLLQCDBqteEsF4v4ZkyIkgOeJT6sE=; b=XC
        +lVaEUPY1alOkJ7yvAalY7ZrJ69eBrHcgpziPKxNqvp62Puysi0Lx9kP4oJVYM9cSlT0Si251Dsdu
        0g3M3fUg9Ukx7SJG7+PrrSnLAMhv/Rk/5SS8X0CF/MCdjRP+qXu7cevW85PLOJ55terpJ5YaLxqys
        UKp9ZKKu5/iyzcY=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mJcmZ-0047Tn-2u; Fri, 27 Aug 2021 16:24:35 +0200
Date:   Fri, 27 Aug 2021 16:24:35 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Marek =?iso-8859-1?Q?Beh=FAn?= <kabel@kernel.org>
Cc:     netdev@vger.kernel.org, Russell King <linux@armlinux.org.uk>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: Re: [PATCH net v2] net: phy: marvell10g: fix broken PHY interrupts
 for anyone after us in the driver probe list
Message-ID: <YSj1o8hrcsPHDrVX@lunn.ch>
References: <20210827132541.28953-1-kabel@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210827132541.28953-1-kabel@kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Fixes: a5de4be0aaaa ("net: phy: marvell10g: fix differentiation of 88X3310 from 88X3340")
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> Tested-by: Marek Behún <kabel@kernel.org>
> Signed-off-by: Marek Behún <kabel@kernel.org>

Looks sensible.

Thanks

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
