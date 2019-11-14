Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 99AD8FC67D
	for <lists+netdev@lfdr.de>; Thu, 14 Nov 2019 13:45:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726755AbfKNMo6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Nov 2019 07:44:58 -0500
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:33965 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726690AbfKNMo6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Nov 2019 07:44:58 -0500
Received: from Internal Mail-Server by MTLPINE1 (envelope-from roid@mellanox.com)
        with ESMTPS (AES256-SHA encrypted); 14 Nov 2019 14:44:53 +0200
Received: from dev-r-vrt-139.mtr.labs.mlnx (dev-r-vrt-139.mtr.labs.mlnx [10.212.139.1])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id xAECirEE024546;
        Thu, 14 Nov 2019 14:44:53 +0200
From:   Roi Dayan <roid@mellanox.com>
To:     netdev@vger.kernel.org
Cc:     David Ahern <dsahern@gmail.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Jiri Pirko <jiri@mellanox.com>,
        Eli Britstein <elibr@mellanox.com>,
        Roi Dayan <roid@mellanox.com>
Subject: [PATCH iproute2 v2 0/5] fix json output for some keys
Date:   Thu, 14 Nov 2019 14:44:36 +0200
Message-Id: <20191114124441.2261-1-roid@mellanox.com>
X-Mailer: git-send-email 2.8.4
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

This series is fixing output for tos, ttl, ct_zone, ct_mark
in json format.

Thanks,
Roi

Eli Britstein (5):
  tc_util: introduce a function to print JSON/non-JSON masked numbers
  tc_util: add an option to print masked numbers with/without a newline
  tc: flower: fix newline prints for ct-mark and ct-zone
  tc_util: fix JSON prints for ct-mark and ct-zone
  tc: flower: fix output for ip tos and ttl

 tc/f_flower.c | 19 +++-----------
 tc/m_ct.c     |  4 +--
 tc/tc_util.c  | 79 +++++++++++++++++++++++++++++++++++++++--------------------
 tc/tc_util.h  |  6 +++--
 4 files changed, 62 insertions(+), 46 deletions(-)

-- 
2.8.4

