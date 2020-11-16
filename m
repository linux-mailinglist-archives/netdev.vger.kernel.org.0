Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A1B2A2B4E66
	for <lists+netdev@lfdr.de>; Mon, 16 Nov 2020 18:49:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387916AbgKPRq1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Nov 2020 12:46:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731834AbgKPRq1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Nov 2020 12:46:27 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BDE53C0613CF;
        Mon, 16 Nov 2020 09:46:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:Subject:Sender
        :Reply-To:Content-ID:Content-Description;
        bh=9sZyEPf94X/5U3dKsvhB39LKcRrFqi6aC5GNtt9/TYk=; b=XRffYaPEUEfNIxJ7YWf4c/snqH
        Gw+iEKkux7fTwIVqFSLInxzWfr25qpPYbNbQIov9uuIzuyiXLJJ5Ip9fpX4xpZg0VP5fdDMp3NVPA
        FFp4MAjHX9xRsJMMZjFQ7qANqs1fGxBMIJZyr3DcytFWAyQ4sUBzMCZWzNYtMivlWwZJAP5O1y8Hy
        AYqkg3YJ6JXvq61K4igVnvUE61mqWDW1GAv5maOWTwIAV6uT74yg9zN6na7Sq1arfI1Bg170zl6kT
        LjoTjAl80+GkT+j43vJtYOygmVcD4vxH+S11kOh9czp9WLKapFJFg5i8+PCSmzVlqVAHoQEFn1bN8
        Gwo8kF6A==;
Received: from [2601:1c0:6280:3f0::f32]
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1keia8-000251-BA; Mon, 16 Nov 2020 17:46:24 +0000
Subject: Re: linux-next: Tree for Nov 16 (net/core/stream.o)
To:     Stephen Rothwell <sfr@canb.auug.org.au>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>
References: <20201116175912.5f6a78d9@canb.auug.org.au>
From:   Randy Dunlap <rdunlap@infradead.org>
Message-ID: <8a1d4d64-d8cf-f19b-b425-594e10f3fc5a@infradead.org>
Date:   Mon, 16 Nov 2020 09:46:21 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <20201116175912.5f6a78d9@canb.auug.org.au>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/15/20 10:59 PM, Stephen Rothwell wrote:
> Hi all,
> 
> Changes since 20201113:
> 


on x86_64:

# CONFIG_INET is not set

ld: net/core/stream.o: in function `sk_stream_write_space':
stream.c:(.text+0x68): undefined reference to `tcp_stream_memory_free'
ld: stream.c:(.text+0x80): undefined reference to `tcp_stream_memory_free'
ld: net/core/stream.o: in function `sk_stream_wait_memory':
stream.c:(.text+0x5b3): undefined reference to `tcp_stream_memory_free'
ld: stream.c:(.text+0x5c8): undefined reference to `tcp_stream_memory_free'
ld: stream.c:(.text+0x6f8): undefined reference to `tcp_stream_memory_free'
ld: net/core/stream.o:stream.c:(.text+0x70d): more undefined references to `tcp_stream_memory_free' follow


-- 
~Randy
Reported-by: Randy Dunlap <rdunlap@infradead.org>
