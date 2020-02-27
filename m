Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 790331711B3
	for <lists+netdev@lfdr.de>; Thu, 27 Feb 2020 08:50:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728455AbgB0HuZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Feb 2020 02:50:25 -0500
Received: from mail-wr1-f67.google.com ([209.85.221.67]:43693 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727661AbgB0HuY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Feb 2020 02:50:24 -0500
Received: by mail-wr1-f67.google.com with SMTP id c13so2020425wrq.10
        for <netdev@vger.kernel.org>; Wed, 26 Feb 2020 23:50:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=jB/sTRteWZ9jdQS/ghmQ033Z3sQv1bwzUEePogES9Vk=;
        b=UJKI9HJcyqId6xAsTPOByYiPFVDeqWXIJoSif8pD5T/ZskUkqGPYDeQmF9e6iF8v0D
         wPoJGu9lhUNf3wpwPJ1/PHiZzUtNtNWH/0ycd1QEXrocXmGyhKLXJA8eXGvAyHdu1mNk
         3gzDqYb/YLH9Fx0EI5C2C7p3jTEwa2o4eZTXvTdiyNxfQV4AgM/YyksMu4IH/cgRUF0B
         Ck/mlDxi4Ca+Wb9C8hhBI6yR98e+Ox8jdZoX5H3y3QjiZB+y3TT8QTz+A44wSfK3rShQ
         z/+MRDyYwtll2oQpd1f/bRlys1D5ZoS/vqjbpKxs0+AJNTamrOg9L+fOvpy9g0UpT1QX
         hTlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=jB/sTRteWZ9jdQS/ghmQ033Z3sQv1bwzUEePogES9Vk=;
        b=UZyiaXoPfa/kn4J1AYKGbxT2w19SZm8ZNk76U7XdH1YXlNI4DF6PF+Y8I1L4Sc6uiw
         xdupTS/WbqzpJ2QRIN+JjgDB6Mih7/6nz6hUq6kyi6JvvK/UGY2RbQ1CqrzRv71wAV/0
         Z8RMZp8UneEaniNOQPOJWi8Bo2Yh1kk6AEnuv/ngqZThtjjMw9PK5g0Z7Tv+VNkhWudR
         mrGJDq9kgK2AcxMCzxq8htoxtS/13GOwXZclBA/StFieVrS+2vEPl3uDnes6Fc21x3fl
         Nb6uI5r7IBuHQ67TIfsds981TH/pg+FR47nEXfHBhGHcGP0FCyL0JeEpt1oXitYuTN/Z
         ZjUQ==
X-Gm-Message-State: APjAAAUI+SY0Jm6id3AewCBBjKeKSrEpjgGWVbOO87dStxtfNnr4cgT3
        Njmd7Oc3w6tz4Sv+mET+pn+KL8Wgyps=
X-Google-Smtp-Source: APXvYqxAHjtamsF5jaiKX71Em0gwYkWwGKKfPYUxoHVmpHe5kc2O0jnVPPb18wfPwLo9lWOcXo4Uag==
X-Received: by 2002:a5d:4bd0:: with SMTP id l16mr3440184wrt.271.1582789822523;
        Wed, 26 Feb 2020 23:50:22 -0800 (PST)
Received: from localhost (ip-89-177-130-96.net.upcbroadband.cz. [89.177.130.96])
        by smtp.gmail.com with ESMTPSA id a7sm2645437wmb.0.2020.02.26.23.50.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Feb 2020 23:50:22 -0800 (PST)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, idosch@mellanox.com,
        mlxsw@mellanox.com, shuah@kernel.org
Subject: [patch net-next 00/16] selftests: updates for mlxsw driver test
Date:   Thu, 27 Feb 2020 08:50:05 +0100
Message-Id: <20200227075021.3472-1-jiri@resnulli.us>
X-Mailer: git-send-email 2.21.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@mellanox.com>

This patchset contains tweaks to the existing tests and is also adding
couple of new ones, namely tests for shared buffer and red offload.

Amit Cohen (1):
  selftests: mlxsw: resource_scale: Invoke for Spectrum-3

Danielle Ratson (5):
  selftests: mlxsw: Use busywait helper in blackhole routes test
  selftests: mlxsw: Use busywait helper in vxlan test
  selftests: mlxsw: Use busywait helper in rtnetlink test
  selftests: mlxsw: Reduce running time using offload indication
  selftests: mlxsw: Reduce router scale running time using offload
    indication

Ido Schimmel (1):
  selftests: devlink_trap_l3_drops: Avoid race condition

Jiri Pirko (2):
  selftests: add egress redirect test to mlxsw tc flower restrictions
  selftests: add a mirror test to mlxsw tc flower restrictions

Petr Machata (2):
  selftests: forwarding: lib.sh: Add start_tcp_traffic
  selftests: mlxsw: Add a RED selftest

Shalom Toledo (5):
  selftests: mlxsw: Add shared buffer configuration test
  selftests: devlink_lib: Check devlink info command is supported
  selftests: devlink_lib: Add devlink port helpers
  selftests: mlxsw: Add mlxsw lib
  selftests: mlxsw: Add shared buffer traffic test

 .../drivers/net/mlxsw/blackhole_routes.sh     |   5 +-
 .../net/mlxsw/devlink_trap_l3_drops.sh        |  11 +-
 .../selftests/drivers/net/mlxsw/mlxsw_lib.sh  |  13 +
 .../drivers/net/mlxsw/router_scale.sh         |  53 +-
 .../selftests/drivers/net/mlxsw/rtnetlink.sh  |  68 ++-
 .../drivers/net/mlxsw/sch_red_core.sh         | 499 ++++++++++++++++++
 .../drivers/net/mlxsw/sch_red_ets.sh          |  83 +++
 .../drivers/net/mlxsw/sch_red_prio.sh         |   5 +
 .../drivers/net/mlxsw/sch_red_root.sh         |  60 +++
 .../drivers/net/mlxsw/sharedbuffer.sh         | 222 ++++++++
 .../net/mlxsw/sharedbuffer_configuration.py   | 416 +++++++++++++++
 .../net/mlxsw/spectrum-2/resource_scale.sh    |   5 +-
 .../net/mlxsw/tc_flower_restrictions.sh       |  88 ++-
 .../drivers/net/mlxsw/tc_flower_scale.sh      |  31 +-
 .../selftests/drivers/net/mlxsw/vxlan.sh      | 206 ++++----
 .../selftests/net/forwarding/devlink_lib.sh   |  22 +
 tools/testing/selftests/net/forwarding/lib.sh |  52 +-
 17 files changed, 1653 insertions(+), 186 deletions(-)
 create mode 100644 tools/testing/selftests/drivers/net/mlxsw/mlxsw_lib.sh
 create mode 100644 tools/testing/selftests/drivers/net/mlxsw/sch_red_core.sh
 create mode 100755 tools/testing/selftests/drivers/net/mlxsw/sch_red_ets.sh
 create mode 100755 tools/testing/selftests/drivers/net/mlxsw/sch_red_prio.sh
 create mode 100755 tools/testing/selftests/drivers/net/mlxsw/sch_red_root.sh
 create mode 100755 tools/testing/selftests/drivers/net/mlxsw/sharedbuffer.sh
 create mode 100755 tools/testing/selftests/drivers/net/mlxsw/sharedbuffer_configuration.py

-- 
2.21.1

