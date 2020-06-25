Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 56D3A209DEE
	for <lists+netdev@lfdr.de>; Thu, 25 Jun 2020 13:55:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404667AbgFYLzX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Jun 2020 07:55:23 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:57975 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2404646AbgFYLzO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Jun 2020 07:55:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1593086113;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=oS+tjJRTXWkIBJiF60BGiX9Deix+p/MPPW7LrDM4LQg=;
        b=O38EpymfpLv7ScNU6vfp3wvsRk2hHC4rBOM6+haqfQzImVkz/cHiY5qzN2xLngpmSrbQMj
        /0EKCxxnqNEVWYABJOsMUB4y1GWSTuJCV/sKo8WOqpssjW+hgsYt12GmAkINiF9bwuRDyB
        tkeKzmpjJC8wzbNzbrkNOCW+RcPjlTY=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-195-sRlSKAgANMGizqvipY8FCw-1; Thu, 25 Jun 2020 07:55:11 -0400
X-MC-Unique: sRlSKAgANMGizqvipY8FCw-1
Received: by mail-wm1-f70.google.com with SMTP id a21so6639392wmd.0
        for <netdev@vger.kernel.org>; Thu, 25 Jun 2020 04:55:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=oS+tjJRTXWkIBJiF60BGiX9Deix+p/MPPW7LrDM4LQg=;
        b=UyjuKcYgb2kv+gpqJeh9RifBogwxkXx33DRAXL/iM23HAI3tpM56GwxKedN1OYHdqU
         krGxRO70emjIP8p8ZK3WnXMj6G6RcyRU/xs9XdTKKFVpRAZ3psbREDo6dshD26K4Ka4q
         wMNn151m6+HG3WaH98RDGj1VJTFHvhqEx9huoF3Ej0Z7bdMcJZ/OUcgyg+DnhnOop8X0
         7armvVCplnzPYWO1fwsQuXVFsWnl0qDSqdmlumSM5y3DXd6X7hY+Hte/1J103+R+oDaR
         NRylsG1mWA45t4/+AkC6u15L5RzZj16j/Uuan39x30MMr0oEb292JIuZCjf4Crkr5q6z
         eaMg==
X-Gm-Message-State: AOAM531OT6iNajloGJDrkfjvbr4DfP/lNwo7ByQSDZww05DpihmafvvT
        nbQxlA9gWKJAUytCp8uMkgPZRGCIvRATwDAyKQ+l3xdOqxbmnF3ILfg1ASkhyF90bMyrypZPFDD
        x6R8g/yKdtpm9j0+G
X-Received: by 2002:adf:a507:: with SMTP id i7mr39280026wrb.0.1593086110799;
        Thu, 25 Jun 2020 04:55:10 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwjqfJVd3WkZS8rf/Eu0Ta02+8zhyOKxM75IA3tL9xrh0OYYczzH8cn3T+qkjTjJplc9T9E0g==
X-Received: by 2002:adf:a507:: with SMTP id i7mr39280013wrb.0.1593086110634;
        Thu, 25 Jun 2020 04:55:10 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id v20sm31975789wrb.51.2020.06.25.04.55.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Jun 2020 04:55:09 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 5729F1814F9; Thu, 25 Jun 2020 13:55:08 +0200 (CEST)
Subject: [PATCH net-next 5/5] sch_cake: fix a few style nits
From:   =?utf-8?q?Toke_H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     David Miller <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, cake@lists.bufferbloat.net
Date:   Thu, 25 Jun 2020 13:55:08 +0200
Message-ID: <159308610826.190211.15296927891260930838.stgit@toke.dk>
In-Reply-To: <159308610282.190211.9431406149182757758.stgit@toke.dk>
References: <159308610282.190211.9431406149182757758.stgit@toke.dk>
User-Agent: StGit/0.23
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Toke Høiland-Jørgensen <toke@redhat.com>

I spotted a few nits when comparing the in-tree version of sch_cake with
the out-of-tree one: A redundant error variable declaration shadowing an
outer declaration, and an indentation alignment issue. Fix both of these to
minimise the delta.

Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
---
 net/sched/sch_cake.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/sched/sch_cake.c b/net/sched/sch_cake.c
index 78a702a4e1d4..e075913b2fd7 100644
--- a/net/sched/sch_cake.c
+++ b/net/sched/sch_cake.c
@@ -2761,7 +2761,7 @@ static int cake_init(struct Qdisc *sch, struct nlattr *opt,
 	qdisc_watchdog_init(&q->watchdog, sch);
 
 	if (opt) {
-		int err = cake_change(sch, opt, extack);
+		err = cake_change(sch, opt, extack);
 
 		if (err)
 			return err;
@@ -3078,7 +3078,7 @@ static int cake_dump_class_stats(struct Qdisc *sch, unsigned long cl,
 			PUT_STAT_S32(BLUE_TIMER_US,
 				     ktime_to_us(
 					     ktime_sub(now,
-						     flow->cvars.blue_timer)));
+						       flow->cvars.blue_timer)));
 		}
 		if (flow->cvars.dropping) {
 			PUT_STAT_S32(DROP_NEXT_US,

