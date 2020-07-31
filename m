Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC5E32348BB
	for <lists+netdev@lfdr.de>; Fri, 31 Jul 2020 17:53:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387588AbgGaPxR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Jul 2020 11:53:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387503AbgGaPxQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Jul 2020 11:53:16 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A3E0C061574;
        Fri, 31 Jul 2020 08:53:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:Subject:Sender
        :Reply-To:Content-ID:Content-Description;
        bh=WhFCKccSxeYrRdpZtSH7k15LwotaM65GljxztVSl55A=; b=khQQnUr0WRQISYUyU2GnSiv9lX
        iwzDTK0IX48EK5HAURvgBu+u+aEcxrmPY1ALPcUQHj3JnBMJtdvyx6J/i2EbXhao0G1yBXhdUCd+i
        Odd8jmr+fhHSUmImtiws/fVnbHu6w6yHZ/3ln0p2LjKaXRxfZsTufd0/NqHsgbNHIQvLdClxEzEcV
        wWk/YyNQzrPn3yz3nbYjBG0l+pkPIw7VAuAt4vIJ9WguqhacY2XL1HBeT4KgJlaayNIUdrr0eBz9B
        SaCvUTb3Ai07KMoZlEchvMLBPopHMEOWaAUWFRKelkIbnkiFKTyZ3VI7M/29tRr8M7Ib8S/Q14QMS
        PPCB4n1g==;
Received: from [2601:1c0:6280:3f0:897c:6038:c71d:ecac]
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1k1XLN-0003iF-WF; Fri, 31 Jul 2020 15:53:14 +0000
Subject: Re: linux-next: Tree for Jul 31 (net/decnet/ & FIB_RULES)
To:     Stephen Rothwell <sfr@canb.auug.org.au>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        linux-decnet-user@lists.sourceforge.net
References: <20200731211909.33b550ec@canb.auug.org.au>
From:   Randy Dunlap <rdunlap@infradead.org>
Message-ID: <4c6abcd0-e51b-0cf3-92de-5538c366e685@infradead.org>
Date:   Fri, 31 Jul 2020 08:53:09 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200731211909.33b550ec@canb.auug.org.au>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/31/20 4:19 AM, Stephen Rothwell wrote:
> Hi all,
> 
> Changes since 20200730:
> 

on i386:

ld: net/core/fib_rules.o: in function `fib_rules_lookup':
fib_rules.c:(.text+0x16b8): undefined reference to `fib4_rule_match'
ld: fib_rules.c:(.text+0x16bf): undefined reference to `fib4_rule_match'
ld: fib_rules.c:(.text+0x170d): undefined reference to `fib4_rule_action'
ld: fib_rules.c:(.text+0x171e): undefined reference to `fib4_rule_action'
ld: fib_rules.c:(.text+0x1751): undefined reference to `fib4_rule_suppress'
ld: fib_rules.c:(.text+0x175d): undefined reference to `fib4_rule_suppress'

CONFIG_DECNET=y
CONFIG_DECNET_ROUTER=y

DECNET_ROUTER selects FIB_RULES.


-- 
~Randy
Reported-by: Randy Dunlap <rdunlap@infradead.org>
