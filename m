Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DC463103A41
	for <lists+netdev@lfdr.de>; Wed, 20 Nov 2019 13:42:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729905AbfKTMm4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Nov 2019 07:42:56 -0500
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:54238 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729871AbfKTMmz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Nov 2019 07:42:55 -0500
Received: from Internal Mail-Server by MTLPINE1 (envelope-from roid@mellanox.com)
        with ESMTPS (AES256-SHA encrypted); 20 Nov 2019 14:42:53 +0200
Received: from dev-r-vrt-139.mtr.labs.mlnx (dev-r-vrt-139.mtr.labs.mlnx [10.212.139.1])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id xAKCgqRB017234;
        Wed, 20 Nov 2019 14:42:52 +0200
From:   Roi Dayan <roid@mellanox.com>
To:     netdev@vger.kernel.org
Cc:     David Ahern <dsahern@gmail.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Jiri Pirko <jiri@mellanox.com>,
        Eli Britstein <elibr@mellanox.com>,
        Roi Dayan <roid@mellanox.com>
Subject: [PATCH iproute2-next 0/3] flower match support for masked ports
Date:   Wed, 20 Nov 2019 14:42:42 +0200
Message-Id: <20191120124245.3516-1-roid@mellanox.com>
X-Mailer: git-send-email 2.8.4
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

This series is for adding support for flower match on masked
src/dst ports.

Thanks,
Roi

Eli Britstein (3):
  tc: flower: add u16 big endian parse option
  tc_util: add functions for big endian masked numbers
  tc: flower: support masked port destination and source match

 man/man8/tc-flower.8 | 13 +++++-----
 tc/f_flower.c        | 73 ++++++++++++++++++++++++++++++++++++++++------------
 tc/tc_util.c         | 12 +++++++++
 tc/tc_util.h         |  2 ++
 4 files changed, 77 insertions(+), 23 deletions(-)

-- 
2.8.4

