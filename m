Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4FB5322ADC4
	for <lists+netdev@lfdr.de>; Thu, 23 Jul 2020 13:30:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728464AbgGWLaE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jul 2020 07:30:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727828AbgGWLaE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jul 2020 07:30:04 -0400
Received: from mail.katalix.com (mail.katalix.com [IPv6:2a05:d01c:827:b342:16d0:7237:f32a:8096])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id E2064C0619DC
        for <netdev@vger.kernel.org>; Thu, 23 Jul 2020 04:30:03 -0700 (PDT)
Received: from localhost.localdomain (82-69-49-219.dsl.in-addr.zen.co.uk [82.69.49.219])
        (Authenticated sender: tom)
        by mail.katalix.com (Postfix) with ESMTPSA id 3BF7B8AD78;
        Thu, 23 Jul 2020 12:30:03 +0100 (BST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=katalix.com; s=mail;
        t=1595503803; bh=Eni1VDWlCc2WJt1dp4VLCCBW2fSFuwxegPuuF+TCp/g=;
        h=From:To:Cc:Subject:Date:Message-Id:From;
        z=From:=20Tom=20Parkin=20<tparkin@katalix.com>|To:=20netdev@vger.ke
         rnel.org|Cc:=20jchapman@katalix.com,=0D=0A=09Tom=20Parkin=20<tpark
         in@katalix.com>|Subject:=20[PATCH=20net-next=200/6]=20l2tp:=20furt
         her=20checkpatch.pl=20cleanups|Date:=20Thu,=2023=20Jul=202020=2012
         :29:49=20+0100|Message-Id:=20<20200723112955.19808-1-tparkin@katal
         ix.com>;
        b=jTWUy8iKrWd4K4e6g+81GyDZFFHK/vXGNwgowkuH4lZ+nyAY4+eD+dnmBuSmo0vwd
         LPELx6QlcPtttHD9uyQvNZaCOK6aci55nPAde+U2GMBS8Rys5quy44g2wXfgneVbsA
         ysT0GLhnj3ZJWkvVRjVspnv3bZMk9MGzPHrpCjzUBThCFU/aeJ62pR2pkxDYFwrTWb
         t92zikKb90A3fiWcrqsqitwGTQlSXi4/q1Oljs3AjZJm7ke32p0eN4vKpbk9Kpkzz8
         fdnCkOlUtiTWTX8Mok05e5cohWLZuah26SvWLeKH70f0/hgespvpE4wbL+bhGyxD3l
         Zovt2hlKdX3JQ==
From:   Tom Parkin <tparkin@katalix.com>
To:     netdev@vger.kernel.org
Cc:     jchapman@katalix.com, Tom Parkin <tparkin@katalix.com>
Subject: [PATCH net-next 0/6] l2tp: further checkpatch.pl cleanups
Date:   Thu, 23 Jul 2020 12:29:49 +0100
Message-Id: <20200723112955.19808-1-tparkin@katalix.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

l2tp hasn't been kept up to date with the static analysis checks offered
by checkpatch.pl.

This patchset builds on the series "l2tp: cleanup checkpatch.pl
warnings".  It includes small refactoring changes which improve code
quality and resolve a subset of the checkpatch warnings for the l2tp
codebase.

Tom Parkin (6):
  l2tp: cleanup comparisons to NULL
  l2tp: cleanup unnecessary braces in if statements
  l2tp: check socket address type in l2tp_dfs_seq_tunnel_show
  l2tp: cleanup netlink send of tunnel address information
  l2tp: cleanup netlink tunnel create address handling
  l2tp: cleanup kzalloc calls

 net/l2tp/l2tp_core.c    |  30 +++---
 net/l2tp/l2tp_debugfs.c |  20 ++--
 net/l2tp/l2tp_ip.c      |   2 +-
 net/l2tp/l2tp_ip6.c     |   2 +-
 net/l2tp/l2tp_netlink.c | 206 ++++++++++++++++++++++------------------
 net/l2tp/l2tp_ppp.c     |  59 ++++++------
 6 files changed, 169 insertions(+), 150 deletions(-)

-- 
2.17.1

