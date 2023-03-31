Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9030E6D1AEC
	for <lists+netdev@lfdr.de>; Fri, 31 Mar 2023 10:57:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231326AbjCaI5Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Mar 2023 04:57:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230082AbjCaI5O (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Mar 2023 04:57:14 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 629318A5E;
        Fri, 31 Mar 2023 01:57:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F1012625B4;
        Fri, 31 Mar 2023 08:57:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF612C433D2;
        Fri, 31 Mar 2023 08:57:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680253032;
        bh=HhmtS11lifJh0p+DxBrhsUr+GJEThbU7xivKAEBKBvg=;
        h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
        b=BJrJ1NIrp4FCUZh2GsNJwgyd6vGiR91fyJlzgaWsDECOTs1ayW+nzbYmZ4BpLGJgu
         NXs4OjHAEewh/T5XB+HAkIPIefDmVo8f/tHcbY9mgIG9jVgsal3JemId+TXk0LJXz0
         qidf3Xd8SKSlD7NRatlGUf+b3lfmUqaboEbEz4KlW8JkAsg2/WG1PQPSF3lkXzhHVn
         LWW8UuXMrY/dYBx29yRZuj9T7rRKsA0VzPrZo2GwYYQfcbNNuP7SCHtI7s/0bmkjGx
         nEaDe7XtwEHef5maTH/RSGl7Tu5IqmyJ3cGB1nF1BRaOFJZ2EDI1WgE7o7ePGfqNvv
         56EV1c62UClxA==
From:   Simon Horman <horms@kernel.org>
Date:   Fri, 31 Mar 2023 10:56:57 +0200
Subject: [PATCH vhost 3/3] MAINTAINERS: add vringh.h to Virtio Core and Net
 Drivers
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20230331-vhost-fixes-v1-3-1f046e735b9e@kernel.org>
References: <20230331-vhost-fixes-v1-0-1f046e735b9e@kernel.org>
In-Reply-To: <20230331-vhost-fixes-v1-0-1f046e735b9e@kernel.org>
To:     "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>
Cc:     Eli Cohen <elic@nvidia.com>, Si-Wei Liu <si-wei.liu@oracle.com>,
        Xie Yongji <xieyongji@bytedance.com>,
        Parav Pandit <parav@nvidia.com>, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org
X-Mailer: b4 0.12.2
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

vringh.h doesn't seem to belong to any section in MAINTAINERS.
Add it to Virtio Core and Net Drivers, which seems to be the most
appropriate section to me.

Signed-off-by: Simon Horman <horms@kernel.org>
---
 MAINTAINERS | 1 +
 1 file changed, 1 insertion(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 91201c2b8190..7cf548302c56 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -22095,6 +22095,7 @@ F:	drivers/vdpa/
 F:	drivers/virtio/
 F:	include/linux/vdpa.h
 F:	include/linux/virtio*.h
+F:	include/linux/vringh.h
 F:	include/uapi/linux/virtio_*.h
 F:	tools/virtio/
 

-- 
2.30.2

