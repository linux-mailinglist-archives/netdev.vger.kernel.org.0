Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D037045EA7E
	for <lists+netdev@lfdr.de>; Fri, 26 Nov 2021 10:37:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376408AbhKZJkR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Nov 2021 04:40:17 -0500
Received: from mail.loongson.cn ([114.242.206.163]:58934 "EHLO loongson.cn"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1376415AbhKZJiR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 26 Nov 2021 04:38:17 -0500
Received: from [10.180.13.93] (unknown [10.180.13.93])
        by mail.loongson.cn (Coremail) with SMTP id AQAAf9AxesgsqqBhRiAAAA--.19S2;
        Fri, 26 Nov 2021 17:34:47 +0800 (CST)
Subject: Re: [PATCH v1 1/2] modpost: file2alias: fixup mdio alias garbled code
 in modules.alias
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>, linux@armlinux.org.uk,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-kbuild@vger.kernel.org, zhuyinbo@loongson.cn,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-kbuild@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        masahiroy@kernel.org, michal.lkml@markovi.net,
        ndesaulniers@google.com
References: <1637583298-20321-1-git-send-email-zhuyinbo@loongson.cn>
 <YZukJBsf3qMOOK+Y@lunn.ch> <5b561d5f-d7ac-4d90-e69e-5a80a73929e0@loongson.cn>
 <YZxqLi7/JDN9mQoK@lunn.ch> <0a9e959a-bcd1-f649-b4cd-bd0f65fc71aa@loongson.cn>
 <YZzykR2rcXnu/Hzx@lunn.ch>
From:   zhuyinbo <zhuyinbo@loongson.cn>
Message-ID: <92c667be-7d33-7742-5fb9-7e5670024911@loongson.cn>
Date:   Fri, 26 Nov 2021 17:34:36 +0800
User-Agent: Mozilla/5.0 (X11; Linux mips64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <YZzykR2rcXnu/Hzx@lunn.ch>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-CM-TRANSID: AQAAf9AxesgsqqBhRiAAAA--.19S2
X-Coremail-Antispam: 1UD129KBjvJXoW7tFW8uF1DuFW3XrWDWFW7Arb_yoW8tr1fpF
        43tFyjkr4kJr43tw1xKr1kZayUK3s7Aa1jq345J3s09r90vr1Utr10grWj93srWr4rJw12
        qr1jqFWvgF4jy3DanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUU9C14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
        rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
        1l84ACjcxK6xIIjxv20xvE14v26ryj6F1UM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4U
        JVWxJr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Gc
        CE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E
        2Ix0cI8IcVAFwI0_Jr0_Jr4lYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJV
        W8JwACjcxG0xvEwIxGrwACjI8F5VA0II8E6IAqYI8I648v4I1lFIxGxcIEc7CjxVA2Y2ka
        0xkIwI1lc7I2V7IY0VAS07AlzVAYIcxG8wCY02Avz4vE-syl42xK82IYc2Ij64vIr41l4I
        8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8GjcxK67AK
        xVWUGVWUWwC2zVAF1VAY17CE14v26r1q6r43MIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcV
        AFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r4j6F4UMIIF0xvE42xK8VAvwI8I
        cIk0rVWrZr1j6s0DMIIF0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI
        0_Gr0_Gr1UYxBIdaVFxhVjvjDU0xZFpf9x0JUdHUDUUUUU=
X-CM-SenderInfo: 52kx5xhqerqz5rrqw2lrqou0/
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


在 2021/11/23 下午9:54, Andrew Lunn 写道:
>>>> Hi Andrew,
>>>>
>>>>       Use default mdio configure, After module compilation, mdio alias configure
>>>> is following and it doesn't match
>>>>
>>>>       the match phy dev(mdio dev)  uevent, because the mdio alias configure
>>>> "0000000101000001000011111001????"  include "?" and
>>> A PHY ID generally break up into 3 parts.
>>>
>>> The OUI of the manufacture.
>>> The device.
>>> The revision
>>>
>>> The ? means these bits don't matter. Those correspond to the
>>> revision. Generally, a driver can driver any revision of the PHY,
>>> which is why those bits don't matter.
>>>
>>> So when a driver probes with the id 00000001010000010000111110010110
>>> we expect user space to find the best match, performing wildcard
>>> expansion. So the ? will match anything.
>>>
>>> Since this is worked for a long time, do you have an example where it
>>> is broken? If so, which PHY driver? If it is broken, no driver is
>>> loaded, or the wrong driver is loaded, i expect it is a bug in a
>>> specific driver. And we should fix that bug in the specific driver.
>>>
>>>        Andrew
>> Hi Andrew,
>>
>> The string like "0000000101000001000011111001????" dont't match any mdio driver, and i said it include "? that "?" doesn't match any driver, in addition that include Binary digit
>> like "0000000101000001000011111001", that binary digit doesn't match any driver, that should use Hexadecimal for phy id, and I test on some platform, not only a platform, it isn't some
>> specifi driver issue, it is gerneral issue. please you note.  that phy driver match phy device must use whole string "MODALIAS=xxxyyzz", not partial match.
> Please give a concrete example. Show us udev logs of it not working,
> it failing to find a match.
>
> 	Andrew

Hi Andrew,


     I don't get udev log, but I can find that phy module wether be load 
by lsmod ways,  and you can try

     it in any a phy deice and in any arch platform.   in addition,  I 
will send v2 version patch that need consider

     some phy device doesn't follow IEEE802.3 protocol strictly and 
doesn't read phy id from phy register successfully,

     please review.


Brs,

Yinbo Zhu.



