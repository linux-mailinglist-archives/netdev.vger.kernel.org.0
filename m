Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 554C03B9227
	for <lists+netdev@lfdr.de>; Thu,  1 Jul 2021 15:19:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236700AbhGANTh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Jul 2021 09:19:37 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:48270 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236679AbhGANTa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Jul 2021 09:19:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1625145420;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=gguLsCFpzVwzGkxldhII1jrqh0b5Cj87XHgV11Kqlhw=;
        b=PFGi92bQ4JyDO8VEfaFk5haqfUqaD97I4m+hTLbLBQScCbMDjQ24z0dd46uxn/FPwUcDyd
        jHjC9qkyAcxPGxeRhv84DUAnLTs4Cgni9cAepqYrPNKHgh+y3GsMpqqA10GwpFUxU8lOKy
        +R+0rmfke0Hz8VTtAMZpVVpxGVjLhbg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-454-v8BzdXwmNUK8gIYUC2JDMg-1; Thu, 01 Jul 2021 09:16:59 -0400
X-MC-Unique: v8BzdXwmNUK8gIYUC2JDMg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 383CA1023F42
        for <netdev@vger.kernel.org>; Thu,  1 Jul 2021 13:16:58 +0000 (UTC)
Received: from firesoul.localdomain (unknown [10.40.208.52])
        by smtp.corp.redhat.com (Postfix) with ESMTP id EA73160C81;
        Thu,  1 Jul 2021 13:16:54 +0000 (UTC)
Received: from [192.168.42.3] (localhost [IPv6:::1])
        by firesoul.localdomain (Postfix) with ESMTP id 921AE30000DB9;
        Thu,  1 Jul 2021 15:16:53 +0200 (CEST)
Subject: [PATCH net-next] net/sched: sch_taprio: fix typo in comment
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     netdev@vger.kernel.org
Cc:     Jesper Dangaard Brouer <brouer@redhat.com>, dcaratti@redhat.com
Date:   Thu, 01 Jul 2021 15:16:53 +0200
Message-ID: <162514541350.782166.18361886167078327975.stgit@firesoul>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I have checked that the IEEE standard 802.1Q-2018 section 8.6.9.4.5
is called AdminGateStates.

Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
---
 net/sched/sch_taprio.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/sched/sch_taprio.c b/net/sched/sch_taprio.c
index 66fe2b82af9a..07b30d0601d7 100644
--- a/net/sched/sch_taprio.c
+++ b/net/sched/sch_taprio.c
@@ -564,7 +564,7 @@ static struct sk_buff *taprio_dequeue_soft(struct Qdisc *sch)
 	/* if there's no entry, it means that the schedule didn't
 	 * start yet, so force all gates to be open, this is in
 	 * accordance to IEEE 802.1Qbv-2015 Section 8.6.9.4.5
-	 * "AdminGateSates"
+	 * "AdminGateStates"
 	 */
 	gate_mask = entry ? entry->gate_mask : TAPRIO_ALL_GATES_OPEN;
 


