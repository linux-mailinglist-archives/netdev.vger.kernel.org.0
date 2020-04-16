Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE1AB1AC66B
	for <lists+netdev@lfdr.de>; Thu, 16 Apr 2020 16:39:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729254AbgDPOjQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Apr 2020 10:39:16 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:41810 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392889AbgDPOjB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Apr 2020 10:39:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=t9o/0fX6kp5xG6Ocs8a+gY+ZKCwM6Z0yeyoSCYOginU=; b=SK3rvxq1KD6mADx+S856fg0Ycz
        l4//cxWqkKDkp53Q9Yk6tdXpgUQbJ5TXSTgUAeAVwpZrx3XgZ293MJYHfYBfqT6IjruMW7/dWdND4
        1276tN+wFh+0Z6Htv4opD9eNPxwnuxd/xqvxwSSsk6jJgZEom06mMDKSKHCNm85BXGdc=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jP5fO-0035Ra-LI; Thu, 16 Apr 2020 16:38:58 +0200
Date:   Thu, 16 Apr 2020 16:38:58 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Baruch Siach <baruch@tkos.co.il>
Cc:     Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Maxime Chevallier <maxime.chevallier@bootlin.com>
Subject: Re: [PATCH] net: phy: marvell10g: disable temperature sensor on 2110
Message-ID: <20200416143858.GO657811@lunn.ch>
References: <1eca8c654679764a64252072509ddc1bf59938a0.1587047556.git.baruch@tkos.co.il>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1eca8c654679764a64252072509ddc1bf59938a0.1587047556.git.baruch@tkos.co.il>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 16, 2020 at 05:32:36PM +0300, Baruch Siach wrote:
> The 88E2110 temperature sensor is in a different location than 88X3310,
> and it has no enable/disable option.

Hi Buruch

How easy would it be to support the new location? These things can get
warm, specially if there is no heat sink attached. So it would be nice
to support it, if possible.

   Andrew
