Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 61410229D31
	for <lists+netdev@lfdr.de>; Wed, 22 Jul 2020 18:35:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728299AbgGVQfs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jul 2020 12:35:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726535AbgGVQfs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jul 2020 12:35:48 -0400
Received: from merlin.infradead.org (merlin.infradead.org [IPv6:2001:8b0:10b:1231::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5FFBC0619DC;
        Wed, 22 Jul 2020 09:35:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:Subject:Sender
        :Reply-To:Content-ID:Content-Description;
        bh=5XZN44V6CF32fCmbu6lN9a7A+gJGo7nDxcGvT72Gh9Q=; b=R9nzzvmIS+N0vrYDloMBSCBYaj
        THJs3mLaZ4vD8p/YZNaKSeo8B0l6g69cdikZ5e4hzc9JcOFXBLrj8H4f1IM7iqbB0MO0fLOdIDZyT
        YwqozO+H84qg0S6WYJ4NqKDDBPD2id9gqNI64bdk9scHdmf846NSW4vBoJZO9WAP82XYUWJkRyITP
        4Y3FA9gM5aCCU+hDyHrDjqlSjt3zEfy1wYlbGoXdYl2t2ZficHKqHaBr40Ir2h1t5W2M6nXhP40nC
        xyeCyjfxhQD2sCkqyeGB0biqA3rHF6pE+TeVRwgxvKJFFdgwkmntKlmHPEIXj9ifwgm+ZnYGUEDkD
        sor7GMlQ==;
Received: from [2601:1c0:6280:3f0::19c2]
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jyHiW-0000XQ-MQ; Wed, 22 Jul 2020 16:35:41 +0000
Subject: Re: linux-next: Tree for Jul 22 (drivers/net/vrf)
To:     Stephen Rothwell <sfr@canb.auug.org.au>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        David Ahern <dsahern@kernel.org>,
        Shrijeet Mukherjee <shrijeet@gmail.com>,
        David Miller <davem@davemloft.net>
References: <20200722231640.3dae04cd@canb.auug.org.au>
From:   Randy Dunlap <rdunlap@infradead.org>
Message-ID: <e1fc4765-db64-2876-2f3c-857c45d4fb45@infradead.org>
Date:   Wed, 22 Jul 2020 09:35:35 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200722231640.3dae04cd@canb.auug.org.au>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/22/20 6:16 AM, Stephen Rothwell wrote:
> Hi all,
> 
> Changes since 20200721:
> 

on i386:
when CONFIG_SYSCTL is not set/enabled:

ERROR: modpost: "sysctl_vals" [drivers/net/vrf.ko] undefined!


-- 
~Randy
Reported-by: Randy Dunlap <rdunlap@infradead.org>
