Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1DFEB251CBF
	for <lists+netdev@lfdr.de>; Tue, 25 Aug 2020 17:59:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726818AbgHYP7A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Aug 2020 11:59:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726466AbgHYP67 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Aug 2020 11:58:59 -0400
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EAEC3C061574;
        Tue, 25 Aug 2020 08:58:58 -0700 (PDT)
Received: by mail-wr1-x430.google.com with SMTP id b17so12461294wru.2;
        Tue, 25 Aug 2020 08:58:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=uc+i0gWQ7QGFfIc1FEZg9eNWGBKxWPtFWURbOx3qDRs=;
        b=VGI3XJusG7DtDltydX+p+GzQ5RPWGMc1T1ToEdnMnFchvPZQ3hNqQJyzZXejriIevw
         hK/hOEsqvPo9CqNq5xjLXmUF/Lq+FYVV8cCkZNDTXXjsiuep9u07mK1dbVu64ZCl4i/y
         hU7vcT/ErbkDhi8L+hWUu8Krk2xRoktNjGH2j/1ew87GNEk/l2I3mBETh0I7uMoYHRfA
         0ICvCAZLnd/b9Ztb31msjaxO5SwIKNejh3SL18kQZhDeiG8IMcYexqxsLs9WPnMIYZd4
         C5Uzkj/Wi++Jk9wGeEAN0HZVT+yGQQaM9PTfj+CRPgrkB7/bFOpALaSUcIsNdNGxRyS0
         gIvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=uc+i0gWQ7QGFfIc1FEZg9eNWGBKxWPtFWURbOx3qDRs=;
        b=X/B49lI4Rf6YfR0OfY/AHfIiZIE5NNoEy+GPjkIxIeOsujridcCV/p1sGHMCJfDSiW
         7RxgjgMgKmJTBK+mylVKGaOGKdbFwOveyDW3yUx8ldgMFReLYCjd1oulJ9/OIIiiHvop
         o7S0kCYdkVwiXCbB4B07GELjkCq7wsMWZIzvwjj8znw56oycfMvS9QbpZT4nDSBIfbd5
         0AWVLOzRVEzEg5eT+VvebQe/VQpVAT4TdZBSYwF5VI8Djn/lXcE1Y433grmzYyIA6OxO
         Xfr1opVJxVDdoJoyKQX/IZHhnbC1S50iskCtRnc6haaSmC9ZZ7BPvHC2zVufFlhAUn0P
         kM5w==
X-Gm-Message-State: AOAM531Sup77c/vtO0yqEVAiTtXQO/wPmIVSqHnIPNJouHJERT/XJueI
        txVbxe/zi5xCFD20PEL5gYlkxlKQlsDae1QT
X-Google-Smtp-Source: ABdhPJy5CtEGeRW1UBmrR30rISXoR9TcOxm8quyf9iUBq3d4PfZjDJ8RF7ddO2JxnjDRZy14uWvLDQ==
X-Received: by 2002:a5d:4850:: with SMTP id n16mr8439374wrs.92.1598371136604;
        Tue, 25 Aug 2020 08:58:56 -0700 (PDT)
Received: from ubuntu18_1.cisco.com ([173.38.220.45])
        by smtp.gmail.com with ESMTPSA id r3sm28198987wro.1.2020.08.25.08.58.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Aug 2020 08:58:55 -0700 (PDT)
From:   Ahmed Abdelsalam <ahabdels@gmail.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>, netdev@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     ahabdels@gmail.com, andrea.mayer@uniroma2.it
Subject: [net-next v5 2/2] seg6: Add documentation for seg6_inherit_inner_ipv4_dscp sysctl
Date:   Tue, 25 Aug 2020 15:58:40 +0000
Message-Id: <20200825155840.1070-1-ahabdels@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch adds a documentation for seg6_inherit_inner_ipv4_dscp
sysctl into Documentation/networking/ip-sysctl.rst

Signed-off-by: Ahmed Abdelsalam <ahabdels@gmail.com>
---
 Documentation/networking/ip-sysctl.rst | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/Documentation/networking/ip-sysctl.rst b/Documentation/networking/ip-sysctl.rst
index 837d51f9e1fa..9dacdebeafc5 100644
--- a/Documentation/networking/ip-sysctl.rst
+++ b/Documentation/networking/ip-sysctl.rst
@@ -1799,6 +1799,11 @@ seg6_flowlabel - INTEGER
 
 	Default is 0.
 
+seg6_inherit_inner_ipv4_dscp - BOOLEAN
+	Enable the SRv6 encapsulation to inherit the DSCP value of the inner IPv4 packet.
+
+	Default: FALSE (Do not inherit DSCP)
+
 ``conf/default/*``:
 	Change the interface-specific default settings.
 
-- 
2.17.1

