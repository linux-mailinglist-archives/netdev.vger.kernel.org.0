Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 26727310958
	for <lists+netdev@lfdr.de>; Fri,  5 Feb 2021 11:43:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231312AbhBEKmX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Feb 2021 05:42:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230256AbhBEKjq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Feb 2021 05:39:46 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4ACE2C061797
        for <netdev@vger.kernel.org>; Fri,  5 Feb 2021 02:39:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:Content-Type:MIME-Version:
        Message-ID:Subject:Cc:To:From:Date:Reply-To:Content-Transfer-Encoding:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=0NBsznay4nSnq5tjYJlPeLdjFfT/PKR+t8SLeQA/wB8=; b=vIXUspZX4AIagvIK9mlnLdTBH
        5Aeb70L0Oc9ipFx+Zltb06PdALvjwI1e5EMKr9qmGzo75RD1MwYmHwCFmT74rQlcCqHZSBKgLlpER
        53i2WZTe0CV2lyhtuTOQcsjU+gBCIF8X28eN2kDI72uJZpj/vjO5C3ori22lqaYYR+iAmnoUSTGJp
        u2K9+jxmjVoreXHvJQQBuhdsKL/Ep7zvkKt11fKuKMW3cXtnibBASP72YA/66ajQjv70aCDxVgkDP
        joZW63TvTZNg3BYbgOaQQdHimLE9WVSq15bEYHMktOyoBpbTvi4pwhOmpX4Up7L0z+yfeJ3Jt8T8v
        8uXduAojQ==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:39480)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1l7yVx-0007eD-NK; Fri, 05 Feb 2021 10:39:01 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1l7yVw-00068A-4O; Fri, 05 Feb 2021 10:39:00 +0000
Date:   Fri, 5 Feb 2021 10:39:00 +0000
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Ioana Ciornei <ioana.ciornei@nxp.com>,
        Ioana Radulescu <ruxandra.radulescu@nxp.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH net-next v2 0/3] dpaa2: add 1000base-X support
Message-ID: <20210205103859.GH1463@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: Russell King - ARM Linux admin <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

This patch series adds 1000base-X support to pcs-lynx and DPAA2,
allowing runtime switching between SGMII and 1000base-X. This is
a pre-requisit for SFP module support on the SolidRun ComExpress 7.

v2: updated with Ioana's r-b's, and comment on backplane support

 drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.h |  4 ++-
 drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c | 25 ++++++++++++----
 drivers/net/pcs/pcs-lynx.c                       | 36 ++++++++++++++++++++++++
 3 files changed, 59 insertions(+), 6 deletions(-)

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
