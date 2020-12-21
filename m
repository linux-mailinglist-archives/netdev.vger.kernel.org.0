Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D0D0A2DF934
	for <lists+netdev@lfdr.de>; Mon, 21 Dec 2020 07:20:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728436AbgLUGUc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Dec 2020 01:20:32 -0500
Received: from conssluserg-02.nifty.com ([210.131.2.81]:41324 "EHLO
        conssluserg-02.nifty.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726140AbgLUGUb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Dec 2020 01:20:31 -0500
Received: from mail-pf1-f181.google.com (mail-pf1-f181.google.com [209.85.210.181]) (authenticated)
        by conssluserg-02.nifty.com with ESMTP id 0BL6Jbgn024900;
        Mon, 21 Dec 2020 15:19:37 +0900
DKIM-Filter: OpenDKIM Filter v2.10.3 conssluserg-02.nifty.com 0BL6Jbgn024900
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nifty.com;
        s=dec2015msa; t=1608531578;
        bh=BYlCTuhSzV6TRqa7tXYTcFDqgVKa7TxcGPT3foHwNXs=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=hyOhPooQuC6c16OkErO/kv5Nd7W/E29yS78DeXcxbDDsqCqepVcUpLsSX6xmZqKMN
         kFZO1TH4QG1XAYVWaJgjo8t1HWnBSWKb//s1iSE/yFiTW+HXe1Tx11HC60U8rdBNiN
         8qmYtfe5V1pSJWIhNFPLlgf2Hir0FMN6GRp/u+Dhy7ahlk9rGaE9FGIQF9wfmMDGcU
         dztpm9zrLJYVh2IoCTVYFOONxslnFij98XwpNdFtwxYmbDPGeGjhvt+MjmKAMSNA7q
         CcjqLvDpByyGrnVyuc1PuGzRJcmJkTPMuL4K2Pe60ZfzxTjqYtoZwv8UOqLjzdLDc9
         VcUb9vQ/QHtHw==
X-Nifty-SrcIP: [209.85.210.181]
Received: by mail-pf1-f181.google.com with SMTP id v2so5883335pfm.9;
        Sun, 20 Dec 2020 22:19:37 -0800 (PST)
X-Gm-Message-State: AOAM5319u3yN+Of6s1LnIP6Aj3EOkwytJmq98U8IxGiZYWLaBk45Ffst
        Qa6pTUKOm20eC/4AaROis81aB/KM86P6IjvP1Ec=
X-Google-Smtp-Source: ABdhPJyTGmpFdbbWcUsN7vwbZtf5cf/Z4qlcgRfZbI9ZKyKFX7z9MBplWa/TWblbbnO2J/T7wiw0B8s5pwv5XMbvdJE=
X-Received: by 2002:a63:3205:: with SMTP id y5mr14082429pgy.47.1608531576913;
 Sun, 20 Dec 2020 22:19:36 -0800 (PST)
MIME-Version: 1.0
References: <20201128193335.219395-1-masahiroy@kernel.org> <20201212161831.GA28098@roeck-us.net>
 <CANiq72=e9Csgpcu3MdLGB77dL_QBn6PpqoG215YUHZLNCUGP0w@mail.gmail.com>
 <8f645b94-80e5-529c-7b6a-d9b8d8c9685e@roeck-us.net> <CANiq72kML=UmMLyKcorYwOhp2oqjfz7_+JN=EmPp05AapHbFSg@mail.gmail.com>
 <X9YwXZvjSWANm4wR@kroah.com> <CANiq72=UzRTkh6bcNSjE-kSgBJYX12+zQUYphZ1GcY-7kNxaLA@mail.gmail.com>
In-Reply-To: <CANiq72=UzRTkh6bcNSjE-kSgBJYX12+zQUYphZ1GcY-7kNxaLA@mail.gmail.com>
From:   Masahiro Yamada <masahiroy@kernel.org>
Date:   Mon, 21 Dec 2020 15:18:59 +0900
X-Gmail-Original-Message-ID: <CAK7LNARXa1CQSFJjcqN7Y_8dZ1CSGqjoeox3oGAS_3=4QrHs9g@mail.gmail.com>
Message-ID: <CAK7LNARXa1CQSFJjcqN7Y_8dZ1CSGqjoeox3oGAS_3=4QrHs9g@mail.gmail.com>
Subject: Re: [PATCH v3] Compiler Attributes: remove CONFIG_ENABLE_MUST_CHECK
To:     Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Cc:     Greg KH <gregkh@linuxfoundation.org>,
        Guenter Roeck <linux@roeck-us.net>,
        "Jason A . Donenfeld" <Jason@zx2c4.com>,
        Nathan Chancellor <natechancellor@gmail.com>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Shuah Khan <shuah@kernel.org>,
        clang-built-linux <clang-built-linux@googlegroups.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        wireguard@lists.zx2c4.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 14, 2020 at 12:27 AM Miguel Ojeda
<miguel.ojeda.sandonis@gmail.com> wrote:
>
> On Sun, Dec 13, 2020 at 4:16 PM Greg KH <gregkh@linuxfoundation.org> wrote:
> >
> > Because if you get a report of something breaking for your change, you
> > need to work to resolve it, not argue about it.  Otherwise it needs to
> > be dropped/reverted.
>
> Nobody has argued that. In fact, I explicitly said the opposite: "So I
> think we can fix them as they come.".
>
> I am expecting Masahiro to follow up. It has been less than 24 hours
> since the report, on a weekend.
>
> Cheers,
> Miguel


Sorry for the delay.

Now I sent out the fix for lantiq_etop.c

https://lore.kernel.org/patchwork/patch/1355595/


The reason of the complication was
I was trying to merge the following patch in the same development cycle:
https://patchwork.kernel.org/project/linux-kbuild/patch/20201117104736.24997-1-olaf@aepfle.de/


-Werror=return-type gives a bigger impact
because any instance of __must_check violation
results in build breakage.
So, I just dropped it from my tree (and, I will aim for 5.12).

The removal of CONFIG_ENABLE_MUST_CHECK is less impactive,
because we are still able to build with some warnings.


Tomorrow's linux-next should be OK
and, you can send my patch in this merge window.

-- 
Best Regards
Masahiro Yamada
