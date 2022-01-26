Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3196049D24C
	for <lists+netdev@lfdr.de>; Wed, 26 Jan 2022 20:11:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244349AbiAZTLQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jan 2022 14:11:16 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:53296 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243816AbiAZTLP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Jan 2022 14:11:15 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A1299B81EA6
        for <netdev@vger.kernel.org>; Wed, 26 Jan 2022 19:11:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47161C340E3;
        Wed, 26 Jan 2022 19:11:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643224273;
        bh=01l6LvhEyZzWL5biF2DNfYwbR4V7SgSBF6Au4Dp0XqU=;
        h=From:To:Cc:Subject:Date:From;
        b=ZHt0LjzUtNnfL0bWG6VUQtG8f5n+AU7gLVnR45gUOcnrPj3aUIBtpQc86Uz+BhHUR
         gizRkF1mGk7j9C0ItuB2TgsHqS1r1SfYQvqRbjAqbOBCAvvBk4dEHgZJ/KgHYH2JIc
         BbjeI4PJ6r/fsVkwjOQPi/FgpuQDpVcSISO1en/nk29bYHYIB2BOhpisPYlrVO9VgE
         Sx1E1GW7HNofT+zcFiR2iwYWxV5jQC9hm5J/KEHnn5We6zK1n8MN7Kdk52/nCaD8fJ
         8UbtI82FLOk1oPoxkPDB4LeX/o7CPD70z9NfMGXYWg4la2FzsBOqaMZDQN13+PPXC0
         kzgWLpQkjHTIg==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 00/15] net: get rid of unused static inlines
Date:   Wed, 26 Jan 2022 11:10:54 -0800
Message-Id: <20220126191109.2822706-1-kuba@kernel.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I noticed a couple of unused static inline functions reviewing
net/sched patches so I run a grep thru all of include/ and net/
to catch other cases. This set removes the cases which look like
obvious dead code.

Jakub Kicinski (15):
  mii: remove mii_lpa_to_linkmode_lpa_sgmii()
  nfc: use *_set_vendor_cmds() helpers
  net: remove net_invalid_timestamp()
  net: remove linkmode_change_bit()
  net: remove bond_slave_has_mac_rcu()
  net: ax25: remove route refcount
  hsr: remove get_prp_lan_id()
  ipv6: remove inet6_rsk() and tcp_twsk_ipv6only()
  dccp: remove max48()
  udp: remove inner_udp_hdr()
  udplite: remove udplite_csum_outgoing()
  netlink: remove nl_set_extack_cookie_u32()
  net: sched: remove psched_tdiff_bounded()
  net: sched: remove qdisc_qlen_cpu()
  net: tipc: remove unused static inlines

 drivers/nfc/st-nci/vendor_cmds.c   |  2 +-
 drivers/nfc/st21nfca/vendor_cmds.c |  4 +--
 include/linux/ipv6.h               |  7 -----
 include/linux/linkmode.h           |  5 ----
 include/linux/mii.h                | 17 ------------
 include/linux/netlink.h            |  9 -------
 include/linux/skbuff.h             |  5 ----
 include/linux/udp.h                |  5 ----
 include/net/ax25.h                 | 12 ---------
 include/net/bonding.h              | 14 ----------
 include/net/pkt_sched.h            |  6 -----
 include/net/sch_generic.h          |  5 ----
 include/net/udplite.h              | 43 ------------------------------
 net/ax25/ax25_route.c              |  5 ++--
 net/dccp/dccp.h                    |  5 ----
 net/hsr/hsr_main.h                 |  5 ----
 net/tipc/msg.h                     | 23 ----------------
 17 files changed, 5 insertions(+), 167 deletions(-)

-- 
2.34.1

