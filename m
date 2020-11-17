Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 519662B5604
	for <lists+netdev@lfdr.de>; Tue, 17 Nov 2020 02:13:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731686AbgKQBKA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Nov 2020 20:10:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728779AbgKQBJ7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Nov 2020 20:09:59 -0500
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B115C0613CF;
        Mon, 16 Nov 2020 17:09:59 -0800 (PST)
Received: by mail-pg1-x544.google.com with SMTP id f18so14804698pgi.8;
        Mon, 16 Nov 2020 17:09:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=tLK4An+hDGibqk+F+KB9Iylic4mHms0AyKGZoLHI+Fo=;
        b=W4EdQQK5c99k1YHeZ5PdPfwRC8Gpa/e69373mXPobeW92VK94XgaPhJ7Lia/01VVpc
         +C0O5aKlrRsUwaAmIYSbEBPt+X3Dd1EW8chADG+6RbSkyZZJB3d4uWi7VD7mPpssPfdq
         QEGa04fY2BH2CBBdtQWEIs03StolYUB2a6rhJBSOGPn1w1ld7qLyGDz9O2ZV0BrnMpY7
         3sCAu4LQeWCztXrLpGgYf/ovvJfQpg+i4FKVpraBdG9pY1d7Im/tfrUXaG3IfczRfjeb
         7ICS9g3uSaYwQ64BQFlC0dZ964Cs76THuj14LmY/CBxQREHuttauSlLHmyiRnHoVrOL7
         TZXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=tLK4An+hDGibqk+F+KB9Iylic4mHms0AyKGZoLHI+Fo=;
        b=makJvdceBAlSdGi6B8SadMW7GSw2ZqUO3RnN0iiW7VHWrdtgtQu1nwuHEM31eTcAXA
         6REnwb/gwsIWQEzAv4tcPEK2mEWEsPEmJ4WWdPZcyrZhX+yWHaeUJjZJe4fGVTjBV2n7
         IR7D/jp0O2GMfiLHdERnWTtvypZeUG+IXLP6h38pOs+M3i6eQTwQP5EAh1fF8wKCCIrD
         ANY8kxefig31p8BQ28bTvib2WACkm2LVc9LOJtOvvV1Z+Xs7rb37etEAGeqRAad2y8V4
         tcpvf0Y9417mOVz8covDNIO93IcmECKAVvZCa3/MnmgYMnHkEdHlI63dpCPlX1IHZrd7
         8vhQ==
X-Gm-Message-State: AOAM530iT2KDzBfD9fJnt2PY/ewbX/xQtzG5D70eT/E0V9LkCDqDJHxW
        hYOzlw8ZfRdt6M7wijzn15M=
X-Google-Smtp-Source: ABdhPJwKqCZdq0GrtoR6CKHJ9lffDESA4ZjLWcy9Axn4FuX/WQCGOH1oxy+fII7QPTvqfsbwnQJZcg==
X-Received: by 2002:a63:441c:: with SMTP id r28mr1581268pga.184.1605575398722;
        Mon, 16 Nov 2020 17:09:58 -0800 (PST)
Received: from taoren-ubuntu-R90MNF91.thefacebook.com (c-73-252-146-110.hsd1.ca.comcast.net. [73.252.146.110])
        by smtp.gmail.com with ESMTPSA id m23sm7362091pfo.136.2020.11.16.17.09.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Nov 2020 17:09:58 -0800 (PST)
From:   rentao.bupt@gmail.com
To:     Jean Delvare <jdelvare@suse.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Jonathan Corbet <corbet@lwn.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        linux-hwmon@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, openbmc@lists.ozlabs.org, taoren@fb.com,
        mikechoi@fb.com
Cc:     Tao Ren <rentao.bupt@gmail.com>
Subject: [PATCH 2/2] docs: hwmon: Document max127 driver
Date:   Mon, 16 Nov 2020 17:09:44 -0800
Message-Id: <20201117010944.28457-3-rentao.bupt@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201117010944.28457-1-rentao.bupt@gmail.com>
References: <20201117010944.28457-1-rentao.bupt@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tao Ren <rentao.bupt@gmail.com>

Add documentation for max127 hardware monitoring driver.

Signed-off-by: Tao Ren <rentao.bupt@gmail.com>
---
 Documentation/hwmon/index.rst  |  1 +
 Documentation/hwmon/max127.rst | 43 ++++++++++++++++++++++++++++++++++
 2 files changed, 44 insertions(+)
 create mode 100644 Documentation/hwmon/max127.rst

diff --git a/Documentation/hwmon/index.rst b/Documentation/hwmon/index.rst
index 408760d13813..0a07b6000c20 100644
--- a/Documentation/hwmon/index.rst
+++ b/Documentation/hwmon/index.rst
@@ -111,6 +111,7 @@ Hardware Monitoring Kernel Drivers
    ltc4245
    ltc4260
    ltc4261
+   max127
    max16064
    max16065
    max1619
diff --git a/Documentation/hwmon/max127.rst b/Documentation/hwmon/max127.rst
new file mode 100644
index 000000000000..e50225a61c1a
--- /dev/null
+++ b/Documentation/hwmon/max127.rst
@@ -0,0 +1,43 @@
+.. SPDX-License-Identifier: GPL-2.0-or-later
+
+Kernel driver max127
+====================
+
+Author:
+
+  * Tao Ren <rentao.bupt@gmail.com>
+
+Supported chips:
+
+  * Maxim MAX127
+
+    Prefix: 'max127'
+
+    Datasheet: https://datasheets.maximintegrated.com/en/ds/MAX127-MAX128.pdf
+
+Description
+-----------
+
+The MAX127 is a multirange, 12-bit data acquisition system (DAS) providing
+8 analog input channels that are independently software programmable for
+a variety of ranges. The available ranges are {0,5V}, {0,10V}, {-5,5V}
+and {-10,10V}.
+
+The MAX127 features a 2-wire, I2C-compatible serial interface that allows
+communication among multiple devices using SDA and SCL lines.
+
+Sysfs interface
+---------------
+
+  ============== ==============================================================
+  in[0-7]_input  The conversion value for the corresponding channel.
+		 RO
+
+  in[0-7]_min    The lower limit (in Volt) for the corresponding channel.
+		 For the MAX127, it will be adjusted to -10, -5, or 0.
+		 RW
+
+  in[0-7]_max    The higher limit (in Volt) for the corresponding channel.
+		 For the MAX127, it will be adjusted to 0, 5, or 10.
+		 RW
+  ============== ==============================================================
-- 
2.17.1

