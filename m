Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C3F30D81EF
	for <lists+netdev@lfdr.de>; Tue, 15 Oct 2019 23:19:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728152AbfJOVTQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Oct 2019 17:19:16 -0400
Received: from mx1.redhat.com ([209.132.183.28]:47338 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727310AbfJOVTQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 15 Oct 2019 17:19:16 -0400
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com [209.85.222.197])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id C8DA0882EF
        for <netdev@vger.kernel.org>; Tue, 15 Oct 2019 21:19:15 +0000 (UTC)
Received: by mail-qk1-f197.google.com with SMTP id 10so21562582qka.2
        for <netdev@vger.kernel.org>; Tue, 15 Oct 2019 14:19:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=dL6rRUzanF/mngAS+r+PSLw0RQ+CPB/xDAExf30z58I=;
        b=qPLlCFF02klc5+x4sW+tNO56BfaufjVFUtlx1f5+PORrzfBkqPmWXnP7iz2LAszX+T
         oIFYoitAW9W9s52OL9QBq7FpfsxvoOZ8Tg0Z4TMT47KnJwruIEqS5+PHO5vcvhBW9CoG
         qpnBRnk12nCv/jl+WGBdG3dBt3ky1L4a8F2ZaUIKROItKq6UiyCDSY5uAPGTF/yHW32Z
         lmn/Z4GjdFpLOBNs74XAzU0Lyb8o3Q6kbG5OIn4JcY2QH5JZGHje31lLNAfnhMil1CtT
         1WPAp7b8vTWF70w6ykL0CtO4Gr2WQeRGOTduFqWKNIAhMAxZYzXqMLnSRHmfqeQw3ell
         iumA==
X-Gm-Message-State: APjAAAWRh+/CrSAql3vCWvVb/CuYE5sjWTjFdFdVzzqm3ndTOPJOfcho
        OH0r5cA7W0Bp0GKQW7AOfiiErOzugr23SRtYaKU6f3pe5gxUkT0xH+z5dHLD5dsNGEBtSBctlak
        IzMdhJy8JmFN+sbPr
X-Received: by 2002:a0c:f612:: with SMTP id r18mr38402294qvm.56.1571174353649;
        Tue, 15 Oct 2019 14:19:13 -0700 (PDT)
X-Google-Smtp-Source: APXvYqzMCqTGbwZd7p8eXtvsCO6t1D+F0697yJqDJ1oBBJZwAb7HGPZvXklyA5piJoGL8p8xGUaolQ==
X-Received: by 2002:a0c:f612:: with SMTP id r18mr38402264qvm.56.1571174353431;
        Tue, 15 Oct 2019 14:19:13 -0700 (PDT)
Received: from redhat.com (bzq-79-176-10-77.red.bezeqint.net. [79.176.10.77])
        by smtp.gmail.com with ESMTPSA id q44sm14292649qtk.16.2019.10.15.14.19.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Oct 2019 14:19:12 -0700 (PDT)
Date:   Tue, 15 Oct 2019 17:19:08 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        jan.kiszka@web.de, mst@redhat.com
Subject: [PULL] vhost: cleanups and fixes
Message-ID: <20191015171908-mutt-send-email-mst@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mutt-Fcc: =sent
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The following changes since commit da0c9ea146cbe92b832f1b0f694840ea8eb33cce:

  Linux 5.4-rc2 (2019-10-06 14:27:30 -0700)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git tags/for_linus

for you to fetch changes up to 245cdd9fbd396483d501db83047116e2530f245f:

  vhost/test: stop device before reset (2019-10-13 09:38:27 -0400)

----------------------------------------------------------------
virtio: fixes

Some minor bugfixes

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>

----------------------------------------------------------------
Michael S. Tsirkin (3):
      tools/virtio: more stubs
      tools/virtio: xen stub
      vhost/test: stop device before reset

 drivers/vhost/test.c             | 2 ++
 tools/virtio/crypto/hash.h       | 0
 tools/virtio/linux/dma-mapping.h | 2 ++
 tools/virtio/xen/xen.h           | 6 ++++++
 4 files changed, 10 insertions(+)
 create mode 100644 tools/virtio/crypto/hash.h
 create mode 100644 tools/virtio/xen/xen.h
