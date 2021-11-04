Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 060EA445AB5
	for <lists+netdev@lfdr.de>; Thu,  4 Nov 2021 20:54:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231849AbhKDT4x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Nov 2021 15:56:53 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:46968 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231586AbhKDT4v (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Nov 2021 15:56:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1636055651;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=pZ4zh7JFN0bP24GdpvWa6P0ZJ4uX4rr4lhECDZnnt44=;
        b=FRtSGZyOTvZnBnCJ20MytONuYRdREIWeMlWraEqHGE9xYeDJR2GTuZfmacWwGYfuQtjHcC
        0OfTDACl7z6hl61/h0ylzGfBBXoim6BJfsfI+h3nNckDkjJiQlDK4Me6NBmQ7gylAnaOhG
        SGNcSF+haajlm3DgBr6BRbqahhO+Ruk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-4-j_EoAV6yPfyGbwLUsBK6ow-1; Thu, 04 Nov 2021 15:53:04 -0400
X-MC-Unique: j_EoAV6yPfyGbwLUsBK6ow-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1E1BC80430D;
        Thu,  4 Nov 2021 19:53:03 +0000 (UTC)
Received: from eperezma.remote.csb (unknown [10.39.194.185])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 57FDB60BF1;
        Thu,  4 Nov 2021 19:52:52 +0000 (UTC)
From:   =?UTF-8?q?Eugenio=20P=C3=A9rez?= <eperezma@redhat.com>
To:     linux-kernel@vger.kernel.org
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org
Subject: [PATCH] vdpa: Mark vdpa_config_ops.get_vq_notification as optional
Date:   Thu,  4 Nov 2021 20:52:48 +0100
Message-Id: <20211104195248.2088904-1-eperezma@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Since vhost_vdpa_mmap checks for its existence before calling it.

Signed-off-by: Eugenio Pérez <eperezma@redhat.com>
---
 include/linux/vdpa.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/vdpa.h b/include/linux/vdpa.h
index c3011ccda430..0bdc7f785394 100644
--- a/include/linux/vdpa.h
+++ b/include/linux/vdpa.h
@@ -155,7 +155,7 @@ struct vdpa_map_file {
  *				@vdev: vdpa device
  *				@idx: virtqueue index
  *				@state: pointer to returned state (last_avail_idx)
- * @get_vq_notification:	Get the notification area for a virtqueue
+ * @get_vq_notification:	Get the notification area for a virtqueue (optional)
  *				@vdev: vdpa device
  *				@idx: virtqueue index
  *				Returns the notifcation area
-- 
2.27.0

