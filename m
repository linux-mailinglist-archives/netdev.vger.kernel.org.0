Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 42FD4229D22
	for <lists+netdev@lfdr.de>; Wed, 22 Jul 2020 18:32:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728059AbgGVQce (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jul 2020 12:32:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726349AbgGVQce (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jul 2020 12:32:34 -0400
Received: from mail.katalix.com (mail.katalix.com [IPv6:2a05:d01c:827:b342:16d0:7237:f32a:8096])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 2165CC0619DC
        for <netdev@vger.kernel.org>; Wed, 22 Jul 2020 09:32:34 -0700 (PDT)
Received: from localhost.localdomain (82-69-49-219.dsl.in-addr.zen.co.uk [82.69.49.219])
        (Authenticated sender: tom)
        by mail.katalix.com (Postfix) with ESMTPSA id 6EF9B915B2;
        Wed, 22 Jul 2020 17:32:33 +0100 (BST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=katalix.com; s=mail;
        t=1595435553; bh=Qzgyl3c/3voTC9Nfj8oU0Kab+QD1eczm0fTEW7ktQoI=;
        h=From:To:Cc:Subject:Date:Message-Id:From;
        z=From:=20Tom=20Parkin=20<tparkin@katalix.com>|To:=20netdev@vger.ke
         rnel.org|Cc:=20jchapman@katalix.com,=0D=0A=09Tom=20Parkin=20<tpark
         in@katalix.com>|Subject:=20[PATCH=20v2=20net-next=2000/10]=20l2tp:
         =20cleanup=20checkpatch.pl=20warnings|Date:=20Wed,=2022=20Jul=2020
         20=2017:32:04=20+0100|Message-Id:=20<20200722163214.7920-1-tparkin
         @katalix.com>;
        b=lG5n23gNwzLaoZzxbfxVaJE9MAwjNyXMvpOTnzItKoPXilovVUqCKGG5vSKgzuDyQ
         aPSTvZJ2gM+ZM8ZFPAlAtloIDBoMyUhhjnWF5gdtIpxsb6izaTxaTdQC6PKj7X56B6
         /01pm89nJD8i39jOdjGWWOWtjKRZbhy0L2HZ8KJj7UdM0cbBGFNJH84gCduF3F9u8u
         nRTU10Z8tpUTP3+mlxDwSOuQAXmvFSzP2w7uAoQjHmmVvqOl61O70zRiRCumcG4hev
         EIbhfLnbLBYSuBjECr/bbGqabASjHA6E2N/Yo4KM5A5AsTDBLco59zh7V/jXjnutT6
         AG0MrqYhB6fXw==
From:   Tom Parkin <tparkin@katalix.com>
To:     netdev@vger.kernel.org
Cc:     jchapman@katalix.com, Tom Parkin <tparkin@katalix.com>
Subject: [PATCH v2 net-next 00/10] l2tp: cleanup checkpatch.pl warnings
Date:   Wed, 22 Jul 2020 17:32:04 +0100
Message-Id: <20200722163214.7920-1-tparkin@katalix.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

l2tp hasn't been kept up to date with the static analysis checks offered
by checkpatch.pl.

This series addresses a range of minor issues which don't involve large
changes to code structure.  The changes include:

 * tweaks to use of whitespace, comment style, line breaks,
   and indentation

 * two minor modifications to code to use a function or macro suggested
   by checkpatch

v1 -> v2

 * combine related patches (patches fixing whitespace issues, patches
   addressing comment style)

 * respin the single large patchset into a multiple smaller series for
   easier review

Tom Parkin (10):
  l2tp: cleanup whitespace use
  l2tp: cleanup comments
  l2tp: cleanup difficult-to-read line breaks
  l2tp: cleanup wonky alignment of line-broken function calls
  l2tp: cleanup suspect code indent
  l2tp: add identifier name in function pointer prototype
  l2tp: prefer using BIT macro
  l2tp: prefer seq_puts for unformatted output
  l2tp: line-break long function prototypes
  l2tp: avoid precidence issues in L2TP_SKB_CB macro

 net/l2tp/l2tp_core.c    | 69 +++++++++++++++++-----------------
 net/l2tp/l2tp_core.h    | 82 +++++++++++++++++------------------------
 net/l2tp/l2tp_debugfs.c | 11 ++----
 net/l2tp/l2tp_eth.c     | 19 ++++------
 net/l2tp/l2tp_ip.c      | 17 +++++----
 net/l2tp/l2tp_ip6.c     | 29 +++++++--------
 net/l2tp/l2tp_netlink.c | 75 ++++++++++++++++---------------------
 net/l2tp/l2tp_ppp.c     | 20 +++++-----
 8 files changed, 145 insertions(+), 177 deletions(-)

-- 
2.17.1

