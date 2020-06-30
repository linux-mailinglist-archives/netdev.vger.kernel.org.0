Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6111420F29B
	for <lists+netdev@lfdr.de>; Tue, 30 Jun 2020 12:24:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732473AbgF3KYl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jun 2020 06:24:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732398AbgF3KYf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Jun 2020 06:24:35 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9099FC061755
        for <netdev@vger.kernel.org>; Tue, 30 Jun 2020 03:24:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:Content-Type:MIME-Version:
        Message-ID:Subject:Cc:To:From:Date:Reply-To:Content-Transfer-Encoding:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=UWd4VHWByibEQ4uhLajkZ6wpYPz8ikosuMYzQZMScsA=; b=ifcgpT4Lr+0TNe/xTg1xGeJkB
        G1+AhlY3UpV8kAnQ/BMcrps9HVBTZ5k/cTi3io9Yem+D/CqaCAv+DjY413YdBNwwNAYgZSceLvfO3
        d08BQPE/0U66i34zmnT+8TEFqUWT8eJI0OwDGxYFb1APi5b9i8ev2wmJrgPBeqeuBgiWqn1v9U+6X
        8Hq6vRsuh2nE9yEU9qCuvemCjEQJTYd9L3757rf5SafQu5lel0IArTCbckfFKtCr25OqtatGrC9Hk
        zdEzFCw5ap5/9tZm3DkxWefPi7vqu11k+Md6/+aQNenA8Qqsf2oLr+in1Rlr3i+YViQ5WGeAngdfq
        ugtklXTPg==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:33488)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1jqDRJ-0000Oh-OB; Tue, 30 Jun 2020 11:24:33 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1jqDRG-00086B-CK; Tue, 30 Jun 2020 11:24:30 +0100
Date:   Tue, 30 Jun 2020 11:24:30 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Vivien Didelot <vivien.didelot@gmail.com>
Subject: [PATCH net-next 0/2] Convert Broadcom B53 to mac_link_up() resolved
 state
Message-ID: <20200630102430.GZ1551@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

These two patches update the Broadcom B53 DSA support to use the newly
provided resolved link state via mac_link_up() rather than using the
state in mac_config().

 drivers/net/dsa/b53/b53_common.c | 31 +++++++++++++++----------------
 1 file changed, 15 insertions(+), 16 deletions(-)

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
