Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 56E641AAF21
	for <lists+netdev@lfdr.de>; Wed, 15 Apr 2020 19:08:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1416363AbgDORHl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Apr 2020 13:07:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1416349AbgDORHi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Apr 2020 13:07:38 -0400
Received: from mail-yb1-xb42.google.com (mail-yb1-xb42.google.com [IPv6:2607:f8b0:4864:20::b42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CAC2C061A0C;
        Wed, 15 Apr 2020 10:07:38 -0700 (PDT)
Received: by mail-yb1-xb42.google.com with SMTP id a9so375288ybc.8;
        Wed, 15 Apr 2020 10:07:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=mEawja+POkeWDhdeSb2n3JPPbIrc1MBf0BcSpr4jXiw=;
        b=DW/aynPdwuOV0UulG8/7DG2OSJ6ky7m4cHJ+Gz21nR6FRRF2vhyh16CWluwim3SoYH
         Sa3l3B3FzcLzAWMfA6xNlEZa48cJ9CxVyXx9wg8ieAy8Y5M9yIqLVmci0t7KahDzEp3+
         0TqZwO9P5Molcs7XpM8HUylYXdhNKpm1l4A7g2qFfA3vk8FbXmQZ1hXFuN1x1RAhqt7v
         FwAoYkOyjNfRiOoUzhrbnRB1KWQFZ4mT1YcaV5pjQKptgjzp1AtP5iy5Tg2xG69PKdwT
         tTojddkg9JdojP/Tpl3xBs1VsghOKLCz4A+73Z27B3CA1QGRd0/CftSCiv79EQSHLi++
         fpfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=mEawja+POkeWDhdeSb2n3JPPbIrc1MBf0BcSpr4jXiw=;
        b=N8j0bZXCFcUIH/gk1jPyGQ+F6ktrC3LQ8dZ21CB70LUexUDNj1mivlSbtn8lwq+9XB
         fI7kOPyP2mRbz1WIzZf4Rn8R63EDf4JvV2FCy37yogdTGzq+vgSx67q23XH+d3OIuAaO
         1+r4kH2AwS8HWH8vF0SBjxfii0QGoTxkn9RK6TiX+OSc7ikg0jJma8i3+bHhplib7TkF
         68VT4dmeAK1r4xWYOPEPfc7p5RicvX713rn9d2G6YgIy/Dl+HKsBu/EIuQN59QizLnpH
         FGXm0yse3u78rVRQwTB+vEEDW3HACpwReRhmaeOf1cgsFQuQRJlpwP93oowJO5S2QP7l
         gycA==
X-Gm-Message-State: AGi0PuYlV1gzJ3HoO2JpjNrjeCx9B441KlnIXhwuhEP1PeGgwgG1XNtr
        hEaY0ayS/qdRS+OOAfdJRoreQFdBx6l+uEIbryY=
X-Google-Smtp-Source: APiQypIUYnCqlboeLXX498mvDUEkiFizMnzOWoFRqJIN9jX23XsZO6pmKNshpPPzZLdtasP8OYlYcSo7oKRRSZZK1Gc=
X-Received: by 2002:a25:cf12:: with SMTP id f18mr9443585ybg.167.1586970457348;
 Wed, 15 Apr 2020 10:07:37 -0700 (PDT)
MIME-Version: 1.0
References: <3865908.1586874010@warthog.procyon.org.uk> <e751977dac616d93806d98f4ad3ce144bb1eb244.camel@kernel.org>
In-Reply-To: <e751977dac616d93806d98f4ad3ce144bb1eb244.camel@kernel.org>
From:   Steve French <smfrench@gmail.com>
Date:   Wed, 15 Apr 2020 12:07:26 -0500
Message-ID: <CAH2r5mvj7GF3i8AE6E=+5f_Vigtb3uw=665F2uuBOgGzUhHObQ@mail.gmail.com>
Subject: Re: What's a good default TTL for DNS keys in the kernel
To:     Jeff Layton <jlayton@kernel.org>
Cc:     David Howells <dhowells@redhat.com>,
        linux-nfs <linux-nfs@vger.kernel.org>,
        CIFS <linux-cifs@vger.kernel.org>, linux-afs@lists.infradead.org,
        ceph-devel@vger.kernel.org, keyrings@vger.kernel.org,
        Network Development <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, fweimer@redhat.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 15, 2020 at 8:22 AM Jeff Layton <jlayton@kernel.org> wrote:
>
> On Tue, 2020-04-14 at 15:20 +0100, David Howells wrote:
> > Since key.dns_resolver isn't given a TTL for the address information obtained
> > for getaddrinfo(), no expiry is set on dns_resolver keys in the kernel for
> > NFS, CIFS or Ceph.  AFS gets one if it looks up a cell SRV or AFSDB record
> > because that is looked up in the DNS directly, but it doesn't look up A or
> > AAAA records, so doesn't get an expiry for the addresses themselves.
> >
> > I've previously asked the libc folks if there's a way to get this information
> > exposed in struct addrinfo, but I don't think that ended up going anywhere -
> > and, in any case, would take a few years to work through the system.
> >
> > For the moment, I think I should put a default on any dns_resolver keys and
> > have it applied either by the kernel (configurable with a /proc/sys/ setting)
> > or by the key.dnf_resolver program (configurable with an /etc file).
> >
> > Any suggestion as to the preferred default TTL?  10 minutes?
> >
>
> Typical DNS TTL values are on the order of a day but it can vary widely.
> There's really no correct answer for this, since you have no way to tell
> how long the entry has been sitting in the DNS server's cache before you
> queried for it.
>
> So, you're probably down to just finding some value that doesn't hammer
> the DNS server too much, but that allows you to get new entries in a
> reasonable amount of time.
>
> 10 mins sounds like a reasonable default to me.

I would lean toward slightly longer (20 minutes?) but aren't there
usually different timeouts for 'static' vs. 'dynamic' DNS records (so
static records would have longer timeouts)?


-- 
Thanks,

Steve
