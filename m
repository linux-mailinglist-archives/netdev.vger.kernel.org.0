Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E75D1DDF16
	for <lists+netdev@lfdr.de>; Fri, 22 May 2020 07:01:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728153AbgEVFBt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 May 2020 01:01:49 -0400
Received: from mta-p6.oit.umn.edu ([134.84.196.206]:50102 "EHLO
        mta-p6.oit.umn.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726666AbgEVFBs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 May 2020 01:01:48 -0400
Received: from localhost (unknown [127.0.0.1])
        by mta-p6.oit.umn.edu (Postfix) with ESMTP id 49SvV35CsHz9vcJn
        for <netdev@vger.kernel.org>; Fri, 22 May 2020 05:01:47 +0000 (UTC)
X-Virus-Scanned: amavisd-new at umn.edu
Received: from mta-p6.oit.umn.edu ([127.0.0.1])
        by localhost (mta-p6.oit.umn.edu [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id DM95lpFw109s for <netdev@vger.kernel.org>;
        Fri, 22 May 2020 00:01:47 -0500 (CDT)
Received: from mail-il1-f198.google.com (mail-il1-f198.google.com [209.85.166.198])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mta-p6.oit.umn.edu (Postfix) with ESMTPS id 49SvV33dyqz9vcJj
        for <netdev@vger.kernel.org>; Fri, 22 May 2020 00:01:47 -0500 (CDT)
DMARC-Filter: OpenDMARC Filter v1.3.2 mta-p6.oit.umn.edu 49SvV33dyqz9vcJj
DKIM-Filter: OpenDKIM Filter v2.11.0 mta-p6.oit.umn.edu 49SvV33dyqz9vcJj
Received: by mail-il1-f198.google.com with SMTP id w65so7626676ilk.14
        for <netdev@vger.kernel.org>; Thu, 21 May 2020 22:01:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=umn.edu; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=PKNUiHK9Hb2/cZzi/FocwTzEpdCaBMxhZnTs6WEbQRc=;
        b=gWX3bduAFtQnUWf4ap1h8sk1OX5aCUOFhenEC65fDEcuw0mzrWt7+M/2t9/aT6ngJx
         FPG41a5BJlAn4XgSJhybY1ScsSJlTC0GDZle/ROvDwB4jLLlaIpbrS0WfOuK49m/5RUf
         dL/SFr5MUX4bccLA4bq0cI/6bCIXHTU6ex/XQVljmGEA1fe1uHs5NXGgRZ4TSRTOYWru
         /jWxkuujky6gBYrdUGVqAnS41Rfl/XB7aUQtyGjb24wyvsP8oDqkupEaI4IlkGrR1s/z
         2pyACcHa65CN2/L2UzLNFDS0b/EFgy6C2DSUXk0GBahpk05QffxLGjb7mMkhsd3vuoJG
         QwCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=PKNUiHK9Hb2/cZzi/FocwTzEpdCaBMxhZnTs6WEbQRc=;
        b=afkhA4WMcXt97YA9TfIoWZjR7e/R4mFNP0kcCXCvLuanKIAvnyLF56b8kWQDY33SpU
         Z+PnxzImq6TqjKi4+njKapgNwN3yc6sbuo6CMusCwI/GaXcQnpxLulVv7Njm/km8NJ5J
         BG73RFWJOI6DmaMJFAjo3WrdoV6Jn8z5n7Q1qd3tME1JejULxIfK+5BreReFEbehxNnY
         6WDXd0DUjHb+1mdzuO6AzArrnZdkGbYtFgC+a4tyRJMPueyy7GnYqIXJDMTSzGxV32V4
         EvUn3ue00aYF5J8V9DnngkS9Dwesj9w0qvjo937IHOQpObOgQOYxX/k44T6Y8pyrfw2l
         h2sA==
X-Gm-Message-State: AOAM530rXJ7gXA9bxPnKCitMO50NG3UCGQcZ6TkBkLfWa1h8oqK0GEsx
        uEKB37vLk6eu+a5KPqAe/zWUlhtssEvfHbHJPo83mBTm98q0qeTZaPEBjuCNVzkG+90mm8Y1UFh
        I/XdrAS32IVrja3fFAoZ6
X-Received: by 2002:a02:54ca:: with SMTP id t193mr7007998jaa.26.1590123706718;
        Thu, 21 May 2020 22:01:46 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzJwmNLYhrE/pUNUnqwv/haakA9gU7GWmulh8h6dkVQOIh2qLlZbtTntT/fT/VGWj/bte33nA==
X-Received: by 2002:a02:54ca:: with SMTP id t193mr7007970jaa.26.1590123706362;
        Thu, 21 May 2020 22:01:46 -0700 (PDT)
Received: from qiushi.dtc.umn.edu (cs-kh5248-02-umh.cs.umn.edu. [128.101.106.4])
        by smtp.gmail.com with ESMTPSA id l16sm3998886ils.64.2020.05.21.22.01.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 May 2020 22:01:45 -0700 (PDT)
From:   wu000273@umn.edu
To:     dhowells@redhat.com
Cc:     davem@davemloft.net, kuba@kernel.org,
        linux-afs@lists.infradead.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, kjlu@umn.edu, wu000273@umn.edu
Subject: [PATCH] rxrpc: fix a memory leak bug.
Date:   Fri, 22 May 2020 00:01:29 -0500
Message-Id: <20200522050129.30148-1-wu000273@umn.edu>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Qiushi Wu <wu000273@umn.edu>

In function rxkad_verify_response(), pointer "ticket" is not released,
when function rxkad_decrypt_ticket() returns an error, causing a
memory leak bug.

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

