Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BAB1542523A
	for <lists+netdev@lfdr.de>; Thu,  7 Oct 2021 13:44:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241114AbhJGLqr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Oct 2021 07:46:47 -0400
Received: from mga09.intel.com ([134.134.136.24]:65334 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230091AbhJGLqo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 7 Oct 2021 07:46:44 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10129"; a="226127319"
X-IronPort-AV: E=Sophos;i="5.85,354,1624345200"; 
   d="scan'208";a="226127319"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Oct 2021 04:44:50 -0700
X-IronPort-AV: E=Sophos;i="5.85,354,1624345200"; 
   d="scan'208";a="522572633"
Received: from smile.fi.intel.com (HELO smile) ([10.237.68.40])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Oct 2021 04:44:45 -0700
Received: from andy by smile with local (Exim 4.95)
        (envelope-from <andriy.shevchenko@linux.intel.com>)
        id 1mYRpJ-009VuO-7q;
        Thu, 07 Oct 2021 14:44:41 +0300
Date:   Thu, 7 Oct 2021 14:44:41 +0300
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>
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
Message-ID: <YV7dqcCbxaeBcELY@smile.fi.intel.com>
References: <20211007095129.22037-1-andriy.shevchenko@linux.intel.com>
 <20211007095129.22037-4-andriy.shevchenko@linux.intel.com>
 <20211007112328.GA19281@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211007112328.GA19281@gondor.apana.org.au>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 07, 2021 at 07:23:28PM +0800, Herbert Xu wrote:
> On Thu, Oct 07, 2021 at 12:51:28PM +0300, Andy Shevchenko wrote:
> > When kernel.h is used in the headers it adds a lot into dependency hell,
> > especially when there are circular dependencies are involved.

> > Replace kernel.h inclusion with the list of what is really being used.

> Nack.  I can see the benefits of splitting things out of kernel.h
> but there is no reason to add crap to end users like rhashtable.c.

Crap is in the kernel.h. Could you elaborate how making a proper list
of the inclusions is a crap?

-- 
With Best Regards,
Andy Shevchenko


