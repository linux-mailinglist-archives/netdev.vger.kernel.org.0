Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E2A2C683379
	for <lists+netdev@lfdr.de>; Tue, 31 Jan 2023 18:14:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232050AbjAaROI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Jan 2023 12:14:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231985AbjAaROA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Jan 2023 12:14:00 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC4EDDA
        for <netdev@vger.kernel.org>; Tue, 31 Jan 2023 09:12:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1675185171;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=dxTPeh4PeZrg0wlJ9bxVQH6gwTkaP+xq+ZBRhr42d/w=;
        b=PxPLVGGtoQT59z8BeZZFWu2dAH5Olz96blvuBDdzsnwif0n3xbmapCytKU6lvxxZpeejzB
        mPe+Tt5Ngs+VfOyBf0D2udHdbijwkGtHCNcy0ieJAcJApOajfa30i1fl/TZX4rc7bKdgbB
        Eb9hhylFvmw1aJKJgOxfaTIkUqyDpFM=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-563-k-xyGQX_Ok255lsCQj9W-g-1; Tue, 31 Jan 2023 12:12:46 -0500
X-MC-Unique: k-xyGQX_Ok255lsCQj9W-g-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9B5F3802C16;
        Tue, 31 Jan 2023 17:12:36 +0000 (UTC)
Received: from warthog.procyon.org.uk.com (unknown [10.33.36.97])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 68A17112132D;
        Tue, 31 Jan 2023 17:12:35 +0000 (UTC)
From:   David Howells <dhowells@redhat.com>
To:     netdev@vger.kernel.org
Cc:     David Howells <dhowells@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Marc Dionne <marc.dionne@auristor.com>,
        linux-afs@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 03/13] rxrpc: Shrink the tabulation in the rxrpc trace header a bit
Date:   Tue, 31 Jan 2023 17:12:17 +0000
Message-Id: <20230131171227.3912130-4-dhowells@redhat.com>
In-Reply-To: <20230131171227.3912130-1-dhowells@redhat.com>
References: <20230131171227.3912130-1-dhowells@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Shrink the tabulation in the rxrpc trace header a bit to allow for fields
with long type names that have been removed.

Signed-off-by: David Howells <dhowells@redhat.com>
---
 include/trace/events/rxrpc.h | 196 +++++++++++++++++------------------
 1 file changed, 98 insertions(+), 98 deletions(-)

diff --git a/include/trace/events/rxrpc.h b/include/trace/events/rxrpc.h
index 788bfe7446d9..cdcadb1345dc 100644
--- a/include/trace/events/rxrpc.h
+++ b/include/trace/events/rxrpc.h
@@ -678,10 +678,10 @@ TRACE_EVENT(rxrpc_call,
 	    TP_ARGS(call_debug_id, ref, aux, why),
 
 	    TP_STRUCT__entry(
-		    __field(unsigned int,		call)
-		    __field(int,			ref)
-		    __field(int,			why)
-		    __field(unsigned long,		aux)
+		    __field(unsigned int,	call)
+		    __field(int,		ref)
+		    __field(int,		why)
+		    __field(unsigned long,	aux)
 			     ),
 
 	    TP_fast_assign(
@@ -753,8 +753,8 @@ TRACE_EVENT(rxrpc_rx_done,
 	    TP_ARGS(result, abort_code),
 
 	    TP_STRUCT__entry(
-		    __field(int,			result)
-		    __field(int,			abort_code)
+		    __field(int,	result)
+		    __field(int,	abort_code)
 			     ),
 
 	    TP_fast_assign(
@@ -867,10 +867,10 @@ TRACE_EVENT(rxrpc_rx_data,
 	    TP_ARGS(call, seq, serial, flags),
 
 	    TP_STRUCT__entry(
-		    __field(unsigned int,		call)
-		    __field(rxrpc_seq_t,		seq)
-		    __field(rxrpc_serial_t,		serial)
-		    __field(u8,				flags)
+		    __field(unsigned int,	call)
+		    __field(rxrpc_seq_t,	seq)
+		    __field(rxrpc_serial_t,	serial)
+		    __field(u8,			flags)
 			     ),
 
 	    TP_fast_assign(
@@ -895,13 +895,13 @@ TRACE_EVENT(rxrpc_rx_ack,
 	    TP_ARGS(call, serial, ack_serial, first, prev, reason, n_acks),
 
 	    TP_STRUCT__entry(
-		    __field(unsigned int,		call)
-		    __field(rxrpc_serial_t,		serial)
-		    __field(rxrpc_serial_t,		ack_serial)
-		    __field(rxrpc_seq_t,		first)
-		    __field(rxrpc_seq_t,		prev)
-		    __field(u8,				reason)
-		    __field(u8,				n_acks)
+		    __field(unsigned int,	call)
+		    __field(rxrpc_serial_t,	serial)
+		    __field(rxrpc_serial_t,	ack_serial)
+		    __field(rxrpc_seq_t,	first)
+		    __field(rxrpc_seq_t,	prev)
+		    __field(u8,			reason)
+		    __field(u8,			n_acks)
 			     ),
 
 	    TP_fast_assign(
@@ -931,9 +931,9 @@ TRACE_EVENT(rxrpc_rx_abort,
 	    TP_ARGS(call, serial, abort_code),
 
 	    TP_STRUCT__entry(
-		    __field(unsigned int,		call)
-		    __field(rxrpc_serial_t,		serial)
-		    __field(u32,			abort_code)
+		    __field(unsigned int,	call)
+		    __field(rxrpc_serial_t,	serial)
+		    __field(u32,		abort_code)
 			     ),
 
 	    TP_fast_assign(
@@ -955,11 +955,11 @@ TRACE_EVENT(rxrpc_rx_challenge,
 	    TP_ARGS(conn, serial, version, nonce, min_level),
 
 	    TP_STRUCT__entry(
-		    __field(unsigned int,		conn)
-		    __field(rxrpc_serial_t,		serial)
-		    __field(u32,			version)
-		    __field(u32,			nonce)
-		    __field(u32,			min_level)
+		    __field(unsigned int,	conn)
+		    __field(rxrpc_serial_t,	serial)
+		    __field(u32,		version)
+		    __field(u32,		nonce)
+		    __field(u32,		min_level)
 			     ),
 
 	    TP_fast_assign(
@@ -985,11 +985,11 @@ TRACE_EVENT(rxrpc_rx_response,
 	    TP_ARGS(conn, serial, version, kvno, ticket_len),
 
 	    TP_STRUCT__entry(
-		    __field(unsigned int,		conn)
-		    __field(rxrpc_serial_t,		serial)
-		    __field(u32,			version)
-		    __field(u32,			kvno)
-		    __field(u32,			ticket_len)
+		    __field(unsigned int,	conn)
+		    __field(rxrpc_serial_t,	serial)
+		    __field(u32,		version)
+		    __field(u32,		kvno)
+		    __field(u32,		ticket_len)
 			     ),
 
 	    TP_fast_assign(
@@ -1015,10 +1015,10 @@ TRACE_EVENT(rxrpc_rx_rwind_change,
 	    TP_ARGS(call, serial, rwind, wake),
 
 	    TP_STRUCT__entry(
-		    __field(unsigned int,		call)
-		    __field(rxrpc_serial_t,		serial)
-		    __field(u32,			rwind)
-		    __field(bool,			wake)
+		    __field(unsigned int,	call)
+		    __field(rxrpc_serial_t,	serial)
+		    __field(u32,		rwind)
+		    __field(bool,		wake)
 			     ),
 
 	    TP_fast_assign(
@@ -1074,14 +1074,14 @@ TRACE_EVENT(rxrpc_tx_data,
 	    TP_ARGS(call, seq, serial, flags, retrans, lose),
 
 	    TP_STRUCT__entry(
-		    __field(unsigned int,		call)
-		    __field(rxrpc_seq_t,		seq)
-		    __field(rxrpc_serial_t,		serial)
-		    __field(u32,			cid)
-		    __field(u32,			call_id)
-		    __field(u8,				flags)
-		    __field(bool,			retrans)
-		    __field(bool,			lose)
+		    __field(unsigned int,	call)
+		    __field(rxrpc_seq_t,	seq)
+		    __field(rxrpc_serial_t,	serial)
+		    __field(u32,		cid)
+		    __field(u32,		call_id)
+		    __field(u8,			flags)
+		    __field(bool,		retrans)
+		    __field(bool,		lose)
 			     ),
 
 	    TP_fast_assign(
@@ -1114,12 +1114,12 @@ TRACE_EVENT(rxrpc_tx_ack,
 	    TP_ARGS(call, serial, ack_first, ack_serial, reason, n_acks),
 
 	    TP_STRUCT__entry(
-		    __field(unsigned int,		call)
-		    __field(rxrpc_serial_t,		serial)
-		    __field(rxrpc_seq_t,		ack_first)
-		    __field(rxrpc_serial_t,		ack_serial)
-		    __field(u8,				reason)
-		    __field(u8,				n_acks)
+		    __field(unsigned int,	call)
+		    __field(rxrpc_serial_t,	serial)
+		    __field(rxrpc_seq_t,	ack_first)
+		    __field(rxrpc_serial_t,	ack_serial)
+		    __field(u8,			reason)
+		    __field(u8,			n_acks)
 			     ),
 
 	    TP_fast_assign(
@@ -1301,17 +1301,17 @@ TRACE_EVENT(rxrpc_timer,
 	    TP_ARGS(call, why, now),
 
 	    TP_STRUCT__entry(
-		    __field(unsigned int,			call)
-		    __field(enum rxrpc_timer_trace,		why)
-		    __field(long,				now)
-		    __field(long,				ack_at)
-		    __field(long,				ack_lost_at)
-		    __field(long,				resend_at)
-		    __field(long,				ping_at)
-		    __field(long,				expect_rx_by)
-		    __field(long,				expect_req_by)
-		    __field(long,				expect_term_by)
-		    __field(long,				timer)
+		    __field(unsigned int,		call)
+		    __field(enum rxrpc_timer_trace,	why)
+		    __field(long,			now)
+		    __field(long,			ack_at)
+		    __field(long,			ack_lost_at)
+		    __field(long,			resend_at)
+		    __field(long,			ping_at)
+		    __field(long,			expect_rx_by)
+		    __field(long,			expect_req_by)
+		    __field(long,			expect_term_by)
+		    __field(long,			timer)
 			     ),
 
 	    TP_fast_assign(
@@ -1345,16 +1345,16 @@ TRACE_EVENT(rxrpc_timer_expired,
 	    TP_ARGS(call, now),
 
 	    TP_STRUCT__entry(
-		    __field(unsigned int,			call)
-		    __field(long,				now)
-		    __field(long,				ack_at)
-		    __field(long,				ack_lost_at)
-		    __field(long,				resend_at)
-		    __field(long,				ping_at)
-		    __field(long,				expect_rx_by)
-		    __field(long,				expect_req_by)
-		    __field(long,				expect_term_by)
-		    __field(long,				timer)
+		    __field(unsigned int,	call)
+		    __field(long,		now)
+		    __field(long,		ack_at)
+		    __field(long,		ack_lost_at)
+		    __field(long,		resend_at)
+		    __field(long,		ping_at)
+		    __field(long,		expect_rx_by)
+		    __field(long,		expect_req_by)
+		    __field(long,		expect_term_by)
+		    __field(long,		timer)
 			     ),
 
 	    TP_fast_assign(
@@ -1491,9 +1491,9 @@ TRACE_EVENT(rxrpc_retransmit,
 	    TP_ARGS(call, seq, expiry),
 
 	    TP_STRUCT__entry(
-		    __field(unsigned int,		call)
-		    __field(rxrpc_seq_t,		seq)
-		    __field(s64,			expiry)
+		    __field(unsigned int,	call)
+		    __field(rxrpc_seq_t,	seq)
+		    __field(s64,		expiry)
 			     ),
 
 	    TP_fast_assign(
@@ -1559,14 +1559,14 @@ TRACE_EVENT(rxrpc_reset_cwnd,
 	    TP_ARGS(call, now),
 
 	    TP_STRUCT__entry(
-		    __field(unsigned int,			call)
-		    __field(enum rxrpc_congest_mode,		mode)
-		    __field(unsigned short,			cwnd)
-		    __field(unsigned short,			extra)
-		    __field(rxrpc_seq_t,			hard_ack)
-		    __field(rxrpc_seq_t,			prepared)
-		    __field(ktime_t,				since_last_tx)
-		    __field(bool,				has_data)
+		    __field(unsigned int,		call)
+		    __field(enum rxrpc_congest_mode,	mode)
+		    __field(unsigned short,		cwnd)
+		    __field(unsigned short,		extra)
+		    __field(rxrpc_seq_t,		hard_ack)
+		    __field(rxrpc_seq_t,		prepared)
+		    __field(ktime_t,			since_last_tx)
+		    __field(bool,			has_data)
 			     ),
 
 	    TP_fast_assign(
@@ -1597,8 +1597,8 @@ TRACE_EVENT(rxrpc_disconnect_call,
 	    TP_ARGS(call),
 
 	    TP_STRUCT__entry(
-		    __field(unsigned int,		call)
-		    __field(u32,			abort_code)
+		    __field(unsigned int,	call)
+		    __field(u32,		abort_code)
 			     ),
 
 	    TP_fast_assign(
@@ -1617,8 +1617,8 @@ TRACE_EVENT(rxrpc_improper_term,
 	    TP_ARGS(call),
 
 	    TP_STRUCT__entry(
-		    __field(unsigned int,		call)
-		    __field(u32,			abort_code)
+		    __field(unsigned int,	call)
+		    __field(u32,		abort_code)
 			     ),
 
 	    TP_fast_assign(
@@ -1666,10 +1666,10 @@ TRACE_EVENT(rxrpc_resend,
 	    TP_ARGS(call, ack),
 
 	    TP_STRUCT__entry(
-		    __field(unsigned int,		call)
-		    __field(rxrpc_seq_t,		seq)
-		    __field(rxrpc_seq_t,		transmitted)
-		    __field(rxrpc_serial_t,		ack_serial)
+		    __field(unsigned int,	call)
+		    __field(rxrpc_seq_t,	seq)
+		    __field(rxrpc_seq_t,	transmitted)
+		    __field(rxrpc_serial_t,	ack_serial)
 			     ),
 
 	    TP_fast_assign(
@@ -1749,13 +1749,13 @@ TRACE_EVENT(rxrpc_call_reset,
 	    TP_ARGS(call),
 
 	    TP_STRUCT__entry(
-		    __field(unsigned int,		debug_id)
-		    __field(u32,			cid)
-		    __field(u32,			call_id)
-		    __field(rxrpc_serial_t,		call_serial)
-		    __field(rxrpc_serial_t,		conn_serial)
-		    __field(rxrpc_seq_t,		tx_seq)
-		    __field(rxrpc_seq_t,		rx_seq)
+		    __field(unsigned int,	debug_id)
+		    __field(u32,		cid)
+		    __field(u32,		call_id)
+		    __field(rxrpc_serial_t,	call_serial)
+		    __field(rxrpc_serial_t,	conn_serial)
+		    __field(rxrpc_seq_t,	tx_seq)
+		    __field(rxrpc_seq_t,	rx_seq)
 			     ),
 
 	    TP_fast_assign(
@@ -1781,8 +1781,8 @@ TRACE_EVENT(rxrpc_notify_socket,
 	    TP_ARGS(debug_id, serial),
 
 	    TP_STRUCT__entry(
-		    __field(unsigned int,		debug_id)
-		    __field(rxrpc_serial_t,		serial)
+		    __field(unsigned int,	debug_id)
+		    __field(rxrpc_serial_t,	serial)
 			     ),
 
 	    TP_fast_assign(
@@ -1915,7 +1915,7 @@ TRACE_EVENT(rxrpc_call_poked,
 	    TP_ARGS(call),
 
 	    TP_STRUCT__entry(
-		    __field(unsigned int,		call_debug_id)
+		    __field(unsigned int,	call_debug_id)
 			     ),
 
 	    TP_fast_assign(

