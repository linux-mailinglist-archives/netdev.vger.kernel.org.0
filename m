Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E2AB742F7B3
	for <lists+netdev@lfdr.de>; Fri, 15 Oct 2021 18:08:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241129AbhJOQK5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Oct 2021 12:10:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236309AbhJOQK4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Oct 2021 12:10:56 -0400
Received: from mail-ua1-x931.google.com (mail-ua1-x931.google.com [IPv6:2607:f8b0:4864:20::931])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AEF21C061570
        for <netdev@vger.kernel.org>; Fri, 15 Oct 2021 09:08:49 -0700 (PDT)
Received: by mail-ua1-x931.google.com with SMTP id h19so18991294uax.5
        for <netdev@vger.kernel.org>; Fri, 15 Oct 2021 09:08:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=W/QqMDzHh53aqgUQsAFCEbvWMw4xb3zGnxTgFnVLaHY=;
        b=avEwJ6czmdP44J5cY4NbKPfz+w2JUk0fF4KTTOQT+/W2ZypeoHXd1GWsf74Fjhbmcr
         bvQsHPKvGYtGIaOFPCJxzSW4vmCiLt5xyHvNW1DqwrUMxpdwJh6uaxuBgaCWGTfl2/5/
         L5aZYCLjkt/pl3O836bjCc+fQgt9dD0sJeHGjgTGLi8+zN9bkaDXAxUML1jpKZ5sGOTC
         bqxMpF5zTv/mJkrw9xmDBzamrhCfoeBRAQt1x+WZdngYGyCemUYtCglL+/c/H+e16o6q
         JJTOcbJ0eeXq0PO5t5RR1qtATg9ZX9AHVGXS3hqWtSmmfPrE+XZybxf3pzFPq9OYSxe3
         e9lg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=W/QqMDzHh53aqgUQsAFCEbvWMw4xb3zGnxTgFnVLaHY=;
        b=FaZ9wIRbWCrSKs1kGSlydbjoRwX/8rdvrtpUQP40ifjCLgCO908XIB2a41tzfQCr7C
         BuXJ0S2JsdmXL4olC6yFViJNc8Tu89zT8LHpVB4nZ+fJpdNG0Q/Mk4vRmFlKmiOZM37E
         vub08JQmzVhhRDimlgy2n5OcN+lLBAQkHvJXs+JQgZFBeIVVkMN+D6EbmL3jxc3CfXxL
         c8kmjB/d7rDsEgdYWFJu6jrqQ1uuP9G4IUKm6HqMinGD3g1N9C3LmftTcjn5XsORB4aK
         N816ugIsKwjqi8VHvI+5kSDNQHEduhwYWQPHRXLGKDHmRS/FJ7kSx6lSAFumFrzowwv6
         2xAA==
X-Gm-Message-State: AOAM533NqQ8AusAbkcg/8Um781KVcG17wrDs4ouL6emdA4/2KzAMC31j
        N/pNcTuBCliorUmP6cKX221G4+C+cv+j94sDGuqyAQ==
X-Google-Smtp-Source: ABdhPJwkjUXsiHNIoMmayekpggaXDFv9/MM+zPih+YHZ7w5sqG1Xsn6PTv0Qc2/UB34s0TKtFp8r1hMXlfa42RjJM88=
X-Received: by 2002:a05:6102:1342:: with SMTP id j2mr14514063vsl.43.1634314128708;
 Fri, 15 Oct 2021 09:08:48 -0700 (PDT)
MIME-Version: 1.0
References: <20210924235456.2413081-1-weiwan@google.com>
In-Reply-To: <20210924235456.2413081-1-weiwan@google.com>
From:   Wei Wang <weiwan@google.com>
Date:   Fri, 15 Oct 2021 09:08:37 -0700
Message-ID: <CAEA6p_CSbFFiEUQKy_n5dBd-oBWLq1L0CZYjECqBfjjkeQoSdg@mail.gmail.com>
Subject: Re: [patch v3] tcp.7: Add description for TCP_FASTOPEN and
 TCP_FASTOPEN_CONNECT options
To:     Alejandro Colomar <alx.manpages@gmail.com>,
        Michael Kerrisk <mtk.manpages@gmail.com>,
        linux-man@vger.kernel.org
Cc:     netdev@vger.kernel.org, Yuchung Cheng <ycheng@google.com>,
        Neal Cardwell <ncardwell@google.com>,
        Eric Dumazet <edumazet@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 24, 2021 at 4:54 PM Wei Wang <weiwan@google.com> wrote:
>
> TCP_FASTOPEN socket option was added by:
> commit 8336886f786fdacbc19b719c1f7ea91eb70706d4
> TCP_FASTOPEN_CONNECT socket option was added by the following patch
> series:
> commit 065263f40f0972d5f1cd294bb0242bd5aa5f06b2
> commit 25776aa943401662617437841b3d3ea4693ee98a
> commit 19f6d3f3c8422d65b5e3d2162e30ef07c6e21ea2
> commit 3979ad7e82dfe3fb94a51c3915e64ec64afa45c3
> Add detailed description for these 2 options.
> Also add descriptions for /proc entry tcp_fastopen and tcp_fastopen_key.
>
> Signed-off-by: Wei Wang <weiwan@google.com>
> ---

Hi Alex,

Does this version look OK to you to apply?
Let me know.

Thanks.
Wei

>  man7/tcp.7 | 125 +++++++++++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 125 insertions(+)
>
> diff --git a/man7/tcp.7 b/man7/tcp.7
> index 0a7c61a37..bdd4a33ca 100644
> --- a/man7/tcp.7
> +++ b/man7/tcp.7
> @@ -423,6 +423,28 @@ option.
>  .\" Since 2.4.0-test7
>  Enable RFC\ 2883 TCP Duplicate SACK support.
>  .TP
> +.IR tcp_fastopen  " (Bitmask; default: 0x1; since Linux 3.7)"
> +Enables RFC\ 7413 Fast Open support.
> +The flag is used as a bitmap with the following values:
> +.RS
> +.IP 0x1
> +Enables client side Fast Open support
> +.IP 0x2
> +Enables server side Fast Open support
> +.IP 0x4
> +Allows client side to transmit data in SYN without Fast Open option
> +.IP 0x200
> +Allows server side to accept SYN data without Fast Open option
> +.IP 0x400
> +Enables Fast Open on all listeners without
> +.B TCP_FASTOPEN
> +socket option
> +.RE
> +.TP
> +.IR tcp_fastopen_key " (since Linux 3.7)"
> +Set server side RFC\ 7413 Fast Open key to generate Fast Open cookie
> +when server side Fast Open support is enabled.
> +.TP
>  .IR tcp_ecn " (Integer; default: see below; since Linux 2.4)"
>  .\" Since 2.4.0-test7
>  Enable RFC\ 3168 Explicit Congestion Notification.
> @@ -1202,6 +1224,109 @@ Bound the size of the advertised window to this value.
>  The kernel imposes a minimum size of SOCK_MIN_RCVBUF/2.
>  This option should not be used in code intended to be
>  portable.
> +.TP
> +.BR TCP_FASTOPEN " (since Linux 3.6)"
> +This option enables Fast Open (RFC\ 7413) on the listener socket.
> +The value specifies the maximum length of pending SYNs
> +(similar to the backlog argument in
> +.BR listen (2)).
> +Once enabled,
> +the listener socket grants the TCP Fast Open cookie on incoming
> +SYN with TCP Fast Open option.
> +.IP
> +More importantly it accepts the data in SYN with a valid Fast Open cookie
> +and responds SYN-ACK acknowledging both the data and the SYN sequence.
> +.BR accept (2)
> +returns a socket that is available for read and write when the handshake
> +has not completed yet.
> +Thus the data exchange can commence before the handshake completes.
> +This option requires enabling the server-side support on sysctl
> +.IR net.ipv4.tcp_fastopen
> +(see above).
> +For TCP Fast Open client-side support,
> +see
> +.BR send (2)
> +.B MSG_FASTOPEN
> +or
> +.B TCP_FASTOPEN_CONNECT
> +below.
> +.TP
> +.BR TCP_FASTOPEN_CONNECT " (since Linux 4.11)"
> +This option enables an alternative way to perform Fast Open on the active
> +side (client).
> +When this option is enabled,
> +.BR connect (2)
> +would behave differently depending on if a Fast Open cookie is available
> +for the destination.
> +.IP
> +If a cookie is not available (i.e. first contact to the destination),
> +.BR connect (2)
> +behaves as usual by sending a SYN immediately,
> +except the SYN would include an empty Fast Open cookie option to solicit a
> +cookie.
> +.IP
> +If a cookie is available,
> +.BR connect (2)
> +would return 0 immediately but the SYN transmission is defered.
> +A subsequent
> +.BR write (2)
> +or
> +.BR sendmsg (2)
> +would trigger a SYN with data plus cookie in the Fast Open option.
> +In other words,
> +the actual connect operation is deferred until data is supplied.
> +.IP
> +.B Note:
> +While this option is designed for convenience,
> +enabling it does change the behaviors and certain system calls might set
> +different
> +.I errno
> +values.
> +With cookie present,
> +.BR write (2)
> +or
> +.BR sendmsg (2)
> +must be called right after
> +.BR connect (2)
> +in order to send out SYN+data to complete 3WHS and establish connection.
> +Calling
> +.BR read (2)
> +right after
> +.BR connect (2)
> +without
> +.BR write (2)
> +will cause the blocking socket to be blocked forever.
> +.IP
> +The application should  either set
> +.B TCP_FASTOPEN_CONNECT
> +socket option before
> +.BR write (2)
> +or
> +.BR sendmsg (2)
> +,
> +or call
> +.BR write (2)
> +or
> +.BR sendmsg (2)
> +with
> +.B MSG_FASTOPEN
> +flag directly,
> +instead of both on the same connection.
> +.IP
> +Here is the typical call flow with this new option:
> +.IP
> +.in +4n
> +.EX
> +s = socket();
> +setsockopt(s, IPPROTO_TCP, TCP_FASTOPEN_CONNECT, 1, ...);
> +connect(s);
> +write(s); // write() should always follow connect() in order to trigger SYN to go out
> +read(s)/write(s);
> +...
> +close(s);
> +.EE
> +.in
> +.IP
>  .SS Sockets API
>  TCP provides limited support for out-of-band data,
>  in the form of (a single byte of) urgent data.
> --
> 2.33.0.685.g46640cef36-goog
>
