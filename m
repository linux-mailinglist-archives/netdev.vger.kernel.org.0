Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC58F3A31FA
	for <lists+netdev@lfdr.de>; Thu, 10 Jun 2021 19:24:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230084AbhFJR0m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Jun 2021 13:26:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229802AbhFJR0l (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Jun 2021 13:26:41 -0400
Received: from mail-yb1-xb30.google.com (mail-yb1-xb30.google.com [IPv6:2607:f8b0:4864:20::b30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E363C061574;
        Thu, 10 Jun 2021 10:24:45 -0700 (PDT)
Received: by mail-yb1-xb30.google.com with SMTP id p184so363301yba.11;
        Thu, 10 Jun 2021 10:24:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=eW+5V+zbDfUdAlLcDcRVdOxN1l6x5Hh789VvE9XY038=;
        b=q+Sze6h033k9a8LBwJXN5cVATMf3X84rcfng3rsxlWmiXFf5SNqxPCXoH7H45vPrTq
         s5ne4pvnV6QPM0pi1a2Tm8yIMMJJY1AnLLebySuMqoMPPSVdoc/4cMDl0N77pN4A0Mnk
         A8KTYOoilXhxhyyNoClVBMprF2hWHoJ3C25+vyF+dYb3Ip3C7v6Nc/V4GZMJcWxl0lnM
         QQXCjQMtXwSXpF/nBfyXyJZn/G1U0o/YX7c1NaXlRfWH+IUQNvQ9qkoRJVdTbZE0Wu0y
         i5rzrsnD36Bw8Nls6SM9913/mzfquQPNYKlmOJ5z03CVvYt5I7KzOJetk/TAYVA39zLr
         axFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=eW+5V+zbDfUdAlLcDcRVdOxN1l6x5Hh789VvE9XY038=;
        b=rxq6CK5WuiIyCTiHDFIRNSixT7+xKJjAGPYwhUcT1YGTFjcNetlyiJQerhJ0C8AsXw
         ZRoS5WaWK3/QjsiyAOGYoWFHHkZZ//n4qTvMub8byjLQPrCVy80ZWXCbbd0adnrkdxLe
         KFtm6MLaaYJXt/0OWpS1Diqis8VlWWQP/kfrrnY7mj3h6e5gV3LvGJ51h2DCtfxW8wzL
         9yc8s6n8C4tc97jOVyssux1dyRwpI4Fmqp+5YRL66nwKFfSjjiBcvAKSqXDHv7UuVWsX
         PmWr5/tEFBcmrPkhvSPQ46Go7QcsgjkpXDU8AmbGPQZuoaSF78mmte4WzO5v/M2nJUQV
         +2aA==
X-Gm-Message-State: AOAM533ViI5xHsb63oNZNEfBmyNFub2zxrWS7YCULSLk5/bzqclupbfy
        2XR9m4RbWAAkXpzGXRMbdemrwl3cHA81Bvvxtco=
X-Google-Smtp-Source: ABdhPJwklyvU0Q8rmj0IRZV39jUSVWLBBaCQC+kN6HBez3IDqgr/L8Hiw9N50OCsZ23j7/J37xEQJ9ZIMAK8q6vRn/o=
X-Received: by 2002:a25:1455:: with SMTP id 82mr9054485ybu.403.1623345884428;
 Thu, 10 Jun 2021 10:24:44 -0700 (PDT)
MIME-Version: 1.0
References: <20210609135537.1460244-1-joamaki@gmail.com>
In-Reply-To: <20210609135537.1460244-1-joamaki@gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 10 Jun 2021 10:24:33 -0700
Message-ID: <CAEf4Bzar4+HQ_0BBGt75_UPG-tVpjqz9YVdeBi2GVY1iam4Y2g@mail.gmail.com>
Subject: Re: [PATCH bpf-next 0/3] XDP bonding support
To:     Jussi Maki <joamaki@gmail.com>
Cc:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, j.vosburgh@gmail.com,
        andy@greyhouse.net, vfalico@gmail.com,
        Andrii Nakryiko <andrii@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 9, 2021 at 6:55 AM Jussi Maki <joamaki@gmail.com> wrote:
>
> This patchset introduces XDP support to the bonding driver.
>
> Patch 1 contains the implementation, including support for
> the recently introduced EXCLUDE_INGRESS. Patch 2 contains a
> performance fix to the roundrobin mode which switches rr_tx_counter
> to be per-cpu. Patch 3 contains the test suite for the implementation
> using a pair of veth devices.
>
> The vmtest.sh is modified to enable the bonding module and install
> modules. The config change should probably be done in the libbpf
> repository. Andrii: How would you like this done properly?

I think vmtest.sh and CI setup doesn't support modules (not easily at
least). Can we just compile that driver in? Then you can submit a PR
against libbpf Github repo to adjust the config. We have also kernel
CI repo where we'll need to make this change.

>
> The motivation for this change is to enable use of bonding (and
> 802.3ad) in hairpinning L4 load-balancers such as [1] implemented with
> XDP and also to transparently support bond devices for projects that
> use XDP given most modern NICs have dual port adapters.  An alternative
> to this approach would be to implement 802.3ad in user-space and
> implement the bonding load-balancing in the XDP program itself, but
> is rather a cumbersome endeavor in terms of slave device management
> (e.g. by watching netlink) and requires separate programs for native
> vs bond cases for the orchestrator. A native in-kernel implementation
> overcomes these issues and provides more flexibility.
>
> Below are benchmark results done on two machines with 100Gbit
> Intel E810 (ice) NIC and with 32-core 3970X on sending machine, and
> 16-core 3950X on receiving machine. 64 byte packets were sent with
> pktgen-dpdk at full rate. Two issues [2, 3] were identified with the
> ice driver, so the tests were performed with iommu=off and patch [2]
> applied. Additionally the bonding round robin algorithm was modified
> to use per-cpu tx counters as high CPU load (50% vs 10%) and high rate
> of cache misses were caused by the shared rr_tx_counter (see patch
> 2/3). The statistics were collected using "sar -n dev -u 1 10".
>
>  -----------------------|  CPU  |--| rxpck/s |--| txpck/s |----
>  without patch (1 dev):
>    XDP_DROP:              3.15%      48.6Mpps
>    XDP_TX:                3.12%      18.3Mpps     18.3Mpps
>    XDP_DROP (RSS):        9.47%      116.5Mpps
>    XDP_TX (RSS):          9.67%      25.3Mpps     24.2Mpps
>  -----------------------
>  with patch, bond (1 dev):
>    XDP_DROP:              3.14%      46.7Mpps
>    XDP_TX:                3.15%      13.9Mpps     13.9Mpps
>    XDP_DROP (RSS):        10.33%     117.2Mpps
>    XDP_TX (RSS):          10.64%     25.1Mpps     24.0Mpps
>  -----------------------
>  with patch, bond (2 devs):
>    XDP_DROP:              6.27%      92.7Mpps
>    XDP_TX:                6.26%      17.6Mpps     17.5Mpps
>    XDP_DROP (RSS):       11.38%      117.2Mpps
>    XDP_TX (RSS):         14.30%      28.7Mpps     27.4Mpps
>  --------------------------------------------------------------
>
> RSS: Receive Side Scaling, e.g. the packets were sent to a range of
> destination IPs.
>
> [1]: https://cilium.io/blog/2021/05/20/cilium-110#standalonelb
> [2]: https://lore.kernel.org/bpf/20210601113236.42651-1-maciej.fijalkowski@intel.com/T/#t
> [3]: https://lore.kernel.org/bpf/CAHn8xckNXci+X_Eb2WMv4uVYjO2331UWB2JLtXr_58z0Av8+8A@mail.gmail.com/
>
> ---
>
> Jussi Maki (3):
>   net: bonding: Add XDP support to the bonding driver
>   net: bonding: Use per-cpu rr_tx_counter
>   selftests/bpf: Add tests for XDP bonding
>
>  drivers/net/bonding/bond_main.c               | 459 +++++++++++++++---
>  include/linux/filter.h                        |  13 +-
>  include/linux/netdevice.h                     |   5 +
>  include/net/bonding.h                         |   3 +-
>  kernel/bpf/devmap.c                           |  34 +-
>  net/core/filter.c                             |  37 +-
>  .../selftests/bpf/prog_tests/xdp_bonding.c    | 342 +++++++++++++
>  tools/testing/selftests/bpf/vmtest.sh         |  30 +-
>  8 files changed, 843 insertions(+), 80 deletions(-)
>  create mode 100644 tools/testing/selftests/bpf/prog_tests/xdp_bonding.c
>
> --
> 2.30.2
>
