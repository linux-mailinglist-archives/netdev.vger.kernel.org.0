Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AB6A8E7975
	for <lists+netdev@lfdr.de>; Mon, 28 Oct 2019 20:56:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726175AbfJ1T4w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Oct 2019 15:56:52 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:38946 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725839AbfJ1T4w (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 28 Oct 2019 15:56:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=VR3G+MDUZRbBV6q52iSdJXKIy1R8X7Rb37l7KS1PT2M=; b=F4sG+Oal6Whd84t3rj+8KYL9vW
        r22mVoB8b4GwlgPob0DOkN2NecCxXz03Z3MXyIIomXEi6Utq9RQrbrhUn11LW+2C9u1E13B4zqeCs
        WTuXE0V+GROx2KSdg2I1u08PrxcQo2xooBGlsaP2bSTd15OM/E26UMH8yz8EyP68JzBE=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.92.2)
        (envelope-from <andrew@lunn.ch>)
        id 1iPB89-0008Ie-Nq; Mon, 28 Oct 2019 20:56:45 +0100
Date:   Mon, 28 Oct 2019 20:56:45 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        David Miller <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Chris Healy <Chris.Healy@zii.aero>
Subject: Re: [PATCH net-next 1/4] net: phy: marvell: fix typo in constant
 MII_M1011_PHY_SRC_DOWNSHIFT_MASK
Message-ID: <20191028195645.GF17625@lunn.ch>
References: <4ae7d05a-4d1d-024f-ebdf-c92798f1a770@gmail.com>
 <8828cb2a-4628-a58c-8dbb-104ada3bf37a@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8828cb2a-4628-a58c-8dbb-104ada3bf37a@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 28, 2019 at 08:52:22PM +0100, Heiner Kallweit wrote:
> Fix typo and use PHY_SCR for PHY-specific Control Register.
> 
> Fixes: a3bdfce7bf9c ("net: phy: marvell: support downshift as PHY tunable")
> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
