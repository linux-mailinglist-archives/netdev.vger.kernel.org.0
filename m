Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9DCB32BB636
	for <lists+netdev@lfdr.de>; Fri, 20 Nov 2020 21:05:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729941AbgKTUDF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Nov 2020 15:03:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729673AbgKTUDE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Nov 2020 15:03:04 -0500
Received: from mail-yb1-xb2d.google.com (mail-yb1-xb2d.google.com [IPv6:2607:f8b0:4864:20::b2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72686C0613CF;
        Fri, 20 Nov 2020 12:03:04 -0800 (PST)
Received: by mail-yb1-xb2d.google.com with SMTP id s8so9625500yba.13;
        Fri, 20 Nov 2020 12:03:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=7fqPLQEFFb+30cv5hRu417jliDYJU1gr9SR+smm/nlA=;
        b=mVJRrIt7lNN8CGdZoBvgoQpYSdgK0pfYBLiUFGOPRyEmAXpqMmzVJfhPkd4fUBcz6m
         vQV3ZzU6uLnwCJlABIhOkNbc4gKmeDqy8jQr3sxKvEOHBUJhvJVYcTg2pQ90Cx4a90oe
         4HHpgxnPxsJk3exyWx2n/6CELJYS6g67rk4JUNIsBjY3/ulJU83kwTbcqUpnDft+zKIk
         OkoFJgeq5IHfhoIHNFlMWMmdO000sKcv4Yy8H+4gVow321XbHDdFa2r2gt0FK29Fuh8Q
         uMGVsasMWgYPmb9ck75e+qZpPDZQlPOLLn3mPNicCgxIxtnm7kX+c36BKfeZbLkiqaVU
         TzYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=7fqPLQEFFb+30cv5hRu417jliDYJU1gr9SR+smm/nlA=;
        b=mXHpcmYk3hn3ikl7h8If9EgfEwQP2cde/b8pLsy3ntvMiNAPElAALD+AeIauUhPag9
         w0Jzu1fPm9yw6LU4yhaJJf19RgBtu4Np5tdytuh5nknHKZi4WVzzp8ymFIBl0qSZca9d
         lWENq+SFBNsRzkRYP5YjamdTDu4yqyFJnieYM5MaIF+7YzKA8FVnCW7/lqV2PoVLozkg
         l2eK1zEks5CRAEowyBfoNZ+eedbIfL6JrVALV8MuLK6+aEgHcCMNVNVmDw5nIBk4drZd
         x7LzYhvlks7lP5HZeZlfFoHHmJ6cG150Zzm5ljMs1OHG458i7pEJ8+PkfyVmPG7a/UMB
         MFgw==
X-Gm-Message-State: AOAM532yMYImqLmyMYFZKUOWbJpOBs/YeIfdWPutm1ThRJmhqQ5QTodJ
        /REMQ7wW8l/o8V8zAwDuh85AACjKD34FVlnG2AI=
X-Google-Smtp-Source: ABdhPJyTL2JUuHRhyKqsCA40H4wzpjo+coWeGY8JK7nwSgn9KmUYvmDwbHDpplv6hSAZ2ZycK6Nw3I4kyf03eg4h6Jg=
X-Received: by 2002:a25:7717:: with SMTP id s23mr29244152ybc.459.1605902583683;
 Fri, 20 Nov 2020 12:03:03 -0800 (PST)
MIME-Version: 1.0
References: <87y2iwqbdg.fsf@toke.dk>
In-Reply-To: <87y2iwqbdg.fsf@toke.dk>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 20 Nov 2020 12:02:52 -0800
Message-ID: <CAEf4BzaYPXKCSUX50UrkvbGZ+Ne_YqHLfcgtXzwWFpCvugC8jg@mail.gmail.com>
Subject: Re: Is test_offload.py supposed to work?
To:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
Cc:     Jakub Kicinski <kuba@kernel.org>, Jiri Pirko <jiri@mellanox.com>,
        bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 20, 2020 at 7:49 AM Toke H=C3=B8iland-J=C3=B8rgensen <toke@redh=
at.com> wrote:
>
> Hi Jakub and Jiri
>
> I am investigating an error with XDP offload mode, and figured I'd run
> 'test_offload.py' from selftests. However, I'm unable to get it to run
> successfully; am I missing some config options, or has it simply
> bit-rotted to the point where it no longer works?
>

See also discussion in [0]

  [0] https://www.spinics.net/lists/netdev/msg697523.html

> [root@(none) bpf]# ./test_offload.py
> Test destruction of generic XDP...
> Test TC non-offloaded...
> Test TC non-offloaded isn't getting bound...
> Test TC offloads are off by default...
> FAIL: Missing or incorrect netlink extack message
>   File "./test_offload.py", line 836, in <module>
>     check_extack(err, "TC offload is disabled on net device.", args)
>   File "./test_offload.py", line 657, in check_extack
>     fail(not comp, "Missing or incorrect netlink extack message")
>   File "./test_offload.py", line 86, in fail
>     tb =3D "".join(traceback.extract_stack().format())
>
>
> Commenting out that line gets me a bit further:
>
> [root@(none) bpf]# ./test_offload.py
> Test destruction of generic XDP...
> Test TC non-offloaded...
> Test TC non-offloaded isn't getting bound...
> Test TC offloads are off by default...
> Test TC offload by default...
> Test TC cBPF bytcode tries offload by default...
> Test TC cBPF unbound bytecode doesn't offload...
> Test non-0 chain offload...
> FAIL: Missing or incorrect netlink extack message
>   File "./test_offload.py", line 876, in <module>
>     check_extack(err, "Driver supports only offload of chain 0.", args)
>   File "./test_offload.py", line 657, in check_extack
>     fail(not comp, "Missing or incorrect netlink extack message")
>   File "./test_offload.py", line 86, in fail
>     tb =3D "".join(traceback.extract_stack().format())
>
>
> And again, after which I gave up:
>
> [root@(none) bpf]# ./test_offload.py
> Test destruction of generic XDP...
> Test TC non-offloaded...
> Test TC non-offloaded isn't getting bound...
> Test TC offloads are off by default...
> Test TC offload by default...
> Test TC cBPF bytcode tries offload by default...
> Test TC cBPF unbound bytecode doesn't offload...
> Test non-0 chain offload...
> Test TC replace...
> Test TC replace bad flags...
> Test spurious extack from the driver...
> Test TC offloads work...
> FAIL: Missing or incorrect message from netdevsim in verifier log
>   File "./test_offload.py", line 920, in <module>
>     check_verifier_log(err, "[netdevsim] Hello from netdevsim!")
>   File "./test_offload.py", line 671, in check_verifier_log
>     fail(True, "Missing or incorrect message from netdevsim in verifier l=
og")
>   File "./test_offload.py", line 86, in fail
>     tb =3D "".join(traceback.extract_stack().format())
>
> -Toke
>
