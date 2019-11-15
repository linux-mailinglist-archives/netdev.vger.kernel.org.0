Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 50A84FD760
	for <lists+netdev@lfdr.de>; Fri, 15 Nov 2019 08:53:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726983AbfKOHxK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Nov 2019 02:53:10 -0500
Received: from mail.dlink.ru ([178.170.168.18]:48360 "EHLO fd.dlink.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725829AbfKOHxK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 15 Nov 2019 02:53:10 -0500
Received: by fd.dlink.ru (Postfix, from userid 5000)
        id E7B311B2040B; Fri, 15 Nov 2019 10:53:07 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 fd.dlink.ru E7B311B2040B
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dlink.ru; s=mail;
        t=1573804387; bh=8Ehrj23PMw/h0WcE7C1DeuA9hvHqsayqXUUFF8u9gEM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References;
        b=jJh5himROQYvaXrqmY9SbrNIc2jqMifGFam4qqbx2Tcq9Zf46JguwD2uABxXilSWz
         6jj77L9eW5WDfMr8rvjRhh+OADuBEEPlDOrhxCh2gXu6in+jEL/6pMB6VDOhmrLn9l
         V5Sial4/eZWn7TTjiV1av0m7W3ZwyvPdMvgBUFyM=
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on mail.dlink.ru
X-Spam-Level: 
X-Spam-Status: No, score=-99.2 required=7.5 tests=BAYES_50,URIBL_BLOCKED,
        USER_IN_WHITELIST autolearn=disabled version=3.4.2
Received: from mail.rzn.dlink.ru (mail.rzn.dlink.ru [178.170.168.13])
        by fd.dlink.ru (Postfix) with ESMTP id 80FF51B2040B;
        Fri, 15 Nov 2019 10:52:59 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 fd.dlink.ru 80FF51B2040B
Received: from mail.rzn.dlink.ru (localhost [127.0.0.1])
        by mail.rzn.dlink.ru (Postfix) with ESMTP id 3ECB51B21209;
        Fri, 15 Nov 2019 10:52:59 +0300 (MSK)
Received: from mail.rzn.dlink.ru (localhost [127.0.0.1])
        by mail.rzn.dlink.ru (Postfix) with ESMTPA;
        Fri, 15 Nov 2019 10:52:59 +0300 (MSK)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 8bit
Date:   Fri, 15 Nov 2019 10:52:59 +0300
From:   Alexander Lobakin <alobakin@dlink.ru>
To:     David Miller <davem@davemloft.net>
Cc:     ecree@solarflare.com, jiri@mellanox.com, edumazet@google.com,
        idosch@mellanox.com, pabeni@redhat.com, petrm@mellanox.com,
        sd@queasysnail.net, f.fainelli@gmail.com,
        jaswinder.singh@linaro.org, manishc@marvell.com,
        GR-Linux-NIC-Dev@marvell.com, johannes.berg@intel.com,
        emmanuel.grumbach@intel.com, luciano.coelho@intel.com,
        linuxwifi@intel.com, kvalo@codeaurora.org, netdev@vger.kernel.org,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] net: core: allow fast GRO for skbs with Ethernet
 header in head
In-Reply-To: <20191114.234958.1198680245198023054.davem@davemloft.net>
References: <20191112122843.30636-1-alobakin@dlink.ru>
 <20191114.172508.1027995193093100862.davem@davemloft.net>
 <097eb720466a7c429c8fd91c792e7cd5@dlink.ru>
 <20191114.234958.1198680245198023054.davem@davemloft.net>
User-Agent: Roundcube Webmail/1.4.0
Message-ID: <4cff3016dcc4fc63e23d5c0de6f81bd8@dlink.ru>
X-Sender: alobakin@dlink.ru
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

David Miller wrote 15.11.2019 10:49:

> From: Alexander Lobakin <alobakin@dlink.ru>
> Date: Fri, 15 Nov 2019 10:36:08 +0300
> 
>> Please let me know if I must send v2 of this patch with corrected
>> description before getting any further reviews.
> 
> I would say that you do, thanks for asking.
> 
> The more details and information in the commit message, the better.

Thank you, I'll publish v2 soon to clarify all the possible
misunderstandings.

Regards,
ᚷ ᛖ ᚢ ᚦ ᚠ ᚱ
