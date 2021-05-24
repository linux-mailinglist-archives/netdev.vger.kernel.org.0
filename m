Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CAB5738F35B
	for <lists+netdev@lfdr.de>; Mon, 24 May 2021 20:58:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233188AbhEXS7b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 May 2021 14:59:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232709AbhEXS7a (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 May 2021 14:59:30 -0400
Received: from mail-lf1-x12a.google.com (mail-lf1-x12a.google.com [IPv6:2a00:1450:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6858C061574
        for <netdev@vger.kernel.org>; Mon, 24 May 2021 11:58:01 -0700 (PDT)
Received: by mail-lf1-x12a.google.com with SMTP id i9so42092818lfe.13
        for <netdev@vger.kernel.org>; Mon, 24 May 2021 11:58:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=QLaA8Iq3AVSSSyEwhx9vx8RPthLKncuTLaOITeO972A=;
        b=p8ux36h2e/gKzer8cRPh/AfFl8oniVnym3qJPzx2x6FhZO/5Uj0e/CJr4O9VUDsgit
         VPVSQEjUuALDpMqepv4R5VdEPQ3pNVye1iKisLR3gGTpWexOMIHJo7oYYC8y2xWxcbHT
         2f96r5maz3dJc5yVh8RQJeQE1+4IIPC945f9gVu0oV63QocJWvUXgJncae3ZaU602fGN
         y/MhCTKXsNHyqR7h2s+mrg5g1lBb4zm5EgApj3qaLJ8xySL9XcqjInitSAj8m4BZm3J1
         bZy37REWrc8VC9zO9FqlUYeHsnd6APiGZwjkTdu9F3qp5afwps6mjzPsqXmkmKU4LP27
         4rjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=QLaA8Iq3AVSSSyEwhx9vx8RPthLKncuTLaOITeO972A=;
        b=AS8FEUopw43fl/xNVLu1DjXSMPqULtzBCUm4L2XdTiJvqBnT0bCASkqQxJcB7h1lBj
         7xcoDPRS7/zBuqY93T8fejuniwGqwh3iB7kGrte+UNZV/vh6Q2Wwaocj8PVn8v79iPRY
         4xyfoDAry85taaNBZe8ONntATOYVXb0phL2jQfyl6rmG1/oAM9X/98OZoUFXdfN3+XMm
         LscnkxQ+STGcqJsowlWUGKxuT7PJTwkjRltHR78tOaNB32O5AoRuOavVEa09Kui6Orlw
         2/GkWUqvx+eO53q5XZLGQtSEXdTn5laB4jz+B7+NXHN0YltJMAMesPBv6ARB1CHumPqr
         52ow==
X-Gm-Message-State: AOAM533u2cA+jzwxsTnQmUZe56ebyBMxM8TTFc8D2UqaJGLkL/HkGI8f
        MbraHv/GtN/yXQ5rf/UB53Vs0yBPp0pUVWmWkgAClwoMuSCnow==
X-Google-Smtp-Source: ABdhPJw+brx1u3v7SD56yC8yJrSHE+hA2sPN0ISmXsqZ7cPcpMsjPIaGc9p1a5NW/ufyASmXmroww7oh91yQwMdnW3k=
X-Received: by 2002:ac2:5b12:: with SMTP id v18mr11569201lfn.261.1621882680321;
 Mon, 24 May 2021 11:58:00 -0700 (PDT)
MIME-Version: 1.0
References: <20210517152051.35233-1-cpp.code.lv@gmail.com> <614d9840-cd9d-d8b1-0d88-ce07e409068d@ovn.org>
In-Reply-To: <614d9840-cd9d-d8b1-0d88-ce07e409068d@ovn.org>
From:   Cpp Code <cpp.code.lv@gmail.com>
Date:   Mon, 24 May 2021 11:57:49 -0700
Message-ID: <CAASuNyWEUgdJU-_zcKbpkQa91KHffoTaR4T8csea=AtP30DSsg@mail.gmail.com>
Subject: Re: [PATCH net-next v2] net: openvswitch: IPv6: Add IPv6 extension
 header support
To:     Ilya Maximets <i.maximets@ovn.org>
Cc:     netdev@vger.kernel.org, "pshelar@ovn.org" <pshelar@ovn.org>,
        "David S. Miller" <davem@davemloft.net>,
        ovs dev <dev@openvswitch.org>,
        Jakub Kicinski <kuba@kernel.org>, Ben Pfaff <blp@ovn.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Yes, these changes only works together with changes in userspace. I
believe in any solution there should be corresponding changes in
userspace. If we would be able to easily run old version of userspace
with these changes in kernel without userspace complaining about
struct size, we could get in to a situation with hard to find bugs.

I don't agree with the solution of a new struct key as semantically
ipv6 extension headers are integral part of every ipv6 packet thus
expected to be in the struct along with label, for example. Correct if
I am missing something.

On Wed, May 19, 2021 at 2:52 AM Ilya Maximets <i.maximets@ovn.org> wrote:
>
> On 5/17/21 5:20 PM, Toms Atteka wrote:
> > IPv6 extension headers carry optional internet layer information
> > and are placed between the fixed header and the upper-layer
> > protocol header.
> >
> > This change adds a new OpenFlow field OFPXMT_OFB_IPV6_EXTHDR and
> > packets can be filtered using ipv6_ext flag.
> >
> > Tested-at: https://github.com/TomCodeLV/ovs/actions/runs/504185214
> > Signed-off-by: Toms Atteka <cpp.code.lv@gmail.com>
> > ---
> >  include/uapi/linux/openvswitch.h |   1 +
> >  net/openvswitch/flow.c           | 141 +++++++++++++++++++++++++++++++
> >  net/openvswitch/flow.h           |  14 +++
> >  net/openvswitch/flow_netlink.c   |   5 +-
> >  4 files changed, 160 insertions(+), 1 deletion(-)
> >
> >
> > base-commit: 5d869070569a23aa909c6e7e9d010fc438a492ef
> >
> > diff --git a/include/uapi/linux/openvswitch.h b/include/uapi/linux/openvswitch.h
> > index 8d16744edc31..a19812b6631a 100644
> > --- a/include/uapi/linux/openvswitch.h
> > +++ b/include/uapi/linux/openvswitch.h
> > @@ -420,6 +420,7 @@ struct ovs_key_ipv6 {
> >       __u8   ipv6_tclass;
> >       __u8   ipv6_hlimit;
> >       __u8   ipv6_frag;       /* One of OVS_FRAG_TYPE_*. */
> > +     __u16  ipv6_exthdr;
> >  };
>
> Wouldn't this break existing userspace?  Curent OVS expects netlink
> message with attribute size equal to the old version of 'struct ovs_key_ipv6'
> and it will discard OVS_KEY_ATTR_IPV6 as malformed.
>
> This should likely be a completely new structure and a completely new
> OVS_KEY_ATTR.
>
> Best regards, Ilya Maximets.
