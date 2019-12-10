Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B2D1B118E5B
	for <lists+netdev@lfdr.de>; Tue, 10 Dec 2019 17:57:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727780AbfLJQ5V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Dec 2019 11:57:21 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:45194 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727594AbfLJQ5T (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 10 Dec 2019 11:57:19 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=YtNpRS+/0ITE/bdikvpE9Q02VJ6ZNKc6zmo2mTVH45c=; b=XsriBR7fWym0FCtryg+M1jF96T
        XCJ1kdV+oOqAqYCm5KDoEMeAmTyNd7uYAYTTLRiTAnUOpaLTOMHWctlJOahYoTNRrPF24bPTAKloN
        iO+3zOi9j0OnitePdNIvtnlMZDZIFV99+f4pZO9kuIshLf7O42EATipc4djoDyJeSeBE=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.92.2)
        (envelope-from <andrew@lunn.ch>)
        id 1ieip2-0005Ui-AI; Tue, 10 Dec 2019 17:57:16 +0100
Date:   Tue, 10 Dec 2019 17:57:16 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Russell King <rmk+kernel@armlinux.org.uk>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: Re: [PATCH net-next v2 03/14] net: sfp: add more extended compliance
 codes
Message-ID: <20191210165716.GI27714@lunn.ch>
References: <20191209151553.GP25745@shell.armlinux.org.uk>
 <E1ieKo3-0004um-R5@rmk-PC.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1ieKo3-0004um-R5@rmk-PC.armlinux.org.uk>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 09, 2019 at 03:18:39PM +0000, Russell King wrote:
> SFF-8024 is used to define various constants re-used in several SFF
> SFP-related specifications.  Split these constants from the enum, and
> rename them to indicate that they're defined by SFF-8024.
> 
> Add and use updated SFF-8024 extended compliance code definitions for
> 10GBASE-T, 5GBASE-T and 2.5GBASE-T modules.
> 
> Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>

> +	case SFF8024_CONNECTOR_SG: /* guess */

Does SFF8024 say anything about this, or is it still a guess?

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
