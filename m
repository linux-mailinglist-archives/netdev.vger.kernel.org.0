Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0EAC76E3C9E
	for <lists+netdev@lfdr.de>; Mon, 17 Apr 2023 00:27:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229664AbjDPW1G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 16 Apr 2023 18:27:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229446AbjDPW1F (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 16 Apr 2023 18:27:05 -0400
Received: from nautica.notk.org (ipv6.notk.org [IPv6:2001:41d0:1:7a93::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3778A269E;
        Sun, 16 Apr 2023 15:27:04 -0700 (PDT)
Received: by nautica.notk.org (Postfix, from userid 108)
        id 0ADE2C009; Mon, 17 Apr 2023 00:27:03 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codewreck.org; s=2;
        t=1681684023; bh=M+qG9tBDP0q6BoIuH0STukSZh3pZTkWN9eRiZkUJxbk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=0ZwelhQgh3FyP+PUx1/r9n7J0Q5eIpp0n40fsVrEKxJEqPavrmNZLeXoTlrRKyo4D
         kRx4pjz4oEnUmc7aGAGHYUAnv1S6SvRrRzPO0f7MG4/bIyrZ8uB+mwdV4CRp/ali6R
         3a0cQGpnGovoTAxrdnESDIVZ9IDHABsf5JJE2sIUnYgt4IYzPrSekNz6SARfSwXQdH
         RGih2FU3ylcU/hnh9tIIRCNRwhw7dW5YmPKFTNFyCrg1NtTpZdvtqvfF0Zms1bTKzu
         xVCwkjz2kYtNdh6UT/cZ6NLGBZWJMz0pniSPR+tcU4HXKCXAoRI70rGGOo3nUXxQ9N
         NX5QHgOFdrwvQ==
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
X-Spam-Level: 
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
Received: from odin.codewreck.org (localhost [127.0.0.1])
        by nautica.notk.org (Postfix) with ESMTPS id C741BC009;
        Mon, 17 Apr 2023 00:26:58 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codewreck.org; s=2;
        t=1681684022; bh=M+qG9tBDP0q6BoIuH0STukSZh3pZTkWN9eRiZkUJxbk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=HJnlOxUTpvfnHYXh/DTjd9wz9+6Uw5UjUKrgVBsHbaMWW6cVVakw4+7GCG4fcrFrv
         BWsDgOUuchOpOPbjQfr5IWqEi8iizwixZL4RilLr9WCoF4WOjgK1SlDADGoHOwf9n3
         s439atTCQmxgnp7dFKQnFFzfmTdmcnpz9iJPvHAIDDiRnZ3tv7L3B2mcmiu1pw4zrm
         wSIxaio4681GJRpK8VTOS0MNwkJAPPHRTdYo69YYlWx7i7eFuxUkmzICWRKatS0NKG
         D02MfZYzJFY30Vwo56sawgyEIH4+Bi6bDmo6jyRmoF+rFkpovqasFHynCJY2ogFF9I
         bP68wC10+k2og==
Received: from localhost (odin.codewreck.org [local])
        by odin.codewreck.org (OpenSMTPD) with ESMTPA id e80dcd00;
        Sun, 16 Apr 2023 22:26:56 +0000 (UTC)
Date:   Mon, 17 Apr 2023 07:26:41 +0900
From:   Dominique Martinet <asmadeus@codewreck.org>
To:     Samuel Thibault <samuel.thibault@ens-lyon.org>
Cc:     James Chapman <jchapman@katalix.com>, tparkin@katalix.com,
        edumazet@google.com, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, corbet@lwn.net, netdev@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] PPPoL2TP: Add more code snippets
Message-ID: <ZDx2IUYTmLSdzU6D@codewreck.org>
References: <20230416220704.xqk4q6uwjbujnqpv@begin>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20230416220704.xqk4q6uwjbujnqpv@begin>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Samuel Thibault wrote on Mon, Apr 17, 2023 at 12:07:04AM +0200:
> The existing documentation was not telling that one has to create a PPP
> channel and a PPP interface to get PPPoL2TP data offloading working.
> 
> Also, tunnel switching was not described, so that people were thinking
> it was not supported, while it actually is.
> 
> Signed-off-by: Samuel Thibault <samuel.thibault@ens-lyon.org>

Just passing by, thanks!
The update made me ask a couple more questions so I've commented below,
but I think this is already useful in itself so don't hold back for me.

> ---
>  Documentation/networking/l2tp.rst |   59 ++++++++++++++++++++++++++++++++++++--
>  1 file changed, 56 insertions(+), 3 deletions(-)
> 
> --- a/Documentation/networking/l2tp.rst
> +++ b/Documentation/networking/l2tp.rst
> @@ -387,11 +387,12 @@ Sample userspace code:
>    - Create session PPPoX data socket::
>  
>          struct sockaddr_pppol2tp sax;
> -        int fd;
> +        int ret;
>  
>          /* Note, the tunnel socket must be bound already, else it
>           * will not be ready
>           */
> +        int session_fd = socket(AF_PPPOX, SOCK_DGRAM, PX_PROTO_OL2TP);
>          sax.sa_family = AF_PPPOX;
>          sax.sa_protocol = PX_PROTO_OL2TP;
>          sax.pppol2tp.fd = tunnel_fd;
> @@ -406,12 +407,64 @@ Sample userspace code:
>          /* session_fd is the fd of the session's PPPoL2TP socket.
>           * tunnel_fd is the fd of the tunnel UDP / L2TPIP socket.
>           */
> -        fd = connect(session_fd, (struct sockaddr *)&sax, sizeof(sax));
> -        if (fd < 0 ) {
> +        ret = connect(session_fd, (struct sockaddr *)&sax, sizeof(sax));
> +        if (ret < 0 ) {
>                  return -errno;
>          }
>          return 0;
>  
> +  - Create PPP channel::
> +
> +        int chindx;
> +        ret = ioctl(session_fd, PPPIOCGCHAN, &chindx);
> +        if (ret < 0)
> +                return -errno;
> +
> +        int ppp_chan_fd = open("/dev/ppp", O_RDWR);
> +
> +        ret = ioctl(ppp_chan_fd, PPPIOCATTCHAN, &chindx);
> +        if (ret < 0)
> +                return -errno;
> +
> +Non-data PPP frames will be available for read on `ppp_chan_fd`.
> +
> +  - Create PPP interface::
> +
> +        int ppp_if_fd = open("/dev/ppp", O_RDWR);
> +
> +        int ifunit;
> +        ret = ioctl(ppp_if_fd, PPPIOCNEWUNIT, &ifunit);
> +        if (ret < 0)
> +                return -errno;
> +
> +        ret = ioctl(ppp_chan_fd, PPPIOCCONNECT, ifunit);
> +        if (ret < 0)
> +                return -errno;
> +
> +The ppp<ifunit> interface can then be configured as usual with SIOCSIFMTU,
> +SIOCSIFADDR, SIOCSIFDSTADDR, SIOCSIFNETMASK, and activated by setting IFF_UP
> +with SIOCSIFFLAGS

(That somewhat makes it sounds like the "new" netlink interface cannot
be used (e.g. ip command); although I guess sommeone implementing this
would be more likely to use the ioctls than not so having the names can
be a timesaver?)

Also, this got me wondering if the 'if' fd can be closed immediately or
if the interface will be removed when the fd is closed (probably not?)
If the fd can immediately be closed, could the chan fd or another fd be
used instead, saving an open?

> +
> +  - Tunnel switching is supported by bridging channels::
> +
> +        int chindx;
> +        ret = ioctl(session_fd, PPPIOCGCHAN, &chindx);
> +        if (ret < 0)
> +                return -errno;
> +
> +        int chindx2;
> +        ret = ioctl(session_fd2, PPPIOCGCHAN, &chind2x);
> +        if (ret < 0)
> +                return -errno;
> +
> +        int ppp_chan_fd = open("/dev/ppp", O_RDWR);
> +
> +        ret = ioctl(ppp_chan_fd, PPPIOCBRIDGECHAN, &chindx2);
> +        if (ret < 0)
> +                return -errno;
> +
> +        close(ppp_chan_fd);
> +
>  Old L2TPv2-only API
>  -------------------
>  

-- 
Dominique Martinet | Asmadeus
