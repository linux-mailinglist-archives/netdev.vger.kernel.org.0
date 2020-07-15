Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 434752214F9
	for <lists+netdev@lfdr.de>; Wed, 15 Jul 2020 21:17:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726942AbgGOTRU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jul 2020 15:17:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:42630 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726722AbgGOTRU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 15 Jul 2020 15:17:20 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4AF832076C;
        Wed, 15 Jul 2020 19:17:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594840639;
        bh=x3XkBZKKmpZo/K5hL/TFryLVZ2vrqSWHl2APl+XqCNY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=hN5bjlmLUrQOXgaC1ls9K7/2944oPb6yzNjnFLIIN2LX4Zt9SDpuGOuM2SROWpY3a
         cweN5ibLfZQtkY3JfurJWMru1hLEn6VKGyTeY195JDIQdcw6nqZSDoJ1csi2O+eytm
         Szqffwn98KFGPcUqCUJ4cvhs8uFzjEzci9yKs1tA=
Date:   Wed, 15 Jul 2020 12:17:17 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Vladimir Oltean <olteanv@gmail.com>,
        Jonathan Corbet <corbet@lwn.net>
Cc:     netdev@vger.kernel.org, davem@davemloft.net,
        richardcochran@gmail.com, sorganov@gmail.com, andrew@lunn.ch,
        linux-doc@vger.kernel.org
Subject: Re: [PATCH net-next] docs: networking: timestamping: replace tabs
 with spaces in code blocks
Message-ID: <20200715121717.41aaff49@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200709202210.72985-1-olteanv@gmail.com>
References: <20200709202210.72985-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu,  9 Jul 2020 23:22:10 +0300 Vladimir Oltean wrote:
> Reading the document in vim is currently not a pleasant experience. Its
> rst syntax highlighting is confused by the "*/" sequences which it's not
> interpreting as part of the code blocks for some reason.
> 
> Replace the tabs with spaces, so that syntax highlighters (at least the
> one in vim) have a better idea where code blocks start and where they
> end.
> 
> Signed-off-by: Vladimir Oltean <olteanv@gmail.com>

Dunno about this change, there seems to be plenty examples of using
tabs for indentation of code block :(

Jon, any guidance? It seems to me the document renders correctly [1],
so the onus is on the editor to fix the RST highlight..

[1] https://www.kernel.org/doc/html/latest/networking/timestamping.html 

> diff --git a/Documentation/networking/timestamping.rst b/Documentation/networking/timestamping.rst
> index 03f7beade470..5fa4e2274dd9 100644
> --- a/Documentation/networking/timestamping.rst
> +++ b/Documentation/networking/timestamping.rst
> @@ -257,13 +257,13 @@ setsockopt::
>  
>    struct msghdr *msg;
>    ...
> -  cmsg			       = CMSG_FIRSTHDR(msg);
> -  cmsg->cmsg_level	       = SOL_SOCKET;
> -  cmsg->cmsg_type	       = SO_TIMESTAMPING;
> -  cmsg->cmsg_len	       = CMSG_LEN(sizeof(__u32));
> +  cmsg                         = CMSG_FIRSTHDR(msg);
> +  cmsg->cmsg_level             = SOL_SOCKET;
> +  cmsg->cmsg_type              = SO_TIMESTAMPING;
> +  cmsg->cmsg_len               = CMSG_LEN(sizeof(__u32));
>    *((__u32 *) CMSG_DATA(cmsg)) = SOF_TIMESTAMPING_TX_SCHED |
> -				 SOF_TIMESTAMPING_TX_SOFTWARE |
> -				 SOF_TIMESTAMPING_TX_ACK;
> +                                 SOF_TIMESTAMPING_TX_SOFTWARE |
> +                                 SOF_TIMESTAMPING_TX_ACK;
>    err = sendmsg(fd, msg, 0);
>  
>  The SOF_TIMESTAMPING_TX_* flags set via cmsg will override
> @@ -273,7 +273,7 @@ Moreover, applications must still enable timestamp reporting via
>  setsockopt to receive timestamps::
>  
>    __u32 val = SOF_TIMESTAMPING_SOFTWARE |
> -	      SOF_TIMESTAMPING_OPT_ID /* or any other flag */;
> +              SOF_TIMESTAMPING_OPT_ID /* or any other flag */;
>    err = setsockopt(fd, SOL_SOCKET, SO_TIMESTAMPING, &val, sizeof(val));
>  
>  
> @@ -354,14 +354,14 @@ SOL_SOCKET, cmsg_type SCM_TIMESTAMPING, and payload of type
>  
>  For SO_TIMESTAMPING_OLD::
>  
> -	struct scm_timestamping {
> -		struct timespec ts[3];
> -	};
> +        struct scm_timestamping {
> +                struct timespec ts[3];
> +        };
>  
>  For SO_TIMESTAMPING_NEW::
>  
> -	struct scm_timestamping64 {
> -		struct __kernel_timespec ts[3];
> +        struct scm_timestamping64 {
> +                struct __kernel_timespec ts[3];
>  
>  Always use SO_TIMESTAMPING_NEW timestamp to always get timestamp in
>  struct scm_timestamping64 format.
> @@ -468,11 +468,11 @@ Hardware time stamping must also be initialized for each device driver
>  that is expected to do hardware time stamping. The parameter is defined in
>  include/uapi/linux/net_tstamp.h as::
>  
> -	struct hwtstamp_config {
> -		int flags;	/* no flags defined right now, must be zero */
> -		int tx_type;	/* HWTSTAMP_TX_* */
> -		int rx_filter;	/* HWTSTAMP_FILTER_* */
> -	};
> +        struct hwtstamp_config {
> +                int flags;      /* no flags defined right now, must be zero */
> +                int tx_type;    /* HWTSTAMP_TX_* */
> +                int rx_filter;  /* HWTSTAMP_FILTER_* */
> +        };
>  
>  Desired behavior is passed into the kernel and to a specific device by
>  calling ioctl(SIOCSHWTSTAMP) with a pointer to a struct ifreq whose
> @@ -505,42 +505,42 @@ not been implemented in all drivers.
>  
>  ::
>  
> -    /* possible values for hwtstamp_config->tx_type */
> -    enum {
> -	    /*
> -	    * no outgoing packet will need hardware time stamping;
> -	    * should a packet arrive which asks for it, no hardware
> -	    * time stamping will be done
> -	    */
> -	    HWTSTAMP_TX_OFF,
> -
> -	    /*
> -	    * enables hardware time stamping for outgoing packets;
> -	    * the sender of the packet decides which are to be
> -	    * time stamped by setting SOF_TIMESTAMPING_TX_SOFTWARE
> -	    * before sending the packet
> -	    */
> -	    HWTSTAMP_TX_ON,
> -    };
> -
> -    /* possible values for hwtstamp_config->rx_filter */
> -    enum {
> -	    /* time stamp no incoming packet at all */
> -	    HWTSTAMP_FILTER_NONE,
> -
> -	    /* time stamp any incoming packet */
> -	    HWTSTAMP_FILTER_ALL,
> -
> -	    /* return value: time stamp all packets requested plus some others */
> -	    HWTSTAMP_FILTER_SOME,
> -
> -	    /* PTP v1, UDP, any kind of event packet */
> -	    HWTSTAMP_FILTER_PTP_V1_L4_EVENT,
> -
> -	    /* for the complete list of values, please check
> -	    * the include file include/uapi/linux/net_tstamp.h
> -	    */
> -    };
> +   /* possible values for hwtstamp_config->tx_type */
> +   enum {
> +           /*
> +           * no outgoing packet will need hardware time stamping;
> +           * should a packet arrive which asks for it, no hardware
> +           * time stamping will be done
> +           */
> +           HWTSTAMP_TX_OFF,
> +
> +           /*
> +           * enables hardware time stamping for outgoing packets;
> +           * the sender of the packet decides which are to be
> +           * time stamped by setting SOF_TIMESTAMPING_TX_SOFTWARE
> +           * before sending the packet
> +           */
> +           HWTSTAMP_TX_ON,
> +   };
> +
> +   /* possible values for hwtstamp_config->rx_filter */
> +   enum {
> +           /* time stamp no incoming packet at all */
> +           HWTSTAMP_FILTER_NONE,
> +
> +           /* time stamp any incoming packet */
> +           HWTSTAMP_FILTER_ALL,
> +
> +           /* return value: time stamp all packets requested plus some others */
> +           HWTSTAMP_FILTER_SOME,
> +
> +           /* PTP v1, UDP, any kind of event packet */
> +           HWTSTAMP_FILTER_PTP_V1_L4_EVENT,
> +
> +           /* for the complete list of values, please check
> +           * the include file include/uapi/linux/net_tstamp.h
> +           */
> +   };
>  
>  3.1 Hardware Timestamping Implementation: Device Drivers
>  --------------------------------------------------------
> @@ -555,10 +555,10 @@ to the shared time stamp structure of the skb call skb_hwtstamps(). Then
>  set the time stamps in the structure::
>  
>      struct skb_shared_hwtstamps {
> -	    /* hardware time stamp transformed into duration
> -	    * since arbitrary point in time
> -	    */
> -	    ktime_t	hwtstamp;
> +            /* hardware time stamp transformed into duration
> +            * since arbitrary point in time
> +            */
> +            ktime_t     hwtstamp;
>      };
>  
>  Time stamps for outgoing packets are to be generated as follows:

