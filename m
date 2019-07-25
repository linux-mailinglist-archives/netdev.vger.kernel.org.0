Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D9876742E9
	for <lists+netdev@lfdr.de>; Thu, 25 Jul 2019 03:40:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387895AbfGYBkl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jul 2019 21:40:41 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:35876 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726808AbfGYBkl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 24 Jul 2019 21:40:41 -0400
Received: from DGGEMS405-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 8A9CB1451149D3AC8C95;
        Thu, 25 Jul 2019 09:40:38 +0800 (CST)
Received: from [127.0.0.1] (10.133.213.239) by DGGEMS405-HUB.china.huawei.com
 (10.3.19.205) with Microsoft SMTP Server id 14.3.439.0; Thu, 25 Jul 2019
 09:40:30 +0800
Subject: Re: [PATCH] carl9170: remove set but not used variable 'udev'
To:     Christian Lamparter <chunkeey@gmail.com>
References: <20190724015411.66525-1-yuehaibing@huawei.com>
 <CAAd0S9BvTfRyUVkQzcczyNkU_oeU5hNdK3KVQzLsU21b4JGNTQ@mail.gmail.com>
CC:     Kalle Valo <kvalo@codeaurora.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>,
        <kernel-janitors@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Hulk Robot <hulkci@huawei.com>
From:   Yuehaibing <yuehaibing@huawei.com>
Message-ID: <1cfbfe67-e931-029b-1836-a6b796283c2c@huawei.com>
Date:   Thu, 25 Jul 2019 09:40:29 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.2.0
MIME-Version: 1.0
In-Reply-To: <CAAd0S9BvTfRyUVkQzcczyNkU_oeU5hNdK3KVQzLsU21b4JGNTQ@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.133.213.239]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2019/7/25 3:42, Christian Lamparter wrote:
> On Wed, Jul 24, 2019 at 3:48 AM YueHaibing <yuehaibing@huawei.com> wrote:
>>
>> Fixes gcc '-Wunused-but-set-variable' warning:
>>
>> drivers/net/wireless/ath/carl9170/usb.c: In function 'carl9170_usb_disconnect':
>> drivers/net/wireless/ath/carl9170/usb.c:1110:21: warning:
>>  variable 'udev' set but not used [-Wunused-but-set-variable]
>>
>> It is not used, so can be removed.
>>
>> Reported-by: Hulk Robot <hulkci@huawei.com>
>> Signed-off-by: YueHaibing <yuehaibing@huawei.com>
>> ---
> Isn't this the same patch you sent earlier:
> 
> https://patchwork.kernel.org/patch/11027909/
> 
>>From what I can tell, it's the same but with an extra [-next], I
> remember that I've acked that one
> but your patch now does not have it? Is this an oversight, because I'm
> the maintainer for this
> driver. So, in my opinion at least the "ack" should have some value
> and shouldn't be "ignored".
> 
> Look, from what I know, Kalle is not ignoring you, It's just that
> carl9170 is no longer top priority.
> So please be patient. As long as its queued in the patchwork it will
> get considered.

Thank you for reminder. I forget the previous patch，and our CI robot
report it again, So I do it again, sorry for confusion.

Just pls drop this and use previous one.

> 
> Cheers,
> Christian
> 
>>  drivers/net/wireless/ath/carl9170/usb.c | 2 --
>>  1 file changed, 2 deletions(-)
>>
>> diff --git a/drivers/net/wireless/ath/carl9170/usb.c b/drivers/net/wireless/ath/carl9170/usb.c
>> index 99f1897a775d..486957a04bd1 100644
>> --- a/drivers/net/wireless/ath/carl9170/usb.c
>> +++ b/drivers/net/wireless/ath/carl9170/usb.c
>> @@ -1107,12 +1107,10 @@ static int carl9170_usb_probe(struct usb_interface *intf,
>>  static void carl9170_usb_disconnect(struct usb_interface *intf)
>>  {
>>         struct ar9170 *ar = usb_get_intfdata(intf);
>> -       struct usb_device *udev;
>>
>>         if (WARN_ON(!ar))
>>                 return;
>>
>> -       udev = ar->udev;
>>         wait_for_completion(&ar->fw_load_wait);
>>
>>         if (IS_INITIALIZED(ar)) {
>>
>>
>>
> 
> .
> 

