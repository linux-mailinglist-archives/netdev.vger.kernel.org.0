Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9F4B4AD14F
	for <lists+netdev@lfdr.de>; Mon,  9 Sep 2019 01:55:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731684AbfIHXzL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 8 Sep 2019 19:55:11 -0400
Received: from mail-qt1-f195.google.com ([209.85.160.195]:42598 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731668AbfIHXzJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 8 Sep 2019 19:55:09 -0400
Received: by mail-qt1-f195.google.com with SMTP id c9so14106866qth.9
        for <netdev@vger.kernel.org>; Sun, 08 Sep 2019 16:55:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=8yKskexvc0yKszSPHLlD+xXy+tddncxqe3N323uJrtk=;
        b=dkv200VWCZxu1ijix9eiWu0jgagBwixqO8Om+x8VYN5HON1bQDp4orua5XYTjsN8LQ
         y8DylFLt9Cxqkiu2QcRvFm+ijn+GMCwbiS0+A68PdUkJKz8Qd70ABD8KZri+1Lun/Z39
         2wf5eOKAjc2uyv1RSX2Wwmfyy+iezpzY8Tc8Mw8FUeGZqotHDs2rfDW6FE37ABnJntIO
         gszUPs/bMw0N6pVB1DFee7afX0qK7qQQ202eoEt9L5w1xeDAAVWx8HByIyoQar2MvLQV
         +3PnyV8pbJDDZAPIz6hzzDsnChi/e8jsStKM+HQ3gmI0zEWRnqEk6vXwgM142OaX17am
         NdzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=8yKskexvc0yKszSPHLlD+xXy+tddncxqe3N323uJrtk=;
        b=sS0UgaJD9QQRWKUYEsRlDy1UPddYUN9TAL76ISMRj1ymG9us+LQMs/0VJN9IYcI4Y8
         fDGFJmSwR2ip8Uur0wesCnoLveE3v8UopSelehFhAxzquneQBevflVV11DajJvA9BOoi
         +wBPILlBdHmQ+LpIrToVwogJWXqgrc/1Iva6aBgo+uyAyRwd6H7PhTdvJgHr7bJ7NNY4
         J4CGG3wvu28n2QQfI+MqoDpoJE246IXASzl55UPfI7joABamFb97txzU33FQ11uIo66v
         JIkn1Sz0HClcsuxg0LE7Qs75xUe3TzXGZv7rFTd/Z/6yUDtvYLXrnrvarAMvrTcvb14i
         TtVQ==
X-Gm-Message-State: APjAAAWYUa+0Z+m4XCFInxwQVsKPsZ8o/MpRYluFVkBvB8EhaNox/Qti
        qC6Cc566PWX8KlhvIRr3ZGhYHw==
X-Google-Smtp-Source: APXvYqxwhNy3YftOWvpt4hNoEI+ymUrWmMSmnOcSyTXXgvMiAq4PVXgpHuNaQK6wykjhgx8xGVbSAQ==
X-Received: by 2002:a0c:e501:: with SMTP id l1mr12752759qvm.1.1567986908223;
        Sun, 08 Sep 2019 16:55:08 -0700 (PDT)
Received: from penelope.pa.netronome.com (195-23-252-147.net.novis.pt. [195.23.252.147])
        by smtp.gmail.com with ESMTPSA id p27sm5464406qkm.92.2019.09.08.16.55.06
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 08 Sep 2019 16:55:07 -0700 (PDT)
From:   Simon Horman <simon.horman@netronome.com>
To:     David Miller <davem@davemloft.net>
Cc:     Jakub Kicinski <jakub.kicinski@netronome.com>,
        netdev@vger.kernel.org, oss-drivers@netronome.com,
        Dirk van der Merwe <dirk.vandermerwe@netronome.com>,
        Simon Horman <simon.horman@netronome.com>
Subject: [PATCH net-next v2 10/11] kdoc: fix nfp_fw_load documentation
Date:   Mon,  9 Sep 2019 00:54:26 +0100
Message-Id: <20190908235427.9757-11-simon.horman@netronome.com>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190908235427.9757-1-simon.horman@netronome.com>
References: <20190908235427.9757-1-simon.horman@netronome.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dirk van der Merwe <dirk.vandermerwe@netronome.com>

Fixed the incorrect prefix for the 'nfp_fw_load' function.

Signed-off-by: Dirk van der Merwe <dirk.vandermerwe@netronome.com>
Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>
Signed-off-by: Simon Horman <simon.horman@netronome.com>
---
 drivers/net/ethernet/netronome/nfp/nfp_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/netronome/nfp/nfp_main.c b/drivers/net/ethernet/netronome/nfp/nfp_main.c
index 969850f8fe51..4d282fc56009 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_main.c
+++ b/drivers/net/ethernet/netronome/nfp/nfp_main.c
@@ -458,7 +458,7 @@ nfp_get_fw_policy_value(struct pci_dev *pdev, struct nfp_nsp *nsp,
 }
 
 /**
- * nfp_net_fw_load() - Load the firmware image
+ * nfp_fw_load() - Load the firmware image
  * @pdev:       PCI Device structure
  * @pf:		NFP PF Device structure
  * @nsp:	NFP SP handle
-- 
2.11.0

