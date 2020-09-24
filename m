Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B64A2766F4
	for <lists+netdev@lfdr.de>; Thu, 24 Sep 2020 05:23:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726853AbgIXDXJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Sep 2020 23:23:09 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:38292 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726830AbgIXDXC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Sep 2020 23:23:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1600917781;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=uSk+dGSTPng3PyMIpD4EMqwVnZmErlEbtinXKEMZdY4=;
        b=iHwPZ6uduLAKKwvGQI4CxS9hW1TguRM7cdICrRqHQlbrFQEga0lJ+CMS+AWhZwsjpi/RNy
        HMJ5iEEFb2tfDF+urelTOGyBg0wm9lWBcYuotby8x91dAB5CKMIZtVrby5ln/UxjmSLege
        S08byD5gF7AMoaFXgkul50o+6Gv6ma4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-348-qgw51roXPwiSFaUp1aH_EA-1; Wed, 23 Sep 2020 23:23:00 -0400
X-MC-Unique: qgw51roXPwiSFaUp1aH_EA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5840056BE2;
        Thu, 24 Sep 2020 03:22:58 +0000 (UTC)
Received: from jason-ThinkPad-X1-Carbon-6th.redhat.com (ovpn-13-193.pek2.redhat.com [10.72.13.193])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 935D355768;
        Thu, 24 Sep 2020 03:22:52 +0000 (UTC)
From:   Jason Wang <jasowang@redhat.com>
To:     mst@redhat.com, jasowang@redhat.com
Cc:     lulu@redhat.com, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, rob.miller@broadcom.com,
        lingshan.zhu@intel.com, eperezma@redhat.com, hanand@xilinx.com,
        mhabets@solarflare.com, eli@mellanox.com, amorenoz@redhat.com,
        maxime.coquelin@redhat.com, stefanha@redhat.com,
        sgarzare@redhat.com
Subject: [RFC PATCH 07/24] vdpa: add the missing comment for nvqs in struct vdpa_device
Date:   Thu, 24 Sep 2020 11:21:08 +0800
Message-Id: <20200924032125.18619-8-jasowang@redhat.com>
In-Reply-To: <20200924032125.18619-1-jasowang@redhat.com>
References: <20200924032125.18619-1-jasowang@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Signed-off-by: Jason Wang <jasowang@redhat.com>
---
 include/linux/vdpa.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/linux/vdpa.h b/include/linux/vdpa.h
index eae0bfd87d91..df169c2f5c0f 100644
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
2.20.1

