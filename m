Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 836C42786C1
	for <lists+netdev@lfdr.de>; Fri, 25 Sep 2020 14:13:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728366AbgIYMNk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Sep 2020 08:13:40 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:29322 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727132AbgIYMNk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Sep 2020 08:13:40 -0400
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1601036018;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=9aKCeIUiQec4vK5wcBZEU6AS+RDJQHHmHHdQS8z/cKw=;
        b=L74l5MjcOwWcbpp6+u3RcRb3yyV47qA0fkmyjMWWuQ6Io49APjTwrVKZSh/XjE1OKyjjeN
        /VhsWk/UTUMLfu/LqPdFQvURD3ClJb7YMFLZnmB2mwk3lrT5VivoP68478a8s8rh03YPtf
        7UzKxUsi+uCefja42MFW8RrwUksoH9E=
Received: from mail-oo1-f71.google.com (mail-oo1-f71.google.com
 [209.85.161.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-259-dOYGx6uyPkSMSTKKgBY6CQ-1; Fri, 25 Sep 2020 08:13:36 -0400
X-MC-Unique: dOYGx6uyPkSMSTKKgBY6CQ-1
Received: by mail-oo1-f71.google.com with SMTP id x71so1170226ooa.19
        for <netdev@vger.kernel.org>; Fri, 25 Sep 2020 05:13:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=9aKCeIUiQec4vK5wcBZEU6AS+RDJQHHmHHdQS8z/cKw=;
        b=KqKC5idcQZq5lDKwlKSYs4wDE5WOZRq3O9vHMYUL2xYlI4+CM4/N5lURsWfRid5vWU
         rXPYRJEV7OrD3iGRImGpZy5wMfSizkxkJUIg5tUCpWFEyiSS8ziZwGoDUMlzIv3eSdT/
         p1IXv3A+FfW3HGkNHq6tIWnso6pdT1iEUPyOYRfvjklci7zcSx0xs6PAtDlZV7UJkQS7
         G9zQSetGt2bEQxZU42w2V6c2YBO64J0fHi/X2BcKdeIeebhCvVFch1fyC7/wawfi0XD9
         VahXe0CQHGidYbE2cY6yWhygM3un1S7mCfc3wCs/DfdZUmsaoOqgWwMc6GmmyYrUQVYk
         FkiA==
X-Gm-Message-State: AOAM532WX3Jd27XIezenCSi3Sbj6347EN5ZtJC6ycC/zdmCPGiIKsbWt
        EIHh+W6G3lKjifoCDSqCAQwZhobAZsbfWoY3ZNQBYPrxoAxWragKPbL4Vjn4ixrzi1Dp1g53q0d
        VevC0soqWBCSgB/PDY8cza0zivnoTuovi
X-Received: by 2002:a9d:3ca:: with SMTP id f68mr54448otf.330.1601036015809;
        Fri, 25 Sep 2020 05:13:35 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxnBNDgt0/M5Yqbni1/2wD1zhM5oVrbsT1+cJlMXufn1oau4EV6KH5Sl9xBOVhCR3j/eiDaTNOZYjD28Q+7HcM=
X-Received: by 2002:a9d:3ca:: with SMTP id f68mr54429otf.330.1601036015525;
 Fri, 25 Sep 2020 05:13:35 -0700 (PDT)
MIME-Version: 1.0
References: <20200922133731.33478-1-jarod@redhat.com> <14715.1600813163@famine>
In-Reply-To: <14715.1600813163@famine>
From:   Jarod Wilson <jarod@redhat.com>
Date:   Fri, 25 Sep 2020 08:13:24 -0400
Message-ID: <CAKfmpSd145TDcgi6t0+BFfXH2+4Q0J-UB6uA+bm4vfpDrgy1sA@mail.gmail.com>
Subject: Re: [PATCH net-next 0/5] bonding: rename bond components
To:     Jay Vosburgh <jay.vosburgh@canonical.com>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Thomas Davis <tadavis@lbl.gov>, Netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 22, 2020 at 6:19 PM Jay Vosburgh <jay.vosburgh@canonical.com> wrote:
>
> Jarod Wilson <jarod@redhat.com> wrote:
>
> >The bonding driver's use of master and slave, while largely understood
> >in technical circles, poses a barrier for inclusion to some potential
> >members of the development and user community, due to the historical
> >context of masters and slaves, particularly in the United States. This
> >is a first full pass at replacing those phrases with more socially
> >inclusive ones, opting for aggregator to replace master and link to
> >replace slave, as the bonding driver itself is a link aggregation
> >driver.
>
>         First, I think there should be some direction from the kernel
> development leadership as to whether or not this type of large-scale
> search and replace of socially sensitive terms of art or other
> terminology is a task that should be undertaken, given the noted issues
> it will cause in stable release maintenance going forwards.

Admittedly, part of the point of this patch is to help drive such
conversations. Having a concrete example of how these changes would
look makes it easier to discuss, I think. I understand the burden
here, though as you noted later, bonding doesn't really churn that
much, so in this specific case, the maintenance load wouldn't be
terrible, and I think worth it in this case, from a social standpoint.
I know this can start to get political and personal real fast
though...

>         Second, on the merits of the proposed changes (presuming for the
> moment that this goes forward), I would prefer different nomenclature
> that does not reuse existing names for different purposes, i.e., "link"
> and "aggregator."
>
>         Both of those have specific meanings in the current code, and
> old kernels will retain that meaning.  Changing them to have new
> meanings going forward will lead to confusion, in my opinion for no good
> reason, as there are other names suited that do not conflict.
>
>         For example, instead of "master" call everything a "bond," which
> matches common usage in discussion.  Changing "master" to "aggregator,"
> the replacement results in cumbersome descriptions like "the
> aggregator's active aggregator" in the context of LACP.
>
>         A replacement term for "slave" is trickier; my first choice
> would be "port," but that may make more churn from a code change point
> of view, although struct slave could become struct bond_port, and leave
> the existing struct port for its current LACP use.

I did briefly have the idea of renaming 'port' in the LACP code to
'lacp_port', which would allow reuse of 'port', and would then be
consistent with the team driver (and bridge driver, iirc). I could
certainly pursue that option, or try going with "bond_port", but I'd
like something so widely used throughout the code to be shorter if
possible, I think. It really is LACP that throws a wrench into most
sensible naming schemes I could think of. Simply renaming current
"master" to "bond" does make a fair bit of sense though, didn't really
occur to me. But replacing "slave" is definitely the far more involved
and messy one.

> >There are a few problems with this change. First up, "link" is used for
> >link state already in the bonding driver, so the first step here is to
> >rename link to link_state. Second, aggregator is already used in the
> >802.3ad code, but I feel the usage is actually consistent with referring
> >to the bonding aggregation virtual device as the aggregator. Third, we
> >have the issue of not wanting to break any existing userspace, which I
> >believe this patchset accomplishes, while also adding alternative
> >interfaces using new terminology, and a Kconfig option that will let
> >people make the conscious decision to break userspace and no longer
> >expose the original master/slave interfaces, once their userspace is
> >able to cope with their removal.
>
>         I'm opposed to the Kconfig option because it will lead to
> balkanization of the UAPI, which would be worse than a clean break
> (which I'm also opposed to).

I suspected this might be a point of contention. Easy enough to simply
omit that bit from the series, if that's the consensus.

> >Lastly, we do still have the issue of ease of backporting fixes to
> >-stable trees. I've not had a huge amount of time to spend on it, but
> >brief forays into coccinelle didn't really pay off (since it's meant to
> >operate on code, not patches), and the best solution I can come up with
> >is providing a shell script someone could run over git-format-patch
> >output before git-am'ing the result to a -stable tree, though scripting
> >these changes in the first place turned out to be not the best thing to
> >do anyway, due to subtle cases where use of master or slave can NOT yet
> >be replaced, so a large amount of work was done by hand, inspection,
> >trial and error, which is why this set is a lot longer in coming than
> >I'd originally hoped. I don't expect -stable backports to be horrible to
> >figure out one way or another though, and I don't believe that a bit of
> >inconvenience on that front is enough to warrant not making these
> >changes.
>
>         I'm skeptical that, given the scope of the changes involved,
> that it's really feasible to have effective automated massaging of
> patches.  I think the reality is that a large fraction of the bonding
> fixes in the future will have to be backported entirely by hand.  The
> only saving grace here is that the quantity of such patches is generally
> low (~40 in 2020 year to date).

Yeah, requiring manual backporting by hand is a very distinct
possibility. As noted, such patches are usually pretty low in number,
and I'll note that they're also generally fairly small patches too. I
would be happy to help with any manual backporting as well, as a
consolation if scripting them doesn't really work out.

-- 
Jarod Wilson
jarod@redhat.com

