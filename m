Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD6B931E8E2
	for <lists+netdev@lfdr.de>; Thu, 18 Feb 2021 12:02:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230446AbhBRK43 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Feb 2021 05:56:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232146AbhBRJej (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Feb 2021 04:34:39 -0500
Received: from mail-wm1-x32b.google.com (mail-wm1-x32b.google.com [IPv6:2a00:1450:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CD78C061793;
        Thu, 18 Feb 2021 01:33:37 -0800 (PST)
Received: by mail-wm1-x32b.google.com with SMTP id x4so2348455wmi.3;
        Thu, 18 Feb 2021 01:33:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=yxsqVCKZzlNeKGOz6m5cqTJ3ultAlLxUv7Rsxme6dLQ=;
        b=HThvDt8hD0LPFSy/aMw5yLv9AjNDjxEQ18fW5iIbKLuZhF/H9oXPCWUcA63ZYyNV3e
         /qKJWqlurs/oPX5EJRpgS8Gnl5ZN4ASm6tglzZB3J60zhmrU6tsgZxWk+PkRMTUrRI6d
         QFD0riy76/9IYOXlMz/hdmpDFXiWKhLv3HpweQX9DA3yqKfbtfTR1/FrZQjmQX+zLkqk
         ky52FjCwprHR5sYFfGoq/taMJkFc6OUa20OuxwlliFITA3KjnLhXn+ATFWB212surQOD
         UMW9DiBxa8MyvW63h9Gg4Skqt4r0PhEy5O8ItT4zh0v12HOtQgsohPbFovj/Nqf2S2iy
         ua7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=yxsqVCKZzlNeKGOz6m5cqTJ3ultAlLxUv7Rsxme6dLQ=;
        b=nYtjmvRwM1CzZk65Vy5CEbJeShxWh72gCkHzyl6IUkdEsRUENefsegglS/kK+TAuuP
         sREiS05ubSDoCk+ZXb3ae6EmLhRqYh+TtF3uMhy/6smVxlH97BERAUD7b5GfrHSylYsX
         34RjoWdZo2zOHemdf6UAKa2LvR0ej3FeaODNcehkWBOU7J3c1u8MxtFnAJs00UW6NxE7
         2BeM5LD5anHZGmIIEbuPij5wu4tCg8fbwxm8a2fdfv7CC74oIxD/l4qwSfS8kWsGt7bj
         vOZI5aU86K3cxZy4kWgzDFSlRbF164bmHkavhA+vOjZ2PRDAJdeZiMO/nFeFeNblTPW0
         36jg==
X-Gm-Message-State: AOAM533bLyb+7daYRFlwdFU1z0Z5HshhvwT34qN74zfevIrxLTuzlcYt
        mf+Z+l+KL8kq8FDR7+63SNdNaRVsf30M0GeWwgQ=
X-Google-Smtp-Source: ABdhPJwn68NmAO6UD1aH3SkBpFtHkAgyHre4Ya8vz8AFT+oGvsyw2uferkdCDsuN4k+tjjRBtfLkUiNWnCYkY4hH3yM=
X-Received: by 2002:a05:600c:4ec7:: with SMTP id g7mr2682582wmq.56.1613640815739;
 Thu, 18 Feb 2021 01:33:35 -0800 (PST)
MIME-Version: 1.0
References: <20210217160214.7869-1-ciara.loftus@intel.com> <20210217160214.7869-4-ciara.loftus@intel.com>
In-Reply-To: <20210217160214.7869-4-ciara.loftus@intel.com>
From:   =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
Date:   Thu, 18 Feb 2021 10:33:24 +0100
Message-ID: <CAJ+HfNjUttwjKU0cKcHp46aD670TjrzBLDFmrVNkg4uaNcPaYw@mail.gmail.com>
Subject: Re: [PATCH bpf-next 3/4] selftests/bpf: restructure xsk selftests
To:     Ciara Loftus <ciara.loftus@intel.com>
Cc:     Netdev <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        Weqaar Janjua <weqaar.a.janjua@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 17 Feb 2021 at 17:33, Ciara Loftus <ciara.loftus@intel.com> wrote:
>
> Prior to this commit individual xsk tests were launched from the
> shell script 'test_xsk.sh'. When adding a new test type, two new test
> configurations had to be added to this file - one for each of the
> supported XDP 'modes' (skb or drv). Should zero copy support be added to
> the xsk selftest framework in the future, three new test configurations
> would need to be added for each new test type. Each new test type also
> typically requires new CLI arguments for the xdpxceiver program.
>
> This commit aims to reduce the overhead of adding new tests, by launching
> the test configurations from within the xdpxceiver program itself, using
> simple loops. Every test is run every time the C program is executed. Man=
y
> of the CLI arguments can be removed as a result.
>
> Signed-off-by: Ciara Loftus <ciara.loftus@intel.com>
> ---
>  tools/testing/selftests/bpf/test_xsk.sh    | 112 +-----------
>  tools/testing/selftests/bpf/xdpxceiver.c   | 199 ++++++++++++---------
>  tools/testing/selftests/bpf/xdpxceiver.h   |  27 ++-
>  tools/testing/selftests/bpf/xsk_prereqs.sh |  24 +--
>  4 files changed, 139 insertions(+), 223 deletions(-)
>

I like where this is going! Nice!

[...]

> diff --git a/tools/testing/selftests/bpf/xdpxceiver.c b/tools/testing/sel=
ftests/bpf/xdpxceiver.c
> index 8af746c9a6b6..7cb4a13597d0 100644
> --- a/tools/testing/selftests/bpf/xdpxceiver.c
> +++ b/tools/testing/selftests/bpf/xdpxceiver.c

[...]

>
> +static int configure_skb(void)
> +{
> +
> +       char cmd[80];
> +
> +       snprintf(cmd, sizeof(cmd), "ip link set dev %s xdpdrv off", ifdic=
t[0]->ifname);
> +       if (system(cmd)) {
> +               ksft_test_result_fail("Failed to configure native mode on=
 iface %s\n",
> +                                               ifdict[0]->ifname);
> +               return -1;
> +       }
> +       snprintf(cmd, sizeof(cmd), "ip netns exec %s ip link set dev %s x=
dpdrv off",
> +                                       ifdict[1]->nsname, ifdict[1]->ifn=
ame);
> +       if (system(cmd)) {
> +               ksft_test_result_fail("Failed to configure native mode on=
 iface/ns %s\n",
> +                                               ifdict[1]->ifname, ifdict=
[1]->nsname);
> +               return -1;
> +       }
> +
> +       cur_mode =3D TEST_MODE_SKB;
> +
> +       return 0;
> +
> +}
> +
> +static int configure_drv(void)
> +{
> +       char cmd[80];
> +
> +       snprintf(cmd, sizeof(cmd), "ip link set dev %s xdpgeneric off", i=
fdict[0]->ifname);
> +       if (system(cmd)) {
> +               ksft_test_result_fail("Failed to configure native mode on=
 iface %s\n",
> +                                               ifdict[0]->ifname);
> +               return -1;
> +       }
> +       snprintf(cmd, sizeof(cmd), "ip netns exec %s ip link set dev %s x=
dpgeneric off",
> +                                       ifdict[1]->nsname, ifdict[1]->ifn=
ame);
> +       if (system(cmd)) {
> +               ksft_test_result_fail("Failed to configure native mode on=
 iface/ns %s\n",
> +                                               ifdict[1]->ifname, ifdict=
[1]->nsname);
> +               return -1;
> +       }
> +
> +       cur_mode =3D TEST_MODE_DRV;
> +
> +       return 0;
> +}
> +

We're already using libbpf, so please use the libbpf APIs instead of
calling iproute2.

Bj=C3=B6rn

[...]
