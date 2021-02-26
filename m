Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 54ECE326929
	for <lists+netdev@lfdr.de>; Fri, 26 Feb 2021 22:08:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230163AbhBZVIR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Feb 2021 16:08:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229990AbhBZVIO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Feb 2021 16:08:14 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C2D4C061756;
        Fri, 26 Feb 2021 13:07:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=7pgftJoNP5KTdbInm9s0p3yXUSHbaaNN6wUdMbqk36Q=; b=iiQ3KmXmdmtEz3zoxoZjCfxwfG
        jdd70ti+Bkd01AvEbuYEA93mZ5RxbcslWYlslLagJqUxLmTq+FY3f5Dx749FY5vIS0nlDP1hmce1V
        etaW4F0Qal/ZfdjqmAUKMzfF8mP3WKiH8C+gUzC0iGL2xb5PQT6vwGcnobN5nsC6VYTEf8jDCw3dj
        cCu9tOQwgTyuQf1oUE0XGJYPpyiU2taOff/CHWOi1cIuMkEOsfIVl38BoqmLKlw65QR+mYD9LrKDY
        wuBaYI2/HVpH3vgLMnUiWS31zzPWnFQBqMLDzOwbQKSYP3MclasDj9rSUtJvyQYrg2oNaOfZ7/rxe
        /S1kQXEQ==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by casper.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1lFkKI-00CVhR-Ph; Fri, 26 Feb 2021 21:07:08 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 2D6843006D0;
        Fri, 26 Feb 2021 22:07:04 +0100 (CET)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 1BDE720616380; Fri, 26 Feb 2021 22:07:04 +0100 (CET)
Date:   Fri, 26 Feb 2021 22:07:04 +0100
From:   Peter Zijlstra <peterz@infradead.org>
To:     Shuah Khan <skhan@linuxfoundation.org>
Cc:     mingo@redhat.com, will@kernel.org, kvalo@codeaurora.org,
        davem@davemloft.net, kuba@kernel.org, ath10k@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/3] lockdep: add lockdep_assert_not_held()
Message-ID: <YDli+H48Ft3F6k9/@hirez.programming.kicks-ass.net>
References: <cover.1614355914.git.skhan@linuxfoundation.org>
 <a40d18bba5a52662ac8fc556e1fce3752ea08472.1614355914.git.skhan@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a40d18bba5a52662ac8fc556e1fce3752ea08472.1614355914.git.skhan@linuxfoundation.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 26, 2021 at 10:52:13AM -0700, Shuah Khan wrote:
> +		/* avoid false negative lockdep_assert_not_held()
> +		 * and lockdep_assert_held()
> +		 */

That's a coding style fail.
