Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A83082EC0FF
	for <lists+netdev@lfdr.de>; Wed,  6 Jan 2021 17:21:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727473AbhAFQV0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jan 2021 11:21:26 -0500
Received: from smtprelay0167.hostedemail.com ([216.40.44.167]:53420 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727290AbhAFQVZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Jan 2021 11:21:25 -0500
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay05.hostedemail.com (Postfix) with ESMTP id 796781802EF0B;
        Wed,  6 Jan 2021 16:20:44 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,,RULES_HIT:41:355:379:599:973:982:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2194:2199:2393:2553:2559:2562:2691:2828:3138:3139:3140:3141:3142:3352:3622:3867:3868:3870:3872:3873:3874:4321:5007:6742:7652:7875:10004:10400:10848:11232:11657:11658:11914:12043:12297:12740:12760:12895:13069:13255:13311:13357:13439:14096:14097:14181:14659:14721:21080:21451:21627:30054:30070:30090:30091,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:,MSBL:0,DNSBL:none,Custom_rules:0:0:0,LFtime:2,LUA_SUMMARY:none
X-HE-Tag: word71_1a13b70274e3
X-Filterd-Recvd-Size: 2436
Received: from [192.168.1.159] (unknown [47.151.137.21])
        (Authenticated sender: joe@perches.com)
        by omf03.hostedemail.com (Postfix) with ESMTPA;
        Wed,  6 Jan 2021 16:20:42 +0000 (UTC)
Message-ID: <ed87ad8d74cd93c9459551ca6cc7ef523adefa7e.camel@perches.com>
Subject: Re: [PATCH] drivers: net: wireless: realtek: Fix the word
 association defautly de-faulty
From:   Joe Perches <joe@perches.com>
To:     Bhaskar Chowdhury <unixbhaskar@gmail.com>,
        Randy Dunlap <rdunlap@infradead.org>
Cc:     pkshih@realtek.com, kvalo@codeaurora.org, davem@davemloft.net,
        kuba@kernel.org, Larry.Finger@lwfinger.net, zhengbin13@huawei.com,
        baijiaju1990@gmail.com, christophe.jaillet@wanadoo.fr,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date:   Wed, 06 Jan 2021 08:20:40 -0800
In-Reply-To: <X/W4r1rmMCnKQAQZ@Gentoo>
References: <20210105101738.13072-1-unixbhaskar@gmail.com>
         <35a634c1-3672-b757-101e-9b8f3c0163a7@infradead.org>
         <X/W4r1rmMCnKQAQZ@Gentoo>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.38.1-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2021-01-06 at 18:48 +0530, Bhaskar Chowdhury wrote:
> Good point Randy, there were several driver file witch have "defautly" in it
> and I tried to correct that.Only that spell made it a "de-faulty" as dic
> suggested . But I think it should be "by default" as you said.

What tool suggested 'de-faulty' with a dash between de and faulty"

I don't believe it was codespell.

$ codespell drivers/net/wireless/realtek/rtlwifi/rtl8188ee/trx.c
drivers/net/wireless/realtek/rtlwifi/rtl8188ee/trx.c:61: cacluated ==> calculated
drivers/net/wireless/realtek/rtlwifi/rtl8188ee/trx.c:190: cacluated ==> calculated
drivers/net/wireless/realtek/rtlwifi/rtl8188ee/trx.c:435: managment ==> management
drivers/net/wireless/realtek/rtlwifi/rtl8188ee/trx.c:817: defautly ==> defaultly

Nor checkpatch:

$ ./scripts/checkpatch.pl -f --terse --nosummary --types=typo_spelling drivers/net/wireless/realtek/rtlwifi/rtl8188ee/trx.c
drivers/net/wireless/realtek/rtlwifi/rtl8188ee/trx.c:61: CHECK: 'cacluated' may be misspelled - perhaps 'calculated'?
drivers/net/wireless/realtek/rtlwifi/rtl8188ee/trx.c:190: CHECK: 'cacluated' may be misspelled - perhaps 'calculated'?
drivers/net/wireless/realtek/rtlwifi/rtl8188ee/trx.c:435: CHECK: 'managment' may be misspelled - perhaps 'management'?


