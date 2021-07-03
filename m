Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C2543BA73F
	for <lists+netdev@lfdr.de>; Sat,  3 Jul 2021 06:46:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229893AbhGCEtX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 3 Jul 2021 00:49:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:42962 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229461AbhGCEtW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 3 Jul 2021 00:49:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DE87661405;
        Sat,  3 Jul 2021 04:46:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1625287608;
        bh=bdqIjdWS6ByoG+Rr4ADz7N1F9WKftDDWxQ52YTc5eNA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=hVZGm1mQn1KY3S7UU3o7OMw0ALThdr8gNKdtJax+HC9Xa0nOKSiJ5eoaAz7avoxIP
         Pqavy8lTQm0sC1SzHiVlKerBZbo+eQyW2rF5rXuPb+oRRnk1hMAXhU7lgB7mp8RjFy
         851PXQEnO0hBzWPkNq7zYv2RQWPUKrd1OPBCW8Nk=
Date:   Sat, 3 Jul 2021 06:46:46 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Luis Chamberlain <mcgrof@kernel.org>
Cc:     tj@kernel.org, shuah@kernel.org, akpm@linux-foundation.org,
        Richard Fontana <fontana@sharpeleven.org>, rafael@kernel.org,
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
Subject: Re: [PATCH 1/4] selftests: add tests_sysfs module
Message-ID: <YN/rtmZbd6velB1L@kroah.com>
References: <20210702050543.2693141-1-mcgrof@kernel.org>
 <20210702050543.2693141-2-mcgrof@kernel.org>
 <YN6iSKCetBrk2y8V@kroah.com>
 <20210702190230.r46bck4vib7u3qo6@garbanzo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210702190230.r46bck4vib7u3qo6@garbanzo>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 02, 2021 at 12:02:30PM -0700, Luis Chamberlain wrote:
> On Fri, Jul 02, 2021 at 07:21:12AM +0200, Greg KH wrote:
> > On Thu, Jul 01, 2021 at 10:05:40PM -0700, Luis Chamberlain wrote:
> > > @@ -0,0 +1,953 @@
> > > +// SPDX-License-Identifier: GPL-2.0-or-later
> > > +/*
> > > + * sysfs test driver
> > > + *
> > > + * Copyright (C) 2021 Luis Chamberlain <mcgrof@kernel.org>
> > > + *
> > > + * This program is free software; you can redistribute it and/or modify it
> > > + * under the terms of the GNU General Public License as published by the Free
> > > + * Software Foundation; either version 2 of the License, or at your option any
> > > + * later version; or, when distributed separately from the Linux kernel or
> > > + * when incorporated into other software packages, subject to the following
> > > + * license:
> > 
> > This boilerplate should not be here, only the spdx line is needed.
> 
> As per Documentation/process/license-rules.rst we use the SPDX license
> tag for the license that applies but it also states about dual
> licensing:
> 
> "Aside from that, individual files can be provided under a dual license,         
> e.g. one of the compatible GPL variants and alternatively under a               
> permissive license like BSD, MIT etc."
> 
> Let me know if things should change somehow here to clarify this better.

The spdx line is not matching the actual license for the file, which is
wrong.

And "copyright-left" is not a valid license according to our list of
valid licenses in the LICENSES directory, so please do not add it to
kernel code when it is obviously not needed.

And given that this is directly interacting with sysfs, which is
GPLv2-only, trying to claim a different license on the code that tests
it is going to be a total mess for any lawyer who wants to look into
this.  Just keep it simple please.

thanks,

greg k-h
