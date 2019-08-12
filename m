Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D6FA989849
	for <lists+netdev@lfdr.de>; Mon, 12 Aug 2019 09:51:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726799AbfHLHvu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Aug 2019 03:51:50 -0400
Received: from mail5.windriver.com ([192.103.53.11]:45578 "EHLO mail5.wrs.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726548AbfHLHvu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 12 Aug 2019 03:51:50 -0400
Received: from ALA-HCA.corp.ad.wrs.com (ala-hca.corp.ad.wrs.com [147.11.189.40])
        by mail5.wrs.com (8.15.2/8.15.2) with ESMTPS id x7C7heW4021295
        (version=TLSv1 cipher=AES128-SHA bits=128 verify=FAIL);
        Mon, 12 Aug 2019 00:44:11 -0700
Received: from pek-yxue-d1.wrs.com (128.224.155.90) by ALA-HCA.corp.ad.wrs.com
 (147.11.189.40) with Microsoft SMTP Server id 14.3.468.0; Mon, 12 Aug 2019
 00:43:52 -0700
From:   Ying Xue <ying.xue@windriver.com>
To:     <davem@davemloft.net>, <netdev@vger.kernel.org>
CC:     <jon.maloy@ericsson.com>, <hdanton@sina.com>,
        <tipc-discussion@lists.sourceforge.net>,
        <syzkaller-bugs@googlegroups.com>, <jakub.kicinski@netronome.com>
Subject: [PATCH v2 0/3] Fix three issues found by syzbot
Date:   Mon, 12 Aug 2019 15:32:39 +0800
Message-ID: <1565595162-1383-1-git-send-email-ying.xue@windriver.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In this series, try to fix two memory leak issues and another issue of
calling smp_processor_id() in preemptible context.

Changes since v1:
 - Fix "Reported-by:" missing in patch #3, which was reported by Jakub
   Kicinski

Ying Xue (3):
  tipc: fix memory leak issue
  tipc: fix memory leak issue
  tipc: fix issue of calling smp_processor_id() in preemptible

 net/tipc/group.c     | 22 +++++++++++++---------
 net/tipc/node.c      |  7 +++++--
 net/tipc/udp_media.c | 12 +++++++++---
 3 files changed, 27 insertions(+), 14 deletions(-)

-- 
2.7.4

