Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DA3FC17031B
	for <lists+netdev@lfdr.de>; Wed, 26 Feb 2020 16:50:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728532AbgBZPuZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Feb 2020 10:50:25 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:35326 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728205AbgBZPuZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 26 Feb 2020 10:50:25 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=GptTXN1lcq7WkB8yqzH0ptbEdYgv5vWzFVj2QklJQEM=; b=nOPzx8TCZ7E1Tlbtjh2/qJdosd
        zYsg1obhumsmP+MzkhkfM/SxZDL6chK0nScdzmLPPGc+Is65dL5nvFf9UsbtygJGJ+OC7zpcHXDxV
        +S4thpu10z7gD4j5qeu6g0zLB4s0tjy11xpMKFCZy96R5uZCMwHNW2OyCzKqT4vW1S8Q=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1j6yx3-0006jK-ML; Wed, 26 Feb 2020 16:50:21 +0100
Date:   Wed, 26 Feb 2020 16:50:21 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Antoine Tenart <antoine.tenart@bootlin.com>
Cc:     davem@davemloft.net, f.fainelli@gmail.com, hkallweit1@gmail.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux@armlinux.org.uk
Subject: Re: [PATCH net-next] net: phy: mscc: add missing shift for media
 operation mode selection
Message-ID: <20200226155021.GK7663@lunn.ch>
References: <20200226144034.1519658-1-antoine.tenart@bootlin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200226144034.1519658-1-antoine.tenart@bootlin.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 26, 2020 at 03:40:34PM +0100, Antoine Tenart wrote:
> This patch adds a missing shift for the media operation mode selection.
> This does not fix the driver as the current operation mode (copper) has
> a value of 0, but this wouldn't work for other modes.
> 
> Signed-off-by: Antoine Tenart <antoine.tenart@bootlin.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
