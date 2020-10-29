Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C9B3729F696
	for <lists+netdev@lfdr.de>; Thu, 29 Oct 2020 22:06:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726435AbgJ2VGe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Oct 2020 17:06:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:52210 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726200AbgJ2VGc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 29 Oct 2020 17:06:32 -0400
Received: from mail-qv1-f49.google.com (mail-qv1-f49.google.com [209.85.219.49])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D0B2420FC3;
        Thu, 29 Oct 2020 21:06:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604005592;
        bh=N4ClDiY0laorS+29+1mvV2WgI/I6Hyfs/fIK1pWQNJM=;
        h=From:Date:Subject:To:Cc:From;
        b=bk0CdwO0+E8Uyd0eYpD2W3CecgMIxz0bcZCEjIFh07IK3evLqPTUe+inlAam1QUAF
         e7F4LhQeX9xgrwg5uanun1XqplFZKsCfSNFtPg0bxyjdzUHtFv1H7SLXK+QoOhVI3h
         auAdJh+oBezVwksu7g5LWumm0zi8ST4ypiBgpCxc=
Received: by mail-qv1-f49.google.com with SMTP id ev17so1955762qvb.3;
        Thu, 29 Oct 2020 14:06:31 -0700 (PDT)
X-Gm-Message-State: AOAM531Z3m6DDtDxN4gPNdCn2a5YaTLja6e4UH2dkPj/gCmqOa1Yr6U+
        pFVXUesUccx9FNYvW8zHQTbPCrrjfbP/TEjz5TI=
X-Google-Smtp-Source: ABdhPJwpf98zWmGiKaNypey91Yjw92ghodOzFm8+GjIX1WObDqJopLu9KFhdQ1Hgnkzh0Ien+1g0faXPF88ZNIGfMK4=
X-Received: by 2002:a0c:c187:: with SMTP id n7mr6510328qvh.19.1604005590727;
 Thu, 29 Oct 2020 14:06:30 -0700 (PDT)
MIME-Version: 1.0
From:   Arnd Bergmann <arnd@kernel.org>
Date:   Thu, 29 Oct 2020 22:06:14 +0100
X-Gmail-Original-Message-ID: <CAK8P3a2zy2X9rivWcGaOB=c8SQ8Gcc8tm_6DMOmcQVKFift+Tg@mail.gmail.com>
Message-ID: <CAK8P3a2zy2X9rivWcGaOB=c8SQ8Gcc8tm_6DMOmcQVKFift+Tg@mail.gmail.com>
Subject: [GIT PULL, staging, net-next] wimax: move to staging
To:     gregkh <gregkh@linuxfoundation.org>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        driverdevel <devel@driverdev.osuosl.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        Inaky Perez-Gonzalez <inaky.perez-gonzalez@intel.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The following changes since commit 3650b228f83adda7e5ee532e2b90429c03f7b9ec:

  Linux 5.10-rc1 (2020-10-25 15:14:11 -0700)

are available in the Git repository at:

  git://git.kernel.org:/pub/scm/linux/kernel/git/arnd/playground.git
tags/wimax-staging

for you to fetch changes up to f54ec58fee837ec847cb8b50593e81bfaa46107f:

  wimax: move out to staging (2020-10-29 19:27:45 +0100)

----------------------------------------------------------------
wimax: move to staging

After I sent a fix for what appeared to be a harmless warning in
the wimax user interface code, the conclusion was that the whole
thing has most likely not been used in a very long time, and the
user interface possibly been broken since b61a5eea5904 ("wimax: use
genl_register_family_with_ops()").

Using a shared branch between net-next and staging should help
coordinate patches getting submitted against it.

----------------------------------------------------------------
Arnd Bergmann (2):
      wimax: fix duplicate initializer warning
      wimax: move out to staging

 Documentation/admin-guide/index.rst                |  1 -
 Documentation/networking/kapi.rst                  | 21 ----------------
 .../translations/zh_CN/admin-guide/index.rst       |  1 -
 MAINTAINERS                                        | 22 ----------------
 drivers/net/Kconfig                                |  2 --
 drivers/net/Makefile                               |  1 -
 drivers/net/wimax/Kconfig                          | 18 --------------
 drivers/net/wimax/Makefile                         |  2 --
 drivers/staging/Kconfig                            |  2 ++
 drivers/staging/Makefile                           |  1 +
 .../staging/wimax/Documentation}/i2400m.rst        |  0
 .../staging/wimax/Documentation}/index.rst         |  0
 .../staging/wimax/Documentation}/wimax.rst         |  0
 {net => drivers/staging}/wimax/Kconfig             |  6 +++++
 {net => drivers/staging}/wimax/Makefile            |  2 ++
 drivers/staging/wimax/TODO                         | 18 ++++++++++++++
 {net => drivers/staging}/wimax/debug-levels.h      |  2 +-
 {net => drivers/staging}/wimax/debugfs.c           |  2 +-
 drivers/{net => staging}/wimax/i2400m/Kconfig      |  0
 drivers/{net => staging}/wimax/i2400m/Makefile     |  0
 drivers/{net => staging}/wimax/i2400m/control.c    |  2 +-
 .../{net => staging}/wimax/i2400m/debug-levels.h   |  2 +-
 drivers/{net => staging}/wimax/i2400m/debugfs.c    |  0
 drivers/{net => staging}/wimax/i2400m/driver.c     |  2 +-
 drivers/{net => staging}/wimax/i2400m/fw.c         |  0
 drivers/{net => staging}/wimax/i2400m/i2400m-usb.h |  0
 drivers/{net => staging}/wimax/i2400m/i2400m.h     |  4 +--
 .../staging/wimax/i2400m/linux-wimax-i2400m.h      |  0
 drivers/{net => staging}/wimax/i2400m/netdev.c     |  0
 drivers/{net => staging}/wimax/i2400m/op-rfkill.c  |  2 +-
 drivers/{net => staging}/wimax/i2400m/rx.c         |  0
 drivers/{net => staging}/wimax/i2400m/sysfs.c      |  0
 drivers/{net => staging}/wimax/i2400m/tx.c         |  0
 .../wimax/i2400m/usb-debug-levels.h                |  2 +-
 drivers/{net => staging}/wimax/i2400m/usb-fw.c     |  0
 drivers/{net => staging}/wimax/i2400m/usb-notif.c  |  0
 drivers/{net => staging}/wimax/i2400m/usb-rx.c     |  0
 drivers/{net => staging}/wimax/i2400m/usb-tx.c     |  0
 drivers/{net => staging}/wimax/i2400m/usb.c        |  2 +-
 {net => drivers/staging}/wimax/id-table.c          |  2 +-
 .../staging/wimax/linux-wimax-debug.h              |  2 +-
 .../wimax.h => drivers/staging/wimax/linux-wimax.h |  0
 .../wimax.h => drivers/staging/wimax/net-wimax.h   |  2 +-
 {net => drivers/staging}/wimax/op-msg.c            |  2 +-
 {net => drivers/staging}/wimax/op-reset.c          |  4 +--
 {net => drivers/staging}/wimax/op-rfkill.c         |  4 +--
 {net => drivers/staging}/wimax/op-state-get.c      |  4 +--
 {net => drivers/staging}/wimax/stack.c             | 29 ++++++++++++++--------
 {net => drivers/staging}/wimax/wimax-internal.h    |  2 +-
 net/Kconfig                                        |  2 --
 net/Makefile                                       |  1 -
 51 files changed, 68 insertions(+), 103 deletions(-)
 delete mode 100644 drivers/net/wimax/Kconfig
 delete mode 100644 drivers/net/wimax/Makefile
 rename {Documentation/admin-guide/wimax =>
drivers/staging/wimax/Documentation}/i2400m.rst (100%)
 rename {Documentation/admin-guide/wimax =>
drivers/staging/wimax/Documentation}/index.rst (100%)
 rename {Documentation/admin-guide/wimax =>
drivers/staging/wimax/Documentation}/wimax.rst (100%)
 rename {net => drivers/staging}/wimax/Kconfig (94%)
 rename {net => drivers/staging}/wimax/Makefile (83%)
 create mode 100644 drivers/staging/wimax/TODO
 rename {net => drivers/staging}/wimax/debug-levels.h (96%)
 rename {net => drivers/staging}/wimax/debugfs.c (97%)
 rename drivers/{net => staging}/wimax/i2400m/Kconfig (100%)
 rename drivers/{net => staging}/wimax/i2400m/Makefile (100%)
 rename drivers/{net => staging}/wimax/i2400m/control.c (99%)
 rename drivers/{net => staging}/wimax/i2400m/debug-levels.h (96%)
 rename drivers/{net => staging}/wimax/i2400m/debugfs.c (100%)
 rename drivers/{net => staging}/wimax/i2400m/driver.c (99%)
 rename drivers/{net => staging}/wimax/i2400m/fw.c (100%)
 rename drivers/{net => staging}/wimax/i2400m/i2400m-usb.h (100%)
 rename drivers/{net => staging}/wimax/i2400m/i2400m.h (99%)
 rename include/uapi/linux/wimax/i2400m.h =>
drivers/staging/wimax/i2400m/linux-wimax-i2400m.h (100%)
 rename drivers/{net => staging}/wimax/i2400m/netdev.c (100%)
 rename drivers/{net => staging}/wimax/i2400m/op-rfkill.c (99%)
 rename drivers/{net => staging}/wimax/i2400m/rx.c (100%)
 rename drivers/{net => staging}/wimax/i2400m/sysfs.c (100%)
 rename drivers/{net => staging}/wimax/i2400m/tx.c (100%)
 rename drivers/{net => staging}/wimax/i2400m/usb-debug-levels.h (95%)
 rename drivers/{net => staging}/wimax/i2400m/usb-fw.c (100%)
 rename drivers/{net => staging}/wimax/i2400m/usb-notif.c (100%)
 rename drivers/{net => staging}/wimax/i2400m/usb-rx.c (100%)
 rename drivers/{net => staging}/wimax/i2400m/usb-tx.c (100%)
 rename drivers/{net => staging}/wimax/i2400m/usb.c (99%)
 rename {net => drivers/staging}/wimax/id-table.c (99%)
 rename include/linux/wimax/debug.h =>
drivers/staging/wimax/linux-wimax-debug.h (99%)
 rename include/uapi/linux/wimax.h => drivers/staging/wimax/linux-wimax.h (100%)
 rename include/net/wimax.h => drivers/staging/wimax/net-wimax.h (99%)
 rename {net => drivers/staging}/wimax/op-msg.c (99%)
 rename {net => drivers/staging}/wimax/op-reset.c (98%)
 rename {net => drivers/staging}/wimax/op-rfkill.c (99%)
 rename {net => drivers/staging}/wimax/op-state-get.c (96%)
 rename {net => drivers/staging}/wimax/stack.c (97%)
 rename {net => drivers/staging}/wimax/wimax-internal.h (99%)
