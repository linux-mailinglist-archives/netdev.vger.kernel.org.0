Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2C923515FDB
	for <lists+netdev@lfdr.de>; Sat, 30 Apr 2022 20:37:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243733AbiD3Skw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 30 Apr 2022 14:40:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237413AbiD3Sku (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 30 Apr 2022 14:40:50 -0400
Received: from proxima.lasnet.de (proxima.lasnet.de [78.47.171.185])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 269ED286F1;
        Sat, 30 Apr 2022 11:37:27 -0700 (PDT)
Received: from [IPV6:2003:e9:d73c:4280:54dc:6687:cab2:6015] (p200300e9d73c428054dc6687cab26015.dip0.t-ipconnect.de [IPv6:2003:e9:d73c:4280:54dc:6687:cab2:6015])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: stefan@datenfreihafen.org)
        by proxima.lasnet.de (Postfix) with ESMTPSA id 55846C0A18;
        Sat, 30 Apr 2022 20:37:24 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=datenfreihafen.org;
        s=2021; t=1651343844;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Zjubw1Cj+o2zwVEKTAmtkSH2136IQ+Ju8iYFepITZEE=;
        b=nmedl8xqPDazkgdNQVbsi8xbdD9H0URNxOHBtui0jrbM6a0HXa4X7sd4Wc87PZEpeLxMY8
        GifkuVXqKM6rtyzP3Ml4TVnfe3M+lm5nWpTO7IWVz1vx2CFvyMfvovlEHu5t3l58aaVg34
        dh9Ge+EZfIF2+KUgvGaoh66TsfhEjPS/2O0B+6nxF0Flt/gCxgdliZhtuaFK2qDBj8S9t9
        eM5biQ3m9F0CE22apY64k1Kh36suYlSMWdiIntU3rBWGiLq08FObQ5MBTaqBZ7Upy0gOxu
        ww5O1MK+S9C1VVEb7Yhtu1PFC1mmFM6Nt+U6bv7W1E+ydT7ksLctcw1aXnfK/w==
Message-ID: <7c4d0f55-2d01-3450-627e-b1d39e1b6bff@datenfreihafen.org>
Date:   Sat, 30 Apr 2022 20:37:21 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: [PATCH wpan-next] net: mac802154: Fix symbol durations
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
References: <20220428164140.251965-1-miquel.raynal@bootlin.com>
From:   Stefan Schmidt <stefan@datenfreihafen.org>
In-Reply-To: <20220428164140.251965-1-miquel.raynal@bootlin.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello.

On 28.04.22 18:41, Miquel Raynal wrote:
> There are two major issues in the logic calculating the symbol durations
> based on the page/channel:
> - The page number is used in place of the channel value.
> - The BIT() macro is missing because we want to check the channel
>    value against a bitmask.
> 
> Fix these two errors and apologize loudly for this mistake.
> 
> Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>


This patch has been applied to the wpan-next tree and will be
part of the next pull request to net-next. Thanks!

regards
Stefan Schmidt
