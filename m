Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 390346D1AF0
	for <lists+netdev@lfdr.de>; Fri, 31 Mar 2023 10:57:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231450AbjCaI5T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Mar 2023 04:57:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230003AbjCaI5O (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Mar 2023 04:57:14 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8BCD10FA;
        Fri, 31 Mar 2023 01:57:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 91D5EB82D63;
        Fri, 31 Mar 2023 08:57:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6477C4339B;
        Fri, 31 Mar 2023 08:57:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680253030;
        bh=nfqhbMG0lxmbbjcxNP04AkwjjwaQZsVAQxrkkGDhnNY=;
        h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
        b=k0XuSiOiAktREiH2nau3/FnqnJTuNgZeIabvaGankpNCYZwxbkfdhQ0/7qFVmbQ09
         x5ZT9GEtyYfuNNu0bpzh48ZesmBsE33e/2bAoE3XTJNgCMN0OYhATafkAaBb1U4U2G
         leoF9TZkIYlJxywgZqpekpOtywA440DUD3JI1agl6w42aSFSbI0XZ6DVbwq2FqKJQG
         h+4GQE1Wk2CvpBbdEqofsEnLekV2wJyIFNdpV6y4YnPZC9yac8G+u0aIt/+z8EWB4d
         H0rt3RPYdFmH9JwTThUYXaRXu4aNfNtefYGcVCoQuOJsBzUAMuoDyq6qO/J7I/VP6T
         KKaz3ydTSiHwg==
From:   Simon Horman <horms@kernel.org>
Date:   Fri, 31 Mar 2023 10:56:56 +0200
Subject: [PATCH vhost 2/3] vringh: address kdoc warnings
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20230331-vhost-fixes-v1-2-1f046e735b9e@kernel.org>
References: <20230331-vhost-fixes-v1-0-1f046e735b9e@kernel.org>
In-Reply-To: <20230331-vhost-fixes-v1-0-1f046e735b9e@kernel.org>
To:     "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>
Cc:     Eli Cohen <elic@nvidia.com>, Si-Wei Liu <si-wei.liu@oracle.com>,
        Xie Yongji <xieyongji@bytedance.com>,
        Parav Pandit <parav@nvidia.com>, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org
X-Mailer: b4 0.12.2
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Address some minor kdoc warnings in vring.h.
* Place kdoc for 'struct vringh_config_ops' immediately before the structure
* Add missing documentation of members of 'vringh_iov' and 'vringh_kiov'

Warnings flagged by:
 $ ./scripts/kernel-doc -none include/linux/vringh.h
 include/linux/vringh.h:68: error: Cannot parse struct or union!
 include/linux/vringh.h:92: warning: Function parameter or member 'iov' not described in 'vringh_iov'
 include/linux/vringh.h:92: warning: Function parameter or member 'consumed' not described in 'vringh_iov'
 include/linux/vringh.h:92: warning: Function parameter or member 'i' not described in 'vringh_iov'
 include/linux/vringh.h:92: warning: Function parameter or member 'used' not described in 'vringh_iov'
 include/linux/vringh.h:92: warning: Function parameter or member 'max_num' not described in 'vringh_iov'
 include/linux/vringh.h:104: warning: Function parameter or member 'iov' not described in 'vringh_kiov'
 include/linux/vringh.h:104: warning: Function parameter or member 'consumed' not described in 'vringh_kiov'
 include/linux/vringh.h:104: warning: Function parameter or member 'i' not described in 'vringh_kiov'
 include/linux/vringh.h:104: warning: Function parameter or member 'used' not described in 'vringh_kiov'
 include/linux/vringh.h:104: warning: Function parameter or member 'max_num' not described in 'vringh_kiov'

Signed-off-by: Simon Horman <horms@kernel.org>
---
 include/linux/vringh.h | 17 +++++++++++++++--
 1 file changed, 15 insertions(+), 2 deletions(-)

diff --git a/include/linux/vringh.h b/include/linux/vringh.h
index 1991a02c6431..9f3e7012a255 100644
--- a/include/linux/vringh.h
+++ b/include/linux/vringh.h
@@ -54,6 +54,9 @@ struct vringh {
 	void (*notify)(struct vringh *);
 };
 
+struct virtio_device;
+typedef void vrh_callback_t(struct virtio_device *, struct vringh *);
+
 /**
  * struct vringh_config_ops - ops for creating a host vring from a virtio driver
  * @find_vrhs: find the host vrings and instantiate them
@@ -65,8 +68,6 @@ struct vringh {
  *	Returns 0 on success or error status
  * @del_vrhs: free the host vrings found by find_vrhs().
  */
-struct virtio_device;
-typedef void vrh_callback_t(struct virtio_device *, struct vringh *);
 struct vringh_config_ops {
 	int (*find_vrhs)(struct virtio_device *vdev, unsigned nhvrs,
 			 struct vringh *vrhs[], vrh_callback_t *callbacks[]);
@@ -81,6 +82,12 @@ struct vringh_range {
 
 /**
  * struct vringh_iov - iovec mangler.
+ * @iov: array of iovecs to operate on
+ * @consumed: number of bytes consumed within iov[i]
+ * @i: index of current iovec
+ * @used: number of iovecs present in @iov
+ * @max_num: maximum number of iovecs.
+ *           corresponds to allocated memory of @iov
  *
  * Mangles iovec in place, and restores it.
  * Remaining data is iov + i, of used - i elements.
@@ -93,6 +100,12 @@ struct vringh_iov {
 
 /**
  * struct vringh_kiov - kvec mangler.
+ * @iov: array of iovecs to operate on
+ * @consumed: number of bytes consumed within iov[i]
+ * @i: index of current iovec
+ * @used: number of iovecs present in @iov
+ * @max_num: maximum number of iovecs.
+ *           corresponds to allocated memory of @iov
  *
  * Mangles kvec in place, and restores it.
  * Remaining data is iov + i, of used - i elements.

-- 
2.30.2

