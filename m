Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 46F071499BE
	for <lists+netdev@lfdr.de>; Sun, 26 Jan 2020 10:04:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729305AbgAZJEB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Jan 2020 04:04:01 -0500
Received: from mail-pl1-f181.google.com ([209.85.214.181]:37755 "EHLO
        mail-pl1-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728253AbgAZJD7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Jan 2020 04:03:59 -0500
Received: by mail-pl1-f181.google.com with SMTP id c23so2633782plz.4
        for <netdev@vger.kernel.org>; Sun, 26 Jan 2020 01:03:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=aAlrNGLqGJUXgYLHYc8hZuU+35xV6eCos5KAsJeJnlk=;
        b=gP3yKzOoEADfUY7geP5z7IctRn7UXTcoHfywY2SsCLYKsg3CsUduheSzJ3otu+ACKG
         VsSg8SrodRuwQWJCjOS6I4TlrSAgDH6kHzZYjgVwFE9SU0gg+1IuU95a2CNFVpi3z/0D
         spW33e/ZZL7P9GjK1YQdi+/jOq1BR4tJh+Z9g=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=aAlrNGLqGJUXgYLHYc8hZuU+35xV6eCos5KAsJeJnlk=;
        b=GcyEnmzqX/PwCnK008Z2goghQ2Ss5GHLGGGhkoUOPx0PFPcnT8b8Mg3r9oogh7uUoT
         hshR18TBeC3O5wXvtNR3o7JLVnyroVQJum8hDy5D5Df/x4Dfg1Mrr7glE4FaZ9ysHg1m
         IHuGcRzv7wnNyuC+gQsXopOE986HaxjCJVKoZeC5nstBs+dFDw+W1Ibx+QLpioBbgH5U
         jStYa8EfHBBKwYgTaLci6WvtOl2W2EmLWMqSWySYTqyF5wQ3lGtQRztQF2jvSR4xzFKm
         C+3yaiJaz3N2M1Icn1yoAR7YHh5AvzeHNI+/lZwPJYM08An8jXonSE2NndU14PEoei5y
         qWCg==
X-Gm-Message-State: APjAAAW4Op57mlkA3sT6eYJky+IWaL5NcPMAhPTmiV4+Jvl4aFtJc9Ui
        zFTQtvzobOULrTzIBb+IaeEU1g==
X-Google-Smtp-Source: APXvYqx8lVmqlVQ0g9vAlW7+q1SXhLkhVDNQKwK12XnWkITE+hrtBypePU4Ihxd38QonqSYahjGfHg==
X-Received: by 2002:a17:902:6bcb:: with SMTP id m11mr12764340plt.10.1580029438554;
        Sun, 26 Jan 2020 01:03:58 -0800 (PST)
Received: from localhost.swdvt.lab.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id i17sm11856315pfr.67.2020.01.26.01.03.56
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 26 Jan 2020 01:03:58 -0800 (PST)
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org,
        Vasundhara Volam <vasundhara-v.volam@broadcom.com>,
        Jiri Pirko <jiri@mellanox.com>
Subject: [PATCH net-next 16/16] devlink: document devlink info versions reported by bnxt_en driver
Date:   Sun, 26 Jan 2020 04:03:10 -0500
Message-Id: <1580029390-32760-17-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1580029390-32760-1-git-send-email-michael.chan@broadcom.com>
References: <1580029390-32760-1-git-send-email-michael.chan@broadcom.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vasundhara Volam <vasundhara-v.volam@broadcom.com>

Add the set of info versions reported by bnxt_en driver, including
a description of what the version represents, and what modes (fixed,
running, stored) it reports.

Cc: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: Vasundhara Volam <vasundhara-v.volam@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
---
 Documentation/networking/devlink/bnxt.rst | 33 +++++++++++++++++++++++++++++++
 1 file changed, 33 insertions(+)

diff --git a/Documentation/networking/devlink/bnxt.rst b/Documentation/networking/devlink/bnxt.rst
index 79e746d..9048e7b 100644
--- a/Documentation/networking/devlink/bnxt.rst
+++ b/Documentation/networking/devlink/bnxt.rst
@@ -39,3 +39,36 @@ parameters.
      - Generic Routing Encapsulation (GRE) version check will be enabled in
        the device. If disabled, the device will skip the version check for
        incoming packets.
+
+Info versions
+=============
+
+The ``bnxt_en`` driver reports the following versions
+
+.. list-table:: devlink info versions implemented
+      :widths: 5 5 90
+
+   * - Name
+     - Type
+     - Description
+   * - ``asic.id``
+     - fixed
+     - ASIC design identifier
+   * - ``asic.rev``
+     - fixed
+     - ASIC design revision
+   * - ``board.nvm_cfg_ver``
+     - stored, running
+     - Non-volatile memory version of the board
+   * - ``fw``
+     - stored, running
+     - Overall board firmware version
+   * - ``fw.app``
+     - stored, running
+     - Data path firmware version
+   * - ``fw.mgmt``
+     - stored, running
+     - Management firmware version
+   * - ``fw.roce``
+     - stored, running
+     - RoCE management firmware version
-- 
2.5.1

