Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 48C6E2BFEC7
	for <lists+netdev@lfdr.de>; Mon, 23 Nov 2020 04:43:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727557AbgKWDkG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 22 Nov 2020 22:40:06 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:59420 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726885AbgKWDkF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 22 Nov 2020 22:40:05 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1606102803;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=fyhlt2yMh9EPFXRVNXM1RHxmP2uagn8aXC85b4vBVaI=;
        b=OmLjTRtxa7u3uwDMV4HQi3aTOPvXf+cBQJ4RjvkjeujE6Nma4WVTvVQotjsbPSsafHc87m
        yGiSO54TlnRQpIyMRyu21ym1SW1qRg6tGbKUrqMFBc279njvdiiSonIpFwPoSEd9R9K1lO
        5KekhFtQ68RTBMpwmTmBmZq5Xuk88xA=
Received: from mail-oi1-f197.google.com (mail-oi1-f197.google.com
 [209.85.167.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-240-CTWp9YGKMOKv7LA-Xi_Elg-1; Sun, 22 Nov 2020 22:39:31 -0500
X-MC-Unique: CTWp9YGKMOKv7LA-Xi_Elg-1
Received: by mail-oi1-f197.google.com with SMTP id t67so8024584oie.14
        for <netdev@vger.kernel.org>; Sun, 22 Nov 2020 19:39:31 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=fyhlt2yMh9EPFXRVNXM1RHxmP2uagn8aXC85b4vBVaI=;
        b=LTTVGkK7u4KQ1OkYa9jNwZuN617MYw1MUPlbBC3fjOzZYwD52RI/4ncH9JG26dZ9t4
         lTljJlg1N5VXBHjKJsolOvucHSy3/V9V643HE0s5Vl1QbQw26aLOljjfpHKuR/qpqBAU
         UEoCDi8XqsIMvS5toecegGMnllvLTNoruT1OHV1Mby1C1WA0WSAvgRm9RX41xmwfZ+nJ
         qFEWLAS5g40T3BwSU9s5CyRI/BL4gdbdMUk81qRkvmRUw4gdg5eSjQ+FrkCV1vXhN/OW
         F1NJbQAywaGeOksU+XCcuiT0ug5gwCv/GXHAn+WJFd+u81EU+OsTE+Gs1vOFrG3RmZ/P
         bZUA==
X-Gm-Message-State: AOAM533/E8yh9Tfv8pVJ+hR6QeKtz1e7Oeu3tAQvFuOwogRdSRYWJJh6
        V4GX7WvrXJekVR44xZDuQRgNVuaVB0/s+pkpyDYjhrXZPVUm1iHoSqry4REPzQPNjkJ3QEQnESR
        Q6m2PUCx9rfVeL1nRT/Qn+39w2pLfoeTs
X-Received: by 2002:a4a:9f16:: with SMTP id s22mr21338258ook.20.1606102771076;
        Sun, 22 Nov 2020 19:39:31 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyoVJjTZ+YY/UAnuYLzBa3gsPwGcX34dzoxPkOT4xtR5xPJXqfK2R0HpnL2z7+elAuPrduCa2PMEaH8CK9eqw8=
X-Received: by 2002:a4a:9f16:: with SMTP id s22mr21338250ook.20.1606102770835;
 Sun, 22 Nov 2020 19:39:30 -0800 (PST)
MIME-Version: 1.0
References: <20201106200436.943795-1-jarod@redhat.com> <10065.1605125636@famine>
 <20201111140429.25ab20b1@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201111140429.25ab20b1@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Jarod Wilson <jarod@redhat.com>
Date:   Sun, 22 Nov 2020 22:39:20 -0500
Message-ID: <CAKfmpSdNmGnsxajsMHvhPSP5e5HTovt-bsvze482cE7ZyVFBSA@mail.gmail.com>
Subject: Re: [PATCH net-next v4 0/5] bonding: rename bond components
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Jay Vosburgh <jay.vosburgh@canonical.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        "David S. Miller" <davem@davemloft.net>,
        Thomas Davis <tadavis@lbl.gov>, Netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 11, 2020 at 5:04 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Wed, 11 Nov 2020 12:13:56 -0800 Jay Vosburgh wrote:
> > Jarod Wilson <jarod@redhat.com> wrote:
> >
> > >The bonding driver's use of master and slave, while largely understood
> > >in technical circles, poses a barrier for inclusion to some potential
> > >members of the development and user community, due to the historical
> > >context of masters and slaves, particularly in the United States. This
> > >is a first full pass at replacing those phrases with more socially
> > >inclusive ones, opting for bond to replace master and port to
> > >replace slave, which is congruent with the bridge and team drivers.
> > >
> > >There are a few problems with this change. First up, "port" is used in
> > >the bonding 802.3ad code, so the first step here is to rename port to
> > >ad_port, so we can reuse port. Second, we have the issue of not wanting
> > >to break any existing userspace, which I believe this patchset
> > >accomplishes, preserving all existing sysfs and procfs interfaces, and
> > >adding module parameter aliases where necessary.
> > >
> > >Third, we do still have the issue of ease of backporting fixes to
> > >-stable trees. I've not had a huge amount of time to spend on it, but
> > >brief forays into coccinelle didn't really pay off (since it's meant to
> > >operate on code, not patches), and the best solution I can come up with
> > >is providing a shell script someone could run over git-format-patch
> > >output before git-am'ing the result to a -stable tree, though scripting
> > >these changes in the first place turned out to be not the best thing to
> > >do anyway, due to subtle cases where use of master or slave can NOT yet
> > >be replaced, so a large amount of work was done by hand, inspection,
> > >trial and error, which is why this set is a lot longer in coming than
> > >I'd originally hoped. I don't expect -stable backports to be horrible to
> > >figure out one way or another though, and I don't believe that a bit of
> > >inconvenience on that front is enough to warrant not making these
> > >changes.
> >
> >       I think this undersells the impact a bit; this will most likely
> > break the majority of cherry-picks for the bonding driver to stable
> > going forward should this patch set be committed.  Yes, the volume of
> > patches to bonding is relatively low, and the manual backports are not
> > likely to be technically difficult.  Nevertheless, I expect that most
> > bonding backports to stable that cross this patch set will require
> > manual intervention.
> >
> >       As such, I'd still like to see explicit direction from the
> > kernel development community leadership that change sets of this nature
> > (not technically driven, with long term maintenance implications) are
> > changes that should be undertaken rather than are merely permitted.
>
> Yeah, IDK. I think it's up to you as the maintainer of this code to
> make a call based on the specific circumstances. All we have AFAIK
> is the coding style statement which discourages new uses:
>
>   For symbol names and documentation, avoid introducing new usage of
>   'master / slave' (or 'slave' independent of 'master') and 'blacklist /
>   whitelist'.
>
>   Recommended replacements for 'master / slave' are:
>     '{primary,main} / {secondary,replica,subordinate}'
>     '{initiator,requester} / {target,responder}'
>     '{controller,host} / {device,worker,proxy}'
>     'leader / follower'
>     'director / performer'
>
>   Recommended replacements for 'blacklist/whitelist' are:
>     'denylist / allowlist'
>     'blocklist / passlist'
>
>   Exceptions for introducing new usage is to maintain a userspace ABI/API,
>   or when updating code for an existing (as of 2020) hardware or protocol
>   specification that mandates those terms. For new specifications
>   translate specification usage of the terminology to the kernel coding
>   standard where possible.

Haven't been able to put much time into this the past few weeks, too
many other things going on leading into the holidays... But I think
Red Hat's general stance on this is that leaving things the way they
are is akin to condoning them. For change to happen, change needs to
happen. I know this starts to get political in a hurry though. I'd
like to see the changes made, even if there's a bit of pain involved
(clearly, since I've dumped this much time and effort into it so far).
:)

I'll try to address issues raised with this version, including the
checkpatch bits, but it may not be until after the first of the year
at this point, with assorted projects trying to get wrapped up before
the holidays, then the holidays themselves, etc.

-- 
Jarod Wilson
jarod@redhat.com

