Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C829024EBBC
	for <lists+netdev@lfdr.de>; Sun, 23 Aug 2020 08:06:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726744AbgHWGF3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Aug 2020 02:05:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725830AbgHWGF3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 23 Aug 2020 02:05:29 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A20FC061573
        for <netdev@vger.kernel.org>; Sat, 22 Aug 2020 23:05:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:Subject:Sender
        :Reply-To:Content-ID:Content-Description;
        bh=1iYJuhG0tzrB8Bf5m8FYNXArkap6cTu6gz6CcWPiEaM=; b=j70cSftxZD51A0uurzxPZFPwrF
        N59RS0imdn+RgiHKWjt6E7L0GnwImKxG4mKJSyXQvCxdaQK+zBdyymccg+4Gt8ngosKAsDytoyLSv
        JHQG3pTauFjWnnZ3NWKVJyuJnGmcldwF2UyynPfTFFh5ZWqFA3ZpcvBb/w8bOiLT0KAa4hRhnpysZ
        uX4Ohd7n8dxozKvUf/13A/eTvJVg1xm3+X3V/270FjHlcrf7XTi1ldTRpN4Nfr1QN0P9eIPj32atm
        iRd7gTwvvmfEoBAMOhI1ILs5zKY7mc6jylmKVB7RkuI1zCPSCK9vBmtmvyJL0lbQHu3E25B9U3Yr5
        eyId3mcg==;
Received: from [2601:1c0:6280:3f0::19c2]
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1k9j7y-0007PV-9B; Sun, 23 Aug 2020 06:05:15 +0000
Subject: Re: [PATCH 0/8] net: batman-adv: delete duplicated words + other
 fixes
To:     Sven Eckelmann <sven@narfation.org>, netdev@vger.kernel.org
Cc:     Marek Lindner <mareklindner@neomailbox.ch>,
        Simon Wunderlich <sw@simonwunderlich.de>,
        Antonio Quartulli <a@unstable.cc>,
        b.a.t.m.a.n@lists.open-mesh.org,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
References: <20200822231335.31304-1-rdunlap@infradead.org>
 <1676363.I2AznyWB51@sven-edge>
From:   Randy Dunlap <rdunlap@infradead.org>
Message-ID: <37b82a77-fc58-9a7b-8996-a6bd030ee7ef@infradead.org>
Date:   Sat, 22 Aug 2020 23:05:10 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <1676363.I2AznyWB51@sven-edge>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/22/20 10:49 PM, Sven Eckelmann wrote:
> On Sunday, 23 August 2020 01:13:27 CEST Randy Dunlap wrote:
>> Drop repeated words in net/batman-adv/.
> 
> Please rebase to only contain the changes not yet in 
> https://git.open-mesh.org/linux-merge.git/shortlog/refs/heads/batadv/net-next
> 
> Kind regards,
> 	Sven

Ah, I think that you have everything covered already.
Glad to see it.


Is this git tree included in linux-next?

thanks.
-- 
~Randy

