Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3885F372B6E
	for <lists+netdev@lfdr.de>; Tue,  4 May 2021 15:54:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231360AbhEDNzs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 May 2021 09:55:48 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:40819 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231241AbhEDNzs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 May 2021 09:55:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1620136493;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=sYJMcb7M+srNSdjRHy6DuLOfiiwc1W8bmdN+X3kOy+Y=;
        b=KfJU34WkDIYRzlOtIbFrUgosQ9coFwRiTSvd6uBwRbkg9nYlgPIgY+imieoQuV5P50Bk1D
        nxrFw2lPx3opjwpg1IMjYYKEjchDUvhkoN4Ygn9X878G+C7iY+GFkc0ZiURP9JdvaiDWjN
        OK9fDCd/hhNsmb3KtpMvk0hpzg9VzA0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-232-TDqT2_DMPJ6x83Hqvy81cg-1; Tue, 04 May 2021 09:54:51 -0400
X-MC-Unique: TDqT2_DMPJ6x83Hqvy81cg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4C593107ACCA;
        Tue,  4 May 2021 13:54:50 +0000 (UTC)
Received: from steredhat.redhat.com (ovpn-114-107.ams2.redhat.com [10.36.114.107])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3CF7F10016F8;
        Tue,  4 May 2021 13:54:45 +0000 (UTC)
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     virtualization@lists.linux-foundation.org
Cc:     netdev@vger.kernel.org, Jason Wang <jasowang@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: [PATCH] vhost-iotlb: fix vhost_iotlb_del_range() documentation
Date:   Tue,  4 May 2021 15:54:44 +0200
Message-Id: <20210504135444.158716-1-sgarzare@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Trivial change for the vhost_iotlb_del_range() documentation,
fixing the function name in the comment block.

Discovered with `make C=2 M=drivers/vhost`:
../drivers/vhost/iotlb.c:92: warning: expecting prototype for vring_iotlb_del_range(). Prototype was for vhost_iotlb_del_range() instead

Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
---
 drivers/vhost/iotlb.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/vhost/iotlb.c b/drivers/vhost/iotlb.c
index 0fd3f87e913c..0582079e4bcc 100644
--- a/drivers/vhost/iotlb.c
+++ b/drivers/vhost/iotlb.c
@@ -83,7 +83,7 @@ int vhost_iotlb_add_range(struct vhost_iotlb *iotlb,
 EXPORT_SYMBOL_GPL(vhost_iotlb_add_range);
 
 /**
- * vring_iotlb_del_range - delete overlapped ranges from vhost IOTLB
+ * vhost_iotlb_del_range - delete overlapped ranges from vhost IOTLB
  * @iotlb: the IOTLB
  * @start: start of the IOVA range
  * @last: last of IOVA range
-- 
2.30.2

