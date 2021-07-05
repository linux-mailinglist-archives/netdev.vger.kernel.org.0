Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CAC913BBB46
	for <lists+netdev@lfdr.de>; Mon,  5 Jul 2021 12:33:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230506AbhGEKfi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Jul 2021 06:35:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230498AbhGEKfg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Jul 2021 06:35:36 -0400
Received: from mail-qv1-xf2c.google.com (mail-qv1-xf2c.google.com [IPv6:2607:f8b0:4864:20::f2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 778EEC061762;
        Mon,  5 Jul 2021 03:32:59 -0700 (PDT)
Received: by mail-qv1-xf2c.google.com with SMTP id fi7so7519606qvb.0;
        Mon, 05 Jul 2021 03:32:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Uv5ai65gHb5m/HxZd5R8XWhGgD//S0MpoNfax4VMuGs=;
        b=pERmxVpJmV1UrNZlchRsmpGEyukTJjAGELhKWFeg2cWIqeduB/v1eJoeNhJI74by/E
         S7SUC8tgnz9RLMqcjuBehNr/iVc/fANx0fABKhZr9ixp6seEtQVbByay4VbmQpKYFnUh
         MDzd8kOsDFiWRcjQd98+2gcxNzwPidP2veYdL/67fdE80nwUgDHj9y34U3yzPFqBYDTS
         m//98Yf6SQNi7nAD9jHB297Rwe+OXYfQsnwXNkoLvTdmVSlGxDJfWqGB0KFk7o19eIN0
         KSJw0xk2Dq8RZ0IV5p1Fdx/E1HkA8wLPlkizX0UvyehtFnYf/5I6MV24iIKX1gsHAt6F
         IGXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Uv5ai65gHb5m/HxZd5R8XWhGgD//S0MpoNfax4VMuGs=;
        b=I2+Ww1+FI3WKuV/sWzzKGuRLd5WK7gN74XhTiqceJ/5ZO31XMu3G16YKf4Q5yplEsW
         /WvR6bFFEBMHq2eXwg66V7LAj6xkE6nnQhlxvr6OgLWikyYJ4ulRL2+sPLP0mngeyqBA
         yzXwh8HY7A79oBfwXXxOZmdg4y4GPrVCq00hDB/FeshM8AMsckreH+EPkv5D0qbtWeVo
         QHdCKCOkiFeBDs2NcbxRqqCKBwdJmfZWeJ6gekdXELUb0heHcEiR+EZ4D1ZEAtdtj6fs
         x/5XW33gsHaKHJDqovvCxzZQ3gFGfs9oa37VTdTzbvOcygTZGuesJlrxfnYI6GiQEvDk
         1rXw==
X-Gm-Message-State: AOAM533IPHmtk3kQiqGNi/N0i3S9EWzcOMaMLUl6M/rkcnbsxgXKPpmE
        zF+5vZvwzarpZcQ+dho1+Hm+/cVzNjQ/80E3fw==
X-Google-Smtp-Source: ABdhPJwKsyJm8Wuj7b6z76dHg62Zky63dEg6wUu5O0hnKGVA97DUdqDQEJox82/1WorM6l8DpAAER6+FmaysKpWQP4g=
X-Received: by 2002:a0c:f8d1:: with SMTP id h17mr7863652qvo.21.1625481178553;
 Mon, 05 Jul 2021 03:32:58 -0700 (PDT)
MIME-Version: 1.0
References: <20210609135537.1460244-1-joamaki@gmail.com> <20210624091843.5151-1-joamaki@gmail.com>
 <31459.1625163601@famine>
In-Reply-To: <31459.1625163601@famine>
From:   Jussi Maki <joamaki@gmail.com>
Date:   Mon, 5 Jul 2021 13:32:47 +0300
Message-ID: <CAHn8xcn0CpcmX7fzkWwHWJpXTxVD=9XScCsDYT-bg3+d+5M5zA@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2 0/4] XDP bonding support
To:     Jay Vosburgh <jay.vosburgh@canonical.com>
Cc:     bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andy Gospodarek <andy@greyhouse.net>, vfalico@gmail.com,
        Andrii Nakryiko <andrii@kernel.org>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 1, 2021 at 9:20 PM Jay Vosburgh <jay.vosburgh@canonical.com> wrote:
>
> joamaki@gmail.com wrote:
>
> >From: Jussi Maki <joamaki@gmail.com>
> >
> >This patchset introduces XDP support to the bonding driver.
> >
> >The motivation for this change is to enable use of bonding (and
> >802.3ad) in hairpinning L4 load-balancers such as [1] implemented with
> >XDP and also to transparently support bond devices for projects that
> >use XDP given most modern NICs have dual port adapters.  An alternative
> >to this approach would be to implement 802.3ad in user-space and
> >implement the bonding load-balancing in the XDP program itself, but
> >is rather a cumbersome endeavor in terms of slave device management
> >(e.g. by watching netlink) and requires separate programs for native
> >vs bond cases for the orchestrator. A native in-kernel implementation
> >overcomes these issues and provides more flexibility.
> >
> >Below are benchmark results done on two machines with 100Gbit
> >Intel E810 (ice) NIC and with 32-core 3970X on sending machine, and
> >16-core 3950X on receiving machine. 64 byte packets were sent with
> >pktgen-dpdk at full rate. Two issues [2, 3] were identified with the
> >ice driver, so the tests were performed with iommu=off and patch [2]
> >applied. Additionally the bonding round robin algorithm was modified
> >to use per-cpu tx counters as high CPU load (50% vs 10%) and high rate
> >of cache misses were caused by the shared rr_tx_counter. Fix for this
> >has been already merged into net-next. The statistics were collected
> >using "sar -n dev -u 1 10".
> >
> > -----------------------|  CPU  |--| rxpck/s |--| txpck/s |----
> > without patch (1 dev):
> >   XDP_DROP:              3.15%      48.6Mpps
> >   XDP_TX:                3.12%      18.3Mpps     18.3Mpps
> >   XDP_DROP (RSS):        9.47%      116.5Mpps
> >   XDP_TX (RSS):          9.67%      25.3Mpps     24.2Mpps
> > -----------------------
> > with patch, bond (1 dev):
> >   XDP_DROP:              3.14%      46.7Mpps
> >   XDP_TX:                3.15%      13.9Mpps     13.9Mpps
> >   XDP_DROP (RSS):        10.33%     117.2Mpps
> >   XDP_TX (RSS):          10.64%     25.1Mpps     24.0Mpps
> > -----------------------
> > with patch, bond (2 devs):
> >   XDP_DROP:              6.27%      92.7Mpps
> >   XDP_TX:                6.26%      17.6Mpps     17.5Mpps
> >   XDP_DROP (RSS):       11.38%      117.2Mpps
> >   XDP_TX (RSS):         14.30%      28.7Mpps     27.4Mpps
> > --------------------------------------------------------------
>
>         To be clear, the fact that the performance numbers for XDP_DROP
> and XDP_TX are lower for "with patch, bond (1 dev)" than "without patch
> (1 dev)" is expected, correct?

Yes that is correct. With the patch the ndo callback for choosing the
slave device is invoked which in this test (mode=xor) hashes L2&L3
headers (I seem to have failed to mention this in the original
message). In round-robin mode I recall it being about 16Mpps versus
the 18Mpps without the patch. I did also try "INDIRECT_CALL" to avoid
going via ndo_ops, but that had no discernible effect.
