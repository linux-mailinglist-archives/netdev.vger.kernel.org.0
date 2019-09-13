Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B38E9B1DE3
	for <lists+netdev@lfdr.de>; Fri, 13 Sep 2019 14:54:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729830AbfIMMyx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Sep 2019 08:54:53 -0400
Received: from esa4.hc3370-68.iphmx.com ([216.71.155.144]:19103 "EHLO
        esa4.hc3370-68.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726771AbfIMMyw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Sep 2019 08:54:52 -0400
X-Greylist: delayed 426 seconds by postgrey-1.27 at vger.kernel.org; Fri, 13 Sep 2019 08:54:52 EDT
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=citrix.com; s=securemail; t=1568379291;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=1FjLAiM1CFwox6bkTWmjXk9BINA8nGGb21FooSLf9zs=;
  b=CyzM7yHUKPbTHarBJjXJLX2U2x7eBnIh1AqqkDrFX+nBlstdqoPgwST7
   nwoAIn43JuLtEpZxP6MCbesTY2vxHvYa42REDY47nduKHGEak1XcH7ISl
   Pa9n4hWcG+h3+uur/ZcL1tvDjitaUGC0R0Y+rcuTPNStvYKO5TSVclzoN
   g=;
Authentication-Results: esa4.hc3370-68.iphmx.com; dkim=none (message not signed) header.i=none; spf=None smtp.pra=paul.durrant@citrix.com; spf=Pass smtp.mailfrom=Paul.Durrant@citrix.com; spf=None smtp.helo=postmaster@mail.citrix.com
Received-SPF: None (esa4.hc3370-68.iphmx.com: no sender
  authenticity information available from domain of
  paul.durrant@citrix.com) identity=pra;
  client-ip=162.221.158.21; receiver=esa4.hc3370-68.iphmx.com;
  envelope-from="Paul.Durrant@citrix.com";
  x-sender="paul.durrant@citrix.com";
  x-conformance=sidf_compatible
Received-SPF: Pass (esa4.hc3370-68.iphmx.com: domain of
  Paul.Durrant@citrix.com designates 162.221.158.21 as
  permitted sender) identity=mailfrom;
  client-ip=162.221.158.21; receiver=esa4.hc3370-68.iphmx.com;
  envelope-from="Paul.Durrant@citrix.com";
  x-sender="Paul.Durrant@citrix.com";
  x-conformance=sidf_compatible; x-record-type="v=spf1";
  x-record-text="v=spf1 ip4:209.167.231.154 ip4:178.63.86.133
  ip4:195.66.111.40/30 ip4:85.115.9.32/28 ip4:199.102.83.4
  ip4:192.28.146.160 ip4:192.28.146.107 ip4:216.52.6.88
  ip4:216.52.6.188 ip4:162.221.158.21 ip4:162.221.156.83 ~all"
Received-SPF: None (esa4.hc3370-68.iphmx.com: no sender
  authenticity information available from domain of
  postmaster@mail.citrix.com) identity=helo;
  client-ip=162.221.158.21; receiver=esa4.hc3370-68.iphmx.com;
  envelope-from="Paul.Durrant@citrix.com";
  x-sender="postmaster@mail.citrix.com";
  x-conformance=sidf_compatible
IronPort-SDR: G4rs6Vv3LOEx/koMDh9FyKRyWRgAuIR7nnpkUOn/WyXt+M8XOnwWSqiUGfy5YmJLp+BGsTXWOf
 B9WFR3chONn/OvCM7yC6GraCHiwXJW/VMnIP6O0XLXSom2kguoGPSiuDANmNuFVlVEMmOpFOw+
 PXpGZ+0eD8TTJGPfSFoIEQtASJfzl62rUohfmP5bZ35WzOX3NfidNptcr7TzFDGMw3B0OhQEEz
 kVGd38H/M53YjqIUOuFhT0LK35ZMAPkT66dvmPViBQLL9mjMhVhkap2ifymDmRgMox4XdRw4Pu
 iiE=
X-SBRS: 2.7
X-MesageID: 5829606
X-Ironport-Server: esa4.hc3370-68.iphmx.com
X-Remote-IP: 162.221.158.21
X-Policy: $RELAYED
X-IronPort-AV: E=Sophos;i="5.64,501,1559534400"; 
   d="scan'208";a="5829606"
From:   Paul Durrant <paul.durrant@citrix.com>
To:     <netdev@vger.kernel.org>, <xen-devel@lists.xenproject.org>
CC:     Paul Durrant <paul.durrant@citrix.com>,
        Wei Liu <wei.liu@kernel.org>
Subject: [PATCH net-next] MAINTAINERS: xen-netback: update my email address
Date:   Fri, 13 Sep 2019 13:47:27 +0100
Message-ID: <20190913124727.3277-1-paul.durrant@citrix.com>
X-Mailer: git-send-email 2.20.1.2.gb21ebb671
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

My Citrix email address will expire shortly.

Signed-off-by: Paul Durrant <paul.durrant@citrix.com>
--
Cc: Wei Liu <wei.liu@kernel.org>
---
 MAINTAINERS | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index e7a47b5210fd..b36d51f0fe5c 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -17646,7 +17646,7 @@ F:	Documentation/ABI/testing/sysfs-hypervisor-xen
 
 XEN NETWORK BACKEND DRIVER
 M:	Wei Liu <wei.liu@kernel.org>
-M:	Paul Durrant <paul.durrant@citrix.com>
+M:	Paul Durrant <paul@xen.org>
 L:	xen-devel@lists.xenproject.org (moderated for non-subscribers)
 L:	netdev@vger.kernel.org
 S:	Supported
-- 
2.20.1.2.gb21ebb671

