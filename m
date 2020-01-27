Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C52F114A152
	for <lists+netdev@lfdr.de>; Mon, 27 Jan 2020 10:57:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729694AbgA0J5c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jan 2020 04:57:32 -0500
Received: from mail-pf1-f182.google.com ([209.85.210.182]:33116 "EHLO
        mail-pf1-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729269AbgA0J5b (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jan 2020 04:57:31 -0500
Received: by mail-pf1-f182.google.com with SMTP id n7so4652487pfn.0
        for <netdev@vger.kernel.org>; Mon, 27 Jan 2020 01:57:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=1N0TrAtPT93RkS/6BfJQHECG6tNTwBP1gca2/bhge+4=;
        b=B7fpfEiq3+CWMWaSBc0lllJyKLVxzL/9CVcRktwGw+Wxnynqy1fxDO+BWqGaz57IcA
         SaceXo1jzPtD+QK3LlbLs4BJ1WdE4blQ9842wp78O5NHw77zfhSXV3w6+O7rp7L2/m2N
         87ZdnJt11UTMHgYEQI4I51vh12ytm+ME245i8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=1N0TrAtPT93RkS/6BfJQHECG6tNTwBP1gca2/bhge+4=;
        b=WBAJlXxsBlGYlD25X464QY9G3JWNPDQv8dSSKEgk4NkGV8/3HB0iaJHzrf04iJZ5dw
         JKcbv287BPvywOIdKDYHjBOZm8SrT83/wmq9QF/PfN1j8ldZmFrCAbTs8KLBsrtdMJoB
         9soEZce/QksoetNvEiynJ/zu+WzyVPT6m9aI19e2i6bist/wj41tdEt7k6fgQ12wASN1
         MRH1ba381/45AY1KC7TPbYThypALoQr4X2gaPD6/uWin+37s79iW2whTzn0ucZDvkXIZ
         h4jo/UrvMk8F7yh6TLBpg3LZ2nhyAqtd/7QORwHpGRPryIL8/JnriSdJcn+X1GtiFJjd
         k0eg==
X-Gm-Message-State: APjAAAUubpP8EY6xI+tzDQUWYdj8l1CUwr71jaF83PuAGp3t4ZBeHa+u
        Rn2PBRfY5S1jMETNTqtzjDF0Ig==
X-Google-Smtp-Source: APXvYqx4yHgrqBJzaqUqWfUgOwHlOaBGMS3kgiTH8fHj4nRD7xXLPbKvNB40x97Y0nMVypZFnnSpNA==
X-Received: by 2002:aa7:9a96:: with SMTP id w22mr3854497pfi.210.1580119050720;
        Mon, 27 Jan 2020 01:57:30 -0800 (PST)
Received: from localhost.swdvt.lab.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id r3sm15232594pfg.145.2020.01.27.01.57.28
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 27 Jan 2020 01:57:30 -0800 (PST)
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org,
        Vasundhara Volam <vasundhara-v.volam@broadcom.com>,
        Jiri Pirko <jiri@mellanox.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next v2 15/15] devlink: document devlink info versions reported by bnxt_en driver
Date:   Mon, 27 Jan 2020 04:56:27 -0500
Message-Id: <1580118987-30052-16-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1580118987-30052-1-git-send-email-michael.chan@broadcom.com>
References: <1580118987-30052-1-git-send-email-michael.chan@broadcom.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vasundhara Volam <vasundhara-v.volam@broadcom.com>

Add the set of info versions reported by bnxt_en driver, including
a description of what the version represents, and what modes (fixed,
running, stored) it reports.

v2: Use fw.psid.

Cc: Jiri Pirko <jiri@mellanox.com>
Cc: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Vasundhara Volam <vasundhara-v.volam@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
---
 Documentation/networking/devlink/bnxt.rst | 33 +++++++++++++++++++++++++++++++
 1 file changed, 33 insertions(+)

diff --git a/Documentation/networking/devlink/bnxt.rst b/Documentation/networking/devlink/bnxt.rst
index 79e746d..82ef9ec 100644
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
+   * - ``fw.psid``
+     - stored, running
+     - Firmware parameter set version of the board
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

