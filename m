Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1244F2AA8A1
	for <lists+netdev@lfdr.de>; Sun,  8 Nov 2020 01:43:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728680AbgKHAnO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 Nov 2020 19:43:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726043AbgKHAnO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 7 Nov 2020 19:43:14 -0500
Received: from mail-lj1-x242.google.com (mail-lj1-x242.google.com [IPv6:2a00:1450:4864:20::242])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5390C0613CF;
        Sat,  7 Nov 2020 16:43:13 -0800 (PST)
Received: by mail-lj1-x242.google.com with SMTP id y25so4784048lja.9;
        Sat, 07 Nov 2020 16:43:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=dCChJ5ZSl/RZr19brXxPue8N9XgRog2mo+oIzDL+zH4=;
        b=Q10C4iB8VHfgvPEzzHV9LVPwrpZ0u4XhXLTWmlmgvRtJRTOj5MfM5/IkFCLQ3fkoct
         zLkTBwxMBSGpCn/BqxFswp7iNnnXJKAALGkTxYUcGXOcICeUKzdLwvZVWFwUh8dhyYLl
         R0zLIwJvGJ1wZOeq2GfWkntRyLT9hrVdBrJzEV5uMC5u2Q6OCuxhbzcVLqsXjYhjcPQh
         MNqkJSH2vlKJMKN/pJnu68Ip7D8uGtnxmr9/8PeCrU6+PlPzJSgOcRK0id8SI3QlJyHc
         +ahyiyUv2warRJDyMQ6SLgyU2kCBgvCWjZ4o6w3y/2EHYKG/5B827ozjotYJHjzk34fJ
         +OfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=dCChJ5ZSl/RZr19brXxPue8N9XgRog2mo+oIzDL+zH4=;
        b=VEiVxQZGFBj/Ox0RCxLRxzZe1o6QRD016ESnJ24EdtY5d7SIjwJvkgbtJ08MKbtIK2
         ritgeb1Zsd37FMQg4vo5l4593ZNVV6vUrX5GFlEHUDkiUoCiR9e7DIXgUb2u81+kSwkk
         RUgrTFyvloVzA/zmrkwBnYLg/NgJ4uBskPhCPUjYvWiyZuW5K21JVE5hjdkdOGWwQYIf
         qfcjOPP2vpzcfj3aO6nHohsNstRJwoFpfPpWwtBjojz6GDbaqp+Yv/AfNmSeTn820iKV
         WPbcKiikifzOuq0IOYGcUax7wrHURGNKkbvZHXSXRyi0IyTUbLwvhWHtnYMyHJ+4lb0r
         INrg==
X-Gm-Message-State: AOAM532MY+Xqmx38a+i1s5lkACEUcWf63KXQc5Yj2px6QDSfZ/u+LDs+
        rmg33BC4CKDXr9t9jyPjzOvqA9qn10308AvLomE=
X-Google-Smtp-Source: ABdhPJwMxxHJGUxG1SdOzMLokykLWftsgHLqhmv2rMK659iUfYWKxUK5Hz8YGs5BNWYIbEHay/JZzZS8xw8NqFXuTKg=
X-Received: by 2002:a2e:5d4:: with SMTP id 203mr3381837ljf.137.1604796192202;
 Sat, 07 Nov 2020 16:43:12 -0800 (PST)
MIME-Version: 1.0
References: <1604644960-48378-1-git-send-email-dong.menglong@zte.com.cn> <20201107154825.7e878d9a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201107154825.7e878d9a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Menglong Dong <menglong8.dong@gmail.com>
Date:   Sun, 8 Nov 2020 08:42:58 +0800
Message-ID: <CADxym3ZdNxB2p+QOuJq0FacHLbobMNSgOrYqZte_FBLfXsh+Qw@mail.gmail.com>
Subject: Re: [PATCH] net: ipv4: remove redundant initialization in inet_rtm_deladdr
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Menglong Dong <dong.menglong@zte.com.cn>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Dear Jakub,

On Sun, Nov 8, 2020 at 7:48 AM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Fri,  6 Nov 2020 01:42:37 -0500 menglong8.dong@gmail.com wrote:
> > From: Menglong Dong <dong.menglong@zte.com.cn>
> >
> > The initialization for 'err' with '-EINVAL' is redundant and
> > can be removed, as it is updated soon.
> >
> > Signed-off-by: Menglong Dong <dong.menglong@zte.com.cn>
>
> How many changes like this are there in the kernel right now?
>
> I'm afraid that if there are too many it's not worth the effort.
>
> Also - what tool do you use to find those, we need to make sure new
> instances don't get into the tree.
>

I didn't use any tools. Maybe some general tools, such as kw,
coverity, coccicheck,
are able to find these changes(as far as I know, they can).

In fact, I find these changes by my eyes. I believe 'err' is the most
likely victim
and checked every usage of it in 'net' directory. Here are all the
changes I found,
and I think there won't be too many.

Cheers,
Menglong Dong
