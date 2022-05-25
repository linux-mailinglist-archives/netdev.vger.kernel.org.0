Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (unknown [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B4738533CCD
	for <lists+netdev@lfdr.de>; Wed, 25 May 2022 14:40:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243491AbiEYMkf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 May 2022 08:40:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243387AbiEYMkb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 May 2022 08:40:31 -0400
Received: from out30-57.freemail.mail.aliyun.com (out30-57.freemail.mail.aliyun.com [115.124.30.57])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63D7B8D6A0
        for <netdev@vger.kernel.org>; Wed, 25 May 2022 05:40:27 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R111e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04423;MF=gjfang@linux.alibaba.com;NM=1;PH=DS;RN=12;SR=0;TI=SMTPD_---0VENRapy_1653482423;
Received: from 30.18.74.36(mailfrom:gjfang@linux.alibaba.com fp:SMTPD_---0VENRapy_1653482423)
          by smtp.aliyun-inc.com(127.0.0.1);
          Wed, 25 May 2022 20:40:24 +0800
Content-Type: multipart/mixed; boundary="------------G0OvHJqLSL151iPK9V5OIGKA"
Message-ID: <90c70f7f-1f07-4cd7-bb41-0f708114bb80@linux.alibaba.com>
Date:   Wed, 25 May 2022 20:40:22 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.9.1
Subject: Re: packet stuck in qdisc : patch proposal
Content-Language: en-US
To:     Yunsheng Lin <linyunsheng@huawei.com>,
        Vincent Ray <vray@kalrayinc.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Cc:     davem <davem@davemloft.net>,
        =?UTF-8?B?5pa55Zu954Ks?= <guoju.fgj@alibaba-inc.com>,
        kuba <kuba@kernel.org>, netdev <netdev@vger.kernel.org>,
        Samuel Jones <sjones@kalrayinc.com>,
        vladimir oltean <vladimir.oltean@nxp.com>,
        Remy Gauguey <rgauguey@kalrayinc.com>, will <will@kernel.org>,
        Eric Dumazet <edumazet@google.com>
References: <1359936158.10849094.1649854873275.JavaMail.zimbra@kalray.eu>
 <2b827f3b-a9db-e1a7-0dc9-65446e07bc63@linux.alibaba.com>
 <1684598287.15044793.1653314052575.JavaMail.zimbra@kalray.eu>
 <d374b806-1816-574e-ba8b-a750a848a6b3@huawei.com>
 <1758521608.15136543.1653380033771.JavaMail.zimbra@kalray.eu>
 <1675198168.15239468.1653411635290.JavaMail.zimbra@kalray.eu>
 <317a3e67-0956-e9c2-0406-9349844ca612@gmail.com>
 <1140270297.15304639.1653471897630.JavaMail.zimbra@kalray.eu>
 <60d1e5b8-dae0-38ef-4b9d-f6419861fdab@huawei.com>
From:   Guoju Fang <gjfang@linux.alibaba.com>
In-Reply-To: <60d1e5b8-dae0-38ef-4b9d-f6419861fdab@huawei.com>
X-Spam-Status: No, score=-10.0 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is a multi-part message in MIME format.
--------------G0OvHJqLSL151iPK9V5OIGKA
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 2022/5/25 18:45, Yunsheng Lin wrote:
> On 2022/5/25 17:44, Vincent Ray wrote:
>> ----- On May 24, 2022, at 10:17 PM, Eric Dumazet eric.dumazet@gmail.com wrote:
>>
>>> On 5/24/22 10:00, Vincent Ray wrote:
>>>> All,
>>>>
>>>> I confirm Eric's patch works well too, and it's better and clearer than mine.
>>>> So I think we should go for it, and the one from Guoju in addition.
>>>>
>>>> @Eric : I see you are one of the networking maintainers, so I have a few
>>>> questions for you :
>>>>
>>>> a) are you going to take care of these patches directly yourself, or is there
>>>> something Guoju or I should do to promote them ?
>>>
>>> I think this is totally fine you take ownership of the patch, please
>>> send a formal V2.
>>>
>>> Please double check what patchwork had to say about your V1 :
>>>
>>>
>>> https://patchwork.kernel.org/project/netdevbpf/patch/1684598287.15044793.1653314052575.JavaMail.zimbra@kalray.eu/
>>>
>>>
>>> And make sure to address the relevant points
>>
>> OK I will.
>> If you agree, I will take your version of the fix (test_and_set_bit()), keeping the commit message
>> similar to my original one.
>>
>> What about Guoju's patch ?
> 
> @Guoju, please speak up if you want to handle the patch yourself.

Hi Yunsheng, all,

I rewrite the comments of my patch and it looks a little clearer. :)

Thank you.

Best regards,

> 
>> (adding a smp_mb() between the spin_unlock() and test_bit() in qdisc_run_end()).
>> I think it is also necessary though potentially less critical.
>> Do we embed it in the same patch ? or patch series ?
> 
> Guoju's patch fixes the commit a90c57f2cedd, so "patch series"
> seems better if Guoju is not speaking up to handle the patch himself.
> 
> 
>>
>> @Guoju : have you submitted it for integration ?
>>
>>
>>> The most important one is the lack of 'Signed-off-by:' tag, of course.
>>>
>>>
>>>> b) Can we expect to see them land in the mainline soon ?
>>>
>>> If your v2 submission is correct, it can be merged this week ;)
>>>
>>>
>>>>
>>>> c) Will they be backported to previous versions of the kernel ? Which ones ?
>>>
>>> You simply can include a proper Fixes: tag, so that stable teams can
>>> backport
>>>
>>> the patch to all affected kernel versions.
>>>
>>
>> Here things get a little complicated in my head ;-)
>> As explained, I think this mechanism has been bugged, in a way or an other, for some time, perhaps since the introduction
>> of lockless qdiscs (4.16) or somewhere between 4.16 and 5.14.
>> It's hard to tell at a glance since the code looks quite different back then.
>> Because of these changes, a unique patch will also only apply up to a certain point in the past.
>>
>> However, I think the bug became really critical only with the introduction of "true bypass" behavior
>> in lockless qdiscs by YunSheng in 5.14, though there may be scenarios where it is a big deal
>> even in no-bypass mode.
> 
> 
> commit 89837eb4b246 tried to fix that, but it did not fix it completely, and that commit should has
> been back-ported to the affected kernel versions as much as possible, so I think the Fixes tag
> should be:
> 
> Fixes: 89837eb4b246 ("net: sched: add barrier to ensure correct ordering for lockless qdisc")
> 
>>
>> => I suggest we only tag it for backward fix up to the 5.14, where it should apply smoothly,
>>   and we live with the bug for versions before that.
>> This would mean that 5.15 LT can be patched but no earlier LT
>>   
>> What do you think ?
>>
>> BTW : forgive my ignorance, but are there any kind of "Errata Sheet" or similar for known bugs that
>> won't be fixed in a given kernel ?
>>
>>>
>>>
>>>>
>>>> Thanks a lot, best,
>>>
>>> Thanks a lot for working on this long standing issue.
>>>
>>>
>>>
>>>
>>> To declare a filtering error, please use the following link :
>>> https://www.security-mail.net/reporter.php?mid=7009.628d3d4c.37c04.0&r=vray%40kalrayinc.com&s=eric.dumazet%40gmail.com&o=Re%3A+packet+stuck+in+qdisc+%3A+patch+proposal&verdict=C&c=0ca08e7b7e420d1ab014cda67db48db71df41f5f
>>
>>
>>
>>
>> .
>>
--------------G0OvHJqLSL151iPK9V5OIGKA
Content-Type: text/plain; charset=UTF-8;
 name="0001-net-sched-add-barrier-to-fix-packet-stuck-problem-fo.patch"
Content-Disposition: attachment;
 filename*0="0001-net-sched-add-barrier-to-fix-packet-stuck-problem-fo.pa";
 filename*1="tch"
Content-Transfer-Encoding: base64

RnJvbSAyOGNjODFiMzM5NzJjYjFiY2RmZDUyOWNlYWUwMjRjOTgwMGE1NGExIE1vbiBTZXAg
MTcgMDA6MDA6MDAgMjAwMQpGcm9tOiBHdW9qdSBGYW5nIDxnamZhbmdAbGludXguYWxpYmFi
YS5jb20+CkRhdGU6IFdlZCwgMjUgTWF5IDIwMjIgMTk6MTI6MDAgKzA4MDAKU3ViamVjdDog
W1BBVENIXSBuZXQ6IHNjaGVkOiBhZGQgYmFycmllciB0byBmaXggcGFja2V0IHN0dWNrIHBy
b2JsZW0gZm9yCiBsb2NrbGVzcyBxZGlzYwoKSW4gcWRpc2NfcnVuX2VuZCgpLCB0aGUgc3Bp
bl91bmxvY2soKSBvbmx5IGhhcyBzdG9yZS1yZWxlYXNlIHNlbWFudGljLAp3aGljaCBndWFy
YW50ZWVzIGFsbCBlYXJsaWVyIG1lbW9yeSBhY2Nlc3MgYXJlIHZpc2libGUgYmVmb3JlIGl0
LiBCdXQKdGhlIHN1YnNlcXVlbnQgdGVzdF9iaXQoKSBtYXkgYmUgcmVvcmRlcmVkIGFoZWFk
IG9mIHRoZSBzcGluX3VubG9jaygpLAphbmQgbWF5IGNhdXNlIGEgcGFja2V0IHN0dWNrIHBy
b2JsZW0uCgpUaGUgY29uY3VycmVudCBvcGVyYXRpb25zIGNhbiBiZSBkZXNjcmliZWQgYXMg
YmVsb3csCiAgICAgICAgIENQVSAwICAgICAgICAgICAgICAgICAgICAgIHwgICAgICAgICAg
Q1BVIDEKICAgcWRpc2NfcnVuX2VuZCgpICAgICAgICAgICAgICAgICAgfCAgICAgcWRpc2Nf
cnVuX2JlZ2luKCkKICAgICAgICAgIC4gICAgICAgICAgICAgICAgICAgICAgICAgfCAgICAg
ICAgICAgLgogLS0tLT4gLyogbWF5IGJlIHJlb3JkZXJkIGhlcmUgKi8gICB8ICAgICAgICAg
ICAuCnwgICAgICAgICAuICAgICAgICAgICAgICAgICAgICAgICAgIHwgICAgICAgICAgIC4K
fCAgICAgc3Bpbl91bmxvY2soKSAgICAgICAgICAgICAgICAgfCAgICAgICAgIHNldF9iaXQo
KQp8ICAgICAgICAgLiAgICAgICAgICAgICAgICAgICAgICAgICB8ICAgICAgICAgc21wX21i
X19hZnRlcl9hdG9taWMoKQogLS0tLSB0ZXN0X2JpdCgpICAgICAgICAgICAgICAgICAgICB8
ICAgICAgICAgc3Bpbl90cnlsb2NrKCkKICAgICAgICAgIC4gICAgICAgICAgICAgICAgICAg
ICAgICAgfCAgICAgICAgICAuCgpDb25zaWRlciB0aGUgZm9sbG93aW5nIHNlcXVlbmNlIG9m
IGV2ZW50czoKICAgIENQVSAwIHJlb3JkZXIgdGVzdF9iaXQoKSBhaGVhZCBhbmQgc2VlIE1J
U1NFRCA9IDAKICAgIENQVSAxIGNhbGxzIHNldF9iaXQoKQogICAgQ1BVIDEgY2FsbHMgc3Bp
bl90cnlsb2NrKCkgYW5kIHJldHVybiBmYWlsCiAgICBDUFUgMCBleGVjdXRlcyBzcGluX3Vu
bG9jaygpCgpBdCB0aGUgZW5kIG9mIHRoZSBzZXF1ZW5jZSwgQ1BVIDAgY2FsbHMgc3Bpbl91
bmxvY2soKSBhbmQgZG9lcyBub3RoaW5nCmJlY2F1c2UgaXQgc2VlIE1JU1NFRCA9IDAuIFRo
ZSBza2Igb24gQ1BVIDEgaGFzIGJlZWQgZW5xdWV1ZWQgYnV0IG5vIG9uZQp0YWtlIGl0LCB1
bnRpbCB0aGUgbmV4dCBjcHUgcHVzaGluZyB0byB0aGUgcWRpc2MgKGlmIGV2ZXIgLi4uKSB3
aWxsCm5vdGljZSBhbmQgZGVxdWV1ZSBpdC4KClNvIG9uZSBleHBsaWNpdCBiYXJyaWVyIGlz
IG5lZWRlZCBiZXR3ZWVuIHNwaW5fdW5sb2NrKCkgYW5kCnRlc3RfYml0KCkgdG8gZW5zdXJl
IHRoZSBjb3JyZWN0IG9yZGVyLgoKU2lnbmVkLW9mZi1ieTogR3VvanUgRmFuZyA8Z2pmYW5n
QGxpbnV4LmFsaWJhYmEuY29tPgotLS0KIGluY2x1ZGUvbmV0L3NjaF9nZW5lcmljLmggfCAz
ICsrKwogMSBmaWxlIGNoYW5nZWQsIDMgaW5zZXJ0aW9ucygrKQoKZGlmZiAtLWdpdCBhL2lu
Y2x1ZGUvbmV0L3NjaF9nZW5lcmljLmggYi9pbmNsdWRlL25ldC9zY2hfZ2VuZXJpYy5oCmlu
ZGV4IDliYWIzOTZjMWYzYi4uOGE4NzM4NjQyY2EwIDEwMDY0NAotLS0gYS9pbmNsdWRlL25l
dC9zY2hfZ2VuZXJpYy5oCisrKyBiL2luY2x1ZGUvbmV0L3NjaF9nZW5lcmljLmgKQEAgLTIy
OSw2ICsyMjksOSBAQCBzdGF0aWMgaW5saW5lIHZvaWQgcWRpc2NfcnVuX2VuZChzdHJ1Y3Qg
UWRpc2MgKnFkaXNjKQogCWlmIChxZGlzYy0+ZmxhZ3MgJiBUQ1FfRl9OT0xPQ0spIHsKIAkJ
c3Bpbl91bmxvY2soJnFkaXNjLT5zZXFsb2NrKTsKIAorCQkvKiBlbnN1cmUgb3JkZXJpbmcg
YmV0d2VlbiBzcGluX3VubG9jaygpIGFuZCB0ZXN0X2JpdCgpICovCisJCXNtcF9tYigpOwor
CiAJCWlmICh1bmxpa2VseSh0ZXN0X2JpdChfX1FESVNDX1NUQVRFX01JU1NFRCwKIAkJCQkg
ICAgICAmcWRpc2MtPnN0YXRlKSkpCiAJCQlfX25ldGlmX3NjaGVkdWxlKHFkaXNjKTsKLS0g
CjIuMzIuMC4zLmcwMTE5NWNmOWYKCg==

--------------G0OvHJqLSL151iPK9V5OIGKA--
