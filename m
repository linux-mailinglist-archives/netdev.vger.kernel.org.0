Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D8F3E1DEF6D
	for <lists+netdev@lfdr.de>; Fri, 22 May 2020 20:45:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730879AbgEVSpb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 May 2020 14:45:31 -0400
Received: from mta-p6.oit.umn.edu ([134.84.196.206]:60876 "EHLO
        mta-p6.oit.umn.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730810AbgEVSp2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 May 2020 14:45:28 -0400
Received: from localhost (unknown [127.0.0.1])
        by mta-p6.oit.umn.edu (Postfix) with ESMTP id 49TFmQ6rVmz9vZ2Z
        for <netdev@vger.kernel.org>; Fri, 22 May 2020 18:45:26 +0000 (UTC)
X-Virus-Scanned: amavisd-new at umn.edu
Received: from mta-p6.oit.umn.edu ([127.0.0.1])
        by localhost (mta-p6.oit.umn.edu [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id d9JJvsOzGyX9 for <netdev@vger.kernel.org>;
        Fri, 22 May 2020 13:45:26 -0500 (CDT)
Received: from mail-io1-f70.google.com (mail-io1-f70.google.com [209.85.166.70])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mta-p6.oit.umn.edu (Postfix) with ESMTPS id 49TFmQ58WWz9vZ2T
        for <netdev@vger.kernel.org>; Fri, 22 May 2020 13:45:26 -0500 (CDT)
DMARC-Filter: OpenDMARC Filter v1.3.2 mta-p6.oit.umn.edu 49TFmQ58WWz9vZ2T
DKIM-Filter: OpenDKIM Filter v2.11.0 mta-p6.oit.umn.edu 49TFmQ58WWz9vZ2T
Received: by mail-io1-f70.google.com with SMTP id l2so6490609iok.5
        for <netdev@vger.kernel.org>; Fri, 22 May 2020 11:45:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=umn.edu; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=jcvktWzuf/YXJY7B0r0fkd4cBPlRZYMazd1bG7Knz0c=;
        b=gQ7VoiSWNDAurX2rgbSypPcmLB7w9Jvn08mBdJMJuHb25/wtGmnfpprU+6c5L3QG3/
         bzsM9SuomxldGrYsmbNh14S+TTNHtS15CQQucWHvoC50LV9ND9hkZahbIy5y9kTK4oTM
         wsnPs27cKSJV9geYLWjU3NUMGP3vRiAbaCA7ukKMzFJUUS+iCdBe0F8vudzvwOfh6Vuj
         Bci9Gp8t5f1zdZDGWPBEl9CY3EMVnwzN3R8SE0cPrUeDObg5yX5UUGbNbrpDt1pvVQf2
         I7MFa5IVLeLpg5DqLYm2Edbm/awA8ohROq2iHKNlZAyQa6VD/u9bAKg5TEtg2Ar8KX5U
         pvcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=jcvktWzuf/YXJY7B0r0fkd4cBPlRZYMazd1bG7Knz0c=;
        b=RpFv6w03KlGmoyv5hGs4q8VcfnCvCPJ0bMi+Qb8nrK9Jn2o1PNWH/Isw2ZA1bM0yOh
         7kHmx86RdxW+3uqsIkfvda8/DPZSV9c5vkT8isv7qd9hP1OpzorPxVskdmkt8sMkUpjz
         24CCmXLatbq63ic/kfEfe97pzCc0iKHbpfTbCWb7GszOMDMyH3p4mkNjzbrp67aKEob8
         kyZ8vOQ//aEAwrU0wStOO0VRH8XnsAW4f51kqDBEp8M7xFWRl97AyA5vFaZFZiWqhAOO
         I8dIh/LgVkEQxj0s0FkwVo45Sm7T/UQZV35blsHTc2bW2Tyd9cIeNf7x5oeRBGQ3tDEb
         YBZQ==
X-Gm-Message-State: AOAM533jr+pZt3lvggLY+B9loUWLevqjJTqoDJ+hMI5xmA4IsX1Kehic
        P3t1R3jeRIw4GBmi5jqm7guTuEdftg2QWcxL1JSYp3QmHGnjaXSRDiNLa3i4kJkaYM0M37BKYGR
        huZLITzrKr3JY/W4s3shZ
X-Received: by 2002:a02:942a:: with SMTP id a39mr9335836jai.50.1590173126220;
        Fri, 22 May 2020 11:45:26 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzq7xTVOmomZtExLcWH5Wmv5DCntGP0+yx8VBEomiAdvM5u/Is+jMFWSfoirA2k795Um2KKfA==
X-Received: by 2002:a02:942a:: with SMTP id a39mr9335815jai.50.1590173125861;
        Fri, 22 May 2020 11:45:25 -0700 (PDT)
Received: from qiushi.dtc.umn.edu (cs-kh5248-02-umh.cs.umn.edu. [128.101.106.4])
        by smtp.gmail.com with ESMTPSA id 13sm4012617ioo.23.2020.05.22.11.45.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 May 2020 11:45:25 -0700 (PDT)
From:   wu000273@umn.edu
To:     dhowells@redhat.com
Cc:     Markus.Elfring@web.de, davem@davemloft.net, kuba@kernel.org,
        linux-afs@lists.infradead.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kjlu@umn.edu, wu000273@umn.edu
Subject: [PATCH v3] rxrpc: fix a memory leak in rxkad_verify_response().
Date:   Fri, 22 May 2020 13:45:18 -0500
Message-Id: <20200522184518.26323-1-wu000273@umn.edu>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Qiushi Wu <wu000273@umn.edu>

A ticket was not released after a call of the function
“rxkad_decrypt_ticket” failed. Thus replace the jump target
“temporary_error_free_resp” by “temporary_error_free_ticket”.

Fixes: 8c2f826dc3631 ("rxrpc: Don't put crypto buffers on the stack")
Signed-off-by: Qiushi Wu <wu000273@umn.edu>
---
 net/rxrpc/rxkad.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/net/rxrpc/rxkad.c b/net/rxrpc/rxkad.c
index 098f1f9ec53b..52a24d4ef5d8 100644
--- a/net/rxrpc/rxkad.c
+++ b/net/rxrpc/rxkad.c
@@ -1148,7 +1148,7 @@ static int rxkad_verify_response(struct rxrpc_connection *conn,
 	ret = rxkad_decrypt_ticket(conn, skb, ticket, ticket_len, &session_key,
 				   &expiry, _abort_code);
 	if (ret < 0)
-		goto temporary_error_free_resp;
+		goto temporary_error_free_ticket;
 
 	/* use the session key from inside the ticket to decrypt the
 	 * response */
@@ -1230,7 +1230,6 @@ static int rxkad_verify_response(struct rxrpc_connection *conn,
 
 temporary_error_free_ticket:
 	kfree(ticket);
-temporary_error_free_resp:
 	kfree(response);
 temporary_error:
 	/* Ignore the response packet if we got a temporary error such as
-- 
2.17.1

