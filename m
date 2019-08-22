Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AC75B9919C
	for <lists+netdev@lfdr.de>; Thu, 22 Aug 2019 13:06:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388000AbfHVLFy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Aug 2019 07:05:54 -0400
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:33433 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729038AbfHVLFy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Aug 2019 07:05:54 -0400
Received: from Internal Mail-Server by MTLPINE1 (envelope-from ayal@mellanox.com)
        with ESMTPS (AES256-SHA encrypted); 22 Aug 2019 14:05:48 +0300
Received: from dev-l-vrt-210.mtl.labs.mlnx (dev-l-vrt-210.mtl.labs.mlnx [10.134.210.1])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id x7MB5mB8016285;
        Thu, 22 Aug 2019 14:05:48 +0300
Received: from dev-l-vrt-210.mtl.labs.mlnx (localhost [127.0.0.1])
        by dev-l-vrt-210.mtl.labs.mlnx (8.15.2/8.15.2/Debian-8ubuntu1) with ESMTP id x7MB5mKG028568;
        Thu, 22 Aug 2019 14:05:48 +0300
Received: (from ayal@localhost)
        by dev-l-vrt-210.mtl.labs.mlnx (8.15.2/8.15.2/Submit) id x7MB5hJm028565;
        Thu, 22 Aug 2019 14:05:43 +0300
From:   Aya Levin <ayal@mellanox.com>
To:     netdev@vger.kernel.org,
        Stephen Hemminger <stephen@networkplumber.org>,
        Jiri Pirko <jiri@mellanox.com>
Cc:     Moshe Shemesh <moshe@mellanox.com>, Aya Levin <ayal@mellanox.com>
Subject: [iproute2, master 0/2] Fix reporter's dump's time-stamp
Date:   Thu, 22 Aug 2019 14:05:40 +0300
Message-Id: <1566471942-28529-1-git-send-email-ayal@mellanox.com>
X-Mailer: git-send-email 1.8.4.3
In-Reply-To: <1566461871-21992-1-git-send-email-ayal@mellanox.com>
References: <1566461871-21992-1-git-send-email-ayal@mellanox.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch set handles the reporter's dump time-stamp display. First
patch refactors the current implementation of helper function which
displays the reporter's dump time-stamp and add the actual print to
the function's body.

The second patch introduces a new attribute which is the time-stamp in
timespec (current time) instead of jiffies. When the new attribute is
present try and translate the time-stamp according to 'current time'.

Aya Levin (2):
  devlink: Print health reporter's dump time-stamp in a helper function
  devlink: Add a new time-stamp format for health reporter's dump

 devlink/devlink.c            | 44 ++++++++++++++++++++++++++++----------------
 include/uapi/linux/devlink.h |  2 ++
 2 files changed, 30 insertions(+), 16 deletions(-)

-- 
2.14.1

