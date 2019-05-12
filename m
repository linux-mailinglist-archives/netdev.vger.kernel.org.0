Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BA0651ABD4
	for <lists+netdev@lfdr.de>; Sun, 12 May 2019 12:40:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726547AbfELKj4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 May 2019 06:39:56 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:39178 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726287AbfELKjz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 12 May 2019 06:39:55 -0400
Received: by mail-pg1-f195.google.com with SMTP id w22so5232848pgi.6;
        Sun, 12 May 2019 03:39:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:subject:message-id:mime-version:content-disposition
         :user-agent;
        bh=J+6QUVyYBF5lWD9wtMqwXAgFCRK24LyY/PhNjYfKEtg=;
        b=oNBJcmCxy2e7dI8WCDab4i09uYG7p6SRkZ3IbdviGVG4PmcIUMF4hP48LYGm+vG0+L
         DV/cH8CZdK3rFmptb/7FsjEKC6VQ3FMclm5ENAKfE3LlPWQyEmluNtoNuhIqT2qJO2nk
         jp32R21t0zfsN/PtpXhLY7JgcuzQytiBpfcBcTfLkrC8qpCheN341cgwbu/t+skQXU1K
         H2IFmSKf0/mFtcij3G2zjR9I3ikMFYia2tRpIJRCsBapMq/AC2ptNBlppkFuYoc+poBm
         2tvhvhHxoO56FIrfOaPXjavFRclVpeUijutiNGZwAxaERmNUbmXLcnkEaNR+f96T+AVL
         lTwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:subject:message-id:mime-version
         :content-disposition:user-agent;
        bh=J+6QUVyYBF5lWD9wtMqwXAgFCRK24LyY/PhNjYfKEtg=;
        b=rpiw5spPeNhTOFTHBsR9fTLe5IP4gk7KP+rklIaL7IlA3HDpHZvFuDjPaoutj5VXcy
         2Z6IXodXSk9xZ+/Ouc0gFkLuuDvciGEekCRWbd1hw0oow+akhBQ+FyOWNcu9blV7vSHT
         TXwB5PLzmouq7OmErGo+SX1trlOPmYgej7XffqJh9RB9Vegi1E465iMIuxl//Tb31Pt6
         PEgTTgBlkqxGX8uXfiFnBPo+xr15HGtzoDa9r5fDikdtJNhMYkiV22kD/Xjk+e3FNboH
         hjApRHPwa17dXVL5mqcY2T8/tH29ut76hxVHw394ifBq8LLh0fAN7m2J8jtKXK0B81ua
         lprQ==
X-Gm-Message-State: APjAAAWXx6OkahJfS/X/MN8vmZwX+OISHENXx3qonc82JHpY54LxPaG0
        wIDazqA4BQnV6CbgLTMVHAkCqrOI
X-Google-Smtp-Source: APXvYqwyHLvo5k0jx3qm/DuyeUygkLREdCFDAJbCQBBUOP+j3Ri2dRtUnGwVwlecsvSdPhp9R/DLDw==
X-Received: by 2002:a62:704a:: with SMTP id l71mr27005311pfc.32.1557657595183;
        Sun, 12 May 2019 03:39:55 -0700 (PDT)
Received: from hari-Inspiron-1545 ([183.83.92.73])
        by smtp.gmail.com with ESMTPSA id n18sm30463079pfi.48.2019.05.12.03.39.52
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 12 May 2019 03:39:54 -0700 (PDT)
Date:   Sun, 12 May 2019 16:09:49 +0530
From:   Hariprasad Kelam <hariprasad.kelam@gmail.com>
To:     Gerrit Renker <gerrit@erg.abdn.ac.uk>,
        "David S. Miller" <davem@davemloft.net>, dccp@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] net: dccp : proto: remove Unneeded variable "err"
Message-ID: <20190512103949.GA2554@hari-Inspiron-1545>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix below issue reported by coccicheck


net/dccp/proto.c:266:5-8: Unneeded variable: "err". Return "0" on line
310

Signed-off-by: Hariprasad Kelam <hariprasad.kelam@gmail.com>
---
 net/dccp/proto.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/net/dccp/proto.c b/net/dccp/proto.c
index 0e2f71a..5dd85ec 100644
--- a/net/dccp/proto.c
+++ b/net/dccp/proto.c
@@ -263,7 +263,6 @@ int dccp_disconnect(struct sock *sk, int flags)
 	struct inet_connection_sock *icsk = inet_csk(sk);
 	struct inet_sock *inet = inet_sk(sk);
 	struct dccp_sock *dp = dccp_sk(sk);
-	int err = 0;
 	const int old_state = sk->sk_state;
 
 	if (old_state != DCCP_CLOSED)
@@ -307,7 +306,7 @@ int dccp_disconnect(struct sock *sk, int flags)
 	WARN_ON(inet->inet_num && !icsk->icsk_bind_hash);
 
 	sk->sk_error_report(sk);
-	return err;
+	return 0;
 }
 
 EXPORT_SYMBOL_GPL(dccp_disconnect);
-- 
2.7.4

