Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5D514626B8
	for <lists+netdev@lfdr.de>; Mon,  8 Jul 2019 18:57:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391590AbfGHQ5u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jul 2019 12:57:50 -0400
Received: from mail-pl1-f193.google.com ([209.85.214.193]:35364 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391585AbfGHQ5u (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Jul 2019 12:57:50 -0400
Received: by mail-pl1-f193.google.com with SMTP id w24so8575878plp.2;
        Mon, 08 Jul 2019 09:57:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :in-reply-to:references;
        bh=RAoKx9mz5JWp2hq7L9ozatzLp5ZOOuU3FDgxWeBPxPY=;
        b=LQmRIBrJY8zJpWTk3WW0d1wmUgqNCZcHBB1O+3a/qRdkfXNha46FAXQsyqA/fjv0yy
         6brqWThW0iN2Z2aOadDsM+ZP2Dbn72SOaOS5fg8VYbDXbpTuvYBnBp6fdekQNYkaibzS
         zlACctbxyJbSFtAdT1k9jE8fGosnET0LfmuJYFL/3TLblfiQyxsW6WmJ8z5PEMcY7+Ma
         1482yu7MisoJChrFwNORUv6UnEmZgle63OGNuay+RJUc4jfSZo9D3CVT9bBQ/xf0MnoW
         RSObXman/7GcY39jd5Im5l6GM4a1kbGxdwzc5c4LgSgL+FomaQMYVXeOQj43zl5DnRQC
         ZMaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:in-reply-to:references;
        bh=RAoKx9mz5JWp2hq7L9ozatzLp5ZOOuU3FDgxWeBPxPY=;
        b=Lq7KBi4byTGwRR+tguCgOm8IeV5WroXMEhMvJgHH7s+PHWQ4iKHKG8eeR2oiABhl/+
         wNLYwOHt0RuNTd7IXWxGLqF7Ee/T/lyLCQ1o1qSSq/l4y4k+wmk7NATxW6uEEfRxDlh3
         g6COpo5RT5E5dQV5X/v+ZceHnIiI8X2pzDi5bJXBIWUNyK91iPD48z8rlGDPVknWF2GB
         uQ38tbwFsLWa6JLj21E2hiAXoleZIwpUukiWlqKHqcf4+/IWcdZJZ8Ert4iDRKmFuYtP
         xMmO9pw6ret5kFsHOkT5NwGqXqKIsh4gyeQ/RAO1LzWwi71XKYtAg4pqCq8dDCNG+cdh
         v6EA==
X-Gm-Message-State: APjAAAVscOgiYC2/U7XaHa1ofsEbY6LqSZEaKLQiQk7Yr/ylf/nXDM8a
        djFTE2T1SYjvslIZ1WQhAt8LhaSU
X-Google-Smtp-Source: APXvYqycxnyqVdtSnefbWdOy/I5TI3BanY+9Kddp4TCrE4fVQya1pRGluKzq8QrodAtCtKABaLUr2w==
X-Received: by 2002:a17:902:2aa8:: with SMTP id j37mr25185331plb.316.1562605069636;
        Mon, 08 Jul 2019 09:57:49 -0700 (PDT)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id x1sm103348pjo.4.2019.07.08.09.57.48
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 08 Jul 2019 09:57:49 -0700 (PDT)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc:     Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>, davem@davemloft.net
Subject: [PATCH net-next 4/4] sctp: rename sp strm_interleave to ep intl_enable
Date:   Tue,  9 Jul 2019 00:57:07 +0800
Message-Id: <9143b75d086dbec5aed55e4ba49d90c781f45c9a.1562604972.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <acc7f14e1ddd65d0515074c030c63fd339261b46.1562604972.git.lucien.xin@gmail.com>
References: <cover.1562604972.git.lucien.xin@gmail.com>
 <988dac46cfecb6ae4fa21e40bf16da6faf3da6ab.1562604972.git.lucien.xin@gmail.com>
 <40a905e7b9733c7bdca74af31ab86586fbb91cd0.1562604972.git.lucien.xin@gmail.com>
 <acc7f14e1ddd65d0515074c030c63fd339261b46.1562604972.git.lucien.xin@gmail.com>
In-Reply-To: <cover.1562604972.git.lucien.xin@gmail.com>
References: <cover.1562604972.git.lucien.xin@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Like other endpoint features, strm_interleave should be moved to
sctp_endpoint and renamed to intl_enable.

Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 include/net/sctp/structs.h | 2 +-
 net/sctp/sm_make_chunk.c   | 4 ++--
 net/sctp/socket.c          | 8 ++++----
 3 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/include/net/sctp/structs.h b/include/net/sctp/structs.h
index c41b57b..ba5c4f6 100644
--- a/include/net/sctp/structs.h
+++ b/include/net/sctp/structs.h
@@ -219,7 +219,6 @@ struct sctp_sock {
 		disable_fragments:1,
 		v4mapped:1,
 		frag_interleave:1,
-		strm_interleave:1,
 		recvrcvinfo:1,
 		recvnxtinfo:1,
 		data_ready_signalled:1;
@@ -1324,6 +1323,7 @@ struct sctp_endpoint {
 	struct list_head endpoint_shared_keys;
 	__u16 active_key_id;
 	__u8  auth_enable:1,
+	      intl_enable:1,
 	      prsctp_enable:1,
 	      reconf_enable:1;
 
diff --git a/net/sctp/sm_make_chunk.c b/net/sctp/sm_make_chunk.c
index 31ab2c6..ed39396 100644
--- a/net/sctp/sm_make_chunk.c
+++ b/net/sctp/sm_make_chunk.c
@@ -269,7 +269,7 @@ struct sctp_chunk *sctp_make_init(const struct sctp_association *asoc,
 	if (sp->adaptation_ind)
 		chunksize += sizeof(aiparam);
 
-	if (sp->strm_interleave) {
+	if (asoc->ep->intl_enable) {
 		extensions[num_ext] = SCTP_CID_I_DATA;
 		num_ext += 1;
 	}
@@ -2027,7 +2027,7 @@ static void sctp_process_ext_param(struct sctp_association *asoc,
 				asoc->peer.asconf_capable = 1;
 			break;
 		case SCTP_CID_I_DATA:
-			if (sctp_sk(asoc->base.sk)->strm_interleave)
+			if (asoc->ep->intl_enable)
 				asoc->peer.intl_capable = 1;
 			break;
 		default:
diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index b679b61..0fc5b90 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -1913,7 +1913,7 @@ static int sctp_sendmsg_to_asoc(struct sctp_association *asoc,
 		if (err)
 			goto err;
 
-		if (sp->strm_interleave) {
+		if (asoc->ep->intl_enable) {
 			timeo = sock_sndtimeo(sk, 0);
 			err = sctp_wait_for_connect(asoc, &timeo);
 			if (err) {
@@ -3581,7 +3581,7 @@ static int sctp_setsockopt_fragment_interleave(struct sock *sk,
 	sctp_sk(sk)->frag_interleave = !!val;
 
 	if (!sctp_sk(sk)->frag_interleave)
-		sctp_sk(sk)->strm_interleave = 0;
+		sctp_sk(sk)->ep->intl_enable = 0;
 
 	return 0;
 }
@@ -4484,7 +4484,7 @@ static int sctp_setsockopt_interleaving_supported(struct sock *sk,
 		goto out;
 	}
 
-	sp->strm_interleave = !!params.assoc_value;
+	sp->ep->intl_enable = !!params.assoc_value;
 
 	retval = 0;
 
@@ -7711,7 +7711,7 @@ static int sctp_getsockopt_interleaving_supported(struct sock *sk, int len,
 	}
 
 	params.assoc_value = asoc ? asoc->peer.intl_capable
-				  : sctp_sk(sk)->strm_interleave;
+				  : sctp_sk(sk)->ep->intl_enable;
 
 	if (put_user(len, optlen))
 		goto out;
-- 
2.1.0

