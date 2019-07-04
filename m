Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 870575FEE3
	for <lists+netdev@lfdr.de>; Fri,  5 Jul 2019 01:58:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727695AbfGDX5z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Jul 2019 19:57:55 -0400
Received: from smtprelay0069.hostedemail.com ([216.40.44.69]:57118 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727313AbfGDX5y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Jul 2019 19:57:54 -0400
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay01.hostedemail.com (Postfix) with ESMTP id 1896C100E86C0;
        Thu,  4 Jul 2019 23:57:53 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::::,RULES_HIT:41:355:379:541:973:988:989:1260:1345:1437:1534:1540:1711:1730:1747:1777:1792:1801:2393:2559:2562:3138:3139:3140:3141:3142:3352:3865:3866:3867:3870:3871:4605:5007:6261:8603:10004:10848:11658:11914:12043:12048:12297:12679:12895:13069:13138:13161:13229:13231:13311:13357:14096:14384:14394:14581:21080:21451:21627:30054:30079,0,RBL:23.242.196.136:@perches.com:.lbl8.mailshell.net-62.8.0.180 64.201.201.201,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:neutral,Custom_rules:0:0:0,LFtime:24,LUA_SUMMARY:none
X-HE-Tag: girl52_61bbf4fecba19
X-Filterd-Recvd-Size: 1739
Received: from joe-laptop.perches.com (cpe-23-242-196-136.socal.res.rr.com [23.242.196.136])
        (Authenticated sender: joe@perches.com)
        by omf14.hostedemail.com (Postfix) with ESMTPA;
        Thu,  4 Jul 2019 23:57:51 +0000 (UTC)
From:   Joe Perches <joe@perches.com>
To:     Dan Murphy <dmurphy@ti.com>, linux-leds@vger.kernel.org,
        linux-media@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linuxppc-dev@lists.ozlabs.org, linux-nfs@vger.kernel.org
Cc:     linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH 0/8] treewide: correct misuses of strscpy/strlcpy
Date:   Thu,  4 Jul 2019 16:57:40 -0700
Message-Id: <cover.1562283944.git.joe@perches.com>
X-Mailer: git-send-email 2.15.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

These are all likely copy/paste defects where the field size of the
'copied to' array is incorrect.

Each patch in this series is independent.

Joe Perches (8):
  Input: synaptics: Fix misuse of strlcpy
  leds: as3645a: Fix misuse of strlcpy
  media: m2m-deinterlace: Fix misuse of strscpy
  media: go7007: Fix misuse of strscpy
  net: ethernet: sun4i-emac: Fix misuse of strlcpy
  net: nixge: Fix misuse of strlcpy
  tty: hvcs: Fix odd use of strlcpy
  nfsd: Fix misuse of strlcpy

 drivers/input/mouse/synaptics.c             | 2 +-
 drivers/leds/leds-as3645a.c                 | 2 +-
 drivers/media/platform/m2m-deinterlace.c    | 2 +-
 drivers/media/usb/go7007/snd-go7007.c       | 2 +-
 drivers/net/ethernet/allwinner/sun4i-emac.c | 4 ++--
 drivers/net/ethernet/ni/nixge.c             | 2 +-
 drivers/tty/hvc/hvcs.c                      | 4 ++--
 fs/nfsd/nfs4idmap.c                         | 2 +-
 8 files changed, 10 insertions(+), 10 deletions(-)

-- 
2.15.0

