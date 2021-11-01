Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9CB5B44233D
	for <lists+netdev@lfdr.de>; Mon,  1 Nov 2021 23:15:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232226AbhKAWS0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Nov 2021 18:18:26 -0400
Received: from mail.netfilter.org ([217.70.188.207]:59198 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231855AbhKAWSO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Nov 2021 18:18:14 -0400
Received: from localhost.localdomain (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id EA91663F4E;
        Mon,  1 Nov 2021 23:13:45 +0100 (CET)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net 0/2] Netfilter/IPVS fixes for net
Date:   Mon,  1 Nov 2021 23:15:26 +0100
Message-Id: <20211101221528.236114-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

The following patchset contains Netfilter/IPVS fixes for net:

1) Fix mac address UAF reported by KASAN in nfnetlink_queue,
   from Florian Westphal.

2) Autoload genetlink IPVS on demand, from Thomas Weissschuh.

Please, pull these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf.git

Thanks.

----------------------------------------------------------------

The following changes since commit 64222515138e43da1fcf288f0289ef1020427b87:

  Merge tag 'drm-fixes-2021-10-22' of git://anongit.freedesktop.org/drm/drm (2021-10-21 19:06:08 -1000)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf.git HEAD

for you to fetch changes up to 2199f562730dd1382946e0a2532afc38cd444129:

  ipvs: autoload ipvs on genl access (2021-10-22 14:10:17 +0200)

----------------------------------------------------------------
Florian Westphal (1):
      netfilter: nfnetlink_queue: fix OOB when mac header was cleared

Thomas Weißschuh (1):
      ipvs: autoload ipvs on genl access

 net/netfilter/ipvs/ip_vs_ctl.c  | 2 ++
 net/netfilter/nfnetlink_queue.c | 2 +-
 2 files changed, 3 insertions(+), 1 deletion(-)
