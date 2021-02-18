Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0263A31EF81
	for <lists+netdev@lfdr.de>; Thu, 18 Feb 2021 20:16:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234089AbhBRTPW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Feb 2021 14:15:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234955AbhBRSCT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Feb 2021 13:02:19 -0500
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0231C061574;
        Thu, 18 Feb 2021 10:01:33 -0800 (PST)
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.94)
        (envelope-from <johannes@sipsolutions.net>)
        id 1lCnb2-004n8X-1t; Thu, 18 Feb 2021 19:00:12 +0100
Message-ID: <e3d412224ec1ad73c8c4dbc42a17e8e481dc8982.camel@sipsolutions.net>
Subject: Re: [PATCH] kcov: Remove kcov include from sched.h and move it to
 its users.
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        linux-kernel@vger.kernel.org, kasan-dev@googlegroups.com
Cc:     Dmitry Vyukov <dvyukov@google.com>,
        Andrey Konovalov <andreyknvl@gmail.com>,
        Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Juri Lelli <juri.lelli@redhat.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>,
        Daniel Bristot de Oliveira <bristot@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Date:   Thu, 18 Feb 2021 19:00:02 +0100
In-Reply-To: <20210218173124.iy5iyqv3a4oia4vv@linutronix.de>
References: <20210218173124.iy5iyqv3a4oia4vv@linutronix.de>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-malware-bazaar: not-scanned
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 2021-02-18 at 18:31 +0100, Sebastian Andrzej Siewior wrote:
> The recent addition of in_serving_softirq() to kconv.h results in

You typo'ed "kconv.h" pretty consistently ;-)

But yes, that makes sense.

Acked-by: Johannes Berg <johannes@sipsolutions.net>

johannes


