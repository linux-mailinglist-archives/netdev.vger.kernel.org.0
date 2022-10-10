Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DAE3D5FA3F2
	for <lists+netdev@lfdr.de>; Mon, 10 Oct 2022 21:08:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229847AbiJJTIV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Oct 2022 15:08:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229832AbiJJTIT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Oct 2022 15:08:19 -0400
Received: from ms.lwn.net (ms.lwn.net [IPv6:2600:3c01:e000:3a1::42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2D7711C05;
        Mon, 10 Oct 2022 12:08:18 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:281:8300:73:8b7:7001:c8aa:b65f])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ms.lwn.net (Postfix) with ESMTPSA id 14158299;
        Mon, 10 Oct 2022 19:08:18 +0000 (UTC)
DKIM-Filter: OpenDKIM Filter v2.11.0 ms.lwn.net 14158299
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=lwn.net; s=20201203;
        t=1665428898; bh=++eWub7rW10WIqlEbZ8W9lP8C39R5e1NP5uJK+tq2GQ=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=P5i0OSEOcKPkAly4+dMv/zlZ5epmkYQw6CK0SReMnbfBX9G7yGTZlx1lT97HgyWia
         ZSUjLFjT4Qwuue41a2TNSKdfqIZh9wnO5duVwHWGRtsE9HG7/PQZMru8SczZw7tzUG
         3KuL3oiDqCYv3QYtyGSoWBIzZe/Z03wmo039DpZ5jUmrG5AUYjJ6cZyeu2o1eMrvfm
         LINA58z1XQv8R0Um5OjEu3im2BKV0L5/VTkhNEjE80MK0pTbRESwWSKPzDHRQAHDY6
         qXhT77O8C9uI65h1IM8bG/f3764Gzjlt2t125Bc3PPY2jyAVGEzXX6oATz37s5IrLQ
         JP5akMpS8Aorg==
From:   Jonathan Corbet <corbet@lwn.net>
To:     Jouke Witteveen <j.witteveen@gmail.com>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Jouke Witteveen <j.witteveen@gmail.com>, netdev@vger.kernel.org
Subject: Re: [PATCH] Documentation: update urls to Linux Foundation wiki
In-Reply-To: <20221001112058.22387-1-j.witteveen@gmail.com>
References: <20221001112058.22387-1-j.witteveen@gmail.com>
Date:   Mon, 10 Oct 2022 13:08:17 -0600
Message-ID: <87v8orpkda.fsf@meer.lwn.net>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jouke Witteveen <j.witteveen@gmail.com> writes:

> The redirects from the old urls stopped working recently.
>
> Signed-off-by: Jouke Witteveen <j.witteveen@gmail.com>

I see the LF has done its annual web-site replacement; I have no idea
why they are so enamored with breaking URLs...

Anyway, This is networking documentation, so it should go to the folks
at netdev [CC'd] rather than me.

>  Documentation/networking/bridge.rst                           | 2 +-
>  Documentation/networking/dccp.rst                             | 4 ++--
>  .../networking/device_drivers/ethernet/intel/ice.rst          | 2 +-
>  Documentation/networking/generic_netlink.rst                  | 2 +-
>  MAINTAINERS                                                   | 2 +-
>  net/ipv4/Kconfig                                              | 2 +-
>  net/sched/Kconfig                                             | 2 +-
>  7 files changed, 8 insertions(+), 8 deletions(-)
>
> diff --git a/Documentation/networking/bridge.rst b/Documentation/networking/bridge.rst
> index 4aef9cddde2f..c859f3c1636e 100644
> --- a/Documentation/networking/bridge.rst
> +++ b/Documentation/networking/bridge.rst
> @@ -8,7 +8,7 @@ In order to use the Ethernet bridging functionality, you'll need the
>  userspace tools.
>  
>  Documentation for Linux bridging is on:
> -   http://www.linuxfoundation.org/collaborate/workgroups/networking/bridge
> +   https://wiki.linuxfoundation.org/networking/bridge

So this page is full of encouraging stuff like:

> The code is updated as part of the 2.4 and 2.6 kernels available at
> kernel.org.

...and tells us about an encouraging prototype implementation in 2.6.18.
I'd apply the patch because working URLs are better than broken ones,
but I also question the value of this material at all in 2022... there
should be better documents to link to at this point?

Thanks,

jon

>  The bridge-utilities are maintained at:
>     git://git.kernel.org/pub/scm/linux/kernel/git/shemminger/bridge-utils.git
> diff --git a/Documentation/networking/dccp.rst b/Documentation/networking/dccp.rst
> index 91e5c33ba3ff..cd661509d35d 100644
> --- a/Documentation/networking/dccp.rst
> +++ b/Documentation/networking/dccp.rst
> @@ -41,11 +41,11 @@ specified in RFCs 4340...42.
>  
>  The known bugs are at:
>  
> -	http://www.linuxfoundation.org/collaborate/workgroups/networking/todo#DCCP
> +	https://wiki.linuxfoundation.org/networking/todo#dccp
>  
>  For more up-to-date versions of the DCCP implementation, please consider using
>  the experimental DCCP test tree; instructions for checking this out are on:
> -http://www.linuxfoundation.org/collaborate/workgroups/networking/dccp_testing#Experimental_DCCP_source_tree
> +https://wiki.linuxfoundation.org/networking/dccp_testing#experimental_dccp_source_tree
>  
>  
>  Socket options
> diff --git a/Documentation/networking/device_drivers/ethernet/intel/ice.rst b/Documentation/networking/device_drivers/ethernet/intel/ice.rst
> index dc2e60ced927..b481b81f3be5 100644
> --- a/Documentation/networking/device_drivers/ethernet/intel/ice.rst
> +++ b/Documentation/networking/device_drivers/ethernet/intel/ice.rst
> @@ -819,7 +819,7 @@ NAPI
>  ----
>  This driver supports NAPI (Rx polling mode).
>  For more information on NAPI, see
> -https://www.linuxfoundation.org/collaborate/workgroups/networking/napi
> +https://wiki.linuxfoundation.org/networking/napi
>  
>  
>  MACVLAN
> diff --git a/Documentation/networking/generic_netlink.rst b/Documentation/networking/generic_netlink.rst
> index 59e04ccf80c1..d960dbd7e80e 100644
> --- a/Documentation/networking/generic_netlink.rst
> +++ b/Documentation/networking/generic_netlink.rst
> @@ -6,4 +6,4 @@ Generic Netlink
>  
>  A wiki document on how to use Generic Netlink can be found here:
>  
> - * http://www.linuxfoundation.org/collaborate/workgroups/networking/generic_netlink_howto
> + * https://wiki.linuxfoundation.org/networking/generic_netlink_howto
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 17abc6483100..f9eecb2b6a84 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -5717,7 +5717,7 @@ F:	drivers/scsi/dc395x.*
>  DCCP PROTOCOL
>  L:	dccp@vger.kernel.org
>  S:	Orphan
> -W:	http://www.linuxfoundation.org/collaborate/workgroups/networking/dccp
> +W:	https://wiki.linuxfoundation.org/networking/dccp
>  F:	include/linux/dccp.h
>  F:	include/linux/tfrc.h
>  F:	include/uapi/linux/dccp.h
> diff --git a/net/ipv4/Kconfig b/net/ipv4/Kconfig
> index e983bb0c5012..ce458aba140a 100644
> --- a/net/ipv4/Kconfig
> +++ b/net/ipv4/Kconfig
> @@ -419,7 +419,7 @@ config INET_DIAG
>  	  native Linux tools such as ss. ss is included in iproute2, currently
>  	  downloadable at:
>  
> -	    http://www.linuxfoundation.org/collaborate/workgroups/networking/iproute2
> +	    https://wiki.linuxfoundation.org/networking/iproute2
>  
>  	  If unsure, say Y.
>  
> diff --git a/net/sched/Kconfig b/net/sched/Kconfig
> index 1e8ab4749c6c..4b63d3fff3ae 100644
> --- a/net/sched/Kconfig
> +++ b/net/sched/Kconfig
> @@ -26,7 +26,7 @@ menuconfig NET_SCHED
>  	  from the package iproute2+tc at
>  	  <https://www.kernel.org/pub/linux/utils/net/iproute2/>.  That package
>  	  also contains some documentation; for more, check out
> -	  <http://www.linuxfoundation.org/collaborate/workgroups/networking/iproute2>.
> +	  <https://wiki.linuxfoundation.org/networking/iproute2>.
>  
>  	  This Quality of Service (QoS) support will enable you to use
>  	  Differentiated Services (diffserv) and Resource Reservation Protocol
> -- 
> 2.37.3
