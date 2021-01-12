Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9EE712F2794
	for <lists+netdev@lfdr.de>; Tue, 12 Jan 2021 06:15:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387991AbhALFOf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jan 2021 00:14:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732239AbhALFOe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Jan 2021 00:14:34 -0500
Received: from mail-io1-xd32.google.com (mail-io1-xd32.google.com [IPv6:2607:f8b0:4864:20::d32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61B84C061786;
        Mon, 11 Jan 2021 21:13:54 -0800 (PST)
Received: by mail-io1-xd32.google.com with SMTP id w18so1567929iot.0;
        Mon, 11 Jan 2021 21:13:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=IbXhOJ56RwRmP5zF5gVpCwjA2Ob1+5GjKR6R6OZsZG8=;
        b=XQvAIkCZHT3eOaQWqsa5MfFBNLGrNt52eer5VlWISH+7k4o+fUhFclDOMWq29WrM4O
         BHcscU6I0wFGEYzgfP6W1+UMF+Bf778iBsNkUXCUgvPWnDiMXmWlp4l/vjhFmQ06a1Kh
         qKaWe+UNDo29BvX1i45atZVCQsS8NzcztRmiAIKVjjfZpilPjqDlYIbnlVHOEAEINQqf
         /0SlKbdsVqkwaVw7cbZ/omiXHtXUYHa3ixukOuE3rLFmPe3dv65m4ktg7xBACLpTobde
         KApF7miS5XoZ67y+uBtN7Uoes3KCVXQ9ljxPPxKzJ2gMEX53k+QZocaLUzLehJlo2k5+
         i0zA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=IbXhOJ56RwRmP5zF5gVpCwjA2Ob1+5GjKR6R6OZsZG8=;
        b=hx/t7hRIZfTRX9HA2+k6YR9wvThaYlptyf+q/CAsE1xAyZMiNqK2ZipOvaadgk04aC
         S0l32fqY8qL/duxa5G1Ohp0rdQ6+SDNrLtXs0E41+7ellAsT44nYKGn6ER5/ZI7NcjmX
         hggFMXZUOVssEEyEkoPQkv4whZ+FQbaYdoxq4KhjqAepH3+u898t0E7KsD/3HSXzuw9w
         J4XTqkzaNyPopEAeMSeCXDAoX0rJciEfqHSdqCD6ipDHtZkv1KXf9NFZ0PvpenU4pt12
         qQbPmwjOQ9ht+F5t8Iv8HyXI4wF4GiS/fStkdKI0vJ26wjN9ooIO6eE7WmbWPKNURz+R
         CIPA==
X-Gm-Message-State: AOAM532xlU04R5WcBvX8LjxqrC7wRR+h20kd5Cojb+wm5sSgFQ8dm1Eg
        FXx6yQw8NPit8NzOE3Zx2I4=
X-Google-Smtp-Source: ABdhPJz1LCsKd5Owfk2BbzcKfOUv/VmBeFnHA2Q/qg7CgxJxyCZyItZaXBWs8agXTHj5dowPoFu4Mw==
X-Received: by 2002:a05:6638:216e:: with SMTP id p14mr2742011jak.70.1610428433876;
        Mon, 11 Jan 2021 21:13:53 -0800 (PST)
Received: from localhost.localdomain ([156.146.36.246])
        by smtp.gmail.com with ESMTPSA id m19sm1616223ila.81.2021.01.11.21.13.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Jan 2021 21:13:53 -0800 (PST)
From:   Bhaskar Chowdhury <unixbhaskar@gmail.com>
To:     mw@semihalf.com, linux@armlinux.org.uk, davem@davemloft.net,
        kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, gustavo@embeddedor.com
Cc:     rdunlap@infradead.org, Bhaskar Chowdhury <unixbhaskar@gmail.com>
Subject: [PATCH V2] drivers: net: marvell:  Fix two spellings, controling to controlling and oen to one
Date:   Tue, 12 Jan 2021 10:43:42 +0530
Message-Id: <20210112051342.26064-1-unixbhaskar@gmail.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

s/controling/controlling/

s/oen/one/

Signed-off-by: Bhaskar Chowdhury <unixbhaskar@gmail.com>
---
 As Gustavo mentioned in reply, so included that missed one before

 drivers/net/ethernet/marvell/mvpp2/mvpp2_cls.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_cls.h b/drivers/net/ethernet/marvell/mvpp2/mvpp2_cls.h
index 8867f25afab4..663157dc8062 100644
--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_cls.h
+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_cls.h
@@ -143,7 +143,7 @@ struct mvpp2_cls_c2_entry {
 /* Number of per-port dedicated entries in the C2 TCAM */
 #define MVPP22_CLS_C2_PORT_N_FLOWS	MVPP2_N_RFS_ENTRIES_PER_FLOW

-/* Each port has oen range per flow type + one entry controling the global RSS
+/* Each port has one range per flow type + one entry controlling the global RSS
  * setting and the default rx queue
  */
 #define MVPP22_CLS_C2_PORT_RANGE	(MVPP22_CLS_C2_PORT_N_FLOWS + 1)
--
2.26.2

