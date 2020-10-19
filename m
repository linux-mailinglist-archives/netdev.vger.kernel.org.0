Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B5462293082
	for <lists+netdev@lfdr.de>; Mon, 19 Oct 2020 23:32:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733081AbgJSVck (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Oct 2020 17:32:40 -0400
Received: from mx2.suse.de ([195.135.220.15]:41410 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733061AbgJSVcj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 19 Oct 2020 17:32:39 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 1F488AC2F;
        Mon, 19 Oct 2020 21:32:38 +0000 (UTC)
Received: by lion.mk-sys.cz (Postfix, from userid 1000)
        id D814E60563; Mon, 19 Oct 2020 23:32:37 +0200 (CEST)
Message-Id: <cover.1603142897.git.mkubecek@suse.cz>
From:   Michal Kubecek <mkubecek@suse.cz>
Subject: [PATCH ethtool 0/4] add missing message descriptions
To:     netdev@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>
Date:   Mon, 19 Oct 2020 23:32:37 +0200 (CEST)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add message descriptions needed for pretty printing of netlink messages
related to recently added features: genetlink policy dumps and pause frame
statistics. First two patches extend pretty printing code with features
used by these descriptions: support for 64-bit numeric attributes and
and enumerated types (shown as symbolic names rather than numeric values).

Michal Kubecek (4):
  netlink: support u32 enumerated types in pretty printing
  netlink: support 64-bit attribute types in pretty printed messages
  netlink: add descriptions for genetlink policy dumps
  netlink: add message descriptions for pause stats

 netlink/desc-ethtool.c  |  7 +++++
 netlink/desc-genlctrl.c | 57 +++++++++++++++++++++++++++++++++++++++++
 netlink/prettymsg.c     | 19 ++++++++++++++
 netlink/prettymsg.h     | 24 +++++++++++++++--
 4 files changed, 105 insertions(+), 2 deletions(-)

-- 
2.28.0

