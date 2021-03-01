Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D8F63327937
	for <lists+netdev@lfdr.de>; Mon,  1 Mar 2021 09:30:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232271AbhCAI3L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Mar 2021 03:29:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232898AbhCAI3B (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Mar 2021 03:29:01 -0500
Received: from merlin.infradead.org (merlin.infradead.org [IPv6:2001:8b0:10b:1231::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD7BFC06174A;
        Mon,  1 Mar 2021 00:28:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=SLHlTyr7J4bDHB68FVUYkSlUgSwJhgwwD2i9uVB39uY=; b=uVn9nYvH4/M/8OLvG8WZEVQfCq
        hBlKT6zXgY5YuhHzZxPgXGbisSXRCSaQWTTJN+dcVKLbhdt2dcascK+Es+bZuplCOAR6XYv3/HM4G
        nzdBWK57VLtTZ+BT3ZNLFNghOxviSosPsXMZrN6Zkj2ZQOnlxZWNtgoCdAP2Yn7PlE+CL8f3co4Id
        cd/6wC5Dujkq0m1aDBCVt+KVIBO9eBfGw3i9sXXm4sHlCgqGgbKsshfn+O81aAERgTMuJXcRfbeKF
        A+ZMau+w9bTvecM2jrIkxlxUL7lPBQCC54Shq83LaiagCZyPGgSUXxATnX0FHVKF8r18ZJiaFhOgQ
        15iTFYrg==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1lGduU-0006I4-HY; Mon, 01 Mar 2021 08:28:10 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id A0F6F301959;
        Mon,  1 Mar 2021 09:28:06 +0100 (CET)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 8785025F2CD01; Mon,  1 Mar 2021 09:28:06 +0100 (CET)
Date:   Mon, 1 Mar 2021 09:28:06 +0100
From:   Peter Zijlstra <peterz@infradead.org>
To:     Shuah Khan <skhan@linuxfoundation.org>
Cc:     mingo@redhat.com, will@kernel.org, kvalo@codeaurora.org,
        davem@davemloft.net, kuba@kernel.org, ath10k@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/3] lockdep: add lockdep_assert_not_held()
Message-ID: <YDyllv3zs+lWtgCV@hirez.programming.kicks-ass.net>
References: <cover.1614355914.git.skhan@linuxfoundation.org>
 <a40d18bba5a52662ac8fc556e1fce3752ea08472.1614355914.git.skhan@linuxfoundation.org>
 <YDli+H48Ft3F6k9/@hirez.programming.kicks-ass.net>
 <0ee409b7-b0d5-43c2-c247-b0482c392dea@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0ee409b7-b0d5-43c2-c247-b0482c392dea@linuxfoundation.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 26, 2021 at 02:16:12PM -0700, Shuah Khan wrote:
> On 2/26/21 2:07 PM, Peter Zijlstra wrote:
> > On Fri, Feb 26, 2021 at 10:52:13AM -0700, Shuah Khan wrote:
> > > +		/* avoid false negative lockdep_assert_not_held()
> > > +		 * and lockdep_assert_held()
> > > +		 */
> > 
> > That's a coding style fail.
> > 
> 
> Checkpatch didn't complain.

  Documentation/CodingStyle

(or whatever unreadable rst crap it is today :-( )

and:

  https://lkml.kernel.org/lkml/CA+55aFyQYJerovMsSoSKS7PessZBr4vNp-3QUUwhqk4A4_jcbg@mail.gmail.com/

> What's your preference? Does the following work for you?
> 
> /*
>  * avoid false negative lockdep_assert_not_held()
>  * and lockdep_assert_held()
>  */

Yep (ideally even with a Capital and full stop).
