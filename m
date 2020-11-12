Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A6BC62AFFBA
	for <lists+netdev@lfdr.de>; Thu, 12 Nov 2020 07:40:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726194AbgKLGkc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Nov 2020 01:40:32 -0500
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:5886 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725898AbgKLGkb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Nov 2020 01:40:31 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5facd8e20000>; Wed, 11 Nov 2020 22:40:35 -0800
Received: from sw-mtx-036.mtx.labs.mlnx (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Thu, 12 Nov
 2020 06:40:30 +0000
From:   Parav Pandit <parav@nvidia.com>
To:     <virtualization@lists.linux-foundation.org>
CC:     <mst@redhat.com>, <jasowang@redhat.com>, <parav@nvidia.com>,
        <elic@nvidia.com>, <netdev@vger.kernel.org>
Subject: [PATCH 1/7] vdpa: Add missing comment for virtqueue count
Date:   Thu, 12 Nov 2020 08:39:59 +0200
Message-ID: <20201112064005.349268-2-parav@nvidia.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201112064005.349268-1-parav@nvidia.com>
References: <20201112064005.349268-1-parav@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL101.nvidia.com (172.20.187.10) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1605163235; bh=HisUjgRvMY7IXIfftOHpd8Quijdl8ayptoeXWTLZhqk=;
        h=From:To:CC:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
         References:MIME-Version:Content-Transfer-Encoding:Content-Type:
         X-Originating-IP:X-ClientProxiedBy;
        b=KxXa+3kCgPdsl+h2Y9LwzJBS64fxr3cEEoLD58Fk5z4CkZOjbXuLvymJmP55+LLRu
         oNefKcm+45oYNv8wbRBW2KM49LkhydGcG4IzduPqqbdgEmLiSMC8d+vdxrhRry/TW1
         uTeXG0wTy1kGXCQ+wtQbVUmZPogLBTBAXEkFhhqu5EKDqYOSRaBo3pcPR1QoXqIoKp
         RwnnHnDWgqkB97q94er1C98zlFpftcU10K+2COwlT8uZH23NHu6QjvntEu6CRZZtx8
         4R24h0yDTeisVc7dvf1VdkRkb2mlzn/Yy7B4MhlKk791GSBSvYe9sBqlRWAF5oSH0o
         H5cA1JCUrtB4g==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add missing comment for number of virtqueue.

Signed-off-by: Parav Pandit <parav@nvidia.com>
Reviewed-by: Eli Cohen <elic@nvidia.com>
Acked-by: Jason Wang <jasowang@redhat.com>
---
 include/linux/vdpa.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/linux/vdpa.h b/include/linux/vdpa.h
index 30bc7a7223bb..0fefeb976877 100644
--- a/include/linux/vdpa.h
+++ b/include/linux/vdpa.h
@@ -42,6 +42,7 @@ struct vdpa_vq_state {
  * @config: the configuration ops for this device.
  * @index: device index
  * @features_valid: were features initialized? for legacy guests
+ * @nvqs: maximum number of supported virtqueues
  */
 struct vdpa_device {
 	struct device dev;
--=20
2.26.2

