Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8FA061624BD
	for <lists+netdev@lfdr.de>; Tue, 18 Feb 2020 11:40:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726327AbgBRKkM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Feb 2020 05:40:12 -0500
Received: from pandora.armlinux.org.uk ([78.32.30.218]:51638 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726298AbgBRKkM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Feb 2020 05:40:12 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:Content-Type:MIME-Version:
        Message-ID:Subject:Cc:To:From:Date:Reply-To:Content-Transfer-Encoding:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=Hp0Ij7ZYJ3qifvzMcq1wfno2U3C2scBRGrabjWil+tw=; b=d9abACLXMhWhCiSNCDA8kuDBI
        iaMFLa23nYQhzNxmDtQcVzvqLsk6ZAJ3jxvlX9Z8AjM0OM2CydwBCTWWsDKrvbiMRiKFGwtMuxtfi
        j8fkUYTrZZUKMt0QugferbpVtNgz1bfKyfw+8bAI+3ckeIT3ByT6U3OD2rWjFATsAl4r1gadGhge/
        uyZt3FGeCup8AuQp+1FeNpKjVbzQJpYsXjoB0yR6K7tUYa4hYLr7HOasYxjLBVygxl0irUsCJlKul
        pCVb6UdYv/hhokxD49rub9GnVNEInC1BQKphfU7H71gvh8QUan9yymU1+rug/RPWocniAykbWdyGe
        xHZXgpQEg==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([2001:4d48:ad52:3201:222:68ff:fe15:37dd]:56356 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1j40IM-0006ee-5J; Tue, 18 Feb 2020 10:40:02 +0000
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1j40IL-0002TU-At; Tue, 18 Feb 2020 10:40:01 +0000
Date:   Tue, 18 Feb 2020 10:40:01 +0000
From:   Russell King <rmk+kernel@armlinux.org.uk>
To:     John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Mark Lee <Mark-MC.Lee@mediatek.com>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: [PATCH] MAINTAINERS: remove Felix Fietkau for the Mediatek ethernet
 driver
Message-ID: <20200218103959.GA9487@e0022681537dd.dyn.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Felix's address has been failing for a while now with the following
non-delivery report:

This message was created automatically by mail delivery software.

A message that you sent could not be delivered to one or more of its
recipients. This is a permanent error. The following address(es) failed:

  nbd@openwrt.org
    host util-01.infra.openwrt.org [2a03:b0c0:3:d0::175a:2001]
    SMTP error from remote mail server after RCPT TO:<nbd@openwrt.org>:
    550 Unrouteable address

Let's remove his address from MAINTAINERS.  If a different resolution
is desired, please submit an alternative patch.

Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
---
 MAINTAINERS | 1 -
 1 file changed, 1 deletion(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index a0d86490c2c6..82dccd29b24f 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -10528,7 +10528,6 @@ F:	drivers/leds/leds-mt6323.c
 F:	Documentation/devicetree/bindings/leds/leds-mt6323.txt
 
 MEDIATEK ETHERNET DRIVER
-M:	Felix Fietkau <nbd@openwrt.org>
 M:	John Crispin <john@phrozen.org>
 M:	Sean Wang <sean.wang@mediatek.com>
 M:	Mark Lee <Mark-MC.Lee@mediatek.com>
-- 
2.20.1

