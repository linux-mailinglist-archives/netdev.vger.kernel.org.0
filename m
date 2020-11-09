Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C1C42AB841
	for <lists+netdev@lfdr.de>; Mon,  9 Nov 2020 13:30:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729516AbgKIMaw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Nov 2020 07:30:52 -0500
Received: from mx2.suse.de ([195.135.220.15]:41008 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727826AbgKIMaw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 9 Nov 2020 07:30:52 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 7CCB0ABDE;
        Mon,  9 Nov 2020 12:30:51 +0000 (UTC)
Received: by lion.mk-sys.cz (Postfix, from userid 1000)
        id 3622E60344; Mon,  9 Nov 2020 13:30:51 +0100 (CET)
Message-Id: <cover.1604924742.git.mkubecek@suse.cz>
From:   Michal Kubecek <mkubecek@suse.cz>
Subject: [PATCH ethtool 0/2] netlink: data lifetime error fixes
To:     netdev@vger.kernel.org
Cc:     Ido Schimmel <idosch@idosch.org>, Ivan Vecera <ivecera@redhat.com>
Date:   Mon,  9 Nov 2020 13:30:51 +0100 (CET)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fixes of two data lifetime bugs found by testing with valgrind: one use
after free, one memory leak.

Michal Kubecek (2):
  netlink: fix use after free in netlink_run_handler()
  netlink: fix leaked instances of struct nl_socket

 netlink/netlink.c | 21 +++++++++++++++------
 netlink/nlsock.c  |  3 +++
 2 files changed, 18 insertions(+), 6 deletions(-)

-- 
2.29.2

