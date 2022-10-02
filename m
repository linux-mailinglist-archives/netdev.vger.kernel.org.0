Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C2AFF5F21F2
	for <lists+netdev@lfdr.de>; Sun,  2 Oct 2022 10:17:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229638AbiJBIR3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Oct 2022 04:17:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229458AbiJBIR1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 Oct 2022 04:17:27 -0400
Received: from a.mx.secunet.com (a.mx.secunet.com [62.96.220.36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C42233F1EF
        for <netdev@vger.kernel.org>; Sun,  2 Oct 2022 01:17:25 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id 8C5E720561;
        Sun,  2 Oct 2022 10:17:23 +0200 (CEST)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id WdmpNy4FEDRl; Sun,  2 Oct 2022 10:17:22 +0200 (CEST)
Received: from mailout2.secunet.com (mailout2.secunet.com [62.96.220.49])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id ED8B3200AC;
        Sun,  2 Oct 2022 10:17:22 +0200 (CEST)
Received: from cas-essen-01.secunet.de (unknown [10.53.40.201])
        by mailout2.secunet.com (Postfix) with ESMTP id D8B3380004A;
        Sun,  2 Oct 2022 10:17:22 +0200 (CEST)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 cas-essen-01.secunet.de (10.53.40.201) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Sun, 2 Oct 2022 10:17:22 +0200
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Sun, 2 Oct
 2022 10:17:22 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)
        id D989D31829EC; Sun,  2 Oct 2022 10:17:21 +0200 (CEST)
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Herbert Xu <herbert@gondor.apana.org.au>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        <netdev@vger.kernel.org>
Subject: [PATCH 0/24] pull request (net-next): ipsec-next 2022-10-02
Date:   Sun, 2 Oct 2022 10:16:48 +0200
Message-ID: <20221002081712.757515-1-steffen.klassert@secunet.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-ClientProxiedBy: cas-essen-01.secunet.de (10.53.40.201) To
 mbx-essen-01.secunet.de (10.53.40.197)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

1) Refactor selftests to use an array of structs in xfrm_fill_key().
   From Gautam Menghani.

2) Drop an unused argument from xfrm_policy_match.
   From Hongbin Wang.

3) Support collect metadata mode for xfrm interfaces.
   From Eyal Birger.

4) Add netlink extack support to xfrm.
   From Sabrina Dubroca.

Please note, there is a merge conflict in:

include/net/dst_metadata.h

between commit:

0a28bfd4971f ("net/macsec: Add MACsec skb_metadata_dst Tx Data path support")

from the net-next tree and commit:

5182a5d48c3d ("net: allow storing xfrm interface metadata in metadata_dst")

from the ipsec-next tree.

Can be solved as done in linux-next.

Please pull or let me know if there are problems.

Thanks!

The following changes since commit 7ebfc85e2cd7b08f518b526173e9a33b56b3913b:

  Merge tag 'net-6.0-rc1' of git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net (2022-08-11 13:45:37 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/klassert/ipsec-next.git master

for you to fetch changes up to c39596f6ad1bfe65fc2d926e0703cf26e3fae90a:

  Merge branch 'xfrm: add netlink extack to all the ->init_stat' (2022-09-30 09:49:33 +0200)

----------------------------------------------------------------
Eyal Birger (3):
      net: allow storing xfrm interface metadata in metadata_dst
      xfrm: interface: support collect metadata mode
      xfrm: lwtunnel: add lwtunnel support for xfrm interfaces in collect_md mode

Gautam Menghani (1):
      selftests/net: Refactor xfrm_fill_key() to use array of structs

Hongbin Wang (1):
      xfrm: Drop unused argument

Sabrina Dubroca (19):
      xfrm: propagate extack to all netlink doit handlers
      xfrm: add extack support to verify_newpolicy_info
      xfrm: add extack to verify_policy_dir
      xfrm: add extack to verify_policy_type
      xfrm: add extack to validate_tmpl
      xfrm: add extack to verify_sec_ctx_len
      xfrm: add extack support to verify_newsa_info
      xfrm: add extack to verify_replay
      xfrm: add extack to verify_one_alg, verify_auth_trunc, verify_aead
      xfrm: add extack support to xfrm_dev_state_add
      xfrm: add extack to attach_*
      xfrm: add extack to __xfrm_init_state
      xfrm: add extack support to xfrm_init_replay
      xfrm: pass extack down to xfrm_type ->init_state
      xfrm: ah: add extack to ah_init_state, ah6_init_state
      xfrm: esp: add extack to esp_init_state, esp6_init_state
      xfrm: tunnel: add extack to ipip_init_state, xfrm6_tunnel_init_state
      xfrm: ipcomp: add extack to ipcomp{4,6}_init_state
      xfrm: mip6: add extack to mip6_destopt_init_state, mip6_rthdr_init_state

Steffen Klassert (3):
      Merge remote-tracking branch 'xfrm: start adding netlink extack support'
      Merge branch 'xfrm: add netlink extack for state creation'
      Merge branch 'xfrm: add netlink extack to all the ->init_stat'

 include/net/dst_metadata.h          |  31 +++
 include/net/ipcomp.h                |   2 +-
 include/net/xfrm.h                  |  24 ++-
 include/uapi/linux/if_link.h        |   1 +
 include/uapi/linux/lwtunnel.h       |  10 +
 net/core/lwtunnel.c                 |   1 +
 net/ipv4/ah4.c                      |  23 ++-
 net/ipv4/esp4.c                     |  55 +++---
 net/ipv4/ipcomp.c                   |  10 +-
 net/ipv4/xfrm4_tunnel.c             |  10 +-
 net/ipv6/ah6.c                      |  23 ++-
 net/ipv6/esp6.c                     |  55 +++---
 net/ipv6/ipcomp6.c                  |  10 +-
 net/ipv6/mip6.c                     |  14 +-
 net/ipv6/xfrm6_tunnel.c             |  10 +-
 net/xfrm/xfrm_device.c              |  20 +-
 net/xfrm/xfrm_input.c               |   7 +-
 net/xfrm/xfrm_interface.c           | 206 ++++++++++++++++++--
 net/xfrm/xfrm_ipcomp.c              |  10 +-
 net/xfrm/xfrm_policy.c              |  25 ++-
 net/xfrm/xfrm_replay.c              |  10 +-
 net/xfrm/xfrm_state.c               |  30 ++-
 net/xfrm/xfrm_user.c                | 370 ++++++++++++++++++++++++------------
 tools/testing/selftests/net/ipsec.c | 104 +++++-----
 24 files changed, 738 insertions(+), 323 deletions(-)
