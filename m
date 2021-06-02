Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6ABC7397E7F
	for <lists+netdev@lfdr.de>; Wed,  2 Jun 2021 04:11:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230305AbhFBCMm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Jun 2021 22:12:42 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:53460 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230234AbhFBCMl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Jun 2021 22:12:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1622599857;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=laL4CFj9WEOaC1G1kdtekXt+lw/cU3Q0nLDdaObMtyo=;
        b=F1EUuz5S657p2p8gXt6CjZe+EqJNUOV7ysTBpFpa6wnb6StGrwdy4TXRKkc0wjxqjRuDaS
        2Y2GPF5HJosPUCrwDmZji0IaR/iwnqFIeBJpw5RYyK5nbXVL6+4OxI7YK6k0yLC+XqXZdf
        +6lID0hjojJLBjMUtVW/6iMVcjL69FI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-426-woa9fcVzMEuBWVLtUHlHjw-1; Tue, 01 Jun 2021 22:10:54 -0400
X-MC-Unique: woa9fcVzMEuBWVLtUHlHjw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 44C98107ACE3;
        Wed,  2 Jun 2021 02:10:53 +0000 (UTC)
Received: from localhost.localdomain (ovpn-12-99.pek2.redhat.com [10.72.12.99])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D091E5D6CF;
        Wed,  2 Jun 2021 02:10:46 +0000 (UTC)
From:   Jason Wang <jasowang@redhat.com>
To:     mst@redhat.com, jasowang@redhat.com,
        virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     eli@mellanox.com
Subject: [PATCH V2 0/4] 
Date:   Wed,  2 Jun 2021 10:10:39 +0800
Message-Id: <20210602021043.39201-1-jasowang@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

*** BLURB HERE ***

Eli Cohen (1):
  virtio/vdpa: clear the virtqueue state during probe

Jason Wang (3):
  vdpa: support packed virtqueue for set/get_vq_state()
  virtio-pci library: introduce vp_modern_get_driver_features()
  vp_vdpa: allow set vq state to initial state after reset

 drivers/vdpa/ifcvf/ifcvf_main.c        |  4 +--
 drivers/vdpa/mlx5/net/mlx5_vnet.c      |  8 ++---
 drivers/vdpa/vdpa_sim/vdpa_sim.c       |  4 +--
 drivers/vdpa/virtio_pci/vp_vdpa.c      | 42 ++++++++++++++++++++++++--
 drivers/vhost/vdpa.c                   |  4 +--
 drivers/virtio/virtio_pci_modern_dev.c | 21 +++++++++++++
 drivers/virtio/virtio_vdpa.c           | 15 +++++++++
 include/linux/vdpa.h                   | 25 +++++++++++++--
 include/linux/virtio_pci_modern.h      |  1 +
 9 files changed, 109 insertions(+), 15 deletions(-)

-- 
2.25.1

