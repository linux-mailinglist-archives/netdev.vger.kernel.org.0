Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF634305FCB
	for <lists+netdev@lfdr.de>; Wed, 27 Jan 2021 16:39:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233642AbhA0Phn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jan 2021 10:37:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235800AbhA0Pfi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Jan 2021 10:35:38 -0500
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3BD7C061793;
        Wed, 27 Jan 2021 07:34:57 -0800 (PST)
Received: by mail-wr1-x42c.google.com with SMTP id a1so2370219wrq.6;
        Wed, 27 Jan 2021 07:34:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=/tGkcqmhsn9CH2w55SDFq0iWv5ul//RuUKfZo0AIfJg=;
        b=nI6hC+eFt6rqAEWWJ3zfLpZVJeDPKJtH7reAeQP1NtQAuwe0PewFh1GHSG/1QTs/Wd
         /T3S38h03kJTD88uKq71v2ru512DVHbApPqiToF2O4KwQ3bwd02hrLNFGB+wM+3DI2W9
         5QgdXKtlddkkvCbGiq4tKh0JhLkMjRgWQJbEtRWVeL/tyssy78O0u9vCHB59m7qy6reC
         /42tOSAJK92ZfC+p9O7fJToEWAFauBsqCDIBhRD8/4wis47GA9dpaspaj37/0+2yhNnO
         zaeko0BR4PpvzjFaP+f3fhjKiu7Trm4oBZiSxQXRyfJkEmdDotqlscfCfgwZR3aAjrVJ
         E1gg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=/tGkcqmhsn9CH2w55SDFq0iWv5ul//RuUKfZo0AIfJg=;
        b=n7IYOxDPtkv8tFcSbwDslBe4WakNRSwvOw2gI8Ng9KfOk++GTyUbN+T/3BjeS2Fh+/
         DO4X7jTEbGWoOmmtmlayLAwkcTFqIeSgjDWkFF7WhynwPl+1kVepTqrMT7Fyigxo32gx
         E2DWN8IYuoOOdzUayQmQ0Ed4dp1z9dvGumfmHi28xmB4FzPjXRpA2Sb+ZGwn6+x07HvS
         EEtFtXrsKJX1LQDtlXQ3lrumxx+4hCYsZKmzG18dO9PBTP+lgVkLiwxgzK+RNlI+5Et8
         UvDOYtPNLMDouyYIoI31FQwJ9xXmJ7CGO1qTnU8C6YMwRzds4HrzPgWRSIfsUJmRXb/C
         IFXg==
X-Gm-Message-State: AOAM532d4tH6jJ62xJF0qxuI06egTIWvkKlKJAxc8XorICsue0AzHMFE
        3Eofqn2p9FoR37b0Xwij63Y=
X-Google-Smtp-Source: ABdhPJznInE3W+I8qFX2CdMmfN/npZnB/gkKoeKohjHxuaA+KnWF+CJXZg6/EDX2vJaq3HmdYzYfvg==
X-Received: by 2002:adf:eacc:: with SMTP id o12mr11615147wrn.202.1611761696772;
        Wed, 27 Jan 2021 07:34:56 -0800 (PST)
Received: from LABNL-ITC-SW01.tmt.telital.com (static-82-85-31-68.clienti.tiscali.it. [82.85.31.68])
        by smtp.gmail.com with ESMTPSA id m8sm3386132wrv.37.2021.01.27.07.34.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Jan 2021 07:34:56 -0800 (PST)
From:   Daniele Palmas <dnlplm@gmail.com>
To:     =?UTF-8?q?Bj=C3=B8rn=20Mork?= <bjorn@mork.no>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, linux-usb@vger.kernel.org,
        Aleksander Morgado <aleksander@aleksander.es>,
        Daniele Palmas <dnlplm@gmail.com>
Subject: [PATCH net-next v2 2/2] net: qmi_wwan: document qmap/mux_id sysfs file
Date:   Wed, 27 Jan 2021 16:34:33 +0100
Message-Id: <20210127153433.12237-3-dnlplm@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210127153433.12237-1-dnlplm@gmail.com>
References: <20210127153433.12237-1-dnlplm@gmail.com>
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

