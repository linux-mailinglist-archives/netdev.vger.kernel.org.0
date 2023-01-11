Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C0CFA665233
	for <lists+netdev@lfdr.de>; Wed, 11 Jan 2023 04:17:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230131AbjAKDRT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Jan 2023 22:17:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229653AbjAKDRR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Jan 2023 22:17:17 -0500
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0C6DC769
        for <netdev@vger.kernel.org>; Tue, 10 Jan 2023 19:17:15 -0800 (PST)
Received: by mail-pl1-x62c.google.com with SMTP id d15so15370544pls.6
        for <netdev@vger.kernel.org>; Tue, 10 Jan 2023 19:17:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=9fUXn5crzb/9m8DrJA5PFE2Z7lSmcG4Rs/Z1KxcjmkY=;
        b=o3Ch5oaqtX/Gdxlvmb7wRGDMt4de/OS6wIowvJrr2Rm8qwDUoNBEX28a3ok2Z5CMUh
         o6qKi1U0DEqiIKhOvjlj2ooXb+IlNhiogW+pDJMmRiG6/3hMtr+K3E0LF/UdLtiudha1
         JmB7ADFc+DDGugDpFsQZ0vplta7Sz2p+Ef1fxd09gdbyquX3s0+5I3ub2cM5ChFQezNW
         XRAJpIrufpGKzdgLhpLPasiUAMt8+7pziaGPdqnszAusvv3LeFiFIhhUIOoYoUebZxH5
         +bwFH6qQD+Nq//saWJxp3h8MRBuZZ/D7Y2+nrnQDCr9Fi8TLG7n3NczR2wIZos/urhFt
         /Obg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=9fUXn5crzb/9m8DrJA5PFE2Z7lSmcG4Rs/Z1KxcjmkY=;
        b=uWKpQvYTzPN9jCccfoSLftqs+HUbhxJji9a61EDoCs5yTS/5sVG8R6KbKcxjBhJ1Mb
         oBHIoxmr/zClV+458KVTB++De31xqadUlNGiDqVqUS93rRykDHUjxTsdcVkcJ192NUuW
         xXBsjxtZlt/eHamITRfBAp8vPMixxtKZzJo+jLNRp/DxBix7J5s7TUiJs7lJCejgCryB
         t5JFnitcJSKrV2oseNMYP30OUbU2RC0P6g4HsluUdnR4PebeDg+Ngkf9irt/u4ns5nVj
         7aKlIXHnLCwjGhMFnW1RwT5Lmfee4Q5svpzH5XMErXdVh2YBgjUyl9AyfGb9LXUq9lnA
         EQXQ==
X-Gm-Message-State: AFqh2komNyAbAngygdcu0SKu3RHQM0CxnAlW2UQiQ9Od2IxNNz1G0fHM
        6Lqtyc9bO6R8iZTbjhqmROoRZP/yD0RK4XZz1co=
X-Google-Smtp-Source: AMrXdXs9edEl1a5oMJhR7v7zb8CHvwhKFHdVGa9LbsJ3oj9S7YFy3yrI79QuBldOLtnDTDo+sADUnQ==
X-Received: by 2002:a17:902:7586:b0:189:30cd:8fa2 with SMTP id j6-20020a170902758600b0018930cd8fa2mr1018213pll.50.1673407034975;
        Tue, 10 Jan 2023 19:17:14 -0800 (PST)
Received: from hermes.local (204-195-120-218.wavecable.com. [204.195.120.218])
        by smtp.gmail.com with ESMTPSA id h5-20020a170902f7c500b0019337bf957dsm4226756plw.296.2023.01.10.19.17.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Jan 2023 19:17:14 -0800 (PST)
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     netdev@vger.kernel.org
Cc:     Stephen Hemminger <stephen@networkplumber.org>
Subject: [PATCH iproute2 00/10] SPDX cleanups
Date:   Tue, 10 Jan 2023 19:17:02 -0800
Message-Id: <20230111031712.19037-1-stephen@networkplumber.org>
X-Mailer: git-send-email 2.39.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Cleanout the GPL boiler plate in iproute.
Better to use modern SPDX to document the license
rather than copy/paste same text in multiple places.

There is no change in licensing here, and none is planned.

Stephen Hemminger (10):
  bridge: use SPDX
  genl: use SPDX
  lib: replace GPL boilerplate with SPDX
  devlink: use SPDX
  ip: use SPDX
  testsuite: use SPDX
  tipc: use SPDX
  tc: replace GPL-BSD boilerplate in codel and fq
  tc: use SPDX
  misc: use SPDX

 bridge/monitor.c                 |  7 +------
 devlink/devlink.c                |  6 +-----
 devlink/mnlg.c                   |  6 +-----
 devlink/mnlg.h                   |  6 +-----
 genl/ctrl.c                      |  6 +-----
 genl/genl.c                      |  7 +------
 ip/ip.c                          |  6 +-----
 ip/ip6tunnel.c                   | 15 +--------------
 ip/ipaddress.c                   |  7 +------
 ip/ipaddrlabel.c                 | 16 +---------------
 ip/ipfou.c                       |  6 +-----
 ip/ipila.c                       |  6 +-----
 ip/ipl2tp.c                      |  7 +------
 ip/iplink.c                      |  7 +------
 ip/iplink_amt.c                  |  6 +-----
 ip/iplink_bond.c                 |  6 +-----
 ip/iplink_bond_slave.c           |  6 +-----
 ip/iplink_bridge.c               |  6 +-----
 ip/iplink_bridge_slave.c         |  6 +-----
 ip/iplink_can.c                  |  6 +-----
 ip/iplink_geneve.c               |  6 +-----
 ip/iplink_hsr.c                  |  6 +-----
 ip/iplink_ipoib.c                |  6 +-----
 ip/iplink_ipvlan.c               |  6 +-----
 ip/iplink_macvlan.c              |  6 +-----
 ip/iplink_netdevsim.c            |  1 +
 ip/iplink_vlan.c                 |  6 +-----
 ip/iplink_vrf.c                  |  6 +-----
 ip/iplink_vxcan.c                |  6 +-----
 ip/iplink_vxlan.c                |  6 +-----
 ip/iplink_xdp.c                  |  6 +-----
 ip/iplink_xstats.c               |  6 +-----
 ip/ipmacsec.c                    |  6 +-----
 ip/ipmaddr.c                     |  7 +------
 ip/ipmonitor.c                   |  7 +------
 ip/ipmroute.c                    |  7 +------
 ip/ipneigh.c                     |  7 +------
 ip/ipnetconf.c                   |  7 +------
 ip/ipntable.c                    | 18 ++----------------
 ip/ipprefix.c                    | 17 ++---------------
 ip/iproute.c                     |  7 +------
 ip/iproute_lwtunnel.c            |  7 +------
 ip/iprule.c                      |  7 +------
 ip/ipseg6.c                      |  5 +----
 ip/iptoken.c                     |  6 +-----
 ip/iptunnel.c                    |  7 +------
 ip/iptuntap.c                    |  7 +------
 ip/ipvrf.c                       |  7 +------
 ip/ipxfrm.c                      | 20 ++------------------
 ip/link_gre.c                    |  7 +------
 ip/link_gre6.c                   |  7 +------
 ip/link_ip6tnl.c                 |  7 +------
 ip/link_iptnl.c                  |  7 +------
 ip/link_veth.c                   |  7 +------
 ip/link_vti.c                    |  6 +-----
 ip/link_vti6.c                   |  6 +-----
 ip/rtm_map.c                     |  7 +------
 ip/rtmon.c                       |  7 +------
 ip/tcp_metrics.c                 |  5 +----
 ip/tunnel.c                      | 18 ++----------------
 ip/tunnel.h                      | 15 +--------------
 ip/xfrm.h                        | 17 +----------------
 ip/xfrm_monitor.c                | 20 ++------------------
 ip/xfrm_policy.c                 | 20 ++------------------
 ip/xfrm_state.c                  | 20 ++------------------
 lib/bpf_legacy.c                 |  6 +-----
 lib/cg_map.c                     |  6 +-----
 lib/fs.c                         |  7 +------
 lib/inet_proto.c                 |  7 +------
 lib/json_print.c                 |  8 ++------
 lib/libnetlink.c                 |  7 +------
 lib/ll_addr.c                    |  6 +-----
 lib/ll_map.c                     |  7 +------
 lib/ll_proto.c                   |  5 +----
 lib/ll_types.c                   |  6 +-----
 lib/names.c                      |  7 +------
 lib/namespace.c                  |  6 +-----
 lib/rt_names.c                   |  6 +-----
 lib/utils.c                      |  7 +------
 misc/arpd.c                      |  6 +-----
 misc/ifstat.c                    |  6 +-----
 misc/lnstat.c                    |  7 +------
 misc/lnstat_util.c               |  7 +------
 misc/nstat.c                     |  6 +-----
 misc/rtacct.c                    |  7 +------
 misc/ss.c                        |  6 +-----
 tc/e_bpf.c                       |  6 +-----
 tc/em_canid.c                    |  6 +-----
 tc/em_cmp.c                      |  6 +-----
 tc/em_ipset.c                    |  5 +----
 tc/em_ipt.c                      |  5 +----
 tc/em_meta.c                     |  6 +-----
 tc/em_nbyte.c                    |  6 +-----
 tc/em_u32.c                      |  6 +-----
 tc/f_basic.c                     |  7 +------
 tc/f_bpf.c                       |  6 +-----
 tc/f_cgroup.c                    |  7 +------
 tc/f_flow.c                      |  6 +-----
 tc/f_flower.c                    |  6 +-----
 tc/f_fw.c                        |  7 +------
 tc/f_matchall.c                  |  7 +------
 tc/f_route.c                     |  7 +------
 tc/f_rsvp.c                      |  7 +------
 tc/f_u32.c                       |  6 +-----
 tc/m_action.c                    |  6 +-----
 tc/m_bpf.c                       |  6 +-----
 tc/m_connmark.c                  | 13 +------------
 tc/m_csum.c                      |  6 +-----
 tc/m_ematch.c                    |  6 +-----
 tc/m_estimator.c                 |  7 +------
 tc/m_gact.c                      |  7 +------
 tc/m_ife.c                       |  7 +------
 tc/m_ipt.c                       |  6 +-----
 tc/m_mirred.c                    |  7 +------
 tc/m_nat.c                       |  7 +------
 tc/m_pedit.c                     |  7 +------
 tc/m_pedit.h                     |  5 +----
 tc/m_police.c                    | 10 +---------
 tc/m_sample.c                    |  7 +------
 tc/m_simple.c                    |  6 +-----
 tc/m_skbedit.c                   | 14 +-------------
 tc/m_skbmod.c                    |  7 +------
 tc/m_tunnel_key.c                |  6 +-----
 tc/m_vlan.c                      |  6 +-----
 tc/m_xt.c                        |  6 +-----
 tc/m_xt_old.c                    |  6 +-----
 tc/p_eth.c                       |  6 +-----
 tc/p_icmp.c                      |  7 +------
 tc/p_ip.c                        |  7 +------
 tc/p_ip6.c                       |  7 +------
 tc/p_tcp.c                       |  7 +------
 tc/p_udp.c                       |  7 +------
 tc/q_atm.c                       |  1 -
 tc/q_cbq.c                       |  7 +------
 tc/q_cbs.c                       |  7 +------
 tc/q_choke.c                     |  6 +-----
 tc/q_codel.c                     | 32 +-------------------------------
 tc/q_drr.c                       |  7 +------
 tc/q_dsmark.c                    |  1 -
 tc/q_etf.c                       |  7 +------
 tc/q_fifo.c                      |  7 +------
 tc/q_fq.c                        | 32 +-------------------------------
 tc/q_fq_codel.c                  | 32 +-------------------------------
 tc/q_gred.c                      |  6 +-----
 tc/q_hfsc.c                      |  7 +------
 tc/q_ingress.c                   |  6 +-----
 tc/q_mqprio.c                    |  6 +-----
 tc/q_multiq.c                    | 13 +------------
 tc/q_pie.c                       | 12 +-----------
 tc/q_prio.c                      |  7 +------
 tc/q_qfq.c                       |  6 +-----
 tc/q_red.c                       |  7 +------
 tc/q_rr.c                        |  6 +-----
 tc/q_sfb.c                       |  9 +--------
 tc/q_sfq.c                       |  7 +------
 tc/q_skbprio.c                   |  7 +------
 tc/q_taprio.c                    |  6 +-----
 tc/q_tbf.c                       |  7 +------
 tc/tc.c                          | 10 +---------
 tc/tc_cbq.c                      |  7 +------
 tc/tc_class.c                    |  7 +------
 tc/tc_core.c                     |  7 +------
 tc/tc_estimator.c                |  7 +------
 tc/tc_exec.c                     |  6 +-----
 tc/tc_filter.c                   |  7 +------
 tc/tc_monitor.c                  |  7 +------
 tc/tc_qdisc.c                    |  6 +-----
 tc/tc_red.c                      |  7 +------
 tc/tc_stab.c                     |  7 +------
 tc/tc_util.c                     |  7 +------
 testsuite/tools/generate_nlmsg.c |  6 +-----
 tipc/bearer.c                    |  6 +-----
 tipc/bearer.h                    |  6 +-----
 tipc/cmdl.c                      |  6 +-----
 tipc/cmdl.h                      |  6 +-----
 tipc/link.c                      |  6 +-----
 tipc/link.h                      |  6 +-----
 tipc/media.c                     |  6 +-----
 tipc/media.h                     |  6 +-----
 tipc/misc.c                      |  6 +-----
 tipc/misc.h                      |  6 +-----
 tipc/msg.c                       |  6 +-----
 tipc/msg.h                       |  6 +-----
 tipc/nametable.c                 |  6 +-----
 tipc/nametable.h                 |  6 +-----
 tipc/node.c                      |  6 +-----
 tipc/node.h                      |  6 +-----
 tipc/peer.c                      |  6 +-----
 tipc/peer.h                      |  6 +-----
 tipc/socket.c                    |  6 +-----
 tipc/socket.h                    |  6 +-----
 tipc/tipc.c                      |  6 +-----
 192 files changed, 198 insertions(+), 1253 deletions(-)

-- 
2.39.0

