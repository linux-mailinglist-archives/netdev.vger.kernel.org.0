Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D6FCD278926
	for <lists+netdev@lfdr.de>; Fri, 25 Sep 2020 15:16:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728754AbgIYNQG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Sep 2020 09:16:06 -0400
Received: from mailrelay112.isp.belgacom.be ([195.238.20.139]:52935 "EHLO
        mailrelay112.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728406AbgIYNQF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Sep 2020 09:16:05 -0400
IronPort-SDR: svHJhKx79Vc1wlxc8jrCkO0rg3d9zYQX5cOwELwQiP917ddw8bEr6GeyTyjZvcV2xZUgYWGFOw
 PrGOUS9cVbYJB5o0SWpdXOCHCKnVI5m0Ktpgj6WwP8NNeINgMYgMmIm4vS+uWaimm46q/WOHUf
 kxkW2Y8wDkyqy9uoalE7S96w9T1apAqMwbJ0/kK1Afy/4Vxk5uZ9GBI3Jze6zO9CckOq81YtAb
 skN7Pnr38o+5zV3e/IKgU+DCNc/E8KAn0V7GfGdEFajTvWzqMNK9wzaEHRUHzhZ38N++kPN9ij
 vQQ=
X-Belgacom-Dynamic: yes
IronPort-PHdr: =?us-ascii?q?9a23=3AE+HUAxHaNZ6KY8iGb8876J1GYnF86YWxBRYc79?=
 =?us-ascii?q?8ds5kLTJ76p8u5bnLW6fgltlLVR4KTs6sC17OJ9fq4EjFRqb+681k6OKRWUB?=
 =?us-ascii?q?EEjchE1ycBO+WiTXPBEfjxciYhF95DXlI2t1uyMExSBdqsLwaK+i764jEdAA?=
 =?us-ascii?q?jwOhRoLerpBIHSk9631+ev8JHPfglEnjWwba5wIRmsswndqsYajItmJ60s1h?=
 =?us-ascii?q?bHv3xEdvhMy2h1P1yThRH85smx/J5n7Stdvu8q+tBDX6vnYak2VKRUAzs6PW?=
 =?us-ascii?q?874s3rrgTDQhCU5nQASGUWkwFHDBbD4RrnQ5r+qCr6tu562CmHIc37SK0/VD?=
 =?us-ascii?q?q+46t3ThLjlSEKPCM7/m7KkMx9lKJVrgy8qRJxwIDaZ46aOvVlc6/Bft4XX3?=
 =?us-ascii?q?ZNU9xNWyBdBI63cosBD/AGPeZdt4Tzp0EBogC/BQa2AuPk1z9GhmXo0qInze?=
 =?us-ascii?q?shCwDG0xAjH9kTt3nUos/6O7wcUe2u16nIzjXCb/VI1jfh8oTHaQ4urOiKUL?=
 =?us-ascii?q?ltfsXf1VMhGBnZjlWMt4PlJTWV2/wDvWWY6+duVeOihm45pwx/ojai29sghp?=
 =?us-ascii?q?TVio8UxV7K+jh0zYgrKNClSEN2Y8CpHpRMuy+UOIV7RsMsTWF2tCs+zLANpJ?=
 =?us-ascii?q?21fDASxZkj2hLTceGLfouW7h75SeqcIDd1iGh4dL++gRu57FKuxffmVsau1V?=
 =?us-ascii?q?ZHti9Fkt7RuX8TzxHT8c2HSudl/kemxDaPyxjf6uFaLkAwkqrWM5ohwrksmZ?=
 =?us-ascii?q?UJtUTDHij2mF7qjKOMckUk/fSn5P7jYrr7oZ+cMpV7igD4Mqg2m8y/B/o3Mh?=
 =?us-ascii?q?QWUmWf5OiwzqDv8E7nTLlQk/E7k6nUvIrHKckavqK5BhVa0ocn6xaxFTem19?=
 =?us-ascii?q?EYkGEJLF1fYx2HgZPkO0rNIPH4C/ewnUisnC1wyP/YJrHhGInCLmDfkLf9er?=
 =?us-ascii?q?Zw81NTxxAtzd9B4pJZEawOL+jtWkDvsdzYChg5MwKow+r9DtVyyJ8eU3qVAq?=
 =?us-ascii?q?CFKKPSrUOI5uU3LumPeY8aoyzyJuMm5/Hwl385n0ESfa2z0ZsQcnC4EexsI1?=
 =?us-ascii?q?+Fbnr0ntcBDWAKsxI7TOzplV2NSiBcaGqsUKI//Tw7E5+mDZzdSYy3nLOA3T?=
 =?us-ascii?q?+xHodKaWBeFlCMDXDoep2CW/gSdCKdP9FukiIfWLi/RI8uywuuuBX5y7V5NO?=
 =?us-ascii?q?rU/DMXtZb52Nhy/e3Tmgk49SZoAMSFz2GNU2Z0k3sMRz832qB/vEN8xk6A0a?=
 =?us-ascii?q?dmmfxYE8Jc5/dSXwckOp7T0fZ6B8rxWg3fZNeJTkipQtG8DTE2VNIxzMcEY1?=
 =?us-ascii?q?xhFNW6khDDwy2qDqcbl7ORH5M0/LnR32PyJ8d9zXbJyrUhg0M9TcRRZiWagf?=
 =?us-ascii?q?tz/hbeAqbFmluUkqKte7ha2iPRsC+A0GCHlEJVSgh9VePCR39MSFHRqIHX70?=
 =?us-ascii?q?nDRrnmJ64qPgZbyMWBYv9EY9fnpU5FVfHuJJLUbjTiyC+LGR+Uy+bUP8LRcG?=
 =?us-ascii?q?IH0XCFBQ=3D=3D?=
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: =?us-ascii?q?A2AIEgDD7G1f/xCltltfHAEBATwBAQQ?=
 =?us-ascii?q?EAQECAQEHAQEcgUqBHCACAQGCLY4dkmKSBAsBAQEBAQEBAQE1AQIEAQGES4I?=
 =?us-ascii?q?xJTgTAgMBAQEDAgUBAQYBAQEBAQEFBAGGD0WCNyKDUgEjI4E/gziCWCm4coQ?=
 =?us-ascii?q?QhRGBQoE2AgEBAQGIK4UagUE/hF+KNASQE6cqgnGDE4RpkkwPIoJ7nhWTCKI?=
 =?us-ascii?q?YgXpNIBiDJU8ZDZxoQmcCBgoBAQMJVwE9AY4fAQE?=
X-IPAS-Result: =?us-ascii?q?A2AIEgDD7G1f/xCltltfHAEBATwBAQQEAQECAQEHAQEcg?=
 =?us-ascii?q?UqBHCACAQGCLY4dkmKSBAsBAQEBAQEBAQE1AQIEAQGES4IxJTgTAgMBAQEDA?=
 =?us-ascii?q?gUBAQYBAQEBAQEFBAGGD0WCNyKDUgEjI4E/gziCWCm4coQQhRGBQoE2AgEBA?=
 =?us-ascii?q?QGIK4UagUE/hF+KNASQE6cqgnGDE4RpkkwPIoJ7nhWTCKIYgXpNIBiDJU8ZD?=
 =?us-ascii?q?ZxoQmcCBgoBAQMJVwE9AY4fAQE?=
Received: from 16.165-182-91.adsl-dyn.isp.belgacom.be (HELO localhost.localdomain) ([91.182.165.16])
  by relay.skynet.be with ESMTP; 25 Sep 2020 15:16:02 +0200
From:   Fabian Frederick <fabf@skynet.be>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     mkubecek@suse.cz, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Fabian Frederick <fabf@skynet.be>
Subject: [PATCH V2 0/5 net-next] vxlan: clean-up
Date:   Fri, 25 Sep 2020 15:15:41 +0200
Message-Id: <20200925131541.56410-1-fabf@skynet.be>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This small patchet does some clean-up on vxlan.
Second version removes VXLAN_NL2FLAG macro relevant patches as suggested by Michal and David

I hope to have some feedback/ACK from vxlan developers.

Fabian Frederick (5):
  vxlan: don't collect metadata if remote checksum is wrong
  vxlan: add unlikely to vxlan_remcsum check
  vxlan: move encapsulation warning
  vxlan: check rtnl_configure_link return code correctly
  vxlan: fix vxlan_find_sock() documentation for l3mdev

 drivers/net/vxlan.c | 23 ++++++++++++-----------
 1 file changed, 12 insertions(+), 11 deletions(-)

-- 
2.27.0

