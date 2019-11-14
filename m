Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EE594FC334
	for <lists+netdev@lfdr.de>; Thu, 14 Nov 2019 10:58:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727031AbfKNJ6X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Nov 2019 04:58:23 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:57015 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726973AbfKNJ6W (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Nov 2019 04:58:22 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1573725501;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=T07opPBgFn11XBnpdKhY17+fMXO1mCcxC+fDaB2l29U=;
        b=Kg0SaWGAiLlOBJLZ0jWaG/mtTIOp2MZZdABDmgbYgGDeYz/+XRzaM+tyXCcCupSRd7okJk
        VydnIjSVHKkdycscbXLPF3wbeBxGlh8dEtQzoh7xezFFRNc0vbhWtWSgEXskWH9mThjZ98
        sc7PGNXWLVUYCRQEX6WOfHJitoQMNKE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-417-zyyF1A3KPmWdcoN01oaIkg-1; Thu, 14 Nov 2019 04:58:19 -0500
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 79D591005509;
        Thu, 14 Nov 2019 09:58:17 +0000 (UTC)
Received: from steredhat.redhat.com (ovpn-117-81.ams2.redhat.com [10.36.117.81])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1F4FC165F6;
        Thu, 14 Nov 2019 09:58:08 +0000 (UTC)
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     netdev@vger.kernel.org
Cc:     Stephen Hemminger <sthemmin@microsoft.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Jorgen Hansen <jhansen@vmware.com>,
        Jason Wang <jasowang@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        Sasha Levin <sashal@kernel.org>,
        "K. Y. Srinivasan" <kys@microsoft.com>,
        Dexuan Cui <decui@microsoft.com>, linux-hyperv@vger.kernel.org
Subject: [PATCH net-next v2 03/15] vsock: remove include/linux/vm_sockets.h file
Date:   Thu, 14 Nov 2019 10:57:38 +0100
Message-Id: <20191114095750.59106-4-sgarzare@redhat.com>
In-Reply-To: <20191114095750.59106-1-sgarzare@redhat.com>
References: <20191114095750.59106-1-sgarzare@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-MC-Unique: zyyF1A3KPmWdcoN01oaIkg-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This header file now only includes the "uapi/linux/vm_sockets.h".
We can include directly it when needed.

Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>
Reviewed-by: Jorgen Hansen <jhansen@vmware.com>
Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
---
 include/linux/vm_sockets.h            | 13 -------------
 include/net/af_vsock.h                |  2 +-
 include/net/vsock_addr.h              |  2 +-
 net/vmw_vsock/vmci_transport_notify.h |  1 -
 4 files changed, 2 insertions(+), 16 deletions(-)
 delete mode 100644 include/linux/vm_sockets.h

diff --git a/include/linux/vm_sockets.h b/include/linux/vm_sockets.h
deleted file mode 100644
index 7dd899ccb920..000000000000
--- a/include/linux/vm_sockets.h
+++ /dev/null
@@ -1,13 +0,0 @@
-/* SPDX-License-Identifier: GPL-2.0-only */
-/*
- * VMware vSockets Driver
- *
- * Copyright (C) 2007-2013 VMware, Inc. All rights reserved.
- */
-
-#ifndef _VM_SOCKETS_H
-#define _VM_SOCKETS_H
-
-#include <uapi/linux/vm_sockets.h>
-
-#endif /* _VM_SOCKETS_H */
diff --git a/include/net/af_vsock.h b/include/net/af_vsock.h
index 80ea0f93d3f7..c660402b10f2 100644
--- a/include/net/af_vsock.h
+++ b/include/net/af_vsock.h
@@ -10,7 +10,7 @@
=20
 #include <linux/kernel.h>
 #include <linux/workqueue.h>
-#include <linux/vm_sockets.h>
+#include <uapi/linux/vm_sockets.h>
=20
 #include "vsock_addr.h"
=20
diff --git a/include/net/vsock_addr.h b/include/net/vsock_addr.h
index 57d2db5c4bdf..cf8cc140d68d 100644
--- a/include/net/vsock_addr.h
+++ b/include/net/vsock_addr.h
@@ -8,7 +8,7 @@
 #ifndef _VSOCK_ADDR_H_
 #define _VSOCK_ADDR_H_
=20
-#include <linux/vm_sockets.h>
+#include <uapi/linux/vm_sockets.h>
=20
 void vsock_addr_init(struct sockaddr_vm *addr, u32 cid, u32 port);
 int vsock_addr_validate(const struct sockaddr_vm *addr);
diff --git a/net/vmw_vsock/vmci_transport_notify.h b/net/vmw_vsock/vmci_tra=
nsport_notify.h
index 7843f08d4290..a1aa5a998c0e 100644
--- a/net/vmw_vsock/vmci_transport_notify.h
+++ b/net/vmw_vsock/vmci_transport_notify.h
@@ -11,7 +11,6 @@
 #include <linux/types.h>
 #include <linux/vmw_vmci_defs.h>
 #include <linux/vmw_vmci_api.h>
-#include <linux/vm_sockets.h>
=20
 #include "vmci_transport.h"
=20
--=20
2.21.0

