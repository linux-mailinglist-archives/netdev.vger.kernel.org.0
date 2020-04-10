Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 40A9A1A4B71
	for <lists+netdev@lfdr.de>; Fri, 10 Apr 2020 22:51:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726691AbgDJUu5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Apr 2020 16:50:57 -0400
Received: from mail-ot1-f67.google.com ([209.85.210.67]:43311 "EHLO
        mail-ot1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726177AbgDJUu5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Apr 2020 16:50:57 -0400
Received: by mail-ot1-f67.google.com with SMTP id n25so2972417otr.10;
        Fri, 10 Apr 2020 13:50:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ewCXAds0/Tx9yG0Y/dWTq5Eu5IfI4LrFYqbMl7UoUlU=;
        b=nMJR2f+Uu9/PNKJ0GuOQ2PkCB1cyFm5FHsnsOsm2d8xTlKfTFcPmLTmiBOtFJ8BTf2
         JpYHfSsYXOq0YcH3G2NcgXfnVLRbqfqFKHQB4hxOqMU/9DBd0LkChTH7QjZRBqtPjCRl
         r8KdsVhrQFddf1kBW67rBEO770j++HT2xhmBLnedX9q4gIxr3f9N2uI3BXlNHVQyQ9ct
         AVxOCocmdqPcFiBlfqM2L/RZK0IUuDnIvDSOU7G9JVodErzRT9ukb8YsUYp1gmoANz7J
         vPwaKMhkIR340GRWc+qsTWidwlpvPwTadokxHi4td76k1Or4lUNh19J3sMJk9crmv1F9
         MdcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ewCXAds0/Tx9yG0Y/dWTq5Eu5IfI4LrFYqbMl7UoUlU=;
        b=OvgaUsdl0UzVVqniKReQo0MgiLFmerFF9wk66bl7jyU9DjbXcKg2zWoLxFl7yY3pxK
         lgFqg+mrvsg1tgFXdJ1M7y0fjwWxgXoWRirwu1eUcaczoOBT71oKGAbPyHsqxYxWoLPN
         j4SKc6ccmDpV/N4em3i5mzuNGW7QBD7Ua/ETdYBvKGXZ2Yr3+UJftGPyARiOU2trnmS9
         iFrvwLwfvOMDFRUv27mmOEIiFelhLK5XZLxIIUj4zRf5ZyHuUKmZQBUqMDX71UpL2rgW
         FRV+t/YRJvETQbqPDYk3m9cIWkkpmslLz0SXB+ubP1WsUfKfVMKZgMxc9gqOPNzGuqXr
         OHKA==
X-Gm-Message-State: AGi0PubqhwdsDbFJhsm0Lg5MmICUd/47ojObXsjwK6biwXpxJFBvSqdY
        pm5Q54XCAu4iwE9aCWPjaHFsAp6NhwoLbhMF3Bo=
X-Google-Smtp-Source: APiQypIVa2LfjgeNBVItEHbjs1Wcrz/CM/OdP2ZKbNx7AI3QlFbE65FClqWj+Pg/ADsxUXsbjxJXK5cekR3Tzk4XZYY=
X-Received: by 2002:a9d:7845:: with SMTP id c5mr231157otm.319.1586551856800;
 Fri, 10 Apr 2020 13:50:56 -0700 (PDT)
MIME-Version: 1.0
References: <CA+G9fYt7-R-_fVDeiwj=sVvBQ-456Pm1oFFtM5Hm_94nN-tA+w@mail.gmail.com>
In-Reply-To: <CA+G9fYt7-R-_fVDeiwj=sVvBQ-456Pm1oFFtM5Hm_94nN-tA+w@mail.gmail.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Fri, 10 Apr 2020 13:50:44 -0700
Message-ID: <CAM_iQpXQdgwFwUONX+za5vJbcXP9krwz_--pG+z_Etf_v8K2mw@mail.gmail.com>
Subject: Re: x86_64: 5.6.0: locking/lockdep.c:1155 lockdep_register_key
To:     Naresh Kamboju <naresh.kamboju@linaro.org>
Cc:     open list <linux-kernel@vger.kernel.org>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>, Borislav Petkov <bp@suse.de>,
        Netdev <netdev@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Brian Gerst <brgerst@gmail.com>, lkft-triage@lists.linaro.org,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andriin@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 7, 2020 at 2:58 AM Naresh Kamboju <naresh.kamboju@linaro.org> wrote:
>
> On Linux mainline kernel 5.6.0 running kselftest on i386 kernel running on
> x86_64 devices we have noticed this kernel warning.
>
> [ 0.000000] Linux version 5.6.0 (oe-user@oe-host) (gcc version 7.3.0
> (GCC)) #1 SMP Mon Apr 6 17:31:22 UTC 2020
> <>
> [  143.321511] ------------[ cut here ]------------
> [  143.326180] WARNING: CPU: 1 PID: 1515 at
> /usr/src/kernel/kernel/locking/lockdep.c:1155
> lockdep_register_key+0x150/0x180
> [  143.336958] Modules linked in: sch_ingress veth algif_hash
> x86_pkg_temp_thermal fuse
> [  143.344698] CPU: 1 PID: 1515 Comm: ip Tainted: G        W         5.6.0 #1
> [  143.351562] Hardware name: Supermicro SYS-5019S-ML/X11SSH-F, BIOS
> 2.0b 07/27/2017
> [  143.359034] EIP: lockdep_register_key+0x150/0x180
> [  143.363739] Code: ff ff a1 88 4c 2a dc 85 c0 0f 85 ef fe ff ff 68
> 27 02 f9 db 68 a5 7a f7 db e8 0c 5b fa ff 0f 0b 59 58 e9 d7 fe ff ff
> 8d 76 00 <0f> 0b 8d 65 f8 5b 5e 5d c3 8d b4 26 00 00 00 00 89 c2 b8 68
> 68 99
> [  143.382485] EAX: 00000001 EBX: dc329ea8 ECX: 00000001 EDX: dc3299a8
> [  143.388751] ESI: 00000001 EDI: c7316000 EBP: c610fe10 ESP: c610fe08
> [  143.395014] DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068 EFLAGS: 00010202
> [  143.401792] CR0: 80050033 CR2: b7dd70c0 CR3: 20672000 CR4: 003406d0
> [  143.408051] DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
> [  143.414315] DR6: fffe0ff0 DR7: 00000400
> [  143.418144] Call Trace:
> [  143.420592]  alloc_netdev_mqs+0xc6/0x3c0

This is odd, the warning complains a lockdep key is static, but
all of the 3 lockdep keys in netdev_register_lockdep_key() are
dynamic. I don't see how this warning could happen.

Thanks.
