Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5D36A5EC882
	for <lists+netdev@lfdr.de>; Tue, 27 Sep 2022 17:49:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232288AbiI0Ps4 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 27 Sep 2022 11:48:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232885AbiI0Psc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Sep 2022 11:48:32 -0400
Received: from us-smtp-delivery-44.mimecast.com (us-smtp-delivery-44.mimecast.com [207.211.30.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC014B248D
        for <netdev@vger.kernel.org>; Tue, 27 Sep 2022 08:46:13 -0700 (PDT)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-155-LfcoxsMTPZCpBT33s63vdg-1; Tue, 27 Sep 2022 11:46:07 -0400
X-MC-Unique: LfcoxsMTPZCpBT33s63vdg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id EF873862FE4;
        Tue, 27 Sep 2022 15:46:06 +0000 (UTC)
Received: from hog.localdomain (unknown [10.39.195.84])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 07CF02166B26;
        Tue, 27 Sep 2022 15:46:05 +0000 (UTC)
From:   Sabrina Dubroca <sd@queasysnail.net>
To:     netdev@vger.kernel.org
Cc:     steffen.klassert@secunet.com, Sabrina Dubroca <sd@queasysnail.net>
Subject: [PATCH ipsec-next 0/6] xfrm: add netlink extack to all the ->init_state
Date:   Tue, 27 Sep 2022 17:45:28 +0200
Message-Id: <cover.1664287440.git.sd@queasysnail.net>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: queasysnail.net
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset=WINDOWS-1252; x-default=true
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series completes extack support for state creation.

Sabrina Dubroca (6):
  xfrm: pass extack down to xfrm_type ->init_state
  xfrm: ah: add extack to ah_init_state, ah6_init_state
  xfrm: esp: add extack to esp_init_state, esp6_init_state
  xfrm: tunnel: add extack to ipip_init_state, xfrm6_tunnel_init_state
  xfrm: ipcomp: add extack to ipcomp{4,6}_init_state
  xfrm: mip6: add extack to mip6_destopt_init_state,
    mip6_rthdr_init_state

 include/net/ipcomp.h    |  2 +-
 include/net/xfrm.h      |  3 ++-
 net/ipv4/ah4.c          | 23 ++++++++++-------
 net/ipv4/esp4.c         | 55 ++++++++++++++++++++++++-----------------
 net/ipv4/ipcomp.c       | 10 +++++---
 net/ipv4/xfrm4_tunnel.c | 10 +++++---
 net/ipv6/ah6.c          | 23 +++++++++++------
 net/ipv6/esp6.c         | 55 ++++++++++++++++++++++++-----------------
 net/ipv6/ipcomp6.c      | 10 +++++---
 net/ipv6/mip6.c         | 14 +++++------
 net/ipv6/xfrm6_tunnel.c | 10 +++++---
 net/xfrm/xfrm_ipcomp.c  | 10 +++++---
 net/xfrm/xfrm_state.c   |  2 +-
 13 files changed, 140 insertions(+), 87 deletions(-)

-- 
2.37.3

