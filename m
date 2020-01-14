Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 93EB5139F90
	for <lists+netdev@lfdr.de>; Tue, 14 Jan 2020 03:42:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729609AbgANCmF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jan 2020 21:42:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:51956 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729094AbgANCmF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 13 Jan 2020 21:42:05 -0500
Received: from cakuba (c-73-93-4-247.hsd1.ca.comcast.net [73.93.4.247])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 05BA120CC7;
        Tue, 14 Jan 2020 02:42:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578969724;
        bh=cYeNuRI3BRYwHaUnuxx2Yc5dqSVhWfN5JURywJNKI6Y=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=J3fP5R2s+gajhLPyX1jFepCT4lILG3era6Pd0qYpL+L6uMMXB9dqyTkQgJDYfalSo
         BU7YO4k5c+uAAg89v1EjMXTe/ulAGOkhfcaL386dkxFg23TneH8qQkdQxysCO6K4LC
         SA0pA4NkLeS4WU0MZjR0T7K4SCSKboIvchqI64VQ=
Date:   Mon, 13 Jan 2020 18:42:03 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Milind Parab <mparab@cadence.com>
Cc:     <nicolas.ferre@microchip.com>, <andrew@lunn.ch>,
        <antoine.tenart@bootlin.com>, <rmk+kernel@armlinux.org.uk>,
        <Claudiu.Beznea@microchip.com>, <f.fainelli@gmail.com>,
        <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <hkallweit1@gmail.com>, <linux-kernel@vger.kernel.org>,
        <dkangude@cadence.com>, <a.fatoum@pengutronix.de>,
        <brad.mouring@ni.com>, <pthombar@cadence.com>
Subject: Re: [PATCH v3 net] net: macb: fix for fixed-link mode
Message-ID: <20200113184203.06eb133d@cakuba>
In-Reply-To: <1578886243-43953-1-git-send-email-mparab@cadence.com>
References: <1578886243-43953-1-git-send-email-mparab@cadence.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 13 Jan 2020 03:30:43 +0000, Milind Parab wrote:
> This patch fix the issue with fixed link. With fixed-link
> device opening fails due to macb_phylink_connect not
> handling fixed-link mode, in which case no MAC-PHY connection
> is needed and phylink_connect return success (0), however
> in current driver attempt is made to search and connect to
> PHY even for fixed-link.
> 
> Fixes: 7897b071ac3b ("net: macb: convert to phylink")
> Signed-off-by: Milind Parab <mparab@cadence.com>

Applied, thank you!
