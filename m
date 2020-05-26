Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E68411E2764
	for <lists+netdev@lfdr.de>; Tue, 26 May 2020 18:46:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388339AbgEZQqN convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 26 May 2020 12:46:13 -0400
Received: from eu-smtp-delivery-151.mimecast.com ([146.101.78.151]:56859 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2388845AbgEZQqM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 May 2020 12:46:12 -0400
Received: from AcuMS.aculab.com (156.67.243.126 [156.67.243.126]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-63-v9y8bZD-MCq9wvEoCVuLLA-1; Tue, 26 May 2020 17:40:01 +0100
X-MC-Unique: v9y8bZD-MCq9wvEoCVuLLA-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) with Microsoft SMTP
 Server (TLS) id 15.0.1347.2; Tue, 26 May 2020 17:40:01 +0100
Received: from AcuMS.Aculab.com ([fe80::43c:695e:880f:8750]) by
 AcuMS.aculab.com ([fe80::43c:695e:880f:8750%12]) with mapi id 15.00.1347.000;
 Tue, 26 May 2020 17:40:01 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Vlad Yasevich' <vyasevich@gmail.com>,
        'Neil Horman' <nhorman@tuxdriver.com>,
        "'David S. Miller'" <davem@davemloft.net>,
        "'Jakub Kicinski'" <kuba@kernel.org>,
        "'linux-sctp@vger.kernel.org'" <linux-sctp@vger.kernel.org>,
        "'netdev@vger.kernel.org'" <netdev@vger.kernel.org>,
        'Christoph Hellwig' <hch@lst.de>,
        "'Marcelo Ricardo Leitner'" <marcelo.leitner@gmail.com>
Subject: [PATCH v3 net-next 8/8] sctp: setsockopt, whitespace changes
Thread-Topic: [PATCH v3 net-next 8/8] sctp: setsockopt, whitespace changes
Thread-Index: AdYzfBPccN+NsoA5RrGKK2rPMQR4xA==
Date:   Tue, 26 May 2020 16:40:01 +0000
Message-ID: <522c0d1d83ff44cba6786f7cc3ca6547@AcuMS.aculab.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.202.205.107]
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: aculab.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix alignment of ?: continued lines.

Signed-off-by: David Laight <david.laight@aculab.com>

---
 net/sctp/socket.c | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index 6d35ea3..4b89e5f 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -6304,7 +6304,7 @@ static int sctp_getsockopt_context(struct sock *sk, int len,
 		return -EINVAL;
 
 	params->assoc_value = asoc ? asoc->default_rcv_context
-				  : sctp_sk(sk)->default_rcv_context;
+				   : sctp_sk(sk)->default_rcv_context;
 
 	return 0;
 }
@@ -6789,7 +6789,7 @@ static int sctp_getsockopt_pr_supported(struct sock *sk, int len,
 	}
 
 	params->assoc_value = asoc ? asoc->peer.prsctp_capable
-				  : sctp_sk(sk)->ep->prsctp_enable;
+				   : sctp_sk(sk)->ep->prsctp_enable;
 
 	return 0;
 }
@@ -6924,7 +6924,7 @@ static int sctp_getsockopt_reconfig_supported(struct sock *sk, int len,
 		return -EINVAL;
 
 	params->assoc_value = asoc ? asoc->peer.reconf_capable
-				  : sctp_sk(sk)->ep->reconf_enable;
+				   : sctp_sk(sk)->ep->reconf_enable;
 
 	return 0;
 }
@@ -6943,7 +6943,7 @@ static int sctp_getsockopt_enable_strreset(struct sock *sk, int len,
 		return -EINVAL;
 
 	params->assoc_value = asoc ? asoc->strreset_enable
-				  : sctp_sk(sk)->ep->strreset_enable;
+				   : sctp_sk(sk)->ep->strreset_enable;
 
 	return 0;
 }
@@ -6962,7 +6962,7 @@ static int sctp_getsockopt_scheduler(struct sock *sk, int len,
 		return -EINVAL;
 
 	params->assoc_value = asoc ? sctp_sched_get_sched(asoc)
-				  : sctp_sk(sk)->default_ss;
+				   : sctp_sk(sk)->default_ss;
 
 	return 0;
 }
@@ -6997,7 +6997,7 @@ static int sctp_getsockopt_interleaving_supported(struct sock *sk, int len,
 		return -EINVAL;
 
 	params->assoc_value = asoc ? asoc->peer.intl_capable
-				  : sctp_sk(sk)->ep->intl_enable;
+				   : sctp_sk(sk)->ep->intl_enable;
 
 	return 0;
 }
@@ -7053,7 +7053,7 @@ static int sctp_getsockopt_asconf_supported(struct sock *sk, int len,
 		return -EINVAL;
 
 	params->assoc_value = asoc ? asoc->peer.asconf_capable
-				  : sctp_sk(sk)->ep->asconf_enable;
+				   : sctp_sk(sk)->ep->asconf_enable;
 
 	return 0;
 }
@@ -7072,7 +7072,7 @@ static int sctp_getsockopt_auth_supported(struct sock *sk, int len,
 		return -EINVAL;
 
 	params->assoc_value = asoc ? asoc->peer.auth_capable
-				  : sctp_sk(sk)->ep->auth_enable;
+				   : sctp_sk(sk)->ep->auth_enable;
 
 	return 0;
 }
@@ -7091,7 +7091,7 @@ static int sctp_getsockopt_ecn_supported(struct sock *sk, int len,
 		return -EINVAL;
 
 	params->assoc_value = asoc ? asoc->peer.ecn_capable
-				  : sctp_sk(sk)->ep->ecn_enable;
+				   : sctp_sk(sk)->ep->ecn_enable;
 
 	return 0;
 }
@@ -7110,7 +7110,7 @@ static int sctp_getsockopt_pf_expose(struct sock *sk, int len,
 		return -EINVAL;
 
 	params->assoc_value = asoc ? asoc->pf_expose
-				  : sctp_sk(sk)->pf_expose;
+				   : sctp_sk(sk)->pf_expose;
 
 	return 0;
 }
-- 
1.8.1.2

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)

