Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C167419EF5
	for <lists+netdev@lfdr.de>; Mon, 27 Sep 2021 21:12:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236358AbhI0TOQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Sep 2021 15:14:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236141AbhI0TOP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Sep 2021 15:14:15 -0400
Received: from mail-lf1-x134.google.com (mail-lf1-x134.google.com [IPv6:2a00:1450:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A21A8C061714;
        Mon, 27 Sep 2021 12:12:37 -0700 (PDT)
Received: by mail-lf1-x134.google.com with SMTP id z24so82854619lfu.13;
        Mon, 27 Sep 2021 12:12:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=g1L2s4NZq83aRZiynEOAEFk+LytSiN0akgfpfUfBL+s=;
        b=aZbN+bqYMWcpSUTG6slz9WQOTn9ntVoaArXsPdhI4DDBOcijDFw1vba/15ROuwcE9b
         VA9i+pZma/3wbZI1LUfiGwV1qKbFh2lrJD5ibGBu7KPWV1IqdQ8ZqGz8l9lYPFTpPclQ
         tuS8M91ATnDoYX5P6233ilv4lqtRbqtLspGOeqDFhjNXoc8lHEwyaQnCDm6fkyQ3hDK1
         EAR5ZHlRntxNEpUcya7bSOsMXGhfp+KZsggUlnEerhYIDzJajyBmKB+PvCjNB7w6XRQD
         tA2XgUvMrePF5wVvYAYESqrfH/fus3eH/TEc5Dhz7wUZ2KNNDIqzqB5hmd7zfTtbNWm4
         NayQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=g1L2s4NZq83aRZiynEOAEFk+LytSiN0akgfpfUfBL+s=;
        b=Ue4FEApefUQw/R+bPQgYT3HLTTtML1IHFZ2oPOtt9rKXslg3oDGwCWMqBD98uQn2bR
         8mDFKZHYSLv6qBQ2c0aOGi+b7o3M8kdBzi33D8YI1idnOxfbyagx9H+xeaCMZ3PNwXok
         5wpwQRVKFIcT+OTMoXky/685VpXbyjdxr/+F8dT5+Jibwivh2JOo4lKQTBUQSnSSCDzs
         Ne81S3eDHsA5NIesBrDXc6FK/YTpM+kuVs5oUtG3uIROsncM0k31+aHsILWswoo1DIyC
         VM6f9RzF91GdOzvpmqxQ8ETQfPEhg7Y5wBTi+Tl7q9+GF82KmiUUczEOF9Mu121wwFDY
         xjCw==
X-Gm-Message-State: AOAM533C6L39eoqdBwj3UizRHYA2BbmqCIO4q+qAnSVjpYogbMOsm7p3
        yV8ZLInZn1jMOhfKbf3k5FbI5l7hCCZrFYSnXK9/3xsu
X-Google-Smtp-Source: ABdhPJzPvlBdTxS1jiSsnfXupwFBY9N88/hUIoOj1bqMVKjlkJbcZ0CAdaKrZ2Qas7kBmeHUan0wWrOskD631WS1rPQ=
X-Received: by 2002:ac2:5f71:: with SMTP id c17mr1334481lfc.555.1632769956054;
 Mon, 27 Sep 2021 12:12:36 -0700 (PDT)
MIME-Version: 1.0
References: <20210920182038.1510501-1-cpp.code.lv@gmail.com> <0d70b112-dc7a-7083-db8d-183782b8ef8f@6wind.com>
In-Reply-To: <0d70b112-dc7a-7083-db8d-183782b8ef8f@6wind.com>
From:   Cpp Code <cpp.code.lv@gmail.com>
Date:   Mon, 27 Sep 2021 12:12:23 -0700
Message-ID: <CAASuNyUWoZ1wToEUYbdehux=yVnWQ=suKDyRkQfRD-72DOLziw@mail.gmail.com>
Subject: Re: [PATCH net-next v5] net: openvswitch: IPv6: Add IPv6 extension
 header support
To:     nicolas.dichtel@6wind.com
Cc:     netdev@vger.kernel.org, pshelar@ovn.org,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        ovs dev <dev@openvswitch.org>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

To use this code there is a part of code in the userspace. We want to
keep compatibility when we only update userspace part code or only
kernel part code. This means we should have same values for constants
and we can only add new ones at the end of list.

Best,
Tom

On Wed, Sep 22, 2021 at 11:02 PM Nicolas Dichtel
<nicolas.dichtel@6wind.com> wrote:
>
> Le 20/09/2021 =C3=A0 20:20, Toms Atteka a =C3=A9crit :
> > This change adds a new OpenFlow field OFPXMT_OFB_IPV6_EXTHDR and
> > packets can be filtered using ipv6_ext flag.
> >
> > Signed-off-by: Toms Atteka <cpp.code.lv@gmail.com>
> > ---
> >  include/uapi/linux/openvswitch.h |  12 +++
> >  net/openvswitch/flow.c           | 140 +++++++++++++++++++++++++++++++
> >  net/openvswitch/flow.h           |  14 ++++
> >  net/openvswitch/flow_netlink.c   |  24 +++++-
> >  4 files changed, 189 insertions(+), 1 deletion(-)
> >
> > diff --git a/include/uapi/linux/openvswitch.h b/include/uapi/linux/open=
vswitch.h
> > index a87b44cd5590..dc6eb5f6399f 100644
> > --- a/include/uapi/linux/openvswitch.h
> > +++ b/include/uapi/linux/openvswitch.h
> > @@ -346,6 +346,13 @@ enum ovs_key_attr {
> >  #ifdef __KERNEL__
> >       OVS_KEY_ATTR_TUNNEL_INFO,  /* struct ip_tunnel_info */
> >  #endif
> > +
> > +#ifndef __KERNEL__
> > +     PADDING,  /* Padding so kernel and non kernel field count would m=
atch */
> > +#endif
> > +
> > +     OVS_KEY_ATTR_IPV6_EXTHDRS,  /* struct ovs_key_ipv6_exthdr */
> Naive question, why not moving OVS_KEY_ATTR_IPV6_EXTHDRS above
> OVS_KEY_ATTR_TUNNEL_INFO?
>
>
>
> Regards,
> Nicolas
