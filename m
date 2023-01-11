Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8957E666314
	for <lists+netdev@lfdr.de>; Wed, 11 Jan 2023 19:52:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235650AbjAKSwk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Jan 2023 13:52:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238218AbjAKSwc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Jan 2023 13:52:32 -0500
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 766E636302
        for <netdev@vger.kernel.org>; Wed, 11 Jan 2023 10:52:30 -0800 (PST)
Received: by mail-pj1-x102e.google.com with SMTP id h7-20020a17090aa88700b00225f3e4c992so21051843pjq.1
        for <netdev@vger.kernel.org>; Wed, 11 Jan 2023 10:52:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=K5s6CPjBm3cbYzTYL3YzuHVIK3OJ8xvu0qkjF8wOgp4=;
        b=upRcjG3nUXn3SOHnafLw4qCDROKB/i7fgAKcWouOOQpUaZpCSINk9YyeD5FETi3bCj
         Ku61ibF5F8QwZB/UaPnltGdzrn3hAki5CZsNJXPnQALwED9mVeut2lIYRupkdVBrffv/
         wKAd7mAc9l5gp2vHYPAFqhy53QqVhwJzEfMYIEN6xyJ0Ep5W15c66KbHW5IBLL2GgOjj
         XuGp6+mApalSdG3cRYv6Oq61R0oFglcQVKU25ZrAnLKUz/NvMAw6vTt9A34N1KknJhQI
         1vDrp5Ilg4+D3saOjF4VNscblVRuZkpGmDRazDG73y0Ub88isYjUT0CZzZqE6Q19pgqJ
         ftMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=K5s6CPjBm3cbYzTYL3YzuHVIK3OJ8xvu0qkjF8wOgp4=;
        b=qdd3Vei3iSPR+k++fHbk7+BSlYuG6yETCzCzOV8QxzhHjGhOOujSBTZLZGUvLpnJ8E
         SNh4piuYJDXcdrjmyCUQ1ysQf0TeNY+FaN1ozTnBOsQZdJW2Ol8TlqmpVTglT3OksY5Y
         c8SYK1kSdS/3LNbMIWEdCo70wEKkwil0DF97gHENRUIldPwlDwNLtp19xganvQ431u4u
         05u689nuqhsFwywCyn0sCESkJN5UIHOTlegesuuB6GuVChm/iVtfG2eoRNVKC2SgKzMh
         6EimZ/B807if/kAN78b8M7l0HFZt75ZVq8SQF44rTwbIQLxZRhd9oZIRyuoAZfxjumKC
         wQUQ==
X-Gm-Message-State: AFqh2koDH7EOqiTcrtzV7iQIPgElrgVaXN7NQa3dl8e8ZXx0H5QHaDFk
        fMXgPh84K3iDt2HyZKE8U926UeMb3VrHlgpHcNU=
X-Google-Smtp-Source: AMrXdXvNeSC1XspEFNm5i40OkmSOZlzaQAYU3vEh8zKNMSB20pArGeDvK5+HiAW4nc4dE2hpFYYu3g==
X-Received: by 2002:a05:6a20:d819:b0:b2:3b40:32b1 with SMTP id iv25-20020a056a20d81900b000b23b4032b1mr83270006pzb.57.1673463149579;
        Wed, 11 Jan 2023 10:52:29 -0800 (PST)
Received: from hermes.local (204-195-120-218.wavecable.com. [204.195.120.218])
        by smtp.gmail.com with ESMTPSA id d7-20020a631d47000000b004a849d3d9c2sm8650447pgm.22.2023.01.11.10.52.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Jan 2023 10:52:29 -0800 (PST)
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     netdev@vger.kernel.org
Cc:     Stephen Hemminger <stephen@networkplumber.org>
Subject: [PATCH v2 iproute2 00/11] SPDX cleanups
Date:   Wed, 11 Jan 2023 10:52:16 -0800
Message-Id: <20230111185227.69093-1-stephen@networkplumber.org>
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

v2 rebase and found some more missing SPDX places

Stephen Hemminger (11):
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
  netem: add SPDX license header

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
 ip/iplink_batadv.c               |  1 +
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
 misc/ss_util.h                   |  1 +
 misc/ssfilter.h                  |  1 +
 misc/ssfilter.y                  |  1 +
 misc/ssfilter_check.c            |  1 +
 netem/maketable.c                |  1 +
 netem/normal.c                   |  1 +
 netem/pareto.c                   |  1 +
 netem/paretonormal.c             |  1 +
 netem/stats.c                    |  1 +
 tc/e_bpf.c                       |  6 +-----
 tc/em_canid.c                    |  6 +-----
 tc/em_cmp.c                      |  6 +-----
 tc/em_ipset.c                    |  5 +----
 tc/em_ipt.c                      |  5 +----
 tc/em_meta.c                     |  6 +-----
 tc/em_nbyte.c                    |  6 +-----
 tc/em_u32.c                      |  6 +-----
 tc/emp_ematch.y                  |  1 +
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
 202 files changed, 208 insertions(+), 1248 deletions(-)

-- 
2.39.0

