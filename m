Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3FA855E7C13
	for <lists+netdev@lfdr.de>; Fri, 23 Sep 2022 15:39:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232284AbiIWNjq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Sep 2022 09:39:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232109AbiIWNjd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Sep 2022 09:39:33 -0400
Received: from mout.kundenserver.de (mout.kundenserver.de [217.72.192.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BF07139F77;
        Fri, 23 Sep 2022 06:39:27 -0700 (PDT)
Received: from weisslap.fritz.box ([31.19.218.61]) by mrelayeu.kundenserver.de
 (mreue107 [212.227.15.183]) with ESMTPSA (Nemesis) id
 1MWSFB-1on1P51sNP-00Xuax; Fri, 23 Sep 2022 15:39:00 +0200
From:   =?UTF-8?q?Michael=20Wei=C3=9F?= <michael.weiss@aisec.fraunhofer.de>
To:     Paolo Abeni <pabeni@redhat.com>, Pravin B Shelar <pshelar@ovn.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Joe Stringer <joe@cilium.io>, Andy Zhou <azhou@ovn.org>,
        =?UTF-8?q?Michael=20Wei=C3=9F?= <michael.weiss@aisec.fraunhofer.de>,
        Eric Dumazet <edumazet@google.com>, netdev@vger.kernel.org,
        dev@openvswitch.org, linux-kernel@vger.kernel.org
Subject: [PATCH v3 net-next 0/2] net: openvswitch: metering and conntrack in userns
Date:   Fri, 23 Sep 2022 15:38:18 +0200
Message-Id: <20220923133820.993725-1-michael.weiss@aisec.fraunhofer.de>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:TbkwBqE8rtVWDaKA++w4xNoVrzhy+83FLLTsPMhi7l0YL3haBbv
 icd/B+ZShs7Zp+Z6rzrVS3TDZPT9B9iV61FrmrDUV4qBXi+jvgLPStdKIoUyK+l3gF3s/Sa
 RGywgd87LROnWQD+V9sNAWupUFW7Bu7eAVYAmGUIzL57cdwHP3E0P5rCaWslbLxQ9oQJj0u
 Xygw3gm/FC58rQboZgy7w==
X-UI-Out-Filterresults: notjunk:1;V03:K0:kr4BHpKIPsk=:A8v9UaCKN54SoR8s+2KXc6
 GPYz5ogJ6KYgJHJPezwyuR1uEw2litUfyYdh/RQQYfwnewJwxo0oIMe3xe1Et7ZTNhqCCIWRK
 HwCxHpPniauGA5DEYDtJu31Em6gL5f1ZQEM53TeM+BYyh1Xqbpnsm1go2J2nijNzlz/P2ywZd
 17QrCO1e/Cla9s+LRxt4h0o4oSAecq8JG05SN5bVBFFAWQadhqFRy8B992oaIGV9H2exZjol2
 oHLu4oAHLgoLi1pX0NZY17sBRGvGJlp59CEIEEIesM8hU7fMFzsc5DJAiIASzauWGFXQB6xat
 QxlzCCzVQk38hUpx6qyITVYe3znSryLIukNZn44Yz9xNs1eQ4d5Fml56+awWk5nk693phCli4
 W0RucCB+VRVDIIIROO7PTDhObMZw8ynpqHTXqdIup36PUojcSqFp+23dTMUok6YIRZnwVwsjJ
 34LTqbkJUIfCSs3U0gWodd9Uq+JJUi4e1VJwJzyXhFNZxp7lb1irUukvtn34jpWKnHm9SWGP6
 9U0ujVcUe8RGh+j/DdqN1ODuvuVOPJ1azpeafnlCYyR5Qr3DfdnURXcP1jmh+GzTSDLfxJkRr
 MgInLbhHkp/V7UrscYCwf1jB+JJflHXwE8OB2Fi4jVE9AiE0ZeSI8+utp7HqF0ktoWbBJUrda
 zYkTt5IRWEeKQHnAMbLyaQwW6DxZgrXJQ+3njsp4iP8h2rCMZzu/3bBzXDy7R3kT+ZYddHG2S
 b+3duhFejARqxvlrktL+MTLKeCknw1ynfRDSG8aRzJnOf6Mgg0V+SJVOIczWp8yFn0gNlCSNr
 AiNHGFGs4pvk2KhsIHppDxFHaUnRw==
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently using openvswitch in a non-initial user namespace, e.g., an
unprivileged container, is possible but without metering and conntrack
support. This is due to the restriction of the corresponding Netlink
interfaces to the global CAP_NET_ADMIN.

This simple patches switch from GENL_ADMIN_PERM to GENL_UNS_ADMIN_PERM
in several cases to allow this also for the unprivileged container
use case.

We tested this for unprivileged containers created by the container
manager of GyroidOS (gyroidos.github.io). However, for other container
managers such as LXC or systemd which provide unprivileged containers
this should be apply equally.

Changes in v3:
- also changed GFP_KERNEL to GFP_KERNEL_ACCOUNT in
  ovs_ct_limit_set_zone_limit() as suggested by Jakub
- Rebased on net-next/main branch of networking tree

Changes in v2:
- changed GFP_KERNEL to GFP_KERNEL_ACCOUNT in dp_meter_create()
  as suggested by Paolo
- Rebased on net branch of networking tree

Michael Weiß (2):
  net: openvswitch: allow metering in non-initial user namespace
  net: openvswitch: allow conntrack in non-initial user namespace

 net/openvswitch/conntrack.c | 13 ++++++++-----
 net/openvswitch/meter.c     | 14 +++++++-------
 2 files changed, 15 insertions(+), 12 deletions(-)


base-commit: 3aba35bb201fd2481b3fd5794120d9d1b0734fe8
-- 
2.30.2

