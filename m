Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3791F1383BF
	for <lists+netdev@lfdr.de>; Sat, 11 Jan 2020 22:53:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731554AbgAKVxr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Jan 2020 16:53:47 -0500
Received: from mail-ot1-f51.google.com ([209.85.210.51]:44658 "EHLO
        mail-ot1-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731549AbgAKVxr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 11 Jan 2020 16:53:47 -0500
Received: by mail-ot1-f51.google.com with SMTP id h9so5491420otj.11
        for <netdev@vger.kernel.org>; Sat, 11 Jan 2020 13:53:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=p2+prck3fTAOLxZxLml10K6KNGhNGC7LWQKEQtK4bP4=;
        b=kgovbnkpuHntxVnVGexD7aY71323M4p0RPHiMVELEBgfExkjxCCuRnlqbCBwazZCHy
         /PmU/Z2BzFUVMlmHfomlxf5reVvCrA6ttbUQc1Ph7da/3tuG8KOdYBxjcsby8lCd+0mX
         rLkujp8SGCPTWV+iDLg8moEpambKKCm6H4Gqa8Msr6MHX09Rkzyx23uao4GPH900LjZi
         LtPAwg6wa0Uk56M/KphcLMt9jTDoyvB001mc/ASK8h5fHO/jGyoJdu5FqA460MFjAZHb
         BoiHyb8XIZytVsYDFl2V+vcx5C+ymjMOrKqF8OYdCWaQJih9w+6X3tuJjCdmP7hAiIt8
         0Rew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=p2+prck3fTAOLxZxLml10K6KNGhNGC7LWQKEQtK4bP4=;
        b=I6X6kY7QGnYVQnz0R1Hd9Ecjc8b4K6qEFuPrPgw3hNEmiGfEYsuy/jGFQYNkzcIJsM
         AzMJPNKrnnFyP0wESn0K8a3oMs5L3Npc+DMULI7JzZwGtrAlACVJjUOgIAlvP2w4/nV6
         6ebLA2q2FuTDzb+zmDCOTxLt8yXnhVx2eFd7e7u7z9YlkY7meuQm77qmWj1zZOuCJDlN
         mm3rWgiK0jBv2JEUZPiDrDbvvkZQKnOCZE7w+8Y6xzKQJ7GVqWi/X5jcho6ZaxFxnBU+
         mk/dTHjBjeMHh/wcJklJuw9ozZtSRCj7GzbuWK0YTu+4MYxeDyeX+rjrb+W4l1POOceV
         v8jg==
X-Gm-Message-State: APjAAAVNs8tfGMpp/O404G2Nl8YgZ1UjsobiahExWyHS+DFR+ipGuMak
        W6sW0p4RBiLVv8gRMJUsTi6Dfdw4t30gYalzxoo=
X-Google-Smtp-Source: APXvYqzVjOwOKNAw8vzQLETvrftyIlBED73lXcWQeJNGzr2RZ7xS7A8VGNxGaF2opO67Ngd6EGteIdh01hhuqibc9wY=
X-Received: by 2002:a9d:53c4:: with SMTP id i4mr8423500oth.48.1578779626667;
 Sat, 11 Jan 2020 13:53:46 -0800 (PST)
MIME-Version: 1.0
References: <000000000000ab3f800598cec624@google.com> <000000000000802598059b6c7989@google.com>
 <CAM_iQpX7-BF=C+CAV3o=VeCZX7=CgdscZaazTD6QT-Tw1=XY9Q@mail.gmail.com>
 <CAMArcTXTtJB8WUuJUumP2NHVg_c19m-6EheC3JRGxzseYmHVDw@mail.gmail.com>
 <CAM_iQpVJiYHnhUJKzQpoPzaUhjrd=O4WR6zFJ+329KnWi6jJig@mail.gmail.com>
 <CAMArcTVPrKrhY63P=VgFuTQf0wUNO_9=H2R96p08-xoJ+mbZ5w@mail.gmail.com>
 <CAM_iQpX-S7cPvYTqAMkZF=avaoMi_af70dwQEiC37OoXNWA4Aw@mail.gmail.com>
 <CAMArcTUFK6TUYP+zwD3009m126fz+S-cAT5CN5pZ3C5axErh8g@mail.gmail.com>
 <CAM_iQpUpZLcsC2eYPGO-UCRf047FTvP-0x8hQnDxRZ-w3vL9Tg@mail.gmail.com> <CAMArcTV66StxE=Pjiv6zsh0san039tuVvsKNE2Sb=7+jJ3xEdQ@mail.gmail.com>
In-Reply-To: <CAMArcTV66StxE=Pjiv6zsh0san039tuVvsKNE2Sb=7+jJ3xEdQ@mail.gmail.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Sat, 11 Jan 2020 13:53:35 -0800
Message-ID: <CAM_iQpU9EXx7xWAaps2E3DWiZbt25ByCK4sR=njYMHF=KsvLFg@mail.gmail.com>
Subject: Re: WARNING: bad unlock balance in sch_direct_xmit
To:     Taehee Yoo <ap420073@gmail.com>
Cc:     syzbot <syzbot+4ec99438ed7450da6272@syzkaller.appspotmail.com>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 9, 2020 at 10:02 PM Taehee Yoo <ap420073@gmail.com> wrote:
> ndo_get_lock_subclass() was used to calculate subclass which was used by
> netif_addr_lock_nested().
>
> -static inline void netif_addr_lock_nested(struct net_device *dev)
> -{
> -       int subclass = SINGLE_DEPTH_NESTING;
> -
> -       if (dev->netdev_ops->ndo_get_lock_subclass)
> -               subclass = dev->netdev_ops->ndo_get_lock_subclass(dev);
> -
> -       spin_lock_nested(&dev->addr_list_lock, subclass);
> -}
>
> The most important thing about nested lock is to get the correct subclass.
> nest_level was used as subclass and this was calculated by
> ->ndo_get_lock_subclass().
> But, ->ndo_get_lock_subclass() didn't calculate correct subclass.
> After "master" and "nomaster" operations, nest_level should be updated
> recursively, but it didn't. So incorrect subclass was used.
>
> team3 <-- subclass 0
>
> "ip link set team3 master team2"
>
> team2 <-- subclass 0
> team3 <-- subclass 1
>
> "ip link set team2 master team1"
>
> team1 <-- subclass 0
> team3 <-- subclass 1
> team3 <-- subclass 1
>
> "ip link set team1 master team0"
>
> team0 <-- subclass 0
> team1 <-- subclass 1
> team3 <-- subclass 1
> team3 <-- subclass 1
>
> After "master" and "nomaster" operation, subclass values of all lower or
> upper interfaces would be changed. But ->ndo_get_lock_subclass()
> didn't update subclass recursively, lockdep warning appeared.
> In order to fix this, I had two ways.
> 1. use dynamic keys instead of static keys.
> 2. fix ndo_get_lock_subclass().
>
> The reason why I adopted using dynamic keys instead of fixing
> ->ndo_get_lock_subclass() is that the ->ndo_get_lock_subclass() isn't
> a common helper function.
> So, driver writers should implement ->ndo_get_lock_subclass().
> If we use dynamic keys, ->ndo_get_lock_subclass() code could be removed.
>

The details you provide here are really helpful for me to understand
the reasons behind your changes. Let me think about this and see how
I could address both problems. This appears to be harder than I originally
thought.

>
> What I fixed problems with dynamic lockdep keys could be fixed by
> nested lock too. I think if the subclass value synchronization routine
> works well, there will be no problem.

Great! We are on the same page.

Thanks for all the information and the reproducer too!
