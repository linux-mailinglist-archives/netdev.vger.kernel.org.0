Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2AF3B347933
	for <lists+netdev@lfdr.de>; Wed, 24 Mar 2021 14:05:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234256AbhCXNEc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Mar 2021 09:04:32 -0400
Received: from mail.bugwerft.de ([46.23.86.59]:55152 "EHLO mail.bugwerft.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233182AbhCXND5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 24 Mar 2021 09:03:57 -0400
X-Greylist: delayed 11693 seconds by postgrey-1.27 at vger.kernel.org; Wed, 24 Mar 2021 09:03:57 EDT
Received: from [192.168.178.106] (p57bc9f24.dip0.t-ipconnect.de [87.188.159.36])
        by mail.bugwerft.de (Postfix) with ESMTPSA id 6EEED4C40BB;
        Wed, 24 Mar 2021 13:03:54 +0000 (UTC)
Subject: Re: [PATCH] net: axienet: allow setups without MDIO
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     radhey.shyam.pandey@xilinx.com, davem@davemloft.net,
        kuba@kernel.org, netdev@vger.kernel.org
References: <20210324094855.1604778-1-daniel@zonque.org>
 <YFsyv3FZlz+Tah9s@lunn.ch>
From:   Daniel Mack <daniel@zonque.org>
Message-ID: <161c58bd-7d04-beeb-50e2-25a44a397b2b@zonque.org>
Date:   Wed, 24 Mar 2021 14:03:53 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <YFsyv3FZlz+Tah9s@lunn.ch>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/24/21 1:38 PM, Andrew Lunn wrote:
> On Wed, Mar 24, 2021 at 10:48:55AM +0100, Daniel Mack wrote:
>> In setups with fixed-link settings on the hardware bus there is no mdio node
>> in DTS. axienet_probe() already handles that gracefully but lp->mii_bus is
>> then NULL.
>>
>> Fix code that tries to blindly grab the MDIO lock by introducing two helper
>> functions that make the locking conditional.
> 
> Hi Danial
> 
> What about axienet_dma_err_handler()?

Ah, I missed that one. Thanks a lot! Will send a v2.


Daniel
