Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D11D20227A
	for <lists+netdev@lfdr.de>; Sat, 20 Jun 2020 09:57:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727104AbgFTH5h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 20 Jun 2020 03:57:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725835AbgFTH5g (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 20 Jun 2020 03:57:36 -0400
Received: from mail-wr1-x444.google.com (mail-wr1-x444.google.com [IPv6:2a00:1450:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86579C06174E;
        Sat, 20 Jun 2020 00:57:36 -0700 (PDT)
Received: by mail-wr1-x444.google.com with SMTP id l10so11754937wrr.10;
        Sat, 20 Jun 2020 00:57:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=+ni8LF6DiZ7e+Sa1bH9I96UUmF2BBDFC3xDwZDcw058=;
        b=NiF4Ek5JpVCT1lkixtJWNHFOi/+jzvu5yqUj3bVi28nBXxd1qGW6SwIjRWQsHVZvQ1
         /sN9tsPubXkYpuqaIOe2WnxiwZqgQAakf0KNEk2oKNHTdNO+l1Oj0svHDl4FSnAMkWg0
         sjQSuriza/6E772gnStLKc8Dd+ZP24hlrXp1pQFOacPEJCRv7X5MnaV2n105XjmEVS+c
         7t4HeE/LZWVXKY6rYGMkUtcMqVNx8jBnpGXPoNYK8/OBSesF0B3kuXHEPqVIuQQhwKza
         R6ye/M+q2rTGF6UJbvBK0WlWpo0wqfwIYsh4RMJFfuYb/4J3XwOTd1Pg3Q/A8JtMiS5J
         KJRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=+ni8LF6DiZ7e+Sa1bH9I96UUmF2BBDFC3xDwZDcw058=;
        b=effKCyDlDQeCPgiqd8WfGrAECWCVwvDTEwI3tOhp8P5FfsQ87uUT84LR+RHXjXNAlC
         OUZieR9ZY6oWk1KKQ84PvTxmtGML20GOO4NWVcsFpMeN/lFKqy/yesRYyQ6wK38dzWQ9
         HUPwtESq3r1zm+EmWXR4H2n/lDLIeM/L7zIEkjQsiauDPGcYSzv7fSSKZW4FYp3jC/wP
         DLGqMbQs8AsmnR0CnV8lDqRymQCsGr4gnwe36vTcglZYSTvHSfcFUzJyd/i6GPlH0pAo
         kJHdL+Vxk76i+jVSQkOrR/DpDTk1g1cfItD1fVa+KmVJyxocAHlwC60Zl1GcG0gmXEcp
         Mfvw==
X-Gm-Message-State: AOAM5301EQOHZmcA4V322O5uBJDtPlhv84AxgyNjEYoUF7qU5y51T2n4
        FJ3QPIltlsEqHpAd+zdEJ2SkpGQ=
X-Google-Smtp-Source: ABdhPJx2LzDP5vaEKmQra4DiB1bA7ic/ADuDUbl9U0GPCwzJ0K00W8lZUJcSkex4J9D5e32tWJ5TGQ==
X-Received: by 2002:a05:6000:128e:: with SMTP id f14mr8750971wrx.276.1592639855172;
        Sat, 20 Jun 2020 00:57:35 -0700 (PDT)
Received: from localhost.localdomain ([46.53.252.34])
        by smtp.gmail.com with ESMTPSA id e25sm10429252wrc.69.2020.06.20.00.57.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 20 Jun 2020 00:57:34 -0700 (PDT)
Date:   Sat, 20 Jun 2020 10:57:32 +0300
From:   Alexey Dobriyan <adobriyan@gmail.com>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>,
        linux-arch <linux-arch@vger.kernel.org>,
        NetFilter <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH] linux++, this: rename "struct notifier_block *this"
Message-ID: <20200620075732.GA468070@localhost.localdomain>
References: <20200618210645.GB2212102@localhost.localdomain>
 <CAHk-=whz7xz1EBqfyS-C8zTx3_q54R1GuX9tDHdK1-TG91WH-Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAHk-=whz7xz1EBqfyS-C8zTx3_q54R1GuX9tDHdK1-TG91WH-Q@mail.gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 19, 2020 at 11:37:47AM -0700, Linus Torvalds wrote:
> On Thu, Jun 18, 2020 at 2:06 PM Alexey Dobriyan <adobriyan@gmail.com> wrote:
> >
> > Rename
> >         struct notifier_block *this
> > to
> >         struct notifier_block *nb
> >
> > "nb" is arguably a better name for notifier block.
> 
> Maybe it's a better name. But it doesn't seem worth it.
> 
> Because C++ reserved words are entirely irrelevant.
> 
> We did this same dance almost three decades ago, and the fact is, C++
> has other reserved words that make it all pointless.

The real problems are "class" and "new" indeed.

> There is no way I will accept the renaming of various "new" variables.

I'm not sending "new".

> We did it, it was bad, we undid it, and we now have a _lot_ more uses
> of 'new' and 'old', and no, we're not changing it for a braindead
> language that isn't relevant to the kernel.
> 
> The fact is, C++ chose bad identifiers to make reserved words.
> 
> If you want to build the kernel with C++, you'd be a lot better off just doing
> 
>    /* C++ braindamage */
>    #define this __this
>    #define new __new
> 
> and deal with that instead.

Can't do this because of placement new.

> Because no, the 'new' renaming will never happen, and while 'this'
> isn't nearly as common or relevant a name, once you have the same
> issue with 'new', what's the point of trying to deal with 'this'?

I'm not sending "new".

There is stuff which can be merge without breaking source compatibility
and readability of C version:

	private		=> priv
	virtual		=> virt
	this		=> self (in some contexts)

and those which can not. I'm not sending the latter.
