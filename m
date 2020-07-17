Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E8A1223BB1
	for <lists+netdev@lfdr.de>; Fri, 17 Jul 2020 14:50:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726424AbgGQMuV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jul 2020 08:50:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726056AbgGQMuU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Jul 2020 08:50:20 -0400
Received: from mail-vs1-xe31.google.com (mail-vs1-xe31.google.com [IPv6:2607:f8b0:4864:20::e31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30B45C061755
        for <netdev@vger.kernel.org>; Fri, 17 Jul 2020 05:50:20 -0700 (PDT)
Received: by mail-vs1-xe31.google.com with SMTP id x13so4744512vsx.13
        for <netdev@vger.kernel.org>; Fri, 17 Jul 2020 05:50:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ZnPJAnA3DP5OlSmqrsdGzJVINqJx7/prUrXzRyKeRSg=;
        b=OVUlXeBiQZbXbcKV6f451hDmrNU2ZzTkOqlqhVtLxZ5MfXpuq4uFK3ac4j9/8caIoD
         E8jDyk9sfqHBS997bOnYTs5sOpNzOar2Rchs6c/ZYD1pdbP3LgWf3OLe+wCojop8LaNc
         4X/CdWN+wrxgMvOPS8EOqFTkflOs2GwM3/fLJlNAqFUUYj8u98IXFT2WJF/aSuvnRFAw
         ycrTgYGAd7o+vTJ5Jb/xsSX2J0rw4ZJrVZE2g1pszX6opNA9GaE3EGBW8fnhCQBSbRKL
         d8Yu4dheovXpju9GRKCdBXCyMSRPf8ndUEEhyhwBFWaEE6Of/LO641i0FrkHLy1Kll+T
         KYRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ZnPJAnA3DP5OlSmqrsdGzJVINqJx7/prUrXzRyKeRSg=;
        b=QsGJUPvwtZALWdCVTjpghvXTa3PDD9zf59nYuWpE5M7zdKab3TnYAh7jeATfIfQZPC
         9OJGQ32lDShdzEExk0ckQ6/9QisAlxQFloZHuxSIOKgpddho9nyjnWGnWnvjD3evt+kt
         rQFhJ+aHWudnoIZyvGhph9mWNpnj2xcD49bkQ8SnU6/cJNgNViQTPVzeUCMwRsP7CTbu
         LCC/UyCzingXYspft11iQeYpTdWJ/bULlUnui1+aab5cnPnJ+r8QW5ZKrKPaFfdkmN+P
         +9xthbrvvCI52kDgTb3kXldWH1LSebhW0v8h5nAePzeyH4BMCU271y2bPJEWsvfLj/rl
         5jGw==
X-Gm-Message-State: AOAM5325Y79T+PvIzmxD4ymG4TF52voNB70I1gKh2SCDu7FemFcxLL0P
        k2nlyokDdF7WlXNEIiLNNudLOfVB2Z+LVL2GvKs=
X-Google-Smtp-Source: ABdhPJwsZcGdR2t65PDxC9pIY82gf3FpXqpH6wAsXxUk+tJ+G08Y9a4mgMfvDQNchBryeqSoqyOJ3UWmJ7Kv1P1SNyQ=
X-Received: by 2002:a67:7ccd:: with SMTP id x196mr7111359vsc.224.1594990219191;
 Fri, 17 Jul 2020 05:50:19 -0700 (PDT)
MIME-Version: 1.0
References: <CAOAjy5T63wDzDowikwZXPTC5fCnPL1QbH9P1v+MMOfydegV30w@mail.gmail.com>
 <20200711162349.GL1014141@lunn.ch> <20200711192255.GO1551@shell.armlinux.org.uk>
 <CAOAjy5TBOhovCRDF7NC-DWemA2k5as93tqq3gOT1chO4O0jpiA@mail.gmail.com>
 <20200712132554.GS1551@shell.armlinux.org.uk> <CAOAjy5T0oNJBsjru9r7MPu_oO8TSpY4PKDg7whq4yBJE12mPaA@mail.gmail.com>
 <20200717092153.GK1551@shell.armlinux.org.uk>
In-Reply-To: <20200717092153.GK1551@shell.armlinux.org.uk>
From:   Martin Rowe <martin.p.rowe@gmail.com>
Date:   Fri, 17 Jul 2020 12:50:07 +0000
Message-ID: <CAOAjy5RNz8mGi4XjP_8x-aZo5VhXRFF446R7NgcQGEKWVpUV1Q@mail.gmail.com>
Subject: Re: bug: net: dsa: mv88e6xxx: unable to tx or rx with Clearfog GT 8K
 (with git bisect)
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
Cc:     Andrew Lunn <andrew@lunn.ch>, netdev@vger.kernel.org,
        davem@davemloft.net, vivien.didelot@gmail.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 17 Jul 2020 at 09:22, Russell King - ARM Linux admin
<linux@armlinux.org.uk> wrote:
> The key file is /sys/kernel/debug/mv88e6xxx.0/regs - please send the
> contents of that file.

$ cat regs.broken
    GLOBAL GLOBAL2 SERDES     0    1    2    3    4    5
 0:  c800       0    ffff  9e07 9e4f 100f 100f 9e4f 170b
 1:     0    803e    ffff     3    3    3    3    3 201f
 2:     0       0    ffff  ff00    0    0    0    0    0
 3:     0       0    ffff  3400 3400 3400 3400 3400 3400
 4:  40a8     258    ffff    7c  43f  43c  43c  43f 373f
 5:  1000     4f0    ffff     0    0    0    0    0    0
 6:     0    1f0f    ffff    7e   7c   7a   76   6e   5f
 7:     0    703f    ffff     1    0    0    0    0    0
 8:     0    7800    ffff  2080 2080 2080 2080 2080 2080
 9:     0    1500    ffff     1    1    1    1    1    1
 a:   509       0    ffff  8000    0    0    0    0    0
 b:  3000    31ff    ffff     1    2    4    8   10    0
 c:   207       0    ffff     0    0    0    0    0    0
 d:  3333     50f    ffff     0    0    0    0    0    0
 e:     1       4    ffff     0    0    0    0    0    0
 f:     3     f00    ffff  9100 9100 9100 9100 9100 dada
10:     0       0    ffff     0    0    0    0    0    0
11:     0       0    ffff     0    0    0    0    0    0
12:  5555       0    ffff     0    0    0    0    0    0
13:  5555     300    ffff     0    0    0    0    0    0
14:  aaaa       0    ffff     0    0    0    0    0    0
15:  aaaa       0    ffff     0    0    0    0    0    0
16:  ffff       0       0     0   33   33   33   33    0
17:  ffff       0    ffff     0    0    0    0    0    0
18:  fa41    15f6    ffff  3210 3210 3210 3210 3210 3210
19:     0       0    ffff  7654 7654 7654 7654 7654 7654
1a:   3ff       0    ffff     0    0    0    0 1ea0 a100
1b:   1fc    110f    ffff  8000 8000 8000 8000 8000 8000
1c:   7c0       0    ffff     0    0    0    0    0    0
1d:  1400       0    ffff     0    0    0    0    0    0
1e:     0       0    ffff  f000 f000 f000 f000 f000 f000
1f:     0       0    ffff     0   2f    0    0   2e    1

$ cat regs.reverted
    GLOBAL GLOBAL2 SERDES     0    1    2    3    4    5
 0:  c800       0    ffff  9e07 9e4f 100f 100f 9e4f 1f0b
 1:     0    803e    ffff     3    3    3    3    3 203f
 2:     0       0    ffff  ff00    0    0    0    0    0
 3:     0       0    ffff  3400 3400 3400 3400 3400 3400
 4:  40a8     258    ffff    7c  43d  43c  43c  43f 373f
 5:  1000     4f0    ffff     0    0    0    0    0    0
 6:     0    1f0f    ffff    7e   7c   7a   76   6e   5f
 7:     0    703f    ffff     1    0    0    0    0    0
 8:     0    7800    ffff  2080 2080 2080 2080 2080 2080
 9:     0    1500    ffff     1    1    1    1    1    1
 a:   509       0    ffff  8000    0    0    0    0    0
 b:  3000    31ff    ffff     1    2    4    8   10    0
 c:   207       0    ffff     0    0    0    0    0    0
 d:  3333     58b    ffff     0    0    0    0    0    0
 e:     1       4    ffff     0    0    0    0    0    0
 f:     3     f00    ffff  9100 9100 9100 9100 9100 dada
10:     0       0    ffff     0    0    0    0    0    0
11:     0       0    ffff     0    0    0    0    0    0
12:  5555       0    ffff     0    0    0    0    0    0
13:  5555     300    ffff     0    0    0    0    0    0
14:  aaaa       0    ffff     0    0    0    0    0    0
15:  aaaa       0    ffff     0    0    0    0    0    0
16:  ffff       0       0     0   33   33   33   33    0
17:  ffff       0    ffff     0    0    0    0    0    0
18:  fa41    15f6    ffff  3210 3210 3210 3210 3210 3210
19:     0       0    ffff  7654 7654 7654 7654 7654 7654
1a:   3ff       0    ffff     0    0    0    0 1ea0 a100
1b:   1fc    110f    ffff  8000 8000 8000 8000 8000 8000
1c:   7c0       0    ffff     0    0    0    0    0    0
1d:  1400       0    ffff     0    0    0    0    0    0
1e:     0       0    ffff  f000 f000 f000 f000 f000 f000
1f:     0       0    ffff     0   91    0    0   7b   34

Both with 5.8.0-rc4, broken is just mainline, reverted has the one
commit reverted.

Martin
