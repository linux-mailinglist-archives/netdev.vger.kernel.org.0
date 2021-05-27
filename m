Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C94D393076
	for <lists+netdev@lfdr.de>; Thu, 27 May 2021 16:10:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236318AbhE0OME (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 May 2021 10:12:04 -0400
Received: from mx2.suse.de ([195.135.220.15]:40682 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234913AbhE0OMA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 27 May 2021 10:12:00 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1622124626; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=MQ+arKPNxzST7ab2H3QoxDvfWeE34QJ5lFr2r3wbfcs=;
        b=nWzTxUB5rSV4EUp8QkGcMcmKLCujFX935Zur6Osu6oyTnMThJ/aPu+MH48yb8unoD341zv
        nVCeubF0QAZAMwHUaraDqNyPVQNikXyS9bMi8DO7fW51RqAvl8jfnAmfx80S80CPu39VdE
        FMt9vrfhc5ybpee+TcZuthndh2hgrlQ=
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 02B7CAAFD;
        Thu, 27 May 2021 14:10:26 +0000 (UTC)
Date:   Thu, 27 May 2021 16:10:23 +0200
From:   Petr Mladek <pmladek@suse.com>
To:     Richard Fitzgerald <rf@opensource.cirrus.com>
Cc:     rostedt@goodmis.org, sergey.senozhatsky@gmail.com,
        andriy.shevchenko@linux.intel.com, linux@rasmusvillemoes.dk,
        w@1wt.eu, lkml@sdf.org, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        patches@opensource.cirrus.com
Subject: Re: [PATCH 0/2] Fix truncation warnings from building test_scanf.c
Message-ID: <YK+oT02rkFOujT3C@alley>
References: <20210524155941.16376-1-rf@opensource.cirrus.com>
 <YKzBbB/QIJrgPrmq@alley>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YKzBbB/QIJrgPrmq@alley>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue 2021-05-25 11:20:45, Petr Mladek wrote:
> On Mon 2021-05-24 16:59:39, Richard Fitzgerald wrote:
> > The kernel test robot is reporting truncation warnings when building
> > lib/test_scanf.c:
> > 
> > Richard Fitzgerald (2):
> >   lib: test_scanf: Fix incorrect use of type_min() with unsigned types
> >   random32: Fix implicit truncation warning in prandom_seed_state()
> > 
> >  include/linux/prandom.h |  2 +-
> >  lib/test_scanf.c        | 13 ++++++-------
> >  2 files changed, 7 insertions(+), 8 deletions(-)
> 
> For both patches:
> 
> Reviewed-by: Petr Mladek <pmladek@suse.com>
> 
> I am going to commit them within next two days or so unless anyone
> complains in the meantime.

JFYI, both patches have been committed into  printk/linux.git,
branch for-5.14-vsprintf-scanf.

Best Regards,
Petr
