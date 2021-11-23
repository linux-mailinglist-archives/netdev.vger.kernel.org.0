Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E1D0F459B57
	for <lists+netdev@lfdr.de>; Tue, 23 Nov 2021 05:58:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229728AbhKWFBu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Nov 2021 00:01:50 -0500
Received: from mail.loongson.cn ([114.242.206.163]:41582 "EHLO loongson.cn"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229468AbhKWFBu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 23 Nov 2021 00:01:50 -0500
Received: from [10.180.13.93] (unknown [10.180.13.93])
        by mail.loongson.cn (Coremail) with SMTP id AQAAf9Dx79P0dJxhZH0AAA--.2750S2;
        Tue, 23 Nov 2021 12:58:29 +0800 (CST)
Subject: Re: [PATCH v1 1/2] modpost: file2alias: fixup mdio alias garbled code
 in modules.alias
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>, linux@armlinux.org.uk,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-kbuild@vger.kernel.org, zhuyinbo@loongson.cn,
        davem@davemloft.net, kuba@kernel.org, masahiroy@kernel.org,
        michal.lkml@markovi.net, ndesaulniers@google.com,
        netdev@vger.kernel.org, linux-kbuild@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <1637583298-20321-1-git-send-email-zhuyinbo@loongson.cn>
 <YZukJBsf3qMOOK+Y@lunn.ch> <5b561d5f-d7ac-4d90-e69e-5a80a73929e0@loongson.cn>
 <YZxqLi7/JDN9mQoK@lunn.ch>
From:   zhuyinbo <zhuyinbo@loongson.cn>
Message-ID: <0a9e959a-bcd1-f649-b4cd-bd0f65fc71aa@loongson.cn>
Date:   Tue, 23 Nov 2021 12:58:29 +0800
User-Agent: Mozilla/5.0 (X11; Linux mips64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <YZxqLi7/JDN9mQoK@lunn.ch>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-CM-TRANSID: AQAAf9Dx79P0dJxhZH0AAA--.2750S2
X-Coremail-Antispam: 1UD129KBjvJXoW7CFy8KFyDuF4fKw1fCF4Uurg_yoW5JrW7pF
        43tFyFkFWkXr4akwsa9rykua4jk392kF4Yg345GrnY9398Zr1Yyr48KrW7K3srWrn7Jw1j
        gryagFyv9F4kZ3DanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUU9K14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
        rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
        1l84ACjcxK6xIIjxv20xvE14v26r1j6r1xM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4j
        6F4UM28EF7xvwVC2z280aVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Gc
        CE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E
        2Ix0cI8IcVAFwI0_Jr0_Jr4lYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJV
        W8JwACjcxG0xvEwIxGrwACjI8F5VA0II8E6IAqYI8I648v4I1lFIxGxcIEc7CjxVA2Y2ka
        0xkIwI1lc7I2V7IY0VAS07AlzVAYIcxG8wCY02Avz4vE-syl42xK82IYc2Ij64vIr41l4I
        8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8GjcxK67AK
        xVWUGVWUWwC2zVAF1VAY17CE14v26r1q6r43MIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcV
        AFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r4j6F4UMIIF0xvE42xK8VAvwI8I
        cIk0rVWrJr0_WFyUJwCI42IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I0E14
        v26r4j6r4UJbIYCTnIWIevJa73UjIFyTuYvjfUoOJ5UUUUU
X-CM-SenderInfo: 52kx5xhqerqz5rrqw2lrqou0/
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


在 2021/11/23 下午12:12, Andrew Lunn 写道:
> On Tue, Nov 23, 2021 at 09:33:03AM +0800, zhuyinbo wrote:
>> 在 2021/11/22 下午10:07, Andrew Lunn 写道:
>>
>>      On Mon, Nov 22, 2021 at 08:14:57PM +0800, Yinbo Zhu wrote:
>>
>>          After module compilation, module alias mechanism will generate a ugly
>>          mdio modules alias configure if ethernet phy was selected, this patch
>>          is to fixup mdio alias garbled code.
>>
>>          In addition, that ugly alias configure will cause ethernet phy module
>>          doens't match udev, phy module auto-load is fail, but add this patch
>>          that it is well mdio driver alias configure match phy device uevent.
>>
>>      What PHY do you have problems with? What is the PHY id and which
>>      driver should be loaded.
>>
>>      This code has existed a long time, so suddenly saying it is wrong and
>>      changing it needs a good explanation why it is wrong. Being ugly is
>>      not a good reason.
>>
>>          Andrew
>>
>> Hi Andrew,
>>
>>      Use default mdio configure, After module compilation, mdio alias configure
>> is following and it doesn't match
>>
>>      the match phy dev(mdio dev)  uevent, because the mdio alias configure
>> "0000000101000001000011111001????"  include "?" and
> A PHY ID generally break up into 3 parts.
>
> The OUI of the manufacture.
> The device.
> The revision
>
> The ? means these bits don't matter. Those correspond to the
> revision. Generally, a driver can driver any revision of the PHY,
> which is why those bits don't matter.
>
> So when a driver probes with the id 00000001010000010000111110010110
> we expect user space to find the best match, performing wildcard
> expansion. So the ? will match anything.
>
> Since this is worked for a long time, do you have an example where it
> is broken? If so, which PHY driver? If it is broken, no driver is
> loaded, or the wrong driver is loaded, i expect it is a bug in a
> specific driver. And we should fix that bug in the specific driver.
>
>       Andrew

Hi Andrew,

The string like "0000000101000001000011111001????" dont't match any mdio driver, and i said it include "? that "?" doesn't match any driver, in addition that include Binary digit
like "0000000101000001000011111001", that binary digit doesn't match any driver, that should use Hexadecimal for phy id, and I test on some platform, not only a platform, it isn't some
specifi driver issue, it is gerneral issue. please you note.  that phy driver match phy device must use whole string "MODALIAS=xxxyyzz", not partial match.

