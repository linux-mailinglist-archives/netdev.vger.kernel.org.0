Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 512E5462EC2
	for <lists+netdev@lfdr.de>; Tue, 30 Nov 2021 09:45:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239686AbhK3Isq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Nov 2021 03:48:46 -0500
Received: from mail.loongson.cn ([114.242.206.163]:45244 "EHLO loongson.cn"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S239664AbhK3Isq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 30 Nov 2021 03:48:46 -0500
Received: from [10.180.13.93] (unknown [10.180.13.93])
        by mail.loongson.cn (Coremail) with SMTP id AQAAf9AxismT5KVh97YBAA--.3687S2;
        Tue, 30 Nov 2021 16:45:14 +0800 (CST)
Subject: Re: [PATCH v2 1/2] modpost: file2alias: fixup mdio alias garbled code
 in modules.alias
To:     Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Michal Marek <michal.lkml@markovi.net>,
        Nick Desaulniers <ndesaulniers@google.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-kbuild@vger.kernel.org
References: <1637919957-21635-1-git-send-email-zhuyinbo@loongson.cn>
 <c6d37ae0-9ccb-a527-4f55-e96972813a53@gmail.com>
From:   zhuyinbo <zhuyinbo@loongson.cn>
Cc:     Russell King <linux@armlinux.org.uk>, Andrew Lunn <andrew@lunn.ch>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-kbuild@vger.kernel.org, zhuyinbo@loongson.cn
Message-ID: <a569842b-a1e9-0ace-67a4-96d4d0429fbd@loongson.cn>
Date:   Tue, 30 Nov 2021 16:45:07 +0800
User-Agent: Mozilla/5.0 (X11; Linux mips64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <c6d37ae0-9ccb-a527-4f55-e96972813a53@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-CM-TRANSID: AQAAf9AxismT5KVh97YBAA--.3687S2
X-Coremail-Antispam: 1UD129KBjvJXoWxGw17XF1xGFy8Jr1xZF17trb_yoW5Xr4UpF
        W3GFy5KFWkGF429a1F93WUWryUXw47Kr95Wa1jqF1vgF9Iyry0vr4SkF4Sga4kZFZ2va40
        g3W5uFyDur4DZrDanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUU9K14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
        rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
        1l84ACjcxK6xIIjxv20xvE14v26r4j6ryUM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26F4j
        6r4UJwA2z4x0Y4vEx4A2jsIE14v26F4UJVW0owA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Gc
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


在 2021/11/26 下午6:21, Heiner Kallweit 写道:
> On 26.11.2021 10:45, Yinbo Zhu wrote:
>> After module compilation, module alias mechanism will generate a ugly
>> mdio modules alias configure if ethernet phy was selected, this patch
>> is to fixup mdio alias garbled code.
>>
>> In addition, that ugly alias configure will cause ethernet phy module
>> doens't match udev, phy module auto-load is fail, but add this patch
>> that it is well mdio driver alias configure match phy device uevent.
>>
> I think Andrew asked you for an example already.
> For which PHY's the driver isn't auto-loaded?

I test that use marvell phy, another colleague use motorcomm phy,  which 
auto load function was all fail.

and I need to emphasize one thing that the mdio auto load issue is 
generally issue, not special phy issue.


>
> In addition your commit descriptions are hard to read, especially the
> one for patch 2. Could you please try to change them to proper English?
> Not being a native speaker myself ..
I had changed commit information as v3 version, please you check.
>> Signed-off-by: Yinbo Zhu <zhuyinbo@loongson.cn>
>> ---
>> Change in v2:
>> 		Add a MDIO_ANY_ID for considering some special phy device
>> 		which phy id doesn't be read from phy register.
>>
>>
>>   include/linux/mod_devicetable.h |  2 ++
>>   scripts/mod/file2alias.c        | 17 +----------------
>>   2 files changed, 3 insertions(+), 16 deletions(-)
>>
>> diff --git a/include/linux/mod_devicetable.h b/include/linux/mod_devicetable.h
>> index ae2e75d..7bd23bf 100644
>> --- a/include/linux/mod_devicetable.h
>> +++ b/include/linux/mod_devicetable.h
>> @@ -595,6 +595,8 @@ struct platform_device_id {
>>   	kernel_ulong_t driver_data;
>>   };
>>   
>> +#define MDIO_ANY_ID (~0)
>> +
>>   #define MDIO_NAME_SIZE		32
>>   #define MDIO_MODULE_PREFIX	"mdio:"
>>   
>> diff --git a/scripts/mod/file2alias.c b/scripts/mod/file2alias.c
>> index 49aba86..63f3149 100644
>> --- a/scripts/mod/file2alias.c
>> +++ b/scripts/mod/file2alias.c
>> @@ -1027,24 +1027,9 @@ static int do_platform_entry(const char *filename,
>>   static int do_mdio_entry(const char *filename,
>>   			 void *symval, char *alias)
>>   {
>> -	int i;
>>   	DEF_FIELD(symval, mdio_device_id, phy_id);
>> -	DEF_FIELD(symval, mdio_device_id, phy_id_mask);
>> -
>>   	alias += sprintf(alias, MDIO_MODULE_PREFIX);
>> -
>> -	for (i = 0; i < 32; i++) {
>> -		if (!((phy_id_mask >> (31-i)) & 1))
>> -			*(alias++) = '?';
>> -		else if ((phy_id >> (31-i)) & 1)
>> -			*(alias++) = '1';
>> -		else
>> -			*(alias++) = '0';
>> -	}
>> -
>> -	/* Terminate the string */
>> -	*alias = 0;
>> -
>> +	ADD(alias, "p", phy_id != MDIO_ANY_ID, phy_id);
>>   	return 1;
>>   }
>>   
>>

