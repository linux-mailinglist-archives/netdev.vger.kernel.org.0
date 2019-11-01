Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 60207EC91B
	for <lists+netdev@lfdr.de>; Fri,  1 Nov 2019 20:34:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727890AbfKATeG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Nov 2019 15:34:06 -0400
Received: from mx1.redhat.com ([209.132.183.28]:56964 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727325AbfKATeE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 1 Nov 2019 15:34:04 -0400
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com [209.85.221.72])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 52F82811BF
        for <netdev@vger.kernel.org>; Fri,  1 Nov 2019 19:34:04 +0000 (UTC)
Received: by mail-wr1-f72.google.com with SMTP id f16so5733371wrr.16
        for <netdev@vger.kernel.org>; Fri, 01 Nov 2019 12:34:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=DDu4dZguSc1AuhYOU131Dph2BpOLdkpSLt78cfUXrP4=;
        b=RKsusEW1Cdc4lWrZ/TuOYbhqmODulHVsMJdkm62xW+7Ig/uY70ztHYpkDjoUEkNMlm
         t8RpdpZWfxFlP/lS56n2O12MRBUmqT9vCCMINzkHVAWs9cBRpM28RKeEdRk1xiJxhXyj
         S/3UQZMJng91F0E97s+yCJcduDlsoIjRxo4a93/uhBvcNmQnS2hpIVFIP4eEDJlXSnMF
         IPHVClBhHY+w8NTC8bVn/1Ya+vf5dS8pFk8VkesJuJ+4EN9VW84Go4IURFW5xIoG0eDJ
         SfQ2M0mSz+AYaDimuZBwKo4/n8aqdn1K5EKP/5MOluHwRK6zF0TCrr2L4PFgHYVfqVwA
         i4rg==
X-Gm-Message-State: APjAAAVusR06/tkLei4MASLE2KRYhWbhr+SIrNmG/h0mKncjJMv7rHEM
        Sr8IAxPyrZVNJihN7GdwI8GB/yFnS8kSfTnSL4owjxZ8W07Fc3U3wdJfjMnd4MJ9ALTObUrXmPn
        buETPMIgIn5lkP7mr
X-Received: by 2002:a1c:3dc4:: with SMTP id k187mr11325443wma.167.1572636841903;
        Fri, 01 Nov 2019 12:34:01 -0700 (PDT)
X-Google-Smtp-Source: APXvYqz0xUERtPHGhyf71lfOGgMY82PECMv5XY2AKvQnIIKeMbgOF3SlGefp223udCXQMXep6c44yw==
X-Received: by 2002:a1c:3dc4:: with SMTP id k187mr11325432wma.167.1572636841676;
        Fri, 01 Nov 2019 12:34:01 -0700 (PDT)
Received: from redhat.com (94.222.26.109.rev.sfr.net. [109.26.222.94])
        by smtp.gmail.com with ESMTPSA id 65sm12393239wrs.9.2019.11.01.12.33.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 Nov 2019 12:34:00 -0700 (PDT)
Date:   Fri, 1 Nov 2019 15:33:57 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, jasowang@redhat.com, mst@redhat.com,
        sgarzare@redhat.com, yong.liu@intel.com
Subject: [PULL RESEND] virtio: fixes
Message-ID: <20191028042900-1-mutt-send-email-mst@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mutt-Fcc: =sent
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Could not figure out whether I sent this pull request or not. Sorry about
the noise if I did.

The following changes since commit 7d194c2100ad2a6dded545887d02754948ca5241:

  Linux 5.4-rc4 (2019-10-20 15:56:22 -0400)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git tags/for_linus

for you to fetch changes up to b3683dee840274e9997d958b9d82e5de95950f0b:

  vringh: fix copy direction of vringh_iov_push_kern() (2019-10-28 04:25:04 -0400)

----------------------------------------------------------------
virtio: fixes

Some minor fixes

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>

----------------------------------------------------------------
Jason Wang (1):
      vringh: fix copy direction of vringh_iov_push_kern()

Marvin Liu (1):
      virtio_ring: fix stalls for packed rings

Stefano Garzarella (1):
      vsock/virtio: remove unused 'work' field from 'struct virtio_vsock_pkt'

 drivers/vhost/vringh.c       | 8 +++++++-
 drivers/virtio/virtio_ring.c | 7 +++----
 include/linux/virtio_vsock.h | 1 -
 3 files changed, 10 insertions(+), 6 deletions(-)
