Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 07214E5926
	for <lists+netdev@lfdr.de>; Sat, 26 Oct 2019 09:56:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726139AbfJZHz5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Oct 2019 03:55:57 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:36802 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725996AbfJZHz4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 26 Oct 2019 03:55:56 -0400
Received: by mail-wm1-f67.google.com with SMTP id c22so4243451wmd.1
        for <netdev@vger.kernel.org>; Sat, 26 Oct 2019 00:55:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=bqfjxb2UREomEKw3YgCsrCqVg3Fm6y255O+gDOqXdAc=;
        b=eIOpy3LDx1qkmvWhElVW+5ivsqhE5cTyiG1DThw6oxO8azB1YHtf9G96k5g027wAiE
         q1PnvPlS7YR0DHSdA0A7O79O9I0jplRgCCfkAyWpLFfWZ3Z0Zn7VOduK0s96fGPK3Ibs
         ZQa/Ckgy5yIbS+snxpOrdIHc6ozulye7fImBhW5EdieEKTUOuB4jcf/Wu1D5K+hXUUWK
         DHAG9JH4NxRZt11OfRXElHtxErNzEn+mnxzWmFzSEbgEgwwYyojuSqG/cAQVwsDYZqM8
         mhPgJr86ukjsL4Ox+Eu1I8aWD3EgpB6fXHDgvc/ukYe+6M4Sqxhy7pOD54wRqInKrqmq
         8OyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=bqfjxb2UREomEKw3YgCsrCqVg3Fm6y255O+gDOqXdAc=;
        b=rFqgMyiV9vqb0ITd6c4vlbbCyZT4+MVgVbuA+Q4LTVfsCvdJD0LHX3PXEa75aF+4dw
         8nlzDpAtae6eZ8PLnGQxoECN/OhVwGgF+sAEJ/jzNs7/u13gcaKvkOtK0NyfVsf3GA9a
         Inx2ZyeZpX9QXZg/wZZol5tzlZHPnRZi8Ps0/zLKYFJyWC7yldpw7S/rSTZqcC3NFVyd
         tkOGoqJ4wHz9m034NfjyXrj1ZnDoxQ61jnW+L6LIlnWTECp03YR4VXs3nbCU17ZDzp9p
         MI+d16jGQuo48ivZ6pfx9h7HX1YPv2z/hpvQ7/svSZhiAoLrEdo285K6cDRU+i0NmF+2
         JbPA==
X-Gm-Message-State: APjAAAWTsI39xn1KkDSfQq28J9znpJ1qFlWTfXabYOaZQgh9QjngoWn/
        TRr49Awf2J6Jmcbn2YATzr8qPQ==
X-Google-Smtp-Source: APXvYqz6vXX3kNbIhjpCaBbs9lB3H1Lc8718A2nPtRSCf9j4szxDGpxvTyCCKvmPIKxlh0eIhTRejg==
X-Received: by 2002:a1c:b4c2:: with SMTP id d185mr6342082wmf.159.1572076552501;
        Sat, 26 Oct 2019 00:55:52 -0700 (PDT)
Received: from netronome.com (fred-musen.rivierenbuurt.horms.nl. [2001:470:7eb3:404:a2a4:c5ff:fe4c:9ce9])
        by smtp.gmail.com with ESMTPSA id u68sm6887991wmu.12.2019.10.26.00.55.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 26 Oct 2019 00:55:51 -0700 (PDT)
Date:   Sat, 26 Oct 2019 09:55:50 +0200
From:   Simon Horman <simon.horman@netronome.com>
To:     Matteo Croce <mcroce@redhat.com>
Cc:     netdev <netdev@vger.kernel.org>,
        Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        "David S . Miller" <davem@davemloft.net>,
        Stanislav Fomichev <sdf@google.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Song Liu <songliubraving@fb.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Paul Blakey <paulb@mellanox.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next 3/4] flow_dissector: extract more ICMP
 information
Message-ID: <20191026075549.GC31244@netronome.com>
References: <20191021200948.23775-1-mcroce@redhat.com>
 <20191021200948.23775-4-mcroce@redhat.com>
 <20191023100009.GC8732@netronome.com>
 <CAGnkfhxg1sXkmiNS-+H184omQaKbp_+_Sy7Vi-9W9qLwGGPU6g@mail.gmail.com>
 <20191023175522.GB28355@netronome.com>
 <CAGnkfhyEB0JU7LPZfYxHiKkryrkzoOs3Krumt1Lph+Q=qx1s8A@mail.gmail.com>
 <20191025062856.GB7325@netronome.com>
 <CAGnkfhzN=P+j5n3A2RrRTseHgqMU1-5CsRd8xonZ2mLBtNoJ_g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGnkfhzN=P+j5n3A2RrRTseHgqMU1-5CsRd8xonZ2mLBtNoJ_g@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 25, 2019 at 08:24:20PM +0200, Matteo Croce wrote:
> On Fri, Oct 25, 2019 at 8:29 AM Simon Horman <simon.horman@netronome.com> wrote:
> >
> > On Fri, Oct 25, 2019 at 02:27:28AM +0200, Matteo Croce wrote:
> > > On Wed, Oct 23, 2019 at 7:55 PM Simon Horman <simon.horman@netronome.com> wrote:
> > > >
> > > > On Wed, Oct 23, 2019 at 12:53:37PM +0200, Matteo Croce wrote:
> > > > > On Wed, Oct 23, 2019 at 12:00 PM Simon Horman
> > > > > <simon.horman@netronome.com> wrote:
> > > > > > On Mon, Oct 21, 2019 at 10:09:47PM +0200, Matteo Croce wrote:
> > > > > > > +     switch (ih->type) {
> > > > > > > +     case ICMP_ECHO:
> > > > > > > +     case ICMP_ECHOREPLY:
> > > > > > > +     case ICMP_TIMESTAMP:
> > > > > > > +     case ICMP_TIMESTAMPREPLY:
> > > > > > > +     case ICMPV6_ECHO_REQUEST:
> > > > > > > +     case ICMPV6_ECHO_REPLY:
> > > > > > > +             /* As we use 0 to signal that the Id field is not present,
> > > > > > > +              * avoid confusion with packets without such field
> > > > > > > +              */
> > > > > > > +             key_icmp->id = ih->un.echo.id ? : 1;
> > > > > >
> > > > > > Its not obvious to me why the kernel should treat id-zero as a special
> > > > > > value if it is not special on the wire.
> > > > > >
> > > > > > Perhaps a caller who needs to know if the id is present can
> > > > > > check the ICMP type as this code does, say using a helper.
> > > > > >
> > > > >
> > > > > Hi,
> > > > >
> > > > > The problem is that the 0-0 Type-Code pair identifies the echo replies.
> > > > > So instead of adding a bool is_present value I hardcoded the info in
> > > > > the ID field making it always non null, at the expense of a possible
> > > > > collision, which is harmless.
> > > >
> > > > Sorry, I feel that I'm missing something here.
> > > >
> > > > My reading of the code above is that for the cased types above
> > > > (echo, echo reply, ...) the id is present. Otherwise it is not.
> > > > My idea would be to put a check for those types in a helper.
> > > >
> > >
> > > Something like icmp_has_id(), I like it.
> > >
> > > > I do agree that the override you have used is harmless enough
> > > > in the context of the only user of the id which appears in
> > > > the following patch of this series.
> > > >
> > > >
> > > > Some other things I noticed in this patch on a second pass:
> > > >
> > > > * I think you can remove the icmp field from struct flow_dissector_key_ports
> > > >
> > >
> > > You mean flow_dissector_key_icmp maybe?
> >
> > Yes, sorry for the misinformation.
> >
> > > > * I think that adding icmp to struct flow_keys should be accompanied by
> > > >   adding ICMP to flow_keys_dissector_symmetric_keys. But I think this is
> > > >   not desirable outside of the bonding use-case and rather
> > > >   the bonding driver should define its own structures that
> > > >   includes the keys it needs - basically copies of struct flow_keys
> > > >   and flow_keys_dissector_symmetric_keys with some modifications.
> > > >
> > >
> > > Just flow_keys_dissector_symmetric_keys or flow_keys_dissector_keys too?
> > > Anyway, it seems that the bonding uses the flow_dissector only when
> > > using encap2+3 or encap3+4 hashing, which means decap some known
> > > tunnels (mpls and gre and pppoe I think).
> >
> > That is the use case I noticed.
> >
> > In that case it uses skb_flow_dissect_flow_keys() which in turn
> > uses struct flow_keys and flow_keys_basic_dissector_keys (which is
> > assigned to flow_keys_dissector_keys.
> >
> > Sorry about mentioning flow_keys_dissector_symmetric_keys, I think
> > that was a copy-paste-error on my side.
> >
> 
> np
> 
> > In any case, my point is that if you update struct flow_keys then likely
> > some corresponding change should also be made to one or more of
> > *__dissector_keys. But such a change would have scope outside of bonding,
> > which is perhaps undesirable. So it might be better to make local
> > structures and call __skb_flow_dissect from within the bonding code.
> >
> 
> What drawbacks will it have to have the ICMP dissector enabled with
> flow_keys_dissector_keys?

1. All callers of skb_flow_dissect_flow_keys() (and any other users of
   flow_keys_dissector_keys) will incur the cost of extracting ICMP
   headers for ICMP packets, this was not previously the case.

2. The behaviour of callers of skb_flow_dissect_flow_keys() may change.
   In particular ___skb_get_hash() will take into account ICMP headers
   for ICMP packets, which was not previously the case.

Perhaps other side affects for other users, I have not audited them.

> I see three options here:
> 1. add the ICMP key in flow_keys_dissector_keys and change the
> flow_dissector behaviour, when dealing with echoes
> 2. do a local copy in the bonding code
> 3. leave flow_keys_dissector_keys as is, so the bonding will balance
> echoes only when not decapping tunnels

I'm not sure that I follow option 3.
I think that option 1 is not preferable due to side effects on other
users.

> I don't really know if option 1 could be a bug or a feature, sure
> option 2 is safer. That can be changed later easily anyway.

I agree option 2 seems safer.

> > As for other use cases, that do not currently use the dissector,
> > I think you will need to update them too to get then desired new
> > feature introduced in patch 4 for those use-cases, which I assume is
> > desired. Perhaps converting those use-cases to use the flow dissector
> > is a good way forwards. Perhaps not.
> >
> 
> I don't really know why the bonding doesn't use the dissector.
> Performance? Anyway, maybe converting the bonding to
> the flow_dissector would make sense, this can be done in the future.
> I have to talk with the bonding maintainers to understand what's
> behind this choice.

I am not sure either but I think that any change should check
for performance regressions. I think there is also the issue of
for which hashing options using ICMP fields is appropriate,
but perhaps it is all of them.
