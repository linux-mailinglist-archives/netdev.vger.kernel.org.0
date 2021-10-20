Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA46B434692
	for <lists+netdev@lfdr.de>; Wed, 20 Oct 2021 10:11:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229833AbhJTIOC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Oct 2021 04:14:02 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:51208 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229836AbhJTIOB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Oct 2021 04:14:01 -0400
Date:   Wed, 20 Oct 2021 10:11:43 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1634717505;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=LvZIA+OycCpC6dus/oTDkuHhEgmqJ9W28ECHgsBnQ1U=;
        b=eXudXR1acas4NkuNVOlRarOF4PmTmsKM0FP9TeZwd/UvxVtAWJjhqd5hFF9ycEeEDWiNNv
        QgW/REYruLMIMxdwCrA/6Ri1l1Z7RxRMEaaemezKj2St2Ia9DM9ZcI7VSFsNyqQcrB8rRp
        4cj1tcSjnV7bBvCQrw3iwonaZMErUVQc/le4AsH+iOSx0FNLaaAy76hmQoU/q2oVW4O7Ut
        xnLlSTzbmLUdgHXb/SudL6DpVG7JWRdhGnkHIvtn1HyUeAU2kZvq7+C51zT4Yh7cBEjyie
        Hupcb2B1Rt7NfHQjtS37Y43xcZg9dSbgw82eW14XQoxRStSraxUlGx91w0EEyQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1634717505;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=LvZIA+OycCpC6dus/oTDkuHhEgmqJ9W28ECHgsBnQ1U=;
        b=3Uq9yCbtiVZiuY29ArPKtAGJMUA1ENMskNKe1yLuUvEuQBw2qxOkwbIldREeSatkhSaN3s
        Bl1+0SLpQNIveGBg==
From:   Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To:     Vlad Buslov <vladbu@nvidia.com>
Cc:     "Ahmed S . Darwish" <a.darwish@linutronix.de>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>
Subject: Re: [PATCH net-next 1/2] net: sched: fix logic error in
 qdisc_run_begin()
Message-ID: <20211020081143.2xu3n6qjqh4zloa4@linutronix.de>
References: <20211019003402.2110017-1-eric.dumazet@gmail.com>
 <20211019003402.2110017-2-eric.dumazet@gmail.com>
 <ygnhzgr49mmy.fsf@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <ygnhzgr49mmy.fsf@nvidia.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021-10-20 10:32:53 [+0300], Vlad Buslov wrote:
> We've got a warning[0] in today's regression that was added by commit that
> this patch fixes. I can't reproduce it manually and from changelog it is
> hard to determine whether the fix is for the issue we experiencing or
> something else. WDYT?

The backtrace looks like it has been fixed by
   https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git/commit/?id=e22db7bd552f7f7f19fe4ef60abfb7e7b364e3a8

Sorry for that.

Sebastian
