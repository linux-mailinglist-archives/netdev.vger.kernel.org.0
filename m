Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B260EF909F
	for <lists+netdev@lfdr.de>; Tue, 12 Nov 2019 14:27:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727310AbfKLN1c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Nov 2019 08:27:32 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:35734 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725944AbfKLN1c (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 12 Nov 2019 08:27:32 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=euNUpgPVSFECHKrlPOqySzeXVv/LTuML8q4Esa2KSao=; b=XPrY76jGMc1pxZG3n/FWKdj1bp
        RrmBbhUjtJid7xU9Wtv9uQvDYDjb7fXB8BjrxI3XhhjZXsUIhqNQVHD4dG5/r7MvXH5PQbG2tz+47
        Yc8Gn5CC42pqFtluXt8wYnTFV9dwbOxENy/ub0yBeVlLE2GOQgqJuA+1E90qxSMWxKWI=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.92.2)
        (envelope-from <andrew@lunn.ch>)
        id 1iUWCe-0001XN-3P; Tue, 12 Nov 2019 14:27:28 +0100
Date:   Tue, 12 Nov 2019 14:27:28 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Colin King <colin.king@canonical.com>
Cc:     Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Iwan R Timmer <irtimmer@gmail.com>, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH][next] net: dsa: mv88e6xxx: fix broken if statement
 because of a stray semicolon
Message-ID: <20191112132728.GC5090@lunn.ch>
References: <20191112130523.232461-1-colin.king@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191112130523.232461-1-colin.king@canonical.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 12, 2019 at 01:05:23PM +0000, Colin King wrote:
> From: Colin Ian King <colin.king@canonical.com>
> 
> There is a stray semicolon in an if statement that will cause a dev_err
> message to be printed unconditionally. Fix this by removing the stray
> semicolon.
> 
> Addresses-Coverity: ("Stay semicolon")
> Fixes: f0942e00a1ab ("net: dsa: mv88e6xxx: Add support for port mirroring")
> Signed-off-by: Colin Ian King <colin.king@canonical.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
