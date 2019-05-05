Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 437001420B
	for <lists+netdev@lfdr.de>; Sun,  5 May 2019 21:12:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727706AbfEETMZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 May 2019 15:12:25 -0400
Received: from mail-pl1-f193.google.com ([209.85.214.193]:35334 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726636AbfEETMY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 May 2019 15:12:24 -0400
Received: by mail-pl1-f193.google.com with SMTP id w24so5237572plp.2
        for <netdev@vger.kernel.org>; Sun, 05 May 2019 12:12:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:openpgp:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=UWdyAJFzDoOKPK42c+RdVNABzNrCdN5ShH0AFAVI6ko=;
        b=Z8Cl+eMnUFxGADSKJo4ns7w/qpoUhI/wgAz5s93T1LxYEc1mSYIb/COqIRAtvRwGkp
         VHUpHC3kh7SVsS7+x/AHETb56+yfuNmj0bCcHuvhVoHUiHpabDeDYH6oK9SADCrkp7fG
         2Y8brnzZQIVFgN+tvbmqRb3V8KFPtjd1kH9Bgn8GLc81OJHaKqfbxUgHs9RfR98zrNY1
         PoEWuAWqcCx1OPEELZxOJ5PkQj7LbQ/ncRGGIYPU1igL3YpUkm9eSlpfZQfK6/hQHNWk
         no6LKC/n7P6aWYSKZwT7Dl0V8kmPD/0BBIOIFPSWX5PFfU+vRKNj/M3YQZ8h4huzUZkf
         Lw3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=UWdyAJFzDoOKPK42c+RdVNABzNrCdN5ShH0AFAVI6ko=;
        b=anCNiYznVTKjRLtXEidueUEuWLdip6WC8o/yvga0PS0L5UF5zr7gizo2IsAPf1tPuP
         cjp8OPojRm3HFkAZYkzm0wh4bhWFglm/7jY1zxc0QxDyOYhLelBSh6wqbruAnRAuoj68
         yuMDBHkXwUfKxRjRVCyTpF8NfHCZAkVLWC51N87sANgdrKNmlpXKPzB37wEgeASTzTq8
         sPAuhpxGEsiq2gQcHSs6Vz4k1yTdfc8Y9ay3PBMG1ywOW1c7kD+Al/mvaTKg++SNJlut
         rB3FqF2jRmJw4TpAhbe07XZTRsafKUDDcr7Dxzd8gTZBpsdkyF8F4hOfMxT9BeM8fvaw
         J7kA==
X-Gm-Message-State: APjAAAVuSQACG3ksXMjl3PDcRa/SZptJXMsGlUf+x7wuo8wRWWde4IMr
        NnE/373O7zWEYlgcdDJKOnc/jGen
X-Google-Smtp-Source: APXvYqyWJ2B6rUCCjgOFOZWjQ/5whr9vheziO1XBYSxWQ4YjCA/rdyHSIE9PdNUy1nJiiHQhV9HpNQ==
X-Received: by 2002:a17:902:e407:: with SMTP id ci7mr26816288plb.219.1557083543344;
        Sun, 05 May 2019 12:12:23 -0700 (PDT)
Received: from [10.230.28.107] ([192.19.223.250])
        by smtp.gmail.com with ESMTPSA id s17sm10408040pfm.149.2019.05.05.12.12.21
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 05 May 2019 12:12:22 -0700 (PDT)
Subject: Re: [PATCH net-next] net: phy: improve pause mode reporting in
 phy_print_status
To:     Heiner Kallweit <hkallweit1@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        David Miller <davem@davemloft.net>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <1ea97344-6971-44dd-2191-9a8db0d2c10d@gmail.com>
 <65df73ce-9213-2b6a-6894-f68bf54a5f3d@gmail.com>
 <5cc8f009-c558-05ff-1739-4e4fd8c68bf2@gmail.com>
 <87b70c57-2d95-8e23-674d-71541122b1b4@gmail.com>
 <1278310b-5457-e8eb-851e-1796d2616f8d@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Openpgp: preference=signencrypt
Message-ID: <ad7fc900-2f3f-abb1-5e7f-67a79a9125f3@gmail.com>
Date:   Sun, 5 May 2019 12:12:20 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <1278310b-5457-e8eb-851e-1796d2616f8d@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/5/2019 12:06 PM, Heiner Kallweit wrote:
> On 05.05.2019 20:46, Florian Fainelli wrote:
>>
>>
>> On 5/5/2019 10:31 AM, Heiner Kallweit wrote:
>>> On 05.05.2019 19:10, Florian Fainelli wrote:
>>>>
>>>>
>>>> On 5/5/2019 10:03 AM, Heiner Kallweit wrote:
>>>>> So far we report symmetric pause only, and we don't consider the local
>>>>> pause capabilities. Let's properly consider local and remote
>>>>> capabilities, and report also asymmetric pause.
>>>>
>>>> I would go one step further which is to print what is the link state of
>>>> RX/TX pause, so something like:
>>>>
>>>> - local RX/TX pause advertisement
>>>> - link partnr RX/TX pause advertisement
>>>> - RX/TX being enabled for the link (auto-negotiated or manual)
>>>>
>>>> this sort of duplicates what ethtool offers already but arguably so does
>>>> printing the link state so this would not be that big of a stretch.
>>>>
>>>> I would make the print be something like:
>>>>
>>>> Link is Up - 1Gb/Full - local pause: rx/tx, lpa pause: rx/tx, link
>>>> pause: auto-negotiated
>>>> Link is Up - 1Gb/Full - local pause: rx/tx, lpa pause: rx/tx, link
>>>> pause: forced off
>>>> Link is Up - 1Gb/Full - local pause: rx/tx, lpa pause: rx/tx, link
>>>> pause: forced on
>>>>
>>> For speed and duplex we don't print the capabilities of both sides
>>> but the negotiation result. Therefore I think it's more plausible
>>> to do the same for pause.
>>
>> Pause is different though, if the link speed does not match, there is no
>> link, if the duplex do not match you may establish a link but there will
>> be a duplex mismatch which will cause all sorts of issues. Pause is not
>> an essential link parameter and is more of an optimization.
>>
> Right, still I think this is too much and only partially relevant
> information for the user. And if e.g. the remote side doesn't support
> pause, then it's irrelevant what we support. I think the user is
> (if at all) interested in the information which pause mode is effectively
> used.

My point was really that I would rather see the resolved pause status,
which takes into account the link partner advertised, locally advertised
pause settings and local policy (enabled/disabled/auto-negotiated),
rather than the current/locally advertised pause settings which are just
one view of the link. Your patch is fine in that it properly decouples
the symetric/assymetric nature of the settings though.

> 
>>> IMO the intention of phy_print_status() is to print what is
>>> effectively used. If a user is interested in the detailed capabilities
>>> of both sides he can use ethtool, as mentioned by you.
>>>
>>> In fixed mode we currently report pause "off" always.
>>>
>>> Maybe, before we go further, one question for my understanding:
>>> If the link partner doesn't support pause, who tells the MAC how that
>>> it must not send pause frames? Is the network driver supposed to
>>> do this in the adjust_link callback?
>>
>> If the link partner does not support pause, they are not advertised by
>> the link partner and you can read that from the LPA and the resolution
>> of the local pause and link partner pause settings should come back as
>> "not possible" (there may be caveats with symmetric vs. asymmetric pause
>> support).
>>
>> PHYLINK is a good example of how pause should be reported towards the MAC.
>>
> Thanks. So I think the usual MAC driver would have to check pause support
> in the handler passed as argument to phy_connect_direct().

Given that pause can be changed from ethtool -A, would not that just be
a partial view of pause at the time the MAC and PHY get bound together?

> 
>>>
>>> In the Realtek network chip datasheet I found a vague comment that
>>> the MAC checks the aneg result of the internal PHY to decide
>>> whether send pause frames or not.
>>
>> That would mean that the MAC behaves in a mode where it defaults to
>> pause frame being auto-negotiated, which is something that some Ethernet
>> MAC drivers default to as well. As long as you can disable pause when
>> the user requests it, that should be fine.
>>
> At least for the Realtek chips there is no documented way to disable pause.
> If the remote side doesn't support pause, what happens if a pause frame is
> sent? Is it just ignored or can we expect some sort of issue?

Your mileage may vary of course, but if the remote side either does not
support pause or has receive pause frame support disabled, then these
frames should be ignored.
-- 
Florian
