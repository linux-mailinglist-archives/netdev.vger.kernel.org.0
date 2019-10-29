Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F0504E87A1
	for <lists+netdev@lfdr.de>; Tue, 29 Oct 2019 12:59:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730303AbfJ2L7s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Oct 2019 07:59:48 -0400
Received: from mail-lj1-f193.google.com ([209.85.208.193]:34945 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725776AbfJ2L7s (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Oct 2019 07:59:48 -0400
Received: by mail-lj1-f193.google.com with SMTP id m7so14958524lji.2
        for <netdev@vger.kernel.org>; Tue, 29 Oct 2019 04:59:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=nfVQKB9XJT9KAwa7OFFOsDXrEQ0Ltetf7X8GhpgG8Mk=;
        b=AXePf6WJERlDTRRyN0F5iLH7cfTDnSdT5WkUQmR85EQPlXFzHiNXXbafMApbp03sp/
         NEbGiW94bRaK4npLJvDXdmLGKVrQ8HipKvRdHPyiBQEx0Te5MJHoLyQ8qjCqgqA21eLA
         gTLD3n2mfokvc0rgMkTTdQz5crzNDR4mSSyo4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=nfVQKB9XJT9KAwa7OFFOsDXrEQ0Ltetf7X8GhpgG8Mk=;
        b=sJ4rTR18vGUqalCaHd2sRmo4jZ/6uLYuP5kaLXBw3Ad6+G1HY5od5MmFDH2qSCiS9v
         OP+1df7i6nY6VlN2mwvpB72+SE98becdk7LDfz8gpUSSRYhqHJGvLkJAlh/fJsMw/+DT
         HT/rAa3Ocsk3/SpDiRscSCS/JiJZIwmqc5h44A4o+tw177J7PURXROx/nyWFFveOOGfS
         zDuKO1tHIFIDQhHT8Mor8jrNR4PxLG6vMpkO5IwGZdkYFLHGU1KwzjtJFLWCYX+T8UQ2
         Mshdwu9Z1eoV3cg8nuxYFl9WzuYjE9oIdn+gEP0iSi+ekOUuCL6bs+DD8+aMXhSKlXhd
         0ESQ==
X-Gm-Message-State: APjAAAXu7nNXC/bfea1789ZBunfKu0goLr5oi3WnnyvEvVGYqMMyj7OJ
        Ak4XWEe+NGr8IXUySp8Lf4rn/xdDuy8=
X-Google-Smtp-Source: APXvYqypuG2kW1CxsdV9GzKJd0XB9WUkdfjzItNNbHdD5ptveoreGQs+pqUMXUVPtW0hJtFlIsax6g==
X-Received: by 2002:a05:651c:1066:: with SMTP id y6mr2435959ljm.96.1572350385631;
        Tue, 29 Oct 2019 04:59:45 -0700 (PDT)
Received: from localhost.localdomain (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id 27sm7079313ljv.82.2019.10.29.04.59.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Oct 2019 04:59:44 -0700 (PDT)
From:   Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net,
        Nikolay Aleksandrov <nikolay@cumulusnetworks.com>,
        David Ahern <dsahern@gmail.com>
Subject: [PATCH net] net: rtnetlink: fix a typo fbd -> fdb
Date:   Tue, 29 Oct 2019 13:59:32 +0200
Message-Id: <20191029115932.399-1-nikolay@cumulusnetworks.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

A simple typo fix in the nl error message (fbd -> fdb).

CC: David Ahern <dsahern@gmail.com>
Fixes: 8c6e137fbc7f ("rtnetlink: Update rtnl_fdb_dump for strict data checking")
Signed-off-by: Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
---
 net/core/rtnetlink.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
index 1ee6460f8275..05bdf5908472 100644
--- a/net/core/rtnetlink.c
+++ b/net/core/rtnetlink.c
@@ -3916,7 +3916,7 @@ static int valid_fdb_dump_strict(const struct nlmsghdr *nlh,
 	ndm = nlmsg_data(nlh);
 	if (ndm->ndm_pad1  || ndm->ndm_pad2  || ndm->ndm_state ||
 	    ndm->ndm_flags || ndm->ndm_type) {
-		NL_SET_ERR_MSG(extack, "Invalid values in header for fbd dump request");
+		NL_SET_ERR_MSG(extack, "Invalid values in header for fdb dump request");
 		return -EINVAL;
 	}
 
-- 
2.21.0

