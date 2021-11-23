Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 95A3D459A0F
	for <lists+netdev@lfdr.de>; Tue, 23 Nov 2021 03:22:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232666AbhKWCZX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Nov 2021 21:25:23 -0500
Received: from mail.loongson.cn ([114.242.206.163]:38164 "EHLO loongson.cn"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232613AbhKWCZW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 22 Nov 2021 21:25:22 -0500
Received: from [10.180.13.93] (unknown [10.180.13.93])
        by mail.loongson.cn (Coremail) with SMTP id AQAAf9Axp+hCUJxhcHQAAA--.2721S2;
        Tue, 23 Nov 2021 10:21:55 +0800 (CST)
Subject: Re: [PATCH v1 1/2] modpost: file2alias: fixup mdio alias garbled code
 in modules.alias
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org,
        zhuyinbo@loongson.cn, "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Michal Marek <michal.lkml@markovi.net>,
        Nick Desaulniers <ndesaulniers@google.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-kbuild@vger.kernel.org
References: <1637583298-20321-1-git-send-email-zhuyinbo@loongson.cn>
 <YZukJBsf3qMOOK+Y@lunn.ch>
From:   zhuyinbo <zhuyinbo@loongson.cn>
Message-ID: <d91dae2f-54db-5f8d-9ecb-56a0c556c694@loongson.cn>
Date:   Tue, 23 Nov 2021 10:21:54 +0800
User-Agent: Mozilla/5.0 (X11; Linux mips64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <YZukJBsf3qMOOK+Y@lunn.ch>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-CM-TRANSID: AQAAf9Axp+hCUJxhcHQAAA--.2721S2
X-Coremail-Antispam: 1UD129KBjvJXoW7Aw17AFy3Ww48JFW7CrW8tFb_yoW8Cr17pF
        WxtryrGrWkXrn3CFs3JryUCFWUA392kw45t34DtFZa93y7ury2vay2grWI93yxZrs2y34j
        gryUWF109FyDZ3DanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUUPF14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
        rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
        1l84ACjcxK6xIIjxv20xvE14v26r4j6ryUM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26F4j
        6r4UJwA2z4x0Y4vEx4A2jsIE14v26r4UJVWxJr1l84ACjcxK6I8E87Iv6xkF7I0E14v26r
        4UJVWxJr1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2Wl
        Yx0E2Ix0cI8IcVAFwI0_Jr0_Jr4lYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbV
        WUJVW8JwACjcxG0xvEwIxGrwACjI8F5VA0II8E6IAqYI8I648v4I1lFIxGxcIEc7CjxVA2
        Y2ka0xkIwI1lc7I2V7IY0VAS07AlzVAYIcxG8wCY1x0262kKe7AKxVW8ZVWrXwCY02Avz4
        vE-syl42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AK
        xVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r1q6r43MIIYrx
        kI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14v2
        6r4j6F4UMIIF0xvE42xK8VAvwI8IcIk0rVWrJr0_WFyUJwCI42IY6I8E87Iv67AKxVWUJV
        W8JwCI42IY6I8E87Iv6xkF7I0E14v26r4j6r4UJbIYCTnIWIevJa73UjIFyTuYvjTRMXdj
        DUUUU
X-CM-SenderInfo: 52kx5xhqerqz5rrqw2lrqou0/
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


在 2021/11/22 下午10:07, Andrew Lunn 写道:
> On Mon, Nov 22, 2021 at 08:14:57PM +0800, Yinbo Zhu wrote:
>> After module compilation, module alias mechanism will generate a ugly
>> mdio modules alias configure if ethernet phy was selected, this patch
>> is to fixup mdio alias garbled code.
>>
>> In addition, that ugly alias configure will cause ethernet phy module
>> doens't match udev, phy module auto-load is fail, but add this patch
>> that it is well mdio driver alias configure match phy device uevent.
> What PHY do you have problems with? What is the PHY id and which
> driver should be loaded.

     about that phy id,  phy dev read it from  PHY Identifier 1 and 
Identifier 2 register, phy driver will call MODULE_DEVICE_TABLE to 
configure

     phy id to mdio_device_id, phy id was used to do a match phy driver 
with phy device.  that phy problems is phy driver was select 'M' then it

     doesn't be auto load.
> This code has existed a long time, so suddenly saying it is wrong and
> changing it needs a good explanation why it is wrong. Being ugly is
> not a good reason.
>
>      Andrew

Hi Andrew,

     Use default mdio configure, After module compilation, mdio alias 
configure is "alias mdio:0000000101000001000011111001???? marvell"

     and it doesn't match  the match phy dev(mdio dev)  uevent, because 
the mdio alias configure "0000000101000001000011111001????"

    include "?" and  "binary number",   as general, uevent it include 
one string or some string that string consist of one character and one 
hexadecimal digit ,

     which uevent is reported by mdio when mdio register a device for 
ethernet phy device, only uevent from phy dev match alias configure from

     phy driver that phy driver will can be auto-load when phy driver 
was selected  'M'.


BRs

Yinbo Zhu.

