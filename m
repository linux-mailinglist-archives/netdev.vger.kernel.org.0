Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CBC6C371799
	for <lists+netdev@lfdr.de>; Mon,  3 May 2021 17:11:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230256AbhECPL4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 May 2021 11:11:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229717AbhECPL4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 May 2021 11:11:56 -0400
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F0E9C06174A
        for <netdev@vger.kernel.org>; Mon,  3 May 2021 08:11:03 -0700 (PDT)
Received: by mail-ej1-x634.google.com with SMTP id b25so8403432eju.5
        for <netdev@vger.kernel.org>; Mon, 03 May 2021 08:11:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=4+ew7dZb9FMAVqtXeVf7poHhKtI7f056i1LgA/myspo=;
        b=kE1b4bFJu4J4wsmLxPPyXekwIoNGcOe3dIgvcqel++88WYz0TR5J9rgvGn9PTRQ0zG
         VDeWQ1lTOuy1ZVMavhNr6S7goKlfNqs29DWaYWhaCom671bvlj9DtuT9OPpr4JPzbyJU
         itAQHdy1zSKd1bY5MZwvGzf48Wz6X29YDB62qTawGlkFr/MFU3/EW7Si+vCy/zY0wG6n
         XLeB6jdeAukBSfgl+O6VRstuvLYsyk80l5vlc8+1I+YDcfiG6bFoVZnl7MPAhyToOeeg
         yjTypAdWs7HVRPUwmkGJg2hTUNC/mEd+kXRqPSTw0bz6v4OZaPqN0ujeHChVrEKfd7V3
         TXcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=4+ew7dZb9FMAVqtXeVf7poHhKtI7f056i1LgA/myspo=;
        b=UvsheJb5zhNrTg9xP/r/fHPJ0dUX3Q8taknIqrHEiQWyB8I01e8j8G58vGf0QJC9h2
         8m1GEg7oWgK5wci0ywU3rFCqtZ9WPmc+0NtTSarmJK6Lt/X0LlvSF4C61qMIU4oQJOnI
         c4kJQrQWLsGvzXzCzO6BYfmdSnjPrZmlb+41Ai6ANbbPI5pI8MqPY7DuH4aplOFOTzaJ
         qFBgXIfx9ZTLCeDQdSRApy9dlDmVWDpDlBlEPX7Nu3vMP1eDkC21zB82hDGZXVuuVzQP
         fMxMYJdztwJwHRZVVjVT7L+O7gUAmAoY0Jnh3wk6Lrc7vdIFo1rX9CSA3huxruSVQ7jG
         e/sg==
X-Gm-Message-State: AOAM530CaFmEChxslJKQlHabyF85eL8KoknKz8xofw6K9lVSmIwDsD34
        APmJYE4SoXDlHjEoNzwR3as=
X-Google-Smtp-Source: ABdhPJxlfErqDZXNreptMO8KpddrR9I1BsDAhq2zc+sgVfLFr7tvce7y6DMj7z/Db9PWAek51ZYKzg==
X-Received: by 2002:a17:906:28cd:: with SMTP id p13mr17262790ejd.336.1620054661931;
        Mon, 03 May 2021 08:11:01 -0700 (PDT)
Received: from LABNL-ITC-SW01.tmt.telital.com (static-82-85-31-68.clienti.tiscali.it. [82.85.31.68])
        by smtp.gmail.com with ESMTPSA id r18sm11102982ejd.106.2021.05.03.08.11.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 May 2021 08:11:01 -0700 (PDT)
From:   Daniele Palmas <dnlplm@gmail.com>
To:     =?UTF-8?q?Bj=C3=B8rn=20Mork?= <bjorn@mork.no>
Cc:     Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>,
        netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Daniele Palmas <dnlplm@gmail.com>
Subject: [PATCH 1/1] Documentation: ABI: sysfs-class-net-qmi: document pass-through file
Date:   Mon,  3 May 2021 17:10:50 +0200
Message-Id: <20210503151050.2570-1-dnlplm@gmail.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add documentation for /sys/class/net/<iface>/qmi/pass_through

Signed-off-by: Daniele Palmas <dnlplm@gmail.com>
---
 Documentation/ABI/testing/sysfs-class-net-qmi | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/Documentation/ABI/testing/sysfs-class-net-qmi b/Documentation/ABI/testing/sysfs-class-net-qmi
index ed79f5893421..47e6b9732337 100644
--- a/Documentation/ABI/testing/sysfs-class-net-qmi
+++ b/Documentation/ABI/testing/sysfs-class-net-qmi
@@ -58,3 +58,19 @@ Description:
 
 		Indicates the mux id associated to the qmimux network interface
 		during its creation.
+
+What:		/sys/class/net/<iface>/qmi/pass_through
+Date:		January 2021
+KernelVersion:	5.12
+Contact:	Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>
+Description:
+		Boolean.  Default: 'N'
+
+		Set this to 'Y' to enable 'pass-through' mode, allowing packets
+		in MAP format to be passed on to the stack.
+
+		Normally the rmnet driver (CONFIG_RMNET) is then used to process
+		and demultiplex these packets.
+
+		'Pass-through' mode can be enabled when the device is in
+		'raw-ip' mode only.
-- 
2.17.1

