Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 145B4AFDBB
	for <lists+netdev@lfdr.de>; Wed, 11 Sep 2019 15:31:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727979AbfIKNbh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Sep 2019 09:31:37 -0400
Received: from mail2.candelatech.com ([208.74.158.173]:58932 "EHLO
        mail3.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726341AbfIKNbh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Sep 2019 09:31:37 -0400
Received: from [192.168.1.47] (unknown [50.34.216.97])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail3.candelatech.com (Postfix) with ESMTPSA id DA216104F;
        Wed, 11 Sep 2019 06:31:35 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mail3.candelatech.com DA216104F
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=candelatech.com;
        s=default; t=1568208696;
        bh=YdP3oSrdXhMHhpGVAboAGD7aHS6BEGqjs9AhHf3Di+Q=;
        h=Subject:To:References:Cc:From:Date:In-Reply-To:From;
        b=Ys5/jlkyIN75x90bnEJTleorbHVXgGm1upqLv7E6ICwjFoHXeHsnNyhGntRQ3BFAs
         5ttIW6AXsda1K4EFruw7zzY2PpNspSj0d7QzFVhBjcEpCNq03DZeF1FdB5tQ5NH2Ta
         x/dhXH6O7WXgW2XWOvlzAhWW4J7lX7r25d6XmVPI=
Subject: Re: WARNING at net/mac80211/sta_info.c:1057
 (__sta_info_destroy_part2())
To:     Linus Torvalds <torvalds@linux-foundation.org>
References: <CAHk-=wgBuu8PiYpD7uWgxTSY8aUOJj6NJ=ivNQPYjAKO=cRinA@mail.gmail.com>
 <feecebfcceba521703f13c8ee7f5bb9016924cb6.camel@sipsolutions.net>
 <CAHk-=wj_jneK+UYzHhjwsH0XxP0knM+2o2OeFVEz-FjuQ77-ow@mail.gmail.com>
 <30679d3f86731475943856196478677e70a349a9.camel@sipsolutions.net>
 <2d673d55-eb27-8573-b8ae-a493335723cf@candelatech.com>
 <CAHk-=wgAXAw=U_kthB9mG+MBocpawxCzo=6WDrbGgOUr+ac3CA@mail.gmail.com>
Cc:     Johannes Berg <johannes@sipsolutions.net>,
        "David S. Miller" <davem@davemloft.net>,
        Kalle Valo <kvalo@codeaurora.org>,
        linux-wireless@vger.kernel.org, Netdev <netdev@vger.kernel.org>,
        Linux List Kernel Mailing <linux-kernel@vger.kernel.org>
From:   Ben Greear <greearb@candelatech.com>
Message-ID: <4f00154a-41f2-b6f2-264f-10b3b6907fd7@candelatech.com>
Date:   Wed, 11 Sep 2019 06:31:35 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:45.0) Gecko/20100101
 Thunderbird/45.8.0
MIME-Version: 1.0
In-Reply-To: <CAHk-=wgAXAw=U_kthB9mG+MBocpawxCzo=6WDrbGgOUr+ac3CA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 09/11/2019 06:21 AM, Linus Torvalds wrote:
> On Wed, Sep 11, 2019 at 2:03 PM Ben Greear <greearb@candelatech.com> wrote:
>>
>> Out of curiosity, I'm interested to know what ath10k NIC chipset this is from.
>
> It's a Dell XPS 13 9380, with
>
>   02:00.0 Network controller: Qualcomm Atheros QCA6174 802.11ac
> Wireless Network Adapter (rev 32)
>         Subsystem: Bigfoot Networks, Inc. Killer 1435 Wireless-AC
>
> (numeric PCI ID 168c:003e, subsystem 1a56:143a).
>
> The ath10k driver says
>
>     qca6174 hw3.2 target 0x05030000 chip_id 0x00340aff sub 1a56:143a
>     firmware ver WLAN.RM.4.4.1-00140-QCARMSWPZ-1 api 6 features
> wowlan,ignore-otp,mfp crc32 29eb8ca1
>     board_file api 2 bmi_id N/A crc32 4ed3569e
>
> if that tells you anything more.

That means it is something I have never used nor have firmware for, but
the WMI logic should be similar to what I described and have experienced
with other chips.

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
