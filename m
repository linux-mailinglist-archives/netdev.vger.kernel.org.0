Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C913426267
	for <lists+netdev@lfdr.de>; Fri,  8 Oct 2021 04:18:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235635AbhJHCUf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Oct 2021 22:20:35 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:55904 "EHLO deadmen.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233656AbhJHCUe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 7 Oct 2021 22:20:34 -0400
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtp (Exim 4.92 #5 (Debian))
        id 1mYfT0-0002Vk-4Y; Fri, 08 Oct 2021 10:18:34 +0800
Received: from herbert by gondobar with local (Exim 4.92)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1mYfSr-0006Zi-Mn; Fri, 08 Oct 2021 10:18:25 +0800
Date:   Fri, 8 Oct 2021 10:18:25 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Randy Dunlap <rdunlap@infradead.org>,
        linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
        kunit-dev@googlegroups.com, linux-media@vger.kernel.org,
        netdev@vger.kernel.org,
        Brendan Higgins <brendanhiggins@google.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Ingo Molnar <mingo@redhat.com>, Will Deacon <will@kernel.org>,
        Waiman Long <longman@redhat.com>,
        Boqun Feng <boqun.feng@gmail.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Thomas Graf <tgraf@suug.ch>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v2 3/4] lib/rhashtable: Replace kernel.h with the
 necessary inclusions
Message-ID: <20211008021825.GA25242@gondor.apana.org.au>
References: <20211007095129.22037-1-andriy.shevchenko@linux.intel.com>
 <20211007095129.22037-4-andriy.shevchenko@linux.intel.com>
 <20211007112328.GA19281@gondor.apana.org.au>
 <YV7dqcCbxaeBcELY@smile.fi.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YV7dqcCbxaeBcELY@smile.fi.intel.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 07, 2021 at 02:44:41PM +0300, Andy Shevchenko wrote:
>
> Crap is in the kernel.h. Could you elaborate how making a proper list
> of the inclusions is a crap?

Unless you're planning on not including all those header files from
kernel.h, then adding them all to an end node like rhashtable.c is
just a waste of time.

You should be targetting other header files and not c files.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
