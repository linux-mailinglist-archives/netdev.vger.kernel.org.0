Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F0A2718E387
	for <lists+netdev@lfdr.de>; Sat, 21 Mar 2020 19:00:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728002AbgCUSA3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 21 Mar 2020 14:00:29 -0400
Received: from mail-oi1-f196.google.com ([209.85.167.196]:34002 "EHLO
        mail-oi1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727939AbgCUSA2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 21 Mar 2020 14:00:28 -0400
Received: by mail-oi1-f196.google.com with SMTP id e9so1831363oii.1;
        Sat, 21 Mar 2020 11:00:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ivkv2AjL6EXVAa1JYs7mqBfNjeboYRMwbrEQs14HIno=;
        b=XbhPjDLqCGh82zEUMZDThrIXKM7go6EERt4wwRUgHEGU7U891rzFc+8rx1jwxWr/WY
         rS/phtqOqkTNUHrk5ojBOjv/5vNPCpBT0KoeVft/J48L62wicEj7hhJQ8Rbttajorukz
         b/ZStvRxaw7GRDvzZuXtik8U00GV8gZbsG8i0OOrCDtnLdMjIInV6GIT1dwb6rel1QQN
         9EmD3cUnXfY3dv70d5u9e5g8AhsXkMqGVBFCJORy88Z7KqJKNh4vutBJi27m1Fipv27m
         3U2Oh7A/yV+qW2alfABnunrQ/RLTGpLaWXFYyS5u1z4VjA+ZyRxgf6clZCjhyR37+pjb
         EHsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :mime-version:content-transfer-encoding;
        bh=ivkv2AjL6EXVAa1JYs7mqBfNjeboYRMwbrEQs14HIno=;
        b=i4xZBW4dBJONjY+K7DV0iiC/ee7FD++3vc8pcFEm1BPedBvCOMGyUfdJaxLqFLTZJV
         Yoqt6OtvUNOyda/iKrivDwiHk6oORRzXrAF2feKXQATYkYsVI7FxEk918FrFI3r+P+49
         GAeXZ1G4YLiJwBLfE3EGWioIfORhiGFsoXGYFP6p1+6P3Q/1AMV/SFyZSbrRCWxXYeE1
         lGsQQ46Sir8/5wo35DdwZ+sc/LTda2aYBJ3RMWFp+WasH3XM8FsMjTAtYX3U7lgAgFmf
         VQElhbNDPyiIs9Cccwh3UWNjqCWaf0dRCXegaEUE7FmL3ln/cCbBECJIZPNyRDtPlZiE
         MAqw==
X-Gm-Message-State: ANhLgQ38a7deP32iTM/wRPOoJOWachuN12pEvr+8z1Dds3ZzlebGS8b0
        OzRG1PF0YV3qE+FFaxLXbGg=
X-Google-Smtp-Source: ADFU+vvd8OsdGBH2mOLpXI2e8IcKhXNKHRWEkIyD5UCURhyds+ifrpf9jikBmOCbTbWagq8VEVX+OQ==
X-Received: by 2002:aca:54ca:: with SMTP id i193mr11471900oib.163.1584813627142;
        Sat, 21 Mar 2020 11:00:27 -0700 (PDT)
Received: from localhost.localdomain (cpe-24-31-245-230.kc.res.rr.com. [24.31.245.230])
        by smtp.gmail.com with ESMTPSA id u199sm3323892oif.25.2020.03.21.11.00.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 21 Mar 2020 11:00:26 -0700 (PDT)
From:   Larry Finger <Larry.Finger@lwfinger.net>
To:     gregkh@linuxfoundation.org
Cc:     netdev@vger.kernel.org, devel@driverdev.osuosl.org,
        Larry Finger <Larry.Finger@lwfinger.net>,
        kovi <zraetn@gmail.com>, Stable <stable@vger.kernel.org>
Subject: [PATCH] staging: rtl8188eu: Add ASUS USB-N10 Nano B1 to device table
Date:   Sat, 21 Mar 2020 13:00:11 -0500
Message-Id: <20200321180011.26153-1-Larry.Finger@lwfinger.net>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The ASUS USB-N10 Nano B1 has been reported as a new RTL8188EU device.
Add it to the device tables.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Reported-by: kovi <zraetn@gmail.com>
Cc: Stable <stable@vger.kernel.org>
---
 drivers/staging/rtl8188eu/os_dep/usb_intf.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/staging/rtl8188eu/os_dep/usb_intf.c b/drivers/staging/rtl8188eu/os_dep/usb_intf.c
index b5d42f411dd8..b7f65026dba8 100644
--- a/drivers/staging/rtl8188eu/os_dep/usb_intf.c
+++ b/drivers/staging/rtl8188eu/os_dep/usb_intf.c
@@ -32,6 +32,7 @@ static const struct usb_device_id rtw_usb_id_tbl[] = {
 	/****** 8188EUS ********/
 	{USB_DEVICE(0x056e, 0x4008)}, /* Elecom WDC-150SU2M */
 	{USB_DEVICE(0x07b8, 0x8179)}, /* Abocom - Abocom */
+	{USB_DEVICE(0x0B05, 0x18F0)}, /* ASUS USB-N10 Nano B1 */
 	{USB_DEVICE(0x2001, 0x330F)}, /* DLink DWA-125 REV D1 */
 	{USB_DEVICE(0x2001, 0x3310)}, /* Dlink DWA-123 REV D1 */
 	{USB_DEVICE(0x2001, 0x3311)}, /* DLink GO-USB-N150 REV B1 */
-- 
2.25.1

