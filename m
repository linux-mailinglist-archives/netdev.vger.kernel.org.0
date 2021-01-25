Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 02F18303430
	for <lists+netdev@lfdr.de>; Tue, 26 Jan 2021 06:21:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730499AbhAZFSq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jan 2021 00:18:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730006AbhAYPgH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Jan 2021 10:36:07 -0500
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA59EC061226;
        Mon, 25 Jan 2021 07:23:20 -0800 (PST)
Received: by mail-wr1-x42f.google.com with SMTP id d16so12338230wro.11;
        Mon, 25 Jan 2021 07:23:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=/tGkcqmhsn9CH2w55SDFq0iWv5ul//RuUKfZo0AIfJg=;
        b=HnHOkdT1DhgRrkY8rKkFowRSqjP4WIjbOC7Gr1OxgfxKF0C/1wqRnl1LEzemX8WDKT
         KjGGdJA9L0zON2nYPsLmRovk0XazESNve4EV9b+Bm/zmi5VhTdVAcPDEE+ruKrMsVny+
         T/pAYsB3OqgujebXrkhiVCIEuyScUrkpFdOsBH5EVwWpLW4nruf/QO6kbOY9wBc7T0yT
         en0CPipnxRTh6Eq4dU2YZx2Xtcy4lPy+ZRgD+kjB4Qrrcej/T993RnIk54sm6oMeS42o
         a+Exro6v2ntvYrq7a2Y7yyMxB+ZmElJMuiQVz1fVTBuaLtAGb7I+Qqn9V7ojQYGrvRQd
         17Gg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=/tGkcqmhsn9CH2w55SDFq0iWv5ul//RuUKfZo0AIfJg=;
        b=mLqZZnNgErTFm/hHK7J0yshc6tEVpf8A2Eckf6dr36hjNi1Xq2g6O02eObZcgYU39W
         IaRvibN9+odaDfqMd6FlUsjVHJ3wQhVypBiwZEo8FvBnFbGzD4lXrRVV66nVkGkGjtJQ
         ZbIZ5rl8DL+PNdOhnQNO5cjeTZWan17BzCckXZAyhuLMVY8EnBHktSg3qYdS0ZKSm0M0
         AiPclL1QGP41xWCqYUSHk2zzDUZDztbToLUpB81kne44tF/ni1T3DYiCLgnsiSbvfFNT
         WNSl+ypsyiYuXAdMkMYeBC1+SulyOooVBx/m+T8jNmvYRr/vO6RkzX2YqMprpGwbPx/Z
         2jVQ==
X-Gm-Message-State: AOAM5329oUGOq2LdvbcQUxTk6xqOw0Hkv7YMATukPVl/Q5W27Q8TnwKY
        GTONPPBJdtpaJwHXB1ASl+w=
X-Google-Smtp-Source: ABdhPJyI02B9YvkJbG2iUp+OLQYdbcmGCYVgEgNwtD+Atj06XYHgnMluRL8L0x0CKHacE30e4DAV4Q==
X-Received: by 2002:adf:e88f:: with SMTP id d15mr1556733wrm.17.1611588199706;
        Mon, 25 Jan 2021 07:23:19 -0800 (PST)
Received: from LABNL-ITC-SW01.tmt.telital.com (static-82-85-31-68.clienti.tiscali.it. [82.85.31.68])
        by smtp.gmail.com with ESMTPSA id l84sm13071307wmf.17.2021.01.25.07.23.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Jan 2021 07:23:19 -0800 (PST)
From:   Daniele Palmas <dnlplm@gmail.com>
To:     =?UTF-8?q?Bj=C3=B8rn=20Mork?= <bjorn@mork.no>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, linux-usb@vger.kernel.org,
        Aleksander Morgado <aleksander@aleksander.es>,
        Daniele Palmas <dnlplm@gmail.com>
Subject: [PATCH net-next 2/2] net: qmi_wwan: document qmap/mux_id sysfs file
Date:   Mon, 25 Jan 2021 16:22:35 +0100
Message-Id: <20210125152235.2942-3-dnlplm@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210125152235.2942-1-dnlplm@gmail.com>
References: <20210125152235.2942-1-dnlplm@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Document qmap/mux_id sysfs file showing qmimux interface id

Signed-off-by: Daniele Palmas <dnlplm@gmail.com>
---
 Documentation/ABI/testing/sysfs-class-net-qmi | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/Documentation/ABI/testing/sysfs-class-net-qmi b/Documentation/ABI/testing/sysfs-class-net-qmi
index c310db4ccbc2..ed79f5893421 100644
--- a/Documentation/ABI/testing/sysfs-class-net-qmi
+++ b/Documentation/ABI/testing/sysfs-class-net-qmi
@@ -48,3 +48,13 @@ Description:
 
 		Write a number ranging from 1 to 254 to delete a previously
 		created qmap mux based network device.
+
+What:		/sys/class/net/<qmimux iface>/qmap/mux_id
+Date:		January 2021
+KernelVersion:	5.12
+Contact:	Daniele Palmas <dnlplm@gmail.com>
+Description:
+		Unsigned integer
+
+		Indicates the mux id associated to the qmimux network interface
+		during its creation.
-- 
2.17.1

