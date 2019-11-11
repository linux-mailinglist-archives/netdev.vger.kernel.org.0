Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2B9EFF812D
	for <lists+netdev@lfdr.de>; Mon, 11 Nov 2019 21:25:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727784AbfKKUZL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Nov 2019 15:25:11 -0500
Received: from mout.kundenserver.de ([212.227.126.187]:47769 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726877AbfKKUZL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Nov 2019 15:25:11 -0500
Received: from mail-qt1-f181.google.com ([209.85.160.181]) by
 mrelayeu.kundenserver.de (mreue009 [212.227.15.129]) with ESMTPSA (Nemesis)
 id 1MYNW6-1iQONL2Pbe-00VQFV; Mon, 11 Nov 2019 21:25:09 +0100
Received: by mail-qt1-f181.google.com with SMTP id y10so17088264qto.3;
        Mon, 11 Nov 2019 12:25:09 -0800 (PST)
X-Gm-Message-State: APjAAAV+2PBGLq+67cID09YvSZq+exVi39pbXUyxlF+SDNPVPKakEAJg
        /81+mKjsn2nJqKINk8cb7OSTp/3sGTdDZedjVLY=
X-Google-Smtp-Source: APXvYqxYKwc9AQItiNIOwZ2+wxDyN2mshA68mKukz40flGha4d3PjHaLU7oc+tzqqumjcL7RS5kXZzgs7n2BU3mg3Y4=
X-Received: by 2002:ac8:67d9:: with SMTP id r25mr27768950qtp.7.1573503908430;
 Mon, 11 Nov 2019 12:25:08 -0800 (PST)
MIME-Version: 1.0
References: <20191108210236.1296047-1-arnd@arndb.de> <20191108211323.1806194-4-arnd@arndb.de>
In-Reply-To: <20191108211323.1806194-4-arnd@arndb.de>
From:   Arnd Bergmann <arnd@arndb.de>
Date:   Mon, 11 Nov 2019 21:24:51 +0100
X-Gmail-Original-Message-ID: <CAK8P3a2k-ZHAiCMBHWHvtwRfYqnz7aFGfqSYT8sLSyOf7Dm8Aw@mail.gmail.com>
Message-ID: <CAK8P3a2k-ZHAiCMBHWHvtwRfYqnz7aFGfqSYT8sLSyOf7Dm8Aw@mail.gmail.com>
Subject: Re: [PATCH 13/23] y2038: socket: remove timespec reference in timestamping
To:     y2038 Mailman List <y2038@lists.linaro.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Deepa Dinamani <deepa.kernel@gmail.com>,
        Willem de Bruijn <willemb@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Networking <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Provags-ID: V03:K1:mRBSh5cgFckhT9zUEAiAAIs6/5cxzy7bsSmB45MHXVbF7cTR5oG
 d7z3+vKE+Qe207ONHjMT1yhf1ifvJOvcJItomItB6pPBlNFdbGoNk6WU5k3adlr61gM9M6Z
 E2d54s5sTnK8cHUI1J4oCEoifT/xSWlcP6xLCsFosvoe7KI2o7w9twpbFoyfsCazEDz9HXT
 j/x7so+S6Wub4J8QhiNYA==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:zY3+0hYuvcE=:Q+KyCStI0dTtUZUMMAG01+
 xa47pkOOOVSBOrKs3IvYlPMpJFmt25hstitgqyY7wYrxLZTfYXylrxKGNv7KAETeu44b1Kbnz
 25OBPQpNfDSVcrUEdW4MwQnKqpWO8YajjKZrXKAHLnVSDTARP6jRQMV983uUbURkmcy2ImZMD
 nkKP9FpLcXT86/EGtRKAyisk0NVqTVaTV3hdBIphCcYBbNrLYA9bgAnDD8CiXdpiXxcuK8rzs
 iBFCk51YYbjewZKRJoMcSwnL3KQCcA9/JFp672uqp0uRTmz7oeOU1BnaysRSc22mRkNWRH/M2
 BfJwgxj3ab3EVenLPyttOzfOucOCmJjKuTW+MaoS8jFyv71mo9w1UmQX/odkBZfXySleuFxMI
 PTvOpDwCtt89ldRaZS89PDcKhyevp/dKnq2OMLNkzp9Q0CRIWzfQMIpEQ2JmUEIF2C2Iuy80y
 vv6YaJmikkWcq1XpxWWhrrEJKKVv8YKqvjZQXvk9tJQfJYefmb/6rlmffddoai2JSiIv7av5a
 36g+neO83AqdtG2xwBYB9SKquhtgja7iA7iHo9Y5+YPclfiRqGJ4CZfA7Uyi2+uL1HBOMa6Op
 JZhrHbt8lgGGyWUWFtZlYwHmtYFiv0yODjLnJYZ8HnLgL6r07+fG9Si1ANoCXiK5bBtKNp2HB
 gwm69TWRNbQqlpfFdl7c8tmaiwccWI0Sp7OCMHSv++qwJvqQ+crWK4P5DQPhamLCFb+7/CtqA
 0qWWRcriyzqmQbFbHAkqfolJuDMaNOW4TBX8RAPbvMZ6D0nfZZ5rObVltR4UJ0TR9b12E2hD4
 gSdkaHxC+IRV9rO8/uEW5/ejsTdKHYqilpfKvR+3Ibax3mx71pU23DHgun/oqCT6Gr852LwGp
 sVahtqQryfXJ4EyT7Suw==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 8, 2019 at 10:15 PM Arnd Bergmann <arnd@arndb.de> wrote:

> diff --git a/include/uapi/linux/errqueue.h b/include/uapi/linux/errqueue.h
> index 28491dac074b..0cca19670fd2 100644
> --- a/include/uapi/linux/errqueue.h
> +++ b/include/uapi/linux/errqueue.h
> @@ -37,9 +37,16 @@ struct sock_extended_err {
>   *     The timestamping interfaces SO_TIMESTAMPING, MSG_TSTAMP_*
>   *     communicate network timestamps by passing this struct in a cmsg with
>   *     recvmsg(). See Documentation/networking/timestamping.txt for details.
> + *     User space sees a timespec definition that matches either
> + *     __kernel_timespec or __kernel_old_timespec, in the kernel we
> + *     require two structure definitions to provide both.
>   */
>  struct scm_timestamping {
> +#ifdef __KERNEL__
> +       struct __kernel_old_timespec ts[3];
> +#else
>         struct timespec ts[3];
> +#endif
>  };

The kbuild bot pointed out that the way I sent this series, the use of
__kernel_old_timespec
causes a build failure, because I introduce this in a separate submission. I'm
moving this patch over to the other series, and changing the subject to

y2038: socket: use __kernel_old_timespec instead of timespec

With the expectation of merging it along with the other core patches.

      Arnd
