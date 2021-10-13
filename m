Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 914DC42CE31
	for <lists+netdev@lfdr.de>; Thu, 14 Oct 2021 00:32:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231344AbhJMWem (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Oct 2021 18:34:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231273AbhJMWeh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Oct 2021 18:34:37 -0400
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC2F5C061570
        for <netdev@vger.kernel.org>; Wed, 13 Oct 2021 15:32:33 -0700 (PDT)
Received: by mail-pf1-x42f.google.com with SMTP id m26so3765394pff.3
        for <netdev@vger.kernel.org>; Wed, 13 Oct 2021 15:32:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=K3xmyrvrabuXSa2GxlZvZmaD6t80A1dyvYqPOhLAPUM=;
        b=oH+s3TzBp80hi2+8fLk+BxUA/Lo8MJovNJJQVYkR/woOEx0/JK8jA3uz3FM/zYx/eU
         zikY9iYu9WC5mVQsEmvdZwHmPmyy8AhPIm2cTuAUXdcr5r6gYX2K+la0aJ+XpOjs0+1t
         SpuOiD2ip538ATQVM2DzFixtB5v395rFjG6PA885qMDErLt39YgLTeOBPLq87l0PzrUZ
         So/ycGq+BaIEG/VgO0Fmb532xgDTLq6g0VW2OUOvGX6DfxzN8InJqGvhqPZSv+7kO7ag
         dx4frzN0/ScZum55ixIycEc9u/zBN5zmn90nkuFKNAHduZeQH/IF75P4dYt0uY3JT1aL
         bzXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=K3xmyrvrabuXSa2GxlZvZmaD6t80A1dyvYqPOhLAPUM=;
        b=dvCPq9KpdKPDnXEbCCMeTaa3KOwgVZFDEwXjtNkge9nGx1z95m2vjZFUSVojHz7GkD
         89BRVuSu47C+85lNg+8SCbC942sfdPB81vRDyk4JibQM9uVh3h6/d4JIqbTzK7GgJSUk
         oPtm4fn1VqsSMj8LCvQWHi/YpRfy1cqmtx2TNZzi6HP7dKJx59mDG1vP4fOCrX+aV5O2
         fx0FGCw1jGLDOZLecfgUP+KXt+7dbwSeuzPogLkjft3LZrTk6ARMIBQ0LFH2yS4v2wbG
         UEIqusD1HR90+Ddg/S/digls3BdiSMiOxcZBrvsK07S342AiqLcMZPERXtMTdU9tEItP
         9V+A==
X-Gm-Message-State: AOAM533Sa+KiItujwR7Xqvz7YlgsqlEuW7gDj2NuVaxCLO0pxSSIFTuU
        MVboRNe+JftxQn37w1SEve6NAR6nahc=
X-Google-Smtp-Source: ABdhPJyusmCMK0AKn6uPpwooU95/JwT12ECQEMAz6V9wWAtpyb1pppPtecoJeDB08kJMwWDfo1daKg==
X-Received: by 2002:a05:6a00:d63:b0:44d:186d:c4c0 with SMTP id n35-20020a056a000d6300b0044d186dc4c0mr1946966pfv.47.1634164353246;
        Wed, 13 Oct 2021 15:32:33 -0700 (PDT)
Received: from localhost.localdomain ([50.39.163.188])
        by smtp.gmail.com with ESMTPSA id i2sm6546091pjt.19.2021.10.13.15.32.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Oct 2021 15:32:32 -0700 (PDT)
From:   James Prestwood <prestwoj@gmail.com>
To:     netdev@vger.kernel.org
Cc:     James Prestwood <prestwoj@gmail.com>
Subject: [PATCH 3/4] doc: networking: document arp_evict_nocarrier
Date:   Wed, 13 Oct 2021 15:27:09 -0700
Message-Id: <20211013222710.4162634-3-prestwoj@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211013222710.4162634-1-prestwoj@gmail.com>
References: <20211013222710.4162634-1-prestwoj@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Signed-off-by: James Prestwood <prestwoj@gmail.com>
---
 Documentation/networking/ip-sysctl.rst | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/Documentation/networking/ip-sysctl.rst b/Documentation/networking/ip-sysctl.rst
index c2ecc9894fd0..174d9d3ee5c2 100644
--- a/Documentation/networking/ip-sysctl.rst
+++ b/Documentation/networking/ip-sysctl.rst
@@ -1565,6 +1565,15 @@ arp_accept - BOOLEAN
 	gratuitous arp frame, the arp table will be updated regardless
 	if this setting is on or off.
 
+arp_evict_nocarrier - BOOLEAN
+	Clears the ARP cache on NOCARRIER events. This option is important for
+	wireless devices where the ARP cache should not be cleared when roaming
+	between access points on the same network. In most cases this should
+	remain as the default (1).
+
+	- 1 - (default): Clear the ARP cache on NOCARRIER events
+	- 0 - Do not clear ARP cache on NOCARRIER events
+
 mcast_solicit - INTEGER
 	The maximum number of multicast probes in INCOMPLETE state,
 	when the associated hardware address is unknown.  Defaults
-- 
2.31.1

