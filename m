Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2EB2E2310BF
	for <lists+netdev@lfdr.de>; Tue, 28 Jul 2020 19:20:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731925AbgG1RUo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jul 2020 13:20:44 -0400
Received: from mail.katalix.com ([3.9.82.81]:43936 "EHLO mail.katalix.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731684AbgG1RUn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 Jul 2020 13:20:43 -0400
Received: from localhost.localdomain (82-69-49-219.dsl.in-addr.zen.co.uk [82.69.49.219])
        (Authenticated sender: tom)
        by mail.katalix.com (Postfix) with ESMTPSA id 4E2AA9159A;
        Tue, 28 Jul 2020 18:20:41 +0100 (BST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=katalix.com; s=mail;
        t=1595956841; bh=rcQdwB73DTcAzvQQ1Rf9PHt4THi38QZI0ZDmD1Nm6so=;
        h=From:To:Cc:Subject:Date:Message-Id:From;
        z=From:=20Tom=20Parkin=20<tparkin@katalix.com>|To:=20netdev@vger.ke
         rnel.org|Cc:=20jchapman@katalix.com,=0D=0A=09Tom=20Parkin=20<tpark
         in@katalix.com>|Subject:=20[PATCH=200/6]=20l2tp:=20tidy=20up=20l2t
         p=20core=20API|Date:=20Tue,=2028=20Jul=202020=2018:20:27=20+0100|M
         essage-Id:=20<20200728172033.19532-1-tparkin@katalix.com>;
        b=0jtWdQM7UpUUMYWFCUtaNUxCQEHt9U6zvMdpsIRDE6pQLDPerLO4piRNcQiOlnrqU
         bL92X0HL3nMsMmT/x8un4TVwRgT+jSFJLfK9IJ2udUv6pxFEb683LYVlfrNd3t23zR
         dI9otx3czEaSpccN7sC4GBOV4gXIAjm/3lxFmTK9uR/lgVqJhuOxSZUkhhI9uDOY8l
         JwSXIG2P16O8YvcnERguHqwkf1c7AsxPvXyw0FKjQoNezZ4O14+w33mvqGrklqWO7O
         rcbGMch9wdloht675fcAbviUiopoJzOmlzLcSv+mI9u/IjK4guFK+ZdMDXf78B7Llg
         QKJsGFNij1Nlg==
From:   Tom Parkin <tparkin@katalix.com>
To:     netdev@vger.kernel.org
Cc:     jchapman@katalix.com, Tom Parkin <tparkin@katalix.com>
Subject: [PATCH 0/6] l2tp: tidy up l2tp core API
Date:   Tue, 28 Jul 2020 18:20:27 +0100
Message-Id: <20200728172033.19532-1-tparkin@katalix.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This short series makes some minor tidyup changes to the L2TP core API.

Tom Parkin (6):
  l2tp: don't export __l2tp_session_unhash
  l2tp: don't export tunnel and session free functions
  l2tp: return void from l2tp_session_delete
  l2tp: remove build_header callback in struct l2tp_session
  l2tp: tweak exports for l2tp_recv_common and l2tp_ioctl
  l2tp: improve API documentation in l2tp_core.h

 net/l2tp/l2tp_core.c    | 138 +++++++++++++++++++++-------------------
 net/l2tp/l2tp_core.h    | 123 ++++++++++++++++++++++-------------
 net/l2tp/l2tp_ip.c      |   2 +-
 net/l2tp/l2tp_netlink.c |   2 +-
 4 files changed, 154 insertions(+), 111 deletions(-)

-- 
2.17.1

