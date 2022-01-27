Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D6DAB49E6C2
	for <lists+netdev@lfdr.de>; Thu, 27 Jan 2022 16:54:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237754AbiA0Pys (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jan 2022 10:54:48 -0500
Received: from proxima.lasnet.de ([78.47.171.185]:40244 "EHLO
        proxima.lasnet.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231455AbiA0Pys (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jan 2022 10:54:48 -0500
Received: from [IPV6:2003:e9:d724:a665:d7b5:f965:3476:16f8] (p200300e9d724a665d7b5f965347616f8.dip0.t-ipconnect.de [IPv6:2003:e9:d724:a665:d7b5:f965:3476:16f8])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: stefan@datenfreihafen.org)
        by proxima.lasnet.de (Postfix) with ESMTPSA id 2812DC05FB;
        Thu, 27 Jan 2022 16:54:46 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=datenfreihafen.org;
        s=2021; t=1643298886;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=4LmIE/K7JuGngCTWD98Jb7WZn5BaQGZRHb1P/f7j/Tw=;
        b=jwxQz0YEMDUyXH2x2j2NPvVB/Cd/iTUHrrqVhAZN57MaT0SthXjOk1Jl8yriOFOKHAadvp
        thMYDBt+3tIuFtxUzRNx25JMDX/cOG6ghIO4j6wm2l0dlGt84CsPURwC4GF1vsPP9qMwgv
        sfHN5h/BVWLbFkGquOPS1G+FBrD2T8k05iS0G7U+51P+Y5bqjwWnW4iE6kTGTCK/MT9ntw
        wM7OfNW6TIQxFuxMw09PE2RuH/z3QbRlyJr+6kHmqBsAHb4S38Kse/kvdU2+RaoHVBHCTa
        rAI++eOHnpYfFL7cu44zdinZdCHmu8ONSX2cqCxJvdbAiZUC4c2o54UgVQmMRA==
Message-ID: <b07b446d-a48e-78bd-1841-2802e12cf1d1@datenfreihafen.org>
Date:   Thu, 27 Jan 2022 16:54:43 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
Subject: Re: [wpan-next v3 0/3] ieee802154: A bunch of light changes
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
References: <20220125122540.855604-1-miquel.raynal@bootlin.com>
From:   Stefan Schmidt <stefan@datenfreihafen.org>
In-Reply-To: <20220125122540.855604-1-miquel.raynal@bootlin.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello.

On 25.01.22 13:25, Miquel Raynal wrote:
> Here are a few small cleanups and improvements in preparation of a wider
> series bringing a lot of features. These are aside changes, hence they
> have their own small series.
> 
> Changes in v3:
> * Split the v2 into two series: fixes for the wpan branch and cleanups
>    for wpan-next. Here are random "cleanups".
> * Reworded the ieee802154_wake/stop_queue helpers kdoc as discussed
>    with Alexander.
> 
> Miquel Raynal (3):
>    net: ieee802154: hwsim: Ensure frame checksum are valid
>    net: ieee802154: Use the IEEE802154_MAX_PAGE define when relevant
>    net: mac802154: Explain the use of ieee802154_wake/stop_queue()
> 
>   drivers/net/ieee802154/mac802154_hwsim.c |  2 +-
>   include/net/mac802154.h                  | 12 ++++++++++++
>   net/ieee802154/nl-phy.c                  |  4 ++--
>   3 files changed, 15 insertions(+), 3 deletions(-)
> 

I am happy with all three of them now. Alex, let me know if there is 
anything else you want to be adressed and ack if not so I can pull these in.

regards
Stefan Schmidt
