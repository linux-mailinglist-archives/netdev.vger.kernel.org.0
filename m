Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C19B14DBFA6
	for <lists+netdev@lfdr.de>; Thu, 17 Mar 2022 07:50:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229971AbiCQGwB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Mar 2022 02:52:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229961AbiCQGwB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Mar 2022 02:52:01 -0400
Received: from mail-lf1-x136.google.com (mail-lf1-x136.google.com [IPv6:2a00:1450:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B069CDFD5D
        for <netdev@vger.kernel.org>; Wed, 16 Mar 2022 23:50:41 -0700 (PDT)
Received: by mail-lf1-x136.google.com with SMTP id g17so7454515lfh.2
        for <netdev@vger.kernel.org>; Wed, 16 Mar 2022 23:50:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=LLyeLK0Bo8dJWXBBj3APesdSWO55G8dpc4yHaELlxIA=;
        b=Rrwqo8A69IfVpPfWQ+xwA7yqnDWW43Kq3cWCRn0fQ6mKCp55qi0U90lW/qvBTFTw6Q
         DqHGe5fW1qd/XmTz0hnTkX21abjXDHOyfrpsnsTeuE21neDNIq5+xf/o3ZPQQq5b5NAl
         y1PtIrNXS3SPtibx7GKNQlrZ/xp6SCIjP1F9GRenkaSLReau+jxS423TMfSwRSX8yGXi
         9EDuLJ3GT9Oa4aX8gs4/DZ4tdpajheVUVlTGCOVw7KuO0kTpalCNiJvOpSiPBz9w4bZX
         78BbLloRv0oRn6Rm7uUqxWt5iiLt3CUioMlp0YVexmqmNtKf0OtSqQERSUkHWwRSC2RK
         Ks0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=LLyeLK0Bo8dJWXBBj3APesdSWO55G8dpc4yHaELlxIA=;
        b=PwQZ/RTces2W3HfsC+ajuzYPa68SHzR7vgQsttPZ4VtnlSzUgNDJBHUeh1xxlJ0TZn
         ddX+uy8pUoxOX1T+/4OH7vvpdW7Vx67f8XFQ4Sxim+z+gF4qAlaNhgaGy7QNdpyudql9
         IMJVNPZJLxgsinz72JZGcXC1Bh8Ul14sXyzLdZotW9L0pAE8Xp7MqPTdfucFu1gDuAqT
         j6njIiod2PorJGVhm2cv6lVC7jq0sb2q792bTqVSta3nWLMmvTSg72TNavzFeAyFq0E7
         NRamvx0QmRzQmAUREnKXLLpMX1aofHxxtoVACqSc2Fqe9GzCF7BTYfsj6HrfRGRwRujr
         W09w==
X-Gm-Message-State: AOAM531Z4DN2tVdZU2J8zdg6dQwdnZOurN++xhlUTzBsd++hnI4Rs0Sp
        kMHz6CqAbsiPVDc6COYddYlsXtYVitIwV+Ya
X-Google-Smtp-Source: ABdhPJx3ZdBjsgX/4g++3uyC0259ZW0NfO8pchd5ajPZeSQO0h/C9xXQ7Bz7748oOQ7hCNNw/Wj+9A==
X-Received: by 2002:ac2:5e21:0:b0:448:b7b7:c9f with SMTP id o1-20020ac25e21000000b00448b7b70c9fmr1889347lfg.423.1647499839093;
        Wed, 16 Mar 2022 23:50:39 -0700 (PDT)
Received: from wse-c0089.raspi.local (h-98-128-237-157.A259.priv.bahnhof.se. [98.128.237.157])
        by smtp.gmail.com with ESMTPSA id l25-20020ac25559000000b0044825a2539csm362215lfk.59.2022.03.16.23.50.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Mar 2022 23:50:38 -0700 (PDT)
From:   Mattias Forsblad <mattias.forsblad@gmail.com>
To:     netdev@vger.kernel.org
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        Mattias Forsblad <mattias.forsblad@gmail.com>
Subject: [PATCH v3 net-next 0/5] bridge: dsa: switchdev: mv88e6xxx: Implement bridge flood flags
Date:   Thu, 17 Mar 2022 07:50:26 +0100
Message-Id: <20220317065031.3830481-1-mattias.forsblad@gmail.com>
X-Mailer: git-send-email 2.25.1
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

Greetings,

This series implements new bridge flood flags
{flood,mcast_flood,bcast_flood}
and HW offloading for Marvell mv88e6xxx.

When using a non-VLAN filtering bridge we want to be able to limit
traffic to the CPU port to lessen the CPU load. This is specially
important when we have disabled learning on user ports.

A sample configuration could be something like this:

       br0
      /   \
   swp0   swp1

ip link add dev br0 type bridge stp_state 0 vlan_filtering 0
ip link set swp0 master br0
ip link set swp1 master br0
ip link set swp0 type bridge_slave learning off
ip link set swp1 type bridge_slave learning off
ip link set swp0 up
ip link set swp1 up
ip link set br0 type bridge flood 0 mcast_flood 0 bcast_flood 0
ip link set br0 up

To further explain the reasoning for this please refer to post by
Tobias Waldekranz:
https://lore.kernel.org/netdev/87ilsxo052.fsf@waldekranz.com/

The first part(1,2) of the series implements the flags for the SW bridge
and the second part(3) the DSA infrastructure. Part (4) implements
offloading of this flag to HW for mv88e6xxx, which uses the
port vlan table to restrict the ingress from user ports
to the CPU port when all of the flag is cleared. Part (5) adds
selftests for these flags.

v2 -> v3:
  - Fixed compile warnings (Jakub Kicinski, lkp@intel.com)
  
v1 -> v2:
  - Split patch series in a more consistent way (Ido Shimmel)
  - Drop sysfs implementation (Ido, Nikolay Aleksandrov)
  - Change to use the boolopt API (Nikolay)
  - Drop ioctl implementation (Nikolay)
  - Split and rename local_receive to match bridge_slave
    {flood,mcast_flood,bcast_flood} (Ido)
  - Only handle the flags at apropiate places in the hot-path (Ido)
  - Add selftest (Ido)
  
Mattias Forsblad (5):
  switchdev: Add local_receive attribute
  net: bridge: Implement bridge flood flag
  dsa: Handle the flood flag in the DSA layer.
  mv88e6xxx: Offload the flood flag
  selftest: Add bridge flood flag tests

 drivers/net/dsa/mv88e6xxx/chip.c              |  45 ++++-
 include/linux/if_bridge.h                     |   6 +
 include/net/dsa.h                             |   7 +
 include/net/switchdev.h                       |   1 +
 include/uapi/linux/if_bridge.h                |   9 +-
 net/bridge/br.c                               |  46 +++++
 net/bridge/br_device.c                        |   3 +
 net/bridge/br_input.c                         |  23 ++-
 net/bridge/br_private.h                       |   4 +
 net/dsa/dsa_priv.h                            |   2 +
 net/dsa/slave.c                               |  18 ++
 .../testing/selftests/net/forwarding/Makefile |   1 +
 .../selftests/net/forwarding/bridge_flood.sh  | 169 ++++++++++++++++++
 tools/testing/selftests/net/forwarding/lib.sh |   8 +
 14 files changed, 335 insertions(+), 7 deletions(-)
 create mode 100755 tools/testing/selftests/net/forwarding/bridge_flood.sh

-- 
2.25.1

