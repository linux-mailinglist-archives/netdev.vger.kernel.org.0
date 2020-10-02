Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F44C281CE1
	for <lists+netdev@lfdr.de>; Fri,  2 Oct 2020 22:24:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725769AbgJBUYB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Oct 2020 16:24:01 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:34769 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725446AbgJBUYA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Oct 2020 16:24:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1601670240;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=1BtRx1BSPtmWbCbhAW/KtfQIVoEEo/4AK+T/10zLCAU=;
        b=RQPEvWsRv/Xfy1+bBf0qcEzyKAG7FxeO2LzYBGEL/iLrDlvEgBhDFQ6Z68arj6UiVpAbI+
        diq6yB4mlaskexifQK0IKCOQnR+dI6QTb4yu1zO8G36MCBhlnssax7PkovebVF1CdOgR0F
        zXfQV/i1JoXXCEqYufjMtb0pmG88sks=
Received: from mail-ot1-f72.google.com (mail-ot1-f72.google.com
 [209.85.210.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-394-FcIz4TCEOp6yln6Bn2LpxQ-1; Fri, 02 Oct 2020 16:23:58 -0400
X-MC-Unique: FcIz4TCEOp6yln6Bn2LpxQ-1
Received: by mail-ot1-f72.google.com with SMTP id f15so1108828oto.6
        for <netdev@vger.kernel.org>; Fri, 02 Oct 2020 13:23:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=1BtRx1BSPtmWbCbhAW/KtfQIVoEEo/4AK+T/10zLCAU=;
        b=Wq5y6oBbNFvxt+88tYV5D+wbvXfRbj78LcVY7+fKCfWqDIIedTtPnXH+HgtiWPBHvW
         Fseqxa95rkn5ezh90LjteYLBqS/17dfVu2xFCwVtRvj0CvWUZwbfg1I+C0o/FIxecJrv
         QLXWj06mJdy80Lrxiq7D4zVhfzNzQQtEKeE9/9lEhAZgA1UKriExEQAK6WP0Nk31L5Hq
         LlDoznXtzSU50+5O8MyVvbKuj3F5N61Ew+OZQWDoKFJ3+HvwyaPmzN5iBF8ycvNZ0GQj
         e+aFA0m11BcXnGq+WDZZfUaoaSepSZ4+InnyDy1GW++QQ9M26VZWZNIPoIZIMCJMT+dk
         /IKA==
X-Gm-Message-State: AOAM5317MdIsPukZ59s+v+ac2NMkYS4vhuK8dP3zYvKA/ut1akn3YLrS
        id13RRZmt8R6TMf/Qw0Lo3vXp3k3xaEYfG4266H553iUxLDTkx8TAPgMrt4iCJr7bqiN3z7inGx
        S1OuzlbZTS5ttjvvWJmFXLLJcednSyE/k
X-Received: by 2002:a9d:6c4f:: with SMTP id g15mr2998944otq.277.1601670237869;
        Fri, 02 Oct 2020 13:23:57 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJx1gWWCddrZxrj9sNrhg+fkQWj8i0BYmrOGqgsFgdmOfXtbeSMXzBC4l59z6AWV2YwQgZ+1j0OdmCfede0NrJ0=
X-Received: by 2002:a9d:6c4f:: with SMTP id g15mr2998935otq.277.1601670237639;
 Fri, 02 Oct 2020 13:23:57 -0700 (PDT)
MIME-Version: 1.0
References: <20201002174001.3012643-1-jarod@redhat.com> <20201002174001.3012643-7-jarod@redhat.com>
 <20201002121317.474c95f0@hermes.local>
In-Reply-To: <20201002121317.474c95f0@hermes.local>
From:   Jarod Wilson <jarod@redhat.com>
Date:   Fri, 2 Oct 2020 16:23:46 -0400
Message-ID: <CAKfmpSc3-j2GtQtdskEb8BQvB6q_zJPcZc2GhG8t+M3yFxS4MQ@mail.gmail.com>
Subject: Re: [PATCH net-next v2 6/6] bonding: make Kconfig toggle to disable
 legacy interfaces
To:     Stephen Hemminger <stephen@networkplumber.org>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Thomas Davis <tadavis@lbl.gov>, Netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 2, 2020 at 3:13 PM Stephen Hemminger
<stephen@networkplumber.org> wrote:
>
> On Fri,  2 Oct 2020 13:40:01 -0400
> Jarod Wilson <jarod@redhat.com> wrote:
>
> > By default, enable retaining all user-facing API that includes the use of
> > master and slave, but add a Kconfig knob that allows those that wish to
> > remove it entirely do so in one shot.
> >
> > Cc: Jay Vosburgh <j.vosburgh@gmail.com>
> > Cc: Veaceslav Falico <vfalico@gmail.com>
> > Cc: Andy Gospodarek <andy@greyhouse.net>
> > Cc: "David S. Miller" <davem@davemloft.net>
> > Cc: Jakub Kicinski <kuba@kernel.org>
> > Cc: Thomas Davis <tadavis@lbl.gov>
> > Cc: netdev@vger.kernel.org
> > Signed-off-by: Jarod Wilson <jarod@redhat.com>
> > ---
> >  drivers/net/Kconfig                   | 12 ++++++++++++
> >  drivers/net/bonding/bond_main.c       |  4 ++--
> >  drivers/net/bonding/bond_options.c    |  4 ++--
> >  drivers/net/bonding/bond_procfs.c     |  8 ++++++++
> >  drivers/net/bonding/bond_sysfs.c      | 14 ++++++++++----
> >  drivers/net/bonding/bond_sysfs_port.c |  6 ++++--
> >  6 files changed, 38 insertions(+), 10 deletions(-)
> >
>
> This is problematic. You are printing both old and new values.
> Also every distribution will have to enable it.
>
> This looks like too much of change to users.

I'd had a bit of feedback that people would rather see both, and be
able to toggle off the old ones, rather than only having one or the
other, depending on the toggle, so I thought I'd give this a try. I
kind of liked the one or the other route, but I see the problems with
that too.

For simplicity, I'm kind of liking the idea of just not updating the
proc and sysfs interfaces, have a toggle entirely disable them, and
work on enhancing userspace to only use netlink, but ... it's going to
be a while before any such work makes its way to any already shipping
distros. I don't have a satisfying answer here.

-- 
Jarod Wilson
jarod@redhat.com

