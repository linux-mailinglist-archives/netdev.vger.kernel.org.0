Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA63D20CBDA
	for <lists+netdev@lfdr.de>; Mon, 29 Jun 2020 04:51:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726120AbgF2CvI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 28 Jun 2020 22:51:08 -0400
Received: from smtprelay0011.hostedemail.com ([216.40.44.11]:46510 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725983AbgF2CvH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 28 Jun 2020 22:51:07 -0400
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay05.hostedemail.com (Postfix) with ESMTP id 3C72C18029132;
        Mon, 29 Jun 2020 02:51:06 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,,RULES_HIT:41:152:355:379:582:599:968:973:988:989:1152:1260:1277:1311:1313:1314:1345:1359:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2110:2393:2559:2562:2691:3138:3139:3140:3141:3142:3352:3865:3866:3867:3868:3870:3871:3872:3873:4321:4605:5007:6261:7522:7903:9036:9389:10004:10400:10848:11026:11232:11658:11783:11914:12043:12295:12296:12297:12438:12555:12679:12740:12895:13069:13161:13229:13311:13357:13894:14659:14685:14721:21080:21627:21990:30054:30070:30091,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:,MSBL:0,DNSBL:none,Custom_rules:0:0:0,LFtime:1,LUA_SUMMARY:none
X-HE-Tag: camp36_030edf026e6b
X-Filterd-Recvd-Size: 2690
Received: from perches-mx.perches.com (imap-ext [216.40.42.5])
        (Authenticated sender: webmail@joe@perches.com)
        by omf17.hostedemail.com (Postfix) with ESMTPA;
        Mon, 29 Jun 2020 02:51:05 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 8bit
Date:   Sun, 28 Jun 2020 19:51:05 -0700
From:   joe@perches.com
To:     Pkshih <pkshih@realtek.com>
Cc:     kvalo@codeaurora.org, linux-wireless@vger.kernel.org,
        davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] rtlwifi/*/dm.c: Use const in swing_table declarations
In-Reply-To: <1593396529.11412.6.camel@realtek.com>
References: <0f24268338756bb54b4e44674db4aaf90f8a9fca.camel@perches.com>
 <1593396529.11412.6.camel@realtek.com>
User-Agent: Roundcube Webmail/1.4-rc2
Message-ID: <45c908b9b55000dc7b0cf9438c8e6e44@perches.com>
X-Sender: joe@perches.com
X-Originating-IP: [47.151.133.149]
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020-06-28 19:09, Pkshih wrote:
> On Sun, 2020-06-28 at 03:17 -0700, Joe Perches wrote:
> 
> Use 'rtlwifi:' as subject title prefix is enough, likes
>   rtlwifi: Use const in swing_table declarations

We disagree.

I like knowing what content is changed via patch subject lines
as there are 3 rtlwifi drivers being changed by this one patch.

But your choice, you can change it if you choose.

>> Reduce data usage about 1KB by using const.
[]
> Please remove below type casting: 
> 
> @@ -1872,10 +1872,10 @@ static void 
> rtl8821ae_get_delta_swing_table(struct
> ieee80211_hw *hw,
>                 *up_b = rtl8821ae_delta_swing_table_idx_5gb_p[2];
>                 *down_b = rtl8821ae_delta_swing_table_idx_5gb_n[2];
>         } else {
> -           *up_a = (u8 *)rtl8818e_delta_swing_table_idx_24gb_p;
> -           *down_a = (u8 *)rtl8818e_delta_swing_table_idx_24gb_n;
> -           *up_b = (u8 *)rtl8818e_delta_swing_table_idx_24gb_p;
> -           *down_b = (u8 *)rtl8818e_delta_swing_table_idx_24gb_n;
> +               *up_a = rtl8818e_delta_swing_table_idx_24gb_p;
> +               *down_a = rtl8818e_delta_swing_table_idx_24gb_n;
> +               *up_b = rtl8818e_delta_swing_table_idx_24gb_p;
> +               *down_b = rtl8818e_delta_swing_table_idx_24gb_n;

The compiler is quiet about this so I believe this to be
an unrelated change and whitespace correction.

Of course you could modify it if you choose.

btw: There's an unnecessary return at the 2nd instance
      of this cast removal too.

cheers, Joe
