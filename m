Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0A7F716632E
	for <lists+netdev@lfdr.de>; Thu, 20 Feb 2020 17:34:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728769AbgBTQeF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Feb 2020 11:34:05 -0500
Received: from frisell.zx2c4.com ([192.95.5.64]:53143 "EHLO frisell.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728515AbgBTQeE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 20 Feb 2020 11:34:04 -0500
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTP id 70d3bb9f
        for <netdev@vger.kernel.org>;
        Thu, 20 Feb 2020 16:31:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=zx2c4.com; h=mime-version
        :references:in-reply-to:from:date:message-id:subject:to:cc
        :content-type; s=mail; bh=yVRwtw6kJ2XMj4V4P4PtGVoDGHo=; b=qrOCKk
        X43atkuXWccjJkbr1AotsRzCugYKFhmNCFSaq4qcA2vly9ebxRoldh8h494xJqgd
        Q9CoLl/rnxqa9+sOw9KsEfvIzGLPRlL3hUVQsazYzIVjU7sZj2FctYXeKFeqdw/4
        DI23z6ZAMW9Zd/etZ8PyeQFT72wGiloRZYyL/MXMySEQ7QgrwlpYvCPKyPWWNn12
        48w7XGIp9+3WC2cMoQWTVudEptypFmuInX2Y/EJdyd8E6yxyHIR49ppr5Hv0I+vP
        dKWODFPM5LRYqO7ZO3gVKKOnfQeuXnmBlwpXeUqHg2SpawJvXziOTMuwP8pexmDY
        HA2qitAmXOJJcg+A==
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 23b5d75b (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256:NO)
        for <netdev@vger.kernel.org>;
        Thu, 20 Feb 2020 16:31:08 +0000 (UTC)
Received: by mail-ot1-f49.google.com with SMTP id 66so4221231otd.9
        for <netdev@vger.kernel.org>; Thu, 20 Feb 2020 08:34:02 -0800 (PST)
X-Gm-Message-State: APjAAAWFikPZro4UbURU3Fvnvd5xQcl7ZivO9gwtxGVFYFvTrRUmYJBU
        x+vOhlEgsZ2HJyA7jV83y+CzDYatdsDDo0Isd9A=
X-Google-Smtp-Source: APXvYqx67ijbk1qY5//CpLPjuvRXVaxderY03uVmgvQgZGG1qigqoqpBarBdWMHoaZ6HYLw8NP1LifBzpfirR9gbJZQ=
X-Received: by 2002:a9d:7a47:: with SMTP id z7mr24978732otm.179.1582216442024;
 Thu, 20 Feb 2020 08:34:02 -0800 (PST)
MIME-Version: 1.0
References: <20191208232734.225161-1-Jason@zx2c4.com> <CACT4Y+bsJVmgbD-WogwU=LfWiPN1JgjBrwx4s8Y14hDd7vqqhQ@mail.gmail.com>
 <CAHmME9o0AparjaaOSoZD14RAW8_AJTfKfcx3Y2ndDAPFNC-MeQ@mail.gmail.com>
 <CACT4Y+Zssd6OZ2-U4kjw18mNthQyzPWZV_gkH3uATnSv1SVDfA@mail.gmail.com>
 <CAHmME9oM=YHMZyg23WEzmZAof=7iv-A01VazB3ihhR99f6X1cg@mail.gmail.com>
 <CACT4Y+aCEZm_BA5mmVTnK2cR8CQUky5w1qvmb2KpSR4-Pzp4Ow@mail.gmail.com>
 <CAHmME9rYstVLCBOgdMLqMeVDrX1V-f92vRKDqWsREROWdPbb6g@mail.gmail.com>
 <CAHmME9qUWr69o0r+Mtm8tRSeQq3P780DhWAhpJkNWBfZ+J5OYA@mail.gmail.com>
 <CACT4Y+YfBDvQHdK24ybyyy5p07MXNMnLA7+gq9axq-EizN6jhA@mail.gmail.com>
 <CAHmME9qcv5izLz-_Z2fQefhgxDKwgVU=MkkJmAkAn3O_dXs5fA@mail.gmail.com>
 <CACT4Y+arVNCYpJZsY7vMhBEKQsaig_o6j7E=ib4tF5d25c-cjw@mail.gmail.com>
 <CAHmME9ofmwig2=G+8vc1fbOCawuRzv+CcAE=85spadtbneqGag@mail.gmail.com>
 <CACT4Y+awD47=Q3taT_-yQPfQ4uyW-DRpeWBbSHcG6_=b20PPwg@mail.gmail.com>
 <CAHmME9q3_p_BX0BC6=urj4KeWLN2PvPgvGy3vQLFmd=qkNEkpQ@mail.gmail.com>
 <CACT4Y+bSBD_=rmGCF3mngiRKOfa7cv0odFaadF1wyEV9NVhQcg@mail.gmail.com>
 <CAHmME9pQQhQtg8JymxMbSMgnhZ9BpjEoTb=sSNndjp1rXnzi_Q@mail.gmail.com>
 <CAHmME9or-Wwx63ZtwYzOWV9KQJY1aarx2Eh8iF2P--BXfz6u+g@mail.gmail.com>
 <CACT4Y+a8N7_n4t_vxezKJVkd1+gDHaMzpeG18MuDE04+r3341A@mail.gmail.com>
 <CACT4Y+atqrSfZuquPZcRUKNtVbLdu+B5YN3=YmDb38Ruzj3Pzw@mail.gmail.com>
 <CACT4Y+bMzYZeMvv2DdTuTKtJFzTcHhinp7N7VmSiXqSBDyj8Ug@mail.gmail.com>
 <CACT4Y+bUXAstk41RPSF-EQDh7A8-XkTbc53nQTHt4DS5AUhr-A@mail.gmail.com>
 <CAHmME9pr4=cn5ijSNs05=fjdfQon49kyEzymkUREJ=xzTZ7Q7w@mail.gmail.com> <CACT4Y+aTBNZAekX_D+QdofqBdUuG9BkzLq+TFDxr8-sSqL9hdQ@mail.gmail.com>
In-Reply-To: <CACT4Y+aTBNZAekX_D+QdofqBdUuG9BkzLq+TFDxr8-sSqL9hdQ@mail.gmail.com>
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
Date:   Thu, 20 Feb 2020 17:33:50 +0100
X-Gmail-Original-Message-ID: <CAHmME9pSWRe8k3+4G45tWE9V+N3A9APN5KFq65S5D0JNvR2xxQ@mail.gmail.com>
Message-ID: <CAHmME9pSWRe8k3+4G45tWE9V+N3A9APN5KFq65S5D0JNvR2xxQ@mail.gmail.com>
Subject: Re: syzkaller wireguard key situation [was: Re: [PATCH net-next v2]
 net: WireGuard secure network tunnel]
To:     Dmitry Vyukov <dvyukov@google.com>
Cc:     netdev <netdev@vger.kernel.org>,
        syzbot <syzkaller@googlegroups.com>,
        WireGuard mailing list <wireguard@lists.zx2c4.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Dmitry,

On Thu, Feb 20, 2020 at 5:14 PM Dmitry Vyukov <dvyukov@google.com> wrote:
> I got some coverage in wg_netdevice_notification:
> https://imgur.com/a/1sJZKtp
>
> Or you mean the parts that are still red?

Yes, it's the red parts that interest me. Intermixing those with
various wireguard-specific netlink calls and setting devices up and
down and putting traffic through those sockets, in weird ways, could
dig up bugs.

> I think theoretically these parts should be reachable too because
> syzkaller can do unshare and obtain net ns fd's.
>
> It's quite hard to test because it just crashes all the time on known bugs.
> So maybe the most profitable way to get more coverage throughout the
> networking subsystem now is to fix the top layer of crashers ;)

Ahhh, interesting, so the issue is that syzkaller is finding too many
other networking stack bugs before it gets to being able to play with
wireguard. Shucks.

Jason
