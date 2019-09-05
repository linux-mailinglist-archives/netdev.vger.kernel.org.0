Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 71A86A98AF
	for <lists+netdev@lfdr.de>; Thu,  5 Sep 2019 05:05:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730996AbfIEDFs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Sep 2019 23:05:48 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:43196 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729366AbfIEDFs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Sep 2019 23:05:48 -0400
Received: by mail-pl1-f194.google.com with SMTP id 4so554459pld.10
        for <netdev@vger.kernel.org>; Wed, 04 Sep 2019 20:05:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=LeRnFkCkMBcGZ5PE2AX045vU+t/z+Mh9Iis8KFnVK34=;
        b=YssohchZvGx19/YD9qDr9FKNorWv8ge7xcRcxMroT0Em375aRGQxpz1UApKthij/dQ
         RR08hv1hMWzLHtx431Ru+YRmbw8uM3Wm8a8v2J5ZvsgJEq8jq0J8Vt0XKEmIQtmzwG2L
         PqKS4SCLY/gNN3nG4YYnR4IQ5AQwQLQzX5JygGDUCBScptFQcE3uI1ZgVGuoUv6xcS/4
         Nx418BiqkGEcdbYuMHEOg5HAXiJC1IU3Tm6UzULr9j8e/qJLkqJAg1AQkbeZmV9eqjS3
         729wdCeXzFivEUv/ksYRE4zxVcQwLvbSeAj01Cr8Ye+f3h55o/f9ZHkxpX6tkqfOZW3w
         Ck5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=LeRnFkCkMBcGZ5PE2AX045vU+t/z+Mh9Iis8KFnVK34=;
        b=SWDAOe6RQnbPXm3EJTjGkXvjOqTiz4RmSLfw4BhId9Hy12Tgmgw1KBZe3S+EkXczcM
         9wUT1opKXnv0fBSQv2tm4WthyyL5hHhWdmXDdq5Xt+wJzdsOfDc/1dnOCQWKyePidF9l
         uXawBE0B4qIIeiGnO3b7oJUA7RGzovhuZJPgTkWn5Dwub2i5XIvnggI69IEwk750U73J
         KF5kw/M3vlO42VxkNMRhLdPnRqV2e9+dOEgensaoOiO+ic5qt2YK0trEFRtdBAhm+dmC
         AU4+IxoUf3axg81f0Cb3svHIdzqxREqH1DQxZEUsseH1BBEQgUZR1tftVqUCxcm5bxO3
         pl2Q==
X-Gm-Message-State: APjAAAWE7DJSndM0Kp2N3ss8fHLYpihs9U9Quy9Xl/U6Fnu7lwJya4kO
        FCFj7JohV6W9/2MYlo8dPWJUzw==
X-Google-Smtp-Source: APXvYqwF/B6Fv6rynYjc4aoz0HpuKRLUOBb10pA1gDu1IfehSXhqxMdvOgRtb8P8EEKiBOs0N729vg==
X-Received: by 2002:a17:902:b604:: with SMTP id b4mr1035768pls.197.1567652747501;
        Wed, 04 Sep 2019 20:05:47 -0700 (PDT)
Received: from baolinwangubtpc.spreadtrum.com ([117.18.48.82])
        by smtp.gmail.com with ESMTPSA id z68sm403810pgz.88.2019.09.04.20.05.40
        (version=TLS1 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Wed, 04 Sep 2019 20:05:46 -0700 (PDT)
From:   Baolin Wang <baolin.wang@linaro.org>
To:     stable@vger.kernel.org, davem@davemloft.net, kuznet@ms2.inr.ac.ru,
        yoshfuji@linux-ipv6.org, peterz@infradead.org, mingo@redhat.com,
        linus.walleij@linaro.org, natechancellor@gmail.com, sre@kernel.org,
        paulus@samba.org, gregkh@linuxfoundation.org
Cc:     edumazet@google.com, netdev@vger.kernel.org, longman@redhat.com,
        linux-gpio@vger.kernel.org, david@lechnology.com,
        linux-pm@vger.kernel.org, ebiggers@google.com,
        linux-ppp@vger.kernel.org, lanqing.liu@unisoc.com,
        linux-serial@vger.kernel.org, arnd@arndb.de,
        baolin.wang@linaro.org, orsonzhai@gmail.com,
        vincent.guittot@linaro.org, linux-kernel@vger.kernel.org
Subject: [BACKPORT 4.14.y v2 0/6] Candidates from Spreadtrum 4.14 product kernel
Date:   Thu,  5 Sep 2019 11:05:07 +0800
Message-Id: <cover.1567649728.git.baolin.wang@linaro.org>
X-Mailer: git-send-email 1.7.9.5
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

With Arnd's script [1] help, I found some bugfixes in Spreadtrum 4.14 product
kernel, but missing in v4.14.141:

25a09ce79639 ppp: mppe: Revert "ppp: mppe: Add softdep to arc4"
47d3d7fdb10a ip6: fix skb leak in ip6frag_expire_frag_queue()
5b9cea15a3de serial: sprd: Modify the baud rate calculation formula
513e1073d52e locking/lockdep: Add debug_locks check in __lock_downgrade()
957063c92473 pinctrl: sprd: Use define directive for sprd_pinconf_params values
87a2b65fc855 power: supply: sysfs: ratelimit property read error message

[1] https://lore.kernel.org/lkml/20190322154425.3852517-19-arnd@arndb.de/T/

Changes from v1:
 - Drop 2 unnecessary patches (patch 1 and patch 4) from v1 patch set.
 - Add upstream commit id in change log for each stable patch.

David Lechner (1):
  power: supply: sysfs: ratelimit property read error message

Eric Biggers (1):
  ppp: mppe: Revert "ppp: mppe: Add softdep to arc4"

Eric Dumazet (1):
  ip6: fix skb leak in ip6frag_expire_frag_queue()

Lanqing Liu (1):
  serial: sprd: Modify the baud rate calculation formula

Nathan Chancellor (1):
  pinctrl: sprd: Use define directive for sprd_pinconf_params values

Waiman Long (1):
  locking/lockdep: Add debug_locks check in __lock_downgrade()

 drivers/net/ppp/ppp_mppe.c                |    1 -
 drivers/pinctrl/sprd/pinctrl-sprd.c       |    6 ++----
 drivers/power/supply/power_supply_sysfs.c |    3 ++-
 drivers/tty/serial/sprd_serial.c          |    2 +-
 include/net/ipv6_frag.h                   |    1 -
 kernel/locking/lockdep.c                  |    3 +++
 6 files changed, 8 insertions(+), 8 deletions(-)

-- 
1.7.9.5

