Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A5E8441DE81
	for <lists+netdev@lfdr.de>; Thu, 30 Sep 2021 18:13:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349033AbhI3QOv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Sep 2021 12:14:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348685AbhI3QOr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Sep 2021 12:14:47 -0400
Received: from mail-lf1-x133.google.com (mail-lf1-x133.google.com [IPv6:2a00:1450:4864:20::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A31DC061771;
        Thu, 30 Sep 2021 09:13:03 -0700 (PDT)
Received: by mail-lf1-x133.google.com with SMTP id j5so22681305lfg.8;
        Thu, 30 Sep 2021 09:13:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=PSTyYsEnPx2Zz8WOySJeA/TTfgz1xi0DMJG8hnz15H8=;
        b=eHblUON+RQew3T5hKr9l8zNpzreOx5+1eTTqANwye7HIuVSyN9zcg/kLorxjbLKmfF
         7JCc5cJ4i5AIiVYoosGJfWxb4zaVpCx4ggTNn18XcFPKEZhj3Z4iLIpm6DPdCJVF+bYS
         EuySdve1mavEROFhsIQJnCJmRYCmy8Z/9eywYDTsVNuGaHZT16cw5dy9LR8gPYq0sm1+
         DB1SwiDzNoCAszX7L8H1TbZoHYC/AxTyuHdRYQUOqpfPR9ogtax3UGJzYWPQAdxBvMd6
         kESgZGr8bAx0EiAd65SRqbWntIylJCc0/RP2GPQpH4O3PRy0bWBSf+4/HiMZj5Om2qGg
         Rfkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=PSTyYsEnPx2Zz8WOySJeA/TTfgz1xi0DMJG8hnz15H8=;
        b=mhWjJWouVtHBnPY/Re6Gcv/UDWBs1o3N2rpM3V3br/w6MqlbFioWNdbP0+WLYvfivg
         X9XH2Z3nnq0SBW3hQcLD/sKyjxKMP4fIs1nk6S+d5bJjCgPdZDVerJvoHyr6RIivEzuM
         nZLLxOkcznEyH1jPCkq8yCYMsKST6LRSi6fMUbkB8wrNVMh6vG6WXNVZKKGxmxXOnlzo
         UkZo239jGPYdEes9GfjVgzQwo3RNh7NrJyUyXyYbgHHIHkB5Nojd+1M46LbBL8TfP2rO
         Gthg0za8akH4uT1gc+woAhC3EgNfBUVl6D4JxS2FgnzaKXGzrl5JocyC28kkJopE6MjZ
         1Jgg==
X-Gm-Message-State: AOAM532WZkb2SmFrsDH0NPh1LeD/Ny5A9ahqMK6QpI88fBApNzQVIOdK
        Z80oodC3go0h2IRAILqFrWg0NRJ2R6JpAvbkDYndWXIFmzY=
X-Google-Smtp-Source: ABdhPJweNHytmxWHYiqmadp7UNqbhgXMgSWVNSNBcc87lAY3taBiRUnPiicvXlIBDMJzy4RdKme6Zsf/z/9K1DEL61k=
X-Received: by 2002:a2e:300c:: with SMTP id w12mr6787647ljw.302.1633018381576;
 Thu, 30 Sep 2021 09:13:01 -0700 (PDT)
MIME-Version: 1.0
References: <20210928194727.1635106-1-cpp.code.lv@gmail.com> <20210928174853.06fe8e66@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210928174853.06fe8e66@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Cpp Code <cpp.code.lv@gmail.com>
Date:   Thu, 30 Sep 2021 09:12:50 -0700
Message-ID: <CAASuNyXcjwju6wzOeV6Ggu=DrNTrtqWv8T68TcwmwX8kUCZufw@mail.gmail.com>
Subject: Re: [PATCH net-next v6] net: openvswitch: IPv6: Add IPv6 extension
 header support
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, pshelar@ovn.org,
        "David S. Miller" <davem@davemloft.net>,
        ovs dev <dev@openvswitch.org>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 28, 2021 at 5:48 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Tue, 28 Sep 2021 12:47:27 -0700 Toms Atteka wrote:
> > diff --git a/include/uapi/linux/openvswitch.h b/include/uapi/linux/openvswitch.h
> > index a87b44cd5590..dc6eb5f6399f 100644
> > --- a/include/uapi/linux/openvswitch.h
> > +++ b/include/uapi/linux/openvswitch.h
> > @@ -346,6 +346,13 @@ enum ovs_key_attr {
> >  #ifdef __KERNEL__
> >       OVS_KEY_ATTR_TUNNEL_INFO,  /* struct ip_tunnel_info */
> >  #endif
> > +
> > +#ifndef __KERNEL__
>
> #else
>
> > +     PADDING,  /* Padding so kernel and non kernel field count would match */
>
> The name PADDING seems rather risky, collisions will be likely.
> OVS_KEY_ATTR_PADDING maybe?
>
> But maybe we don't need to define this special value and bake it into
> the uAPI, why can't we add something like this to the kernel header
> (i.e. include/linux/openvswitch.h):
>
> /* Insert a kernel only KEY_ATTR */
> #define OVS_KEY_ATTR_TUNNEL_INFO        __OVS_KEY_ATTR_MAX
> #undef OVS_KEY_ATTR_MAX
> #define OVS_KEY_ATTR_MAX                __OVS_KEY_ATTR_MAX
>
> > +#endif

Agree, name should be changed, I think I will go with __OVS_KEY_ATTR_PADDING
