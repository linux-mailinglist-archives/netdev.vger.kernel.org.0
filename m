Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 475B31DD5B2
	for <lists+netdev@lfdr.de>; Thu, 21 May 2020 20:08:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729213AbgEUSIn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 May 2020 14:08:43 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:59692 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727883AbgEUSIn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 May 2020 14:08:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1590084521;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type;
        bh=CSwVUGMdm1SF/JKvVgrgcJwpikT7dcnsVODRPnenSIQ=;
        b=AYgLu8a3LIGrhE/UKpmW9DRbHM8IIjjQq9JymmflmyJiz8ddiqBlkoLskv6Sb5AhrCiNaM
        O0I5EQh8TL3cQ+y/bmWAdBD1Ev7gWcgBhn5uPabPEtoOHy/9vz5n+AiKWKQqGYvylvXfsJ
        Mggcs+Br+9tvVq3uo2swVhoSNIdyQlA=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-62-PaZ99jc2MfSigpubDmOycw-1; Thu, 21 May 2020 14:08:40 -0400
X-MC-Unique: PaZ99jc2MfSigpubDmOycw-1
Received: by mail-wm1-f72.google.com with SMTP id l26so2101931wmh.3
        for <netdev@vger.kernel.org>; Thu, 21 May 2020 11:08:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=CSwVUGMdm1SF/JKvVgrgcJwpikT7dcnsVODRPnenSIQ=;
        b=A08+2oMtezM5kqnCTpttqbfievYVt3eI2jSW9Hpv8pNB8sd/4heS3vnaz9MeMkIDB+
         llQ46HsgAmZSCKTWNQYSaKV2vwXKmtMJHZ7DC/S6DVbZPAfO/Md6+FB4cZ6a4lkahvfm
         YxgBEnWJfRa2DrfaMiZAjfliPsW5ZsbFr+shBr1eC0VUxQeMs0I+bEOl37p6RMkUxjWf
         9TiCoKvljwEm+fWyEI5GbygPNcHom2p6L/ne/9GXwsCbP9erxlsS63/pP9/FxqAOB2cu
         whxM3MJV4kCKAp6Az0t1Dv1hfIbnJ20BeVDUC7h9cEAqBkXmyzzl0Yanc2bnn9CYyGdw
         LLow==
X-Gm-Message-State: AOAM530cwdgL0Ey+AFO5tr49y85eGGuldLpWKt6mWyKQlZYQJiU9b6Wg
        U4kffkCO3K8poyPtKDcovLEL+cRCUwrjNA1ZKunQxLQyfc2BzW6VaAqyGXjRWjAkpatp3PgcRs/
        oekpwmipwuJjtimf4
X-Received: by 2002:a5d:6087:: with SMTP id w7mr10437016wrt.158.1590084518726;
        Thu, 21 May 2020 11:08:38 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxZ9o08gBH7tx0yYBsN8onaJW/OLPfFqqFDCwm2ORoSsfevxSpfrqifuC4Sj9PcOKKkhR/Jqg==
X-Received: by 2002:a5d:6087:: with SMTP id w7mr10436991wrt.158.1590084518323;
        Thu, 21 May 2020 11:08:38 -0700 (PDT)
Received: from redhat.com (bzq-109-64-41-91.red.bezeqint.net. [109.64.41.91])
        by smtp.gmail.com with ESMTPSA id j1sm7269700wrm.40.2020.05.21.11.08.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 May 2020 11:08:37 -0700 (PDT)
Date:   Thu, 21 May 2020 14:08:35 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        jasowang@redhat.com, lkp@intel.com, mst@redhat.com,
        yuehaibing@huawei.com
Subject: [GIT PULL] vhost/vdpa: minor fixes
Message-ID: <20200521140835-mutt-send-email-mst@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mutt-Fcc: =sent
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The following changes since commit 0b841030625cde5f784dd62aec72d6a766faae70:

  vhost: vsock: kick send_pkt worker once device is started (2020-05-02 10:28:21 -0400)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git tags/for_linus

for you to fetch changes up to 1b0be99f1a426d9f17ced95c4118c6641a2ff13d:

  vhost: missing __user tags (2020-05-15 11:36:31 -0400)

----------------------------------------------------------------
virtio: build warning fixes

Fix a couple of build warnings.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>

----------------------------------------------------------------
Michael S. Tsirkin (1):
      vhost: missing __user tags

YueHaibing (1):
      vdpasim: remove unused variable 'ret'

 drivers/vdpa/vdpa_sim/vdpa_sim.c | 15 +++++++--------
 drivers/vhost/vhost.c            |  4 ++--
 2 files changed, 9 insertions(+), 10 deletions(-)

