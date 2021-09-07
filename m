Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A80D1402F16
	for <lists+netdev@lfdr.de>; Tue,  7 Sep 2021 21:42:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345741AbhIGTnj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Sep 2021 15:43:39 -0400
Received: from host.78.145.23.62.rev.coltfrance.com ([62.23.145.78]:47049 "EHLO
        proxy.6wind.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S229574AbhIGTnb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Sep 2021 15:43:31 -0400
X-Greylist: delayed 422 seconds by postgrey-1.27 at vger.kernel.org; Tue, 07 Sep 2021 15:43:30 EDT
Received: from bretzel (unknown [10.16.0.57])
        by proxy.6wind.com (Postfix) with ESMTPS id 503A6B29A9E;
        Tue,  7 Sep 2021 21:35:21 +0200 (CEST)
Received: from dichtel by bretzel with local (Exim 4.92)
        (envelope-from <dichtel@6wind.com>)
        id 1mNgsL-0004IB-8h; Tue, 07 Sep 2021 21:35:21 +0200
From:   Nicolas Dichtel <nicolas.dichtel@6wind.com>
To:     steffen.klassert@secunet.com, davem@davemloft.net, kuba@kernel.org,
        antony.antony@secunet.com
Cc:     netdev@vger.kernel.org, Nicolas Dichtel <nicolas.dichtel@6wind.com>
Subject: [PATCH ipsec 0/2] xfrm: fix uapi for the default policy
Date:   Tue,  7 Sep 2021 21:35:07 +0200
Message-Id: <20210907193510.16487-1-nicolas.dichtel@6wind.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <9b0ddb88-c7d3-9bb6-48f2-1967425b3fc7@6wind.com>
References: <9b0ddb88-c7d3-9bb6-48f2-1967425b3fc7@6wind.com>
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

Nicolas Dichtel (2):
  xfrm: make user policy API complete
  xfrm: notify default policy on update

 include/uapi/linux/xfrm.h |  9 ++++--
 net/xfrm/xfrm_user.c      | 58 +++++++++++++++++++++++++++++++++------
 2 files changed, 55 insertions(+), 12 deletions(-)

Comments are welcome,
Nicolas
-- 
2.33.0

