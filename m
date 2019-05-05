Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0DFBA13EC6
	for <lists+netdev@lfdr.de>; Sun,  5 May 2019 12:19:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727572AbfEEKTn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 May 2019 06:19:43 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:45367 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726385AbfEEKTn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 May 2019 06:19:43 -0400
Received: by mail-wr1-f68.google.com with SMTP id s15so13374901wra.12
        for <netdev@vger.kernel.org>; Sun, 05 May 2019 03:19:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=jcJCE0SrnQR/E7Wsplb3Zz3VWO9/nKhcjoLDvgwhPbE=;
        b=IL+Uxw0IQDTxvdORugEIlTwM/bPqcepcWnFXY1AprMHtCzzhz6os/ogAkQL5jJ15QN
         /dKFW32oTBIYgh+KwombabrLvq43sZkuxGGfAKaOg3NetJkC/4qISquDBUf3VlV9d3RE
         CqLuWKgAaLnoccmWjJVcLvmoXOBqmLE9zMjyJVvpr/ybwwMuKl73nukJWAGCFsii96vS
         r6vR8EkjS0rl8Y62a1vcGJioaH1hdunU9oWQG5d/zfsXWW2U3iSBmaMbq8dhUb/44hQE
         AHy4VNenwhCMomH+JiJnfMlbsjTzW1+ApERyrASJWIbAzh/M/kGYHjwXwn6bL1Nb62Xy
         1V7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=jcJCE0SrnQR/E7Wsplb3Zz3VWO9/nKhcjoLDvgwhPbE=;
        b=lAYp+LPTa9ODUzbSJwT36Fl94Q/HbpMAukxBbOI7EvLHKYHp5RvXfKBrSnmY0gxGvP
         IkTemdskoTkzbilsD2AsNQ9ZAu4WIJB0x/6IbArmZLOUisH39ae2GwzXS2wGLnuKGoy4
         BzLNd+iVgv73F6j+OJu7wYLpXapru9iWfoyOlnnsKLo0BiywKKusq79r8LDzDA85IIY5
         zwr995hVWf0p4xB3yPqHsy505mF97kXL6oRFblx7G9hxV/VYtnLUxVkozRSnugAq5cyt
         T6KJVSC4kfhLoGjclccVwROpzROgSUiDcGdC5wHmo5Hyj4OzOhiBAzysLlR+F43Sitri
         KzEw==
X-Gm-Message-State: APjAAAUGk79lMOwbymh6Bb2a+CmUpB8N4DGHz7uPYslNkvUt8qN1O7sD
        lCXrpnv33LVSgqmXoRshEG0=
X-Google-Smtp-Source: APXvYqw763uuLd6V2G3huLxwO4cZPVXCbikIApl4jLuyMrOc+2E7U9WUW/wEg1desYz24ivAIZX+VQ==
X-Received: by 2002:a5d:6341:: with SMTP id b1mr14118895wrw.28.1557051581572;
        Sun, 05 May 2019 03:19:41 -0700 (PDT)
Received: from localhost.localdomain (5-12-225-227.residential.rdsnet.ro. [5.12.225.227])
        by smtp.gmail.com with ESMTPSA id n2sm12333193wra.89.2019.05.05.03.19.40
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 05 May 2019 03:19:41 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     f.fainelli@gmail.com, vivien.didelot@gmail.com, andrew@lunn.ch,
        davem@davemloft.net
Cc:     netdev@vger.kernel.org, Vladimir Oltean <olteanv@gmail.com>
Subject: [PATCH net-next v3 02/10] net: dsa: Export symbols for dsa_port_vid_{add,del}
Date:   Sun,  5 May 2019 13:19:21 +0300
Message-Id: <20190505101929.17056-3-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190505101929.17056-1-olteanv@gmail.com>
References: <20190505101929.17056-1-olteanv@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is needed so that the newly introduced tag_8021q may access these
core DSA functions when built as a module.

Reported-by: kbuild test robot <lkp@intel.com>
Signed-off-by: Vladimir Oltean <olteanv@gmail.com>
---
Changes in v3:
  - Patch is new.

 net/dsa/port.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/dsa/port.c b/net/dsa/port.c
index e6ad19df5cd8..9bafc5b8da16 100644
--- a/net/dsa/port.c
+++ b/net/dsa/port.c
@@ -389,6 +389,7 @@ int dsa_port_vid_add(struct dsa_port *dp, u16 vid, u16 flags)
 	trans.ph_prepare = false;
 	return dsa_port_vlan_add(dp, &vlan, &trans);
 }
+EXPORT_SYMBOL(dsa_port_vid_add);
 
 int dsa_port_vid_del(struct dsa_port *dp, u16 vid)
 {
@@ -400,6 +401,7 @@ int dsa_port_vid_del(struct dsa_port *dp, u16 vid)
 
 	return dsa_port_vlan_del(dp, &vlan);
 }
+EXPORT_SYMBOL(dsa_port_vid_del);
 
 static struct phy_device *dsa_port_get_phy_device(struct dsa_port *dp)
 {
-- 
2.17.1

