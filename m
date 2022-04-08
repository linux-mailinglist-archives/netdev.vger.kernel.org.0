Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A6E044F8F44
	for <lists+netdev@lfdr.de>; Fri,  8 Apr 2022 09:12:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229559AbiDHHOX convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 8 Apr 2022 03:14:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229513AbiDHHOW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Apr 2022 03:14:22 -0400
X-Greylist: delayed 566 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Fri, 08 Apr 2022 00:12:18 PDT
Received: from mxout014.mail.hostpoint.ch (mxout014.mail.hostpoint.ch [IPv6:2a00:d70:0:e::314])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8ECE20A385
        for <netdev@vger.kernel.org>; Fri,  8 Apr 2022 00:12:18 -0700 (PDT)
Received: from [10.0.2.46] (helo=asmtp013.mail.hostpoint.ch)
        by mxout014.mail.hostpoint.ch with esmtps  (TLS1.3) tls TLS_AES_256_GCM_SHA384
        (Exim 4.94.2 (FreeBSD))
        (envelope-from <thomas@kupper.org>)
        id 1ncidt-0005ir-SE; Fri, 08 Apr 2022 09:02:49 +0200
Received: from [82.197.179.206] (helo=jeffs-rmbp.hsh.patient0.xyz)
        by asmtp013.mail.hostpoint.ch with esmtpa (Exim 4.95 (FreeBSD))
        (envelope-from <thomas@kupper.org>)
        id 1ncidt-0007q1-MB;
        Fri, 08 Apr 2022 09:02:49 +0200
X-Authenticated-Sender-Id: thomas@kupper.org
Subject: Re: AMD XGBE "phy irq request failed" kernel v5.17-rc2 on V1500B
 based board
To:     Shyam Sundar S K <Shyam-sundar.S-k@amd.com>
Cc:     Tom Lendacky <thomas.lendacky@amd.com>, netdev@vger.kernel.org
References: <45b7130e-0f39-cb54-f6a8-3ea2f602d65e@kupper.org>
 <c3e8cbdc-d3f9-d258-fcb6-761a5c6c89ed@amd.com>
 <68185240-9924-a729-7f41-0c2dd22072ce@kupper.org>
 <e1eafc13-4941-dcc8-a2d3-7f35510d0efc@amd.com>
 <06c0ae60-5f84-c749-a485-a52201a1152b@amd.com>
 <603a03f4-2765-c8e7-085c-808f67b42fa9@kupper.org>
 <14d2dc72-4454-3493-20e7-ab3539854e37@amd.com>
 <26d95ad3-0190-857b-8eb2-a065bf370ddc@kupper.org>
 <cee9f8ff-7611-a09f-a8fe-58bcf7143639@amd.com>
 <57cf8ba6-98a7-5d4a-76d0-4b533da06819@amd.com>
 <0371d81e-6cc7-4841-47dc-d7b50d1a5c9b@amd.com>
From:   Thomas Kupper <thomas@kupper.org>
Autocrypt: addr=thomas@kupper.org; keydata=
 mQGiBE5Q8TYRBAC8Lhkq+EVXqfx0trczkTLEgP+4+ZStk6i4HyDj/xzHaY0wHrOP3jF+NuFZ
 WlhSVab0LjXdT/r9n3voQ18CDRy9uPEmDrx9uMSK5zdPIZMMeeFJmdFrvmKPTVUu44i4fSc3
 LdclicSDpLEBaSxYrKmL07HmD2pp6CIIxDq1Q+q1vwCg4YeXIY66WUWYZCpxbdofqpX1yXUD
 /3RFtGGMqyPIzGVbuvRdv4IiBikYkbHB40AteWyrOica9sleEeWobPwuXiQn7b/EO+XSeEjc
 IrY+XUxSzpBaJqQeg6XvRkViMe0rKYhGJsmhxtm3J0FX9hft3A2t8ySY0rHTqOg0G06QI9l3
 pJ8L54U2mEsY1YiwLiLNzh+wXTYOBACsrmRBkDmV+3e1T4P2mYXHsDQrRohO5vjXQoAHyLIA
 hVNkT/phV3VBTA+TcKmEbdjHkIsCW4G164m5rE6uaABaVS0UFF1gzxMRWD8ifIP/yBM60THj
 EtFB5cmTKrAoTVyiRlA4JRTSp7Qi+7VkgR6auO2lN/2+OLUjIcLL5HzysrQhVGhvbWFzIEt1
 cHBlciA8dGhvbWFzQGt1cHBlci5vcmc+iHcEExECADcCGyMGCwkIBwMCBBUCCAMEFgIDAQIe
 AQIXgBYhBESxWB9l55+zHfb85Bl75joxn+H7BQJeU91EAAoJEBl75joxn+H7yN8An2rTPo7F
 QOqJ+pNaVr0W6grPnOqRAKC62QKLptTDnXIx8W88qvI6TZ+LFrkCDQROUPE2EAgAn8LqC/Zr
 F6wCQBkQ7e2fNZXAlEOJCGEMMdydTH9W8TUvbu4y9ZqYC3OrM60G7eTgxOH6H967ENHbr9OC
 cH9UYVTQH2ntajj5lglVrmkYUbou2NDpv1F6aQs1RuIHaeIzrQ7vpBjO/05lywI0hmFVtF3W
 808a2r1wNsXkBvSsDLWoLH89FoIgyNGRZ60GBJv9Z9lkSppnBPcdze+WyXoXXzVQleyIN7Cv
 23kOLl9/FPI0MOXzEevrzJ49dHJZALh98mOtIL8YzpM/kp0EF2J3zb6jdQOBSFcQ9hLGoZ70
 33K4cFgU6MBNyGKyzRi6u0Fg8ix/3YCs1KoFl46NIhDbAwADBQf/V/voyBkRo3EZC1uFUu/T
 s0pTbe4ZqMeUGny8B2Hnst+YkGyjd4VS1ozREYXAnFt7w7cI0M5xNJw3ep9hC1QnMhcSrR/7
 Q5IDneFDcrrYiXifehRvlRsqRvbscY4UY9JoFW/lD3OxTgGQ4sKXUOOL1PRHmyrGZMx1jDHD
 qa3NkHuQEMN3zfSOlLMgBuuwUzc3HcMcpyjc1AWRyoa/yMa1gYOUyMMpF2rP/SVgX9mBrOl8
 fTHG4oZ9i4dCOvt3KQlY9XKlz7zEXVi8YfMk3f2v1yV8ofNjTiPcjb+EhLdySqzvbJCwm8/7
 yc9VOntZU2qZM8iMpuUC6SYVkN1XTDXU0IhgBBgRAgAgAhsMFiEERLFYH2Xnn7Md9vzkGXvm
 OjGf4fsFAl5T6kAACgkQGXvmOjGf4ftTUQCfYZRcWffw98s7Pyn3eS7Lg+/OUzoAn0fylB57
 c+yOSFuuz3ylO/keOQ4b
Message-ID: <bd91301a-3d89-b980-0824-8ab51fcff34a@kupper.org>
Date:   Fri, 8 Apr 2022 09:02:48 +0200
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:52.0)
 Gecko/20100101 PostboxApp/7.0.54
MIME-Version: 1.0
In-Reply-To: <0371d81e-6cc7-4841-47dc-d7b50d1a5c9b@amd.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Content-Language: en-US
X-Spam-Status: No, score=-5.5 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



Shyam Sundar S K wrote on 14.02.22 05:23:
>
> On 2/11/2022 9:18 PM, Tom Lendacky wrote:
>> On 2/11/22 03:49, Shyam Sundar S K wrote:
>>> On 2/11/2022 3:03 PM, Thomas Kupper wrote:
>>>> Am 08.02.22 um 17:24 schrieb Tom Lendacky:
>>>>> On 2/7/22 11:59, Thomas Kupper wrote:
>>>>>> Am 07.02.22 um 16:19 schrieb Shyam Sundar S K:
>>>>>>> On 2/7/2022 8:02 PM, Tom Lendacky wrote:
>>>>>>>> On 2/5/22 12:14, Thomas Kupper wrote:
>>>>>>>>> Am 05.02.22 um 16:51 schrieb Tom Lendacky:
>>>>>>>>>> On 2/5/22 04:06, Thomas Kupper wrote:
>>>> Thanks Tom, I now got time to update to 5.17-rc3 and add the 'debug'
>>>> module parameter. I assume that parameter works with the non-debug
>>>> kernel? I don't really see any new messages related to the amd-xgbe
>>>> driver:
>>>>
>>>> dmesg right after boot:
>>>>
>>>> [    0.000000] Linux version 5.17.0-rc3-tk (jane@m920q-ubu21) (gcc
>>>> (Ubuntu 11.2.0-7ubuntu2) 11.2.0, GNU ld (GNU Binutils for Ubuntu) 2.37)
>>>> #12 SMP PREEMPT Tue Feb 8 19:52:19 CET 2022
>>>> [    0.000000] Command line: BOOT_IMAGE=/boot/vmlinuz-5.17.0-rc3-tk
>>>> root=UUID=8e462830-8ba0-4061-8f23-6f29ce751792 ro console=tty0
>>>> console=ttyS0,115200n8 amd_xgbe.dyndbg=+p amd_xgbe.debug=0x37
>>>> ...
>>>> [    5.275730] amd-xgbe 0000:06:00.1 eth0: net device enabled
>>>> [    5.277766] amd-xgbe 0000:06:00.2 eth1: net device enabled
>>>> [    5.665315] amd-xgbe 0000:06:00.2 enp6s0f2: renamed from eth1
>>>> [    5.696665] amd-xgbe 0000:06:00.1 enp6s0f1: renamed from eth0
>> Hmmm... that's strange. There should have been some messages issued by the
>> xgbe-phy-v2.c file from the xgbe_phy_init() routine.
>>
>> Thomas, if you're up for a bit of kernel hacking, can you remove the
>> "if (netif_msg_probe(pdata)) {" that wrap the dev_dbg() calls in the
>> xgbe-phy-v2.c file? There are 5 locations.
>>
>>>> dmesg right after 'ifconfig enp6s0f2 up'
>>>>
>>>> [   88.843454] amd_xgbe:xgbe_alloc_channels: amd-xgbe 0000:06:00.2
>>>> enp6s0f2: channel-0: cpu=0, node=0
>>
>>> Can you add this change and see if it solves the problem?
>>>
>>> https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git/commit/?id=68c2d6af1f1e
>>>
>> I would imagine that patch has nothing to do with the real issue. Given
>> the previous messages of:
> Agreed. I guessed the earlier problem manifested after the driver
> removal. However, this one still appears like a BIOS misconfiguration.
>
>>> [  648.038655] genirq: Flags mismatch irq 59. 00000000 (enp6s0f2-pcs)
>>> vs. 00000000 (enp6s0f2-pcs)
>>> [  648.048303] amd-xgbe 0000:06:00.2 enp6s0f2: phy irq request failed
>> There should be no reason for not being able to obtain the IRQ.
>>
>> I suspect it is something in the BIOS setup that is not correct and thus
>> the Linux driver is not working properly because of bad input/setup from
>> the BIOS. This was probably worked around by the driver used in the
>> OPNsense DEC740 firewall.
>>
>> Shyam has worked more closely with the embedded area of this device, I'll
>> let him take it from here.
> I shall connect Thomas to BIOS folks and take it forward from there.

Hey Shyam and Tom,

After almost two months I unfortunately haven't heard of anyone from AMD
about a possible fix. And neither in the linux kernel nor the linux
netdev repo are any new commit related to the amd-xgbe driver.
Is there a way that I could get an answer? If you can't or won't do any
fix that's ok it just helps me if I know where I stand on this issue.

/Thomas
> Thanks,
> Shyam


