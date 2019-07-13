Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 44C2F67B04
	for <lists+netdev@lfdr.de>; Sat, 13 Jul 2019 17:38:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728025AbfGMPio (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 13 Jul 2019 11:38:44 -0400
Received: from cmccmta1.chinamobile.com ([221.176.66.79]:2107 "EHLO
        cmccmta1.chinamobile.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727626AbfGMPio (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 13 Jul 2019 11:38:44 -0400
Received: from spf.mail.chinamobile.com (unknown[172.16.121.19]) by rmmx-syy-dmz-app03-12003 (RichMail) with SMTP id 2ee35d29f763725-3a85a; Sat, 13 Jul 2019 23:23:16 +0800 (CST)
X-RM-TRANSID: 2ee35d29f763725-3a85a
X-RM-TagInfo: emlType=0                                       
X-RM-SPAM-FLAG: 00000000
Received: from localhost (unknown[223.105.0.241])
        by rmsmtp-syy-appsvr10-12010 (RichMail) with SMTP id 2eea5d29f7641cf-8262e;
        Sat, 13 Jul 2019 23:23:16 +0800 (CST)
X-RM-TRANSID: 2eea5d29f7641cf-8262e
From:   Haishuang Yan <yanhaishuang@cmss.chinamobile.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Simon Horman <horms@verge.net.au>
Cc:     netdev@vger.kernel.org, lvs-devel@vger.kernel.org,
        linux-kernel@vger.kernel.org, netfilter-devel@vger.kernel.org,
        Haishuang Yan <yanhaishuang@cmss.chinamobile.com>
Subject: [net-next 0/2] ipvs: speedup ipvs netns dismantle
Date:   Sat, 13 Jul 2019 23:19:44 +0800
Message-Id: <1563031186-2101-1-git-send-email-yanhaishuang@cmss.chinamobile.com>
X-Mailer: git-send-email 1.8.3.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Implement exit_batch() method to dismantle more ipvs netns
per round.

Haishuang Yan (2):
  ipvs: batch __ip_vs_cleanup
  ipvs: batch __ip_vs_dev_cleanup

 include/net/ip_vs.h             |  2 +-
 net/netfilter/ipvs/ip_vs_core.c | 49 +++++++++++++++++++++++++----------------
 net/netfilter/ipvs/ip_vs_ctl.c  | 13 ++++++++---
 3 files changed, 41 insertions(+), 23 deletions(-)

-- 
1.8.3.1



