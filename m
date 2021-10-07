Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 47B3D425735
	for <lists+netdev@lfdr.de>; Thu,  7 Oct 2021 17:55:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242158AbhJGP5S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Oct 2021 11:57:18 -0400
Received: from mga11.intel.com ([192.55.52.93]:60499 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240504AbhJGP5Q (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 7 Oct 2021 11:57:16 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10130"; a="223685476"
X-IronPort-AV: E=Sophos;i="5.85,355,1624345200"; 
   d="scan'208";a="223685476"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Oct 2021 08:55:22 -0700
X-IronPort-AV: E=Sophos;i="5.85,355,1624345200"; 
   d="scan'208";a="484563268"
Received: from smile.fi.intel.com (HELO smile) ([10.237.68.40])
  by fmsmga007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Oct 2021 08:55:14 -0700
Received: from andy by smile with local (Exim 4.95)
        (envelope-from <andriy.shevchenko@linux.intel.com>)
        id 1mYVji-009aKV-9f;
        Thu, 07 Oct 2021 18:55:10 +0300
Date:   Thu, 7 Oct 2021 18:55:10 +0300
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Brendan Higgins <brendanhiggins@google.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Miguel Ojeda <ojeda@kernel.org>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>, kunit-dev@googlegroups.com,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Ingo Molnar <mingo@redhat.com>, Will Deacon <will@kernel.org>,
        Waiman Long <longman@redhat.com>,
        Boqun Feng <boqun.feng@gmail.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, Thomas Graf <tgraf@suug.ch>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jonathan Cameron <jic23@kernel.org>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>
Subject: Re: [PATCH v1 3/3] kernel.h: Split out container_of() and
 typeof_memeber() macros
Message-ID: <YV8YXlVMAvY4iIC3@smile.fi.intel.com>
References: <20210713084541.7958-1-andriy.shevchenko@linux.intel.com>
 <20210713084541.7958-3-andriy.shevchenko@linux.intel.com>
 <YO1s+rHEqC9RjMva@kroah.com>
 <YO12ARa3i1TprGnJ@smile.fi.intel.com>
 <YO13lSUdPfNGOnC3@kroah.com>
 <CANiq72=vs8-88h3Z+BON=qA4CZQ1pS1nggnCFHDEHYyG+Y+3JQ@mail.gmail.com>
 <YV67+vrn3MxpXABy@smile.fi.intel.com>
 <CANiq72nKya4OW0Eof=7PP-U78uo+j8DL0UUDNsW3ww_5PPJVtA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANiq72nKya4OW0Eof=7PP-U78uo+j8DL0UUDNsW3ww_5PPJVtA@mail.gmail.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 07, 2021 at 05:39:56PM +0200, Miguel Ojeda wrote:
> On Thu, Oct 7, 2021 at 11:21 AM Andy Shevchenko
> <andriy.shevchenko@linux.intel.com> wrote:
> >
> > It does almost 2% (steady) speedup. I will send a v2 with methodology
> > and numbers of testing.
> 
> Thanks for taking the time to get the numbers!

There is a v4 out, you are among others in Cc list.

-- 
With Best Regards,
Andy Shevchenko


