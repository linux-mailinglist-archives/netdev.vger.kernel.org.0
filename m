Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 55C201465CF
	for <lists+netdev@lfdr.de>; Thu, 23 Jan 2020 11:33:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728139AbgAWKdJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jan 2020 05:33:09 -0500
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:47577 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726194AbgAWKdI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jan 2020 05:33:08 -0500
Received: from Internal Mail-Server by MTLPINE1 (envelope-from rondi@mellanox.com)
        with ESMTPS (AES256-SHA encrypted); 23 Jan 2020 12:33:01 +0200
Received: from nps-server-35.mtl.labs.mlnx (nps-server-35.mtl.labs.mlnx [10.137.1.140])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id 00NAX1Qr002799;
        Thu, 23 Jan 2020 12:33:01 +0200
Received: from nps-server-35.mtl.labs.mlnx (localhost [127.0.0.1])
        by nps-server-35.mtl.labs.mlnx (8.15.2/8.15.2/Debian-11ubuntu1) with ESMTP id 00NAX1xr022710;
        Thu, 23 Jan 2020 12:33:01 +0200
Received: (from rondi@localhost)
        by nps-server-35.mtl.labs.mlnx (8.15.2/8.15.2/Submit) id 00NAWwDD022708;
        Thu, 23 Jan 2020 12:32:58 +0200
From:   Ron Diskin <rondi@mellanox.com>
To:     Stephen Hemminger <stephen@networkplumber.org>,
        David Ahern <dsahern@gmail.com>
Cc:     Jiri Pirko <jiri@mellanox.com>, Moshe Shemesh <moshe@mellanox.com>,
        netdev@vger.kernel.org, Ron Diskin <rondi@mellanox.com>
Subject: [PATCH iproute2 0/6] devlink: Replace devlink print helper functions with common library functions 
Date:   Thu, 23 Jan 2020 12:32:25 +0200
Message-Id: <1579775551-22659-1-git-send-email-rondi@mellanox.com>
X-Mailer: git-send-email 1.8.4.3
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patchset converts devlink prints (json and non-json) to use the
same common json library as the rest of iproute2.
Patches 1-2 add necessary functionality to json_print library.
Patch 3 removes the direct calls to json_writer. 
Patches 4-6 use the new functionality, replacing different pr_out_#type
wrapper.

Ron Diskin (6):
  json_print: Introduce print_#type_name_value
  json_print: Add new json object function not as array item
  devlink: Replace json prints by common library functions
  devlink: Replace pr_out_str wrapper function with common function
  devlink: Replace pr_#type_value wrapper functions with common
    functions
  devlink: Replace pr_out_bool/uint() wrappers with common print
    functions

 devlink/devlink.c    | 610 +++++++++++++++++++++----------------------
 include/json_print.h |   9 +
 lib/json_print.c     |  43 ++-
 3 files changed, 345 insertions(+), 317 deletions(-)

-- 
2.19.1

