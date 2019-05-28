Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2FE0E2D111
	for <lists+netdev@lfdr.de>; Tue, 28 May 2019 23:37:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727805AbfE1Vhh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 May 2019 17:37:37 -0400
Received: from mail-ed1-f42.google.com ([209.85.208.42]:39110 "EHLO
        mail-ed1-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726812AbfE1Vhh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 May 2019 17:37:37 -0400
Received: by mail-ed1-f42.google.com with SMTP id e24so173398edq.6;
        Tue, 28 May 2019 14:37:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=+SzQmfEsdNdnW/gwHRsf2NlK+gsoysG5VVC699wH/5g=;
        b=SrqDnbq/jwnrtf6K/w+IP3kCR3stLry7Fo+17Qkh/wzU4I1dFV1ca8BhnJiuMnYE0X
         9QpJvPX9BYX8ZfW/4MjyHqpjeiq49jBMoZa5bBgMtL36xRU/H3Zb9DM3zK6QIWsrFs3l
         ePDwE8eP+Kln3IMVwrhez8HKTjhH8ufKw1cNus45P0H/1fKQmCQvcjx5iOmdlRBU3b3v
         mS1XWhSZMs+sGq8WPDXWoI+v0oN/hKkZx3V2fUatXovNa5sxREdPCZApeJDHCIYtDw5X
         cQmT7F72xL+96Xo9NuyzXsGVRWVpo6DklMVLfF0avWt4vfGFcxwkL6TV4OTgnLNfi48P
         tmiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=+SzQmfEsdNdnW/gwHRsf2NlK+gsoysG5VVC699wH/5g=;
        b=cco6ruP3b6H/mtjM55Ns3FDSg2631YHxe/5Z6YMVuKGprmVOxTSjadHOP7YSzL4fXq
         TB3cNmr+71MwQWzDtdiuZLTKvWJbLp+L7ZPbzNgzUyX3bBFTz3fwJbCy1tkCrJy7eB2b
         Q3UOFejSUqypWbcrb7AznlEyULv2GVmp9BnroqDDV4CcJYvAGVd774KelmoRUcFL1g5o
         h8TEfdmwBBr+9nuLDPhc4q2WU5Oh0JVOYeUkn7TyDBxti4Nwukt5XXjJzFMaNIcga/0v
         0K8WzhXV1Ho7a9z4TH4h1gKVrCGHP017RphMebOEbePDAvchdvicDBXB9u2l4I8qCNwL
         o0pw==
X-Gm-Message-State: APjAAAXcZ7PNG1rPgqbTEMeE3+B2Gb0XF96X35RD4IM21eORONJrQdcH
        gZ18z5HPvqY8YVfAM0pAlddDDljvg/I674tjTLM=
X-Google-Smtp-Source: APXvYqzPiPdEha9a/8wDQwaIISfKBAzxq2je8/sQO/a1mWCN6wJFBdh82K0gEfkZk6kuPeqK95XobgSG1JLLUKT0ccc=
X-Received: by 2002:a05:6402:745:: with SMTP id p5mr35984041edy.62.1559079454728;
 Tue, 28 May 2019 14:37:34 -0700 (PDT)
MIME-Version: 1.0
References: <20190528184708.16516-1-fklassen@appneta.com> <20190528184708.16516-2-fklassen@appneta.com>
In-Reply-To: <20190528184708.16516-2-fklassen@appneta.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Tue, 28 May 2019 17:36:58 -0400
Message-ID: <CAF=yD-+r9rqRg5vpO1EEVKDjROe_hZhLCQSQxZCBgro9V28+2g@mail.gmail.com>
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
> +
> +                       tss = (struct scm_timestamping *)CMSG_DATA(cmsg);
> +                       if (tss->ts[i].tv_sec == 0)
> +                               stat_tx_ts_errors++;
> +               } else {
> +                       error(1, 0,
> +                             "unknown SOL_SOCKET cmsg type=%u level=%u\n",
> +                             cmsg->cmsg_type, cmsg->cmsg_level);
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
> +                                       stat_zcopy_errors++;
> +                                       if (cfg_verbose)
> +                                               fprintf(stderr,
> +                                                       "Zerocopy TX aborted: lo=%u hi=%u\n",
> +                                                       lo, hi);
> +                               } else if (hi == lo) {
> +                                       // single ID acknowledged
> +                                       stat_zcopies++;
> +                               } else {
> +                                       // range of IDs acknowledged
> +                                       stat_zcopies += hi - lo + 1;
> +                               }
> +                               break;
> +                       }
> +                       case SO_EE_ORIGIN_LOCAL:
> +                               if (cfg_verbose)
> +                                       fprintf(stderr,
> +                                               "received packet with local origin: %u\n",
> +                                               err->ee_origin);
> +                               break;
> +                       default:
> +                               error(0, 1,

here and two following, error(1, 0, ..);

> +                                     "received packet with origin: %u",
> +                                     err->ee_origin);
> +                       }
> +
> +                       break;
> +               }
> +               default:
> +                       error(0, 1, "unknown IP msg type=%u level=%u\n",
> +                             cmsg->cmsg_type, cmsg->cmsg_level);
> +                       break;
> +               }
> +               break;
> +       default:
> +               error(0, 1, "unknown cmsg type=%u level=%u\n",
> +                     cmsg->cmsg_type, cmsg->cmsg_level);
> +       }
> +}
