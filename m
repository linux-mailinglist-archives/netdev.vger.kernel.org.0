Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 81AFE683378
	for <lists+netdev@lfdr.de>; Tue, 31 Jan 2023 18:14:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232033AbjAaROE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Jan 2023 12:14:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231956AbjAaRN5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Jan 2023 12:13:57 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86942E384
        for <netdev@vger.kernel.org>; Tue, 31 Jan 2023 09:12:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1675185167;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=xTziKm5WZVt8AkyTOu0HOcS5EBqt7LaggQBNa8My0Wk=;
        b=SBZaybF5p2zBmVdm7+5DOke9prMd7gv7IuAt/N/pXgmYTePbMoR8S1WDIu43UrLGhUO3+l
        S8rKKljSZ5jj72xC2B5EZ0+621qOkLgBxlPE4Fe1adOKd8rrMg7MSq28NVsXayUN+DaTnU
        vOjfpi3Ao9D/+ol3GkiodJCwLwxBkd0=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-88-_-k0TnNAMROzm61lvjB2Yg-1; Tue, 31 Jan 2023 12:12:45 -0500
X-MC-Unique: _-k0TnNAMROzm61lvjB2Yg-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id AC67E3804502;
        Tue, 31 Jan 2023 17:12:34 +0000 (UTC)
Received: from warthog.procyon.org.uk.com (unknown [10.33.36.97])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 60286492C3E;
        Tue, 31 Jan 2023 17:12:33 +0000 (UTC)
From:   David Howells <dhowells@redhat.com>
To:     netdev@vger.kernel.org
Cc:     David Howells <dhowells@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Marc Dionne <marc.dionne@auristor.com>,
        linux-afs@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 02/13] rxrpc: Remove whitespace before ')' in trace header
Date:   Tue, 31 Jan 2023 17:12:16 +0000
Message-Id: <20230131171227.3912130-3-dhowells@redhat.com>
In-Reply-To: <20230131171227.3912130-1-dhowells@redhat.com>
References: <20230131171227.3912130-1-dhowells@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Work around checkpatch warnings in the rxrpc trace header by removing
whitespace before ')' on lines defining the trace record struct.

Signed-off-by: David Howells <dhowells@redhat.com>
---
 include/trace/events/rxrpc.h | 426 +++++++++++++++++------------------
 1 file changed, 213 insertions(+), 213 deletions(-)

diff --git a/include/trace/events/rxrpc.h b/include/trace/events/rxrpc.h
index 31524d605319..788bfe7446d9 100644
--- a/include/trace/events/rxrpc.h
+++ b/include/trace/events/rxrpc.h
@@ -552,10 +552,10 @@ TRACE_EVENT(rxrpc_local,
 	    TP_ARGS(local_debug_id, op, ref, usage),
 
 	    TP_STRUCT__entry(
-		    __field(unsigned int,	local		)
-		    __field(int,		op		)
-		    __field(int,		ref		)
-		    __field(int,		usage		)
+		    __field(unsigned int,	local)
+		    __field(int,		op)
+		    __field(int,		ref)
+		    __field(int,		usage)
 			     ),
 
 	    TP_fast_assign(
@@ -578,9 +578,9 @@ TRACE_EVENT(rxrpc_peer,
 	    TP_ARGS(peer_debug_id, ref, why),
 
 	    TP_STRUCT__entry(
-		    __field(unsigned int,	peer		)
-		    __field(int,		ref		)
-		    __field(enum rxrpc_peer_trace, why		)
+		    __field(unsigned int,	peer)
+		    __field(int,		ref)
+		    __field(enum rxrpc_peer_trace, why)
 			     ),
 
 	    TP_fast_assign(
@@ -601,9 +601,9 @@ TRACE_EVENT(rxrpc_bundle,
 	    TP_ARGS(bundle_debug_id, ref, why),
 
 	    TP_STRUCT__entry(
-		    __field(unsigned int,	bundle		)
-		    __field(int,		ref		)
-		    __field(int,		why		)
+		    __field(unsigned int,	bundle)
+		    __field(int,		ref)
+		    __field(int,		why)
 			     ),
 
 	    TP_fast_assign(
@@ -624,9 +624,9 @@ TRACE_EVENT(rxrpc_conn,
 	    TP_ARGS(conn_debug_id, ref, why),
 
 	    TP_STRUCT__entry(
-		    __field(unsigned int,	conn		)
-		    __field(int,		ref		)
-		    __field(int,		why		)
+		    __field(unsigned int,	conn)
+		    __field(int,		ref)
+		    __field(int,		why)
 			     ),
 
 	    TP_fast_assign(
@@ -648,11 +648,11 @@ TRACE_EVENT(rxrpc_client,
 	    TP_ARGS(conn, channel, op),
 
 	    TP_STRUCT__entry(
-		    __field(unsigned int,		conn		)
-		    __field(u32,			cid		)
-		    __field(int,			channel		)
-		    __field(int,			usage		)
-		    __field(enum rxrpc_client_trace,	op		)
+		    __field(unsigned int,		conn)
+		    __field(u32,			cid)
+		    __field(int,			channel)
+		    __field(int,			usage)
+		    __field(enum rxrpc_client_trace,	op)
 			     ),
 
 	    TP_fast_assign(
@@ -678,10 +678,10 @@ TRACE_EVENT(rxrpc_call,
 	    TP_ARGS(call_debug_id, ref, aux, why),
 
 	    TP_STRUCT__entry(
-		    __field(unsigned int,		call		)
-		    __field(int,			ref		)
-		    __field(int,			why		)
-		    __field(unsigned long,		aux		)
+		    __field(unsigned int,		call)
+		    __field(int,			ref)
+		    __field(int,			why)
+		    __field(unsigned long,		aux)
 			     ),
 
 	    TP_fast_assign(
@@ -705,10 +705,10 @@ TRACE_EVENT(rxrpc_skb,
 	    TP_ARGS(skb, usage, mod_count, why),
 
 	    TP_STRUCT__entry(
-		    __field(struct sk_buff *,		skb		)
-		    __field(int,			usage		)
-		    __field(int,			mod_count	)
-		    __field(enum rxrpc_skb_trace,	why		)
+		    __field(struct sk_buff *,		skb)
+		    __field(int,			usage)
+		    __field(int,			mod_count)
+		    __field(enum rxrpc_skb_trace,	why)
 			     ),
 
 	    TP_fast_assign(
@@ -731,7 +731,7 @@ TRACE_EVENT(rxrpc_rx_packet,
 	    TP_ARGS(sp),
 
 	    TP_STRUCT__entry(
-		    __field_struct(struct rxrpc_host_header,	hdr		)
+		    __field_struct(struct rxrpc_host_header,	hdr)
 			     ),
 
 	    TP_fast_assign(
@@ -753,8 +753,8 @@ TRACE_EVENT(rxrpc_rx_done,
 	    TP_ARGS(result, abort_code),
 
 	    TP_STRUCT__entry(
-		    __field(int,			result		)
-		    __field(int,			abort_code	)
+		    __field(int,			result)
+		    __field(int,			abort_code)
 			     ),
 
 	    TP_fast_assign(
@@ -772,13 +772,13 @@ TRACE_EVENT(rxrpc_abort,
 	    TP_ARGS(call_nr, why, cid, call_id, seq, abort_code, error),
 
 	    TP_STRUCT__entry(
-		    __field(unsigned int,		call_nr		)
-		    __field(enum rxrpc_abort_reason,	why		)
-		    __field(u32,			cid		)
-		    __field(u32,			call_id		)
-		    __field(rxrpc_seq_t,		seq		)
-		    __field(int,			abort_code	)
-		    __field(int,			error		)
+		    __field(unsigned int,		call_nr)
+		    __field(enum rxrpc_abort_reason,	why)
+		    __field(u32,			cid)
+		    __field(u32,			call_id)
+		    __field(rxrpc_seq_t,		seq)
+		    __field(int,			abort_code)
+		    __field(int,			error)
 			     ),
 
 	    TP_fast_assign(
@@ -804,10 +804,10 @@ TRACE_EVENT(rxrpc_call_complete,
 	    TP_ARGS(call),
 
 	    TP_STRUCT__entry(
-		    __field(unsigned int,		call		)
-		    __field(enum rxrpc_call_completion,	compl		)
-		    __field(int,			error		)
-		    __field(u32,			abort_code	)
+		    __field(unsigned int,		call)
+		    __field(enum rxrpc_call_completion,	compl)
+		    __field(int,			error)
+		    __field(u32,			abort_code)
 			     ),
 
 	    TP_fast_assign(
@@ -830,13 +830,13 @@ TRACE_EVENT(rxrpc_txqueue,
 	    TP_ARGS(call, why),
 
 	    TP_STRUCT__entry(
-		    __field(unsigned int,		call		)
-		    __field(enum rxrpc_txqueue_trace,	why		)
-		    __field(rxrpc_seq_t,		acks_hard_ack	)
-		    __field(rxrpc_seq_t,		tx_bottom	)
-		    __field(rxrpc_seq_t,		tx_top		)
-		    __field(rxrpc_seq_t,		tx_prepared	)
-		    __field(int,			tx_winsize	)
+		    __field(unsigned int,		call)
+		    __field(enum rxrpc_txqueue_trace,	why)
+		    __field(rxrpc_seq_t,		acks_hard_ack)
+		    __field(rxrpc_seq_t,		tx_bottom)
+		    __field(rxrpc_seq_t,		tx_top)
+		    __field(rxrpc_seq_t,		tx_prepared)
+		    __field(int,			tx_winsize)
 			     ),
 
 	    TP_fast_assign(
@@ -867,10 +867,10 @@ TRACE_EVENT(rxrpc_rx_data,
 	    TP_ARGS(call, seq, serial, flags),
 
 	    TP_STRUCT__entry(
-		    __field(unsigned int,		call		)
-		    __field(rxrpc_seq_t,		seq		)
-		    __field(rxrpc_serial_t,		serial		)
-		    __field(u8,				flags		)
+		    __field(unsigned int,		call)
+		    __field(rxrpc_seq_t,		seq)
+		    __field(rxrpc_serial_t,		serial)
+		    __field(u8,				flags)
 			     ),
 
 	    TP_fast_assign(
@@ -895,13 +895,13 @@ TRACE_EVENT(rxrpc_rx_ack,
 	    TP_ARGS(call, serial, ack_serial, first, prev, reason, n_acks),
 
 	    TP_STRUCT__entry(
-		    __field(unsigned int,		call		)
-		    __field(rxrpc_serial_t,		serial		)
-		    __field(rxrpc_serial_t,		ack_serial	)
-		    __field(rxrpc_seq_t,		first		)
-		    __field(rxrpc_seq_t,		prev		)
-		    __field(u8,				reason		)
-		    __field(u8,				n_acks		)
+		    __field(unsigned int,		call)
+		    __field(rxrpc_serial_t,		serial)
+		    __field(rxrpc_serial_t,		ack_serial)
+		    __field(rxrpc_seq_t,		first)
+		    __field(rxrpc_seq_t,		prev)
+		    __field(u8,				reason)
+		    __field(u8,				n_acks)
 			     ),
 
 	    TP_fast_assign(
@@ -931,9 +931,9 @@ TRACE_EVENT(rxrpc_rx_abort,
 	    TP_ARGS(call, serial, abort_code),
 
 	    TP_STRUCT__entry(
-		    __field(unsigned int,		call		)
-		    __field(rxrpc_serial_t,		serial		)
-		    __field(u32,			abort_code	)
+		    __field(unsigned int,		call)
+		    __field(rxrpc_serial_t,		serial)
+		    __field(u32,			abort_code)
 			     ),
 
 	    TP_fast_assign(
@@ -955,11 +955,11 @@ TRACE_EVENT(rxrpc_rx_challenge,
 	    TP_ARGS(conn, serial, version, nonce, min_level),
 
 	    TP_STRUCT__entry(
-		    __field(unsigned int,		conn		)
-		    __field(rxrpc_serial_t,		serial		)
-		    __field(u32,			version		)
-		    __field(u32,			nonce		)
-		    __field(u32,			min_level	)
+		    __field(unsigned int,		conn)
+		    __field(rxrpc_serial_t,		serial)
+		    __field(u32,			version)
+		    __field(u32,			nonce)
+		    __field(u32,			min_level)
 			     ),
 
 	    TP_fast_assign(
@@ -985,11 +985,11 @@ TRACE_EVENT(rxrpc_rx_response,
 	    TP_ARGS(conn, serial, version, kvno, ticket_len),
 
 	    TP_STRUCT__entry(
-		    __field(unsigned int,		conn		)
-		    __field(rxrpc_serial_t,		serial		)
-		    __field(u32,			version		)
-		    __field(u32,			kvno		)
-		    __field(u32,			ticket_len	)
+		    __field(unsigned int,		conn)
+		    __field(rxrpc_serial_t,		serial)
+		    __field(u32,			version)
+		    __field(u32,			kvno)
+		    __field(u32,			ticket_len)
 			     ),
 
 	    TP_fast_assign(
@@ -1015,10 +1015,10 @@ TRACE_EVENT(rxrpc_rx_rwind_change,
 	    TP_ARGS(call, serial, rwind, wake),
 
 	    TP_STRUCT__entry(
-		    __field(unsigned int,		call		)
-		    __field(rxrpc_serial_t,		serial		)
-		    __field(u32,			rwind		)
-		    __field(bool,			wake		)
+		    __field(unsigned int,		call)
+		    __field(rxrpc_serial_t,		serial)
+		    __field(u32,			rwind)
+		    __field(bool,			wake)
 			     ),
 
 	    TP_fast_assign(
@@ -1042,9 +1042,9 @@ TRACE_EVENT(rxrpc_tx_packet,
 	    TP_ARGS(call_id, whdr, where),
 
 	    TP_STRUCT__entry(
-		    __field(unsigned int,			call	)
-		    __field(enum rxrpc_tx_point,		where	)
-		    __field_struct(struct rxrpc_wire_header,	whdr	)
+		    __field(unsigned int,			call)
+		    __field(enum rxrpc_tx_point,		where)
+		    __field_struct(struct rxrpc_wire_header,	whdr)
 			     ),
 
 	    TP_fast_assign(
@@ -1074,14 +1074,14 @@ TRACE_EVENT(rxrpc_tx_data,
 	    TP_ARGS(call, seq, serial, flags, retrans, lose),
 
 	    TP_STRUCT__entry(
-		    __field(unsigned int,		call		)
-		    __field(rxrpc_seq_t,		seq		)
-		    __field(rxrpc_serial_t,		serial		)
-		    __field(u32,			cid		)
-		    __field(u32,			call_id		)
-		    __field(u8,				flags		)
-		    __field(bool,			retrans		)
-		    __field(bool,			lose		)
+		    __field(unsigned int,		call)
+		    __field(rxrpc_seq_t,		seq)
+		    __field(rxrpc_serial_t,		serial)
+		    __field(u32,			cid)
+		    __field(u32,			call_id)
+		    __field(u8,				flags)
+		    __field(bool,			retrans)
+		    __field(bool,			lose)
 			     ),
 
 	    TP_fast_assign(
@@ -1114,12 +1114,12 @@ TRACE_EVENT(rxrpc_tx_ack,
 	    TP_ARGS(call, serial, ack_first, ack_serial, reason, n_acks),
 
 	    TP_STRUCT__entry(
-		    __field(unsigned int,		call		)
-		    __field(rxrpc_serial_t,		serial		)
-		    __field(rxrpc_seq_t,		ack_first	)
-		    __field(rxrpc_serial_t,		ack_serial	)
-		    __field(u8,				reason		)
-		    __field(u8,				n_acks		)
+		    __field(unsigned int,		call)
+		    __field(rxrpc_serial_t,		serial)
+		    __field(rxrpc_seq_t,		ack_first)
+		    __field(rxrpc_serial_t,		ack_serial)
+		    __field(u8,				reason)
+		    __field(u8,				n_acks)
 			     ),
 
 	    TP_fast_assign(
@@ -1147,11 +1147,11 @@ TRACE_EVENT(rxrpc_receive,
 	    TP_ARGS(call, why, serial, seq),
 
 	    TP_STRUCT__entry(
-		    __field(unsigned int,		call		)
-		    __field(enum rxrpc_receive_trace,	why		)
-		    __field(rxrpc_serial_t,		serial		)
-		    __field(rxrpc_seq_t,		seq		)
-		    __field(u64,			window		)
+		    __field(unsigned int,		call)
+		    __field(enum rxrpc_receive_trace,	why)
+		    __field(rxrpc_serial_t,		serial)
+		    __field(rxrpc_seq_t,		seq)
+		    __field(u64,			window)
 			     ),
 
 	    TP_fast_assign(
@@ -1178,9 +1178,9 @@ TRACE_EVENT(rxrpc_recvmsg,
 	    TP_ARGS(call_debug_id, why, ret),
 
 	    TP_STRUCT__entry(
-		    __field(unsigned int,		call		)
-		    __field(enum rxrpc_recvmsg_trace,	why		)
-		    __field(int,			ret		)
+		    __field(unsigned int,		call)
+		    __field(enum rxrpc_recvmsg_trace,	why)
+		    __field(int,			ret)
 			     ),
 
 	    TP_fast_assign(
@@ -1203,12 +1203,12 @@ TRACE_EVENT(rxrpc_recvdata,
 	    TP_ARGS(call, why, seq, offset, len, ret),
 
 	    TP_STRUCT__entry(
-		    __field(unsigned int,		call		)
-		    __field(enum rxrpc_recvmsg_trace,	why		)
-		    __field(rxrpc_seq_t,		seq		)
-		    __field(unsigned int,		offset		)
-		    __field(unsigned int,		len		)
-		    __field(int,			ret		)
+		    __field(unsigned int,		call)
+		    __field(enum rxrpc_recvmsg_trace,	why)
+		    __field(rxrpc_seq_t,		seq)
+		    __field(unsigned int,		offset)
+		    __field(unsigned int,		len)
+		    __field(int,			ret)
 			     ),
 
 	    TP_fast_assign(
@@ -1236,10 +1236,10 @@ TRACE_EVENT(rxrpc_rtt_tx,
 	    TP_ARGS(call, why, slot, send_serial),
 
 	    TP_STRUCT__entry(
-		    __field(unsigned int,		call		)
-		    __field(enum rxrpc_rtt_tx_trace,	why		)
-		    __field(int,			slot		)
-		    __field(rxrpc_serial_t,		send_serial	)
+		    __field(unsigned int,		call)
+		    __field(enum rxrpc_rtt_tx_trace,	why)
+		    __field(int,			slot)
+		    __field(rxrpc_serial_t,		send_serial)
 			     ),
 
 	    TP_fast_assign(
@@ -1265,13 +1265,13 @@ TRACE_EVENT(rxrpc_rtt_rx,
 	    TP_ARGS(call, why, slot, send_serial, resp_serial, rtt, rto),
 
 	    TP_STRUCT__entry(
-		    __field(unsigned int,		call		)
-		    __field(enum rxrpc_rtt_rx_trace,	why		)
-		    __field(int,			slot		)
-		    __field(rxrpc_serial_t,		send_serial	)
-		    __field(rxrpc_serial_t,		resp_serial	)
-		    __field(u32,			rtt		)
-		    __field(u32,			rto		)
+		    __field(unsigned int,		call)
+		    __field(enum rxrpc_rtt_rx_trace,	why)
+		    __field(int,			slot)
+		    __field(rxrpc_serial_t,		send_serial)
+		    __field(rxrpc_serial_t,		resp_serial)
+		    __field(u32,			rtt)
+		    __field(u32,			rto)
 			     ),
 
 	    TP_fast_assign(
@@ -1301,17 +1301,17 @@ TRACE_EVENT(rxrpc_timer,
 	    TP_ARGS(call, why, now),
 
 	    TP_STRUCT__entry(
-		    __field(unsigned int,			call		)
-		    __field(enum rxrpc_timer_trace,		why		)
-		    __field(long,				now		)
-		    __field(long,				ack_at		)
-		    __field(long,				ack_lost_at	)
-		    __field(long,				resend_at	)
-		    __field(long,				ping_at		)
-		    __field(long,				expect_rx_by	)
-		    __field(long,				expect_req_by	)
-		    __field(long,				expect_term_by	)
-		    __field(long,				timer		)
+		    __field(unsigned int,			call)
+		    __field(enum rxrpc_timer_trace,		why)
+		    __field(long,				now)
+		    __field(long,				ack_at)
+		    __field(long,				ack_lost_at)
+		    __field(long,				resend_at)
+		    __field(long,				ping_at)
+		    __field(long,				expect_rx_by)
+		    __field(long,				expect_req_by)
+		    __field(long,				expect_term_by)
+		    __field(long,				timer)
 			     ),
 
 	    TP_fast_assign(
@@ -1345,16 +1345,16 @@ TRACE_EVENT(rxrpc_timer_expired,
 	    TP_ARGS(call, now),
 
 	    TP_STRUCT__entry(
-		    __field(unsigned int,			call		)
-		    __field(long,				now		)
-		    __field(long,				ack_at		)
-		    __field(long,				ack_lost_at	)
-		    __field(long,				resend_at	)
-		    __field(long,				ping_at		)
-		    __field(long,				expect_rx_by	)
-		    __field(long,				expect_req_by	)
-		    __field(long,				expect_term_by	)
-		    __field(long,				timer		)
+		    __field(unsigned int,			call)
+		    __field(long,				now)
+		    __field(long,				ack_at)
+		    __field(long,				ack_lost_at)
+		    __field(long,				resend_at)
+		    __field(long,				ping_at)
+		    __field(long,				expect_rx_by)
+		    __field(long,				expect_req_by)
+		    __field(long,				expect_term_by)
+		    __field(long,				timer)
 			     ),
 
 	    TP_fast_assign(
@@ -1386,7 +1386,7 @@ TRACE_EVENT(rxrpc_rx_lose,
 	    TP_ARGS(sp),
 
 	    TP_STRUCT__entry(
-		    __field_struct(struct rxrpc_host_header,	hdr		)
+		    __field_struct(struct rxrpc_host_header,	hdr)
 			     ),
 
 	    TP_fast_assign(
@@ -1409,10 +1409,10 @@ TRACE_EVENT(rxrpc_propose_ack,
 	    TP_ARGS(call, why, ack_reason, serial),
 
 	    TP_STRUCT__entry(
-		    __field(unsigned int,			call		)
-		    __field(enum rxrpc_propose_ack_trace,	why		)
-		    __field(rxrpc_serial_t,			serial		)
-		    __field(u8,					ack_reason	)
+		    __field(unsigned int,			call)
+		    __field(enum rxrpc_propose_ack_trace,	why)
+		    __field(rxrpc_serial_t,			serial)
+		    __field(u8,					ack_reason)
 			     ),
 
 	    TP_fast_assign(
@@ -1436,10 +1436,10 @@ TRACE_EVENT(rxrpc_send_ack,
 	    TP_ARGS(call, why, ack_reason, serial),
 
 	    TP_STRUCT__entry(
-		    __field(unsigned int,			call		)
-		    __field(enum rxrpc_propose_ack_trace,	why		)
-		    __field(rxrpc_serial_t,			serial		)
-		    __field(u8,					ack_reason	)
+		    __field(unsigned int,			call)
+		    __field(enum rxrpc_propose_ack_trace,	why)
+		    __field(rxrpc_serial_t,			serial)
+		    __field(u8,					ack_reason)
 			     ),
 
 	    TP_fast_assign(
@@ -1463,11 +1463,11 @@ TRACE_EVENT(rxrpc_drop_ack,
 	    TP_ARGS(call, why, ack_reason, serial, nobuf),
 
 	    TP_STRUCT__entry(
-		    __field(unsigned int,			call		)
-		    __field(enum rxrpc_propose_ack_trace,	why		)
-		    __field(rxrpc_serial_t,			serial		)
-		    __field(u8,					ack_reason	)
-		    __field(bool,				nobuf		)
+		    __field(unsigned int,			call)
+		    __field(enum rxrpc_propose_ack_trace,	why)
+		    __field(rxrpc_serial_t,			serial)
+		    __field(u8,					ack_reason)
+		    __field(bool,				nobuf)
 			     ),
 
 	    TP_fast_assign(
@@ -1491,9 +1491,9 @@ TRACE_EVENT(rxrpc_retransmit,
 	    TP_ARGS(call, seq, expiry),
 
 	    TP_STRUCT__entry(
-		    __field(unsigned int,		call		)
-		    __field(rxrpc_seq_t,		seq		)
-		    __field(s64,			expiry		)
+		    __field(unsigned int,		call)
+		    __field(rxrpc_seq_t,		seq)
+		    __field(s64,			expiry)
 			     ),
 
 	    TP_fast_assign(
@@ -1515,13 +1515,13 @@ TRACE_EVENT(rxrpc_congest,
 	    TP_ARGS(call, summary, ack_serial, change),
 
 	    TP_STRUCT__entry(
-		    __field(unsigned int,			call		)
-		    __field(enum rxrpc_congest_change,		change		)
-		    __field(rxrpc_seq_t,			hard_ack	)
-		    __field(rxrpc_seq_t,			top		)
-		    __field(rxrpc_seq_t,			lowest_nak	)
-		    __field(rxrpc_serial_t,			ack_serial	)
-		    __field_struct(struct rxrpc_ack_summary,	sum		)
+		    __field(unsigned int,			call)
+		    __field(enum rxrpc_congest_change,		change)
+		    __field(rxrpc_seq_t,			hard_ack)
+		    __field(rxrpc_seq_t,			top)
+		    __field(rxrpc_seq_t,			lowest_nak)
+		    __field(rxrpc_serial_t,			ack_serial)
+		    __field_struct(struct rxrpc_ack_summary,	sum)
 			     ),
 
 	    TP_fast_assign(
@@ -1559,14 +1559,14 @@ TRACE_EVENT(rxrpc_reset_cwnd,
 	    TP_ARGS(call, now),
 
 	    TP_STRUCT__entry(
-		    __field(unsigned int,			call		)
-		    __field(enum rxrpc_congest_mode,		mode		)
-		    __field(unsigned short,			cwnd		)
-		    __field(unsigned short,			extra		)
-		    __field(rxrpc_seq_t,			hard_ack	)
-		    __field(rxrpc_seq_t,			prepared	)
-		    __field(ktime_t,				since_last_tx	)
-		    __field(bool,				has_data	)
+		    __field(unsigned int,			call)
+		    __field(enum rxrpc_congest_mode,		mode)
+		    __field(unsigned short,			cwnd)
+		    __field(unsigned short,			extra)
+		    __field(rxrpc_seq_t,			hard_ack)
+		    __field(rxrpc_seq_t,			prepared)
+		    __field(ktime_t,				since_last_tx)
+		    __field(bool,				has_data)
 			     ),
 
 	    TP_fast_assign(
@@ -1597,8 +1597,8 @@ TRACE_EVENT(rxrpc_disconnect_call,
 	    TP_ARGS(call),
 
 	    TP_STRUCT__entry(
-		    __field(unsigned int,		call		)
-		    __field(u32,			abort_code	)
+		    __field(unsigned int,		call)
+		    __field(u32,			abort_code)
 			     ),
 
 	    TP_fast_assign(
@@ -1617,8 +1617,8 @@ TRACE_EVENT(rxrpc_improper_term,
 	    TP_ARGS(call),
 
 	    TP_STRUCT__entry(
-		    __field(unsigned int,		call		)
-		    __field(u32,			abort_code	)
+		    __field(unsigned int,		call)
+		    __field(u32,			abort_code)
 			     ),
 
 	    TP_fast_assign(
@@ -1637,11 +1637,11 @@ TRACE_EVENT(rxrpc_connect_call,
 	    TP_ARGS(call),
 
 	    TP_STRUCT__entry(
-		    __field(unsigned int,		call		)
-		    __field(unsigned long,		user_call_ID	)
-		    __field(u32,			cid		)
-		    __field(u32,			call_id		)
-		    __field_struct(struct sockaddr_rxrpc, srx		)
+		    __field(unsigned int,		call)
+		    __field(unsigned long,		user_call_ID)
+		    __field(u32,			cid)
+		    __field(u32,			call_id)
+		    __field_struct(struct sockaddr_rxrpc, srx)
 			     ),
 
 	    TP_fast_assign(
@@ -1666,10 +1666,10 @@ TRACE_EVENT(rxrpc_resend,
 	    TP_ARGS(call, ack),
 
 	    TP_STRUCT__entry(
-		    __field(unsigned int,		call		)
-		    __field(rxrpc_seq_t,		seq		)
-		    __field(rxrpc_seq_t,		transmitted	)
-		    __field(rxrpc_serial_t,		ack_serial	)
+		    __field(unsigned int,		call)
+		    __field(rxrpc_seq_t,		seq)
+		    __field(rxrpc_seq_t,		transmitted)
+		    __field(rxrpc_serial_t,		ack_serial)
 			     ),
 
 	    TP_fast_assign(
@@ -1694,9 +1694,9 @@ TRACE_EVENT(rxrpc_rx_icmp,
 	    TP_ARGS(peer, ee, srx),
 
 	    TP_STRUCT__entry(
-		    __field(unsigned int,			peer	)
-		    __field_struct(struct sock_extended_err,	ee	)
-		    __field_struct(struct sockaddr_rxrpc,	srx	)
+		    __field(unsigned int,			peer)
+		    __field_struct(struct sock_extended_err,	ee)
+		    __field_struct(struct sockaddr_rxrpc,	srx)
 			     ),
 
 	    TP_fast_assign(
@@ -1723,10 +1723,10 @@ TRACE_EVENT(rxrpc_tx_fail,
 	    TP_ARGS(debug_id, serial, ret, where),
 
 	    TP_STRUCT__entry(
-		    __field(unsigned int,		debug_id	)
-		    __field(rxrpc_serial_t,		serial		)
-		    __field(int,			ret		)
-		    __field(enum rxrpc_tx_point,	where		)
+		    __field(unsigned int,		debug_id)
+		    __field(rxrpc_serial_t,		serial)
+		    __field(int,			ret)
+		    __field(enum rxrpc_tx_point,	where)
 			     ),
 
 	    TP_fast_assign(
@@ -1749,13 +1749,13 @@ TRACE_EVENT(rxrpc_call_reset,
 	    TP_ARGS(call),
 
 	    TP_STRUCT__entry(
-		    __field(unsigned int,		debug_id	)
-		    __field(u32,			cid		)
-		    __field(u32,			call_id		)
-		    __field(rxrpc_serial_t,		call_serial	)
-		    __field(rxrpc_serial_t,		conn_serial	)
-		    __field(rxrpc_seq_t,		tx_seq		)
-		    __field(rxrpc_seq_t,		rx_seq		)
+		    __field(unsigned int,		debug_id)
+		    __field(u32,			cid)
+		    __field(u32,			call_id)
+		    __field(rxrpc_serial_t,		call_serial)
+		    __field(rxrpc_serial_t,		conn_serial)
+		    __field(rxrpc_seq_t,		tx_seq)
+		    __field(rxrpc_seq_t,		rx_seq)
 			     ),
 
 	    TP_fast_assign(
@@ -1781,8 +1781,8 @@ TRACE_EVENT(rxrpc_notify_socket,
 	    TP_ARGS(debug_id, serial),
 
 	    TP_STRUCT__entry(
-		    __field(unsigned int,		debug_id	)
-		    __field(rxrpc_serial_t,		serial		)
+		    __field(unsigned int,		debug_id)
+		    __field(rxrpc_serial_t,		serial)
 			     ),
 
 	    TP_fast_assign(
@@ -1804,8 +1804,8 @@ TRACE_EVENT(rxrpc_rx_discard_ack,
 		    prev_pkt, call_ackr_prev),
 
 	    TP_STRUCT__entry(
-		    __field(unsigned int,	debug_id	)
-		    __field(rxrpc_serial_t,	serial		)
+		    __field(unsigned int,	debug_id)
+		    __field(rxrpc_serial_t,	serial)
 		    __field(rxrpc_seq_t,	first_soft_ack)
 		    __field(rxrpc_seq_t,	call_ackr_first)
 		    __field(rxrpc_seq_t,	prev_pkt)
@@ -1837,9 +1837,9 @@ TRACE_EVENT(rxrpc_req_ack,
 	    TP_ARGS(call_debug_id, seq, why),
 
 	    TP_STRUCT__entry(
-		    __field(unsigned int,		call_debug_id	)
-		    __field(rxrpc_seq_t,		seq		)
-		    __field(enum rxrpc_req_ack_trace,	why		)
+		    __field(unsigned int,		call_debug_id)
+		    __field(rxrpc_seq_t,		seq)
+		    __field(enum rxrpc_req_ack_trace,	why)
 			     ),
 
 	    TP_fast_assign(
@@ -1862,11 +1862,11 @@ TRACE_EVENT(rxrpc_txbuf,
 	    TP_ARGS(debug_id, call_debug_id, seq, ref, what),
 
 	    TP_STRUCT__entry(
-		    __field(unsigned int,		debug_id	)
-		    __field(unsigned int,		call_debug_id	)
-		    __field(rxrpc_seq_t,		seq		)
-		    __field(int,			ref		)
-		    __field(enum rxrpc_txbuf_trace,	what		)
+		    __field(unsigned int,		debug_id)
+		    __field(unsigned int,		call_debug_id)
+		    __field(rxrpc_seq_t,		seq)
+		    __field(int,			ref)
+		    __field(enum rxrpc_txbuf_trace,	what)
 			     ),
 
 	    TP_fast_assign(
@@ -1892,9 +1892,9 @@ TRACE_EVENT(rxrpc_poke_call,
 	    TP_ARGS(call, busy, what),
 
 	    TP_STRUCT__entry(
-		    __field(unsigned int,		call_debug_id	)
-		    __field(bool,			busy		)
-		    __field(enum rxrpc_call_poke_trace,	what		)
+		    __field(unsigned int,		call_debug_id)
+		    __field(bool,			busy)
+		    __field(enum rxrpc_call_poke_trace,	what)
 			     ),
 
 	    TP_fast_assign(
@@ -1915,7 +1915,7 @@ TRACE_EVENT(rxrpc_call_poked,
 	    TP_ARGS(call),
 
 	    TP_STRUCT__entry(
-		    __field(unsigned int,		call_debug_id	)
+		    __field(unsigned int,		call_debug_id)
 			     ),
 
 	    TP_fast_assign(

