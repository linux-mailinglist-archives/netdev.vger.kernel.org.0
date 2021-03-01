Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E43C32796E
	for <lists+netdev@lfdr.de>; Mon,  1 Mar 2021 09:41:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233291AbhCAIkP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Mar 2021 03:40:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233320AbhCAIjf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Mar 2021 03:39:35 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F38E2C06174A;
        Mon,  1 Mar 2021 00:38:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=sX04iQ+W/jdAFUfzECen1rbHlQQujm/m2fcunYtptNQ=; b=ZYYzApmDSrC3A3mJrNEFnMMTYl
        Owuvu468Iuob1Pq9iJPfzUjQBKXokwT+Z+rAcEYcI0NNzi05Bg8UDaBAea38MJMFbmvyOOpLc0CgJ
        2jswcasOIJ64Siu4srdOZA/FyydukB0bkxkBxKF76ZvwoXfog/DVhV+omLsVVa4a6POR6luiRAqps
        y6i+bhXOKa2495dMEX+J/vobKhmrGSmeUwp68RhYCFT0ehH7e9VPF3J51C5BOwM7eI5cXLK2BvdSO
        sJNHqNjDk0B6BgfVye0j5QK22pqMrOfd/xN9yAioufjtRf++r3/NwW4dc0khHx3yLeVq5uxUkKWH2
        +J3y1jCQ==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by casper.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1lGe4K-00FUD5-V9; Mon, 01 Mar 2021 08:38:27 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 18F4D3049DC;
        Mon,  1 Mar 2021 09:38:20 +0100 (CET)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id ED854201A7CFC; Mon,  1 Mar 2021 09:38:19 +0100 (CET)
Date:   Mon, 1 Mar 2021 09:38:19 +0100
From:   Peter Zijlstra <peterz@infradead.org>
To:     Shuah Khan <skhan@linuxfoundation.org>
Cc:     mingo@redhat.com, will@kernel.org, kvalo@codeaurora.org,
        davem@davemloft.net, kuba@kernel.org, ath10k@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 0/3] Add lockdep_assert_not_held()
Message-ID: <YDyn+6N6EfgWJ5GV@hirez.programming.kicks-ass.net>
References: <cover.1614383025.git.skhan@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1614383025.git.skhan@linuxfoundation.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 26, 2021 at 05:06:57PM -0700, Shuah Khan wrote:
> Shuah Khan (3):
>   lockdep: add lockdep_assert_not_held()
>   lockdep: add lockdep lock state defines
>   ath10k: detect conf_mutex held ath10k_drain_tx() calls

Thanks!
