Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A2F596458B
	for <lists+netdev@lfdr.de>; Wed, 10 Jul 2019 13:03:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727343AbfGJLDg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Jul 2019 07:03:36 -0400
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:54916 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727121AbfGJLDf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Jul 2019 07:03:35 -0400
Received: from Internal Mail-Server by MTLPINE2 (envelope-from tariqt@mellanox.com)
        with ESMTPS (AES256-SHA encrypted); 10 Jul 2019 14:03:30 +0300
Received: from dev-l-vrt-206-006.mtl.labs.mlnx (dev-l-vrt-206-006.mtl.labs.mlnx [10.134.206.6])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id x6AB3URw020650;
        Wed, 10 Jul 2019 14:03:30 +0300
From:   Tariq Toukan <tariqt@mellanox.com>
To:     Stephen Hemminger <stephen@networkplumber.org>
Cc:     netdev@vger.kernel.org, moshe@mellanox.com, ayal@mellanox.com,
        Tariq Toukan <tariqt@mellanox.com>
Subject: [PATCH iproute2 master 0/3] devlink dumpit fixes
Date:   Wed, 10 Jul 2019 14:03:18 +0300
Message-Id: <1562756601-19171-1-git-send-email-tariqt@mellanox.com>
X-Mailer: git-send-email 1.8.3.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

This series from Aya contains several fixes for devlink health
dump show command with binary data.

In patch 1 we replace the usage of doit with a dumpit, which
is non-blocking and allows transferring larger amount of data.

Patches 2 and 3 fix the output for binary data prints, for both
json and non-json.

Series generated against master commit:
2eb23f3e7aaf devlink: Show devlink port number

Regards,
Tariq

Aya Levin (3):
  devlink: Change devlink health dump show command to dumpit
  devlink: Fix binary values print
  devlink: Remove enclosing array brackets binary print with json format

 devlink/devlink.c | 41 +++++++++++++++++++++--------------------
 1 file changed, 21 insertions(+), 20 deletions(-)

-- 
1.8.3.1

