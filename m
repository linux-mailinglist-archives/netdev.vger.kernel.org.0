Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4FDBB2B7DBB
	for <lists+netdev@lfdr.de>; Wed, 18 Nov 2020 13:43:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726523AbgKRMmk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Nov 2020 07:42:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726136AbgKRMmk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Nov 2020 07:42:40 -0500
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B184C0613D4;
        Wed, 18 Nov 2020 04:42:39 -0800 (PST)
Received: by mail-pg1-x544.google.com with SMTP id j19so1117791pgg.5;
        Wed, 18 Nov 2020 04:42:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=BcnYGj+C/9R8wBRz1/UDdUpVkNJlS0bCdBKP8JiMj4M=;
        b=gBU34nZNaEJsbA4j0zlKy7MXrpRKsPO/m1CuJmc/Oy7Ss49WbVYVYVXYEPCVUAa3v4
         j0sTMgOHPCikUYSKBI3dpohhuj3TFpLs9Y83C2z6YuBKPnY6uM01eDKVw8xH9Rb+fqsd
         jOJNmOC3PBufxsdSlphzIpoUc1hMs1YDjL3XZr7Y3uK5jtojwqSCJN6vhYq1M7C/fFl2
         WjU/LHn2IrA5MJ0+/TIanLXRFFaHBx0xaU8+0CZuwPZMz7L2Sgv9SLdvCLGB5MMg2+/9
         iZFLySIy+Id4t+/DKbbNPhdvOWiCGGWAMWFR+NF5ohZMbCAuR/j6BF8OgYfxqrtMJ5Zg
         WGxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=BcnYGj+C/9R8wBRz1/UDdUpVkNJlS0bCdBKP8JiMj4M=;
        b=R0fHwNc1ZvN+LnLEI7ubFB8pCHAy3UAxL2e6dsR5ebYisqA7UYk8rtnpMqcSGIeB1Q
         ry7OjlGzr0MaMU2SAzgYTGOriez+97AjRF8UUG/RAjETHU85ff6HeCVclB9yJOoNjEU2
         FrlvYp0uOMDBKq8Blp63DPVbFe8KG8c2e4puU6azi4nqS+aRa1Pd+HK9aC4/+DmFA9Cj
         53YP7C8KKJzrY6Yr4Lskpz5ueo88Eb7upWm/GNe7PEnEWO9rev+fjWFO0RG56zqkuXX1
         2rnNr14CQJ0FFKktFfRDfo78UpprCRxbFEtrvrVKxkaiWTxfUG7cmBJHQfUMXSDkBbGN
         0DQg==
X-Gm-Message-State: AOAM533EaaVXIQ2e5+yOPgpOsSJ5rQ5bRivzRwJWxApVhgWeY5lLvg7l
        4XpGzqUvM7PMOXCiyUmR8Rs=
X-Google-Smtp-Source: ABdhPJw1dgjFEQHz6gwvPa9vls9TAYCnMtcRs2kjywi/VkRMNuH54a+eQqStWSUHFMQFZ8H5VjsgVA==
X-Received: by 2002:a62:445:0:b029:196:61fc:2756 with SMTP id 66-20020a6204450000b029019661fc2756mr4473224pfe.12.1605703358664;
        Wed, 18 Nov 2020 04:42:38 -0800 (PST)
Received: from shane-XPS-13-9380.hsd1.ca.comcast.net ([2601:646:8800:1c00:d3e8:9066:8d33:b89c])
        by smtp.gmail.com with ESMTPSA id cu1sm2444519pjb.6.2020.11.18.04.42.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Nov 2020 04:42:38 -0800 (PST)
From:   Xie He <xie.he.0141@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Stephen Rothwell <sfr@canb.auug.org.au>
Cc:     Xie He <xie.he.0141@gmail.com>
Subject: [PATCH net-next] Documentation: Remove the deleted "framerelay" document from the index
Date:   Wed, 18 Nov 2020 04:42:26 -0800
Message-Id: <20201118124226.15588-1-xie.he.0141@gmail.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

commit f73659192b0b ("net: wan: Delete the DLCI / SDLA drivers")
deleted "Documentation/networking/framerelay.rst". However, it is still
referenced in "Documentation/networking/index.rst". We need to remove the
reference, too.

Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Xie He <xie.he.0141@gmail.com>
---
 Documentation/networking/index.rst | 1 -
 1 file changed, 1 deletion(-)

diff --git a/Documentation/networking/index.rst b/Documentation/networking/index.rst
index 70c71c9206e2..bc6020c945c4 100644
--- a/Documentation/networking/index.rst
+++ b/Documentation/networking/index.rst
@@ -52,7 +52,6 @@ Contents:
    eql
    fib_trie
    filter
-   framerelay
    generic-hdlc
    generic_netlink
    gen_stats
-- 
2.27.0

