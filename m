Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0D25C626B5
	for <lists+netdev@lfdr.de>; Mon,  8 Jul 2019 18:57:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391583AbfGHQ5p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jul 2019 12:57:45 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:42620 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726318AbfGHQ5p (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Jul 2019 12:57:45 -0400
Received: by mail-pg1-f196.google.com with SMTP id t132so7980152pgb.9;
        Mon, 08 Jul 2019 09:57:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :in-reply-to:references;
        bh=FGuvks4Nb/N1nZ4oOQYx8el0XJowxnu5ZBzEi0FZcmk=;
        b=b/nmKNvJigdzo6yQSIFqJWuzwAVE9qhG5DClwI/AVF9jQ/AKOoJeU4MV7Bp2K/bzAe
         A861NNzChOsCTMfWixj1tmgamweXk/PFvx2/lP4H9y1K8+rUQZEVeg3iWm6znS+6jLsv
         EUUgwd6MWyLMAB1MUYw/uSBJ2LVFRNCbPf0uB43aWtiN9BEKq3EuW9lGy8EIeyZeuU/O
         uBuiRDvxoG5hHFnRWVwsk8neD/SF0T1A1ipG1M2on4LrkD74wlwNtLSz6UCAS/gZfXHu
         gQD5YXDPSCJRIDfA3f34HIJB8ZvXfVuKVwNYwEZ7tt7rf9AWNX5QKTbABfGM4djVnpWL
         X8Kw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:in-reply-to:references;
        bh=FGuvks4Nb/N1nZ4oOQYx8el0XJowxnu5ZBzEi0FZcmk=;
        b=SCBERj3pxfH6BVJwn3/n80bcw1g/fdj6zLn0VXkTWs1p+qzrlJLi2sLfx7No/RXGqt
         zHIpLhKFDwVbAoVPtvon87/drmWXY/4LxXqh5tEkR+fK+pjLvZkxeU7CvTxN2QirMXdm
         qN/T18aHO83404uvKIuXpW5HlCI6hG19nm7NymuTmit0HS3Lz8V36nXY4PvhWNDxEDmp
         9Ww0VLir7X+WSZWzuxXNNhsVCGMXQsE6D9PBPEhuf883/nrfAndxFA3vrGo28SlmzPwc
         DAxWBektjwY8pz3+jPaDlNz/gBhgNLwZQbZXpkjE03ymrYxvtiCaT7bRTL0IqTQaxy1x
         Sy5Q==
X-Gm-Message-State: APjAAAUEXlW4kgUqpbRQ5qLi2Sa/0L4iPjh4bQL4JUxIoG2s96hPA1U1
        OhsoddndwohtHXUYiTYIZFX/Vc8A
X-Google-Smtp-Source: APXvYqxfh31ksvHXIMVPCFdA0LtuKMVWAx1SIuXIJpVe3ll6UkuzkbAAsVrn8V3T0SN4hnsJMcdh1Q==
X-Received: by 2002:a63:c203:: with SMTP id b3mr25425413pgd.450.1562605061304;
        Mon, 08 Jul 2019 09:57:41 -0700 (PDT)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id 65sm20247866pgf.30.2019.07.08.09.57.40
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 08 Jul 2019 09:57:40 -0700 (PDT)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc:     Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>, davem@davemloft.net
Subject: [PATCH net-next 3/4] sctp: rename asoc intl_enable to asoc peer.intl_capable
Date:   Tue,  9 Jul 2019 00:57:06 +0800
Message-Id: <acc7f14e1ddd65d0515074c030c63fd339261b46.1562604972.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <40a905e7b9733c7bdca74af31ab86586fbb91cd0.1562604972.git.lucien.xin@gmail.com>
References: <cover.1562604972.git.lucien.xin@gmail.com>
 <988dac46cfecb6ae4fa21e40bf16da6faf3da6ab.1562604972.git.lucien.xin@gmail.com>
 <40a905e7b9733c7bdca74af31ab86586fbb91cd0.1562604972.git.lucien.xin@gmail.com>
In-Reply-To: <cover.1562604972.git.lucien.xin@gmail.com>
References: <cover.1562604972.git.lucien.xin@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

To keep consistent with other asoc features, we move intl_enable
to peer.intl_capable in asoc.

Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 include/net/sctp/structs.h   | 33 +++++++++++++++++----------------
 net/sctp/sm_make_chunk.c     |  4 ++--
 net/sctp/socket.c            |  2 +-
 net/sctp/stream_interleave.c |  4 ++--
 net/sctp/stream_sched.c      |  2 +-
 5 files changed, 23 insertions(+), 22 deletions(-)

diff --git a/include/net/sctp/structs.h b/include/net/sctp/structs.h
index 7f35b8e..c41b57b 100644
--- a/include/net/sctp/structs.h
+++ b/include/net/sctp/structs.h
@@ -1679,28 +1679,30 @@ struct sctp_association {
 		__be16 addip_disabled_mask;
 
 		/* These are capabilities which our peer advertised.  */
-		__u8	ecn_capable:1,      /* Can peer do ECN? */
+		__u16	ecn_capable:1,      /* Can peer do ECN? */
 			ipv4_address:1,     /* Peer understands IPv4 addresses? */
 			ipv6_address:1,     /* Peer understands IPv6 addresses? */
 			hostname_address:1, /* Peer understands DNS addresses? */
 			asconf_capable:1,   /* Does peer support ADDIP? */
 			prsctp_capable:1,   /* Can peer do PR-SCTP? */
 			reconf_capable:1,   /* Can peer do RE-CONFIG? */
-			auth_capable:1;     /* Is peer doing SCTP-AUTH? */
-
-		/* sack_needed : This flag indicates if the next received
-		 *             : packet is to be responded to with a
-		 *             : SACK. This is initialized to 0.  When a packet
-		 *             : is received sack_cnt is incremented. If this value
-		 *             : reaches 2 or more, a SACK is sent and the
-		 *             : value is reset to 0. Note: This is used only
-		 *             : when no DATA chunks are received out of
-		 *             : order.  When DATA chunks are out of order,
-		 *             : SACK's are not delayed (see Section 6).
-		 */
-		__u8    sack_needed:1,     /* Do we need to sack the peer? */
+			intl_capable:1,     /* Can peer do INTERLEAVE */
+			auth_capable:1,     /* Is peer doing SCTP-AUTH? */
+			/* sack_needed:
+			 *   This flag indicates if the next received
+			 *   packet is to be responded to with a
+			 *   SACK. This is initialized to 0.  When a packet
+			 *   is received sack_cnt is incremented. If this value
+			 *   reaches 2 or more, a SACK is sent and the
+			 *   value is reset to 0. Note: This is used only
+			 *   when no DATA chunks are received out of
+			 *   order.  When DATA chunks are out of order,
+			 *   SACK's are not delayed (see Section 6).
+			 */
+			sack_needed:1,     /* Do we need to sack the peer? */
 			sack_generation:1,
 			zero_window_announced:1;
+
 		__u32	sack_cnt;
 
 		__u32   adaptation_ind;	 /* Adaptation Code point. */
@@ -2049,8 +2051,7 @@ struct sctp_association {
 
 	__u8 need_ecne:1,	/* Need to send an ECNE Chunk? */
 	     temp:1,		/* Is it a temporary association? */
-	     force_delay:1,
-	     intl_enable:1;
+	     force_delay:1;
 
 	__u8 strreset_enable;
 	__u8 strreset_outstanding; /* request param count on the fly */
diff --git a/net/sctp/sm_make_chunk.c b/net/sctp/sm_make_chunk.c
index 227bbac..31ab2c6 100644
--- a/net/sctp/sm_make_chunk.c
+++ b/net/sctp/sm_make_chunk.c
@@ -438,7 +438,7 @@ struct sctp_chunk *sctp_make_init_ack(const struct sctp_association *asoc,
 	if (sp->adaptation_ind)
 		chunksize += sizeof(aiparam);
 
-	if (asoc->intl_enable) {
+	if (asoc->peer.intl_capable) {
 		extensions[num_ext] = SCTP_CID_I_DATA;
 		num_ext += 1;
 	}
@@ -2028,7 +2028,7 @@ static void sctp_process_ext_param(struct sctp_association *asoc,
 			break;
 		case SCTP_CID_I_DATA:
 			if (sctp_sk(asoc->base.sk)->strm_interleave)
-				asoc->intl_enable = 1;
+				asoc->peer.intl_capable = 1;
 			break;
 		default:
 			break;
diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index da2a3c2..b679b61 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -7710,7 +7710,7 @@ static int sctp_getsockopt_interleaving_supported(struct sock *sk, int len,
 		goto out;
 	}
 
-	params.assoc_value = asoc ? asoc->intl_enable
+	params.assoc_value = asoc ? asoc->peer.intl_capable
 				  : sctp_sk(sk)->strm_interleave;
 
 	if (put_user(len, optlen))
diff --git a/net/sctp/stream_interleave.c b/net/sctp/stream_interleave.c
index afbf122..40c40be 100644
--- a/net/sctp/stream_interleave.c
+++ b/net/sctp/stream_interleave.c
@@ -1358,6 +1358,6 @@ void sctp_stream_interleave_init(struct sctp_stream *stream)
 	struct sctp_association *asoc;
 
 	asoc = container_of(stream, struct sctp_association, stream);
-	stream->si = asoc->intl_enable ? &sctp_stream_interleave_1
-				       : &sctp_stream_interleave_0;
+	stream->si = asoc->peer.intl_capable ? &sctp_stream_interleave_1
+					     : &sctp_stream_interleave_0;
 }
diff --git a/net/sctp/stream_sched.c b/net/sctp/stream_sched.c
index b8fa7ab..99e5f69 100644
--- a/net/sctp/stream_sched.c
+++ b/net/sctp/stream_sched.c
@@ -228,7 +228,7 @@ int sctp_sched_get_value(struct sctp_association *asoc, __u16 sid,
 void sctp_sched_dequeue_done(struct sctp_outq *q, struct sctp_chunk *ch)
 {
 	if (!list_is_last(&ch->frag_list, &ch->msg->chunks) &&
-	    !q->asoc->intl_enable) {
+	    !q->asoc->peer.intl_capable) {
 		struct sctp_stream_out *sout;
 		__u16 sid;
 
-- 
2.1.0

