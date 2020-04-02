Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 03A9519BF53
	for <lists+netdev@lfdr.de>; Thu,  2 Apr 2020 12:28:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387945AbgDBK2a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Apr 2020 06:28:30 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:52747 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728612AbgDBK2a (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Apr 2020 06:28:30 -0400
Received: by mail-wm1-f65.google.com with SMTP id t8so2812624wmi.2
        for <netdev@vger.kernel.org>; Thu, 02 Apr 2020 03:28:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=hU5h8cLuj7lB3NQuqbiKMfQL1bgZg19790EsPw/f0/E=;
        b=XkWi7A4VLONwH+6R2Qp98KET++ywX/BXE9yPyvGIcxpFzualIQZrxwy6gqoIvx3cKY
         yTV7JLhfec5PMft7xtMtKIr5HYDdSZmr08mYi1Z9xYbjG9dEZB496Z4jwwcrfwr4p50D
         3z85vuhmp1TshnBGp+PCiDxaLy3Srz8AGkupBpLS15Alqi+ma/auVzZOOoblBhf1cZDd
         7vQEpxBOHA0utWD0tdi/eiy7sXt0YDuhAiJCWDy1GbOxzWQxxPuj4wFqwYUqTyDBmg/5
         NyIk7X61GrHGEuhEm4LG+4b1uD+BitCOMr6x9kBFHT8iLTENzsSgOc1JagCTFRiqP6AV
         MXPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=hU5h8cLuj7lB3NQuqbiKMfQL1bgZg19790EsPw/f0/E=;
        b=R79xD+IbBjSpVvrQhY9+SIx4NUITY27F2sHCWXJQv9IsOlYiP2QwDdaseY5ih/STJg
         dWvRkuUquJGcSGqMpZ+WR53DzQoV6YFLLaweAWpu5qm78vD90/ELGDrfzS7Hm9MzLUUE
         +vJ8fbTH0G/cM64oHmEGKF5IubwllEHoi1Upst68Qyy3qlqMj86mJ1JMgnt6b0TBIyW7
         pGhym6IANNfhmzA6cajpUu2zBJZPJVTdTI3fZH+uOB664JMH3Oju76RP2nejmfMUbGXZ
         Xstfd8rYN3ZzFr3Euw2VB3FF0z8epAHIfBCeakwGzMO3GsMravY2N/8iaS4CwDC9yzcr
         nAEA==
X-Gm-Message-State: AGi0PuZ4Gg7DulAPjbB3WlBg2+FVDrryKaEov4hTypNr6X6MuykaGqwH
        Odk/lwXMxtzK3NHNAu3UArA=
X-Google-Smtp-Source: APiQypIZviXoou6pRhc2GPifxFhhUlLAnSXnxpw9qevgVJOAOzACJ5K/aKcUtlpBLgDuhuQYicVTCA==
X-Received: by 2002:a7b:cb81:: with SMTP id m1mr2758667wmi.1.1585823307932;
        Thu, 02 Apr 2020 03:28:27 -0700 (PDT)
Received: from localhost.localdomain (5-12-96-237.residential.rdsnet.ro. [5.12.96.237])
        by smtp.gmail.com with ESMTPSA id 91sm750725wrf.79.2020.04.02.03.28.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Apr 2020 03:28:27 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        davem@davemloft.net
Cc:     netdev@vger.kernel.org
Subject: [PATCH net] net: dsa: dsa_bridge_mtu_normalization() can be static
Date:   Thu,  2 Apr 2020 13:28:19 +0300
Message-Id: <20200402102819.8334-1-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: kbuild test robot <lkp@intel.com>

This function is not called from any other C file.

Fixes: bff33f7e2ae2 ("net: dsa: implement auto-normalization of MTU for bridge hardware datapath")
Signed-off-by: kbuild test robot <lkp@intel.com>
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 net/dsa/slave.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index 5390ff541658..e94eb1aac602 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -1338,7 +1338,7 @@ static void dsa_hw_port_list_free(struct list_head *hw_port_list)
 }
 
 /* Make the hardware datapath to/from @dev limited to a common MTU */
-void dsa_bridge_mtu_normalization(struct dsa_port *dp)
+static void dsa_bridge_mtu_normalization(struct dsa_port *dp)
 {
 	struct list_head hw_port_list;
 	struct dsa_switch_tree *dst;
-- 
2.17.1

