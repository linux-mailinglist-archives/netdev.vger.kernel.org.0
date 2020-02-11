Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2960A159A7F
	for <lists+netdev@lfdr.de>; Tue, 11 Feb 2020 21:27:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731806AbgBKU1s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Feb 2020 15:27:48 -0500
Received: from gateway23.websitewelcome.com ([192.185.50.129]:34690 "EHLO
        gateway23.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728522AbgBKU1p (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Feb 2020 15:27:45 -0500
Received: from cm11.websitewelcome.com (cm11.websitewelcome.com [100.42.49.5])
        by gateway23.websitewelcome.com (Postfix) with ESMTP id 8BC7B69E9
        for <netdev@vger.kernel.org>; Tue, 11 Feb 2020 14:27:43 -0600 (CST)
Received: from gator4166.hostgator.com ([108.167.133.22])
        by cmsmtp with SMTP
        id 1c8FjDiCrSl8q1c8FjwpN7; Tue, 11 Feb 2020 14:27:43 -0600
X-Authority-Reason: nr=8
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=embeddedor.com; s=default; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:Subject:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=PPWWdaifeZzk9RLwFlJ5meY5m2rkkfSdPZkRBHo2zLg=; b=lMUWu+8neDtCWoM7HC7ndnZLve
        CNLfWODYRH0dKfbYGWeisHnLSxwNAv69i74ZGjwscfb0/qmOAypEZD+6HBJFL+fTIjsho7HOEtwG1
        MkHOsPZmKwA2Q5pvtdb3Fiw15YCeLaJIrWEpEr+djGYU1UyM4rUwYKd2T+uOu6kMzs+8Zoi0P1/fV
        bYOr6VWSaXgDAjg9G1QXzRO17lr07NmB7n60KgWN3y8bbtk63wqdlYlBwoJS8OYKCJNFDxDDjsT2Q
        kEdxfEnZv6oclhIyZH55YS7WheIc/5xVs6zTjk/g7Dp8gA06Fof0OK0Aw9jCl+XbJ8x4i5IDqZi6S
        pym9IHiw==;
Received: from [200.68.140.36] (port=27441 helo=[192.168.43.131])
        by gator4166.hostgator.com with esmtpsa (TLSv1.2:ECDHE-RSA-AES128-GCM-SHA256:128)
        (Exim 4.92)
        (envelope-from <gustavo@embeddedor.com>)
        id 1j1c8F-001jRM-5K; Tue, 11 Feb 2020 14:27:43 -0600
Subject: Re: [PATCH] treewide: Replace zero-length arrays with flexible-array
 member
To:     Kees Cook <keescook@chromium.org>
Cc:     Greg KH <gregkh@linuxfoundation.org>, linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, netdev@vger.kernel.org,
        linux-usb@vger.kernel.org
References: <20200211174126.GA29960@embeddedor>
 <20200211183229.GA1938663@kroah.com>
 <3fdbb16a-897c-aa5b-d45d-f824f6810412@embeddedor.com>
 <202002111129.77DB1CCC7B@keescook> <20200211193854.GA1972490@kroah.com>
 <88e09425-8207-7a1e-8802-886f9694a37f@embeddedor.com>
 <202002111210.876CEB6@keescook>
From:   "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Autocrypt: addr=gustavo@embeddedor.com; keydata=
 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
 VtSixD1uOgytAP7RWS474w==
Message-ID: <2b73d115-1259-24ae-6f56-e3aa12e5e408@embeddedor.com>
Date:   Tue, 11 Feb 2020 14:30:17 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <202002111210.876CEB6@keescook>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - gator4166.hostgator.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - embeddedor.com
X-BWhitelist: no
X-Source-IP: 200.68.140.36
X-Source-L: No
X-Exim-ID: 1j1c8F-001jRM-5K
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: ([192.168.43.131]) [200.68.140.36]:27441
X-Source-Auth: gustavo@embeddedor.com
X-Email-Count: 24
X-Source-Cap: Z3V6aWRpbmU7Z3V6aWRpbmU7Z2F0b3I0MTY2Lmhvc3RnYXRvci5jb20=
X-Local-Domain: yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2/11/20 14:12, Kees Cook wrote:
> On Tue, Feb 11, 2020 at 01:54:22PM -0600, Gustavo A. R. Silva wrote:
>>
>>
>> On 2/11/20 13:38, Greg KH wrote:
>>> On Tue, Feb 11, 2020 at 11:32:04AM -0800, Kees Cook wrote:
>>>> On Tue, Feb 11, 2020 at 01:20:36PM -0600, Gustavo A. R. Silva wrote:
>>>>>
>>>>>
>>>>> On 2/11/20 12:32, Greg KH wrote:
>>>>>> On Tue, Feb 11, 2020 at 11:41:26AM -0600, Gustavo A. R. Silva wrote:
>>>>>>> The current codebase makes use of the zero-length array language
>>>>>>> extension to the C90 standard, but the preferred mechanism to declare
>>>>>>> variable-length types such as these ones is a flexible array member[1][2],
>>>>>>> introduced in C99:
>>>>>>>
>>>>>>> struct foo {
>>>>>>>         int stuff;
>>>>>>>         struct boo array[];
>>>>>>> };
>>>>>>>
>>>>>>> By making use of the mechanism above, we will get a compiler warning
>>>>>>> in case the flexible array does not occur last in the structure, which
>>>>>>> will help us prevent some kind of undefined behavior bugs from being
>>>>>>> unadvertenly introduced[3] to the codebase from now on.
>>>>>>>
>>>>>>> All these instances of code were found with the help of the following
>>>>>>> Coccinelle script:
>>>>>>>
>>>>>>> @@
>>>>>>> identifier S, member, array;
>>>>>>> type T1, T2;
>>>>>>> @@
>>>>>>>
>>>>>>> struct S {
>>>>>>>   ...
>>>>>>>   T1 member;
>>>>>>>   T2 array[
>>>>>>> - 0
>>>>>>>   ];
>>>>>>> };
>>>>>>>
>>>>>>> [1] https://gcc.gnu.org/onlinedocs/gcc/Zero-Length.html
>>>>>>> [2] https://github.com/KSPP/linux/issues/21
>>>>>>> [3] commit 76497732932f ("cxgb3/l2t: Fix undefined behaviour")
>>>>>>>
>>>>>>> NOTE: I'll carry this in my -next tree for the v5.6 merge window.
>>>>>>
>>>>>> Why not carve this up into per-subsystem patches so that we can apply
>>>>>> them to our 5.7-rc1 trees and then you submit the "remaining" that don't
>>>>>> somehow get merged at that timeframe for 5.7-rc2?
>>>>>>
>>>>>
>>>>> Yep, sounds good. I'll do that.
>>>>
>>>> FWIW, I'd just like to point out that since this is a mechanical change
>>>> with no code generation differences (unlike the pre-C90 1-byte array
>>>> conversions), it's a way better use of everyone's time to just splat
>>>> this in all at once.
>>>>
>>>> That said, it looks like Gustavo is up for it, but I'd like us to
>>>> generally consider these kinds of mechanical changes as being easier to
>>>> manage in a single patch. (Though getting Acks tends to be a bit
>>>> harder...)
>>>
>>> Hey, if this is such a mechanical patch, let's get it to Linus now,
>>> what's preventing that from being merged now?
> 
> Now would be a good time, yes. (Linus has wanted Acks for such things
> sometimes, but those were more "risky" changes...)
> 
>> Well, the only thing is that this has never been in linux-next.
> 
> Hmm. Was it in one of your 0day-tested trees?
> 

It was in my tree for quite a while, but it was never 0day-tested.
Just recently, the 0day guys started testing my _new_ branches,
regularly.

Today, I updated my -next branch to v5.6-rc1 and added the
treewide patch. So, I expect it to be 0day-tested in a couple
of days.

--
Gustavo
