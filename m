Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA9293D38DD
	for <lists+netdev@lfdr.de>; Fri, 23 Jul 2021 12:38:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232141AbhGWJ6A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Jul 2021 05:58:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:49926 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232001AbhGWJ56 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 23 Jul 2021 05:57:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C864D60EE6;
        Fri, 23 Jul 2021 10:38:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627036712;
        bh=tBUdeu52dSGAjDk/xY6fNmZKu9Ai7BBxRSfuL8mBkHs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Rge5e5zdUbmhH8MnTpq7iquBA+RJUJVqycL+V34aQdfhG4Q5Vd/a5igxEiEfDguQy
         jJxvNe7HY4bGIHw7gaZm3HifJ0e/eNGBomQEwJgvTntMNrvC1Ij/aiUJYJ3j7x6bxU
         o4ktjRuCmbCi0y5tosDzHA8W4TN41KL9KEhqOkYc=
Date:   Fri, 23 Jul 2021 12:38:27 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Luis Chamberlain <mcgrof@kernel.org>
Cc:     Shuah Khan <skhan@linuxfoundation.org>, tj@kernel.org,
        shuah@kernel.org, akpm@linux-foundation.org, rafael@kernel.org,
        davem@davemloft.net, kuba@kernel.org, ast@kernel.org,
        andriin@fb.com, daniel@iogearbox.net, atenart@kernel.org,
        alobakin@pm.me, weiwan@google.com, ap420073@gmail.com,
        jeyu@kernel.org, ngupta@vflare.org,
        sergey.senozhatsky.work@gmail.com, minchan@kernel.org,
        axboe@kernel.dk, mbenes@suse.com, jpoimboe@redhat.com,
        tglx@linutronix.de, keescook@chromium.org, jikos@kernel.org,
        rostedt@goodmis.org, peterz@infradead.org,
        linux-block@vger.kernel.org, netdev@vger.kernel.org,
        linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/4] selftests: add tests_sysfs module
Message-ID: <YPqcIzKpEXftpZM8@kroah.com>
References: <20210703004632.621662-1-mcgrof@kernel.org>
 <20210703004632.621662-2-mcgrof@kernel.org>
 <YPgF2VAoxPIiKWX1@kroah.com>
 <20210722223449.ot5272wpc6o5uzlk@garbanzo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210722223449.ot5272wpc6o5uzlk@garbanzo>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 22, 2021 at 03:34:49PM -0700, Luis Chamberlain wrote:
> kunit relies on UML and UML is a simple one core architecture, to start
> with.

I thought the UML requirement was long gone, are you sure it is still
present?

> This means I cannot run tests for multicore with it, which is
> where many races do happen! Yes, you can run kunit on other
> architectures, but all that is new.

What do you mean by "new"?  It should work today, in today's kernel
tree, right?

> In this case kunit is not ideal given I want to mimic something in
> userspace interaction, and expose races through error injection and
> if we can use as many cores to busy races out.

Can you not do that with kunit?  If not, why not?

thanks,

greg k-h
