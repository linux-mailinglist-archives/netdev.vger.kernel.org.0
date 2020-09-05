Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9BEF525E718
	for <lists+netdev@lfdr.de>; Sat,  5 Sep 2020 12:37:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728434AbgIEKhO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Sep 2020 06:37:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726597AbgIEKhN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 5 Sep 2020 06:37:13 -0400
Received: from mail-ed1-x544.google.com (mail-ed1-x544.google.com [IPv6:2a00:1450:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A716CC061244;
        Sat,  5 Sep 2020 03:37:12 -0700 (PDT)
Received: by mail-ed1-x544.google.com with SMTP id b12so8302841edz.11;
        Sat, 05 Sep 2020 03:37:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=odY6KbSbKxqDrhObNYwd42zXyBsKpopwTCHslkv93Yg=;
        b=ZBSeGqh+yeSHUuXd83cOOCh0FqhV/gbWL0FZZuwh3fcRbWKbFjQnc78qMMoGeNbDmE
         zfMWGtn1wH6hVpeDBgR4/DFdcM+AgH/kXGqCnkIWsjZHeX8kaE0O7oljQltvU3hZ+xpV
         2nlQdOtVznfq7G6lFS1OIdIHIhWiIPMwQA6f048xqe+WnT7Oxcv4jIJLV6/kGYMsqDrh
         OJoZ0p5jp22XMRQKZtyclLPAO6fraEiVvavYnlG8CmNG0G1LLPqHWuNkH+4XLzU0oD4k
         K7GAFc0nnpd1lw9FMjODkwR3F4WFiB2j9eUobIoHwy84UYGsrWwJUOmHuqjNmWTP8ad/
         wITg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=odY6KbSbKxqDrhObNYwd42zXyBsKpopwTCHslkv93Yg=;
        b=SDy9FqqE3yc+FxVnB5Ld8s/kYJ99PH607imLxBAG30hIZVirSHN5BErUWNKp9+rax/
         4Sq3Oy3q4SxbVTOQ5B8R1IvDdMT9NbJ6R5DA+zHUhO0i6IYl+GEAs3hABclQBL6MnFFp
         7zCVjC4nFABObO3y6SarZuMUeuqOL0NtkWcKEuNx3haHi6XerDzIddkO/pkyYbu/Zw/9
         z6uzIVT2+N8hnNhIsZWuVA8byooCi1ji4l+m8Dffe6L1ZL0nenTpn0YnVgUlH6KHbi94
         d5QYJIPils8y6x7Laeu1G4w8xrj7MeaU2zp19WAZKkNyyFoIqDdTTnH5spMXf6hwjIch
         x6CQ==
X-Gm-Message-State: AOAM530vupt2p0e3opv00qkUTGbY6eGmQLAozHeZ07zuNU1jwiRYePFH
        d8Mxnb5X6EIqzrYTZ0FoG17S6uxvCXDjmA==
X-Google-Smtp-Source: ABdhPJzMEMnlHTtnM7c8zslsF/1YvBY6tY4FsARQfTRiVmLXlohH/ZHNQpDZkoYogmnLc2ijSzyp4w==
X-Received: by 2002:a50:9fa5:: with SMTP id c34mr5652879edf.2.1599302229721;
        Sat, 05 Sep 2020 03:37:09 -0700 (PDT)
Received: from felia.fritz.box ([2001:16b8:2d30:ea00:952f:5889:9d53:77b0])
        by smtp.gmail.com with ESMTPSA id k6sm8709692ejr.104.2020.09.05.03.37.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 05 Sep 2020 03:37:08 -0700 (PDT)
From:   Lukas Bulwahn <lukas.bulwahn@gmail.com>
To:     Ioana Ciornei <ioana.ciornei@nxp.com>,
        "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Cc:     Ralf Ramsauer <ralf.ramsauer@oth-regensburg.de>,
        Pia Eichinger <pia.eichinger@st.oth-regensburg.de>,
        Joe Perches <joe@perches.com>, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Lukas Bulwahn <lukas.bulwahn@gmail.com>
Subject: [PATCH] MAINTAINERS: repair reference in LYNX PCS MODULE
Date:   Sat,  5 Sep 2020 12:37:00 +0200
Message-Id: <20200905103700.17162-1-lukas.bulwahn@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit 0da4c3d393e4 ("net: phy: add Lynx PCS module") added the files in
./drivers/net/pcs/, but the new LYNX PCS MODULE section refers to
./drivers/net/phy/.

Hence, ./scripts/get_maintainer.pl --self-test=patterns complains:

  warning: no file matches    F:    drivers/net/phy/pcs-lynx.c

Repair the LYNX PCS MODULE section by referring to the right location.

Signed-off-by: Lukas Bulwahn <lukas.bulwahn@gmail.com>
---
applies cleanly on next-20200903

Ioana, please ack.
David, please pick this minor non-urgent patch into your net-next.
 
 MAINTAINERS | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index bb0cb31d323b..918deaa1d96e 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -10350,7 +10350,7 @@ LYNX PCS MODULE
 M:	Ioana Ciornei <ioana.ciornei@nxp.com>
 L:	netdev@vger.kernel.org
 S:	Supported
-F:	drivers/net/phy/pcs-lynx.c
+F:	drivers/net/pcs/pcs-lynx.c
 F:	include/linux/pcs-lynx.h
 
 M68K ARCHITECTURE
-- 
2.17.1

