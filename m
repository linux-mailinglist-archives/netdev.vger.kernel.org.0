Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A942403542
	for <lists+netdev@lfdr.de>; Wed,  8 Sep 2021 09:25:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349827AbhIHHZO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Sep 2021 03:25:14 -0400
Received: from host.78.145.23.62.rev.coltfrance.com ([62.23.145.78]:47787 "EHLO
        proxy.6wind.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1349783AbhIHHZK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Sep 2021 03:25:10 -0400
Received: from bretzel (unknown [10.16.0.57])
        by proxy.6wind.com (Postfix) with ESMTPS id 6EC26B2B5B3;
        Wed,  8 Sep 2021 09:24:00 +0200 (CEST)
Received: from dichtel by bretzel with local (Exim 4.92)
        (envelope-from <dichtel@6wind.com>)
        id 1mNrw8-0001TL-D5; Wed, 08 Sep 2021 09:24:00 +0200
From:   Nicolas Dichtel <nicolas.dichtel@6wind.com>
To:     steffen.klassert@secunet.com, davem@davemloft.net, kuba@kernel.org,
        antony.antony@secunet.com
Cc:     netdev@vger.kernel.org, Nicolas Dichtel <nicolas.dichtel@6wind.com>
Subject: [PATCH ipsec v2 0/2] xfrm: fix uapi for the default policy
Date:   Wed,  8 Sep 2021 09:23:38 +0200
Message-Id: <20210908072341.5647-1-nicolas.dichtel@6wind.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <202109080912.cNYfj6Ho-lkp@intel.com>
References: <202109080912.cNYfj6Ho-lkp@intel.com>
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

v1 -> v2: fix warnings reported by the kernel test robot

Nicolas Dichtel (2):
  xfrm: make user policy API complete
  xfrm: notify default policy on update

 include/uapi/linux/xfrm.h |  9 ++++--
 net/xfrm/xfrm_user.c      | 62 +++++++++++++++++++++++++++++++--------
 2 files changed, 56 insertions(+), 15 deletions(-)

Comments are welcome,
Nicolas
-- 
2.33.0

