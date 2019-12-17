Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3882A1230C9
	for <lists+netdev@lfdr.de>; Tue, 17 Dec 2019 16:47:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727742AbfLQPrf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Dec 2019 10:47:35 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:57726 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726191AbfLQPrf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 17 Dec 2019 10:47:35 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=bgBSVbLqrmEu2VS+yc9/NxoIURw8inKNYTVLsKODS0w=; b=dTbN6ZjsNdMCffzN4u/r3OcsHU
        jui9oPtJtb44WC4GKuXXZaFESOVbnTlc9F0VnRhgftX88B/X7pIgxD0j4DnnSTbhKU2wMbS1pULu3
        2P33+gN3DTra7Tsf35CjI3FL1wcW9v7LLDbli21gzd7/Z1Y/gV2YtvgX2/bBOSIn13Ps=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.92.2)
        (envelope-from <andrew@lunn.ch>)
        id 1ihF4N-0002n7-CH; Tue, 17 Dec 2019 16:47:31 +0100
Date:   Tue, 17 Dec 2019 16:47:31 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Russell King <rmk+kernel@armlinux.org.uk>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: Re: [PATCH net-next 09/11] net: phy: marvell: use existing clause 37
 definitions
Message-ID: <20191217154731.GP17965@lunn.ch>
References: <20191217133827.GQ25745@shell.armlinux.org.uk>
 <E1ihD4g-0001zI-0E@rmk-PC.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1ihD4g-0001zI-0E@rmk-PC.armlinux.org.uk>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 17, 2019 at 01:39:42PM +0000, Russell King wrote:
> Use existing clause 37 advertising/link partner definitions rather than
> private ones for the advertisement registers.
> 
> Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
