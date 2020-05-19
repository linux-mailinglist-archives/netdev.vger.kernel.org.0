Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E4C911DA59C
	for <lists+netdev@lfdr.de>; Wed, 20 May 2020 01:30:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728441AbgESXaO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 May 2020 19:30:14 -0400
Received: from novek.ru ([213.148.174.62]:46382 "EHLO novek.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728188AbgESXaO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 19 May 2020 19:30:14 -0400
Received: from [10.0.1.119] (unknown [62.76.204.32])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by novek.ru (Postfix) with ESMTPSA id 054985028F3;
        Wed, 20 May 2020 02:30:09 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 novek.ru 054985028F3
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=novek.ru; s=mail;
        t=1589931010; bh=gOnu6VK/945CaZR0BZBXTAS89gEXcASJNceA08QWKeY=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=ahJ4ddZMyl3BaeiqkKdvVJdnK1I/m/OQ6GarYlakKKJLQiX5fGC4m+Qcj0YZb0KpN
         HV4mZ5v/vjr+Ke9Gjq5KcCa5n08VvT8awOYfBhArxemrH+5C7kBQ3BeyQmnixXC5aR
         oMu1euVzzleyxakKfxQHBt75rLpnqTyOoBXGpSsc=
Subject: Re: [net-next 0/5] ip6_tunnel: add MPLS support
To:     David Miller <davem@davemloft.net>
Cc:     kuznet@ms2.inr.ac.ru, kuba@kernel.org, netdev@vger.kernel.org
References: <1589834028-9929-1-git-send-email-vfedorenko@novek.ru>
 <20200519.153406.544013162115691784.davem@davemloft.net>
From:   Vadim Fedorenko <vfedorenko@novek.ru>
Message-ID: <ad59aa7e-0c53-3046-a7b0-0932a1828aa1@novek.ru>
Date:   Wed, 20 May 2020 02:30:11 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200519.153406.544013162115691784.davem@davemloft.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Spam-Status: No, score=2.2 required=5.0 tests=RDNS_NONE,SPF_FAIL
        autolearn=no autolearn_force=no version=3.4.1
X-Spam-Level: **
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on gate.novek.ru
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 20.05.2020 01:34, David Miller wrote:
> From: Vadim Fedorenko <vfedorenko@novek.ru>
> Date: Mon, 18 May 2020 23:33:43 +0300
>
>> The support for MPLS-in-IPv4 was added earlier. This patchset adds
>> support for MPLS-in-IPv6.
> This adds way too many ifdefs into the C code, please find another way
> to abstract this such that you don't need to add ifdefs all over the
> place.
>
> Thank you.

This patchset was based on support for MPLS in ipip tunnel which is full
of ifdefs. Can you suggest me a way to eliminate them?

I think that almost all code can be compiled without any ifdef because it
uses constants that are always defined execpt the init/deinit code. The
only way I see is to check presence of AF_MPLS at runtime but I don't know
how to do it right.

Thanks.
