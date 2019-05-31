Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9A6063096C
	for <lists+netdev@lfdr.de>; Fri, 31 May 2019 09:38:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726824AbfEaHiM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 May 2019 03:38:12 -0400
Received: from esa1.hc3370-68.iphmx.com ([216.71.145.142]:18509 "EHLO
        esa1.hc3370-68.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725955AbfEaHiM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 May 2019 03:38:12 -0400
X-Greylist: delayed 426 seconds by postgrey-1.27 at vger.kernel.org; Fri, 31 May 2019 03:38:12 EDT
Authentication-Results: esa1.hc3370-68.iphmx.com; dkim=none (message not signed) header.i=none; spf=None smtp.pra=wei.liu2@citrix.com; spf=Pass smtp.mailfrom=wei.liu2@citrix.com; spf=None smtp.helo=postmaster@MIAPEX02MSOL02.citrite.net
Received-SPF: None (esa1.hc3370-68.iphmx.com: no sender
  authenticity information available from domain of
  wei.liu2@citrix.com) identity=pra; client-ip=23.29.105.83;
  receiver=esa1.hc3370-68.iphmx.com;
  envelope-from="wei.liu2@citrix.com";
  x-sender="wei.liu2@citrix.com"; x-conformance=sidf_compatible
Received-SPF: Pass (esa1.hc3370-68.iphmx.com: domain of
  wei.liu2@citrix.com designates 23.29.105.83 as permitted
  sender) identity=mailfrom; client-ip=23.29.105.83;
  receiver=esa1.hc3370-68.iphmx.com;
  envelope-from="wei.liu2@citrix.com";
  x-sender="wei.liu2@citrix.com";
  x-conformance=sidf_compatible; x-record-type="v=spf1";
  x-record-text="v=spf1 ip4:209.167.231.154 ip4:178.63.86.133
  ip4:195.66.111.40/30 ip4:85.115.9.32/28 ip4:199.102.83.4
  ip4:192.28.146.160 ip4:192.28.146.107 ip4:216.52.6.88
  ip4:216.52.6.188 ip4:23.29.105.83 ip4:162.221.156.50 ~all"
Received-SPF: None (esa1.hc3370-68.iphmx.com: no sender
  authenticity information available from domain of
  postmaster@MIAPEX02MSOL02.citrite.net) identity=helo;
  client-ip=23.29.105.83; receiver=esa1.hc3370-68.iphmx.com;
  envelope-from="wei.liu2@citrix.com";
  x-sender="postmaster@MIAPEX02MSOL02.citrite.net";
  x-conformance=sidf_compatible
IronPort-SDR: lnooVlL8SkMYL7aPjFH0jxwqMqTKLbSrblMa8zyQNljsCXqWr5WsLeRsStI1tiqYlKtZhVPsuN
 KUsYKtAhuC/Y8nB4rO7QrMNvbOHFRVGMDXlSI4ieqHGoWUrwEJq4B1hkIB+Nib73CorDkLXehy
 96W2DXAMm55/Mn7jGRa6JwxE1cWUVwdDp+ymOOYogGbNWCwvgElbIekg8pBjovVyrGhv2JLXga
 nzf8zrqCokKxRQSD+kWFPjP5GU0BEsPoOjPmNjxyvMN1CjGgNy6agoTuO8utgOoEG9XnF+i+DD
 xH0=
X-SBRS: 2.7
X-MesageID: 1145273
X-Ironport-Server: esa1.hc3370-68.iphmx.com
X-Remote-IP: 23.29.105.83
X-Policy: $RELAYED
X-IronPort-AV: E=Sophos;i="5.60,534,1549947600"; 
   d="scan'208";a="1145273"
From:   Wei Liu <wei.liu2@citrix.com>
To:     <netdev@vger.kernel.org>
CC:     Xen-devel <xen-devel@lists.xenproject.org>,
        Paul Durrant <Paul.Durrant@citrix.com>,
        David Miller <davem@davemloft.net>,
        Wei Liu <wei.liu2@citrix.com>
Subject: [PATCH net-next] Update my email address
Date:   Fri, 31 May 2019 08:31:02 +0100
Message-ID: <20190531073102.5334-1-wei.liu2@citrix.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Signed-off-by: Wei Liu <wei.liu2@citrix.com>
---
 MAINTAINERS | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 0c55b0fedbe2..e212c6a42ddf 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -17295,7 +17295,7 @@ F:	Documentation/ABI/stable/sysfs-hypervisor-xen
 F:	Documentation/ABI/testing/sysfs-hypervisor-xen
 
 XEN NETWORK BACKEND DRIVER
-M:	Wei Liu <wei.liu2@citrix.com>
+M:	Wei Liu <wei.liu@kernel.org>
 M:	Paul Durrant <paul.durrant@citrix.com>
 L:	xen-devel@lists.xenproject.org (moderated for non-subscribers)
 L:	netdev@vger.kernel.org
-- 
2.20.1

