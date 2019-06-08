Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B338439BE4
	for <lists+netdev@lfdr.de>; Sat,  8 Jun 2019 10:42:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726501AbfFHIl7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 8 Jun 2019 04:41:59 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:36283 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726164AbfFHIl7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 8 Jun 2019 04:41:59 -0400
Received: by mail-pf1-f193.google.com with SMTP id u22so2492374pfm.3;
        Sat, 08 Jun 2019 01:41:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:subject:message-id:mime-version:content-disposition
         :user-agent;
        bh=cUi6YCZz/ey83Lh7qYQANmj1js9gNg9rJpOrhZYroro=;
        b=Dw9cLMkWUsQRNmnU3iVZFWvpf6urwGJwSounBD3n5o9I3udjrcI9Tk1mt1JJeX3egu
         cCpQSsGV4M8BercqTdMjvaT571sFuFyeonrraTS208oiAOjIG2QmAQrdR9/RYW3VQCwf
         djO7ypwSb2wTOB31Aaw5mi84PtEtoQIvA2ZDrIAyX/Cn7Yx4q8okxDuDV2dgy0G5/tbP
         BBqZANPw1UOLvmyEGdffvm7B78Bcbe+1vGTHU2JV0RVOHCy9fAR7R+oG23SthGxbq5xK
         GJWtoJzMZMIHcz1WTZkvH2JtevBRcdjz0JsCg+cWw8LDaX2rXXkti8jiobEIizon/3hl
         4bgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:subject:message-id:mime-version
         :content-disposition:user-agent;
        bh=cUi6YCZz/ey83Lh7qYQANmj1js9gNg9rJpOrhZYroro=;
        b=mz+s4ITDjAtkP1sD3zF8pqvASjkAhMwuRZPGfiMRauWbS/R4KDIUD2c5Xde6LVc9+e
         UYtmPtQrZKe5a8yFfoDP7E3N37xsW6Y83x2iQcdA/optKPJY3kmqaxmQ1b0gZsB9Az+G
         C1MURqbJ9pNyVTBavpk7k36vEbUP/A513B7UstY4J97B8Kd7lWTkO9tNj9wpySp51GUx
         QHAQ+PINNuspPzlVTBqC/c+o8eOeIDtNfKgus8xpZtC/VjuUVfNyJz381qusdHkXJgMu
         F2UrNgVE3fm062mSyTmw9HOGTLMuv0HVF51t2cnd5L5MLA3LoQZuk/oRIp/jq+hjrEDu
         72/g==
X-Gm-Message-State: APjAAAUEevcyasYpGOCgGuZrl1oxz6n6Tn1RDWhA218wZ8NS38lr0vam
        4/TvSCMkfA0NW5x+I+0hcTk=
X-Google-Smtp-Source: APXvYqzQvyX+7tmUUIYhTfHRIvjOK0bVEYj3/kJuvrWzh4RN2Le2ROwWZxjKquD9clxP6i7wxsfYAQ==
X-Received: by 2002:a62:bd03:: with SMTP id a3mr6040013pff.209.1559983318354;
        Sat, 08 Jun 2019 01:41:58 -0700 (PDT)
Received: from hari-Inspiron-1545 ([183.83.89.153])
        by smtp.gmail.com with ESMTPSA id h11sm4886172pfn.170.2019.06.08.01.41.56
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 08 Jun 2019 01:41:57 -0700 (PDT)
Date:   Sat, 8 Jun 2019 14:11:54 +0530
From:   Hariprasad Kelam <hariprasad.kelam@gmail.com>
To:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] nfc: nci: fix warning comparison to bool
Message-ID: <20190608084154.GA7520@hari-Inspiron-1545>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix below warning reported by coccicheck

net/nfc/nci/ntf.c:367:5-15: WARNING: Comparison to bool

Signed-off-by: Hariprasad Kelam <hariprasad.kelam@gmail.com>
---
 net/nfc/nci/ntf.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/nfc/nci/ntf.c b/net/nfc/nci/ntf.c
index 1e8c1a1..81e8570 100644
--- a/net/nfc/nci/ntf.c
+++ b/net/nfc/nci/ntf.c
@@ -364,7 +364,7 @@ static void nci_rf_discover_ntf_packet(struct nci_dev *ndev,
 	ntf.ntf_type = *data++;
 	pr_debug("ntf_type %d\n", ntf.ntf_type);
 
-	if (add_target == true)
+	if (add_target)
 		nci_add_new_target(ndev, &ntf);
 
 	if (ntf.ntf_type == NCI_DISCOVER_NTF_TYPE_MORE) {
-- 
2.7.4

