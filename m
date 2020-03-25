Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 154A1192AC4
	for <lists+netdev@lfdr.de>; Wed, 25 Mar 2020 15:08:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727604AbgCYOH5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Mar 2020 10:07:57 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:56001 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726074AbgCYOH5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Mar 2020 10:07:57 -0400
Received: from [222.129.50.174] (helo=localhost.localdomain)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <aaron.ma@canonical.com>)
        id 1jH6hD-0003zg-Tx; Wed, 25 Mar 2020 14:07:53 +0000
Subject: Re: [PATCH] e1000e: bump up timeout to wait when ME un-configure ULP
 mode
To:     "Neftin, Sasha" <sasha.neftin@intel.com>,
        Kai-Heng Feng <kai.heng.feng@canonical.com>
Cc:     "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>,
        David Miller <davem@davemloft.net>,
        "moderated list:INTEL ETHERNET DRIVERS" 
        <intel-wired-lan@lists.osuosl.org>,
        "open list:NETWORKING DRIVERS" <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        "Lifshits, Vitaly" <vitaly.lifshits@intel.com>, rex.tsai@intel.com
References: <20200323191639.48826-1-aaron.ma@canonical.com>
 <EC4F7F0B-90F8-4325-B170-84C65D8BBBB8@canonical.com>
 <2c765c59-556e-266b-4d0d-a4602db94476@intel.com>
 <899895bc-fb88-a97d-a629-b514ceda296d@canonical.com>
 <750ad0ad-816a-5896-de2f-7e034d2a2508@intel.com>
From:   Aaron Ma <aaron.ma@canonical.com>
Autocrypt: addr=aaron.ma@canonical.com; prefer-encrypt=mutual; keydata=
 mQENBFffeLkBCACi4eE4dPsgWN6B9UDOVcAvb5QgU/hRG6yS0I1lGKQv4KA+bke0c5g8clbO
 9gIlIl2bityfA9NzBsDik4Iei3AxMbFyxv9keMwcOFQBIOZF0P3f05qjxftF8P+yp9QTV4hp
 BkFzsXzWRgXN3r8hU8wqZybepF4B1C83sm2kQ5A5N0AUGbZli9i2G+/VscG9sWfLy8T7f4YW
 MjmlijCjoV6k29vsmTWQPZ7EApNpvR5BnZQPmQWzkkr0lNXlsKcyLgefQtlwg6drK4fe4wz0
 ouBIHJEiXE1LWK1hUzkCUASra4WRwKk1Mv/NLLE/aJRqEvF2ukt3uVuM77RWfl7/H/v5ABEB
 AAG0IUFhcm9uIE1hIDxhYXJvbi5tYUBjYW5vbmljYWwuY29tPokBNwQTAQgAIQUCV994uQIb
 AwULCQgHAgYVCAkKCwIEFgIDAQIeAQIXgAAKCRDNxCzQfVU6ntJ9B/9aVy0+RkLqF9QpLmw+
 LAf1m3Fd+4ZarPTerqDqkLla3ekYhbrEtlI1mYuB5f+gtrIjmcW27gacHdslKB9YwaL8B4ZB
 GJKhcrntLg4YPzYUnXZkHHTv1hMw7fBYw82cBT+EbG0Djh6Po6Ihqyr3auHhfFcp1PZH4Mtq
 6hN5KaDZzF/go+tRF5e4bn61Nhdue7mrhFSlfkzLG2ehHWmRV+S91ksH81YDFnazK0sRINBx
 V1S8ts3WJ2f1AbgmnDlbK3c/AfI5YxnIHn/x2ZdXj1P/wn7DgZHmpMy5DMuk0gN34NLUPLA/
 cHeKoBAF8emugljiKecKBpMTLe8FrVOxbkrauQENBFffeLkBCACweKP3Wx+gK81+rOUpuQ00
 sCyKzdtMuXXJ7oL4GzYHbLfJq+F+UHpQbytVGTn3R5+Y61v41g2zTYZooaC+Hs1+ixf+buG2
 +2LZjPSELWPNzH9lsKNlCcEvu1XhyyHkBDbnFFHWlUlql3nSXMo//dOTG/XGKaEaZUxjCLUC
 8ehLc16DJDvdXsPwWhHrCH/4k92F6qQ14QigBMsl75jDTDJMEYgRYEBT1D/bwxdIeoN1BfIG
 mYgf059RrWax4SMiJtVDSUuDOpdwoEcZ0FWesRfbFrM+k/XKiIbjMZSvLunA4FIsOdWYOob4
 Hh0rsm1G+fBLYtT+bE26OWpQ/lSn4TdhABEBAAGJAR8EGAEIAAkFAlffeLkCGwwACgkQzcQs
 0H1VOp6p5Af/ap5EVuP1AhFdPD3pXLNrUUt72W3cuAOjXyss43qFC2YRjGfktrizsDjQU46g
 VKoD6EW9XUPgvYM+k8BJEoXDLhHWnCnMKlbHP3OImxzLRhF4kdlnLicz1zKRcessQatRpJgG
 NIiD+eFyh0CZcWBO1BB5rWikjO/idicHao2stFdaBmIeXvhT9Xp6XNFEmzOmfHps+kKpWshY
 9LDAU0ERBNsW4bekOCa/QxfqcbZYRjrVQvya0EhrPhq0bBpzkIL/7QSBMcdv6IajTlHnLARF
 nAIofCEKeEl7+ksiRapL5Nykcbt4dldE3sQWxIybC94SZ4inENKw6I8RNpigWm0R5w==
Message-ID: <2b817a13-9fd8-4181-fed5-e55f7b4365ca@canonical.com>
Date:   Wed, 25 Mar 2020 22:07:36 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <750ad0ad-816a-5896-de2f-7e034d2a2508@intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/25/20 9:58 PM, Neftin, Sasha wrote:
> On 3/25/2020 08:43, Aaron Ma wrote:
>>
>>
>> On 3/25/20 2:36 PM, Neftin, Sasha wrote:
>>> On 3/25/2020 06:17, Kai-Heng Feng wrote:
>>>> Hi Aaron,
>>>>
>>>>> On Mar 24, 2020, at 03:16, Aaron Ma <aaron.ma@canonical.com> wrote:
>>>>>
>>>>> ME takes 2+ seconds to un-configure ULP mode done after resume
>>>>> from s2idle on some ThinkPad laptops.
>>>>> Without enough wait, reset and re-init will fail with error.
>>>>
>>>> Thanks, this patch solves the issue. We can drop the DMI quirk in
>>>> favor of this patch.
>>>>
>>>>>
>>>>> Fixes: f15bb6dde738cc8fa0 ("e1000e: Add support for S0ix")
>>>>> BugLink: https://bugs.launchpad.net/bugs/1865570
>>>>> Signed-off-by: Aaron Ma <aaron.ma@canonical.com>
>>>>> ---
>>>>> drivers/net/ethernet/intel/e1000e/ich8lan.c | 4 ++--
>>>>> 1 file changed, 2 insertions(+), 2 deletions(-)
>>>>>
>>>>> diff --git a/drivers/net/ethernet/intel/e1000e/ich8lan.c
>>>>> b/drivers/net/ethernet/intel/e1000e/ich8lan.c
>>>>> index b4135c50e905..147b15a2f8b3 100644
>>>>> --- a/drivers/net/ethernet/intel/e1000e/ich8lan.c
>>>>> +++ b/drivers/net/ethernet/intel/e1000e/ich8lan.c
>>>>> @@ -1240,9 +1240,9 @@ static s32 e1000_disable_ulp_lpt_lp(struct
>>>>> e1000_hw *hw, bool force)
>>>>>              ew32(H2ME, mac_reg);
>>>>>          }
>>>>>
>>>>> -        /* Poll up to 300msec for ME to clear ULP_CFG_DONE. */
>>>>> +        /* Poll up to 2.5sec for ME to clear ULP_CFG_DONE. */
>>>>>          while (er32(FWSM) & E1000_FWSM_ULP_CFG_DONE) {
>>>>> -            if (i++ == 30) {
>>>>> +            if (i++ == 250) {
>>>>>                  ret_val = -E1000_ERR_PHY;
>>>>>                  goto out;
>>>>>              }
>>>>
>>>> The return value was not caught by the caller, so the error ends up
>>>> unnoticed.
>>>> Maybe let the caller check the return value of
>>>> e1000_disable_ulp_lpt_lp()?
>>>>
>>>> Kai-Heng
>>> Hello Kai-Heng and Aaron,
>>> I a bit confused. In our previous conversation you told ME not running.
>>> let me shimming in. Increasing delay won't be solve the problem and just
>>> mask it. We need to understand why ME take too much time. What is
>>> problem with this specific system?
>>> So, basically no ME system should works for you.
>>
>> Some laptops ME work that's why only reproduce issue on some laptops.
>> In this issue i219 is controlled by ME.
>>
> Who can explain - why ME required too much time on this system?
> Probably need work with ME/BIOS vendor and understand it.
> Delay will just mask the real problem - we need to find root cause.

IMHO, it should be ME check the link status when link disconnected,
that's why Poll up to 5 seconds for Cable Disconnected indication when
enable ULP.

The reason is same for both disable/enable ULP mode.

I agree to ask ME to check it too.

Regards,
Aaron

>> Quirk is only for 1 model type. But issue is reproduced by more models.
>> So it won't work.
>>
>> Regard,
>> Aaron
>>
>>>
>>> Meanwhile I prefer keep DMI quirk.
>>> Thanks,
>>> Sasha
>>>>
>>>>> -- 
>>>>> 2.17.1
>>>>>
>>>>
>>>
> 
