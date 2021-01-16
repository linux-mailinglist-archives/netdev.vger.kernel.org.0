Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 087492F8DFF
	for <lists+netdev@lfdr.de>; Sat, 16 Jan 2021 18:16:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728330AbhAPRKd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 Jan 2021 12:10:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728256AbhAPRK0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 16 Jan 2021 12:10:26 -0500
Received: from mail-wm1-x329.google.com (mail-wm1-x329.google.com [IPv6:2a00:1450:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0024AC061388;
        Sat, 16 Jan 2021 07:05:28 -0800 (PST)
Received: by mail-wm1-x329.google.com with SMTP id g10so10098111wmh.2;
        Sat, 16 Jan 2021 07:05:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=DZLVsLwB5k35ns7zYrJfmPC7wohrTEilCe/nrtCaIos=;
        b=mdF7Lcv1Qsj0qki+yGN+ZMvZUIzeogvlFBN3jT3HMVH2P4zGfcp4NeVeiHp+HEZZ0D
         IKjY9DelmAmuH6F3e7pBF+k8cNnWD8soPicZcMjHuN7/xPBsljHal9bsxYdIJZIIY/fG
         HcpvylPeg2/DuY310EqRrfTK8EiPua3jLUromeIIxVfhmNFMxmneHM424bGLHF2El4qz
         fU8YPbJvJrBI+qkEML2I997Ag1JKCG58QFYWCNGCtoxp93Q5ZL+NTs/LO81Lbpxcb20e
         0isftoNA88QE+4XLjD3no8lKloHL8JUdhMuzU94atSxl/4nZNancrBE1i5QHDbnvpm69
         ZOzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=DZLVsLwB5k35ns7zYrJfmPC7wohrTEilCe/nrtCaIos=;
        b=QeKBpU2xPzxVMRTz7zahw0GqpzfgC80UwxLH7Pbtpdo2mWANtJ3l9gf/z+XkGHw3/Y
         ljw43KbI7kmNte/ru2BtjKD1EUU5xUn78zpcNS+KpeX3CyyyLidS57TSeuejP641ko2V
         zMRq1xymkKm0kZATQB7t9gJXgTlvjljbKPGGilOqzpgTvAl5854CrnZL/MQAJ8uLH7v7
         qI95I6EQjTDRW+JNcCayRVqs41NQAwTudiSl0h2TP0bOd133ZU6ZD8KalhaXoyRhzUp8
         OnIYWF8HG+8emerHOF3xI445aYwCNokoalcx2JPdA529fKXjDCUhaD1C/bjNXcylDdB3
         ot4Q==
X-Gm-Message-State: AOAM530R4l3Ijmt+Cx9qy4mdY4H2yxd21s5x/wAQKyZZrSf/IMekc1P0
        3LANsnf2th/4ws4KZsd9gy0=
X-Google-Smtp-Source: ABdhPJxQAvj6kOWZC0WaVg5MqIG+8t3an335uYZ8IsA/Sff+21gUj42t5TDr7z/f6Ql38fca5Uixgw==
X-Received: by 2002:a1c:24c4:: with SMTP id k187mr13816365wmk.14.1610809527727;
        Sat, 16 Jan 2021 07:05:27 -0800 (PST)
Received: from debian.vlc ([170.253.51.130])
        by smtp.gmail.com with ESMTPSA id f68sm5494887wmf.6.2021.01.16.07.05.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 16 Jan 2021 07:05:27 -0800 (PST)
From:   Alejandro Colomar <alx.manpages@gmail.com>
To:     mtk.manpages@gmail.com
Cc:     =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>,
        linux-man@vger.kernel.org, netdev@vger.kernel.org,
        Alejandro Colomar <alx.manpages@gmail.com>
Subject: [PATCH] rtnetlink.7: Remove IPv4 from description
Date:   Sat, 16 Jan 2021 16:04:35 +0100
Message-Id: <20210116150434.7938-1-alx.manpages@gmail.com>
X-Mailer: git-send-email 2.30.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Pali Rohár <pali@kernel.org>

rtnetlink is not only used for IPv4

Signed-off-by: Pali Rohár <pali@kernel.org>
Signed-off-by: Alejandro Colomar <alx.manpages@gmail.com>
---
 man7/rtnetlink.7 | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/man7/rtnetlink.7 b/man7/rtnetlink.7
index cd6809320..aec005ff9 100644
--- a/man7/rtnetlink.7
+++ b/man7/rtnetlink.7
@@ -13,7 +13,7 @@
 .\"
 .TH RTNETLINK  7 2020-06-09 "Linux" "Linux Programmer's Manual"
 .SH NAME
-rtnetlink \- Linux IPv4 routing socket
+rtnetlink \- Linux routing socket
 .SH SYNOPSIS
 .nf
 .B #include <asm/types.h>
-- 
2.30.0

