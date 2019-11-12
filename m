Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 97A4FF9347
	for <lists+netdev@lfdr.de>; Tue, 12 Nov 2019 15:52:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727717AbfKLOwb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Nov 2019 09:52:31 -0500
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:44324 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727677AbfKLOw1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Nov 2019 09:52:27 -0500
Received: from Internal Mail-Server by MTLPINE1 (envelope-from roid@mellanox.com)
        with ESMTPS (AES256-SHA encrypted); 12 Nov 2019 16:52:21 +0200
Received: from mtr-vdi-191.wap.labs.mlnx. (mtr-vdi-191.wap.labs.mlnx [10.209.100.28])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id xACEqKx5020273;
        Tue, 12 Nov 2019 16:52:21 +0200
From:   Roi Dayan <roid@mellanox.com>
To:     netdev@vger.kernel.org
Cc:     David Ahern <dsahern@gmail.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Jiri Pirko <jiri@mellanox.com>,
        Eli Britstein <elibr@mellanox.com>,
        Roi Dayan <roid@mellanox.com>
Subject: [PATCH iproute2-next 0/8] flower match support for masked ports
Date:   Tue, 12 Nov 2019 16:51:46 +0200
Message-Id: <20191112145154.145289-1-roid@mellanox.com>
X-Mailer: git-send-email 2.8.4
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

This series is for adding support for flower match on masked
src/dst ports.

First commits are preparations and fixing tos and ttl output.
Last 3 commits add support for masked src/dst port.

Thanks,
Roi

Eli Britstein (8):
  tc_util: introduce a function to print JSON/non-JSON masked numbers
  tc_util: add an option to print masked numbers with/without a newline
  tc: flower: fix newline prints for ct-mark and ct-zone
  tc_util: fix JSON prints for ct-mark and ct-zone
  tc: flower: fix output for ip tos and ttl
  tc: flower: add u16 big endian parse option
  tc_util: add functions for big endian masked numbers
  tc: flower: support masked port destination and source match

 man/man8/tc-flower.8 | 13 ++++----
 tc/f_flower.c        | 92 +++++++++++++++++++++++++++++++++-------------------
 tc/m_ct.c            |  4 +--
 tc/tc_util.c         | 88 ++++++++++++++++++++++++++++++++++---------------
 tc/tc_util.h         |  8 +++--
 5 files changed, 136 insertions(+), 69 deletions(-)

-- 
2.8.4

