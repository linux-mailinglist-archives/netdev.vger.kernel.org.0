Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 803F52D10C
	for <lists+netdev@lfdr.de>; Tue, 28 May 2019 23:36:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727297AbfE1VgP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 May 2019 17:36:15 -0400
Received: from mail-ed1-f49.google.com ([209.85.208.49]:35538 "EHLO
        mail-ed1-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726526AbfE1VgO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 May 2019 17:36:14 -0400
Received: by mail-ed1-f49.google.com with SMTP id p26so200321edr.2;
        Tue, 28 May 2019 14:36:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=uecXIZDcklzAA/OFh3RkZA0lNa/d4a4Fo/G/5x2r9/U=;
        b=fMsjIGG81xsEdA/DBHHj4AXpArTXtvjcRWFsKFgh07AzA1bkNjW2xPVStuRLXue+JN
         clpgnkBoD+GgFGC3/uMfQbFAyPqjnWGmBP4iSQl3TR0KuPnfBlue3BQdHNtpIwOXAwi7
         W0VhkYYwBbs3HwdAfQa2O0tkrHJKsULiVCNxDddcllgoRWmpTMfR2v45nbKDS8iyRUep
         iUxv4pxXs54sY0fPI7G35lKiFvpnrUJnGDs6JA4ZtU1PUPwAZVAn3TV8f1waMbJpQvJE
         IOMIaXhFX6P0lsf1QfLxEuZE9S/2UDS6njg7+Bgan41PKQYafFRvTWWzptw9TjOzbaeb
         z3vg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=uecXIZDcklzAA/OFh3RkZA0lNa/d4a4Fo/G/5x2r9/U=;
        b=l9fP15H3KI3olH0BRvCOlytwLpEHYWJo5IAaW6ZZKL3/BiqdT/xDACG9qPe33xr+f1
         qFZO2uSD63SSDRcZo/0T0Yue0J0y3czNZgtdxZc2079n4QMOMeISvZmGVnKD75nQcM3O
         U0d1UPmcd9Mgb+qLBmHA3B7e+YGPYyH1zGiulfkEQL7K20mkmU7cHAWwNmW6EWYuTKrK
         zXGsK7KxFaWwpRwDzUjvTsgzE6ba/ogPHaOBI96RXa6NIn4qt+exbVSo2yANcCLx/3PG
         VevAskIW0bve/OLtlXUEGKQd9MOOlA8LPFgjm00A3C2DwrYpsTGYDoK0KtjVVHDtO93S
         O7hg==
X-Gm-Message-State: APjAAAU3O5f9Cye7+w8uUbS6AFFGPEItN2BiGp+pb8QARM9G5GxDdH63
        94oLEfcf+Q+UoX2hGs5QmkOSDUa8NF+fMhndjsw=
X-Google-Smtp-Source: APXvYqxHxoY8doCT8Xl943B0NhZ0oQA/tfutSQ/S2Sg9d0XLQi8EKmPuF2z5B0/clzfxkfW54vgULnxDSyFVmrxEJAk=
X-Received: by 2002:aa7:ca54:: with SMTP id j20mr131541007edt.23.1559079372032;
 Tue, 28 May 2019 14:36:12 -0700 (PDT)
MIME-Version: 1.0
References: <20190528184708.16516-1-fklassen@appneta.com> <20190528184708.16516-2-fklassen@appneta.com>
In-Reply-To: <20190528184708.16516-2-fklassen@appneta.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Tue, 28 May 2019 17:35:35 -0400
Message-ID: <CAF=yD-KcA5NZ2_tp3zaxW5sbf75a17DLX+VR9hyZo7MTcYAxiw@mail.gmail.com>
Subject: Re: [PATCH net-next v2 1/3] net/udpgso_bench_tx: options to exercise
 TX CMSG
To:     Fred Klassen <fklassen@appneta.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Shuah Khan <shuah@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-kselftest@vger.kernel.org,
        Willem de Bruijn <willemb@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 28, 2019 at 3:24 PM Fred Klassen <fklassen@appneta.com> wrote:
>
> This enhancement adds options that facilitate load testing with
> additional TX CMSG options, and to optionally print results of
> various send CMSG operations.
>
> These options are especially useful in isolating situations
> where error-queue messages are lost when combined with other
> CMSG operations (e.g. SO_ZEROCOPY).
>
> New options:
>
>     -a - count all CMSG messages and match to sent messages
>     -T - add TX CMSG that requests TX software timestamps
>     -H - similar to -T except request TX hardware timestamps
>     -P - call poll() before reading error queue
>     -v - print detailed results
>
> v2: Enhancements as per Willem de Bruijn <willemb@google.com>
>     - Updated control and buffer parameters for recvmsg
>     - poll() parameter cleanup
>     - fail on bad audit results
>     - remove TOS options
>     - improved reporting
>
> Signed-off-by: Fred Klassen <fklassen@appneta.com>
> ---

> -static void flush_zerocopy(int fd)
> +static void flush_cmsg(struct cmsghdr *cmsg)
>  {
> -       struct msghdr msg = {0};        /* flush */
> +       switch (cmsg->cmsg_level) {
> +       case SOL_SOCKET:
> +               if (cmsg->cmsg_type == SO_TIMESTAMPING) {
> +                       int i;
> +
> +                       i = (cfg_tx_ts == SOF_TIMESTAMPING_TX_HARDWARE) ? 2 : 0;
> +                       struct scm_timestamping *tss;

Please don't mix declarations and code.

> +
> +                       tss = (struct scm_timestamping *)CMSG_DATA(cmsg);
> +                       if (tss->ts[i].tv_sec == 0)
> +                               stat_tx_ts_errors++;
> +               } else {
> +                       error(1, 0,
> +                             "unknown SOL_SOCKET cmsg type=%u level=%u\n",
> +                             cmsg->cmsg_type, cmsg->cmsg_level);

Technically, no need to repeat cmsg_level
> +               }
> +               break;
> +       case SOL_IP:
> +       case SOL_IPV6:
> +               switch (cmsg->cmsg_type) {
> +               case IP_RECVERR:
> +               case IPV6_RECVERR:
> +               {
> +                       struct sock_extended_err *err;
> +
> +                       err = (struct sock_extended_err *)CMSG_DATA(cmsg);
> +                       switch (err->ee_origin) {
> +                       case SO_EE_ORIGIN_TIMESTAMPING:
> +                               // Got a TX timestamp from error queue
> +                               stat_tx_ts++;
> +                               break;
> +                       case SO_EE_ORIGIN_ICMP:
> +                       case SO_EE_ORIGIN_ICMP6:
> +                               if (cfg_verbose)
> +                                       fprintf(stderr,
> +                                               "received ICMP error: type=%u, code=%u\n",
> +                                               err->ee_type, err->ee_code);
> +                               break;
> +                       case SO_EE_ORIGIN_ZEROCOPY:
> +                       {
> +                               __u32 lo = err->ee_info;
> +                               __u32 hi = err->ee_data;
> +
> +                               if (hi == lo - 1) {
> +                                       // TX was aborted

where does this come from?

> +                                       stat_zcopy_errors++;
> +                                       if (cfg_verbose)
> +                                               fprintf(stderr,
> +                                                       "Zerocopy TX aborted: lo=%u hi=%u\n",
> +                                                       lo, hi);
> +                               } else if (hi == lo) {

technically, no need to special case

> +                                       // single ID acknowledged
> +                                       stat_zcopies++;
> +                               } else {
> +                                       // range of IDs acknowledged
> +                                       stat_zcopies += hi - lo + 1;
> +                               }
> +                               break;

> +static void set_tx_timestamping(int fd)
> +{
> +       int val = SOF_TIMESTAMPING_OPT_CMSG | SOF_TIMESTAMPING_OPT_ID;

Could consider adding SOF_TIMESTAMPING_OPT_TSONLY to not have to deal
with a data buffer on recv from errqueue.
