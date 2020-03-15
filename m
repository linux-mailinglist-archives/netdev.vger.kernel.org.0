Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 05FA8185B1C
	for <lists+netdev@lfdr.de>; Sun, 15 Mar 2020 08:54:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727767AbgCOHyN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 15 Mar 2020 03:54:13 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:33736 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727654AbgCOHyN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 15 Mar 2020 03:54:13 -0400
Received: by mail-wr1-f66.google.com with SMTP id a25so17322258wrd.0;
        Sun, 15 Mar 2020 00:54:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=krZuLH5aA8NwXAZfipidEOIflgKvPBY7kHSi8m+OXmY=;
        b=plSZ2YEqBywE95sMwb5/g9rxew5HtQN7TGswA23clZ5u+Lsfp1NPfjiJQQBn+w4NGu
         P2Z1SsxnPhFEiv3BS49M0E7zeantBSJO6jVMlY97YJH0ntQwqXYroHFojNgIzGH5UEhf
         QF92dp8zrcBCJ6yzUDFzPQxGbSdOnKZkf1nYHFkz4maNzdSEeOtdRLD8h4pERMSLqxpD
         9tBdEscrUMNhN4Gfj+Y8uMH8NPLSZOjEIyl5j0s5i5do1nBTM6rjYptgaUIZa79DnCpT
         szjX/bQOop0i1sCtFA6UqgSILpUvcrs6OOIu4woffBwLaO9oIl39UDHNoABe0GujGOnJ
         zuhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=krZuLH5aA8NwXAZfipidEOIflgKvPBY7kHSi8m+OXmY=;
        b=qoZEs6eeIP6/ETf4YdhuYyJHik25v2PyRc8gji+ajW4jXOxA2aJRaf7LRjOJ+GLMgn
         aDo5D6gH4rcoy+Mthkqw9DyNrHOKBG4nzkNuSgme1ZiDd0WOObvbcBp/ai0/zC45rboB
         eX6Ka6dM3NyfycvhOV5Vwj9IsHOeAxYvEMpaGGWXKSDGHeNpbW6pOCb/0+JBVB78t/02
         Px5BYk/NXxnBYfbG+x/eykcWwyhUbclSx97dc7ELe4QL6oQ1JPBlUGcyzcRHiGJauEQm
         IqN36B2oddSyOWLxpU4D5rV1ds46EvhOYeq/At6FRbBC6QXNQK+KwBwhfySoK2WqRNcL
         +Sow==
X-Gm-Message-State: ANhLgQ2M9+9xnuXFnj0cP6e0iYdig3UlXZ8NN+3/vG0spV9PbJAJQmZh
        HEocSKslcD2qZl4pfPo5aIY=
X-Google-Smtp-Source: ADFU+vtHChFjhT4bEeZSnYpEU/ALFDqNPkSpBIGVQaE1mDIrUUJukwiaOltooyAjRU2TukDAL8FKMA==
X-Received: by 2002:a05:6000:c:: with SMTP id h12mr22936862wrx.168.1584258850781;
        Sun, 15 Mar 2020 00:54:10 -0700 (PDT)
Received: from felia.fritz.box ([2001:16b8:2d6c:6c00:888a:952a:33bc:a081])
        by smtp.gmail.com with ESMTPSA id k126sm24716601wme.4.2020.03.15.00.54.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 15 Mar 2020 00:54:10 -0700 (PDT)
From:   Lukas Bulwahn <lukas.bulwahn@gmail.com>
To:     Benjamin Gaignard <benjamin.gaignard@st.com>,
        Rob Herring <robh@kernel.org>
Cc:     Dan Murphy <dmurphy@ti.com>, Sriram Dash <sriram.dash@samsung.com>,
        linux-can@vger.kernel.org, netdev@vger.kernel.org,
        Joe Perches <joe@perches.com>, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Lukas Bulwahn <lukas.bulwahn@gmail.com>
Subject: [PATCH] MAINTAINERS: adjust to MCAN MMIO schema conversion
Date:   Sun, 15 Mar 2020 08:53:56 +0100
Message-Id: <20200315075356.8596-1-lukas.bulwahn@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit 824674b59f72 ("dt-bindings: net: can: Convert M_CAN to json-schema")
missed to adjust the MCAN MMIO DEVICE DRIVER entry in MAINTAINERS.

Since then, ./scripts/get_maintainer.pl --self-test complains:

  warning: no file matches \
  F: Documentation/devicetree/bindings/net/can/m_can.txt

Update MAINTAINERS entry to location of converted schema.

Signed-off-by: Lukas Bulwahn <lukas.bulwahn@gmail.com>
---
applies cleanly on next-20200313

Benjamin, please ack.
Rob, please pick this patch (it is not urgent, though).

 MAINTAINERS | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 32a95d162f06..ebc3d91294c6 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -10323,7 +10323,7 @@ M:	Dan Murphy <dmurphy@ti.com>
 M:	Sriram Dash <sriram.dash@samsung.com>
 L:	linux-can@vger.kernel.org
 S:	Maintained
-F:	Documentation/devicetree/bindings/net/can/m_can.txt
+F:	Documentation/devicetree/bindings/net/can/bosch,m_can.yaml
 F:	drivers/net/can/m_can/m_can.c
 F:	drivers/net/can/m_can/m_can.h
 F:	drivers/net/can/m_can/m_can_platform.c
-- 
2.17.1

