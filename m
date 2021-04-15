Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B969A36021F
	for <lists+netdev@lfdr.de>; Thu, 15 Apr 2021 08:01:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230472AbhDOGBu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Apr 2021 02:01:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230384AbhDOGBs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Apr 2021 02:01:48 -0400
Received: from mail-lj1-x22e.google.com (mail-lj1-x22e.google.com [IPv6:2a00:1450:4864:20::22e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0420FC06175F
        for <netdev@vger.kernel.org>; Wed, 14 Apr 2021 23:01:23 -0700 (PDT)
Received: by mail-lj1-x22e.google.com with SMTP id u20so25774425lja.13
        for <netdev@vger.kernel.org>; Wed, 14 Apr 2021 23:01:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=qdo7GLfDZ1fKfLETl+AnnMu4LOm28kYyjEjCWeEN/kM=;
        b=PZxrip/lkWUIJnUpal2tRZVXiAofn50XVw3/lU7TzdlDxJ3ozNg0JLo+iujw/3cE3A
         7ozR/Gb7FWcOZSffC3ERKXcAVMqYX+YUIIHGzcVHpjaC2fhw6cvyROe7+ZOEORYP34gO
         4rktudHPimrrD0KrViFavSSLb6Lfr99RTv1ImY4Ya8S+Tu4Lxwif0WmaVLv27ZZj9Be8
         UX5lMfwFptT5vX2mIZh3o/ufbjoBKPI99et2JkncXPrOAFkC0J2O+KV2mRPrv6obQ8+/
         NcGLJ772C8lX+8IbfHtw7egTBQodFI6Z5S9hmkz8qnGic7XsyD0KTZWn32nrdgIvO23n
         CQbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=qdo7GLfDZ1fKfLETl+AnnMu4LOm28kYyjEjCWeEN/kM=;
        b=kow5WssxpxtTRIU0oU8uhIdAd9wrDm57QFLItWTpLEAgkkuRzrxTx69N/mybc+mdwT
         qUGVA4B/uubSpJHi5QfTW1AsQujCeQYs6Q3adXkxuLhFKafagwNixNuko4mcEk2/Tpwb
         dvkSUd4FJBrfSx6y4jxZoQSSqZcjXPtOP+PZDMD+eaPdS3X8rL7bp8KF6cWmJgQ21ooQ
         k2fT5uWJbtVyLul2A78XwFv86A39HfB650B90ULXQO2w2nPgd4gmoPwS0SX7BE4YghZ4
         nSamO7oDGVniG7dUOqYYTYB2QlWRU/YwzblPs7LQlzqeS2lfbNCvoR4sqd9pHaV8eD+R
         ybeg==
X-Gm-Message-State: AOAM533V18muff7tY4KGy36t+RwErTRlUUnbZn3Q1m/rxvCkK6QBxI3B
        AZjYDQ4qvk+LMpiUr+AWqy1Z8qQkie/4WvqfP/ylyg==
X-Google-Smtp-Source: ABdhPJy9te6R+p8u4q5ZbHoZtpIs4d6hU7Z7VX61/DbN9iNOvSUCxpMUf/Ps0cuyIkT9nOAmt7XlbbjeLhPd7cK0OuU=
X-Received: by 2002:a2e:8797:: with SMTP id n23mr831519lji.347.1618466482085;
 Wed, 14 Apr 2021 23:01:22 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1618388989.git.npache@redhat.com> <0fa191715b236766ad13c5f786d8daf92a9a0cf2.1618388989.git.npache@redhat.com>
 <e26fbcc8-ba3e-573a-523d-9c5d5f84bc46@tessares.net>
In-Reply-To: <e26fbcc8-ba3e-573a-523d-9c5d5f84bc46@tessares.net>
From:   David Gow <davidgow@google.com>
Date:   Thu, 15 Apr 2021 14:01:10 +0800
Message-ID: <CABVgOSm9Lfcu--iiFo=PNLCWCj4vkxqAqO0aZT9B2r3Kw5Fhaw@mail.gmail.com>
Subject: Re: [PATCH v2 5/6] kunit: mptcp: adhear to KUNIT formatting standard
To:     Matthieu Baerts <matthieu.baerts@tessares.net>,
        Nico Pache <npache@redhat.com>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Brendan Higgins <brendanhiggins@google.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-ext4@vger.kernel.org, Networking <netdev@vger.kernel.org>,
        rafael@kernel.org, linux-m68k@lists.linux-m68k.org,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        "Theodore Ts'o" <tytso@mit.edu>,
        mathew.j.martineau@linux.intel.com, davem@davemloft.net,
        Mark Brown <broonie@kernel.org>,
        Shuah Khan <skhan@linuxfoundation.org>, mptcp@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Nico, Matthieu,

Thanks for going to the trouble of making these conform to the KUnit
style guidelines.

On Wed, Apr 14, 2021 at 5:25 PM Matthieu Baerts
<matthieu.baerts@tessares.net> wrote:
>
> Hi Nico,
>
> On 14/04/2021 10:58, Nico Pache wrote:
> > Drop 'S' from end of CONFIG_MPTCP_KUNIT_TESTS inorder to adhear to the
> > KUNIT *_KUNIT_TEST config name format.

[Super nitpicky comment for this series: It's 'adhere', not 'adhear'.
It's not worth resending this out just to fix the spelling here, but
if you do another version, it might be worth fiing.]

>
> For MPTCP, we have multiple KUnit tests: crypto and token. That's why we
> wrote TESTS with a S.

So (as this patch series attests), there are a few different config
options which cover (or intend one day to cover) multiple suites, and
hence end in KUNIT_TESTS. Personally, I'd still slightly prefer TEST
here, just to have a common suffix for KUnit test options, and that's
what I was going for when writing the style guide.

That being said, it's also worth noting that there is an explicit
exemption for existing tests, so if you (for example) have a bunch of
automation which relies on this name and can't easily be changed,
that's probably more important than a lone 'S'.

> I'm fine without S if we need to stick with KUnit' standard. But maybe
> the standard wants us to split the two tests and create
> MPTCP_TOKEN_KUNIT_TEST and MPTCP_TOKEN_KUNIT_TEST config?
>
> In this case, we could eventually keep MPTCP_KUNIT_TESTS which will in
> charge of selecting the two new ones.

This is certainly an option if you want to do it, but personally I
wouldn't bother unless it gives you some real advantage. One thing I
would note, however, is that it's possible to have a per-subsystem
'.kunitconfig' file, so if you want to run a particular group of tests
(i.e., have a particular set of config options for testing), it'd be
possible to have that rather than a meta-Kconfig entry.

While there are some advantages to trying to have a  1:1 suite:config
mapping, there's isn't actually anything that depends on it at the
moment (or indeed, anything actively planned). So, in my view, there's
no need for you to split the config entry unless you think there's a
good reason you'd want to be able to build one set of tests but not
the other.

> Up to the KUnit maintainers to decide ;-)

To summarise my view: personally, I'd prefer things the way this patch
works: have everything end in _KUNIT_TEST, even if that enables a
couple of suites. The extra 'S' on the end isn't a huge problem if you
have a good reason to particularly want to keep it, though: as long as
you don't have something like _K_UNIT_VERIFICATION or something
equally silly that'd break grepping for '_KUNIT_TEST', it's fine be
me.

So, since it matches my prejudices, this patch is:

Reviewed-by: David Gow <davidgow@google.com>

Thanks,
-- David
