Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B15ED523071
	for <lists+netdev@lfdr.de>; Wed, 11 May 2022 12:13:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241794AbiEKKNH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 May 2022 06:13:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241716AbiEKKMi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 May 2022 06:12:38 -0400
Received: from gandalf.ozlabs.org (mail.ozlabs.org [IPv6:2404:9400:2221:ea00::3])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB411216867;
        Wed, 11 May 2022 03:12:35 -0700 (PDT)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4KyrLk522xz4xXh;
        Wed, 11 May 2022 20:12:30 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ellerman.id.au;
        s=201909; t=1652263951;
        bh=AYMaIHm/9FJs7QMQIGjVwHQBqVw7TF+ASqO5SvByvIQ=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=lC0i9AXiN8OGFHknnvxL+T1hg1fn/cgusHgj0/KPf0t/otQdhWoP0Z/6icK5/jzPn
         6yFaDkgHzwr+deS+AD+tGm7GSOKZIDPTNYhu8XoTdM7zVJOIhbK3tycAVo8HDvFH8f
         6Z/+qEsRN4ipbT3AN8LxjBAKXtObESQMWSivIWkKy0R7LSRvxZpLEy4Ps0sUsiIMhW
         Izpt2mBBj+GmabSb7N6QwFt6dYrzB/VTe4GQqPVD9zuW2wt1zyrCXj3xc8vqtzOf7k
         z4WEXVtfm/ZD9BY+Q9EG9pqTKwsaPs2G40KK6X93P5tz+IpFl61hCrRJ14e44s5mak
         blQEwlyz3slZA==
From:   Michael Ellerman <mpe@ellerman.id.au>
To:     Linus Torvalds <torvalds@linux-foundation.org>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Konstantin Ryabitsev <konstantin@linuxfoundation.org>
Cc:     KVM list <kvm@vger.kernel.org>,
        virtualization@lists.linux-foundation.org,
        Netdev <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        mie@igel.co.jp
Subject: Re: [GIT PULL] virtio: last minute fixup
In-Reply-To: <CAHk-=wjPR+bj7P1O=MAQWXp0Mx2hHuNQ1acn6gS+mRo_kbo5Lg@mail.gmail.com>
References: <20220510082351-mutt-send-email-mst@kernel.org>
 <CAHk-=wjPR+bj7P1O=MAQWXp0Mx2hHuNQ1acn6gS+mRo_kbo5Lg@mail.gmail.com>
Date:   Wed, 11 May 2022 20:12:27 +1000
Message-ID: <87czgk8jjo.fsf@mpe.ellerman.id.au>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Linus Torvalds <torvalds@linux-foundation.org> writes:
> On Tue, May 10, 2022 at 5:24 AM Michael S. Tsirkin <mst@redhat.com> wrote:
>>
>> A last minute fixup of the transitional ID numbers.
>> Important to get these right - if users start to depend on the
>> wrong ones they are very hard to fix.
>
> Hmm. I've pulled this, but those numbers aren't exactly "new".
>
> They've been that way since 5.14, so what makes you think people
> haven't already started depending on them?
>
> And - once again - I want to complain about the "Link:" in that commit.
>
> It points to a completely useless patch submission. It doesn't point
> to anything useful at all.
>
> I think it's a disease that likely comes from "b4", and people decided
> that "hey, I can use the -l parameter to add that Link: field", and it
> looks better that way.

Some folks have been doing it since the early 2010s.

But I think it really took off after the Change-Id discussion a few
years back:

  https://lore.kernel.org/all/CAHk-=whFbgy4RXG11c_=S7O-248oWmwB_aZOcWzWMVh3w7=RCw@mail.gmail.com/

Which I read as you endorsing Link: tags :)

> And then they add it all the time, whether it makes any sense or not.

For me it always makes sense, because it means I can easily go from a
commit back to the original submission. That's useful for automating
various things like replies and patchwork status updates.

It allows me to find the exact patch I applied, even if what I committed
is slightly different (due to fuzz or editing), which would be harder
with a search based approach.

It gives us a way to essentially augment the change log after the fact,
by replying to the original patch with things we didn't know at the time
of commit - eg. this patch was reverted because it caused a bug, etc.

If you follow the Link: and there's nothing useful there explaining
what motivated the change then that's a bug in the patch submission, not
the Link: tag.

Really important information should be in the change log itself, but the
space below the "---" is perfect for added context that would be too
verbose for the committed change log. And anyone can reply to the
original submission to add even more useful information.

cheers
