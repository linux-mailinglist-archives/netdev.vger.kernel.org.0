Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2DA91A3509
	for <lists+netdev@lfdr.de>; Fri, 30 Aug 2019 12:39:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727729AbfH3Kjx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Aug 2019 06:39:53 -0400
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:39599 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727603AbfH3Kjx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Aug 2019 06:39:53 -0400
Received: from Internal Mail-Server by MTLPINE1 (envelope-from parav@mellanox.com)
        with ESMTPS (AES256-SHA encrypted); 30 Aug 2019 13:39:51 +0300
Received: from sw-mtx-036.mtx.labs.mlnx (sw-mtx-036.mtx.labs.mlnx [10.12.150.149])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id x7UAdoIF005946;
        Fri, 30 Aug 2019 13:39:50 +0300
From:   Parav Pandit <parav@mellanox.com>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     jiri@mellanox.com, Parav Pandit <parav@mellanox.com>
Subject: [PATCH net-next 0/2] Minor cleanup in devlink
Date:   Fri, 30 Aug 2019 05:39:43 -0500
Message-Id: <20190830103945.18097-1-parav@mellanox.com>
X-Mailer: git-send-email 2.19.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Two minor cleanup in devlink.

Patch-1 Explicitly defines devlink port index as unsigned int
Patch-2 Uses switch-case to handle different port flavours attributes


Parav Pandit (2):
  devlink: Make port index data type as unsigned int
  devlink: Use switch-case instead of if-else

 include/net/devlink.h |  2 +-
 net/core/devlink.c    | 44 ++++++++++++++++++++++++-------------------
 2 files changed, 26 insertions(+), 20 deletions(-)

-- 
2.19.2

