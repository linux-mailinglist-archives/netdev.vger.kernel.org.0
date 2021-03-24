Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 47E67347E5A
	for <lists+netdev@lfdr.de>; Wed, 24 Mar 2021 17:59:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236973AbhCXQ6x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Mar 2021 12:58:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236579AbhCXQ6t (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Mar 2021 12:58:49 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93AD7C061763
        for <netdev@vger.kernel.org>; Wed, 24 Mar 2021 09:58:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:
        Content-Transfer-Encoding:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Reply-To:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=WkSSktRhFxCI0+g2YuqRaHtOth0bcrEVBxdwpgKGsn8=; b=h7sdtVfQhuTBX/JdckETRrWyD
        EZkjmCM4o7Vzvpn2BTcOIgD0NTix+9g5Qe+bthVt1IgWkOKLAOoYPinnldYLiFl6nr1nfaP8hlZQ7
        g3GLRyhplEp1oCxwa84Iy/i0TCm3apn9PFoGyXiaQtqxMI6hvfTM3BGrugMx1tDXTqxs9Jj/23L8J
        lUXM4CKOQP9YUJdyHoWeY/XOpAba5U1jd0jQYMMcX3rrAoui+QNK/+nFn6xSnBkGtD+U3A/9ya1sb
        j1aIVV/eXXWtdPoqssYh1y6QS8U+HouipGua1Ucbug1QTupKFnm6ZAHENYtWLTnc+bcxt5Ec8J2EZ
        r2F1ZIOJg==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:51672)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1lP6q6-0000jk-Au; Wed, 24 Mar 2021 16:58:38 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1lP6q4-0005Cm-DC; Wed, 24 Mar 2021 16:58:36 +0000
Date:   Wed, 24 Mar 2021 16:58:36 +0000
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Marek =?iso-8859-1?Q?Beh=FAn?= <kabel@kernel.org>
Cc:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        "David S . Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>, kuba@kernel.org
Subject: Re: [PATCH net-next 4/7] net: phy: marvell10g: add MACTYPE
 definitions for 88X3310/88X3310P
Message-ID: <20210324165836.GF1463@shell.armlinux.org.uk>
References: <20210324165023.32352-1-kabel@kernel.org>
 <20210324165023.32352-5-kabel@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210324165023.32352-5-kabel@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: Russell King - ARM Linux admin <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 24, 2021 at 05:50:20PM +0100, Marek Behún wrote:
> Add all MACTYPE definitions for 88X3310/88X3310P.
> 
> In order to have consistent naming, rename
> MV_V2_PORT_CTRL_MACTYPE_RATE_MATCH to
> MV_V2_PORT_CTRL_MACTYPE_10GR_RATE_MATCH.

We probably ought to note that the 88x3310 and 88x3340 will be detected
by this driver, but have different MACTYPE definitions.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
