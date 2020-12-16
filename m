Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 31C582DBB83
	for <lists+netdev@lfdr.de>; Wed, 16 Dec 2020 07:52:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725995AbgLPGub (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Dec 2020 01:50:31 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:42942 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725965AbgLPGua (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Dec 2020 01:50:30 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1608101344;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=OCpFJHzFOUB7YnBg/2IvgvLAbT/39ZulfkDLFxkV2t4=;
        b=LRkTT60snfONVQ/6mlAFmZMHnZdPT7HJPDD6wVAKeDH9Ej6AXWHblt4NGRht3ZQjL99UER
        /cUORvvrm/GWCOV3PI2wjDvuGMoTGz/TYLbnd3vVeYjC9FWyuWMYDTg5I82pBjP2YWYCq9
        IYQH6I5l8VZBhEIrz08Y8/vgjQoQ9H4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-243-LW9D0RszNPaOFYyDaolB_g-1; Wed, 16 Dec 2020 01:49:01 -0500
X-MC-Unique: LW9D0RszNPaOFYyDaolB_g-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 268E059;
        Wed, 16 Dec 2020 06:49:00 +0000 (UTC)
Received: from jason-ThinkPad-X1-Carbon-6th.redhat.com (ovpn-12-210.pek2.redhat.com [10.72.12.210])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1627A10013C1;
        Wed, 16 Dec 2020 06:48:55 +0000 (UTC)
From:   Jason Wang <jasowang@redhat.com>
To:     mst@redhat.com, jasowang@redhat.com
Cc:     eperezma@redhat.com, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, lulu@redhat.com, eli@mellanox.com,
        lingshan.zhu@intel.com, rob.miller@broadcom.com,
        stefanha@redhat.com, sgarzare@redhat.com
Subject: [PATCH 05/21] vdpa: add the missing comment for nvqs in struct vdpa_device
Date:   Wed, 16 Dec 2020 14:48:02 +0800
Message-Id: <20201216064818.48239-6-jasowang@redhat.com>
In-Reply-To: <20201216064818.48239-1-jasowang@redhat.com>
References: <20201216064818.48239-1-jasowang@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Signed-off-by: Jason Wang <jasowang@redhat.com>
---
 include/linux/vdpa.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/linux/vdpa.h b/include/linux/vdpa.h
index 30bc7a7223bb..8ab8dcde705d 100644
--- a/include/linux/vdpa.h
+++ b/include/linux/vdpa.h
@@ -42,6 +42,7 @@ struct vdpa_vq_state {
  * @config: the configuration ops for this device.
  * @index: device index
  * @features_valid: were features initialized? for legacy guests
+ * @nvqs: the number of virtqueues
  */
 struct vdpa_device {
 	struct device dev;
-- 
2.25.1

