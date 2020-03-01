Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2CFE7174FFE
	for <lists+netdev@lfdr.de>; Sun,  1 Mar 2020 22:40:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726627AbgCAVkz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 1 Mar 2020 16:40:55 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:40602 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726050AbgCAVkz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 1 Mar 2020 16:40:55 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=E/+UYayoZIrw9e56UG2IVzsic2/vv3VX+KLxwnPRTYM=; b=cr+ZhHjLbL9BMxqSdRTfu8VSrV
        qMoQqsv48Tm95kvg2+0K5mIjrez2S1g6xedN+D+OZqeqAoXSddCTS5hqvfXQIkaGVXhw5sft++mda
        pP82sZZXeCJNthHBjRptT3GGClGCwYiiefgcJwHtj7zisR2ERxjMOAno/SRq4wxdsuGs=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1j8WKO-00010U-2f; Sun, 01 Mar 2020 22:40:48 +0100
Date:   Sun, 1 Mar 2020 22:40:48 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Russell King - ARM Linux <linux@armlinux.org.uk>,
        David Miller <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next] net: phy: mscc: add constants for used
 interrupt mask bits
Message-ID: <20200301214048.GK12571@lunn.ch>
References: <6503f7cf-477d-954b-ab7c-c9805cfa3692@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6503f7cf-477d-954b-ab7c-c9805cfa3692@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Mar 01, 2020 at 09:57:08PM +0100, Heiner Kallweit wrote:
> Add constants for the used interrupts bits. This avoids the magic
> number for MII_VSC85XX_INT_MASK_MASK.
> 
> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
