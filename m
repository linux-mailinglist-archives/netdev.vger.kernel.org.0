Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A811010D11E
	for <lists+netdev@lfdr.de>; Fri, 29 Nov 2019 06:50:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726741AbfK2Fqb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Nov 2019 00:46:31 -0500
Received: from mail-il1-f196.google.com ([209.85.166.196]:34184 "EHLO
        mail-il1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726164AbfK2Fqb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Nov 2019 00:46:31 -0500
Received: by mail-il1-f196.google.com with SMTP id p6so26010831ilp.1;
        Thu, 28 Nov 2019 21:46:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=UeukSdDwiiSgiJFebwv7o38ymarkZLCclxi9kT/TLJY=;
        b=jBqgi2OXhM53PJuTTmroI75k72bCJvOHMHV08+HLesmvLcf18N2XkDVZzREOvbqnhj
         WREf6z8VvKHVJjKsia7IhwSv9I1iVh28cArodmOgq9Mye7SOXK7omsqhvnIVlKPSWzaK
         Anf/SClsiR7/m9uIPQ8i2abUzGeoguiF9FQTWmbbHQsjX06bkoG0cOVGgowF5bt8TFvc
         Rt0LYK0rKIcehlGh6W/rtE7gwvdmQnTEI9mqvmOPmGe/wIXNPbJKt92n05tnq2rSjZTE
         BOeEuFbuV7canqF58bE/pVaQFDCve77ktRTtR9+ue2FE2zGxI9h0K/v3sOhtgdln8El8
         zssQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=UeukSdDwiiSgiJFebwv7o38ymarkZLCclxi9kT/TLJY=;
        b=MEqxLje1MTLdWyDyGANbaXhI2BCwu2XP76BQ+e87L3BGjjmAYoZ5nvB/biLcGfZY0X
         DZqCwLhVUe5V/pKEvHiGZlVBCZhAZECjIRZf418eD1qfDB+QcUA6ReX551+AKEhKSxzE
         fWaVVsqdBN9IIpoKgOEvG1f/Lsz+P1G9sKV3fAjWnkKvDF48BvtXE62C4TrJkyNm/PW9
         SRiB18u0ekjbBs+3jbNLpxUHGsWWItuAGotqZlUe48N+9uph9vVpwkliVOnAUFquLn/U
         UV/eZLa6KrwHq16p+gLu4DZ1s2YOe8+KAZKhNkU6I3CvYPPiA3LQZdle3ZEotAWux6Fz
         JSNg==
X-Gm-Message-State: APjAAAVGA9zDFM4hpj4b31wWorTs5HDD8TCWpcXsW765sy2CI+uKckM/
        iXHmq7L7SDgtqDwVj9zP5ZJi2aX6lB1kRnHGw+w=
X-Google-Smtp-Source: APXvYqx9/KH+KOpP7pYSBhLZwgrvZVqIKBHf0wQdTXvrM6coKa20viLyZHeeJfy0W9pcVdtF96C02BM82HTYDbiKKV4=
X-Received: by 2002:a92:d450:: with SMTP id r16mr8533331ilm.147.1575006390301;
 Thu, 28 Nov 2019 21:46:30 -0800 (PST)
MIME-Version: 1.0
References: <20191127203114.766709977@linuxfoundation.org> <CA+G9fYuAY+14aPiRVUcXLbsr5zJ-GLjULX=s9jcGWcw_vb5Kzw@mail.gmail.com>
 <20191128073623.GE3317872@kroah.com>
In-Reply-To: <20191128073623.GE3317872@kroah.com>
From:   Lukas Bulwahn <lukas.bulwahn@gmail.com>
Date:   Fri, 29 Nov 2019 06:46:23 +0100
Message-ID: <CAKXUXMy_=gVVw656AL5Rih_DJrdrFLoURS-et0+dpJ2cKaw6SQ@mail.gmail.com>
Subject: Re: [PATCH 4.19 000/306] 4.19.87-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Naresh Kamboju <naresh.kamboju@linaro.org>,
        open list <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Shuah Khan <shuah@kernel.org>, patches@kernelci.org,
        Ben Hutchings <ben.hutchings@codethink.co.uk>,
        lkft-triage@lists.linaro.org,
        linux- stable <stable@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        =?UTF-8?Q?Jouni_H=C3=B6gander?= <jouni.hogander@unikie.com>,
        "David S. Miller" <davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 28, 2019 at 8:37 AM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> On Thu, Nov 28, 2019 at 12:23:41PM +0530, Naresh Kamboju wrote:
> > On Thu, 28 Nov 2019 at 02:25, Greg Kroah-Hartman
> > <gregkh@linuxfoundation.org> wrote:
> > >
> > > This is the start of the stable review cycle for the 4.19.87 release.
> > > There are 306 patches in this series, all will be posted as a response
> > > to this one.  If anyone has any issues with these being applied, please
> > > let me know.
> > >
> > > Responses should be made by Fri, 29 Nov 2019 20:18:09 +0000.
> > > Anything received after that time might be too late.
> > >
> > > The whole patch series can be found in one patch at:
> > >         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.87-rc1.gz
> > > or in the git tree and branch at:
> > >         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
> > > and the diffstat can be found below.
> > >
> > > thanks,
> > >
> > > greg k-h
> >
> > Kernel BUG noticed on x86_64 device while booting 4.19.87-rc1 kernel.
> >
> > The problematic patch is,
> >
> > > Jouni Hogander <jouni.hogander@unikie.com>
> > >     net-sysfs: Fix reference count leak in rx|netdev_queue_add_kobject
> >
> > And this kernel panic is been fixed by below patch,
> >
> > commit 48a322b6f9965b2f1e4ce81af972f0e287b07ed0
> > Author: Eric Dumazet <edumazet@google.com>
> > Date:   Wed Nov 20 19:19:07 2019 -0800
> >
> >     net-sysfs: fix netdev_queue_add_kobject() breakage
> >
> >     kobject_put() should only be called in error path.
> >
> >     Fixes: b8eb718348b8 ("net-sysfs: Fix reference count leak in
> > rx|netdev_queue_add_kobject")
> >     Signed-off-by: Eric Dumazet <edumazet@google.com>
> >     Cc: Jouni Hogander <jouni.hogander@unikie.com>
> >     Signed-off-by: David S. Miller <davem@davemloft.net>
>
> Now queued up, I'll push out -rc2 versions with this fix.
>
> greg k-h

We have also been informed about another regression these two commits
are causing:

https://lore.kernel.org/lkml/ace19af4-7cae-babd-bac5-cd3505dcd874@I-love.SAKURA.ne.jp/

I suggest to drop these two patches from this queue, and give us a
week to shake out the regressions of the change, and once ready, we
can include the complete set of fixes to stable (probably in a week or
two).

Lukas
