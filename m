Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 161F03C7D59
	for <lists+netdev@lfdr.de>; Wed, 14 Jul 2021 06:20:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237803AbhGNEXK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Jul 2021 00:23:10 -0400
Received: from smtprelay0246.hostedemail.com ([216.40.44.246]:37952 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S229712AbhGNEXJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Jul 2021 00:23:09 -0400
Received: from omf20.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay07.hostedemail.com (Postfix) with ESMTP id 8829C1844C6AC;
        Wed, 14 Jul 2021 04:20:17 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: joe@perches.com) by omf20.hostedemail.com (Postfix) with ESMTPA id A90B018A600;
        Wed, 14 Jul 2021 04:20:10 +0000 (UTC)
Message-ID: <8aa028a0117ecb51d209861f926a84ce74fe0c46.camel@perches.com>
Subject: Re: [PATCH v9 03/17] vdpa: Fix code indentation
From:   Joe Perches <joe@perches.com>
To:     Xie Yongji <xieyongji@bytedance.com>, mst@redhat.com,
        jasowang@redhat.com, stefanha@redhat.com, sgarzare@redhat.com,
        parav@nvidia.com, hch@infradead.org,
        christian.brauner@canonical.com, rdunlap@infradead.org,
        willy@infradead.org, viro@zeniv.linux.org.uk, axboe@kernel.dk,
        bcrl@kvack.org, corbet@lwn.net, mika.penttila@nextfour.com,
        dan.carpenter@oracle.com, joro@8bytes.org,
        gregkh@linuxfoundation.org, zhe.he@windriver.com,
        xiaodong.liu@intel.com
Cc:     songmuchun@bytedance.com,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Date:   Tue, 13 Jul 2021 21:20:09 -0700
In-Reply-To: <20210713084656.232-4-xieyongji@bytedance.com>
References: <20210713084656.232-1-xieyongji@bytedance.com>
         <20210713084656.232-4-xieyongji@bytedance.com>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.40.0-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspamout05
X-Rspamd-Queue-Id: A90B018A600
X-Spam-Status: No, score=-2.29
X-Stat-Signature: w8c8skx4hq53kyxkkcs5f64b7rox7x57
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Session-ID: U2FsdGVkX19IxVK6JNPE/co+tp8AToMXmxFv5EZRX50=
X-HE-Tag: 1626236410-955187
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2021-07-13 at 16:46 +0800, Xie Yongji wrote:
> Use tabs to indent the code instead of spaces.

There are a lot more of these in this file.

$ ./scripts/checkpatch.pl --fix-inplace --strict include/linux/vdpa.h

and a little typing gives:
---
 include/linux/vdpa.h | 50 +++++++++++++++++++++++++-------------------------
 1 file changed, 25 insertions(+), 25 deletions(-)

diff --git a/include/linux/vdpa.h b/include/linux/vdpa.h
index 3357ac98878d4..14cd4248e59fd 100644
--- a/include/linux/vdpa.h
+++ b/include/linux/vdpa.h
@@ -43,17 +43,17 @@ struct vdpa_vq_state_split {
  * @last_used_idx: used index
  */
 struct vdpa_vq_state_packed {
-        u16	last_avail_counter:1;
-        u16	last_avail_idx:15;
-        u16	last_used_counter:1;
-        u16	last_used_idx:15;
+	u16	last_avail_counter:1;
+	u16	last_avail_idx:15;
+	u16	last_used_counter:1;
+	u16	last_used_idx:15;
 };
 
 struct vdpa_vq_state {
-     union {
-          struct vdpa_vq_state_split split;
-          struct vdpa_vq_state_packed packed;
-     };
+	union {
+		struct vdpa_vq_state_split split;
+		struct vdpa_vq_state_packed packed;
+	};
 };
 
 struct vdpa_mgmt_dev;
@@ -131,7 +131,7 @@ struct vdpa_iova_range {
  *				@vdev: vdpa device
  *				@idx: virtqueue index
  *				@state: pointer to returned state (last_avail_idx)
- * @get_vq_notification: 	Get the notification area for a virtqueue
+ * @get_vq_notification:	Get the notification area for a virtqueue
  *				@vdev: vdpa device
  *				@idx: virtqueue index
  *				Returns the notifcation area
@@ -277,13 +277,13 @@ struct vdpa_device *__vdpa_alloc_device(struct device *parent,
 					const struct vdpa_config_ops *config,
 					size_t size, const char *name);
 
-#define vdpa_alloc_device(dev_struct, member, parent, config, name)   \
-			  container_of(__vdpa_alloc_device( \
-				       parent, config, \
-				       sizeof(dev_struct) + \
-				       BUILD_BUG_ON_ZERO(offsetof( \
-				       dev_struct, member)), name), \
-				       dev_struct, member)
+#define vdpa_alloc_device(dev_struct, member, parent, config, name)	\
+	container_of(__vdpa_alloc_device(parent, config,		\
+					 sizeof(dev_struct) +		\
+					 BUILD_BUG_ON_ZERO(offsetof(dev_struct,	\
+								    member)), \
+					 name),				\
+		     dev_struct, member)
 
 int vdpa_register_device(struct vdpa_device *vdev, int nvqs);
 void vdpa_unregister_device(struct vdpa_device *vdev);
@@ -308,8 +308,8 @@ struct vdpa_driver {
 int __vdpa_register_driver(struct vdpa_driver *drv, struct module *owner);
 void vdpa_unregister_driver(struct vdpa_driver *drv);
 
-#define module_vdpa_driver(__vdpa_driver) \
-	module_driver(__vdpa_driver, vdpa_register_driver,	\
+#define module_vdpa_driver(__vdpa_driver)				\
+	module_driver(__vdpa_driver, vdpa_register_driver,		\
 		      vdpa_unregister_driver)
 
 static inline struct vdpa_driver *drv_to_vdpa(struct device_driver *driver)
@@ -339,25 +339,25 @@ static inline struct device *vdpa_get_dma_dev(struct vdpa_device *vdev)
 
 static inline void vdpa_reset(struct vdpa_device *vdev)
 {
-        const struct vdpa_config_ops *ops = vdev->config;
+	const struct vdpa_config_ops *ops = vdev->config;
 
 	vdev->features_valid = false;
-        ops->set_status(vdev, 0);
+	ops->set_status(vdev, 0);
 }
 
 static inline int vdpa_set_features(struct vdpa_device *vdev, u64 features)
 {
-        const struct vdpa_config_ops *ops = vdev->config;
+	const struct vdpa_config_ops *ops = vdev->config;
 
 	vdev->features_valid = true;
-        return ops->set_features(vdev, features);
+	return ops->set_features(vdev, features);
 }
 
-
-static inline void vdpa_get_config(struct vdpa_device *vdev, unsigned offset,
+static inline void vdpa_get_config(struct vdpa_device *vdev,
+				   unsigned int offset,
 				   void *buf, unsigned int len)
 {
-        const struct vdpa_config_ops *ops = vdev->config;
+	const struct vdpa_config_ops *ops = vdev->config;
 
 	/*
 	 * Config accesses aren't supposed to trigger before features are set.


