Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 195DE7908F
	for <lists+netdev@lfdr.de>; Mon, 29 Jul 2019 18:16:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727999AbfG2QQM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jul 2019 12:16:12 -0400
Received: from mail-ua1-f68.google.com ([209.85.222.68]:38034 "EHLO
        mail-ua1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727624AbfG2QQM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Jul 2019 12:16:12 -0400
Received: by mail-ua1-f68.google.com with SMTP id j2so24175747uaq.5
        for <netdev@vger.kernel.org>; Mon, 29 Jul 2019 09:16:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=AyvJSduUmZn33FbpJeTkP5NHm1ThVmp/uEoZugiTS6k=;
        b=R8zIkhYX8QIFzFk4oxgjhG2T1GS3XHiOYyBv6Txp4goeFhfe3dlk9pO1i1TUy8t4kl
         Ar96ZlHkum+bX69xiT6/yORWCwXlwC7Mu2nKz7l8RIV2E8Ixnhhf8eAk0WFCZ3OL9SX8
         6Z2aszbl4PdIDgIpzp5DP9OvxO+M9sL9uui98dUB42GzksqVY4thnxFAIszgzsL8F5Hx
         C3RxgGZHIYl/deYlUzPqfQAEYkhoqw4/ZR0EHLXQxqfki6gk9tux85l3HMq+a1/niJ6m
         /fBvNGc9YqxuLbn97Zt49dk1rNIw9IU7B3ClwxCyMN/LFa7HJ/Sl/YvXH9AE5KYvLWH5
         8Big==
X-Gm-Message-State: APjAAAWKd08NbJK30RSX476Y1wjC6ftqUVtPCNZg9+cNxI/4QkHS9Bdn
        G+15j54+I0cSW43GsO8p03aq2A==
X-Google-Smtp-Source: APXvYqwG8Q4XQWblCYfrnvjYrxOZIt94OjzyFiLAXTSDaMhX/fRr5dDybVH26+paFqcxZZfddeveUQ==
X-Received: by 2002:a9f:31a2:: with SMTP id v31mr67985907uad.15.1564416971073;
        Mon, 29 Jul 2019 09:16:11 -0700 (PDT)
Received: from redhat.com (bzq-79-181-91-42.red.bezeqint.net. [79.181.91.42])
        by smtp.gmail.com with ESMTPSA id u5sm60539788uah.0.2019.07.29.09.16.07
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 29 Jul 2019 09:16:10 -0700 (PDT)
Date:   Mon, 29 Jul 2019 12:16:05 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        eric.auger@redhat.com, jean-philippe@linaro.org, jroedel@suse.de,
        mst@redhat.com, namit@vmware.com, wei.w.wang@intel.com
Subject: [PULL] vhost,virtio: cleanups and fixes
Message-ID: <20190729121605-mutt-send-email-mst@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mutt-Fcc: =sent
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The following changes since commit 5f9e832c137075045d15cd6899ab0505cfb2ca4b:

  Linus 5.3-rc1 (2019-07-21 14:05:38 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git tags/for_linus

for you to fetch changes up to 73f628ec9e6bcc45b77c53fe6d0c0ec55eaf82af:

  vhost: disable metadata prefetch optimization (2019-07-26 07:49:29 -0400)

----------------------------------------------------------------
virtio, vhost: bugfixes

Fixes in the iommu and balloon devices.
Disable the meta-data optimization for now - I hope we can get it fixed
shortly, but there's no point in making users suffer crashes while we
are working on that.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>

----------------------------------------------------------------
Jean-Philippe Brucker (1):
      iommu/virtio: Update to most recent specification

Michael S. Tsirkin (2):
      balloon: fix up comments
      vhost: disable metadata prefetch optimization

Wei Wang (1):
      mm/balloon_compaction: avoid duplicate page removal

 drivers/iommu/virtio-iommu.c      | 40 ++++++++++++++++-------
 drivers/vhost/vhost.h             |  2 +-
 include/uapi/linux/virtio_iommu.h | 32 ++++++++++--------
 mm/balloon_compaction.c           | 69 +++++++++++++++++++++++----------------
 4 files changed, 89 insertions(+), 54 deletions(-)
