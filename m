Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 341075706A3
	for <lists+netdev@lfdr.de>; Mon, 11 Jul 2022 17:09:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232060AbiGKPJb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jul 2022 11:09:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231433AbiGKPJa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Jul 2022 11:09:30 -0400
Received: from syslogsrv (unknown [217.20.186.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C7245A2E2;
        Mon, 11 Jul 2022 08:09:29 -0700 (PDT)
Received: from fg200.ow.s ([172.20.254.44] helo=localhost.localdomain)
        by syslogsrv with esmtp (Exim 4.90_1)
        (envelope-from <maksym.glubokiy@plvision.eu>)
        id 1oAv26-000G64-Rq; Mon, 11 Jul 2022 18:09:11 +0300
From:   Maksym Glubokiy <maksym.glubokiy@plvision.eu>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>
Cc:     Maksym Glubokiy <maksym.glubokiy@plvision.eu>,
        louis.peens@corigine.com, elic@nvidia.com,
        simon.horman@corigine.com, baowen.zheng@corigine.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next v2 0/2] net: prestera: add support for port range filters
Date:   Mon, 11 Jul 2022 18:09:06 +0300
Message-Id: <20220711150908.1030650-1-maksym.glubokiy@plvision.eu>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,FSL_HELO_NON_FQDN_1,
        HELO_NO_DOMAIN,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This adds support for port-range rules in Marvel Prestera driver:

  $ tc qdisc add ... clsact
  $ tc filter add ... flower ... src_port <PMIN>-<PMAX> ...

Maksym Glubokiy (2):
  net: extract port range fields from fl_flow_key
  net: prestera: add support for port range filters

v2:
 - fix kernel-doc for the newly added structure

 .../marvell/prestera/prestera_flower.c        | 24 +++++++++++++++++++
 include/net/flow_dissector.h                  | 16 +++++++++++++
 include/net/flow_offload.h                    |  6 +++++
 net/core/flow_offload.c                       |  7 ++++++
 net/sched/cls_flower.c                        |  8 +------
 5 files changed, 54 insertions(+), 7 deletions(-)

-- 
2.25.1

