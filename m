Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1297A872F8
	for <lists+netdev@lfdr.de>; Fri,  9 Aug 2019 09:30:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405761AbfHIHaR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Aug 2019 03:30:17 -0400
Received: from mail5.windriver.com ([192.103.53.11]:35626 "EHLO mail5.wrs.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2405617AbfHIHaR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 9 Aug 2019 03:30:17 -0400
Received: from ALA-HCB.corp.ad.wrs.com (ala-hcb.corp.ad.wrs.com [147.11.189.41])
        by mail5.wrs.com (8.15.2/8.15.2) with ESMTPS id x797SGKH017009
        (version=TLSv1 cipher=AES128-SHA bits=128 verify=FAIL);
        Fri, 9 Aug 2019 00:28:27 -0700
Received: from pek-yxue-d1.wrs.com (128.224.155.90) by ALA-HCB.corp.ad.wrs.com
 (147.11.189.41) with Microsoft SMTP Server id 14.3.468.0; Fri, 9 Aug 2019
 00:28:06 -0700
From:   Ying Xue <ying.xue@windriver.com>
To:     <davem@davemloft.net>, <netdev@vger.kernel.org>
CC:     <jon.maloy@ericsson.com>, <hdanton@sina.com>,
        <tipc-discussion@lists.sourceforge.net>,
        <syzkaller-bugs@googlegroups.com>
Subject: [PATCH 0/3] Fix three issues found by syzbot
Date:   Fri, 9 Aug 2019 15:16:54 +0800
Message-ID: <1565335017-21302-1-git-send-email-ying.xue@windriver.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In this series, try to fix two memory leak issues and another issue of
calling smp_processor_id() in preemptible context.

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

