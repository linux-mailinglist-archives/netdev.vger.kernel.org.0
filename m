Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 47A1459883B
	for <lists+netdev@lfdr.de>; Thu, 18 Aug 2022 18:03:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343946AbiHRQCG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Aug 2022 12:02:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343724AbiHRQCF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Aug 2022 12:02:05 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13E51B729D;
        Thu, 18 Aug 2022 09:02:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C878DB82039;
        Thu, 18 Aug 2022 16:02:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45C4DC433B5;
        Thu, 18 Aug 2022 16:02:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660838521;
        bh=Onle2nqvm63/z3wm2S20JSfsSTOA56NuPFbDOZP40XU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=lMq1IuHpQwKOe9smhUrLsaoXC97woCYJa6xRK6RR3cR+wsTXvZR/co6ky+QBdXere
         driF4SpKA/eUPk9ohxlUglLSP+j6AM0vozzd4byDPVXIdi0TcJHohaw62rB2hO0+qb
         u5KjfFZrBAB4dYqzWVjzP4ht6i1Lr1y6VnOvEpHr5pzDBOeNx9+GCSiKx7qjXc/cba
         kpZ7MVrMONl1MaGojgJIcyGVq0xtyqngFTyTWa8eqhIxHFQn0Y+IDKVE1fFraTui8s
         yLaljBohi5mQxOY0/0hLgMDfI5Ot8qkkoiwZhIfdPfmG38L/knY380FJc1tuJR7f+Q
         /byuiMollRMPg==
Date:   Thu, 18 Aug 2022 09:02:00 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc:     linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Matthew Wilcox <willy@infradead.org>, netdev@vger.kernel.org
Subject: Re: [PATCH 9/9] u64_stat: Remove the obsolete fetch_irq() variants
Message-ID: <20220818090200.4c6889f2@kernel.org>
In-Reply-To: <Yv5aSquR9S2KxUr2@linutronix.de>
References: <20220817162703.728679-1-bigeasy@linutronix.de>
        <20220817162703.728679-10-bigeasy@linutronix.de>
        <20220817112745.4efd8217@kernel.org>
        <Yv5aSquR9S2KxUr2@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 18 Aug 2022 17:27:06 +0200 Sebastian Andrzej Siewior wrote:
> On 2022-08-17 11:27:45 [-0700], Jakub Kicinski wrote:
> > What's the thinking on merging? 8 and 9 will get reposted separately 
> > for net-next once the discussions are over?  
> 
> It depends on 2/9. So either it gets routed via -tip with your blessing
> or a feature branch containing 2/9 on top of -rc1 so you can pull that
> change and apply 8+9.
> Just say what works best for you and I let tglx know ;)

Heh, I saw a message from Greg politely and informatively explaining 
to someone how they have to structure their refactoring to avoid
conflicts in linux-next. I should have saved it cause my oratorical
skills are weak.

No ack, I'd much rather you waited for after the next merge window 
and queued this refactoring to net-next. Patch 9 is changing 70
files in networking. Unless I'm missing something and this is time
sensitive.
