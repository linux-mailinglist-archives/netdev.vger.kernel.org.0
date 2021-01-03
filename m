Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1586B2E8E08
	for <lists+netdev@lfdr.de>; Sun,  3 Jan 2021 21:05:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727822AbhACUFa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 3 Jan 2021 15:05:30 -0500
Received: from mx13.kaspersky-labs.com ([91.103.66.164]:15473 "EHLO
        mx13.kaspersky-labs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726504AbhACUF3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 3 Jan 2021 15:05:29 -0500
Received: from relay13.kaspersky-labs.com (unknown [127.0.0.10])
        by relay13.kaspersky-labs.com (Postfix) with ESMTP id 0C13F520CB3;
        Sun,  3 Jan 2021 23:04:45 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kaspersky.com;
        s=mail; t=1609704285;
        bh=qY+P85jixO4G3d+S1dw8yRB+I/VZZ2qm5kIhaDnRWzI=;
        h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type;
        b=ZHO8fVV7Pnh4ozcVoFmrJUeqTdi9NPcbaneYxfTg9wVKY0R3Y4uPMYwIN127VnlcS
         Bwea1zeVRhZc/ToYOmk9zmG8+v6BKtYwYjgJJtPVgmq2x+aWwSXQof+cSxjt3EpEZ8
         rsXz2Dauj2HWH81UOTMHDodjusc35HFDNcoJ/XKY=
Received: from mail-hq2.kaspersky.com (unknown [91.103.66.206])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (Client CN "mail-hq2.kaspersky.com", Issuer "Kaspersky MailRelays CA G3" (verified OK))
        by mailhub13.kaspersky-labs.com (Postfix) with ESMTPS id B5EC35211FB;
        Sun,  3 Jan 2021 23:04:44 +0300 (MSK)
Received: from arseniy-pc.avp.ru (10.64.64.121) by hqmailmbx3.avp.ru
 (10.64.67.243) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2044.4; Sun, 3 Jan
 2021 23:04:44 +0300
From:   Arseny Krasnov <arseny.krasnov@kaspersky.com>
To:     Stefan Hajnoczi <stefanha@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Colin Ian King <colin.king@canonical.com>,
        Jorgen Hansen <jhansen@vmware.com>,
        Arseniy Krasnov <oxffffaa@gmail.com>,
        Andra Paraschiv <andraprs@amazon.com>,
        Jeff Vander Stoep <jeffv@google.com>
CC:     <kvm@vger.kernel.org>, <virtualization@lists.linux-foundation.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <stsp2@yandex.ru>, <arseny.krasnov@kaspersky.com>
Subject: [PATCH 5/5] af_vsock: update comments for stream sockets.
Date:   Sun, 3 Jan 2021 23:04:36 +0300
Message-ID: <20210103200438.1956663-1-arseny.krasnov@kaspersky.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210103195454.1954169-1-arseny.krasnov@kaspersky.com>
References: <20210103195454.1954169-1-arseny.krasnov@kaspersky.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.64.64.121]
X-ClientProxiedBy: hqmailmbx3.avp.ru (10.64.67.243) To hqmailmbx3.avp.ru
 (10.64.67.243)
X-KSE-ServerInfo: hqmailmbx3.avp.ru, 9
X-KSE-AntiSpam-Interceptor-Info: scan successful
X-KSE-AntiSpam-Version: 5.9.16, Database issued on: 01/03/2021 19:48:25
X-KSE-AntiSpam-Status: KAS_STATUS_NOT_DETECTED
X-KSE-AntiSpam-Method: none
X-KSE-AntiSpam-Rate: 10
X-KSE-AntiSpam-Info: Lua profiles 160977 [Jan 03 2021]
X-KSE-AntiSpam-Info: LuaCore: 419 419 70b0c720f8ddd656e5f4eb4a4449cf8ce400df94
X-KSE-AntiSpam-Info: Version: 5.9.16.0
X-KSE-AntiSpam-Info: Envelope from: arseny.krasnov@kaspersky.com
X-KSE-AntiSpam-Info: {Prob_from_in_msgid}
X-KSE-AntiSpam-Info: {Tracking_date, dbl_space}
X-KSE-AntiSpam-Info: {Tracking_from_domain_doesnt_match_to}
X-KSE-AntiSpam-Info: 127.0.0.199:7.1.2;kaspersky.com:7.1.1;arseniy-pc.avp.ru:7.1.1;d41d8cd98f00b204e9800998ecf8427e.com:7.1.1
X-KSE-AntiSpam-Info: Rate: 10
X-KSE-AntiSpam-Info: Status: not_detected
X-KSE-AntiSpam-Info: Method: none
X-KSE-Antiphishing-Info: Clean
X-KSE-Antiphishing-ScanningType: Deterministic
X-KSE-Antiphishing-Method: None
X-KSE-Antiphishing-Bases: 01/03/2021 19:51:00
X-KSE-AttachmentFiltering-Interceptor-Info: no applicable attachment filtering
 rules found
X-KSE-Antivirus-Interceptor-Info: scan successful
X-KSE-Antivirus-Info: Clean, bases: 03.01.2021 18:13:00
X-KSE-BulkMessagesFiltering-Scan-Result: InTheLimit
X-KSE-AttachmentFiltering-Interceptor-Info: no applicable attachment filtering
 rules found
X-KSE-BulkMessagesFiltering-Scan-Result: InTheLimit
X-KLMS-Rule-ID: 52
X-KLMS-Message-Action: clean
X-KLMS-AntiSpam-Status: not scanned, disabled by settings
X-KLMS-AntiSpam-Interceptor-Info: not scanned
X-KLMS-AntiPhishing: Clean, bases: 2021/01/03 18:58:00
X-KLMS-AntiVirus: Kaspersky Security for Linux Mail Server, version 8.0.3.30, bases: 2021/01/03 18:13:00 #16005632
X-KLMS-AntiVirus-Status: Clean, skipped
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Arseniy Krasnov <oxffffaa@gmail.com>

	Replace 'stream' to 'connect oriented' as SOCK_SEQPACKET
support is also connect oriented.
---
 net/vmw_vsock/af_vsock.c | 31 +++++++++++++++++--------------
 1 file changed, 17 insertions(+), 14 deletions(-)

diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
index 30caad9815f7..063d428e9ec2 100644
--- a/net/vmw_vsock/af_vsock.c
+++ b/net/vmw_vsock/af_vsock.c
@@ -415,8 +415,8 @@ static void vsock_deassign_transport(struct vsock_sock *vsk)
 
 /* Assign a transport to a socket and call the .init transport callback.
  *
- * Note: for stream socket this must be called when vsk->remote_addr is set
- * (e.g. during the connect() or when a connection request on a listener
+ * Note: for connect oriented socket this must be called when vsk->remote_addr
+ * is set (e.g. during the connect() or when a connection request on a listener
  * socket is received).
  * The vsk->remote_addr is used to decide which transport to use:
  *  - remote CID == VMADDR_CID_LOCAL or g2h->local_cid or VMADDR_CID_HOST if
@@ -476,10 +476,10 @@ int vsock_assign_transport(struct vsock_sock *vsk, struct vsock_sock *psk)
 			return 0;
 
 		/* transport->release() must be called with sock lock acquired.
-		 * This path can only be taken during vsock_stream_connect(),
-		 * where we have already held the sock lock.
-		 * In the other cases, this function is called on a new socket
-		 * which is not assigned to any transport.
+		 * This path can only be taken during vsock_connect(), where we
+		 * have already held the sock lock. In the other cases, this
+		 * function is called on a new socket which is not assigned to
+		 * any transport.
 		 */
 		vsk->transport->release(vsk);
 		vsock_deassign_transport(vsk);
@@ -656,9 +656,10 @@ static int __vsock_bind_connectible(struct vsock_sock *vsk,
 
 	vsock_addr_init(&vsk->local_addr, new_addr.svm_cid, new_addr.svm_port);
 
-	/* Remove stream sockets from the unbound list and add them to the hash
-	 * table for easy lookup by its address.  The unbound list is simply an
-	 * extra entry at the end of the hash table, a trick used by AF_UNIX.
+	/* Remove connect oriented sockets from the unbound list and add them
+	 * to the hash table for easy lookup by its address.  The unbound list
+	 * is simply an extra entry at the end of the hash table, a trick used
+	 * by AF_UNIX.
 	 */
 	__vsock_remove_bound(vsk);
 	__vsock_insert_bound(vsock_bound_sockets(&vsk->local_addr), vsk);
@@ -949,10 +950,10 @@ static int vsock_shutdown(struct socket *sock, int mode)
 	if ((mode & ~SHUTDOWN_MASK) || !mode)
 		return -EINVAL;
 
-	/* If this is a STREAM socket and it is not connected then bail out
-	 * immediately.  If it is a DGRAM socket then we must first kick the
-	 * socket so that it wakes up from any sleeping calls, for example
-	 * recv(), and then afterwards return the error.
+	/* If this is a connect oriented socket and it is not connected then
+	 * bail out immediately.  If it is a DGRAM socket then we must first
+	 * kick the socket so that it wakes up from any sleeping calls, for
+	 * example recv(), and then afterwards return the error.
 	 */
 
 	sk = sock->sk;
@@ -1757,7 +1758,9 @@ static int vsock_connectible_sendmsg(struct socket *sock, struct msghdr *msg,
 
 	lock_sock(sk);
 
-	/* Callers should not provide a destination with stream sockets. */
+	/* Callers should not provide a destination with connect oriented
+	 * sockets.
+	 */
 	if (msg->msg_namelen) {
 		err = sk->sk_state == TCP_ESTABLISHED ? -EISCONN : -EOPNOTSUPP;
 		goto out;
-- 
2.25.1

