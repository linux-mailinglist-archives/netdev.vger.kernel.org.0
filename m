Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 98BED3240AA
	for <lists+netdev@lfdr.de>; Wed, 24 Feb 2021 16:30:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238517AbhBXPTd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Feb 2021 10:19:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237679AbhBXNmO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Feb 2021 08:42:14 -0500
Received: from proxima.lasnet.de (proxima.lasnet.de [IPv6:2a01:4f8:121:31eb:3::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F909C061794;
        Wed, 24 Feb 2021 05:40:37 -0800 (PST)
Received: from [IPv6:2003:e9:d72b:2a0f:18df:1c4d:541:33a8] (p200300e9d72b2a0f18df1c4d054133a8.dip0.t-ipconnect.de [IPv6:2003:e9:d72b:2a0f:18df:1c4d:541:33a8])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits))
        (No client certificate requested)
        (Authenticated sender: stefan@datenfreihafen.org)
        by proxima.lasnet.de (Postfix) with ESMTPSA id 8364DC0D3E;
        Wed, 24 Feb 2021 14:40:35 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=datenfreihafen.org;
        s=2021; t=1614174035;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=6j7YP2Ey14mrtaHj/1pakHKVgEIqc/hDGUcOde+JIDw=;
        b=Q2Yc8Il2NuaojT91b5GqZaeb4JYXvhEdo3GeS67C71KsnT4hXWFRD0MeJa8GGs4AmPUy2s
        tRd7cj9KIOHNnJfhvGp1LF8m/qVKkL9NyCtoqmxk2+xdHRIdLUN34aaiLMUadaO0Eojob1
        Jsj6297J0MDoq9a5zA6gFaTxRjAzvCf8TGaaN3kpAWlahsa4JJhsOG2Juf6JC4OrPIfGHK
        GfI9qgDA2PAppXI+DMnFNJ3N7DZt5DI4pGsn8jjjQeYPJ3NwrsE2oNFG8dnv0N9bJ30d0f
        pG7BFHEyeFZK10tewPVAZaz8V7ppePeoF95oYaPRgB3E/kIdiHXO/UWp43QA2g==
Subject: Re: UBSAN: shift-out-of-bounds in nl802154_new_interface
To:     Jakub Kicinski <kuba@kernel.org>,
        Alexander Aring <alex.aring@gmail.com>
Cc:     syzbot <syzbot+7bf7b22759195c9a21e9@syzkaller.appspotmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        kernel list <linux-kernel@vger.kernel.org>,
        linux-wpan - ML <linux-wpan@vger.kernel.org>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>,
        syzkaller-bugs@googlegroups.com
References: <000000000000e37c9805bbe843c1@google.com>
 <20210223154855.669413bb@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CAB_54W6FL2vDto3_1=0kAa8qo_qTduCfULLCfvD_XbS4=+VZyw@mail.gmail.com>
 <20210223164924.080fa605@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Stefan Schmidt <stefan@datenfreihafen.org>
Message-ID: <75f80c0a-6990-c392-d28a-a296475bbc29@datenfreihafen.org>
Date:   Wed, 24 Feb 2021 14:40:35 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20210223164924.080fa605@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Alex.

On 24.02.21 01:49, Jakub Kicinski wrote:
> On Tue, 23 Feb 2021 19:26:26 -0500 Alexander Aring wrote:
>> Hi,
>>
>> On Tue, 23 Feb 2021 at 18:48, Jakub Kicinski <kuba@kernel.org> wrote:
>>>
>>> Alex, there seems to be a few more syzbot reports for nl802154 beyond
>>> what you posted fixes for. Are you looking at these?
>>
>> Yes, I have it on my list. I will try to fix them at the weekend.
> 
> Great, thank you!

Thanks for handling these. Your first batch is reviewed and applied. I 
will wait for the next round before I send a pull request to net.

regards
Stefan Schmidt
