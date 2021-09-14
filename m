Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D060F40B1F4
	for <lists+netdev@lfdr.de>; Tue, 14 Sep 2021 16:48:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234465AbhINOsq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Sep 2021 10:48:46 -0400
Received: from host.78.145.23.62.rev.coltfrance.com ([62.23.145.78]:45653 "EHLO
        proxy.6wind.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S234636AbhINOsQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Sep 2021 10:48:16 -0400
Received: from bretzel (unknown [10.16.0.57])
        by proxy.6wind.com (Postfix) with ESMTPS id B279FB41E28;
        Tue, 14 Sep 2021 16:46:56 +0200 (CEST)
Received: from dichtel by bretzel with local (Exim 4.92)
        (envelope-from <dichtel@6wind.com>)
        id 1mQ9i4-0001nK-M1; Tue, 14 Sep 2021 16:46:56 +0200
From:   Nicolas Dichtel <nicolas.dichtel@6wind.com>
To:     steffen.klassert@secunet.com, davem@davemloft.net, kuba@kernel.org,
        antony.antony@secunet.com
Cc:     netdev@vger.kernel.org, Nicolas Dichtel <nicolas.dichtel@6wind.com>
Subject: [PATCH ipsec v3 0/2] xfrm: fix uapi for the default policy
Date:   Tue, 14 Sep 2021 16:46:32 +0200
Message-Id: <20210914144635.6850-1-nicolas.dichtel@6wind.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210908072341.5647-1-nicolas.dichtel@6wind.com>
References: <20210908072341.5647-1-nicolas.dichtel@6wind.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This feature has just been merged after the last release, thus it's still
time to fix the uapi.
As stated in the thread, the uapi is based on some magic values (from the
userland POV).
Here is a proposal to simplify this uapi and make it clear how to use it.
The other problem was the notification: changing the default policy may
radically change the packets flows.

v2 -> v3: rebase on top of ipsec tree

v1 -> v2: fix warnings reported by the kernel test robot

Nicolas Dichtel (2):
  xfrm: make user policy API complete
  xfrm: notify default policy on update

 include/uapi/linux/xfrm.h |  9 ++++--
 net/xfrm/xfrm_user.c      | 67 +++++++++++++++++++++++++++++----------
 2 files changed, 56 insertions(+), 20 deletions(-)

Comments are welcome,
Nicolas
-- 
2.33.0

