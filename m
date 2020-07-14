Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F08021F8E2
	for <lists+netdev@lfdr.de>; Tue, 14 Jul 2020 20:15:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729056AbgGNSPu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jul 2020 14:15:50 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:44285 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725951AbgGNSPt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jul 2020 14:15:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594750547;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=win16zJy2MUuNHeRcvO26T6/yRMLB6t6hoKt7xDIubY=;
        b=cklUsLjqIWt1hZsDYP/H95tji3JyJGzzMoBNu1yO4Akkvpo2iRG5Yvi6+5IYpCGrtuHfMy
        KBwDw01rd/Mt16ShnCCyVFNcwyNWD9RT1rSeAsTi/GW9j2NVwP/eHU64wntYV9AK7yNFUX
        e1GJgM3UsIMBttY8cjUIDSqI+LCWo0I=
Received: from mail-oi1-f199.google.com (mail-oi1-f199.google.com
 [209.85.167.199]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-445-bFnl3dobPme2LQbj_EDQIg-1; Tue, 14 Jul 2020 14:15:43 -0400
X-MC-Unique: bFnl3dobPme2LQbj_EDQIg-1
Received: by mail-oi1-f199.google.com with SMTP id j202so9177924oib.16
        for <netdev@vger.kernel.org>; Tue, 14 Jul 2020 11:15:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=win16zJy2MUuNHeRcvO26T6/yRMLB6t6hoKt7xDIubY=;
        b=g52tMFjVNdh09OEDwMYNNnEKYNUq09hbl5f0dTPlczVGstWMGvjb/pLPSJmZRmk5sx
         W5Gm2RH98mZKsvjnA90u6M8PnahYkm6hUQPKxmoG3gmNDLWwcHpVXuGj4yNk7t6W9vvp
         UdxKVyLLUBCMq5H/wBMrLAgXTyVBDlAEGtdMOUXjSZBz7QxUvvfgpvJ9whtzt1c1rqOZ
         VhoIxRcqX8uSyhxI6oVYXqouaGnXIdsv3RsKCgC1UkCfiJMmAP2+Ygcy5umpb6bDOnnk
         iraa8ViZfZ41li36L+5hpnv6aufO+deDBOS611+zGXh4eRY7Ow//qpNlLjEjZFoydyAP
         Ns4Q==
X-Gm-Message-State: AOAM530XvWrgrOUUOSzsahkVNu/UJ3MGq/j3H4dcfuWdPlO+Gn0+pLHR
        phkgPFBlFyDgB4H2CLlYDpgy4ZgZlZw97HpScj+fgwynao/3LgkNHj/B97C1QHBASn/ctlh6wes
        pDViDxTgwtluHzT9SbcOdX5PpqbtEAU4m
X-Received: by 2002:a9d:600d:: with SMTP id h13mr5330842otj.172.1594750542258;
        Tue, 14 Jul 2020 11:15:42 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzBgExS2QXXoi5JIyk/tiwWZUeQp7vxwi1Pu170mv6T8gyXnZ2C86Ws+npqq5ZEWry7y2oOH+Nl++df1XONhjg=
X-Received: by 2002:a9d:600d:: with SMTP id h13mr5330812otj.172.1594750541934;
 Tue, 14 Jul 2020 11:15:41 -0700 (PDT)
MIME-Version: 1.0
References: <CAKfmpSdcvFG0UTNJFJgXwNRqQb-mk-PsrM5zQ_nXX=RqaaawgQ@mail.gmail.com>
 <20200713220016.xy4n7c5uu3xs6dyk@lion.mk-sys.cz> <20200713154118.3a1edd66@hermes.lan>
 <24041.1594688115@famine>
In-Reply-To: <24041.1594688115@famine>
From:   Jarod Wilson <jarod@redhat.com>
Date:   Tue, 14 Jul 2020 14:15:30 -0400
Message-ID: <CAKfmpSecOTQgCMJkK5r=RDwydVUV9eYqBZ7bV1oWMfOzg_78mA@mail.gmail.com>
Subject: Re: [RFC] bonding driver terminology change proposal
To:     Jay Vosburgh <jay.vosburgh@canonical.com>
Cc:     Stephen Hemminger <stephen@networkplumber.org>,
        Michal Kubecek <mkubecek@suse.cz>,
        Netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 13, 2020 at 8:55 PM Jay Vosburgh <jay.vosburgh@canonical.com> wrote:
>
> Stephen Hemminger <stephen@networkplumber.org> wrote:
>
> >On Tue, 14 Jul 2020 00:00:16 +0200
> >Michal Kubecek <mkubecek@suse.cz> wrote:
> >
> >> On Mon, Jul 13, 2020 at 02:51:39PM -0400, Jarod Wilson wrote:
> >> > To start out with, I'd like to attempt to eliminate as much of the use
> >> > of master and slave in the bonding driver as possible. For the most
> >> > part, I think this can be done without breaking UAPI, but may require
> >> > changes to anything accessing bond info via proc or sysfs.
> >>
> >> Could we, please, avoid breaking existing userspace tools and scripts?
> >> Massive code churn is one thing and we could certainly bite the bullet
> >> and live with it (even if I'm still not convinced it would be as great
> >> idea as some present it) but trading theoretical offense for real and
> >> palpable harm to existing users is something completely different.
> >>
> >> Or is "don't break userspace" no longer the "first commandment" of linux
> >> kernel development?
> >>
> >> Michal Kubecek
> >
> >Please consider using same wording as current standard for link aggregration.
> >Current version is 802.1AX and it uses the terms:
> >  Multiplexer /  Aggregator
>
>         Well, 802.1AX only defines LACP, and the bonding driver does
> more than just LACP.  Also, Multiplexer, in 802.1AX, is a function of
> various components, e.g., each Aggregator has a Multiplexer, as do other
> components.
>
>         As "channel bonding" is a long-established term of art, I don't
> see an issue with something like "bond" and "port," which parallels the
> bridge / port terminology.

I did look at aggregator and port as options, but the overlap with the
bonding 802.3ad code would mean first reworking a bunch of that code
to free up those terms for more general bonding use. I think "bonding"
should be okay to keep around as well, and am kind of on the fence
with "master", since master of ceremonies, masters degress, master
keys, etc are all similar enough to what a master device in a bond
represents, and the main objectionable language is primarily "slave".

One option would be to rename "port" to "laggport" or "adport" or
something like that in the 802.3ad code, and then make use of "port"
in place of slave (which mirrors what's done in the team driver).


> [...]
> >As far as userspace, maybe keep the old API's but provide deprecation nags.
> >And don't document the old API values.
>
>         Unless the community stance on not breaking user space has
> changed, the extant APIs must be maintained.  In the context of bonding,
> this would include "ip link" command line arguments, sysfs and procsfs
> interfaces, as well as netlink attribute names.  There are also exported
> kernel APIs that bonding utilizes, netdev_master_upper_dev_link, et al.

To some people, this could be a case that warranted breaking UAPIs. In
an ideal world, that would be nice, but obviously, breaking the world
to get there isn't good either, so I think maintaining them all is
hopefully still understandable.

>         Additionally, just to be absolutely clear, is the proposal here
> intending to undertake a rather significant search and replace of the
> text strings "master" and "slave" within the bonding driver source?
> This in addition to whatever API changes end up being done.  If so, then
> I would also like to know the answer to Andrew's question regarding
> patch conflicts in order to gauge the future maintenance cost.

Correct, this would be full search-and-replace, with minor tweaks here
and there -- bond_enslave -> bond_connect or something like that,
since bond_encable wouldn't make sense, and replacing references to
ifenslave in the code isn't helpful, since ifenslave is still going to
be called ifenslave.

As of yet, no, I don't have this scripted, but I can certainly give
that a go. I'm not terribly familiar with coccinelle, and if that
would be the way to script it, or if a simple bash/perl/whatever
script would suffice.

--
Jarod Wilson
jarod@redhat.com

