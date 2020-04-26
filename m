Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 512681B9229
	for <lists+netdev@lfdr.de>; Sun, 26 Apr 2020 19:41:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726312AbgDZRlQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Apr 2020 13:41:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726303AbgDZRlP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Apr 2020 13:41:15 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:3201:214:fdff:fe10:1be6])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CA0BC061A0F
        for <netdev@vger.kernel.org>; Sun, 26 Apr 2020 10:41:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:Content-Type:MIME-Version:
        Message-ID:Subject:Cc:To:From:Date:Reply-To:Content-Transfer-Encoding:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=EKEm9tCTR1OowOv86v3kxiEHta6J0ghoPWBjdKDX0KA=; b=A8nuj1N//DPsAE1CM+/uw0aTX
        4z3aP4srUsmErBvM+JOxEmYX8x4lYoPbHHBIIrpCUY4cAeeSUWZWIr7p8w9fUhmug/uTH6otEJxV/
        aEtOnDLP0mN/VDANJMAs7XUFIyx8/FhbJMqlE1igkYnR6XqWBlJlA1+dfwk1Y/9bpXoySR8AfzzTY
        J3xP1M88OPFvcBdJi5UMuaGg7gYdIFjCvxRJSzFgNiWJNX98NU2VxJsvJjbNBnKhiNlNG7V7qOeUb
        4S+FzAosAKBkgNEuSQ7SNmQPb0yiyYUZEdcMuGb39urjJ8pfde7+JWxJxlXfP+0VED8QLlnh5f7kX
        /3r6XGO0w==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:55834)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1jSlH5-0006aI-2Z; Sun, 26 Apr 2020 18:41:03 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1jSlH0-0005rH-TL; Sun, 26 Apr 2020 18:40:58 +0100
Date:   Sun, 26 Apr 2020 18:40:58 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Ioana Ciornei <ioana.ciornei@nxp.com>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: Commit "MAINTAINERS: update dpaa2-eth maintainer list"
Message-ID: <20200426174058.GB25745@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

I see there is the commit below in net-next, but it seems to only
partially address my comments to you about the maintainership of
this driver.

Is Ioana Radulescu's email address now active again?  If it is not,
then my original report and issue with the maintainership of DPAA2
still stands, and it interferes with my ability to send patches.
It means I have to keep adding a commit on top of net-next to fix
MAINTAINERS every time I want to send patches that touch DPAA2.

Please check what the current situation is, and remove Ioana
Radulescu's email address if it is indeed dead, or let me know if
it is not.  Either way, I would like to get rid of one way or
another the additional commit I'm having to carry to fix this
apparently broken MAINTAINERS entry.

Thanks.

commit 31fa51ad7c5664d0e6530e3d537e2eb025aa1925
Author: Ioana Ciornei <ioana.ciornei@nxp.com>
Date:   Wed Apr 22 20:52:54 2020 +0300

    MAINTAINERS: update dpaa2-eth maintainer list

    Add myself as another maintainer of dpaa2-eth.

    Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
    Signed-off-by: David S. Miller <davem@davemloft.net>

diff --git a/MAINTAINERS b/MAINTAINERS
index 6851ef7cf1bd..d5e4d13880b2 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -5173,6 +5173,7 @@ S:        Maintained
 F:     drivers/soc/fsl/dpio

 DPAA2 ETHERNET DRIVER
+M:     Ioana Ciornei <ioana.ciornei@nxp.com>
 M:     Ioana Radulescu <ruxandra.radulescu@nxp.com>
 L:     netdev@vger.kernel.org
 S:     Maintained

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 10.2Mbps down 587kbps up
