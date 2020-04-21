Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 579E81B1BD7
	for <lists+netdev@lfdr.de>; Tue, 21 Apr 2020 04:26:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726931AbgDUC0q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Apr 2020 22:26:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725988AbgDUC0q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Apr 2020 22:26:46 -0400
Received: from mail-yb1-xb29.google.com (mail-yb1-xb29.google.com [IPv6:2607:f8b0:4864:20::b29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4BDDC061A0E;
        Mon, 20 Apr 2020 19:26:45 -0700 (PDT)
Received: by mail-yb1-xb29.google.com with SMTP id g6so6541789ybh.12;
        Mon, 20 Apr 2020 19:26:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=rRgQky4PDEZMWd12RdwHQNU2vo1l3+5UFXq3XUesRDU=;
        b=LQ8Bp0Ov7isBdAiER6YRYWyo8k3+eS6SZ42YaEAFUWiDZOS8+hgeZnWGISDcqJ1p2q
         UaSFjMATwjZUhisrmw/oV67tpJXZiKc1GFOexqcMkyc+i2HLNlyOXbZ/KK9ij0f9d+jg
         W2yjbH8bm3b9+pnfpqHbWw72UQ0HcwKPwhQUhuUUm4SQ+NUXmnFUFHB2TDnN7WoktHaY
         YMzb0JzH+UwJbGLZNjI6M24zAVo6RftVA0hwUGmuZE2n9OhTAYB3wRjnVF/cRuBhIgzU
         6dDsn1/OOeQ73kym2OXUtwIsvatGvdXrWf/ljV96GNnF19kFbfJ3DNcSn3ldAkIb1zOz
         nebg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=rRgQky4PDEZMWd12RdwHQNU2vo1l3+5UFXq3XUesRDU=;
        b=kL865/lOPBI3V0QQT2UpOKQRTSANYuVFif6HNAypVkr0EUbdoR631hurHTn1bSDi1N
         NeIoUSaDjTwe27YSzdO9tPpnND14+zucLEgShaaxZrjwGSdqzmEnup1ZgHQ06ofJfH8/
         2aNJhfJNVlWHbpMer807PAdsIPbNERwRLm8Wpw2epH1Hwn98qOdKu5gA5tXfbKvz9ReJ
         T3zbrMp0WGmI5oD437izfusa/6W4HZWutwE2IPvKpuW1h0wDajB7DNWqRxZZYDLi/jPC
         q9vLhzQZxk74Q01b2XoCWQR/FSRJ2K0/mq8baAD1NSfTa82ULXvUi2J4Pjngg+oXH+m5
         jCag==
X-Gm-Message-State: AGi0PuYk0d83tzbNlAS3IBknmlAzwqCsyH4Feb/c7+jyqjz2x+C9hQwz
        i62kbLH8G9UQmGga1oQ1o72OQVBjQV/4zyAFOFU=
X-Google-Smtp-Source: APiQypIv3Fen+zztBkd5PHVGvOFmEtm69MJphpXA9m9M7QwlbhVOXTlpOGX/cyb0PXpOZ5m24EyY89GZPZz0ftd39Kw=
X-Received: by 2002:a25:cf12:: with SMTP id f18mr23230627ybg.167.1587436004988;
 Mon, 20 Apr 2020 19:26:44 -0700 (PDT)
MIME-Version: 1.0
References: <878siq587w.fsf@cjr.nz> <87imhvj7m6.fsf@cjr.nz>
 <CAH2r5mv5p=WJQu2SbTn53FeTsXyN6ke_CgEjVARQ3fX8QAtK_w@mail.gmail.com>
 <3865908.1586874010@warthog.procyon.org.uk> <927453.1587285472@warthog.procyon.org.uk>
 <1136024.1587388420@warthog.procyon.org.uk> <1986040.1587420879@warthog.procyon.org.uk>
 <93e1141d15e44a7490d756b0a00060660306fadc.camel@redhat.com> <194431215.23515823.1587432599559.JavaMail.zimbra@redhat.com>
In-Reply-To: <194431215.23515823.1587432599559.JavaMail.zimbra@redhat.com>
From:   Steve French <smfrench@gmail.com>
Date:   Mon, 20 Apr 2020 21:26:34 -0500
Message-ID: <CAH2r5msYrA+3+VYYBFTvC+=72GNKH2mP=Ly9sBvOLYeSvebY_A@mail.gmail.com>
Subject: Re: cifs - Race between IP address change and sget()?
To:     Ronnie Sahlberg <lsahlber@redhat.com>
Cc:     Jeff Layton <jlayton@redhat.com>,
        David Howells <dhowells@redhat.com>,
        Paulo Alcantara <pc@cjr.nz>, Al Viro <viro@zeniv.linux.org.uk>,
        linux-nfs <linux-nfs@vger.kernel.org>,
        CIFS <linux-cifs@vger.kernel.org>, linux-afs@lists.infradead.org,
        ceph-devel@vger.kernel.org, keyrings@vger.kernel.org,
        Network Development <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Florian Weimer <fweimer@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 20, 2020 at 8:30 PM Ronnie Sahlberg <lsahlber@redhat.com> wrote:
>
>
>
>
>
> ----- Original Message -----
> > From: "Jeff Layton" <jlayton@redhat.com>
> > To: "David Howells" <dhowells@redhat.com>, "Paulo Alcantara" <pc@cjr.nz>
> > Cc: viro@zeniv.linux.org.uk, "Steve French" <smfrench@gmail.com>, "linux-nfs" <linux-nfs@vger.kernel.org>, "CIFS"
> > <linux-cifs@vger.kernel.org>, linux-afs@lists.infradead.org, ceph-devel@vger.kernel.org, keyrings@vger.kernel.org,
> > "Network Development" <netdev@vger.kernel.org>, "LKML" <linux-kernel@vger.kernel.org>, fweimer@redhat.com
> > Sent: Tuesday, 21 April, 2020 8:30:37 AM
> > Subject: Re: cifs - Race between IP address change and sget()?
> >
> > On Mon, 2020-04-20 at 23:14 +0100, David Howells wrote:
> > > Paulo Alcantara <pc@cjr.nz> wrote:
> > >
> > > > > > > What happens if the IP address the superblock is going to changes,
> > > > > > > then
> > > > > > > another mount is made back to the original IP address?  Does the
> > > > > > > second
> > > > > > > mount just pick the original superblock?
> > > > > >
> > > > > > It is going to transparently reconnect to the new ip address, SMB
> > > > > > share,
> > > > > > and cifs superblock is kept unchanged.  We, however, update internal
> > > > > > TCP_Server_Info structure to reflect new destination ip address.
> > > > > >
> > > > > > For the second mount, since the hostname (extracted out of the UNC
> > > > > > path
> > > > > > at mount time) resolves to a new ip address and that address was
> > > > > > saved
> > > > > > earlier in TCP_Server_Info structure during reconnect, we will end up
> > > > > > reusing same cifs superblock as per
> > > > > > fs/cifs/connect.c:cifs_match_super().
> > > > >
> > > > > Would that be a bug?
> > > >
> > > > Probably.
> > > >
> > > > I'm not sure how that code is supposed to work, TBH.
> > >
> > > Hmmm...  I think there may be a race here then - but I'm not sure it can be
> > > avoided or if it matters.
> > >
> > > Since the address is part of the primary key to sget() for cifs, changing
> > > the
> > > IP address will change the primary key.  Jeff tells me that this is
> > > governed
> > > by a spinlock taken by cifs_match_super().  However, sget() may be busy
> > > attaching a new mount to the old superblock under the sb_lock core vfs
> > > lock,
> > > having already found a match.
> > >
> >
> > Not exactly. Both places that match TCP_Server_Info objects by address
> > hold the cifs_tcp_ses_lock. The address looks like it gets changed in
> > reconn_set_ipaddr, and the lock is not currently taken there, AFAICT. I
> > think it probably should be (at least around the cifs_convert_address
> > call).
>
> I think you are right. We need the spinlock around this call too.
> I will send a patch to the list to add this.
>
> >
> > > Should the change of parameters made by cifs be effected with sb_lock held
> > > to
> > > try and avoid ending up using the wrong superblock?
> > >
> > > However, because the TCP_Server_Info is apparently updated, it looks like
> > > my
> > > original concern is not actually a problem (the idea that if a mounted
> > > server
> > > changes its IP address and then a new server comes online at the old IP
> > > address, it might end up sharing superblocks because the IP address is part
> > > of
> > > the key).
> > >
> >
> > I'm not sure we should concern ourselves with much more than just not
> > allowing addresses to change while matching/searching. If you're
> > standing up new servers at old addresses while you still have clients
> > are migrating, then you are probably Doing it Wrong.
>
> Agree. That is a migration process issue and not something we can/should
> try to address in cifs.ko.

Yep

-- 
Thanks,

Steve
