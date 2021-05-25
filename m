Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1BE6F38FDA4
	for <lists+netdev@lfdr.de>; Tue, 25 May 2021 11:20:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232514AbhEYJWS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 May 2021 05:22:18 -0400
Received: from mx2.suse.de ([195.135.220.15]:47630 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232495AbhEYJWP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 25 May 2021 05:22:15 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1621934445; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=rFZSsJn7jactPkFlH+d1ksuK7gF4+2XFJXlcpC9J1vw=;
        b=U7runddJqVJiSmGLcy6Q76zr+6SdsjeNX+b/kknB40W5GMgseoRsqxA3eFnbwsfCnehNiJ
        qSOoq81Xn6xNZCZNq+UO7mHmTb5/UluoCPeTXb49n7RmwLvFxmOUd7famwW2/buHT2Owdw
        gAiQR7hRe3w5EcM6QF4n1y61VI4Vz6s=
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 81887AE1F;
        Tue, 25 May 2021 09:20:45 +0000 (UTC)
Date:   Tue, 25 May 2021 11:20:44 +0200
From:   Petr Mladek <pmladek@suse.com>
To:     Richard Fitzgerald <rf@opensource.cirrus.com>
Cc:     rostedt@goodmis.org, sergey.senozhatsky@gmail.com,
        andriy.shevchenko@linux.intel.com, linux@rasmusvillemoes.dk,
        w@1wt.eu, lkml@sdf.org, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        patches@opensource.cirrus.com
Subject: Re: [PATCH 0/2] Fix truncation warnings from building test_scanf.c
Message-ID: <YKzBbB/QIJrgPrmq@alley>
References: <20210524155941.16376-1-rf@opensource.cirrus.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210524155941.16376-1-rf@opensource.cirrus.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon 2021-05-24 16:59:39, Richard Fitzgerald wrote:
> The kernel test robot is reporting truncation warnings when building
> lib/test_scanf.c:
> 
> Richard Fitzgerald (2):
>   lib: test_scanf: Fix incorrect use of type_min() with unsigned types
>   random32: Fix implicit truncation warning in prandom_seed_state()
> 
>  include/linux/prandom.h |  2 +-
>  lib/test_scanf.c        | 13 ++++++-------
>  2 files changed, 7 insertions(+), 8 deletions(-)

For both patches:

Reviewed-by: Petr Mladek <pmladek@suse.com>

I am going to commit them within next two days or so unless anyone
complains in the meantime.

Thanks a lot for fixing it.

Best Regards,
Petr
