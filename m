Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1B1973930F
	for <lists+netdev@lfdr.de>; Fri,  7 Jun 2019 19:24:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731310AbfFGRYe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Jun 2019 13:24:34 -0400
Received: from ms.lwn.net ([45.79.88.28]:57778 "EHLO ms.lwn.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729551AbfFGRYe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 7 Jun 2019 13:24:34 -0400
Received: from lwn.net (localhost [127.0.0.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ms.lwn.net (Postfix) with ESMTPSA id EFAC07DA;
        Fri,  7 Jun 2019 17:24:33 +0000 (UTC)
Date:   Fri, 7 Jun 2019 11:24:33 -0600
From:   Jonathan Corbet <corbet@lwn.net>
To:     Geert Uytterhoeven <geert+renesas@glider.be>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jiri Kosina <trivial@kernel.org>, netdev@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH trivial] Documentation: net: dsa: Grammar s/the its/its/
Message-ID: <20190607112433.182eb3ff@lwn.net>
In-Reply-To: <20190607110842.12876-1-geert+renesas@glider.be>
References: <20190607110842.12876-1-geert+renesas@glider.be>
Organization: LWN.net
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri,  7 Jun 2019 13:08:42 +0200
Geert Uytterhoeven <geert+renesas@glider.be> wrote:

> Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
> ---
>  Documentation/networking/dsa/dsa.rst | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/Documentation/networking/dsa/dsa.rst b/Documentation/networking/dsa/dsa.rst
> index ca87068b9ab904a9..563d56c6a25c924e 100644
> --- a/Documentation/networking/dsa/dsa.rst
> +++ b/Documentation/networking/dsa/dsa.rst
> @@ -531,7 +531,7 @@ Bridge VLAN filtering
>    a software implementation.
>  
>  .. note:: VLAN ID 0 corresponds to the port private database, which, in the context
> -        of DSA, would be the its port-based VLAN, used by the associated bridge device.
> +        of DSA, would be its port-based VLAN, used by the associated bridge device.
>  
>  - ``port_fdb_del``: bridge layer function invoked when the bridge wants to remove a
>    Forwarding Database entry, the switch hardware should be programmed to delete
> @@ -554,7 +554,7 @@ Bridge VLAN filtering
>    associated with this VLAN ID.
>  
>  .. note:: VLAN ID 0 corresponds to the port private database, which, in the context
> -        of DSA, would be the its port-based VLAN, used by the associated bridge device.
> +        of DSA, would be its port-based VLAN, used by the associated bridge device.

Applied, thanks.

jon
