Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 20F5F41F669
	for <lists+netdev@lfdr.de>; Fri,  1 Oct 2021 22:42:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355457AbhJAUoa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Oct 2021 16:44:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355332AbhJAUo3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Oct 2021 16:44:29 -0400
Received: from mail-lf1-x12f.google.com (mail-lf1-x12f.google.com [IPv6:2a00:1450:4864:20::12f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2636BC061775;
        Fri,  1 Oct 2021 13:42:45 -0700 (PDT)
Received: by mail-lf1-x12f.google.com with SMTP id j5so38471985lfg.8;
        Fri, 01 Oct 2021 13:42:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=VaEB82g66moSG49ibSQm4DaIHpTLHO/JhyYD6WTE38E=;
        b=WT8tOvXoMB55QTeKzRCKfDDees9R7IsFTEjbNDM7JRfSa7C0vAXxtXKNYIj+zr9Zu+
         KUa8MjXjG1pNe0dOCW/yqpVM8T7WmqHk7tBHtTcxB4p7Z3aBkNvmSYeb5PlnJg6Tl82Q
         5HGo4ZIl9irAmOCGJJYfUyh4WJJP99Qgj0lMPZXyYpphgBFE19VF/8yd9+Ivc6V7UZcj
         wNhA1wq8YKBLUtNe+pAbripBAKtsgYZD2QwdVzj0ETmpl1+4ECOLtGIavmMflJ5420ZU
         a9HpFVggIV528qqWJ5nZWuozx/zlxo7WcIerGvq7Bp+4SPpGd4/Rhom9F9bB0sf9Nw0j
         SLjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=VaEB82g66moSG49ibSQm4DaIHpTLHO/JhyYD6WTE38E=;
        b=pD0hliMBzWeeQm/WoJnGyzPvBvhElvOxYeTH6cLaCU6g+4kCbn2GYz8mGrFQ4g/aSu
         s2GwIDJxjfDenK9WorwKvfqK7uBlFfATLb24KfeLhj26tLonE0Uy4FJBDUmwZ9O4cm2+
         5c1SXbWhFssvfT0p/JiQCpBS8owOf+aCWyLMB7mZ+tgvLAZWQSribeOXKXnNlJ+wZ79r
         5zqfoUudHfaQHTsb4/woDxCiCylJeOHvXek9ueMnvE+wXbJz7Qb6IjP7rX4ds04BGnl/
         xPO/BUdnx508kFwzLjXNEqy975L3IdE9rVMlm5ULbVI3UOWY3yTk3nG1GZpIo/3KiumY
         9Y/A==
X-Gm-Message-State: AOAM530+YVjSgRzLDBXOlZQ7Q6Rl/p5bLSFX0yrQ06o/2tw2vWpNiTHF
        wfiXOeaQSi2FpRfJ5Kf/EHxiKcYbB1oPIkwwWNo=
X-Google-Smtp-Source: ABdhPJy9TwRcdV4sMm8TgMLXEZJfac+zanXG7g7DsutApUoAt1WpMctRE7+tJWPf4akrToetBj1AgpRLy0chKORI6OE=
X-Received: by 2002:a05:6512:1052:: with SMTP id c18mr92771lfb.161.1633120963250;
 Fri, 01 Oct 2021 13:42:43 -0700 (PDT)
MIME-Version: 1.0
References: <20210928194727.1635106-1-cpp.code.lv@gmail.com>
 <20210928174853.06fe8e66@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <d1e5b178-47f5-9791-73e9-0c1f805b0fca@6wind.com> <20210929061909.59c94eff@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CAASuNyVe8z1R6xyCfSAxZbcrL3dej1n8TXXkqS-e8QvA6eWd+w@mail.gmail.com> <b091ef39-dc29-8362-4d31-0a9cc498e8ea@6wind.com>
In-Reply-To: <b091ef39-dc29-8362-4d31-0a9cc498e8ea@6wind.com>
From:   Cpp Code <cpp.code.lv@gmail.com>
Date:   Fri, 1 Oct 2021 13:42:32 -0700
Message-ID: <CAASuNyW81zpSu+FGSDuUrOsyqJj7SokZtvX081BbeXi0ARBaYg@mail.gmail.com>
Subject: Re: [PATCH net-next v6] net: openvswitch: IPv6: Add IPv6 extension
 header support
To:     Nicolas Dichtel <nicolas.dichtel@6wind.com>
Cc:     Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        pshelar@ovn.org, "David S. Miller" <davem@davemloft.net>,
        ovs dev <dev@openvswitch.org>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 1, 2021 at 12:21 AM Nicolas Dichtel
<nicolas.dichtel@6wind.com> wrote:
>
> Le 30/09/2021 =C3=A0 18:11, Cpp Code a =C3=A9crit :
> > On Wed, Sep 29, 2021 at 6:19 AM Jakub Kicinski <kuba@kernel.org> wrote:
> >>
> >> On Wed, 29 Sep 2021 08:19:05 +0200 Nicolas Dichtel wrote:
> >>>> /* Insert a kernel only KEY_ATTR */
> >>>> #define OVS_KEY_ATTR_TUNNEL_INFO    __OVS_KEY_ATTR_MAX
> >>>> #undef OVS_KEY_ATTR_MAX
> >>>> #define OVS_KEY_ATTR_MAX            __OVS_KEY_ATTR_MAX
> >>> Following the other thread [1], this will break if a new app runs ove=
r an old
> >>> kernel.
> >>
> >> Good point.
> >>
> >>> Why not simply expose this attribute to userspace and throw an error =
if a
> >>> userspace app uses it?
> >>
> >> Does it matter if it's exposed or not? Either way the parsing policy
> >> for attrs coming from user space should have a reject for the value.
> >> (I say that not having looked at the code, so maybe I shouldn't...)
> >
> > To remove some confusion, there are some architectural nuances if we
> > want to extend code without large refactor.
> > The ovs_key_attr is defined only in kernel side. Userspace side is
> > generated from this file. As well the code can be built without kernel
> > modules.
> > The code inside OVS repository and net-next is not identical, but I
> > try to keep some consistency.
> I didn't get why OVS_KEY_ATTR_TUNNEL_INFO cannot be exposed to userspace.

OVS_KEY_ATTR_TUNNEL_INFO is compressed version of OVS_KEY_ATTR_TUNNEL
and for clarity purposes its not exposed to userspace as it will never
use it.
I would say it's a coding style as it would not brake anything if exposed.

>
> >
> > JFYI This is the file responsible for generating userspace part:
> > https://github.com/openvswitch/ovs/blob/master/build-aux/extract-odp-ne=
tlink-h
> > This is the how corresponding file for ovs_key_attr looks inside OVS:
> > https://github.com/openvswitch/ovs/blob/master/datapath/linux/compat/in=
clude/linux/openvswitch.h
> > one can see there are more values than in net-next version.
> There are still some '#ifdef __KERNEL__'. The standard 'make headers_inst=
all'
> filters them. Why not using this standard mechanism?

Could you elaborate on this, I don't quite understand the idea!? Which
ifdef you are referring, the one along OVS_KEY_ATTR_TUNNEL_INFO or
some other?

>
> In this file, there are two attributes (OVS_KEY_ATTR_PACKET_TYPE and
> OVS_KEY_ATTR_ND_EXTENSIONS) that doesn't exist in the kernel.
> This will also breaks if an old app runs over a new kernel. I don't see h=
ow it
> is possible to keep the compat between {old|new} {kernel|app}.

Looks like this most likely is a bug while working on multiple
versions of code.  Need to do add more padding.

>
>
> Regards,
> Nicolas
