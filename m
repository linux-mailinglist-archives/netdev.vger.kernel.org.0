Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA17E49DBB3
	for <lists+netdev@lfdr.de>; Thu, 27 Jan 2022 08:33:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237370AbiA0Hds (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jan 2022 02:33:48 -0500
Received: from proxima.lasnet.de ([78.47.171.185]:40864 "EHLO
        proxima.lasnet.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237363AbiA0Hdr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jan 2022 02:33:47 -0500
Received: from [IPV6:2003:e9:d70e:d66f:5a35:69f1:72f5:373] (p200300e9d70ed66f5a3569f172f50373.dip0.t-ipconnect.de [IPv6:2003:e9:d70e:d66f:5a35:69f1:72f5:373])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits))
        (No client certificate requested)
        (Authenticated sender: stefan@datenfreihafen.org)
        by proxima.lasnet.de (Postfix) with ESMTPSA id F16A9C02E8;
        Thu, 27 Jan 2022 08:33:45 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=datenfreihafen.org;
        s=2021; t=1643268826;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=SFzNJoRKii7RyTjP1nn7jts/BXYOHqFnoBth+ka3OAs=;
        b=E+DtaMO3IwUurcTzyYjDp8qDjOkq1fnGPWBOtub5ju2UgY93Cl0YX+TbfHui5s7TNlZ7Gj
        6XmwughueyVAGevPMZ3CpKOtLXtVmrKbSZEKHnvDiGGU9Zxu5gf1TSm9bre9HOuyxuaEug
        Oc5GqNhhld3MvUvv+6Fw8s93msHCwsOU/bnKwLYbR2zP40KgVH1/Uv8nSJ1VXuA7mxGz6z
        Y3+DnKu9TltYe1RAL+ZbBKfmBXrTCGEnTbl+5BRLJEcUW0bK2bsTQ7kNvVIkn3laUr4Jgl
        Ka6gzr1pDqoMSQQKkpy5NDYEWbPQxfOxDOHmd4RtBW95CpI2fkCXNh/xToQi+w==
Message-ID: <1310b011-705f-364d-5d45-9f1a3572cc56@datenfreihafen.org>
Date:   Thu, 27 Jan 2022 08:33:45 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
Subject: Re: [wpan v3 0/6] ieee802154: A bunch of fixes
Content-Language: en-US
To:     Miquel Raynal <miquel.raynal@bootlin.com>,
        Alexander Aring <alex.aring@gmail.com>,
        linux-wpan@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        David Girault <david.girault@qorvo.com>,
        Romuald Despres <romuald.despres@qorvo.com>,
        Frederic Blain <frederic.blain@qorvo.com>,
        Nicolas Schodet <nico@ni.fr.eu.org>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>
References: <20220125121426.848337-1-miquel.raynal@bootlin.com>
From:   Stefan Schmidt <stefan@datenfreihafen.org>
In-Reply-To: <20220125121426.848337-1-miquel.raynal@bootlin.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello.

On 25.01.22 13:14, Miquel Raynal wrote:
> In preparation to a wider series, here are a number of small and random
> fixes across the subsystem.
> 
> Changes in v2:
> * Fixed the wrong RCU usage when updating the default channel at probe
>    time in hwsim.
> * Actually fixed the skb leak fix in the at86rf230 driver as suggested
>    by Alexander.
> * Also reordered the calls to free the skb then wake the queue
>    everywhere else.
> * Added a missing Fixes tag (for the meaningful error codes patch).
> 
> Miquel Raynal (6):
>    net: ieee802154: hwsim: Ensure proper channel selection at probe time
>    net: ieee802154: mcr20a: Fix lifs/sifs periods
>    net: ieee802154: at86rf230: Stop leaking skb's
>    net: ieee802154: ca8210: Stop leaking skb's
>    net: ieee802154: Return meaningful error codes from the netlink
>      helpers
>    MAINTAINERS: Remove Harry Morris bouncing address
> 
>   MAINTAINERS                              |  3 +--
>   drivers/net/ieee802154/at86rf230.c       | 13 +++++++++++--
>   drivers/net/ieee802154/ca8210.c          |  1 +
>   drivers/net/ieee802154/mac802154_hwsim.c |  1 +
>   drivers/net/ieee802154/mcr20a.c          |  4 ++--
>   net/ieee802154/nl802154.c                |  8 ++++----
>   6 files changed, 20 insertions(+), 10 deletions(-)
> 


This series has been applied to the wpan tree and will be
part of the next pull request to net. Thanks!

regards
Stefan Schmidt
