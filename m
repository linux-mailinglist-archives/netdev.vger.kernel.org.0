Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ECD2138B723
	for <lists+netdev@lfdr.de>; Thu, 20 May 2021 21:17:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238711AbhETTSf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 May 2021 15:18:35 -0400
Received: from mx12.kaspersky-labs.com ([91.103.66.155]:53247 "EHLO
        mx12.kaspersky-labs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239034AbhETTSZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 May 2021 15:18:25 -0400
Received: from relay12.kaspersky-labs.com (unknown [127.0.0.10])
        by relay12.kaspersky-labs.com (Postfix) with ESMTP id EB0D57840B;
        Thu, 20 May 2021 22:17:00 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kaspersky.com;
        s=mail202102; t=1621538221;
        bh=niwQJAGy4HqQp2CPR0PYJM2g2+eSFOkJIfWiwuf5OpI=;
        h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type;
        b=ziWTek96fcZLZQ4aK/R+FEdxYJKlijXKg8hrkSAcA8tyKaM1KcTArN7rK39S0SIMv
         7o/ZFWKFk/nANjSfSNW/10W3IDecjWB8CFVeH+U7td7C6T8rrEnf4aZaL046ypWbZz
         99urX2JQMa4hSnD4HeaInFcaP7g3FurNkn1qjXRHS4Cs2t4bThATSR6xqbCZQYwftI
         qH4ItMROU8HcoLDEzIHegztGosJ7ASlPRSwMbiAx2w9D1GwUkkcO+6+KFHmLN9vb+Q
         /Mj26hGsc7H28pwv55wtUCOchfo7UscyA9fXrzACELU8O9uI0tqM4eZgrLYEk6d2hp
         LOZBDY+lclnHw==
Received: from mail-hq2.kaspersky.com (unknown [91.103.66.206])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (Client CN "mail-hq2.kaspersky.com", Issuer "Kaspersky MailRelays CA G3" (verified OK))
        by mailhub12.kaspersky-labs.com (Postfix) with ESMTPS id A4535783DC;
        Thu, 20 May 2021 22:17:00 +0300 (MSK)
Received: from arseniy-pc.avp.ru (10.64.68.128) by hqmailmbx3.avp.ru
 (10.64.67.243) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2176.14; Thu, 20
 May 2021 22:16:59 +0300
From:   Arseny Krasnov <arseny.krasnov@kaspersky.com>
To:     Stefan Hajnoczi <stefanha@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Arseny Krasnov <arseny.krasnov@kaspersky.com>,
        Jorgen Hansen <jhansen@vmware.com>,
        Andra Paraschiv <andraprs@amazon.com>,
        Colin Ian King <colin.king@canonical.com>,
        Norbert Slusarek <nslusarek@gmx.net>
CC:     <kvm@vger.kernel.org>, <virtualization@lists.linux-foundation.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <oxffffaa@gmail.com>
Subject: [PATCH v10 07/18] af_vsock: update comments for stream sockets
Date:   Thu, 20 May 2021 22:16:51 +0300
Message-ID: <20210520191655.1271540-1-arseny.krasnov@kaspersky.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210520191357.1270473-1-arseny.krasnov@kaspersky.com>
References: <20210520191357.1270473-1-arseny.krasnov@kaspersky.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.64.68.128]
X-ClientProxiedBy: hqmailmbx2.avp.ru (10.64.67.242) To hqmailmbx3.avp.ru
 (10.64.67.243)
X-KSE-ServerInfo: hqmailmbx3.avp.ru, 9
X-KSE-AntiSpam-Interceptor-Info: scan successful
X-KSE-AntiSpam-Version: 5.9.20, Database issued on: 05/20/2021 18:58:27
X-KSE-AntiSpam-Status: KAS_STATUS_NOT_DETECTED
X-KSE-AntiSpam-Method: none
X-KSE-AntiSpam-Rate: 10
X-KSE-AntiSpam-Info: Lua profiles 163818 [May 20 2021]
X-KSE-AntiSpam-Info: Version: 5.9.20.0
X-KSE-AntiSpam-Info: Envelope from: arseny.krasnov@kaspersky.com
X-KSE-AntiSpam-Info: LuaCore: 446 446 0309aa129ce7cd9d810f87a68320917ac2eba541
X-KSE-AntiSpam-Info: {Prob_from_in_msgid}
X-KSE-AntiSpam-Info: {Tracking_from_domain_doesnt_match_to}
X-KSE-AntiSpam-Info: d41d8cd98f00b204e9800998ecf8427e.com:7.1.1;arseniy-pc.avp.ru:7.1.1;kaspersky.com:7.1.1;127.0.0.199:7.1.2
X-KSE-AntiSpam-Info: Rate: 10
X-KSE-AntiSpam-Info: Status: not_detected
X-KSE-AntiSpam-Info: Method: none
X-KSE-Antiphishing-Info: Clean
X-KSE-Antiphishing-ScanningType: Deterministic
X-KSE-Antiphishing-Method: None
X-KSE-Antiphishing-Bases: 05/20/2021 19:01:00
X-KSE-AttachmentFiltering-Interceptor-Info: no applicable attachment filtering
 rules found
X-KSE-Antivirus-Interceptor-Info: scan successful
X-KSE-Antivirus-Info: Clean, bases: 20.05.2021 14:47:00
X-KSE-BulkMessagesFiltering-Scan-Result: InTheLimit
X-KSE-AttachmentFiltering-Interceptor-Info: no applicable attachment filtering
 rules found
X-KSE-BulkMessagesFiltering-Scan-Result: InTheLimit
X-KLMS-Rule-ID: 52
X-KLMS-Message-Action: clean
X-KLMS-AntiSpam-Status: not scanned, disabled by settings
X-KLMS-AntiSpam-Interceptor-Info: not scanned
X-KLMS-AntiPhishing: Clean, bases: 2021/05/20 17:27:00
X-KLMS-AntiVirus: Kaspersky Security for Linux Mail Server, version 8.0.3.30, bases: 2021/05/20 14:47:00 #16622423
X-KLMS-AntiVirus-Status: Clean, skipped
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Replace 'stream' to 'connection oriented' in comments as
SEQPACKET is also connection oriented.

Signed-off-by: Arseny Krasnov <arseny.krasnov@kaspersky.com>
Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>
---
 net/vmw_vsock/af_vsock.c | 31 +++++++++++++++++--------------
 1 file changed, 17 insertions(+), 14 deletions(-)

diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
index eac3861d01cc..e657f433b2d7 100644
--- a/net/vmw_vsock/af_vsock.c
+++ b/net/vmw_vsock/af_vsock.c
@@ -415,8 +415,8 @@ static void vsock_deassign_transport(struct vsock_sock *vsk)
 
 /* Assign a transport to a socket and call the .init transport callback.
  *
- * Note: for stream socket this must be called when vsk->remote_addr is set
- * (e.g. during the connect() or when a connection request on a listener
+ * Note: for connection oriented socket this must be called when vsk->remote_addr
+ * is set (e.g. during the connect() or when a connection request on a listener
  * socket is received).
  * The vsk->remote_addr is used to decide which transport to use:
  *  - remote CID == VMADDR_CID_LOCAL or g2h->local_cid or VMADDR_CID_HOST if
@@ -470,10 +470,10 @@ int vsock_assign_transport(struct vsock_sock *vsk, struct vsock_sock *psk)
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
@@ -658,9 +658,10 @@ static int __vsock_bind_connectible(struct vsock_sock *vsk,
 
 	vsock_addr_init(&vsk->local_addr, new_addr.svm_cid, new_addr.svm_port);
 
-	/* Remove stream sockets from the unbound list and add them to the hash
-	 * table for easy lookup by its address.  The unbound list is simply an
-	 * extra entry at the end of the hash table, a trick used by AF_UNIX.
+	/* Remove connection oriented sockets from the unbound list and add them
+	 * to the hash table for easy lookup by its address.  The unbound list
+	 * is simply an extra entry at the end of the hash table, a trick used
+	 * by AF_UNIX.
 	 */
 	__vsock_remove_bound(vsk);
 	__vsock_insert_bound(vsock_bound_sockets(&vsk->local_addr), vsk);
@@ -952,10 +953,10 @@ static int vsock_shutdown(struct socket *sock, int mode)
 	if ((mode & ~SHUTDOWN_MASK) || !mode)
 		return -EINVAL;
 
-	/* If this is a STREAM socket and it is not connected then bail out
-	 * immediately.  If it is a DGRAM socket then we must first kick the
-	 * socket so that it wakes up from any sleeping calls, for example
-	 * recv(), and then afterwards return the error.
+	/* If this is a connection oriented socket and it is not connected then
+	 * bail out immediately.  If it is a DGRAM socket then we must first
+	 * kick the socket so that it wakes up from any sleeping calls, for
+	 * example recv(), and then afterwards return the error.
 	 */
 
 	sk = sock->sk;
@@ -1727,7 +1728,9 @@ static int vsock_connectible_sendmsg(struct socket *sock, struct msghdr *msg,
 
 	transport = vsk->transport;
 
-	/* Callers should not provide a destination with stream sockets. */
+	/* Callers should not provide a destination with connection oriented
+	 * sockets.
+	 */
 	if (msg->msg_namelen) {
 		err = sk->sk_state == TCP_ESTABLISHED ? -EISCONN : -EOPNOTSUPP;
 		goto out;
-- 
2.25.1

