Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A832E245683
	for <lists+netdev@lfdr.de>; Sun, 16 Aug 2020 09:34:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728207AbgHPHeQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 16 Aug 2020 03:34:16 -0400
Received: from mga05.intel.com ([192.55.52.43]:28531 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726850AbgHPHeP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 16 Aug 2020 03:34:15 -0400
IronPort-SDR: 3kgXb30O12oh7UqYP4CWLzVwVETt/V4x8wqrJN8reHqJNBXA27+0KHauDANK+ShjzXdyS1ppQp
 Ek0/SlsuFTtg==
X-IronPort-AV: E=McAfee;i="6000,8403,9714"; a="239397000"
X-IronPort-AV: E=Sophos;i="5.76,319,1592895600"; 
   d="scan'208";a="239397000"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Aug 2020 00:34:15 -0700
IronPort-SDR: Wdx9oszRez5wx0S0XgVAK3fAeLVRWRTiRj2sYez4liMYhYtiTxCLOixD5sfSh/BR/HUnn1IcIT
 kypE9EX0uZZQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.76,319,1592895600"; 
   d="scan'208";a="333795647"
Received: from lkp-server02.sh.intel.com (HELO e1f866339154) ([10.239.97.151])
  by FMSMGA003.fm.intel.com with ESMTP; 16 Aug 2020 00:34:12 -0700
Received: from kbuild by e1f866339154 with local (Exim 4.92)
        (envelope-from <lkp@intel.com>)
        id 1k7DBE-0000DH-Bm; Sun, 16 Aug 2020 07:34:12 +0000
Date:   Sun, 16 Aug 2020 15:33:12 +0800
From:   kernel test robot <lkp@intel.com>
To:     Pascal Bouchareine <kalou@tfz.net>, linux-kernel@vger.kernel.org
Cc:     kbuild-all@lists.01.org, Pascal Bouchareine <kalou@tfz.net>,
        linux-api@vger.kernel.org, netdev@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux Memory Management List <linux-mm@kvack.org>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: [RFC PATCH] net: socket: sock_set_description() can be static
Message-ID: <20200816073312.GA89788@037dd5d7cb9b>
References: <20200815182344.7469-3-kalou@tfz.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200815182344.7469-3-kalou@tfz.net>
X-Patchwork-Hint: ignore
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Signed-off-by: kernel test robot <lkp@intel.com>
---
 sock.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/core/sock.c b/net/core/sock.c
index 2cb44a0e38b77d..f145a710974b48 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -828,7 +828,7 @@ void sock_set_rcvbuf(struct sock *sk, int val)
 }
 EXPORT_SYMBOL(sock_set_rcvbuf);
 
-int sock_set_description(struct sock *sk, char __user *user_desc)
+static int sock_set_description(struct sock *sk, char __user *user_desc)
 {
 	char *old, *desc;
 
