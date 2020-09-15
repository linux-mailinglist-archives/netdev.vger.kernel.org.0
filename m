Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F2D326B5E2
	for <lists+netdev@lfdr.de>; Wed, 16 Sep 2020 01:53:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727159AbgIOXxL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Sep 2020 19:53:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:49610 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727131AbgIOXxB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 15 Sep 2020 19:53:01 -0400
Received: from kicinski-fedora-PC1C0HJN.thefacebook.com (unknown [163.114.132.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9D48120720;
        Tue, 15 Sep 2020 23:53:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600213980;
        bh=N0vl4opf94dZqSohXZUqPqMNbfm0xUoZuhodur17PRY=;
        h=From:To:Cc:Subject:Date:From;
        b=JF+9yiyC0/Yelhl2EtbVgDbldVtRb01QJnUh5eqGVz7pyz/0RmMfGPKkAlmx//F/e
         7b53IzcxOELpflUvvoSLq/Rp1e7bkepH7rsOC72+/B3Fb81orGsg+txOOt7qYQelP1
         Cueo1O8if6Eyiqi3MaLA3cWZkfVxUvn2q6vBGRrM=
From:   Jakub Kicinski <kuba@kernel.org>
To:     mkubecek@suse.cz
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH ethtool-next 0/5] pause frame stats
Date:   Tue, 15 Sep 2020 16:52:54 -0700
Message-Id: <20200915235259.457050-1-kuba@kernel.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi!

This set adds support for pause frame statistics.

This is the first of this kind of statistics so first
support for a new flag (--include-statistics) is added.
Next pause frame info is extended to support --json.
Last but not least - it's taught to display statistics.

Jakub Kicinski (5):
  update UAPI header copies
  pause: add --json support
  separate FLAGS out in -h
  add support for stats in subcommands
  pause: add support for dumping statistics

 ethtool.8.in                 |   7 +++
 ethtool.c                    |  17 +++++-
 internal.h                   |   1 +
 netlink/netlink.h            |  12 +++-
 netlink/pause.c              | 111 +++++++++++++++++++++++++++++++----
 uapi/linux/ethtool_netlink.h |  18 +++++-
 6 files changed, 149 insertions(+), 17 deletions(-)

-- 
2.26.2

