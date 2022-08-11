Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8401458FDC9
	for <lists+netdev@lfdr.de>; Thu, 11 Aug 2022 15:55:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235145AbiHKNyf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Aug 2022 09:54:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235166AbiHKNy3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Aug 2022 09:54:29 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 2FB95760E4
        for <netdev@vger.kernel.org>; Thu, 11 Aug 2022 06:54:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1660226067;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=7Qqan27qkIlEMWlFRm4oE0aMcqVLoB6Ybk+9lIy2V1I=;
        b=IHDfzQSBI+U3JM+DaqiETbYmdSGngP1WrOoDOfnAsYD8sgLpKia6fDteXMMJSgiRug9UhB
        NgPr/0CrnMvb5gkJaA+dTXjbuL6mbaD07W9gfIP8y8LEFYd8kegSVnEg19wzD8tQdGFunV
        jZfKSsXeF3Bn2BaBzUM74o+zYNP5v1s=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-221-pUYzMhu_Om-5Y3E5QtubUg-1; Thu, 11 Aug 2022 09:54:14 -0400
X-MC-Unique: pUYzMhu_Om-5Y3E5QtubUg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 727F9811E84;
        Thu, 11 Aug 2022 13:54:13 +0000 (UTC)
Received: from eperezma.remote.csb (unknown [10.39.192.231])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 6E21640D2827;
        Thu, 11 Aug 2022 13:54:08 +0000 (UTC)
From:   =?UTF-8?q?Eugenio=20P=C3=A9rez?= <eperezma@redhat.com>
To:     virtualization@lists.linux-foundation.org,
        Jason Wang <jasowang@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Cc:     ecree.xilinx@gmail.com, gautam.dawar@amd.com,
        Zhang Min <zhang.min9@zte.com.cn>, pabloc@xilinx.com,
        Piotr.Uminski@intel.com, Dan Carpenter <dan.carpenter@oracle.com>,
        tanuj.kamde@amd.com, Zhu Lingshan <lingshan.zhu@intel.com>,
        martinh@xilinx.com,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        lvivier@redhat.com, martinpo@xilinx.com, hanand@xilinx.com,
        Eli Cohen <elic@nvidia.com>, lulu@redhat.com,
        habetsm.xilinx@gmail.com, Parav Pandit <parav@nvidia.com>,
        Longpeng <longpeng2@huawei.com>,
        Wu Zongyong <wuzongyong@linux.alibaba.com>,
        Si-Wei Liu <si-wei.liu@oracle.com>,
        Stefano Garzarella <sgarzare@redhat.com>, dinang@xilinx.com,
        Xie Yongji <xieyongji@bytedance.com>
Subject: [PATCH v8 2/3] vdpa: Remove wrong doc of VHOST_VDPA_SUSPEND ioctl
Date:   Thu, 11 Aug 2022 15:53:52 +0200
Message-Id: <20220811135353.2549658-3-eperezma@redhat.com>
In-Reply-To: <20220811135353.2549658-1-eperezma@redhat.com>
References: <20220811135353.2549658-1-eperezma@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

It was a leftover from previous versions.

Signed-off-by: Eugenio Pérez <eperezma@redhat.com>
---
 include/linux/vdpa.h       |  2 +-
 include/uapi/linux/vhost.h | 15 +++++----------
 2 files changed, 6 insertions(+), 11 deletions(-)

diff --git a/include/linux/vdpa.h b/include/linux/vdpa.h
index d282f464d2f1..6c4e6ea7f7eb 100644
--- a/include/linux/vdpa.h
+++ b/include/linux/vdpa.h
@@ -218,7 +218,7 @@ struct vdpa_map_file {
  * @reset:			Reset device
  *				@vdev: vdpa device
  *				Returns integer: success (0) or error (< 0)
- * @suspend:			Suspend or resume the device (optional)
+ * @suspend:			Suspend the device (optional)
  *				@vdev: vdpa device
  *				Returns integer: success (0) or error (< 0)
  * @get_config_size:		Get the size of the configuration space includes
diff --git a/include/uapi/linux/vhost.h b/include/uapi/linux/vhost.h
index 6d9f45163155..89fcb2afe472 100644
--- a/include/uapi/linux/vhost.h
+++ b/include/uapi/linux/vhost.h
@@ -171,17 +171,12 @@
 #define VHOST_VDPA_SET_GROUP_ASID	_IOW(VHOST_VIRTIO, 0x7C, \
 					     struct vhost_vring_state)
 
-/* Suspend or resume a device so it does not process virtqueue requests anymore
+/* Suspend a device so it does not process virtqueue requests anymore
  *
- * After the return of ioctl with suspend != 0, the device must finish any
- * pending operations like in flight requests. It must also preserve all the
- * necessary state (the virtqueue vring base plus the possible device specific
- * states) that is required for restoring in the future. The device must not
- * change its configuration after that point.
- *
- * After the return of ioctl with suspend == 0, the device can continue
- * processing buffers as long as typical conditions are met (vq is enabled,
- * DRIVER_OK status bit is enabled, etc).
+ * After the return of ioctl the device must finish any pending operations. It
+ * must also preserve all the necessary state (the virtqueue vring base plus
+ * the possible device specific states) that is required for restoring in the
+ * future. The device must not change its configuration after that point.
  */
 #define VHOST_VDPA_SUSPEND		_IOW(VHOST_VIRTIO, 0x7D, int)
 
-- 
2.31.1

