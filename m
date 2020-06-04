Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 74D5A1EDA87
	for <lists+netdev@lfdr.de>; Thu,  4 Jun 2020 03:40:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727921AbgFDBkQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Jun 2020 21:40:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727909AbgFDBkN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Jun 2020 21:40:13 -0400
Received: from mail-pl1-x641.google.com (mail-pl1-x641.google.com [IPv6:2607:f8b0:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D135C08C5C3
        for <netdev@vger.kernel.org>; Wed,  3 Jun 2020 18:40:12 -0700 (PDT)
Received: by mail-pl1-x641.google.com with SMTP id n9so1496775plk.1
        for <netdev@vger.kernel.org>; Wed, 03 Jun 2020 18:40:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=RZTkgHwXnV/Mmq7iR84jWoY6DwZ1rOj4qUQ+qrZYDwc=;
        b=D25kXdKhWQJ/MUHuNLgCYDZUO7VYifzgRU57sW3cCgSotuT36cS0gwMFjJehcx+vT7
         Qo+Rryfzbt2dW0wLdUcGj9Q0InUDL3Kms87BacBCRrJrfyyPbeQNxvn25asBf8woO+z3
         +P77gIynfVAOQsI2dG7+NHySk/5WZ7LfsfFJE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=RZTkgHwXnV/Mmq7iR84jWoY6DwZ1rOj4qUQ+qrZYDwc=;
        b=ulmtJv5/QJmBqlJBPY7M2h/0YsNYxWShK5Bbm/m1cE5c7yjKo1QVKsHlx0zIH6qGNS
         A2IsTKbLaQDDQ+J0dtQ+e/LMhlqBUP3bAGLLo97Kfdfllwc/lpPy/3g7ULMQqqsU8EH3
         Mx++Jp1wzUHIOJ15Ca8Hu6yPLm4sxhl/EA0cso4QCPtUmjbBUPpTj14Bp7AdK42oAE4E
         +AI/ktNJClwKiKaVrL+xrh4WjRhB/j36mUP0Ufc4A1wIqxLwnZQxM4WcQW2bBg7+8g8F
         BXvHFIOlG8TewbKT7/mRnVVW6zjWOyzO1fLpxCgAT3hT6TgVpSzqk+qdS8DpE4FqhEhb
         x/tw==
X-Gm-Message-State: AOAM533UJVQyqsJIJTC7+8eO8xbv9Hr1ZNa/Owf/exBrG1hHQL1+SfnQ
        niw9xH87bQi+4Mn/i9K7pu0PVA==
X-Google-Smtp-Source: ABdhPJyG3cK5GuU0RarjdGROX8AagUDp+h912sluu+H/wdjYIyX1M3u7CAMpBcEf90rpTZQM3JGTsw==
X-Received: by 2002:a17:90a:dd44:: with SMTP id u4mr2890350pjv.132.1591234811278;
        Wed, 03 Jun 2020 18:40:11 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id o13sm2589124pgs.82.2020.06.03.18.40.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Jun 2020 18:40:10 -0700 (PDT)
Date:   Wed, 3 Jun 2020 18:40:09 -0700
From:   Kees Cook <keescook@chromium.org>
To:     Joe Perches <joe@perches.com>
Cc:     linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>,
        Alexander Potapenko <glider@google.com>,
        Andy Whitcroft <apw@canonical.com>, x86@kernel.org,
        drbd-dev@lists.linbit.com, linux-block@vger.kernel.org,
        b43-dev@lists.infradead.org, netdev@vger.kernel.org,
        linux-wireless@vger.kernel.org, linux-ide@vger.kernel.org,
        linux-clk@vger.kernel.org, linux-spi@vger.kernel.org,
        linux-mm@kvack.org, clang-built-linux@googlegroups.com
Subject: Re: [PATCH 08/10] checkpatch: Remove awareness of
 uninitialized_var() macro
Message-ID: <202006031838.55722640DC@keescook>
References: <20200603233203.1695403-1-keescook@chromium.org>
 <20200603233203.1695403-9-keescook@chromium.org>
 <ff9087b0571e1fc499bd8a4c9fd99bfc0357f245.camel@perches.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ff9087b0571e1fc499bd8a4c9fd99bfc0357f245.camel@perches.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 03, 2020 at 05:02:29PM -0700, Joe Perches wrote:
> On Wed, 2020-06-03 at 16:32 -0700, Kees Cook wrote:
> > Using uninitialized_var() is dangerous as it papers over real bugs[1]
> > (or can in the future), and suppresses unrelated compiler warnings
> > (e.g. "unused variable"). If the compiler thinks it is uninitialized,
> > either simply initialize the variable or make compiler changes.
> > 
> > In preparation for removing[2] the[3] macro[4], effectively revert
> > commit 16b7f3c89907 ("checkpatch: avoid warning about uninitialized_var()")
> > and remove all remaining mentions of uninitialized_var().
> > 
> > [1] https://lore.kernel.org/lkml/20200603174714.192027-1-glider@google.com/
> > [2] https://lore.kernel.org/lkml/CA+55aFw+Vbj0i=1TGqCR5vQkCzWJ0QxK6CernOU6eedsudAixw@mail.gmail.com/
> > [3] https://lore.kernel.org/lkml/CA+55aFwgbgqhbp1fkxvRKEpzyR5J8n1vKT1VZdz9knmPuXhOeg@mail.gmail.com/
> > [4] https://lore.kernel.org/lkml/CA+55aFz2500WfbKXAx8s67wrm9=yVJu65TpLgN_ybYNv0VEOKA@mail.gmail.com/
> 
> nack.  see below.
> 
> I'd prefer a simple revert, but it shouldn't
> be done here.

What do you mean? (I can't understand this and "fine by me" below?)

> 
> > diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
> []
> > @@ -4075,7 +4074,7 @@ sub process {
> >  		}
> >  
> >  # check for function declarations without arguments like "int foo()"
> > -		if ($line =~ /(\b$Type\s*$Ident)\s*\(\s*\)/) {
> > +		if ($line =~ /(\b$Type\s+$Ident)\s*\(\s*\)/) {
> 
> This isn't right because $Type includes a possible trailing *
> where there isn't a space between $Type and $Ident

Ah, hm, that was changed in the mentioned commit:

-               if ($line =~ /(\b$Type\s+$Ident)\s*\(\s*\)/) {
+               if ($line =~ /(\b$Type\s*$Ident)\s*\(\s*\)/) {

> 
> e.g.:	int *bar(void);
> 
> Other than that, fine by me...

Thanks for looking it over! I'll adjust it however you'd like. :)

-- 
Kees Cook
