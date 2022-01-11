Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C468048B681
	for <lists+netdev@lfdr.de>; Tue, 11 Jan 2022 20:10:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346066AbiAKTKX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Jan 2022 14:10:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243149AbiAKTKW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Jan 2022 14:10:22 -0500
Received: from mail-io1-xd2a.google.com (mail-io1-xd2a.google.com [IPv6:2607:f8b0:4864:20::d2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C11EFC06173F
        for <netdev@vger.kernel.org>; Tue, 11 Jan 2022 11:10:22 -0800 (PST)
Received: by mail-io1-xd2a.google.com with SMTP id w22so240091iov.3
        for <netdev@vger.kernel.org>; Tue, 11 Jan 2022 11:10:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=cpKhw2+Pt/hrcEKqbr/vysqr6x3qpLgNMwxZ2Jnl5C0=;
        b=eerQ/ExDgv+zay5VMf5ikY/3WeRNNVVWYOCBLFM/vdqznDa9JiMnjXGhIOw4GTAqMj
         sfucD6jmBLWe6suM3xQ7MK9dAAVggz6h2kPMXekGRW/sQJZ2euTR/uc40V6LQD/+rbPI
         h9Ib9Pmzviyv3j/AXcCjUSjJMj14U1JlAfWWOjwefWTvE+Q/MJZR3QWKiyQFRpzQj6eK
         Ysxuwt9RkR2hEIRWLh08c++urfPbz028TCaR0JmUAwkrSO7GfcuD+hMWaCG6LB+ovTJY
         VAhV67XD/bMcedvaDoDSfB5U63cGPwOFu7s7ytcREqfyERLuNrY7GIegkuj+u8pY0bSc
         eO6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=cpKhw2+Pt/hrcEKqbr/vysqr6x3qpLgNMwxZ2Jnl5C0=;
        b=qpN3mWxAAjRMhgZ+Afl1xlcdZ6bPe5xStjh/8G6Qgb48Tcf9hdYsX2vatYwFbSMEHO
         +dClYUYdYpy/51dgzsnNE7Au5J9V4xYyPz9PGWYT3xwrgvFhczOYMQb4gUq/gXRv/R8N
         TxnOBX/OEdUGoMxqB0gfs9oix5i5FIQ3xyVCy2PrEFeSGslzb4ht/OrghUZPSCUaZ67F
         yfM3xXzBibgiZ2J7HFX8EDU1A36EMoiB2Pc1AqUuY2fP/+4i+XyvzAQ4HLSB2dkcEdtR
         9w54rGRyVUrSbQ+q5YJqQd6JTJdr7BBk1TcTjg23KvQEU0RvfPtrBts3DXOLu+L0upPS
         lENA==
X-Gm-Message-State: AOAM532Hh9E0AUk/xhgHQKtidpzrDGWOkKyxOD37hWopapH/RBm9BuA+
        zcgcUTb2YtGKEAJX7S76NM65PwcuQLPYEZ7XMe8SGP+Zn1I=
X-Google-Smtp-Source: ABdhPJzisK+DlzkN7szRtm3xPttPzAQtu2gTPNuKqqFYx/hq8L8rzgITujWPjOZ9anH/vHsSjlRxfsHaUvo0LyLZ1RE=
X-Received: by 2002:a05:6602:26d3:: with SMTP id g19mr2987470ioo.100.1641928222224;
 Tue, 11 Jan 2022 11:10:22 -0800 (PST)
MIME-Version: 1.0
References: <20220108195824.23840-1-littlesmilingcloud@gmail.com> <acff5b79-2e5d-2877-0532-bb48608cc83b@gmail.com>
In-Reply-To: <acff5b79-2e5d-2877-0532-bb48608cc83b@gmail.com>
From:   Anton Danilov <littlesmilingcloud@gmail.com>
Date:   Tue, 11 Jan 2022 22:09:45 +0300
Message-ID: <CAEzD07JA8+MnQCcRViUxY=TFgeiFn-ZNgkMzvYo06oDuFUMRVA@mail.gmail.com>
Subject: Re: [PATCH iproute2 v2] ip: Extend filter links/addresses
To:     David Ahern <dsahern@gmail.com>
Cc:     Stephen Hemminger <stephen@networkplumber.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello, David.

> current 'type' filtering is the 'kind' string in the rtnl_link_ops --
> bridge, veth, vlan, vrf, etc. You are now wanting to add 'exclude_type'
> and make it based on hardware type. That is a confusing user api.

The 'exclude_type' options first checks the 'kind' in the
rtnl_link_ops, then the hardware type.

> What type of interface filtering is motivating this change? e.g., link /
> address lists but ignoring say vlan or veth devices?

Yep, sure. If you use the kvm hypervisors, you can see a lot of veth
devices. I think an ability to hide them is a good feature.

Filtering by 'kind' value has not been touched.


On Tue, 11 Jan 2022 at 19:35, David Ahern <dsahern@gmail.com> wrote:
>
> On 1/8/22 12:58 PM, Anton Danilov wrote:
> > @@ -227,6 +227,28 @@ static int match_link_kind(struct rtattr **tb, const char *kind, bool slave)
> >       return strcmp(parse_link_kind(tb[IFLA_LINKINFO], slave), kind);
> >  }
> >
> > +static int match_if_type_name(unsigned short if_type, const char *type_name)
> > +{
> > +
> > +     char *expected_type_name;
> > +
> > +     switch (if_type) {
> > +     case ARPHRD_ETHER:
> > +             expected_type_name = "ether";
> > +             break;
> > +     case ARPHRD_LOOPBACK:
> > +             expected_type_name = "loopback";
> > +             break;
> > +     case ARPHRD_PPP:
> > +             expected_type_name = "ppp";
> > +             break;
> > +     default:
> > +             expected_type_name = "";
> > +     }
> > +
> > +     return !strcmp(type_name, expected_type_name);
>
> current 'type' filtering is the 'kind' string in the rtnl_link_ops --
> bridge, veth, vlan, vrf, etc. You are now wanting to add 'exclude_type'
> and make it based on hardware type. That is a confusing user api.
>
> What type of interface filtering is motivating this change? e.g., link /
> address lists but ignoring say vlan or veth devices?



-- 
Anton Danilov.
