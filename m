Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 213C9310D78
	for <lists+netdev@lfdr.de>; Fri,  5 Feb 2021 16:57:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231723AbhBEOQg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Feb 2021 09:16:36 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:28504 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232160AbhBEONf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Feb 2021 09:13:35 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1612540201;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type;
        bh=+vT+jbN1YVSVSpzQpXP9jC5D0CiFueilUGvKuUc6MhE=;
        b=Pl8mWrGNOndtC9XADvofyiyNyA7yNr4jLV7fQ7HkTEv01iiYkZkhAqR1yM5YzaiN2YhWb5
        MeHkfHu52tMdBcTxgPy5RPhFUZ9AC1jE/zzxwjz08MStHDGOBD3cn945gDqRCx5womwJPI
        LH+ynVwpC7f/9zBHw/+9+Dssweb3xU0=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-198-KkKiCmtcMEKV4TtOlnO1hg-1; Fri, 05 Feb 2021 10:45:26 -0500
X-MC-Unique: KkKiCmtcMEKV4TtOlnO1hg-1
Received: by mail-ej1-f70.google.com with SMTP id ce9so6945265ejc.17
        for <netdev@vger.kernel.org>; Fri, 05 Feb 2021 07:45:26 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=+vT+jbN1YVSVSpzQpXP9jC5D0CiFueilUGvKuUc6MhE=;
        b=q6fJdt+gNmP+d1Q21Pg9g40kTTPc1Qh3BbVkSpu8x87olma95Nc61yp2oud1MvdMkw
         q/T/0j/bfP7sioFX9mOCMpHsRQ9LK646kl+lEYzhJncmsgLZHqnDU5ztApaRTwIEyvLu
         nMSt8/4iuJd6Glcx5W8nupqckHTKSPxyJr5hCKU15euvHYBKa1S26EEa/3/lS61/iZa9
         RpQshWjsAm3Yfy+pWJDE1nWagtiC/Z90/Vq0hETQQW3nxRdwNtsaMXMcC34MNArFu3jQ
         f3Xjf0HZBldGry+YFouRR+CF6KUfF/1ZYzJ2tZkDjSQrpXRkJNl/qwCtssaiHbV5p3BF
         H7wg==
X-Gm-Message-State: AOAM533pnRuQlAd6PZgVlBa4BBQQwPc7ST3zN+wTdgkcVyZ9qYue8r0b
        VG4TtityWhkgxfn11ykBNul+IydaAPuXhET9KFWa72ZQBXPbRAksF+pYNIUKfkRPzFW4lQWGQBR
        uphppnsSt31ECanf+
X-Received: by 2002:a17:906:8292:: with SMTP id h18mr4553208ejx.342.1612539924166;
        Fri, 05 Feb 2021 07:45:24 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxqBUHpbvPYDpBnMWonVBrhZuXG+GwON2f3pVr2d/bLWj6ekzRtN+o9kgto+FKOSFfskxHUQg==
X-Received: by 2002:a17:906:8292:: with SMTP id h18mr4553187ejx.342.1612539923963;
        Fri, 05 Feb 2021 07:45:23 -0800 (PST)
Received: from redhat.com (bzq-79-180-2-31.red.bezeqint.net. [79.180.2.31])
        by smtp.gmail.com with ESMTPSA id y8sm4030809eje.37.2021.02.05.07.45.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Feb 2021 07:45:23 -0800 (PST)
Date:   Fri, 5 Feb 2021 10:45:20 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        elic@nvidia.com, jasowang@redhat.com, mst@redhat.com
Subject: [GIT PULL] vdpa: last minute bugfix
Message-ID: <20210205104520-mutt-send-email-mst@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mutt-Fcc: =sent
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The following changes since commit 710eb8e32d04714452759f2b66884bfa7e97d495:

  vdpa/mlx5: Fix memory key MTT population (2021-01-20 03:47:04 -0500)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git tags/for_linus

for you to fetch changes up to b35ccebe3ef76168aa2edaa35809c0232cb3578e:

  vdpa/mlx5: Restore the hardware used index after change map (2021-02-05 10:28:04 -0500)

----------------------------------------------------------------
vdpa: last minute bugfix

A bugfix in the mlx driver I got at the last minute.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>

----------------------------------------------------------------
Eli Cohen (1):
      vdpa/mlx5: Restore the hardware used index after change map

 drivers/vdpa/mlx5/net/mlx5_vnet.c | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

