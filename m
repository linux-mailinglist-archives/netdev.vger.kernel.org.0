Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4925A254AE1
	for <lists+netdev@lfdr.de>; Thu, 27 Aug 2020 18:39:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727882AbgH0QjQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Aug 2020 12:39:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726266AbgH0QjM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Aug 2020 12:39:12 -0400
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E5CAC061264;
        Thu, 27 Aug 2020 09:39:11 -0700 (PDT)
Received: by mail-wr1-x443.google.com with SMTP id d10so5081205wrw.2;
        Thu, 27 Aug 2020 09:39:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=X8tAmJgMDdPWe1jtHOmktcd5X+D5VAolQ0RvwPi2Oio=;
        b=JKHKyGbqLhC8llQwzjTZcHPS3n5LliWOo8QUU8lxH4wR4BGkhgmS3LGOKj18gTURKe
         xVcjzF562daBaRz07SZmAhkD3bS92Y2Qroadwk8FmiRluw7uMMqJI6fnZdX7GUgOdEmB
         65U9iFAioqN1hpSZazaOwmo7FywtnfGMAiS90nYHo18ijdIHCLHt8fPn7NhkjcxnxwPB
         AIV9KNgkeuQIARMN0q41x1+YzdGmLkcwTQWbO4/oqX4Jh6h8tGqQiPonxE3zJzjw78CK
         6GftCFXPaXv8r+Q+3LYEJMk6aSg4y0wFWo5VAQOJQ2h+Uy5VrrtDnH0lm3aWj5UvhsEL
         OesQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=X8tAmJgMDdPWe1jtHOmktcd5X+D5VAolQ0RvwPi2Oio=;
        b=eoUgsZCEYmE+QjtU7Dk8NZVofa9lNIjFNoNxcXuGTMYHkPfdyaEWiMwGiEU/FazSBr
         mJ8FOShXWNeNhe4YpuRbaZZOP3BWBCR4WyeMj5/B/zmCrpJsYJLhW4iVdT1vBLis1+Pd
         WcId2jX/amc/oWEiVFraQxX21k9rWcgYCYcpS0ZVVBF48muobwLC5zeIY8cNr11/FbSx
         b0h1YMicuuARZFC51bV3NqqATN3kfsvuHmXO1yP1LujTNfnpSYq/zR1QKAfn/LgbFLUl
         e4mxK4YNFftFFOhh00IYlQog7EOLDX5VTQ7VNw8w59H64G/sOjI1dy2V4AzrcaUfdGoF
         1hWQ==
X-Gm-Message-State: AOAM530V+fjpOyN+3oeD8fhifnjUO06rhmvLVpZuWNDg2W8ZubNcJ8rj
        /pUYsUNs8tzQa3/fArpJY8k=
X-Google-Smtp-Source: ABdhPJxhNW1oeT8TgLHU84jXFHu+0GvYbZS44y22iMS6YOeBEZEaapcLixbe4qJH4FbAX3T7hpXgdA==
X-Received: by 2002:adf:f808:: with SMTP id s8mr14411769wrp.218.1598546350163;
        Thu, 27 Aug 2020 09:39:10 -0700 (PDT)
Received: from localhost.localdomain (cpc83661-brig20-2-0-cust443.3-3.cable.virginm.net. [82.28.105.188])
        by smtp.gmail.com with ESMTPSA id d21sm6509238wmd.41.2020.08.27.09.39.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Aug 2020 09:39:09 -0700 (PDT)
From:   Alex Dewar <alex.dewar90@gmail.com>
Cc:     Alex Dewar <alex.dewar90@gmail.com>,
        Paul Moore <paul@paul-moore.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH RFC] netlabel: remove unused param from audit_log_format()
Date:   Thu, 27 Aug 2020 17:37:12 +0100
Message-Id: <20200827163712.106303-1-alex.dewar90@gmail.com>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To:     unlisted-recipients:; (no To-header on input)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit d3b990b7f327 ("netlabel: fix problems with mapping removal")
added a check to return an error if ret_val != 0, before ret_val is
later used in a log message. Now it will unconditionally print "...
res=0". So don't print res anymore.

Addresses-Coverity: ("Dead code")
Fixes: d3b990b7f327 ("netlabel: fix problems with mapping removal")
Signed-off-by: Alex Dewar <alex.dewar90@gmail.com>
---

I wasn't sure whether it was intended that something other than ret_val
be printed in the log, so that's why I'm sending this as an RFC.


 net/netlabel/netlabel_domainhash.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/net/netlabel/netlabel_domainhash.c b/net/netlabel/netlabel_domainhash.c
index f73a8382c275..526762b2f3a9 100644
--- a/net/netlabel/netlabel_domainhash.c
+++ b/net/netlabel/netlabel_domainhash.c
@@ -612,9 +612,8 @@ int netlbl_domhsh_remove_entry(struct netlbl_dom_map *entry,
 	audit_buf = netlbl_audit_start_common(AUDIT_MAC_MAP_DEL, audit_info);
 	if (audit_buf != NULL) {
 		audit_log_format(audit_buf,
-				 " nlbl_domain=%s res=%u",
-				 entry->domain ? entry->domain : "(default)",
-				 ret_val == 0 ? 1 : 0);
+				 " nlbl_domain=%s",
+				 entry->domain ? entry->domain : "(default)");
 		audit_log_end(audit_buf);
 	}
 
-- 
2.28.0

