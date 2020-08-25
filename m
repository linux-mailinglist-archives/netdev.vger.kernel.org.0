Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B053D251EAC
	for <lists+netdev@lfdr.de>; Tue, 25 Aug 2020 19:55:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726551AbgHYRzh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Aug 2020 13:55:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726104AbgHYRzg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Aug 2020 13:55:36 -0400
Received: from merlin.infradead.org (merlin.infradead.org [IPv6:2001:8b0:10b:1231::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7710C061574;
        Tue, 25 Aug 2020 10:55:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:Subject:Sender
        :Reply-To:Content-ID:Content-Description;
        bh=13q0yU/4W+VWpJEEdUThAvzf3bI1pgdy0BRgeQelX+A=; b=kWlKX1YrWrdR9fwDglszc5bQml
        esDRvCt2b8TJ/PpEZbhQ3yELpWLbecx60YAwyFq6rqxbWqkeqOgSTjj+Nynqo993f6Xqs15kL5koH
        llQ3HU7hPLTiE/zVNDsZo99p8BY7W4+se4rOnwPF7ET4FdmPc6ErFT7T70ZdpqCsFlQo3lyazxrRr
        VSiGixEg8MiErB+DwhuqpCVSinS9v6hPLt5YOYmhBwjFNvYf8/aIbDVIN9eMohNkrpuDN3ElmlBIb
        7FcatTwcvg3/AFCgArZ3qKdez7NqQP2g1AkPCHwQoIX/GG6vsCTVTA6VIfVDI4qXM2UYVaDimj5tK
        JUJSKu6g==;
Received: from [2601:1c0:6280:3f0::19c2]
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kAdAS-00040v-VR; Tue, 25 Aug 2020 17:55:33 +0000
Subject: Re: [PATCH 1/3] net: ax88796c: ASIX AX88796C SPI Ethernet Adapter
 Driver
To:     Lukasz Stelmach <l.stelmach@samsung.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Kukjin Kim <kgene@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, m.szyprowski@samsung.com,
        b.zolnierkie@samsung.com
References: <6062dc73-99bc-cde0-26a1-5c40ea1447bd@infradead.org>
 <CGME20200825173041eucas1p29cb450a15648e0ecb1e896fcbe0f9126@eucas1p2.samsung.com>
 <dleftjr1ruvdjd.fsf%l.stelmach@samsung.com>
From:   Randy Dunlap <rdunlap@infradead.org>
Message-ID: <dae861c2-71c8-093b-74a6-68cf5c5ae744@infradead.org>
Date:   Tue, 25 Aug 2020 10:55:27 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <dleftjr1ruvdjd.fsf%l.stelmach@samsung.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


>>> +if NET_VENDOR_ASIX
>>> +
>>> +config SPI_AX88796C
>>> +	tristate "Asix AX88796C-SPI support"
>>> +	depends on SPI
>>
>> That line is redundant (but not harmful).
> 
> Why? Is it because NET_VENDOR_ASIX depends on SPI? Probably it
> shouldn't. Thanks for spotting.

Yes, that.


-- 
~Randy

