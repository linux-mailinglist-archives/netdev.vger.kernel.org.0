Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C528E4018A6
	for <lists+netdev@lfdr.de>; Mon,  6 Sep 2021 11:12:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241122AbhIFJNT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Sep 2021 05:13:19 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:23683 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S240727AbhIFJNS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Sep 2021 05:13:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1630919533;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=g7Vz7xsBycQVIBWbmyiFw6LYlCPl58bQ6OL/32Oz/04=;
        b=btkg78HvwgjGNnWSEWqJciA/S2lHggkGbRW0G6dcm8eUJAAnWYvhJcLy5sTkwtSBJXQQHI
        ZsJphNksy0wavnQS4+GAZzkBI9h/h3RlVmrhuDxsnn7ZazoqSxMe/Hun1qL3pqrzIQhDZI
        HtHDDWF9LsbvXLeifpneapjo+huia+Q=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-341-v5_BC4pzNhqyMg0DiVFx_Q-1; Mon, 06 Sep 2021 05:12:12 -0400
X-MC-Unique: v5_BC4pzNhqyMg0DiVFx_Q-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4776D801A93;
        Mon,  6 Sep 2021 09:12:11 +0000 (UTC)
Received: from steredhat.redhat.com (unknown [10.39.192.89])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 06EFB60861;
        Mon,  6 Sep 2021 09:12:00 +0000 (UTC)
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     netdev@vger.kernel.org, virtualization@lists.linux-foundation.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Dexuan Cui <decui@microsoft.com>, linux-kernel@vger.kernel.org,
        Jorgen Hansen <jhansen@vmware.com>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH] MAINTAINERS: add VM SOCKETS (AF_VSOCK) entry
Date:   Mon,  6 Sep 2021 11:11:59 +0200
Message-Id: <20210906091159.66181-1-sgarzare@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a new entry for VM Sockets (AF_VSOCK) that covers vsock core,
tests, and headers. Move some general vsock stuff from virtio-vsock
entry into this new more general vsock entry.

I've been reviewing and contributing for the last few years,
so I'm available to help maintain this code.

Cc: Dexuan Cui <decui@microsoft.com>
Cc: Jorgen Hansen <jhansen@vmware.com>
Cc: Stefan Hajnoczi <stefanha@redhat.com>
Suggested-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
---

Dexuan, Jorgen, Stefan, would you like to co-maintain or
be added as a reviewer?

Thanks,
Stefano
---
 MAINTAINERS | 20 +++++++++++++-------
 1 file changed, 13 insertions(+), 7 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 4278b389218e..12d535eabf95 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -19763,18 +19763,11 @@ L:	kvm@vger.kernel.org
 L:	virtualization@lists.linux-foundation.org
 L:	netdev@vger.kernel.org
 S:	Maintained
-F:	drivers/net/vsockmon.c
 F:	drivers/vhost/vsock.c
 F:	include/linux/virtio_vsock.h
 F:	include/uapi/linux/virtio_vsock.h
-F:	include/uapi/linux/vm_sockets_diag.h
-F:	include/uapi/linux/vsockmon.h
-F:	net/vmw_vsock/af_vsock_tap.c
-F:	net/vmw_vsock/diag.c
 F:	net/vmw_vsock/virtio_transport.c
 F:	net/vmw_vsock/virtio_transport_common.c
-F:	net/vmw_vsock/vsock_loopback.c
-F:	tools/testing/vsock/
 
 VIRTIO BLOCK AND SCSI DRIVERS
 M:	"Michael S. Tsirkin" <mst@redhat.com>
@@ -19970,6 +19963,19 @@ F:	drivers/staging/vme/
 F:	drivers/vme/
 F:	include/linux/vme*
 
+VM SOCKETS (AF_VSOCK)
+M:	Stefano Garzarella <sgarzare@redhat.com>
+L:	virtualization@lists.linux-foundation.org
+L:	netdev@vger.kernel.org
+S:	Maintained
+F:	drivers/net/vsockmon.c
+F:	include/net/af_vsock.h
+F:	include/uapi/linux/vm_sockets.h
+F:	include/uapi/linux/vm_sockets_diag.h
+F:	include/uapi/linux/vsockmon.h
+F:	net/vmw_vsock/
+F:	tools/testing/vsock/
+
 VMWARE BALLOON DRIVER
 M:	Nadav Amit <namit@vmware.com>
 M:	"VMware, Inc." <pv-drivers@vmware.com>
-- 
2.31.1

