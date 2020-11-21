Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 140802BBAC3
	for <lists+netdev@lfdr.de>; Sat, 21 Nov 2020 01:19:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728275AbgKUARW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Nov 2020 19:17:22 -0500
Received: from static-71-183-126-102.nycmny.fios.verizon.net ([71.183.126.102]:58384
        "EHLO chicken.badula.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727367AbgKUARW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Nov 2020 19:17:22 -0500
Received: from chicken.badula.org (localhost [127.0.0.1])
        by chicken.badula.org (8.14.4/8.14.4) with ESMTP id 0AL0HI4k025350
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO);
        Fri, 20 Nov 2020 19:17:20 -0500
Received: (from defang@localhost)
        by chicken.badula.org (8.14.4/8.14.4/Submit) id 0AL0F4b2025319;
        Fri, 20 Nov 2020 19:15:04 -0500
X-Authentication-Warning: chicken.badula.org: defang set sender to <ionut@badula.org> using -f
Received: from moisil.badula.org (pool-71-187-225-100.nwrknj.fios.verizon.net [71.187.225.100])
        by chicken.badula.org (envelope-sender <ionut@badula.org>) (MIMEDefang) with ESMTP id 0AL0F3pl025309; Fri, 20 Nov 2020 19:15:04 -0500
Subject: Re: [PATCH] net: adaptec: remove dead code in set_vlan_mode
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     xiakaixu1987@gmail.com, leon@kernel.org, davem@davemloft.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kaixu Xia <kaixuxia@tencent.com>, Arnd Bergmann <arnd@arndb.de>
References: <1605858600-7096-1-git-send-email-kaixuxia@tencent.com>
 <20201120151714.0cc2f00b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <fe835089-3499-0d70-304e-cc3d2e58a8d8@badula.org>
 <20201120155637.78f47bc0@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Ion Badulescu <ionut@badula.org>
Message-ID: <37b0701d-e57c-ba68-61e0-86565ac37254@badula.org>
Date:   Fri, 20 Nov 2020 19:15:03 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20201120155637.78f47bc0@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Spam-Checker-Version: SpamAssassin 3.3.1 (2010-03-16) on chicken.badula.org
X-Spam-Level: 
X-Spam-Language: en
X-Spam-Status: No, score=0.114 required=5 tests=AWL=0.632,BAYES_00=-1.9,KHOP_HELO_FCRDNS=0.399,NICE_REPLY_A=-0.001,PDS_RDNS_DYNAMIC_FP=0.001,RDNS_DYNAMIC=0.982,SPF_FAIL=0.001
X-Scanned-By: MIMEDefang 2.84 on 71.183.126.100
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/20/20 6:56 PM, Jakub Kicinski wrote:
> On Fri, 20 Nov 2020 18:41:03 -0500 Ion Badulescu wrote:
>> Frankly, no, I don't know of any users, and that unfortunately includes
>> myself. I still have two cards in my stash, but they're 64-bit PCI-X, so
>> plugging them in would likely require taking a dremel to a 32-bit PCI
>> slot to make it open-ended. (They do work in a 32-bit slot.)
>>
>> Anyway, that filter code could use some fixing in other regards. So
>> either we fix it properly (which I can submit a patch for), or clean it
>> out for good.
> 
> Entirely up to you.

All right then. I'll whip out the Dremel this weekend and hopefully get 
a test rig going... :)

-Ion
