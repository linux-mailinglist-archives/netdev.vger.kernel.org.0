Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8EFD33D2FDC
	for <lists+netdev@lfdr.de>; Fri, 23 Jul 2021 00:34:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232375AbhGVVyV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Jul 2021 17:54:21 -0400
Received: from mail-pl1-f174.google.com ([209.85.214.174]:43829 "EHLO
        mail-pl1-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232320AbhGVVyU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Jul 2021 17:54:20 -0400
Received: by mail-pl1-f174.google.com with SMTP id d17so923592plh.10;
        Thu, 22 Jul 2021 15:34:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=VyLGTqswjAT6qLthwUe8GNmcXwOWxADqbicD6omyIuc=;
        b=tf+aLkVdAD4vPdXF88uXQy+vB3CYIO2MMdZ0hkxdyELg+W9F5P7mq8Cy1JLKF7eBCh
         qiR2evj8JTDVZ1XN7HlrJSMCXgUFh36RfuqkNPQ+nJFrnqs51WkBsySYLzLbWcvW56qj
         fDFvUsVvayrAzPYSzuSJQUIm6laskj/RnnW+sLk4LIReGQmtwM0BEb2hLhdt9ObQ8Btt
         +K1xwX/vW8WUGaN+kpWucKNHoPCfcEGsIAutTxCkvQL7+PoCnpCKsX7Vlzl/QLoHBJfl
         WZFKQcBlUsYzXkVeMqv0R7ZFr0i0xBQVyGZT/35S7xfDEcv5jRXz96gZ4euhrqZVHFck
         Mytw==
X-Gm-Message-State: AOAM533L/9nV55B49Xv8/zYBEU72IWC3R8hfk4q4L2YB5tLrz7MUYcYW
        35IKjaTFBnWS12tYKSyEiz0=
X-Google-Smtp-Source: ABdhPJxx0yOHbOnXxEhWB9G1POpQL+iRei2o0jQLKVrRd192woRgvj3mqtJOy4mH9/kNcn0rJ+kQGg==
X-Received: by 2002:a63:1d18:: with SMTP id d24mr2084173pgd.69.1626993293716;
        Thu, 22 Jul 2021 15:34:53 -0700 (PDT)
Received: from garbanzo ([191.96.121.239])
        by smtp.gmail.com with ESMTPSA id l2sm30573920pfc.157.2021.07.22.15.34.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Jul 2021 15:34:52 -0700 (PDT)
Date:   Thu, 22 Jul 2021 15:34:49 -0700
From:   Luis Chamberlain <mcgrof@kernel.org>
To:     Greg KH <gregkh@linuxfoundation.org>,
        Shuah Khan <skhan@linuxfoundation.org>
Cc:     tj@kernel.org, shuah@kernel.org, akpm@linux-foundation.org,
        rafael@kernel.org, davem@davemloft.net, kuba@kernel.org,
        ast@kernel.org, andriin@fb.com, daniel@iogearbox.net,
        atenart@kernel.org, alobakin@pm.me, weiwan@google.com,
        ap420073@gmail.com, jeyu@kernel.org, ngupta@vflare.org,
        sergey.senozhatsky.work@gmail.com, minchan@kernel.org,
        axboe@kernel.dk, mbenes@suse.com, jpoimboe@redhat.com,
        tglx@linutronix.de, keescook@chromium.org, jikos@kernel.org,
        rostedt@goodmis.org, peterz@infradead.org,
        linux-block@vger.kernel.org, netdev@vger.kernel.org,
        linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/4] selftests: add tests_sysfs module
Message-ID: <20210722223449.ot5272wpc6o5uzlk@garbanzo>
References: <20210703004632.621662-1-mcgrof@kernel.org>
 <20210703004632.621662-2-mcgrof@kernel.org>
 <YPgF2VAoxPIiKWX1@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YPgF2VAoxPIiKWX1@kroah.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 21, 2021 at 01:32:41PM +0200, Greg KH wrote:
> On Fri, Jul 02, 2021 at 05:46:29PM -0700, Luis Chamberlain wrote:
> > This selftests will shortly be expanded upon with more tests which
> > require further kernel changes in order to provide better test
> > coverage.
> 
> Why is this not using kunit?  We should not be adding new in-kernel
> tests that are not using that api anymore.

No way. That cannot possibly be true. When was this decided? Did
Shuah Khan, the maintainer of selftests, all of a sudden decide we
are going to deprecate selftests in favor for trying to only use
kunit? Did we have a conference where this was talked about and decided?

If so all these are huge news to me and I missed the memo!

If I would have been at such meeting I would have definitely yelled
bloody murder!

kunit relies on UML and UML is a simple one core architecture, to start
with. This means I cannot run tests for multicore with it, which is
where many races do happen! Yes, you can run kunit on other
architectures, but all that is new.

Second, I did help review kunit getting upstream, and suggested a few
example tests, part of which were for sysctl to compare and contrast
what is possible and what we cannot do.

Not everything we want to test should be written as a kunit test.
No way.

In this case kunit is not ideal given I want to mimic something in
userspace interaction, and expose races through error injection and
if we can use as many cores to busy races out.

Trust me, I'm an advocate of kunit, and I'm even trying to see ideally
what tests from fstests / blktests could be kunit'ified. But in this
case, no. Using a selftests is much better target framework.

> > diff --git a/lib/test_sysfs.c b/lib/test_sysfs.c
> > new file mode 100644
> > index 000000000000..bf43016d40b5
> > --- /dev/null
> > +++ b/lib/test_sysfs.c
> > @@ -0,0 +1,943 @@
> > +// SPDX-License-Identifier: GPL-2.0-or-later
> 
> This does not match your "boiler-plate" text below, sorry.

Indeed, I'll fix it.

  Luis
