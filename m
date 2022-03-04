Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 562A14CDE12
	for <lists+netdev@lfdr.de>; Fri,  4 Mar 2022 21:25:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231241AbiCDUQy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Mar 2022 15:16:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231424AbiCDUQo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Mar 2022 15:16:44 -0500
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C5A8241B48
        for <netdev@vger.kernel.org>; Fri,  4 Mar 2022 12:12:47 -0800 (PST)
Received: by mail-pl1-x62e.google.com with SMTP id z11so8713405pla.7
        for <netdev@vger.kernel.org>; Fri, 04 Mar 2022 12:12:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to;
        bh=mIxd94zyViynB7yw6pX6Mu/7VGP9cCd/KPcAgUYqr80=;
        b=iKw8BskodrC6yeGEGqG2mxKGZQH/RSvhjNSnDNtuU/PgtKZwP0iaFPFHyI3zneJUnz
         wNxe2mCJ94DU1/dcCL6AqCUEh5IhcDR9HB/KuRn/wl4b5uN+vScjUrZ7Wbthwy8MB3Qy
         YHXHS836aofYCSCKJSwXT7DEj1odhsqf8ERy/R+OI3eM+C5QbDAyfZ9fzl+TtQSiXvtS
         XqIC+D28YoOLf7v0Bfa4WtKgYUtN9EPQ1UfezvT3mdK2bHwXGBoO3gw/2LkRIDe+mEHb
         JICyKjCLAVN+/GKvN+JP5CRU9QP5ujnTDYp13s4lQ+AnmZ8BUqwv5Lt9GhUR0kS3O0C1
         eIXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to;
        bh=mIxd94zyViynB7yw6pX6Mu/7VGP9cCd/KPcAgUYqr80=;
        b=b99RP6LVJaBDkLSNws/HFyjE5EMUv6wbuLeUHGTLNTcNxudB2C1nSOJh/6uGDuVn/S
         FCzdqUDdTrJbONNl0I6SDJSt/sgEs04+SZXfpTS1fEMpLTe/ydIypwblp9idczSssu7p
         vBQfLG6g3fX5cr1zukPxLcnrqWkJJfxfslI3tgkiZGCSzxC8OPmkUBgiTWvZ9doISqdn
         1AHm0Mc7F8g/lOmARQU3RD1DuMrYzHW/LES0DPzajuTUULytGnpLHT4W/j7/nkCsbVTI
         VrrAever1nzEO8m/f2V2n5JpPlCpDt1vbz39wLi0Wnvh8I94a5AM/YUn5Q4mzyZsAtKY
         nuMw==
X-Gm-Message-State: AOAM533Ec8C1kQ/CWdtY78AY9O445UmhMf8Wls4FQA7pIuRPvRwHDwxX
        U0N6bQ/qPeCwqd7vyBKWyNA=
X-Google-Smtp-Source: ABdhPJzKKBModgnEADw2QLAAkRmXa8YosTD+bSdkJlKhPtrmLxjGWkT46dUhEg4vfJH+hBTOqJJIdQ==
X-Received: by 2002:a17:902:780f:b0:14f:d765:b6f1 with SMTP id p15-20020a170902780f00b0014fd765b6f1mr122057pll.85.1646424764109;
        Fri, 04 Mar 2022 12:12:44 -0800 (PST)
Received: from [192.168.1.3] (ip72-194-116-95.oc.oc.cox.net. [72.194.116.95])
        by smtp.gmail.com with ESMTPSA id p10-20020a637f4a000000b00373a2760775sm5065190pgn.2.2022.03.04.12.12.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 04 Mar 2022 12:12:43 -0800 (PST)
Content-Type: multipart/mixed; boundary="------------CvvnJNohL3gA0gVFXuFfAQhY"
Message-ID: <de377891-c220-64f8-a0c2-69976d0c8513@gmail.com>
Date:   Fri, 4 Mar 2022 12:12:42 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.1
Subject: Re: [PATCH] net: bcmgenet: Return not supported if we don't have a
 WoL IRQ
Content-Language: en-US
To:     Jeremy Linton <jeremy.linton@arm.com>,
        Javier Martinez Canillas <javierm@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Peter Robinson <pbrobinson@gmail.com>,
        Doug Berger <opendmb@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        bcm-kernel-feedback-list@broadcom.com, netdev@vger.kernel.org
References: <20220222095348.2926536-1-pbrobinson@gmail.com>
 <f79df42b-ff25-edaa-7bf3-00b44b126007@gmail.com>
 <CALeDE9NGckRoatePdaWFYqHXHcOJ2Xzd4PGLOoNWDibzPB_zXQ@mail.gmail.com>
 <734024dc-dadd-f92d-cbbb-c8dc9c955ec3@gmail.com>
 <CALeDE9Nk8gvCS425pJe5JCgcfSZugSnYwzGOkxhszrBz3Da6Fg@mail.gmail.com>
 <3ae3a9fc-9dd1-00c6-4ae8-a65df3ed225f@gmail.com>
 <CALeDE9PK9JkFkbTc36HOZH8CG8MM3OMhKJ24FKioKF5bspSPkA@mail.gmail.com>
 <6cefe7ca-842b-d3af-0299-588b9307703b@gmail.com>
 <20220223144818.2f9ce725@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <922fab4e-0608-0d46-9379-026a51398b7a@arm.com>
 <e0fbf7c7-c09f-0f39-e53a-3118c1b2f193@redhat.com>
 <6fc548ca-1195-8941-5caa-2e3384debad7@arm.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <6fc548ca-1195-8941-5caa-2e3384debad7@arm.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is a multi-part message in MIME format.
--------------CvvnJNohL3gA0gVFXuFfAQhY
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



On 3/4/2022 9:33 AM, Jeremy Linton wrote:
> Hi,
> 
> On 3/3/22 14:04, Javier Martinez Canillas wrote:
>> Hello Jeremy,
>>
>> On 3/3/22 21:00, Jeremy Linton wrote:
>>> Hi,
>>>
>>> On 2/23/22 16:48, Jakub Kicinski wrote:
>>>> On Wed, 23 Feb 2022 09:54:26 -0800 Florian Fainelli wrote:
>>>>>> I have no problems working with you to improve the driver, the 
>>>>>> problem
>>>>>> I have is this is currently a regression in 5.17 so I would like to
>>>>>> see something land, whether it's reverting the other patch, landing
>>>>>> thing one or another straight forward fix and then maybe revisit as
>>>>>> whole in 5.18.
>>>>>
>>>>> Understood and I won't require you or me to complete this 
>>>>> investigating
>>>>> before fixing the regression, this is just so we understand where it
>>>>> stemmed from and possibly fix the IRQ layer if need be. Given what I
>>>>> just wrote, do you think you can sprinkle debug prints throughout the
>>>>> kernel to figure out whether enable_irq_wake() somehow messes up the
>>>>> interrupt descriptor of interrupt and test that theory? We can do that
>>>>> offline if you want.
>>>>
>>>> Let me mark v2 as Deferred for now, then. I'm not really sure if that's
>>>> what's intended but we have 3 weeks or so until 5.17 is cut so we can
>>>> afford a few days of investigating.
>>>>
>>>> I'm likely missing the point but sounds like the IRQ subsystem treats
>>>> IRQ numbers as unsigned so if we pass a negative value "fun" is sort
>>>> of expected. Isn't the problem that device somehow comes with wakeup
>>>> capable being set already? Isn't it better to make sure device is not
>>>> wake capable if there's no WoL irq instead of adding second check?
>>>>
>>>> diff --git a/drivers/net/ethernet/broadcom/genet/bcmgenet.c 
>>>> b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
>>>> index cfe09117fe6c..7dea44803beb 100644
>>>> --- a/drivers/net/ethernet/broadcom/genet/bcmgenet.c
>>>> +++ b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
>>>> @@ -4020,12 +4020,12 @@ static int bcmgenet_probe(struct 
>>>> platform_device *pdev)
>>>>        /* Request the WOL interrupt and advertise suspend if 
>>>> available */
>>>>        priv->wol_irq_disabled = true;
>>>> -    if (priv->wol_irq > 0) {
>>>> +    if (priv->wol_irq > 0)
>>>>            err = devm_request_irq(&pdev->dev, priv->wol_irq,
>>>>                           bcmgenet_wol_isr, 0, dev->name, priv);
>>>> -        if (!err)
>>>> -            device_set_wakeup_capable(&pdev->dev, 1);
>>>> -    }
>>>> +    else
>>>> +        err = -ENOENT;
>>>> +    device_set_wakeup_capable(&pdev->dev, !err);
>>>>        /* Set the needed headroom to account for any possible
>>>>         * features enabling/disabling at runtime
>>>>
>>>
>>>
>>> I duplicated the problem on rpi4/ACPI by moving to gcc12, so I have a/b
>>> config that is close as I can achieve using gcc11 vs 12 and the one
>>> built with gcc12 fails pretty consistently while the gcc11 works.
>>>
>>
>> Did Peter's patch instead of this one help ?
>>
> 
> No, it seems to be the same problem. The second irq is registered, but 
> never seems to fire. There are a couple odd compiler warnings about 
> infinite recursion in memcpy()/etc I was looking at, but nothing really 
> pops out. Its like the adapter never gets the command submissions 
> (although link/up/down appear to be working/etc).

There are two "main" interrupt lines which are required and an optional 
third interrupt line which is the side band Wake-on-LAN interrupt from 
the second level interrupt controller that aggregates all wake-up sources.

The first interrupt line collects the the default RX/TX queue interrupts 
(ring 16) as well as the MAC link up/down and other interrupts that we 
are not using. The second interrupt line is only for the TX queues 
(rings 0 through 3) transmit done completion signaling. Because the 
driver is multi-queue aware and enabled, the network stack will chose 
any of those 5 queues before transmitting packets based upon a hash, so 
if you want to reliably prove/disprove that the second interrupt line is 
non-functional, you would need to force a given type of packet(s) to use 
that queue specifically. There is an example on how to do that here:

https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/Documentation/networking/multiqueue.rst#n47

With that said, please try the following debug patch so we can get more 
understanding of how we managed to prevent the second interrupt line 
from getting its interrupt handler serviced. Thanks
-- 
Florian
--------------CvvnJNohL3gA0gVFXuFfAQhY
Content-Type: text/plain; charset=UTF-8; name="debug.diff"
Content-Disposition: attachment; filename="debug.diff"
Content-Transfer-Encoding: base64

ZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L2V0aGVybmV0L2Jyb2FkY29tL2dlbmV0L2JjbWdl
bmV0LmMgYi9kcml2ZXJzL25ldC9ldGhlcm5ldC9icm9hZGNvbS9nZW5ldC9iY21nZW5ldC5j
CmluZGV4IGNmZTA5MTE3ZmU2Yy4uN2M3YWIyY2IwZWJmIDEwMDY0NAotLS0gYS9kcml2ZXJz
L25ldC9ldGhlcm5ldC9icm9hZGNvbS9nZW5ldC9iY21nZW5ldC5jCisrKyBiL2RyaXZlcnMv
bmV0L2V0aGVybmV0L2Jyb2FkY29tL2dlbmV0L2JjbWdlbmV0LmMKQEAgLTM5OTEsNiArMzk5
MSwxMCBAQCBzdGF0aWMgaW50IGJjbWdlbmV0X3Byb2JlKHN0cnVjdCBwbGF0Zm9ybV9kZXZp
Y2UgKnBkZXYpCiAJfQogCXByaXYtPndvbF9pcnEgPSBwbGF0Zm9ybV9nZXRfaXJxX29wdGlv
bmFsKHBkZXYsIDIpOwogCisJZGV2X2luZm8oJnBkZXYtPmRldiwgIklSUTA6ICVkICgldSks
IElSUTE6ICVkICgldSksIFdvbCBJUlE6ICVkICgldSlcbiIsCisJCSBwcml2LT5pcnEwLCBw
cml2LT5pcnExLCBwcml2LT53b2xfaXJxLAorCQkgcHJpdi0+aXJxMCwgcHJpdi0+aXJxMSwg
cHJpdi0+d29sX2lycSk7CisKIAlwcml2LT5iYXNlID0gZGV2bV9wbGF0Zm9ybV9pb3JlbWFw
X3Jlc291cmNlKHBkZXYsIDApOwogCWlmIChJU19FUlIocHJpdi0+YmFzZSkpIHsKIAkJZXJy
ID0gUFRSX0VSUihwcml2LT5iYXNlKTsKQEAgLTQwMjEsMTAgKzQwMjUsMTMgQEAgc3RhdGlj
IGludCBiY21nZW5ldF9wcm9iZShzdHJ1Y3QgcGxhdGZvcm1fZGV2aWNlICpwZGV2KQogCS8q
IFJlcXVlc3QgdGhlIFdPTCBpbnRlcnJ1cHQgYW5kIGFkdmVydGlzZSBzdXNwZW5kIGlmIGF2
YWlsYWJsZSAqLwogCXByaXYtPndvbF9pcnFfZGlzYWJsZWQgPSB0cnVlOwogCWlmIChwcml2
LT53b2xfaXJxID4gMCkgeworCQlkZXZfaW5mbygmcGRldi0+ZGV2LCAiV29sIElSUSA+IDAg
cmVxdWVzdGluZyBXb0wgSVNSXG4iKTsKIAkJZXJyID0gZGV2bV9yZXF1ZXN0X2lycSgmcGRl
di0+ZGV2LCBwcml2LT53b2xfaXJxLAogCQkJCSAgICAgICBiY21nZW5ldF93b2xfaXNyLCAw
LCBkZXYtPm5hbWUsIHByaXYpOwotCQlpZiAoIWVycikKKwkJaWYgKCFlcnIpIHsKKwkJCWRl
dl9pbmZvKCZwZGV2LT5kZXYsICJNYXJraW5nIGRldmljZSBhcyB3YWtlLXVwIGNhcGFibGVc
biIpOwogCQkJZGV2aWNlX3NldF93YWtldXBfY2FwYWJsZSgmcGRldi0+ZGV2LCAxKTsKKwkJ
fQogCX0KIAogCS8qIFNldCB0aGUgbmVlZGVkIGhlYWRyb29tIHRvIGFjY291bnQgZm9yIGFu
eSBwb3NzaWJsZQpkaWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQvZXRoZXJuZXQvYnJvYWRjb20v
Z2VuZXQvYmNtZ2VuZXRfd29sLmMgYi9kcml2ZXJzL25ldC9ldGhlcm5ldC9icm9hZGNvbS9n
ZW5ldC9iY21nZW5ldF93b2wuYwppbmRleCBlMzFhNWEzOTdmMTEuLjI2ZWZhNGQxNzVhNyAx
MDA2NDQKLS0tIGEvZHJpdmVycy9uZXQvZXRoZXJuZXQvYnJvYWRjb20vZ2VuZXQvYmNtZ2Vu
ZXRfd29sLmMKKysrIGIvZHJpdmVycy9uZXQvZXRoZXJuZXQvYnJvYWRjb20vZ2VuZXQvYmNt
Z2VuZXRfd29sLmMKQEAgLTU3LDExICs1NywxNSBAQCBpbnQgYmNtZ2VuZXRfc2V0X3dvbChz
dHJ1Y3QgbmV0X2RldmljZSAqZGV2LCBzdHJ1Y3QgZXRodG9vbF93b2xpbmZvICp3b2wpCiAJ
c3RydWN0IGJjbWdlbmV0X3ByaXYgKnByaXYgPSBuZXRkZXZfcHJpdihkZXYpOwogCXN0cnVj
dCBkZXZpY2UgKmtkZXYgPSAmcHJpdi0+cGRldi0+ZGV2OwogCi0JaWYgKCFkZXZpY2VfY2Fu
X3dha2V1cChrZGV2KSkKKwlpZiAoIWRldmljZV9jYW5fd2FrZXVwKGtkZXYpKSB7CisJCWRl
dl9lcnIoa2RldiwgIkRldmljZSBjYW5ub3Qgd2FrZS11cFxuIik7CiAJCXJldHVybiAtRU5P
VFNVUFA7CisJfQogCi0JaWYgKHdvbC0+d29sb3B0cyAmIH4oV0FLRV9NQUdJQyB8IFdBS0Vf
TUFHSUNTRUNVUkUgfCBXQUtFX0ZJTFRFUikpCisJaWYgKHdvbC0+d29sb3B0cyAmIH4oV0FL
RV9NQUdJQyB8IFdBS0VfTUFHSUNTRUNVUkUgfCBXQUtFX0ZJTFRFUikpIHsKKwkJZGV2X2Vy
cihrZGV2LCAiSW52YWxpZCB3b2xvcHRzXG4iKTsKIAkJcmV0dXJuIC1FSU5WQUw7CisJfQog
CiAJaWYgKHdvbC0+d29sb3B0cyAmIFdBS0VfTUFHSUNTRUNVUkUpCiAJCW1lbWNweShwcml2
LT5zb3Bhc3MsIHdvbC0+c29wYXNzLCBzaXplb2YocHJpdi0+c29wYXNzKSk7CkBAIC02OSw2
ICs3Myw3IEBAIGludCBiY21nZW5ldF9zZXRfd29sKHN0cnVjdCBuZXRfZGV2aWNlICpkZXYs
IHN0cnVjdCBldGh0b29sX3dvbGluZm8gKndvbCkKIAkvKiBGbGFnIHRoZSBkZXZpY2UgYW5k
IHJlbGV2YW50IElSUSBhcyB3YWtldXAgY2FwYWJsZSAqLwogCWlmICh3b2wtPndvbG9wdHMp
IHsKIAkJZGV2aWNlX3NldF93YWtldXBfZW5hYmxlKGtkZXYsIDEpOworCQlkZXZfaW5mbyhr
ZGV2LCAiRW5hYmxpbmcgZGV2aWNlIGZvciB3YWtlLXVwXG4iKTsKIAkJLyogQXZvaWQgdW5i
YWxhbmNlZCBlbmFibGVfaXJxX3dha2UgY2FsbHMgKi8KIAkJaWYgKHByaXYtPndvbF9pcnFf
ZGlzYWJsZWQpCiAJCQllbmFibGVfaXJxX3dha2UocHJpdi0+d29sX2lycSk7CmRpZmYgLS1n
aXQgYS9rZXJuZWwvaXJxL21hbmFnZS5jIGIva2VybmVsL2lycS9tYW5hZ2UuYwppbmRleCBm
MjNmZmQzMDM4NWIuLmQxYTQzNmYyOWEzYSAxMDA2NDQKLS0tIGEva2VybmVsL2lycS9tYW5h
Z2UuYworKysgYi9rZXJuZWwvaXJxL21hbmFnZS5jCkBAIC04NDEsMTEgKzg0MSwxNSBAQCBz
dGF0aWMgaW50IHNldF9pcnFfd2FrZV9yZWFsKHVuc2lnbmVkIGludCBpcnEsIHVuc2lnbmVk
IGludCBvbikKIAlzdHJ1Y3QgaXJxX2Rlc2MgKmRlc2MgPSBpcnFfdG9fZGVzYyhpcnEpOwog
CWludCByZXQgPSAtRU5YSU87CiAKLQlpZiAoaXJxX2Rlc2NfZ2V0X2NoaXAoZGVzYyktPmZs
YWdzICYgIElSUUNISVBfU0tJUF9TRVRfV0FLRSkKKwlpZiAoaXJxX2Rlc2NfZ2V0X2NoaXAo
ZGVzYyktPmZsYWdzICYgIElSUUNISVBfU0tJUF9TRVRfV0FLRSkgeworCQlwcl9pbmZvKCIl
czogSVJRIGNoaXAgaXMgbWFya2VkIHdpdGggSVJRQ0hJUF9TS0lQX1NFVF9XQUtFXG4iLCBf
X2Z1bmNfXyk7CiAJCXJldHVybiAwOworCX0KIAotCWlmIChkZXNjLT5pcnFfZGF0YS5jaGlw
LT5pcnFfc2V0X3dha2UpCisJaWYgKGRlc2MtPmlycV9kYXRhLmNoaXAtPmlycV9zZXRfd2Fr
ZSkgewogCQlyZXQgPSBkZXNjLT5pcnFfZGF0YS5jaGlwLT5pcnFfc2V0X3dha2UoJmRlc2Mt
PmlycV9kYXRhLCBvbik7CisJCXByX2luZm8oIiVzOiBpcnFfc2V0X3dha2UgcmV0dXJuZWQ6
ICVkIGZvciBJUlE6ICVkXG4iLCBfX2Z1bmNfXywgaXJxKTsKKwl9CiAKIAlyZXR1cm4gcmV0
OwogfQpAQCAtODc1LDggKzg3OSwxMiBAQCBpbnQgaXJxX3NldF9pcnFfd2FrZSh1bnNpZ25l
ZCBpbnQgaXJxLCB1bnNpZ25lZCBpbnQgb24pCiAJc3RydWN0IGlycV9kZXNjICpkZXNjID0g
aXJxX2dldF9kZXNjX2J1c2xvY2soaXJxLCAmZmxhZ3MsIElSUV9HRVRfREVTQ19DSEVDS19H
TE9CQUwpOwogCWludCByZXQgPSAwOwogCi0JaWYgKCFkZXNjKQorCXByX2luZm8oIiVzOiBj
YWxsZWQgd2l0aCBJUlE6ICVkIG9uOiAlZFxuIiwgX19mdW5jX18sIGlycSwgb24pOworCisJ
aWYgKCFkZXNjKSB7CisJCXByX2VycigiJXM6IGludmFsaWQgZGVzY3JpcHRvclxuIiwgX19m
dW5jX18pOwogCQlyZXR1cm4gLUVJTlZBTDsKKwl9CiAKIAkvKiBEb24ndCB1c2UgTk1JcyBh
cyB3YWtlIHVwIGludGVycnVwdHMgcGxlYXNlICovCiAJaWYgKGRlc2MtPmlzdGF0ZSAmIElS
UVNfTk1JKSB7CkBAIC05MDksNiArOTE3LDcgQEAgaW50IGlycV9zZXRfaXJxX3dha2UodW5z
aWduZWQgaW50IGlycSwgdW5zaWduZWQgaW50IG9uKQogCiBvdXRfdW5sb2NrOgogCWlycV9w
dXRfZGVzY19idXN1bmxvY2soZGVzYywgZmxhZ3MpOworCXByX2luZm8oIiVzOiByZXR1cm5p
bmcgJWQgZm9yIElSUTogJWRcbiIsIF9fZnVuY19fLCByZXQsIGlycSk7CiAJcmV0dXJuIHJl
dDsKIH0KIEVYUE9SVF9TWU1CT0woaXJxX3NldF9pcnFfd2FrZSk7Cg==

--------------CvvnJNohL3gA0gVFXuFfAQhY--
