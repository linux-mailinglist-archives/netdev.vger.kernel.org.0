Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6290A54202F
	for <lists+netdev@lfdr.de>; Wed,  8 Jun 2022 02:24:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1382448AbiFHATF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jun 2022 20:19:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1588748AbiFGXzB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jun 2022 19:55:01 -0400
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F07D61B07A7
        for <netdev@vger.kernel.org>; Tue,  7 Jun 2022 16:36:20 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id gc3-20020a17090b310300b001e33092c737so16782769pjb.3
        for <netdev@vger.kernel.org>; Tue, 07 Jun 2022 16:36:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=RNoS+2GDifyrbLA4hlxQhVJkKbviNcn227b8+l+Oqkg=;
        b=du/UL++uxSKkluZsJrMPYpZcm3wWuYaQ2FJAYmNROFytkBwyyGSOZl+N6xxUfoEwoE
         MBsQ2CitEOwV5fEPUmK6kkP9komjOQwH93LwPkC60RrZM/HYlzejF6QARHhziqe9RHBF
         SaqRGEn+LVA8N6bwhY7R3eGIJHI8BqrcKbRVhDvVWpxI44nyqZ152peuOKPOGjdhxhFz
         uv6lhZcTkgWwZFY6yuekbEUOZE/4wCGftTDSByyEcpUaZ0Lu387zeOKshnBQQfQ6thHc
         Z+trdlt27bb2DG64N92/r/zZ0/EBBnwdjRir8Kt3GgmOVHbLt31pOsr6X1cqLQ0Ko/LL
         Q2Eg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=RNoS+2GDifyrbLA4hlxQhVJkKbviNcn227b8+l+Oqkg=;
        b=W2ajWAgiDNix7MtkW6VwXPZxbBO3yMQQEI3J5VN/Ajc3n96uCUgTNzf09I8MAvBCws
         R9Ti3P9nabtkvAoxCSWQ5/HUmioU3Onc1f0NbtT9TIZtuZVgXCBLUEWvP3HAl/ug66FX
         ATG8CK8TZSmFvL2cvslA6VYy9fzYz+6ERIIKFSVDM5/fN0cYcwy1i1Zk7sPexYm7qsXg
         Ru7ouPAjGY1nn7SyJHTbC9yKpMaNQQuEodIBqWNYF6wKpiCEe3bAipZhHHE8VY6Q4tfR
         t3DceRXA7irdSvPrexoabvzq4mTzBMPrcQHEYaTaY3I5Qo+Gon0azgwu4FeNG0t6U3zs
         kXBA==
X-Gm-Message-State: AOAM531PZGjklraJNONKATZLznErksEfKnQzFt2LCHdjJF60lGqNmOxR
        61lRGMgb8i+jW2iYazoNw90=
X-Google-Smtp-Source: ABdhPJyB09p7FqZQ4TvWS+w7C+7thQGxz1WSJDdsVopjaMFftnQMZQDUFexN6ZnCo2pwSB3o5Dqx8Q==
X-Received: by 2002:a17:902:ce88:b0:163:dbd5:9797 with SMTP id f8-20020a170902ce8800b00163dbd59797mr31305436plg.82.1654644980245;
        Tue, 07 Jun 2022 16:36:20 -0700 (PDT)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:191a:13a7:b80a:f36e])
        by smtp.gmail.com with ESMTPSA id u79-20020a627952000000b0051ba7515e0dsm13550947pfc.54.2022.06.07.16.36.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Jun 2022 16:36:19 -0700 (PDT)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev <netdev@vger.kernel.org>,
        "Jason A . Donenfeld" <Jason@zx2c4.com>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH net-next 0/9] net: 
Date:   Tue,  7 Jun 2022 16:36:05 -0700
Message-Id: <20220607233614.1133902-1-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.36.1.255.ge46751e96f-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

While KCSAN has not raised any reports yet, we should address the
potential load/store tearing problem happening with per cpu stats.

This series is not exhaustive, but hopefully a step in the right
direction.

Eric Dumazet (9):
  vlan: adopt u64_stats_t
  ipvlan: adopt u64_stats_t
  sit: use dev_sw_netstats_rx_add()
  ip6_tunnel: use dev_sw_netstats_rx_add()
  wireguard: use dev_sw_netstats_rx_add()
  net: adopt u64_stats_t in struct pcpu_sw_netstats
  devlink: adopt u64_stats_t
  drop_monitor: adopt u64_stats_t
  team: adopt u64_stats_t

 drivers/net/ipvlan/ipvlan.h      | 10 ++++-----
 drivers/net/ipvlan/ipvlan_core.c |  6 +++---
 drivers/net/ipvlan/ipvlan_main.c | 18 ++++++++--------
 drivers/net/macsec.c             |  8 +++----
 drivers/net/macvlan.c            | 18 ++++++++--------
 drivers/net/team/team.c          | 26 +++++++++++------------
 drivers/net/usb/usbnet.c         |  8 +++----
 drivers/net/vxlan/vxlan_core.c   |  8 +++----
 drivers/net/wireguard/receive.c  |  9 +-------
 include/linux/if_macvlan.h       |  6 +++---
 include/linux/if_team.h          | 10 ++++-----
 include/linux/if_vlan.h          | 10 ++++-----
 include/linux/netdevice.h        | 16 +++++++-------
 include/net/ip_tunnels.h         |  4 ++--
 net/8021q/vlan_core.c            |  6 +++---
 net/8021q/vlan_dev.c             | 18 ++++++++--------
 net/bridge/br_netlink.c          |  8 +++----
 net/bridge/br_vlan.c             | 36 ++++++++++++++++++--------------
 net/core/dev.c                   | 18 ++++++++--------
 net/core/devlink.c               | 28 ++++++++++++++-----------
 net/core/drop_monitor.c          | 18 ++++++++--------
 net/dsa/slave.c                  |  8 +++----
 net/ipv6/ip6_tunnel.c            |  7 +------
 net/ipv6/sit.c                   |  8 +------
 24 files changed, 151 insertions(+), 161 deletions(-)

-- 
2.36.1.255.ge46751e96f-goog

