Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 869913888A
	for <lists+netdev@lfdr.de>; Fri,  7 Jun 2019 13:08:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728442AbfFGLIq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Jun 2019 07:08:46 -0400
Received: from laurent.telenet-ops.be ([195.130.137.89]:42192 "EHLO
        laurent.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728399AbfFGLIq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Jun 2019 07:08:46 -0400
Received: from ramsan ([84.194.111.163])
        by laurent.telenet-ops.be with bizsmtp
        id Mn8j2000m3XaVaC01n8jYw; Fri, 07 Jun 2019 13:08:44 +0200
Received: from rox.of.borg ([192.168.97.57])
        by ramsan with esmtp (Exim 4.90_1)
        (envelope-from <geert@linux-m68k.org>)
        id 1hZCjj-000497-Qk; Fri, 07 Jun 2019 13:08:43 +0200
Received: from geert by rox.of.borg with local (Exim 4.90_1)
        (envelope-from <geert@linux-m68k.org>)
        id 1hZCjj-0003MQ-PI; Fri, 07 Jun 2019 13:08:43 +0200
From:   Geert Uytterhoeven <geert+renesas@glider.be>
To:     "David S . Miller" <davem@davemloft.net>,
        Jonathan Corbet <corbet@lwn.net>,
        Jiri Kosina <trivial@kernel.org>
Cc:     netdev@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>
Subject: [PATCH trivial] Documentation: net: dsa: Grammar s/the its/its/
Date:   Fri,  7 Jun 2019 13:08:42 +0200
Message-Id: <20190607110842.12876-1-geert+renesas@glider.be>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
---
 Documentation/networking/dsa/dsa.rst | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/Documentation/networking/dsa/dsa.rst b/Documentation/networking/dsa/dsa.rst
index ca87068b9ab904a9..563d56c6a25c924e 100644
--- a/Documentation/networking/dsa/dsa.rst
+++ b/Documentation/networking/dsa/dsa.rst
@@ -531,7 +531,7 @@ Bridge VLAN filtering
   a software implementation.
 
 .. note:: VLAN ID 0 corresponds to the port private database, which, in the context
-        of DSA, would be the its port-based VLAN, used by the associated bridge device.
+        of DSA, would be its port-based VLAN, used by the associated bridge device.
 
 - ``port_fdb_del``: bridge layer function invoked when the bridge wants to remove a
   Forwarding Database entry, the switch hardware should be programmed to delete
@@ -554,7 +554,7 @@ Bridge VLAN filtering
   associated with this VLAN ID.
 
 .. note:: VLAN ID 0 corresponds to the port private database, which, in the context
-        of DSA, would be the its port-based VLAN, used by the associated bridge device.
+        of DSA, would be its port-based VLAN, used by the associated bridge device.
 
 - ``port_mdb_del``: bridge layer function invoked when the bridge wants to remove a
   multicast database entry, the switch hardware should be programmed to delete
-- 
2.17.1

