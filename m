Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 38EEF3C9E62
	for <lists+netdev@lfdr.de>; Thu, 15 Jul 2021 14:13:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234549AbhGOMQP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Jul 2021 08:16:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234274AbhGOMQP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Jul 2021 08:16:15 -0400
Received: from out2.migadu.com (out2.migadu.com [IPv6:2001:41d0:2:aacc::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BE68C06175F;
        Thu, 15 Jul 2021 05:13:22 -0700 (PDT)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1626351199;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=ZUWdOGGsFfJGsDQViI7TOTWC3PhzFOsTKB3LuxnIBOw=;
        b=JmeL7uPEttuSCd9PW6GIfBEPMECgc8VOi/H81Mbi1OQdTAX4atSxPArwl+7kVBFqPq80Ga
        /hRLgdnmnkH79jvmltUshUiuzWnWvtxKJtl39QpsHiJdCwqB/2Br+HnVpwguYhOTM2SS44
        I2i2/QhxKycttIi9h5zhd+AmzXgYuSA=
From:   Yajun Deng <yajun.deng@linux.dev>
To:     davem@davemloft.net, kuba@kernel.org, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, jiri@resnulli.us,
        johannes.berg@intel.com, avagin@gmail.com, ryazanov.s.a@gmail.com,
        vladimir.oltean@nxp.com, roopa@cumulusnetworks.com,
        yajun.deng@linux.dev, zhudi21@huawei.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 0/2] net: Deal with if statement in rtnetlink_send()
Date:   Thu, 15 Jul 2021 20:12:56 +0800
Message-Id: <20210715121258.18385-1-yajun.deng@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: yajun.deng@linux.dev
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Patch1: use nlmsg_notify() in rtnetlink_send(), so that the caller 
wouldn't deal with if statement.
Patch2: Remove unnecessary if statement.


Yajun Deng (2):
  rtnetlink: use nlmsg_notify() in rtnetlink_send()
  net/sched: Remove unnecessary if statement

 net/core/rtnetlink.c |  9 +--------
 net/sched/act_api.c  | 12 ++----------
 net/sched/cls_api.c  | 15 ++++-----------
 net/sched/sch_api.c  | 10 ++--------
 4 files changed, 9 insertions(+), 37 deletions(-)

-- 
2.32.0

