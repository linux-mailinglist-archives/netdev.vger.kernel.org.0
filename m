Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 809F9DF080
	for <lists+netdev@lfdr.de>; Mon, 21 Oct 2019 16:52:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728842AbfJUOwr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Oct 2019 10:52:47 -0400
Received: from andre.telenet-ops.be ([195.130.132.53]:43080 "EHLO
        andre.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727847AbfJUOwK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Oct 2019 10:52:10 -0400
Received: from ramsan ([84.194.98.4])
        by andre.telenet-ops.be with bizsmtp
        id GErr2100905gfCL01Erri1; Mon, 21 Oct 2019 16:52:09 +0200
Received: from rox.of.borg ([192.168.97.57])
        by ramsan with esmtp (Exim 4.90_1)
        (envelope-from <geert@linux-m68k.org>)
        id 1iMZ2E-00075d-VZ; Mon, 21 Oct 2019 16:51:50 +0200
Received: from geert by rox.of.borg with local (Exim 4.90_1)
        (envelope-from <geert@linux-m68k.org>)
        id 1iMZ2E-0008FP-Rq; Mon, 21 Oct 2019 16:51:50 +0200
From:   Geert Uytterhoeven <geert+renesas@glider.be>
To:     =?UTF-8?q?Breno=20Leit=C3=A3o?= <leitao@debian.org>,
        Nayna Jain <nayna@linux.ibm.com>,
        Paulo Flabiano Smorigo <pfsmorigo@gmail.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        Alex Deucher <alexander.deucher@amd.com>,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        David@rox.of.borg, David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>,
        Casey Leedom <leedom@chelsio.com>,
        Shannon Nelson <snelson@pensando.io>,
        Pensando Drivers <drivers@pensando.io>,
        Kevin Hilman <khilman@kernel.org>, Nishanth Menon <nm@ti.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-crypto@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        amd-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
        netdev@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>
Subject: [PATCH 0/5] debugfs: Remove casts in debugfs_create_*() callers
Date:   Mon, 21 Oct 2019 16:51:44 +0200
Message-Id: <20191021145149.31657-1-geert+renesas@glider.be>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

	Hi all,

Casting parameters in debugfs_create_*() calls prevents the compiler
from performing some checks.

Hence this patch series removes superfluous casts, or reworks code to no
longer need the casts.

All patches can be applied independently, there are no dependencies.
Thanks for your comments!

Geert Uytterhoeven (5):
  crypto: nx - Improve debugfs_create_u{32,64}() handling for atomics
  cxgb4/cxgb4vf: Remove superfluous void * cast in debugfs_create_file()
    call
  drm/amdgpu: Remove superfluous void * cast in debugfs_create_file()
    call
  power: avs: smartreflex: Remove superfluous cast in
    debugfs_create_file() call
  ionic: Use debugfs_create_bool() to export bool

 drivers/crypto/nx/nx_debugfs.c                 | 18 +++++++++---------
 drivers/gpu/drm/amd/amdgpu/amdgpu_debugfs.c    |  4 ++--
 .../ethernet/chelsio/cxgb4vf/cxgb4vf_main.c    |  2 +-
 .../ethernet/pensando/ionic/ionic_debugfs.c    |  3 +--
 drivers/power/avs/smartreflex.c                |  2 +-
 5 files changed, 14 insertions(+), 15 deletions(-)

-- 
2.17.1

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
