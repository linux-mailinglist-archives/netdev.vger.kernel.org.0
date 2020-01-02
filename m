Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3AE3712E388
	for <lists+netdev@lfdr.de>; Thu,  2 Jan 2020 08:56:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727771AbgABHz6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jan 2020 02:55:58 -0500
Received: from mail-lf1-f67.google.com ([209.85.167.67]:45555 "EHLO
        mail-lf1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727663AbgABHz6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Jan 2020 02:55:58 -0500
Received: by mail-lf1-f67.google.com with SMTP id 203so29306827lfa.12
        for <netdev@vger.kernel.org>; Wed, 01 Jan 2020 23:55:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=eGohEk6S6aS69bKKZtdPwikjBlLgnLVNXqA4xcC4Kho=;
        b=w5FCHCPcoy7So8XJA9xIRexZGLLWbE/hk5imTz9sah34ckqci+zpYnZqWeC+TQW+ZP
         0zD5fYB6jyusZl2JflmxXTmq4UGSYONrwfkNhO5zzcRD4xgR5Y5Tmb4SZmHuy6fPVlwH
         226p43eMEapBGGnlGdMQMcTbcQ62SjQLeYen08k2cegDF3UKo9fkUTPjKJ5Y7r3FpLVp
         OuaeWmVkT9FaAZQyT7dQxDpijNlTlYh/wvRc1nE486CWvie96fTD1mtS4YZmMRdnrBwn
         D3Ytvxwxb3dmBcXCvdpUzgXX6K9BmcuCwDuPHUplHOE9MErG9Uxgyt7RWOn8Y3t4Fet/
         lYJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=eGohEk6S6aS69bKKZtdPwikjBlLgnLVNXqA4xcC4Kho=;
        b=rWQIGkh3hYcvDIYU1Hp2IefN9yxxgv1Vtv5pOKQm1uG0mhULshgcF/9KjLi1GNVeEH
         HrFK/BfFCLXAqWXzhuzsJaQ1BaIR1E6S5QoV+zKXwNIdMaBq96Vahn8+1bTirl2NwRUp
         ifyy/M3alfaJP+lKncK/bt37PY8jQWmM9lrjLsY8Ib8L4jYIGB4W12d8dYm+4h1hHdvj
         JmxAibiCJY2FY6/ORPuL4GGwiYCs/+LV8EGvpDiHhXjrTwWzwXGmHJuFEZcHydg9b+ct
         pDFqNAsBSpLX7MS2i4fDUIFMEx6n0Y5+7ZdY2z1oA0Aw2KcdHyEw0SnAI1//j9L22zgm
         G6ow==
X-Gm-Message-State: APjAAAUQ4HykTqxVTQ6TqD9QKP5JxMWgYD2MSn5sQKJzEJDdX+D8yXqm
        galLW1CYu26taspVGK4KHCu3lQGzgBTJWQCQxbLduQ==
X-Google-Smtp-Source: APXvYqyjCkSGCjGJ9B28da0wZQwDRT9CO/xuV+W8Khgy8GH2aJkxDx6Qv0HJANMb32fem+zQhK9aA2k6fU2SmCETnWc=
X-Received: by 2002:ac2:4a91:: with SMTP id l17mr47045202lfp.75.1577951755636;
 Wed, 01 Jan 2020 23:55:55 -0800 (PST)
MIME-Version: 1.0
References: <CA+G9fYv3=oJSFodFp4wwF7G7_g5FWYRYbc4F0AMU6jyfLT689A@mail.gmail.com>
In-Reply-To: <CA+G9fYv3=oJSFodFp4wwF7G7_g5FWYRYbc4F0AMU6jyfLT689A@mail.gmail.com>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Thu, 2 Jan 2020 13:25:44 +0530
Message-ID: <CA+G9fYvPWFtA77k=yx46FRd2wGW+_SMtzgZtYQFgkzmwPhNhdw@mail.gmail.com>
Subject: Re: stable-rc-4.19.93-rc1/4e040169e8b7 : kernel panic RIP: 0010:__inet_lookup_listener
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Cc:     Eric Dumazet <edumazet@google.com>,
        Michal Kubecek <mkubecek@suse.cz>,
        Firo Yang <firo.yang@suse.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        rcu@vger.kernel.org, Netdev <netdev@vger.kernel.org>,
        lkft-triage@lists.linaro.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 2 Jan 2020 at 12:24, Naresh Kamboju <naresh.kamboju@linaro.org> wro=
te:
>
> Results from Linaro=E2=80=99s test farm.
> Regressions on arm64, arm, x86_64, and i386.
>
> While running LTP syscalls accept* test cases on stable-rc-4.19 branch ke=
rnel.
> This report log extracted from qemu_x86_64.
>
> metadata:
>   git branch: linux-4.19.y
>   git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-=
stable-rc.git
>   git commit: 4e040169e8b7f4e1c50ceb0f6596015ecc67a052
>   git describe: v4.19.92-112-g4e040169e8b7
>   make_kernelversion: 4.19.93-rc1
>   kernel-config:
> http://snapshots.linaro.org/openembedded/lkft/lkft/sumo/intel-corei7-64/l=
kft/linux-stable-rc-4.19/396/config
>
> Crash log,
>
> BUG: unable to handle kernel paging request at 0000000040000001
> [   23.578222] PGD 138f25067 P4D 138f25067 PUD 0
> er run is 0h 15m[   23.578222] Oops: 0000 [#1] SMP NOPTI
> [   23.578222] CPU: 1 PID: 2216 Comm: accept02 Not tainted 4.19.93-rc1 #1
> [   23.578222] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996),
> BIOS 1.12.0-1 04/01/2014
> [   23.578222] RIP: 0010:__inet_lookup_listener+0x12d/0x300

Reverting below patch solve this kernel panic,

tcp/dccp: fix possible race __inet_lookup_established()
[ Upstream commit 8dbd76e79a16b45b2ccb01d2f2e08dbf64e71e40 ]

Michal Kubecek and Firo Yang did a very nice analysis of crashes
happening in __inet_lookup_established().

Since a TCP socket can go from TCP_ESTABLISH to TCP_LISTEN
(via a close()/socket()/listen() cycle) without a RCU grace period,
I should not have changed listeners linkage in their hash table.

They must use the nulls protocol (Documentation/RCU/rculist_nulls.txt),
so that a lookup can detect a socket in a hash list was moved in
another one.

Since we added code in commit d296ba60d8e2 ("soreuseport: Resolve
merge conflict for v4/v6 ordering fix"), we have to add
hlist_nulls_add_tail_rcu() helper.

Fixes: 3b24d854cb35 ("tcp/dccp: do not touch listener sk_refcnt under synfl=
ood")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reported-by: Michal Kubecek <mkubecek@suse.cz>
Reported-by: Firo Yang <firo.yang@suse.com>
Reviewed-by: Michal Kubecek <mkubecek@suse.cz>
Link: https://lore.kernel.org/netdev/20191120083919.GH27852@unicorn.suse.cz=
/
Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
