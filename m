Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 652A63A1866
	for <lists+netdev@lfdr.de>; Wed,  9 Jun 2021 17:02:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238817AbhFIPDI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Jun 2021 11:03:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238801AbhFIPDG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Jun 2021 11:03:06 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16638C061574;
        Wed,  9 Jun 2021 08:01:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        Content-Type:In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:
        Subject:Sender:Reply-To:Content-ID:Content-Description;
        bh=ffjZdEaHfFJL2PlBT1Pi9QMrYzsEmrd1QXquQzBQ3MI=; b=agVhEldAJI80iEC/bn2apBj6dj
        GShcrxSObtemYZVq7w0qS86pRLEuBNhoO6Lj0AIFSOBqjOP5Q++7p2bZOa2sYfhuYk4pqwcXP+30Y
        hz/YOlzHP8iNOmzami6ODx0OZNVYgIWnBMkM0bOfOjqU9EOK234N6YvSufy4dSCSNEHNHAjG8eEre
        ZgiRHunrZwOuijUfNJ6Bc0ljF7liAZsnmLAJq7da3ZYD4lPDEXrjFNxAxtNcWioFg1Y1NeTiVLYw7
        uJpv3IMCtEuSgHzn1DCS3S1LLSL+jqHBYD8dEyZOENfT9QAJFxtJoBCLlH31VhB2ZpDgw+lq03XzA
        ninwpdqg==;
Received: from [2601:1c0:6280:3f0::bd57]
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1lqzhd-00ET7w-JV; Wed, 09 Jun 2021 15:01:09 +0000
Subject: Re: [PATCH] nl80211: fix a mistake in grammar
To:     Johannes Berg <johannes@sipsolutions.net>, 13145886936@163.com,
        davem@davemloft.net, kuba@kernel.org
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, gushengxian <gushengxian@yulong.com>
References: <20210609081556.19641-1-13145886936@163.com>
 <d32bec575d204a17531f61c8d2f67443ffdaee6c.camel@sipsolutions.net>
From:   Randy Dunlap <rdunlap@infradead.org>
Message-ID: <c4ab41c7-7230-2548-f7ab-1a0aa8d16e36@infradead.org>
Date:   Wed, 9 Jun 2021 08:01:05 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.0
MIME-Version: 1.0
In-Reply-To: <d32bec575d204a17531f61c8d2f67443ffdaee6c.camel@sipsolutions.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/9/21 1:55 AM, Johannes Berg wrote:
> On Wed, 2021-06-09 at 01:15 -0700, 13145886936@163.com wrote:
>>
>> -	/* don't allow or configure an mcast address */
>> +	/* don't allow or configure a mcast address */
> 
> Arguable? I'd say "an M-cast" address, and I guess that's why it's
> written that way. Not sure how else you'd say it, unless you always
> expand it to "multicast" when reading.

Agreed, it's ok as is.

