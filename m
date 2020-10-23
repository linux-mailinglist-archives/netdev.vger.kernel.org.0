Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C52A8297282
	for <lists+netdev@lfdr.de>; Fri, 23 Oct 2020 17:39:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1750909AbgJWPjC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Oct 2020 11:39:02 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:24197 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750917AbgJWPjB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Oct 2020 11:39:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1603467539;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type;
        bh=J409roG8zhXcXXCErK007R3MrYblBFNCZHcPyX0EW1c=;
        b=ato4djoxJfdL0DPdufQLUuA2IuDBu0X8yUSJyklvDkNC6173YgfMrb8eJggCJjth2SQWkM
        X8oija8Vnn9wN8n8oxEfeN5QNNaZY0NDcsm/k5flYvWWPYxf0sE3w/6DgmjuTF3juHA0JO
        wlB54QYgwWpzWbEi7i5wcSqJR7F0rmw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-190-WxrfRJEEOtWeuf0CbspCdA-1; Fri, 23 Oct 2020 11:38:56 -0400
X-MC-Unique: WxrfRJEEOtWeuf0CbspCdA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B8F7E80400B;
        Fri, 23 Oct 2020 15:38:53 +0000 (UTC)
Received: from redhat.com (ovpn-113-117.ams2.redhat.com [10.36.113.117])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 948346EF5D;
        Fri, 23 Oct 2020 15:38:34 +0000 (UTC)
Date:   Fri, 23 Oct 2020 11:38:32 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        borntraeger@de.ibm.com, david@redhat.com, elic@nvidia.com,
        jasowang@redhat.com, lingshan.zhu@intel.com, li.wang@windriver.com,
        mst@redhat.com, pankaj.gupta.linux@gmail.com, pmorel@linux.ibm.com,
        rikard.falkeborn@gmail.com, sgarzare@redhat.com,
        stable@vger.kernel.org, tiantao6@hisilicon.com
Subject: [GIT PULL] vhost,vdpa,virtio: cleanups, fixes
Message-ID: <20201023113832-mutt-send-email-mst@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mutt-Fcc: =sent
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Was holding out for a couple of big new features including vop and rpmsg
support for 1.0, but it looks like they won't make it in time.
virtio i2c might be ready soon but that's a new driver so
if it's ready soon it's probably ok to merge outside the merge
window ... we'll see.

The following changes since commit bbf5c979011a099af5dc76498918ed7df445635b:

  Linux 5.9 (2020-10-11 14:15:50 -0700)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git tags/for_linus

for you to fetch changes up to 88a0d60c6445f315fbcfff3db792021bb3a67b28:

  MAINTAINERS: add URL for virtio-mem (2020-10-21 10:48:11 -0400)

----------------------------------------------------------------
vhost,vdpa,virtio: cleanups, fixes

A very quiet cycle, no new features.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>

----------------------------------------------------------------
David Hildenbrand (1):
      MAINTAINERS: add URL for virtio-mem

Eli Cohen (3):
      vdpa/mlx5: Make use of a specific 16 bit endianness API
      vdpa/mlx5: Fix failure to bring link up
      vdpa/mlx5: Setup driver only if VIRTIO_CONFIG_S_DRIVER_OK

Li Wang (1):
      vhost: reduce stack usage in log_used

Pierre Morel (2):
      virtio: let arch advertise guest's memory access restrictions
      s390: virtio: PV needs VIRTIO I/O device protection

Rikard Falkeborn (3):
      virtio-balloon: Constify id_table
      virtio_input: Constify id_table
      virtio-mem: Constify mem_id_table

Stefano Garzarella (1):
      vringh: fix __vringh_iov() when riov and wiov are different

Tian Tao (1):
      vhost_vdpa: Fix duplicate included kernel.h

Zhu Lingshan (1):
      vhost_vdpa: remove unnecessary spin_lock in vhost_vring_call

 MAINTAINERS                       |  1 +
 arch/s390/Kconfig                 |  1 +
 arch/s390/mm/init.c               | 11 +++++++++++
 drivers/vdpa/mlx5/net/mlx5_vnet.c | 12 ++++++++++--
 drivers/vhost/vdpa.c              |  9 +--------
 drivers/vhost/vhost.c             |  5 +----
 drivers/vhost/vhost.h             |  2 +-
 drivers/vhost/vringh.c            |  9 +++++----
 drivers/virtio/Kconfig            |  6 ++++++
 drivers/virtio/virtio.c           | 15 +++++++++++++++
 drivers/virtio/virtio_balloon.c   |  2 +-
 drivers/virtio/virtio_input.c     |  2 +-
 drivers/virtio/virtio_mem.c       |  2 +-
 include/linux/virtio_config.h     | 10 ++++++++++
 14 files changed, 65 insertions(+), 22 deletions(-)

