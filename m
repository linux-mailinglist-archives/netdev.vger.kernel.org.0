Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BF3B619ECB0
	for <lists+netdev@lfdr.de>; Sun,  5 Apr 2020 18:41:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727620AbgDEQla (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Apr 2020 12:41:30 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:43786 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727075AbgDEQl3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 Apr 2020 12:41:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        Content-Type:In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:
        Subject:Sender:Reply-To:Content-ID:Content-Description;
        bh=+M0Y1kjtlZOoIzta5LvEShFkET8hM92YHdaoqL+I5Fg=; b=dq7sjnd54/K3+ZTSbi2RUgN+61
        rJw2w4cuSzHi64TQmp4migtec4jAcBa15X41M9GNs2Ar9QcvqxJE2XP/khncENXbWRU5zmZpG9JKL
        qUomqye3eWwhubDeX/WbcRFiJjr9q5eXJ+MwtiafS0gIpIrlNq/w+P6rfa2xOgt79r+6jNWEFx5Rk
        9FU6XydQ4jwaryrEGp5NcqWDrb4w0QCtmGUva7es7IeTbAwzcCM704hXvi+t/Dq27YzNxW/XjyZWv
        LCxi63wdSEOCAg822kz2avJI2F+gLYXROu7sDfgeNsJf0oYLgqZpunQq18W69n0t9dy8i5D9vY/cA
        yNjCc1Ag==;
Received: from [2601:1c0:6280:3f0::19c2]
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jL8Kr-0002db-DQ; Sun, 05 Apr 2020 16:41:25 +0000
Subject: Re: [PATCH net] skbuff.h: Improve the checksum related comments
To:     Dexuan Cui <decui@microsoft.com>,
        Matthew Wilcox <willy@infradead.org>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "willemb@google.com" <willemb@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "simon.horman@netronome.com" <simon.horman@netronome.com>,
        "sdf@google.com" <sdf@google.com>,
        "john.hurley@netronome.com" <john.hurley@netronome.com>,
        "edumazet@google.com" <edumazet@google.com>,
        "fw@strlen.de" <fw@strlen.de>,
        "jonathan.lemon@gmail.com" <jonathan.lemon@gmail.com>,
        "pablo@netfilter.org" <pablo@netfilter.org>,
        "jeremy@azazel.net" <jeremy@azazel.net>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <1586071063-51656-1-git-send-email-decui@microsoft.com>
 <20200405103618.GV21484@bombadil.infradead.org>
 <HK0P153MB027363A6F5A5AACC366B11A3BFC50@HK0P153MB0273.APCP153.PROD.OUTLOOK.COM>
From:   Randy Dunlap <rdunlap@infradead.org>
Message-ID: <7a0df207-8ad3-3731-c372-146a19befc02@infradead.org>
Date:   Sun, 5 Apr 2020 09:41:24 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <HK0P153MB027363A6F5A5AACC366B11A3BFC50@HK0P153MB0273.APCP153.PROD.OUTLOOK.COM>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/5/20 9:33 AM, Dexuan Cui wrote:
>> From: Matthew Wilcox <willy@infradead.org>
>> Sent: Sunday, April 5, 2020 3:36 AM
>> To: Dexuan Cui <decui@microsoft.com>
>>
>> On Sun, Apr 05, 2020 at 12:17:43AM -0700, Dexuan Cui wrote:
>>>   * CHECKSUM_COMPLETE:
>>>   *
>>> - *   This is the most generic way. The device supplied checksum of the
>> _whole_
>>> - *   packet as seen by netif_rx() and fills out in skb->csum. Meaning, the
>>> + *   This is the most generic way. The device supplies checksum of the
>> _whole_
>>> + *   packet as seen by netif_rx() and fills out in skb->csum. This means the
>>
>> I think both 'supplies' and 'supplied' are correct in this sentence.  The
>> nuances are slightly different, but the meaning is the same in this instance.
> 
> I see. So let me rever back to "supplied".
>  
>> You missed a mistake in the second line though, it should be either 'fills
>> out' or 'fills in'.  I think we tend to prefer 'fills in'.
> 
> Thanks! Will use "fills in" in v2.
> 
>>>   * CHECKSUM_COMPLETE:
>>>   *   Not used in checksum output. If a driver observes a packet with this
>> value
>>> - *   set in skbuff, if should treat as CHECKSUM_NONE being set.
>>> + *   set in skbuff, the driver should treat it as CHECKSUM_NONE being set.
>>
>> I would go with "it should treat the packet as if CHECKSUM_NONE were set."
> 
> Thanks. Will use this version.
>  
>>> @@ -211,7 +211,7 @@
>>>   * is implied by the SKB_GSO_* flags in gso_type. Most obviously, if the
>>>   * gso_type is SKB_GSO_TCPV4 or SKB_GSO_TCPV6, TCP checksum offload
>> as
>>>   * part of the GSO operation is implied. If a checksum is being offloaded
>>> - * with GSO then ip_summed is CHECKSUM_PARTIAL, csum_start and
>> csum_offset
>>> + * with GSO then ip_summed is CHECKSUM_PARTIAL AND csum_start and
>> csum_offset
>>>   * are set to refer to the outermost checksum being offload (two offloaded
>>>   * checksums are possible with UDP encapsulation).
>>
>> Why the capitalisation of 'AND'?
> 
> The current text without the patch is:
>  * part of the GSO operation is implied. If a checksum is being offloaded
>  * with GSO then ip_summed is CHECKSUM_PARTIAL, csum_start and csum_offset
>  * are set to refer to the outermost checksum being offload (two offloaded
>  * checksums are possible with UDP encapsulation).
> 
> The comma after the "CHECKSUM_PARTIAL" seems suspicious to me. I feel we
> should add an "and" after the comma, or replace the comma with "and", but
> either way we'll have "... and csum_start and csum_offset...", which seems a little
> unnatural to me since we have 2 'and's here... So I tried to make it a little natural
> by replacing the first 'and' with 'AND', which obviously causes confusion to you.

maybe "both csum_start and csum_offset are set to refer to".

> Please suggest the best change here. Thanks!
>  
>> Thanks for the improvements,
>>
>> Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
> 
> Thanks for the comments! I'll wait for your suggestion on the 'AND' and post
> a v2.


-- 
~Randy

