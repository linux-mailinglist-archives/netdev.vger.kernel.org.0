Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C44EB3991E0
	for <lists+netdev@lfdr.de>; Wed,  2 Jun 2021 19:44:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230341AbhFBRqS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Jun 2021 13:46:18 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:23964 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229574AbhFBRqP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Jun 2021 13:46:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1622655872;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=Y62Jwe0lWGjkkhREiWukC1W0Cl1ntAjQYPKkQTwBGl0=;
        b=TjM5KwrAQbZT36fHU9RyTNdk8h9khyyDug1lT+e6zNIclDtViiswhsjCWALSzqpKA+yzfW
        GjUD1QBnJ5D51fNXuQYs52+8LQaq2jFAMlzh4QeiWg1Yq50N+dKPqDVQocASwaUIsZ3Obw
        jVI3+Js5gAZqRtLmIjRti8c/VBdUKq4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-467-HLtX85rBMTmXffDUKZi-1A-1; Wed, 02 Jun 2021 13:44:30 -0400
X-MC-Unique: HLtX85rBMTmXffDUKZi-1A-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7D280801817;
        Wed,  2 Jun 2021 17:44:28 +0000 (UTC)
Received: from ymir.virt.lab.eng.bos.redhat.com (virtlab420.virt.lab.eng.bos.redhat.com [10.19.152.148])
        by smtp.corp.redhat.com (Postfix) with ESMTP id F032C5C277;
        Wed,  2 Jun 2021 17:44:26 +0000 (UTC)
From:   jmaloy@redhat.com
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     tipc-discussion@lists.sourceforge.net,
        tung.q.nguyen@dektech.com.au, hoang.h.le@dektech.com.au,
        tuong.t.lien@dektech.com.au, jmaloy@redhat.com, maloy@donjonn.com,
        xinl@redhat.com, ying.xue@windriver.com,
        parthasarathy.bhuvaragan@gmail.com
Subject: [net-next v2 0/3] tipc: some small cleanups
Date:   Wed,  2 Jun 2021 13:44:23 -0400
Message-Id: <20210602174426.870536-1-jmaloy@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jon Maloy <jmaloy@redhat.com>

We make some minor code cleanups and improvements.

---
v2: Changed value of TIPC_ANY_SCOPE macro in patch #3
    to avoid compiler warning

Jon Maloy (3):
  tipc: eliminate redundant fields in struct tipc_sock
  tipc: refactor function tipc_sk_anc_data_recv()
  tipc: simplify handling of lookup scope during multicast message
    reception

 net/tipc/name_table.c |   6 +-
 net/tipc/name_table.h |   4 +-
 net/tipc/socket.c     | 156 +++++++++++++++++++-----------------------
 3 files changed, 77 insertions(+), 89 deletions(-)

-- 
2.31.1

