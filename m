Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 86AAE2251FC
	for <lists+netdev@lfdr.de>; Sun, 19 Jul 2020 15:37:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726135AbgGSNgs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Jul 2020 09:36:48 -0400
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:40941 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726061AbgGSNgr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Jul 2020 09:36:47 -0400
Received: from Internal Mail-Server by MTLPINE1 (envelope-from moshe@mellanox.com)
        with SMTP; 19 Jul 2020 16:36:40 +0300
Received: from vnc1.mtl.labs.mlnx (vnc1.mtl.labs.mlnx [10.7.2.1])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id 06JDaet4018648;
        Sun, 19 Jul 2020 16:36:40 +0300
Received: from vnc1.mtl.labs.mlnx (localhost [127.0.0.1])
        by vnc1.mtl.labs.mlnx (8.14.4/8.14.4) with ESMTP id 06JDaetf013801;
        Sun, 19 Jul 2020 16:36:40 +0300
Received: (from moshe@localhost)
        by vnc1.mtl.labs.mlnx (8.14.4/8.14.4/Submit) id 06JDaYbw013787;
        Sun, 19 Jul 2020 16:36:34 +0300
From:   Moshe Shemesh <moshe@mellanox.com>
To:     Stephen Hemminger <stephen@networkplumber.org>,
        David Ahern <dsahern@gmail.com>
Cc:     Jiri Pirko <jiri@mellanox.com>, netdev@vger.kernel.org,
        Moshe Shemesh <moshe@mellanox.com>
Subject: [PATCH iproute2-next 0/3] devlink: Add devlink port health command
Date:   Sun, 19 Jul 2020 16:36:00 +0300
Message-Id: <1595165763-13657-1-git-send-email-moshe@mellanox.com>
X-Mailer: git-send-email 1.8.4.3
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Implement commands for interaction with per-port devlink health
reporters. To do this, adapt devlink-health for usage of port handles
with any existing devlink-health subcommands. Add devlink-port health
subcommand as an alias for devlink-health.

Vladyslav Tarasiuk (3):
  devlink: Add a possibility to print arrays of devlink port handles
  devlink: Add devlink port health command
  devlink: Update devlink-health and devlink-port manpages

 devlink/devlink.c         |   94 +++++++++++++++++++++++++++++++++++----------
 man/man8/devlink-health.8 |   84 ++++++++++++++++++++++++++++-----------
 man/man8/devlink-port.8   |   19 +++++++++
 3 files changed, 152 insertions(+), 45 deletions(-)

