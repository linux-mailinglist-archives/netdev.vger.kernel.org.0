Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B736549F746
	for <lists+netdev@lfdr.de>; Fri, 28 Jan 2022 11:27:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243869AbiA1K1d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jan 2022 05:27:33 -0500
Received: from proxima.lasnet.de ([78.47.171.185]:38566 "EHLO
        proxima.lasnet.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233599AbiA1K1d (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Jan 2022 05:27:33 -0500
Received: from [IPV6:2003:e9:d705:dc25:2cd1:34b0:e26d:e30d] (p200300e9d705dc252cd134b0e26de30d.dip0.t-ipconnect.de [IPv6:2003:e9:d705:dc25:2cd1:34b0:e26d:e30d])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: stefan@datenfreihafen.org)
        by proxima.lasnet.de (Postfix) with ESMTPSA id 3132AC00B1;
        Fri, 28 Jan 2022 11:27:31 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=datenfreihafen.org;
        s=2021; t=1643365651;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=mKn4vINB0VPT9LgyrzLt5iaXWemtnk5uHUPvzBJAu/4=;
        b=ASqvMN+6yAfTH1WfsHL5hwgsYCY7AUusuUoNfnwCMFIIpzQAAMSaADn5FGxlJ5CqweEEZz
        0aGxcA+hhZAplKoDQzQPW79YRNDpJLdKpysfbRGlsLyeLftMrJepfAZtbB5CIj6/ZalRPK
        o8xCW4o9Lrtl9YdFxvRK3ZUjYNbbjM6TwAlFfD4mMutJlcLzw+XedWKWEL+AwlOlbySxaD
        D3SRISpUc3weUsfm5IeHSTrzLF5GLHsd5zKB2p+45e9mu5b2CNMaNYqYCm1iTgGMX2/IZT
        hgkLVdSe+g34X039nyBJcx0zmtu1q5SA1ttdayj8CkNSgQAVWsEtO+aYO9xtHw==
Message-ID: <400a72bf-2485-eefa-e9a2-e0327827ea20@datenfreihafen.org>
Date:   Fri, 28 Jan 2022 11:27:30 +0100
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

This patch has been applied to the wpan-next tree and will be
part of the next pull request to net-next. Thanks!

regards
Stefan Schmidt
