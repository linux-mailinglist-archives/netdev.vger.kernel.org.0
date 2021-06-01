Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EEDFB397325
	for <lists+netdev@lfdr.de>; Tue,  1 Jun 2021 14:25:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233797AbhFAM0r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Jun 2021 08:26:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231726AbhFAM0o (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Jun 2021 08:26:44 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0D9EC061574
        for <netdev@vger.kernel.org>; Tue,  1 Jun 2021 05:25:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=gyySMustJiJw8RTYT48ARMHwHueep4nc0NqEWJ5wXBw=; b=G1e3YVUmHwNkyvyBkRFWu7gOO
        V5QJ6tM+cOgeYjMp4sXneADwVX/LEzYupb7IyeexlQAb8l9NUC/jTNACYEkdCDqhmJIIsSN/RdmSt
        WBcKF4uETLhvhpU1BgCMUvFTa9i8W4Gf3mWclnpHBSlTGXG0yj/cQ+G0n+SgvytSoTeH3gui5OaGd
        3+ejR5D/JLKe1GYz/MKaGb2urBcs5LoHJM3KFxqZcwrdYj47hFqXiIUMKrDWboYIItd7Ncwbvmn5s
        7BS3zcWWuULf9R0ifmEu3572K4ni/zbBLXrCcro4uV0TtZtdkgEq9Qi2kUG1rJ72vzPk1T3V4IjO4
        QD940Adxw==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:44572)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1lo3S8-0003zj-NE; Tue, 01 Jun 2021 13:25:00 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1lo3S8-00006S-2Q; Tue, 01 Jun 2021 13:25:00 +0100
Date:   Tue, 1 Jun 2021 13:25:00 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Xu Liang <lxu@maxlinear.com>
Cc:     andrew@lunn.ch, hkallweit1@gmail.com, netdev@vger.kernel.org,
        davem@davemloft.net, kuba@kernel.org, hmehrtens@maxlinear.com,
        tmohren@maxlinear.com
Subject: Re: [PATCH] phy: maxlinear: add Maxlinear GPY115/21x/24x driver
Message-ID: <20210601122459.GW30436@shell.armlinux.org.uk>
References: <20210601074427.40990-1-lxu@maxlinear.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210601074427.40990-1-lxu@maxlinear.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 01, 2021 at 03:44:27PM +0800, Xu Liang wrote:
> +	if (!(ret & PHY_MIISTAT_LS)
> +	    || FIELD_GET(PHY_MIISTAT_SPD_MASK, ret) != PHY_MIISTAT_SPD_2500)
> +		return false;

We prefer the operators at the end of the previous line rather than at
the beginning of the following line. So:

+	if (!(ret & PHY_MIISTAT_LS) ||
+	    FIELD_GET(PHY_MIISTAT_SPD_MASK, ret) != PHY_MIISTAT_SPD_2500)
+		return false;

Same for the other instances of this.

I think checkpatch should warn about this - did you run your patch
through checkpatch before sending?  There seems to be other style issues
too (e.g. missing blank lines.)

Thanks.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
