Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 101E62F035C
	for <lists+netdev@lfdr.de>; Sat,  9 Jan 2021 21:15:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726132AbhAIUPB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 Jan 2021 15:15:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726001AbhAIUPB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 9 Jan 2021 15:15:01 -0500
Received: from merlin.infradead.org (merlin.infradead.org [IPv6:2001:8b0:10b:1231::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20D28C061786
        for <netdev@vger.kernel.org>; Sat,  9 Jan 2021 12:14:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:Subject:Sender
        :Reply-To:Content-ID:Content-Description;
        bh=evRmOJ9sghD7l8/0DoIM+RUG26y4j45empfgyXx28lw=; b=OrtL7/yqY0U3WEYdEa9E670Vfj
        eVqEMldLbsX4lU61Yz3zkNttl1MnJm6rWRZwGYeGAE78INOMr49BdrHWcmDVxxDVhszpZTSzmetZu
        zOyjJ4HXZXTYs45vE5wpg8AAk511qCblUn3ale00TZPxDWSdIvhDHT0C3V79nJzL9ceJSpsHMTKw8
        kSmyPMUi4FpBnKWRf0nnDXaZz5TsmksOESIEmtg/5EKdC91wV5ViXo0V6rNb2JqgOcYhS3bn9hQFU
        dUvYNUBLVlM4K/ROWA4kxNQo1Vl0mI32TUx3TaQKMqwN68g+CmfmHOs0doHUGSzY3omM5vLf2leaN
        2LLsGgrQ==;
Received: from [2601:1c0:6280:3f0::79df]
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kyKcs-00066Y-7Y; Sat, 09 Jan 2021 20:14:18 +0000
Subject: Re: [PATCH] Incorrect filename in drivers/net/phy/Makefile
To:     Andrew Lunn <andrew@lunn.ch>, Zhi Han <z.han@gmx.net>
Cc:     Florian Fainelli <f.fainelli@gmail.com>, netdev@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>
References: <20210106101712.6360-1-z.han@gmx.net>
 <0d9094e9-5562-8535-98c3-993161aea355@gmail.com>
 <20210109091738.GB25@E480.localdomain> <X/oIgiad+sSejmtt@lunn.ch>
From:   Randy Dunlap <rdunlap@infradead.org>
Message-ID: <219dc4d6-f2a6-ef33-2bf6-b801eb66e35f@infradead.org>
Date:   Sat, 9 Jan 2021 12:14:11 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <X/oIgiad+sSejmtt@lunn.ch>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/9/21 11:48 AM, Andrew Lunn wrote:
> On Sat, Jan 09, 2021 at 10:17:38AM +0100, Zhi Han wrote:
>> Thanks a lot for the .config file.
>> I also tested it, with mdio-bus.o in the Makefile, glad to got that there is
>> no problem of that, although I don't know the reason/trick yet.
> 
> I'm not 100% sure, but i think:
> 
> obj-$(CONFIG_MDIO_DEVICE)       += mdio-bus.o
> 
> actually refers back to
> 
> mdio-bus-y                      += mdio_bus.o mdio_device.o

Ack that.

-- 
~Randy

