Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A144F1E3D6C
	for <lists+netdev@lfdr.de>; Wed, 27 May 2020 11:17:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728477AbgE0JRr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 May 2020 05:17:47 -0400
Received: from mga12.intel.com ([192.55.52.136]:52630 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725820AbgE0JRr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 27 May 2020 05:17:47 -0400
IronPort-SDR: EPJim9tSr0LXmvlOxmZmWr+63LG0lBTy6x26zTWWoUioO5ZC7r6+uVzh1rAOnj047fct0ylO8Q
 NPZeVYCquLMg==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 May 2020 02:17:46 -0700
IronPort-SDR: 40oXLoq2PILk5e50dpXaB6hUneU0F+HlXUvD3DxEWqiiKhfzcf7eE1X1PvDXbUadDuvii9iRTR
 PYV49oHaa5nA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,440,1583222400"; 
   d="scan'208";a="414138598"
Received: from lkp-server01.sh.intel.com (HELO lkp-server01) ([10.239.97.150])
  by orsmga004.jf.intel.com with ESMTP; 27 May 2020 02:17:44 -0700
Received: from kbuild by lkp-server01 with local (Exim 4.89)
        (envelope-from <lkp@intel.com>)
        id 1jdsBz-000Bjv-75; Wed, 27 May 2020 17:17:43 +0800
Date:   Wed, 27 May 2020 17:16:46 +0800
From:   kbuild test robot <lkp@intel.com>
To:     Zhu Lingshan <lingshan.zhu@intel.com>, mst@redhat.com,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        jasowang@redhat.com
Cc:     kbuild-all@lists.01.org, lulu@redhat.com, dan.daly@intel.com,
        cunming.liang@intel.com, Zhu Lingshan <lingshan.zhu@intel.com>
Subject: [RFC PATCH] vdpa: vhost_vdpa_poll_stop() can be static
Message-ID: <20200527091646.GA80910@369e1fe990b8>
References: <1590471145-4436-1-git-send-email-lingshan.zhu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1590471145-4436-1-git-send-email-lingshan.zhu@intel.com>
X-Patchwork-Hint: ignore
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Signed-off-by: kbuild test robot <lkp@intel.com>
---
 vdpa.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
index d3a2acafedecd4..5037ce7f48cd42 100644
--- a/drivers/vhost/vdpa.c
+++ b/drivers/vhost/vdpa.c
@@ -287,12 +287,12 @@ static long vhost_vdpa_get_vring_num(struct vhost_vdpa *v, u16 __user *argp)
 
 	return 0;
 }
-void vhost_vdpa_poll_stop(struct vhost_virtqueue *vq)
+static void vhost_vdpa_poll_stop(struct vhost_virtqueue *vq)
 {
 	vhost_poll_stop(&vq->poll);
 }
 
-int vhost_vdpa_poll_start(struct vhost_virtqueue *vq)
+static int vhost_vdpa_poll_start(struct vhost_virtqueue *vq)
 {
 	struct vhost_poll *poll = &vq->poll;
 	struct file *file = vq->kick;
@@ -747,7 +747,7 @@ static int vhost_vdpa_poll_worker(wait_queue_entry_t *wait, unsigned int mode,
 	return 0;
 }
 
-void vhost_vdpa_poll_init(struct vhost_dev *dev)
+static void vhost_vdpa_poll_init(struct vhost_dev *dev)
 {
 	struct vhost_virtqueue *vq;
 	struct vhost_poll *poll;
