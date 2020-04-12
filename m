Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (unknown [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6A50E1A6122
	for <lists+netdev@lfdr.de>; Mon, 13 Apr 2020 01:51:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726697AbgDLXvI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 Apr 2020 19:51:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.18]:43006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726185AbgDLXvI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 12 Apr 2020 19:51:08 -0400
Received: from mail-wm1-x344.google.com (mail-wm1-x344.google.com [IPv6:2a00:1450:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9BFACC014A42
        for <netdev@vger.kernel.org>; Sun, 12 Apr 2020 16:51:08 -0700 (PDT)
Received: by mail-wm1-x344.google.com with SMTP id a201so8116226wme.1
        for <netdev@vger.kernel.org>; Sun, 12 Apr 2020 16:51:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=OrR8mrUnW362lQdb4We2NkPRtio4Wjh0QoUND2FRYh8=;
        b=oea72BcuwtbP9qvf23s83IczYrxSEKTYkiTfTsa/JVz3pmhX4yse2sjhhsIgxlZu9A
         35cs0hErp+nJnXAGlk3flrWu/B02kfTkaC1elD+mzrcRF6XoZGfRIvDVaPjTP19wFiBr
         7Jxzs3Yr5rhl0NHXPfNrr3m2Gcnv7B/8supqjgPhqCe3/+KTQs0h5NPmJss6/aHInFJJ
         XdGvUSsXoHT6OUfxO40pQftZFNJ8mdVw+Tu5dmjbT6PFjt9cPfvy4WEYPmjbJ+Arzk1q
         q7eCkmjqaYdLXp550PxIJfWE1Bdj9RTmvMqIx9/mwsm4lE8IPqnSsHvbOkpR1r/YCw2c
         weuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=OrR8mrUnW362lQdb4We2NkPRtio4Wjh0QoUND2FRYh8=;
        b=nMvvO5Cy+lF0g4I9HjwRukKLI1U+Z743MMGuilDmdwtJA2BKT6I4xumO4FnuNMaptw
         qnjgUGKdj/lRsfARjDk6sKYjsrgBqz19PXNufjCJFwuKIURv1Osp4s37TvgdBnAdUADD
         w3/IDY0ULmEoJzn+raZJ5eRdQ88af8uKwrXFqbZ02zKyUlY9oheJQSi9KGhL3hOkQEJg
         mSpb6sC6d3Oz4DfmP8eXFuUQrwhORgc5YRYZOwxsudUge6X4kDSczVgdvMwq5CcmlOBU
         +98a+aQNRT8qt3a05TrU47lg7V6NVv0m8lVac9QcLHVe0uB0hnxheymtPtcU+cKnW+ad
         MN2w==
X-Gm-Message-State: AGi0PuaVZbJ6/YEQLZMQeewQSdp55Js+duRdNaReO2Srpr8tdllpx+Si
        WmWoSL1HDfAiAlXeTvu35kNNGfcs
X-Google-Smtp-Source: APiQypI9Qq5GO09Aq9Rc7IFBUShFyOy4BMU50ijU03Lk6avFrOf5vldITWPlOfZeNNk+s/rlXUn8LA==
X-Received: by 2002:a7b:cb51:: with SMTP id v17mr15732971wmj.164.1586735466755;
        Sun, 12 Apr 2020 16:51:06 -0700 (PDT)
Received: from localhost ([2a01:e35:2f01:a61:fc49:14b:88c:2a9c])
        by smtp.gmail.com with ESMTPSA id j11sm12775829wrt.14.2020.04.12.16.51.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 12 Apr 2020 16:51:05 -0700 (PDT)
From:   roucaries.bastien@gmail.com
X-Google-Original-From: rouca@debian.org
To:     netdev@vger.kernel.org
Cc:     sergei.shtylyov@cogentembedded.com,
        Stephen Hemminger <stephen@networkplumber.org>,
        =?UTF-8?q?Bastien=20Roucari=C3=A8s?= <rouca@debian.org>
Subject: [PATCH 1/6] Better documentation of mcast_to_unicast option
Date:   Mon, 13 Apr 2020 01:50:33 +0200
Message-Id: <20200412235038.377692-2-rouca@debian.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200412235038.377692-1-rouca@debian.org>
References: <20200405134859.57232-1-rouca@debian.org>
 <20200412235038.377692-1-rouca@debian.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Bastien Roucariès <rouca@debian.org>

This option is useful for Wifi bridge but need some tweak.

Document it from kernel patches documentation

Signed-off-by: Bastien Roucariès <rouca@debian.org>
---
 man/man8/bridge.8 | 26 ++++++++++++++++++++++++++
 1 file changed, 26 insertions(+)

diff --git a/man/man8/bridge.8 b/man/man8/bridge.8
index b9bd6bc5..ff6f6f37 100644
--- a/man/man8/bridge.8
+++ b/man/man8/bridge.8
@@ -383,6 +383,32 @@ there is no MDB entry. By default this flag is on.
 Controls whether a given port will replicate packets using unicast
 instead of multicast. By default this flag is off.
 
+This is done by copying the packet per host and
+changing the multicast destination MAC to a unicast one accordingly.
+
+.BR mcast_to_unicast
+works on top of the multicast snooping feature of
+the bridge. Which means unicast copies are only delivered to hosts which
+are interested in it and signalized this via IGMP/MLD reports
+previously.
+
+This feature is intended for interface types which have a more reliable
+and/or efficient way to deliver unicast packets than broadcast ones
+(e.g. WiFi).
+
+However, it should only be enabled on interfaces where no IGMPv2/MLDv1
+report suppression takes place. IGMP/MLD report suppression issue is usually
+overcome by the network daemon (supplicant) enabling AP isolation and
+by that separating all STAs.
+
+Delivery of STA-to-STA IP mulitcast is made possible again by
+enabling and utilizing the bridge hairpin mode, which considers the
+incoming port as a potential outgoing port, too (see
+.B hairpin
+option).
+Hairpin mode is performed after multicast snooping, therefore leading to
+only deliver reports to STAs running a multicast router.
+
 .TP
 .BR "neigh_suppress on " or " neigh_suppress off "
 Controls whether neigh discovery (arp and nd) proxy and suppression is
-- 
2.25.1

