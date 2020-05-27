Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 988641E3E38
	for <lists+netdev@lfdr.de>; Wed, 27 May 2020 12:00:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729668AbgE0KAN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 May 2020 06:00:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729660AbgE0KAM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 May 2020 06:00:12 -0400
Received: from mail-lf1-x144.google.com (mail-lf1-x144.google.com [IPv6:2a00:1450:4864:20::144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 307B3C061A0F;
        Wed, 27 May 2020 03:00:12 -0700 (PDT)
Received: by mail-lf1-x144.google.com with SMTP id 82so14112513lfh.2;
        Wed, 27 May 2020 03:00:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=bbRbY0KHq/DE+xFk5645tlp6NSa7U4JheXhifJETtOk=;
        b=dY2Hl6yz+u8UpWZluySalMS34lkd6sqP3T362dnhpLDzJCp/mW5Lgng/U9FbxmgLI0
         knpM5H3J7aBoPMWknfjyhUzp961K8AJqPIRMA3K0V4rEdSWnZXHR5Cwj376AMlWzkTeq
         PJ1RZJIONAMG8gi9GvLp4rLNBavViZ1+XyU/j3qIUwXxfy7npFFSL33ParXr3KC3d7rS
         Y5zr1TVVqtCd532tWpwyvUsOyTcq843ZErI+oXztfq+Nm23exJcxfvN7y606WUZHcO/Q
         zZ9PtgKt2v8PwgvB4nrbxqnMK6hFS38StFIha62CXIzTNNM2IUYQyJxSWhWXGpcHJYu7
         vDNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=bbRbY0KHq/DE+xFk5645tlp6NSa7U4JheXhifJETtOk=;
        b=kAj6qDXPXi+YvOS1Z7gGVW+/wk+gGcGug/T/vitdlz8EPZRWcIzoE2SscMindXN2tR
         gkwWc4BDpMAexNff6qrrsDL6Ok0gIYb2b1iRxXL9I+BEW/gXo6yfZS8nTV4mRMRvHskw
         nViQ/RkRGS3CRQxdj2dbUPSgYB+t+prTdlzToiRK6oZf3hZO0ybNpjA8LVPu1Colo1C2
         ECqjabdt7nYb9427Ri/BOm9wo9eDodot7vuZFijGvR+/b5GYq7WV14KJ3A5DhOBTQA0J
         tcnq2irH7zGE1ml1LJLR3SZh0Xas0rUsK53Qux+2YMpBQQvju3234plmDTvJUXX0iP5+
         xEWw==
X-Gm-Message-State: AOAM530zX2r4RocKaZYOMcq6C6ULgrDQjGmd23iFv8rAvrtFcvVGljDJ
        3f/r4SMERyQ3xN+VLaaq0sEB4qzcnhtlyQ==
X-Google-Smtp-Source: ABdhPJzjWDaSMoFOsQ2TplozOLoo5AwFO5OdvrTjJYl39AF9HfCDXhR+zx09AkYyl/7AkcHS6UWNfQ==
X-Received: by 2002:a19:8b06:: with SMTP id n6mr2676424lfd.66.1590573610386;
        Wed, 27 May 2020 03:00:10 -0700 (PDT)
Received: from bitter.drabanten.lan ([195.178.180.206])
        by smtp.gmail.com with ESMTPSA id x28sm599811ljd.53.2020.05.27.03.00.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 May 2020 03:00:09 -0700 (PDT)
From:   Jonas Falkevik <jonas.falkevik@gmail.com>
To:     marcelo.leitner@gmail.com, lucien.xin@gmail.com,
        nhorman@tuxdriver.com, vyasevich@gmail.com, davem@davemloft.net,
        kuba@kernel.org, linux-sctp@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Jonas Falkevik <jonas.falkevik@gmail.com>
Subject: [PATCH] sctp: fix typo sctp_ulpevent_nofity_peer_addr_change
Date:   Wed, 27 May 2020 11:59:43 +0200
Message-Id: <20200527095943.271140-1-jonas.falkevik@gmail.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

change typo in function name "nofity" to "notify"
sctp_ulpevent_nofity_peer_addr_change ->
sctp_ulpevent_notify_peer_addr_change

Signed-off-by: Jonas Falkevik <jonas.falkevik@gmail.com>
---
 include/net/sctp/ulpevent.h | 2 +-
 net/sctp/associola.c        | 8 ++++----
 net/sctp/ulpevent.c         | 2 +-
 3 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/include/net/sctp/ulpevent.h b/include/net/sctp/ulpevent.h
index 0b032b92da0b..994e984eef32 100644
--- a/include/net/sctp/ulpevent.h
+++ b/include/net/sctp/ulpevent.h
@@ -80,7 +80,7 @@ struct sctp_ulpevent *sctp_ulpevent_make_assoc_change(
 	struct sctp_chunk *chunk,
 	gfp_t gfp);
 
-void sctp_ulpevent_nofity_peer_addr_change(struct sctp_transport *transport,
+void sctp_ulpevent_notify_peer_addr_change(struct sctp_transport *transport,
 					   int state, int error);
 
 struct sctp_ulpevent *sctp_ulpevent_make_remote_error(
diff --git a/net/sctp/associola.c b/net/sctp/associola.c
index 437079a4883d..72315137d7e7 100644
--- a/net/sctp/associola.c
+++ b/net/sctp/associola.c
@@ -432,7 +432,7 @@ void sctp_assoc_set_primary(struct sctp_association *asoc,
 		changeover = 1 ;
 
 	asoc->peer.primary_path = transport;
-	sctp_ulpevent_nofity_peer_addr_change(transport,
+	sctp_ulpevent_notify_peer_addr_change(transport,
 					      SCTP_ADDR_MADE_PRIM, 0);
 
 	/* Set a default msg_name for events. */
@@ -574,7 +574,7 @@ void sctp_assoc_rm_peer(struct sctp_association *asoc,
 
 	asoc->peer.transport_count--;
 
-	sctp_ulpevent_nofity_peer_addr_change(peer, SCTP_ADDR_REMOVED, 0);
+	sctp_ulpevent_notify_peer_addr_change(peer, SCTP_ADDR_REMOVED, 0);
 	sctp_transport_free(peer);
 }
 
@@ -714,7 +714,7 @@ struct sctp_transport *sctp_assoc_add_peer(struct sctp_association *asoc,
 	list_add_tail_rcu(&peer->transports, &asoc->peer.transport_addr_list);
 	asoc->peer.transport_count++;
 
-	sctp_ulpevent_nofity_peer_addr_change(peer, SCTP_ADDR_ADDED, 0);
+	sctp_ulpevent_notify_peer_addr_change(peer, SCTP_ADDR_ADDED, 0);
 
 	/* If we do not yet have a primary path, set one.  */
 	if (!asoc->peer.primary_path) {
@@ -840,7 +840,7 @@ void sctp_assoc_control_transport(struct sctp_association *asoc,
 	 * to the user.
 	 */
 	if (ulp_notify)
-		sctp_ulpevent_nofity_peer_addr_change(transport,
+		sctp_ulpevent_notify_peer_addr_change(transport,
 						      spc_state, error);
 
 	/* Select new active and retran paths. */
diff --git a/net/sctp/ulpevent.c b/net/sctp/ulpevent.c
index 77d5c36a8991..0c3d2b4d7321 100644
--- a/net/sctp/ulpevent.c
+++ b/net/sctp/ulpevent.c
@@ -336,7 +336,7 @@ static struct sctp_ulpevent *sctp_ulpevent_make_peer_addr_change(
 	return NULL;
 }
 
-void sctp_ulpevent_nofity_peer_addr_change(struct sctp_transport *transport,
+void sctp_ulpevent_notify_peer_addr_change(struct sctp_transport *transport,
 					   int state, int error)
 {
 	struct sctp_association *asoc = transport->asoc;
-- 
2.25.4

