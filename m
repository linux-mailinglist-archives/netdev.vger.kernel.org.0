Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C8BBA1163E0
	for <lists+netdev@lfdr.de>; Sun,  8 Dec 2019 22:35:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726761AbfLHVf3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 8 Dec 2019 16:35:29 -0500
Received: from mail-lj1-f196.google.com ([209.85.208.196]:43466 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726661AbfLHVf2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 8 Dec 2019 16:35:28 -0500
Received: by mail-lj1-f196.google.com with SMTP id a13so13326837ljm.10
        for <netdev@vger.kernel.org>; Sun, 08 Dec 2019 13:35:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=uSATXKDDmvR07T7kUi8rHi7RN+bAfLLpofRbY4BLnYc=;
        b=QDp02WtOAAN8JLUWqKZ1RMBdvq52AFxQlA60k5ue1vPtqtI974JZyKwoY75VqFwxG5
         wUDgZAaIsmJW7fwWatKJDfq6JFa//u0FMI769Ck5v6nuPBk6RQObsYioypzjwB8qy/O7
         ieejU5X44533UrSnW+Luvu+jyOKat8deoXhas=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=uSATXKDDmvR07T7kUi8rHi7RN+bAfLLpofRbY4BLnYc=;
        b=FVYHGOrm+Ze1TbWG1pfbF5xzSPJ1zVVD1m9mEJ9Kfev0ElS4kIgBFQzh2cFrcZ2/VG
         6f1xzDuYzMOSWiv7tk7EGHDZsNjiJEc67Y2KZDlwgeJ/TXPsaLDprfn9E5W6sq+JjklH
         8SwkjR9OLAFeSC2S+o24mqd/UjTbaCHvpMM+g1yfRhZaO/7xNSscjDXOklA9lrXcEdW/
         cy2zkTKQngDtITkGAAjGV3vrXbaTPNUubXeRjuURivEe1/B6PHK4VNGJLtwqRU7qma/D
         y1M5Jni2/c5aE1ZdlU4aAv4V5whtYhQEYsPknTCai+1QkKfBJDSXiwQ975QHot1WAlHq
         PmaA==
X-Gm-Message-State: APjAAAVWr5r/7h/b1bdw2dfmpKb25WfIh/QhmkzPfSFsQi0UJy1paedv
        /WZj78/MuwfTvAW3pGHD4jwtoyDBNQg=
X-Google-Smtp-Source: APXvYqzwRpnc8Q1InT645lynN24wDUvaEzrmWaDWrf4Gh2csQFeCuiKiv9Gf37fBq3Cdj6Qofbbu/w==
X-Received: by 2002:a2e:3c1a:: with SMTP id j26mr14565964lja.79.1575840926167;
        Sun, 08 Dec 2019 13:35:26 -0800 (PST)
Received: from mail-lj1-f176.google.com (mail-lj1-f176.google.com. [209.85.208.176])
        by smtp.gmail.com with ESMTPSA id i19sm5759442lfj.17.2019.12.08.13.35.24
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 08 Dec 2019 13:35:25 -0800 (PST)
Received: by mail-lj1-f176.google.com with SMTP id e10so13339748ljj.6
        for <netdev@vger.kernel.org>; Sun, 08 Dec 2019 13:35:24 -0800 (PST)
X-Received: by 2002:a2e:86c4:: with SMTP id n4mr10154411ljj.97.1575840924390;
 Sun, 08 Dec 2019 13:35:24 -0800 (PST)
MIME-Version: 1.0
References: <20191208.012032.1258816267132319518.davem@redhat.com>
In-Reply-To: <20191208.012032.1258816267132319518.davem@redhat.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Sun, 8 Dec 2019 13:35:08 -0800
X-Gmail-Original-Message-ID: <CAHk-=widRc30Mcec8EwqxuMFr+dAFpM4gJjdVOKWJog4T60qKA@mail.gmail.com>
Message-ID: <CAHk-=widRc30Mcec8EwqxuMFr+dAFpM4gJjdVOKWJog4T60qKA@mail.gmail.com>
Subject: Re: [GIT] Networking
To:     David Miller <davem@redhat.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Netdev <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Dec 8, 2019 at 1:20 AM David Miller <davem@redhat.com> wrote:
>
>   git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git

Grr,

This introduces a new warning for me:

    drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun.c: In function
=E2=80=98mlx5e_tc_tun_create_header_ipv6=E2=80=99:
    drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun.c:332:20:
warning: =E2=80=98n=E2=80=99 may be used uninitialized in this function
[-Wmaybe-uninitialized]
      332 |  struct neighbour *n;
          |                    ^

which is very annoying.

The cause is commit 6c8991f41546 ("net: ipv6_stub: use
ip6_dst_lookup_flow instead of ip6_dst_lookup") which changed
mlx5e_route_lookup_ipv6() to use ipv6_dst_lookup_flow() which returns
an error pointer, so it then does

        if (IS_ERR(dst))
                return PTR_ERR(dst);

instead of

        if (ret < 0)
                return ret;

in the old code.

And that then means that the caller, which does

        err =3D mlx5e_route_lookup_ipv6(priv, mirred_dev, &out_dev, &route_=
dev,
                                      &fl6, &n, &ttl);
        if (err)
                return err;

and now gcc no longer sees that 'n' is always initialized when 'err'
is zero. Because gcc apparently thinks that the

        if (IS_ERR(dst))
                return PTR_ERR(dst);

thing can result in a zero return value (I guess the cast from a
64-bit pointer to an 'int' is where it thinks "ok, that cast might
lose high bits and become zero even when the original was tested to
have a range where that will not happen).

Anyway - the code is not buggy, but the new warning is simply not
acceptable. We keep the build warning free even if it's gcc not being
clever enough to see that "if it's uninitialized, we never get to the
location where it's used".

I don't know what the networking pattern for this is, but I did this
in the merge

--      struct neighbour *n;
++      struct neighbour *n =3D NULL;

and I'm not happy about having gotten a pull request that has this
kind of shit in it, especially since it was _known_ shit.

It could have been that people had compilers that didn't see this
problem. But no.

I see that Stephen Rothwell reported it four days ago, and David seems
to have even answered it.

And yet that warning was still there in the pull request.

WTF?

David, this is not acceptable.  You don't introduce new warnings in the tre=
e.

It doesn't matter one whit whether the warning is a false positive. A
false positive warning will then be the cause of ignoring subsequent
real warnings, which makes false positive warnings completely
unacceptable.

Fix your mindset, and stop sending me garbage.

                   Linus
