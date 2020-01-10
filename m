Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 77CB9136D3C
	for <lists+netdev@lfdr.de>; Fri, 10 Jan 2020 13:42:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728226AbgAJMmb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jan 2020 07:42:31 -0500
Received: from mail-wm1-f42.google.com ([209.85.128.42]:36735 "EHLO
        mail-wm1-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727912AbgAJMmb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jan 2020 07:42:31 -0500
Received: by mail-wm1-f42.google.com with SMTP id p17so1839509wma.1;
        Fri, 10 Jan 2020 04:42:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=yTt5XdK0kAp6RZsjOuMjHlFFoxc/QKYaDuzmbXs0yDM=;
        b=T8+hHlkVeFkqMZJZUIJnAGzv4baxM6c6riELQ+FAiuro+7gYOrT3/CP7C+mUkbK2E5
         4jFb8G/ttG2dHjQ26aS7I9XLhEFczIIxrGE0Nb2JM7x9xX0yomHn5cp/9k2iuA7+oMCa
         5xO7hDAf8hIIuUMXj4xJkU9tJyQ4oFz4xt994/0KEV35Tko4MDZByX7Vi0zFtmRbv8eQ
         BVsVRw/wEjBOFI3x+CyMawOWKHHxAfjIWW02L5fWGYZBz3CAbUii8IBpK/jqi+ydengr
         HR/C9isfNrShYiu6TsOAO8O71Er5fU+mwYSsnZS/BIELuRjP5njbPdp4W5rsrzOKXvQe
         ojnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=yTt5XdK0kAp6RZsjOuMjHlFFoxc/QKYaDuzmbXs0yDM=;
        b=Yw0eJKdmOXjwqRIWaG+fkHpuJzap6qrElwK9xLVMHXqCoLPmzp6pfNy4MEVaFKt0Rk
         Qdt5cUlAqbCyPOxmtTTL2vaYKrGxir66b64gFrKVP25dlKVqet1nyZkxCb5+EToReBTa
         ucHmbdxiDwcnKRyhgBtt8QrWtvIuyi78JIK9/D/TKr37vxhn2ZWv5v5O/5KugnpVkmI7
         PY5gPRYYRrINJMtXMQqezOBIbcjxz460563nLD2e7yLVLV9EEhaEFxW00BzWn5bHMKfg
         Ao7hX4jOLR1/3d2zee+3NJqdukJpbdYRrAE1PGYBSAcSsNepwnI76UPJm9jyWtN6AAa1
         sY1A==
X-Gm-Message-State: APjAAAVeSIWqJVfXqkwXN89V1vato3jmaRu57C7xZ0nGj8X4EDwFy+MJ
        aOd3LOMBrWM88bQNldVamQgIn88TjvzGEn1QVSyOaw==
X-Google-Smtp-Source: APXvYqx+++pfU65FjHfva/gsZ7cKLJZcYgmt6SyhpdnHe6T+mPRuEZSkZhGB3SsoCWazxszk2CyUyYvEjXjsLNN3HAI=
X-Received: by 2002:a05:600c:cd:: with SMTP id u13mr4192384wmm.24.1578660148813;
 Fri, 10 Jan 2020 04:42:28 -0800 (PST)
MIME-Version: 1.0
References: <CAA5aLPgz2Pzi5qNZkHwtN=fEXEwRpCQYFUkEzRWkdT39+YNWFA@mail.gmail.com>
 <875zpvvsar.fsf@toke.dk> <CAA5aLPhrDbqJqfVVBWfCZ6TK0ZFMOSsqxK9DS9D1cd4GZJ0ctw@mail.gmail.com>
 <87muj6tusy.fsf@toke.dk>
In-Reply-To: <87muj6tusy.fsf@toke.dk>
From:   Akshat Kakkar <akshat.1984@gmail.com>
Date:   Fri, 10 Jan 2020 18:12:16 +0530
Message-ID: <CAA5aLPjK3bqFoyWQY8xpN6mKyO3S_nRh0+W1i4rW+dfF7KmZYw@mail.gmail.com>
Subject: Re: Cake not doing rate limiting in a way it is expected to do
To:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
Cc:     netdev <netdev@vger.kernel.org>, lartc <lartc@vger.kernel.org>,
        cake@lists.bufferbloat.net
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Toke,
I will try to rebuild my setup and then get back to you. I was off due
to an injury.

Thanks,

On Tue, May 28, 2019 at 9:50 PM Toke H=C3=B8iland-J=C3=B8rgensen <toke@redh=
at.com> wrote:
>
> Akshat Kakkar <akshat.1984@gmail.com> writes:
>
> > It's a controlled lab setup. Users connected to eno2 and server on eno1=
.
> > Link speed 1Gbps.
> > No ingress shaping.
> > Simple http download.
> >
> > I am having multiple rates requirement for multiple user groups, which
> > I am controlling using various classes and thus using htb.
>
> Well, CAKE has its own built-in shaper, so it hasn't seen much testing
> with HTB as a parent. Theoretically it *should* work, though, as long as
> CAKE is running in unlimited mode.
>
> Could you please share your full config, and the output of `tc -s qdisc`
> after a run?
>
> Thanks,
>
> -Toke
