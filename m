Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3115E4A876E
	for <lists+netdev@lfdr.de>; Thu,  3 Feb 2022 16:15:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351735AbiBCPO4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Feb 2022 10:14:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240788AbiBCPOz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Feb 2022 10:14:55 -0500
Received: from proxima.lasnet.de (proxima.lasnet.de [IPv6:2a01:4f8:121:31eb:3::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 001B3C061714;
        Thu,  3 Feb 2022 07:14:54 -0800 (PST)
Received: from [IPV6:2003:e9:d71f:7b00:83f0:ef29:ebc6:2fb7] (p200300e9d71f7b0083f0ef29ebc62fb7.dip0.t-ipconnect.de [IPv6:2003:e9:d71f:7b00:83f0:ef29:ebc6:2fb7])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: stefan@datenfreihafen.org)
        by proxima.lasnet.de (Postfix) with ESMTPSA id 8C1E1C07BA;
        Thu,  3 Feb 2022 16:14:51 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=datenfreihafen.org;
        s=2021; t=1643901291;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=hnORKNBRjHpFsTO4HG8md0wUuEgPB5te4IcquTqbRF8=;
        b=m+EZTLpsxJR5EkC1JiJuc3h5jEiw2V5tWNU3lR8f2+645w0581xZmli9qwHFBW+BtH9hst
        F4F+B8iXNZIHZ1WPM88SPDB40DNFLIfogpkLMUYpWU+9MoDSWBvkYq24WME7jdjFjNM95w
        gd6186kQa061jbaR6vtvRN0JxnT1ItpP/mi5fszi6xXo0asZ6Qd7Gmq/NNl+k5jWGtP6Jz
        VOvkzpX81ytP4NSevp6qeFSZFG7ChxgEYWcaQd+YoWt5RIMxh2yh/LFMWhtncHCV2bGNvB
        BCGjozch/k7BpW3MlhQ7Os0zySosKtDd6FD9Ra82iLjTQr4doTlzlRFy5X8juw==
Message-ID: <e8dd1abc-6558-1269-3995-c8920a4e6000@datenfreihafen.org>
Date:   Thu, 3 Feb 2022 16:14:50 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
Subject: Re: [PATCH net-next] net: don't include ndisc.h from ipv6.h
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>, davem@davemloft.net
Cc:     netdev@vger.kernel.org, j.vosburgh@gmail.com, vfalico@gmail.com,
        andy@greyhouse.net, oliver@neukum.org, yoshfuji@linux-ipv6.org,
        dsahern@kernel.org, alex.aring@gmail.com,
        jukka.rissanen@linux.intel.com, jk@codeconstruct.com.au,
        matt@codeconstruct.com.au, linux-usb@vger.kernel.org,
        linux-bluetooth@vger.kernel.org, linux-wpan@vger.kernel.org
References: <20220203043457.2222388-1-kuba@kernel.org>
From:   Stefan Schmidt <stefan@datenfreihafen.org>
In-Reply-To: <20220203043457.2222388-1-kuba@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello.

On 03.02.22 05:34, Jakub Kicinski wrote:
> Nothing in ipv6.h needs ndisc.h, drop it.
> 
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> ---
> CC: j.vosburgh@gmail.com
> CC: vfalico@gmail.com
> CC: andy@greyhouse.net
> CC: oliver@neukum.org
> CC: yoshfuji@linux-ipv6.org
> CC: dsahern@kernel.org
> CC: alex.aring@gmail.com
> CC: jukka.rissanen@linux.intel.com
> CC: stefan@datenfreihafen.org
> CC: jk@codeconstruct.com.au
> CC: matt@codeconstruct.com.au
> CC: linux-usb@vger.kernel.org
> CC: linux-bluetooth@vger.kernel.org
> CC: linux-wpan@vger.kernel.org
> ---
>   drivers/net/bonding/bond_alb.c | 1 +
>   drivers/net/usb/cdc_mbim.c     | 1 +
>   include/net/ipv6.h             | 1 -
>   include/net/ipv6_frag.h        | 1 +
>   include/net/ndisc.h            | 1 -
>   net/6lowpan/core.c             | 1 +
>   net/ieee802154/6lowpan/core.c  | 1 +

For ieee802154:

Acked-by: Stefan Schmidt <stefan@datenfreihafen.org>

regards
Stefan Schmidt
