Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 64CC1CFBF4
	for <lists+netdev@lfdr.de>; Tue,  8 Oct 2019 16:07:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727115AbfJHOGb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Oct 2019 10:06:31 -0400
Received: from ms.lwn.net ([45.79.88.28]:36778 "EHLO ms.lwn.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726593AbfJHOGa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 8 Oct 2019 10:06:30 -0400
Received: from lwn.net (localhost [127.0.0.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ms.lwn.net (Postfix) with ESMTPSA id D45BF5A0;
        Tue,  8 Oct 2019 14:06:29 +0000 (UTC)
Date:   Tue, 8 Oct 2019 08:06:28 -0600
From:   Jonathan Corbet <corbet@lwn.net>
To:     Martin Varghese <martinvarghesenokia@gmail.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net,
        scott.drennan@nokia.com, jbenc@redhat.com,
        martin.varghese@nokia.com
Subject: Re: [PATCH net-next 1/2] UDP tunnel encapsulation module for
 tunnelling different protocols like MPLS,IP,NSH etc.
Message-ID: <20191008080628.4a40af66@lwn.net>
In-Reply-To: <5979d1bf0b5521c66f2f6fa31b7e1cbdddd8cea8.1570455278.git.martinvarghesenokia@gmail.com>
References: <cover.1570455278.git.martinvarghesenokia@gmail.com>
        <5979d1bf0b5521c66f2f6fa31b7e1cbdddd8cea8.1570455278.git.martinvarghesenokia@gmail.com>
Organization: LWN.net
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue,  8 Oct 2019 15:18:53 +0530
Martin Varghese <martinvarghesenokia@gmail.com> wrote:

> diff --git a/Documentation/networking/bareudp.txt b/Documentation/networking/bareudp.txt
> new file mode 100644
> index 0000000..d2530e2
> --- /dev/null
> +++ b/Documentation/networking/bareudp.txt
> @@ -0,0 +1,23 @@
> +Bare UDP Tunnelling Module Documentation
> +========================================
> +
> +There are various L3 encapsulation standards using UDP being discussed to
> +leverage the UDP based load balancing capability of different networks.
> +MPLSoUDP (https://tools.ietf.org/html/rfc7510)is one among them.
> +
> +The Bareudp tunnel module provides a generic L3 encapsulation tunnelling
> +support for tunnelling different L3 protocols like MPLS, IP, NSH etc. inside
> +a UDP tunnel.
> +
> +Usage
> +------
> +
> +1. Device creation & deletion
> +
> +a. ip link add dev bareudp0 type bareudp dstport 6635 ethertype 0x8847
> +
> +This creates a bareudp tunnel device which tunnels L3 traffic with ethertype
> +0x8847 (MPLS traffic).The destination port of the UDP header will be set to 6635
> +The device will listen on UDP port 6635 to receive traffic.
> +
> +b. ip link delete bareudp0

Please add new documentation in the RST format if at all possible.  This
document is 95% RST already; doing the last bit of work will save somebody
else the effort of converting it in the future.

Thanks,

jon
