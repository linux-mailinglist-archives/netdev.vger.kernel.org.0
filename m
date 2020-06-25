Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 38D5520A66B
	for <lists+netdev@lfdr.de>; Thu, 25 Jun 2020 22:12:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390959AbgFYUMW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Jun 2020 16:12:22 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:54994 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2390587AbgFYUMR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Jun 2020 16:12:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1593115936;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=epUbAMlVxZu5S6QNhQY9u/K2VMd6EIBVfXGl2Kn/Ahc=;
        b=Cx3Xd0gsBAwp+mjQ9FtDJjlJMg2zWWY5fQSNezDbKrJX2cy21029hp5MK1xCfrT8hqXBuN
        k2V7qV293P6z7gpbvhqgpM8kgsJ8cl/Hyqd0wQcKFEplf3tYS9IjGPFlIvGnlRetT3hb0e
        Fq3etrAFdIB8Vf9ivbFKNAmOQ+yF/1A=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-289-GQA3KwXMMByg1YFb3jfgUA-1; Thu, 25 Jun 2020 16:12:12 -0400
X-MC-Unique: GQA3KwXMMByg1YFb3jfgUA-1
Received: by mail-ej1-f70.google.com with SMTP id lg24so5721230ejb.11
        for <netdev@vger.kernel.org>; Thu, 25 Jun 2020 13:12:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=epUbAMlVxZu5S6QNhQY9u/K2VMd6EIBVfXGl2Kn/Ahc=;
        b=Gor5aUILtBwg5KOGoArIYalTQYXCPnGswWJvgn1RTgqNVjtL4DAlS6V0DnOKJSV7ZG
         ZBjpld/DfvvQARnlTaOevzdh11IQGO6X8PaSFG29v6TQiLkUx/rGhdzFJaR/4FNa9vPL
         k+tnl1pXSuWHgwUrqX+r1gaZ9b3hbIXrZg07/izlNdmVYM/qgj3OynItan0B2AJ2+9/t
         TduL3A8kznLuYgacgSHZ34NfR7lanEIvghOj9u7pA2qPbNDf3jy5GfiRo1D8vHaSiQul
         R2R+ZSZ2Bhghg2xWA7nzM5wpreY1xFd7k06m+YlcsvYmMkKCAbHq9ib56DLbTM2Nh79W
         pdoA==
X-Gm-Message-State: AOAM530EdZxQK5gcEpMdOzqQQskf2r5j8Tmv1vVxBsm4HKgNfEiEcY3F
        sIulnS5DkX99VRYrXN5GLDaGt3MQttMZG5vV6D0uJtyqWbzPHshdlDAgpuAgJ56usqE4BAqunBy
        loFhyo8EDTYM37MbZ
X-Received: by 2002:a05:6402:b4b:: with SMTP id bx11mr8584692edb.286.1593115931416;
        Thu, 25 Jun 2020 13:12:11 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJy21WLj5k8KlY5WJysNtXwMo9tGZQb/0mudpfAo6UiV7lbH1mtRWTn9rLRAHpS5XmsTnEtPaQ==
X-Received: by 2002:a05:6402:b4b:: with SMTP id bx11mr8584678edb.286.1593115931254;
        Thu, 25 Jun 2020 13:12:11 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id p13sm18876978edq.50.2020.06.25.13.12.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Jun 2020 13:12:09 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 6796D1814FA; Thu, 25 Jun 2020 22:12:09 +0200 (CEST)
Subject: [PATCH net 3/3] sch_cake: fix a few style nits
From:   =?utf-8?q?Toke_H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     David Miller <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, cake@lists.bufferbloat.net
Date:   Thu, 25 Jun 2020 22:12:09 +0200
Message-ID: <159311592933.207748.4033228977231895526.stgit@toke.dk>
In-Reply-To: <159311592607.207748.5904268231642411759.stgit@toke.dk>
References: <159311592607.207748.5904268231642411759.stgit@toke.dk>
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
outer declaration, and an indentation alignment issue. Fix both of these.

Fixes: 046f6fd5daef ("sched: Add Common Applications Kept Enhanced (cake) qdisc")
Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
---
 net/sched/sch_cake.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/sched/sch_cake.c b/net/sched/sch_cake.c
index 094d6e652deb..ca813697728e 100644
--- a/net/sched/sch_cake.c
+++ b/net/sched/sch_cake.c
@@ -2715,7 +2715,7 @@ static int cake_init(struct Qdisc *sch, struct nlattr *opt,
 	qdisc_watchdog_init(&q->watchdog, sch);
 
 	if (opt) {
-		int err = cake_change(sch, opt, extack);
+		err = cake_change(sch, opt, extack);
 
 		if (err)
 			return err;
@@ -3032,7 +3032,7 @@ static int cake_dump_class_stats(struct Qdisc *sch, unsigned long cl,
 			PUT_STAT_S32(BLUE_TIMER_US,
 				     ktime_to_us(
 					     ktime_sub(now,
-						     flow->cvars.blue_timer)));
+						       flow->cvars.blue_timer)));
 		}
 		if (flow->cvars.dropping) {
 			PUT_STAT_S32(DROP_NEXT_US,

