Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C300C29E18B
	for <lists+netdev@lfdr.de>; Thu, 29 Oct 2020 03:01:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729015AbgJ2CBs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Oct 2020 22:01:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727792AbgJ1Vt1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Oct 2020 17:49:27 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E05BAC0613D2;
        Wed, 28 Oct 2020 14:49:26 -0700 (PDT)
From:   Kurt Kanzenbach <kurt@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1603870986;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=R5JbCe15p9QmFetIlvfzE5q6azcmkgkwYzTevDjWbeQ=;
        b=uHG4YJeJ1P0IgfwMEu/C7+JIrwtE9z5NavUGNKSgSmsNW9LURjbOOawvQJv+E1iWL4MI//
        vLYRqKfdbkpty1fIU2Rc299epgQM+5/qOE1tivvc2MmApYwksneHib+qevRlbrbWOymeB+
        dBXqgobQJTjJzBY9KigJJPQiF2ah2E6Q/0k7P4ucK5ttw+jhwpzyxKZ0Wr5NIgYRO88UOi
        1/3+r9QOnxmLtyiNbzpQ2cQixkHz6s55Kra5vzi5sQUNbKEChdlgBScN48HWd/1U4H2jpl
        OXz6MhqTS2hakaGfQckS+8ElJfOeMP4rP0HQLLP3R4pkbqSXFzWn5QFtARyCfg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1603870986;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=R5JbCe15p9QmFetIlvfzE5q6azcmkgkwYzTevDjWbeQ=;
        b=+VgtKBFZ9sMl0Rh9g3l5Xk2EK6KdVKpS96XolCz5QHz3b0vYybmLx+Q3rSmJ0d9trpbDWv
        UXyQhwuxer+x9jAg==
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Richard Cochran <richardcochran@gmail.com>,
        Kamil Alkhouri <kamil.alkhouri@hs-offenburg.de>,
        ilias.apalodimas@linaro.org, Kurt Kanzenbach <kurt@linutronix.de>,
        Rob Herring <robh@kernel.org>
Subject: [PATCH net-next v7 7/8] dt-bindings: Add vendor prefix for Hirschmann
Date:   Wed, 28 Oct 2020 08:42:20 +0100
Message-Id: <20201028074221.29326-8-kurt@linutronix.de>
In-Reply-To: <20201028074221.29326-1-kurt@linutronix.de>
References: <20201028074221.29326-1-kurt@linutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hirschmann is building devices for automation and networking. Add them to the
vendor prefixes.

Signed-off-by: Kurt Kanzenbach <kurt@linutronix.de>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Acked-by: Rob Herring <robh@kernel.org>
---
 Documentation/devicetree/bindings/vendor-prefixes.yaml | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/Documentation/devicetree/bindings/vendor-prefixes.yaml b/Documentation/devicetree/bindings/vendor-prefixes.yaml
index ad38504f4358..a157bc50be6c 100644
--- a/Documentation/devicetree/bindings/vendor-prefixes.yaml
+++ b/Documentation/devicetree/bindings/vendor-prefixes.yaml
@@ -439,6 +439,8 @@ patternProperties:
     description: HiDeep Inc.
   "^himax,.*":
     description: Himax Technologies, Inc.
+  "^hirschmann,.*":
+    description: Hirschmann Automation and Control GmbH
   "^hisilicon,.*":
     description: Hisilicon Limited.
   "^hit,.*":
-- 
2.20.1

