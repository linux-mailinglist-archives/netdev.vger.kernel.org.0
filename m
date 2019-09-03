Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DE212A61EE
	for <lists+netdev@lfdr.de>; Tue,  3 Sep 2019 08:55:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727123AbfICGyy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Sep 2019 02:54:54 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:45655 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727113AbfICGyt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Sep 2019 02:54:49 -0400
Received: by mail-pg1-f193.google.com with SMTP id 4so5035246pgm.12
        for <netdev@vger.kernel.org>; Mon, 02 Sep 2019 23:54:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=dZueRWZd1uZbZNG0riAle5evD2RPXFUMBIbKb1n2stM=;
        b=FGEtBmTw+UijXa25Ipc7xQ4tq+qIvfBqVg1NmnanWKkTe7yno7WjcxKffa1nMJRAxD
         AOYney+tqn0eT+NmaNjlkHQOanv2QIDA74pDFkjN2+P7BgoLwUFLkf7WRlMExbShWPkY
         li/3kKiY2mP6zBN27Xf9uW7QmC1Xh1uz3qOhy4WUq3vxN6fp1IjTUXp0jvN9sbegwtGr
         jBZD8enNnF01X7NkZsKZipwUc+J5nvDpaxa6aPgYmHKkqoD/xsVarFNXkIr2mGdpaGkC
         eWL7t0M4ytePKm2cj76neBQtC3gx6gqV2FTcsx3B5KgRrVZLgUaYfZ51ZUJWctoicY7C
         TIoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=dZueRWZd1uZbZNG0riAle5evD2RPXFUMBIbKb1n2stM=;
        b=FWd27JyBl7pEKr9TaDrwAgdMx5ZaHPifOmrkg5hBoh0DX6Pv6AECCEoGvicyLTOHki
         EctNwMyBVHoelzvcCqQmSFjA+H+XP26thWJVDfFFaMLjJVK/9hNAuikEfpa9gNJ47xiw
         uJurZgo21g7SB20Xky9AIoxpDl/7nJqJtTdCzGiAM5OH+l/+IOI4UPE2zkkNVd8g2uQ8
         SvdOGEyZLK8rGcQ7Zx3bBkTdOwg6rxd3DXN0dSlwFoC/ta8+5vRfWmiFI7Vxb5FK80u1
         bpSK+Eb70qnDAr/vFKJDJTcF9e2TkSW0P6QLTJ0t6JeRsVwOOg32pdr/1BEOIxJIIyVe
         DVfQ==
X-Gm-Message-State: APjAAAVhm01sgecmSrTcp1Ik9dw9n7XDXjxMe1RjmsWonC4k6YF5NZRe
        ak9T9kVrDQFAYZWJygGzNXasOA==
X-Google-Smtp-Source: APXvYqxkoDM0uGwkQpRgclz5RRJ0gAHteeMYv8Fxj1KTi5HwH2NFSQ2AQjYuF7bCDIFRGM9OMwEfJg==
X-Received: by 2002:a63:7887:: with SMTP id t129mr28954591pgc.309.1567493688797;
        Mon, 02 Sep 2019 23:54:48 -0700 (PDT)
Received: from baolinwangubtpc.spreadtrum.com ([117.18.48.82])
        by smtp.gmail.com with ESMTPSA id s7sm5872032pjn.8.2019.09.02.23.54.39
        (version=TLS1 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Mon, 02 Sep 2019 23:54:48 -0700 (PDT)
From:   Baolin Wang <baolin.wang@linaro.org>
To:     stable@vger.kernel.org, chris@chris-wilson.co.uk, airlied@linux.ie,
        davem@davemloft.net, kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org,
        edumazet@google.com, peterz@infradead.org, mingo@redhat.com,
        vyasevich@gmail.com, nhorman@tuxdriver.com,
        linus.walleij@linaro.org, natechancellor@gmail.com, sre@kernel.org,
        paulus@samba.org, gregkh@linuxfoundation.org
Cc:     intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
        netdev@vger.kernel.org, longman@redhat.com,
        hariprasad.kelam@gmail.com, linux-sctp@vger.kernel.org,
        linux-gpio@vger.kernel.org, david@lechnology.com,
        linux-pm@vger.kernel.org, ebiggers@google.com,
        linux-ppp@vger.kernel.org, lanqing.liu@unisoc.com,
        linux-serial@vger.kernel.org, arnd@arndb.de,
        baolin.wang@linaro.org, orsonzhai@gmail.com,
        vincent.guittot@linaro.org, linux-kernel@vger.kernel.org
Subject: [BACKPORT 4.14.y 0/8] Candidates from Spreadtrum 4.14 product kernel
Date:   Tue,  3 Sep 2019 14:53:46 +0800
Message-Id: <cover.1567492316.git.baolin.wang@linaro.org>
X-Mailer: git-send-email 1.7.9.5
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

With Arnd's script [1] help, I found some bugfixes in Spreadtrum 4.14 product
kernel, but missing in v4.14.141:

86fda90ab588 net: sctp: fix warning "NULL check before some freeing functions is not needed"
25a09ce79639 ppp: mppe: Revert "ppp: mppe: Add softdep to arc4"
d9b308b1f8a1 drm/i915/fbdev: Actually configure untiled displays
47d3d7fdb10a ip6: fix skb leak in ip6frag_expire_frag_queue()
5b9cea15a3de serial: sprd: Modify the baud rate calculation formula
513e1073d52e locking/lockdep: Add debug_locks check in __lock_downgrade()
957063c92473 pinctrl: sprd: Use define directive for sprd_pinconf_params values
87a2b65fc855 power: supply: sysfs: ratelimit property read error message

[1] https://lore.kernel.org/lkml/20190322154425.3852517-19-arnd@arndb.de/T/

Chris Wilson (1):
  drm/i915/fbdev: Actually configure untiled displays

David Lechner (1):
  power: supply: sysfs: ratelimit property read error message

Eric Biggers (1):
  ppp: mppe: Revert "ppp: mppe: Add softdep to arc4"

Eric Dumazet (1):
  ip6: fix skb leak in ip6frag_expire_frag_queue()

Hariprasad Kelam (1):
  net: sctp: fix warning "NULL check before some freeing functions is
    not needed"

Lanqing Liu (1):
  serial: sprd: Modify the baud rate calculation formula

Nathan Chancellor (1):
  pinctrl: sprd: Use define directive for sprd_pinconf_params values

Waiman Long (1):
  locking/lockdep: Add debug_locks check in __lock_downgrade()

 drivers/gpu/drm/i915/intel_fbdev.c        |   12 +++++++-----
 drivers/net/ppp/ppp_mppe.c                |    1 -
 drivers/pinctrl/sprd/pinctrl-sprd.c       |    6 ++----
 drivers/power/supply/power_supply_sysfs.c |    3 ++-
 drivers/tty/serial/sprd_serial.c          |    2 +-
 include/net/ipv6_frag.h                   |    1 -
 kernel/locking/lockdep.c                  |    3 +++
 net/sctp/sm_make_chunk.c                  |   12 ++++--------
 8 files changed, 19 insertions(+), 21 deletions(-)

-- 
1.7.9.5

