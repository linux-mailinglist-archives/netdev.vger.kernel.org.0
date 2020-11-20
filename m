Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 601A42BA95B
	for <lists+netdev@lfdr.de>; Fri, 20 Nov 2020 12:41:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727956AbgKTLk3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Nov 2020 06:40:29 -0500
Received: from dispatch1-us1.ppe-hosted.com ([67.231.154.183]:55888 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726541AbgKTLk3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Nov 2020 06:40:29 -0500
X-Greylist: delayed 485 seconds by postgrey-1.27 at vger.kernel.org; Fri, 20 Nov 2020 06:40:28 EST
Received: from dispatch1-us1.ppe-hosted.com (localhost.localdomain [127.0.0.1])
        by dispatch1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id 7912521B71A
        for <netdev@vger.kernel.org>; Fri, 20 Nov 2020 11:32:23 +0000 (UTC)
Received: from mx1-us1.ppe-hosted.com (unknown [10.110.50.144])
        by dispatch1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id 056172006F;
        Fri, 20 Nov 2020 11:32:23 +0000 (UTC)
Received: from us4-mdac16-49.at1.mdlocal (unknown [10.110.50.132])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id 03D40800A4;
        Fri, 20 Nov 2020 11:32:23 +0000 (UTC)
X-Virus-Scanned: Proofpoint Essentials engine
Received: from mx1-us1.ppe-hosted.com (unknown [10.110.49.102])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 98FBA4006F;
        Fri, 20 Nov 2020 11:32:22 +0000 (UTC)
Received: from webmail.solarflare.com (uk.solarflare.com [193.34.186.16])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 561B06C0055;
        Fri, 20 Nov 2020 11:32:22 +0000 (UTC)
Received: from mh-desktop (10.17.20.62) by ukex01.SolarFlarecom.com
 (10.17.10.4) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 20 Nov
 2020 11:32:16 +0000
Date:   Fri, 20 Nov 2020 11:32:07 +0000
From:   Martin Habets <mhabets@solarflare.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, <netdev@vger.kernel.org>
CC:     Edward Cree <ecree@solarflare.com>,
        Edward Cree <ecree.xilinx@gmail.com>,
        Martin Habets <habetsm.xilinx@gmail.com>
Subject: [PATCH net] MAINTAINERS: Change Solarflare maintainers
Message-ID: <20201120113207.GA1605547@mh-desktop>
Mail-Followup-To: Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Edward Cree <ecree@solarflare.com>,
        Edward Cree <ecree.xilinx@gmail.com>,
        Martin Habets <habetsm.xilinx@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
X-Originating-IP: [10.17.20.62]
X-ClientProxiedBy: ocex03.SolarFlarecom.com (10.20.40.36) To
 ukex01.SolarFlarecom.com (10.17.10.4)
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.6.1012-25800.003
X-TM-AS-Result: No-4.722800-8.000000-10
X-TMASE-MatchedRID: qHyM7pCobyHezO9WekFnOHCO70QAsBdCeik/fzJr6ax2V7JNjG7XFDBX
        Xb/qS263rdoLblq9S5pu+xX/NyzonEfX0Ayg3UN3yZHnIMmQ+DhJaD67iKvY0x3RY4pGTCyHie3
        MY7Xv0pg2om5FtUobJX8mA3sDDq0AcWlAkEA3e4Nq8/xv2Um1avoLR4+zsDTtEiT56ZiIPauemT
        ArggdWtqvCbzbsIRLQj7obrUs1KUaGqVWpjnbMDU+7pnt+3ihRxw1z7whTrMu+bT2iPoR396wa8
        kF5El6Hk2pitPhs16XEetOAikVNK2jj9C2nJxADTkAgCH67EbmdzWPzySgJGu53VB1DJl7uftwZ
        3X11IV0=
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10-4.722800-8.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.6.1012-25800.003
X-MDID: 1605871943-9EIPI0wYj1CS
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Email from solarflare.com will stop working. Update the maintainers.
A replacement for linux-net-drivers@solarflare.com is not working yet,
for now remove it.

Signed-off-by: Martin Habets <mhabets@solarflare.com>
Signed-off-by: Edward Cree <ecree@solarflare.com>
---
 MAINTAINERS |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 8cb1aae96bdf..72eb0525c88f 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -15790,9 +15790,8 @@ F:	drivers/slimbus/
 F:	include/linux/slimbus.h
 
 SFC NETWORK DRIVER
-M:	Solarflare linux maintainers <linux-net-drivers@solarflare.com>
-M:	Edward Cree <ecree@solarflare.com>
-M:	Martin Habets <mhabets@solarflare.com>
+M:	Edward Cree <ecree.xilinx@gmail.com>
+M:	Martin Habets <habetsm.xilinx@gmail.com>
 L:	netdev@vger.kernel.org
 S:	Supported
 F:	drivers/net/ethernet/sfc/
