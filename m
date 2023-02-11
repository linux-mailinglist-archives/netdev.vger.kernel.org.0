Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EF11A69339B
	for <lists+netdev@lfdr.de>; Sat, 11 Feb 2023 21:15:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229750AbjBKUP3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Feb 2023 15:15:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229632AbjBKUP3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 11 Feb 2023 15:15:29 -0500
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFCAD193DB
        for <netdev@vger.kernel.org>; Sat, 11 Feb 2023 12:15:26 -0800 (PST)
Received: by mail-pl1-x629.google.com with SMTP id h4so2113852pll.9
        for <netdev@vger.kernel.org>; Sat, 11 Feb 2023 12:15:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=in-reply-to:from:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=JB2cY8Deb7kRqYhMxQfQd5ksF6Obu/G+2g3pli7nBDs=;
        b=gOWLWLCiGJnobRdSRHbSrxCl+e/qpJ/OkErSkX3A/APiwksHHZN8YRvXX0kkFlaVU/
         7xqj2re9p5cTJ7vLjkyp40QoNBTxZr2il1unUoh8BN6tJXXZqDTuYVhsrgmPGRug380u
         B9yjj4pOv02BO/wakUM7zqKLBUwU1NGHq8BxE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:from:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JB2cY8Deb7kRqYhMxQfQd5ksF6Obu/G+2g3pli7nBDs=;
        b=MO31dR9K7Rhq+BrGSWRLyNOV7cAM+7WQzMM+JkFSPrmRbAJOEVvoybqzV/lXelyof2
         uwIqSiaQMlwueJpbgIyeHekvf8boAjGPAmWxATABRYiNCQOB0pRgfzT4rpeTp/EM8rhs
         jE2hp76G0RfgBk896SQUegHJfgLLQ0BSvDH+TVMA/XnfdUJcUpGb944vUbGUWsGaOT7f
         Ej0EbnrTIbqtzkot5c2A6cB3d8xSUZXkvNUuBRoJKmlEOMW9i3Th57plaU19AtoCAsmP
         vLTf09w3QkW20imFCWEMVCd93nasFsN9yrxpWZ5Gy6NRUP3t2PUYWNF6sINaz7i+WzE3
         fuAw==
X-Gm-Message-State: AO0yUKXHupf9Gsl5a8WUJN+SdsDegemTm5caW9dsh7Nxn/hoXkBvBEYj
        4Mxo4u7DFcfnEk5eDO6q25/sfw==
X-Google-Smtp-Source: AK7set/lAOT5nzLftOpmMcH/qNapQPoiN9m1zHJWFYxa4yXHhHLX6BQNfdtK2F/LzGGJK7Rfxb/trA==
X-Received: by 2002:a17:902:d2d0:b0:19a:5a0d:f760 with SMTP id n16-20020a170902d2d000b0019a5a0df760mr11458109plc.18.1676146526131;
        Sat, 11 Feb 2023 12:15:26 -0800 (PST)
Received: from [192.168.178.136] (f215227.upc-f.chello.nl. [80.56.215.227])
        by smtp.gmail.com with ESMTPSA id iw22-20020a170903045600b0019101215f63sm5382247plb.93.2023.02.11.12.15.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 11 Feb 2023 12:15:25 -0800 (PST)
Message-ID: <78374dd7-1eef-52e1-95f1-73c971ac2dd0@broadcom.com>
Date:   Sat, 11 Feb 2023 21:15:15 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH v3 1/4] wifi: brcmfmac: Rename Cypress 89459 to BCM4355
To:     Hector Martin <marcan@marcan.st>,
        Aditya Garg <gargaditya08@live.com>
Cc:     Ping-Ke Shih <pkshih@realtek.com>,
        Arend van Spriel <aspriel@gmail.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Alexander Prutskov <alep@cypress.com>,
        Chi-Hsien Lin <chi-hsien.lin@cypress.com>,
        Wright Feng <wright.feng@cypress.com>,
        Ian Lin <ian.lin@infineon.com>,
        Soontak Lee <soontak.lee@cypress.com>,
        Joseph chuang <jiac@cypress.com>,
        Sven Peter <sven@svenpeter.dev>,
        Alyssa Rosenzweig <alyssa@rosenzweig.io>,
        Jonas Gorski <jonas.gorski@gmail.com>, asahi@lists.linux.dev,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        SHA-cyfmac-dev-list@infineon.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20230210025009.21873-1-marcan@marcan.st>
 <20230210025009.21873-2-marcan@marcan.st>
 <0cd45af5812345878faf0dc8fa6b0963@realtek.com>
 <624c0a20-f4e6-14a5-02a2-eaf7b36e9331@marcan.st>
 <18640374b38.279b.9b12b7fc0a3841636cfb5e919b41b954@broadcom.com>
 <e9dbfa3d-6599-94b9-0176-e25bb074b2c7@marcan.st>
 <BM1PR01MB0931D1A15E7945A0D48B828EB8DF9@BM1PR01MB0931.INDPRD01.PROD.OUTLOOK.COM>
 <18640c70048.279b.9b12b7fc0a3841636cfb5e919b41b954@broadcom.com>
 <180b9e56-fbf4-4d98-3d18-a71f3b15e045@marcan.st>
From:   Arend van Spriel <arend.vanspriel@broadcom.com>
In-Reply-To: <180b9e56-fbf4-4d98-3d18-a71f3b15e045@marcan.st>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="0000000000004df4d905f47246bf"
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--0000000000004df4d905f47246bf
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 2/11/2023 8:15 PM, Hector Martin wrote:
> On 11/02/2023 23.00, Arend Van Spriel wrote:
>> On February 11, 2023 1:50:00 PM Aditya Garg <gargaditya08@live.com> wrote:
>>
>>>> On 11-Feb-2023, at 6:16 PM, Hector Martin <marcan@marcan.st> wrote:
>>>>
>>>> ﻿On 11/02/2023 20.23, Arend Van Spriel wrote:
>>>>>> On February 11, 2023 11:09:02 AM Hector Martin <marcan@marcan.st> wrote:
>>>>>>
>>>>>> On 10/02/2023 12.42, Ping-Ke Shih wrote:
>>>>>>>
>>>>>>>
>>>>>>>> -----Original Message-----
>>>>>>>> From: Hector Martin <marcan@marcan.st>
>>>>>>>> Sent: Friday, February 10, 2023 10:50 AM
>>>>>>>> To: Arend van Spriel <aspriel@gmail.com>; Franky Lin
>>>>>>>> <franky.lin@broadcom.com>; Hante Meuleman
>>>>>>>> <hante.meuleman@broadcom.com>; Kalle Valo <kvalo@kernel.org>; David S.
>>>>>>>> Miller <davem@davemloft.net>; Eric
>>>>>>>> Dumazet <edumazet@google.com>; Jakub Kicinski <kuba@kernel.org>; Paolo
>>>>>>>> Abeni <pabeni@redhat.com>
>>>>>>>> Cc: Alexander Prutskov <alep@cypress.com>; Chi-Hsien Lin
>>>>>>>> <chi-hsien.lin@cypress.com>; Wright Feng
>>>>>>>> <wright.feng@cypress.com>; Ian Lin <ian.lin@infineon.com>; Soontak Lee
>>>>>>>> <soontak.lee@cypress.com>; Joseph
>>>>>>>> chuang <jiac@cypress.com>; Sven Peter <sven@svenpeter.dev>; Alyssa
>>>>>>>> Rosenzweig <alyssa@rosenzweig.io>;
>>>>>>>> Aditya Garg <gargaditya08@live.com>; Jonas Gorski <jonas.gorski@gmail.com>;
>>>>>>>> asahi@lists.linux.dev;
>>>>>>>> linux-wireless@vger.kernel.org; brcm80211-dev-list.pdl@broadcom.com;
>>>>>>>> SHA-cyfmac-dev-list@infineon.com;
>>>>>>>> netdev@vger.kernel.org; linux-kernel@vger.kernel.org; Hector Martin
>>>>>>>> <marcan@marcan.st>; Arend van Spriel
>>>>>>>> <arend.vanspriel@broadcom.com>
>>>>>>>> Subject: [PATCH v3 1/4] wifi: brcmfmac: Rename Cypress 89459 to BCM4355
>>>>>>>>
>>>>>>>> The commit that introduced support for this chip incorrectly claimed it
>>>>>>>> is a Cypress-specific part, while in actuality it is just a variant of
>>>>>>>> BCM4355 silicon (as evidenced by the chip ID).
>>>>>>>>
>>>>>>>> The relationship between Cypress products and Broadcom products isn't
>>>>>>>> entirely clear but given what little information is available and prior
>>>>>>>> art in the driver, it seems the convention should be that originally
>>>>>>>> Broadcom parts should retain the Broadcom name.
>>>>>>>>
>>>>>>>> Thus, rename the relevant constants and firmware file. Also rename the
>>>>>>>> specific 89459 PCIe ID to BCM43596, which seems to be the original
>>>>>>>> subvariant name for this PCI ID (as defined in the out-of-tree bcmdhd
>>>>>>>> driver).
>>>>>>>>
>>>>>>>> v2: Since Cypress added this part and will presumably be providing
>>>>>>>> its supported firmware, we keep the CYW designation for this device.
>>>>>>>>
>>>>>>>> v3: Drop the RAW device ID in this commit. We don't do this for the
>>>>>>>> other chips since apparently some devices with them exist in the wild,
>>>>>>>> but there is already a 4355 entry with the Broadcom subvendor and WCC
>>>>>>>> firmware vendor, so adding a generic fallback to Cypress seems
>>>>>>>> redundant (no reason why a device would have the raw device ID *and* an
>>>>>>>> explicitly programmed subvendor).
>>>>>>>
>>>>>>> Do you really want to add changes of v2 and v3 to commit message? Or,
>>>>>>> just want to let reviewers know that? If latter one is what you want,
>>>>>>> move them after s-o-b with delimiter ---
>>>>>>
>>>>>> Both; I thought those things were worth mentioning in the commit message
>>>>>> as it stands on its own, and left the version tags in so reviewers know
>>>>>> when they were introduced.
>>>>>
>>>>> The commit message is documenting what we end up with post reviewing so
>>>>> patch versions are meaningless there. Of course useful information that
>>>>> came up in review cycles should end up in the commit message.
>>>>
>>>> Do you really want me to respin this again just to remove 8 characters
>>>> from the commit message? I know it doesn't have much meaning post review
>>>> but it's not unheard of either, grep git logs and you'll find plenty of
>>>> examples.
>>>>
>>>> - Hector
>>>
>>> Adding to that, I guess the maintainers can do a bit on their part. Imao it’s
>>> really frustrating preparing the same patch again and again, especially for
>>> bits like these.
>>
>> Frustrating? I am sure that maintainers have another view on that when they
>> have to mention the same type of submission errors again and again. That's
>> why there is a wireless wiki page on the subject:
>>
>> https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
> 
> Which does not mention this particular issue as far as I can tell. How
> exactly is this a "submission error"? Neither you nor Kalle pointed it
> out through two revisions, only a drive-by reviewer did.

It does mention how to provide the changelog and I would have guessed 
you were smart enough to see the reason behind it. It is a bit lame to 
say it is not mentioned.

>> If Kalle is willing to cleanup the commit message in the current patch you
>> are lucky. You are free to ask. Otherwise it should be not too much trouble
>> resubmitting it.
> 
> It's even less trouble to just take it as is, since an extra "v2: " in
> the commit message doesn't hurt anyone other than those who choose to be
> hurt by it. And as I said there's *tons* of commits with a changelog
> like this in Linux. It's not uncommon.
> 
> I swear, some maintainers seem to take a perverse delight in making
> things as painful as possible for submitters, even when there is
> approximately zero benefit to the end result. And I say this as a
> maintainer myself.
> 
> Maybe y'all should be the ones feeling lucky that so many people are
> willing to put up with all this bullshit to get things upstreamed to
> Linux. It's literally the worst open source project to upstream things
> to, by a *very long* shot. I'll respin a v4 if I must, but but it's.
> Just. This. Kind. Of. Nonsense. Every. Single. Time. And. Every. Single.
> Time. It's. Something. Different. This stuff burns people out and
> discourages submissions and turns huge numbers of people off from ever
> contributing to Linux, and you all need to seriously be aware of that.

I leave this to Kalle. Personally I do not have a problem with it, but 
the drive-by reviewer, Ping-Ke Shih, did have a point and respinning a 
patch series really is not a big effort. In 30+ years of programming I 
have been annoyed many times about seemingly trivial review comments or 
straight bullshit remarks or even solid remarks, but you learn to 
swallow that, make the changes, and move forward. Don't get discouraged.

Regards,
Arend

--0000000000004df4d905f47246bf
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
2Gzj3QNJRLsZu1TLyOyBBIr/BE7UiY3RabgRzknBGAPmzhS+fmyM8OtM5BYBsFBrSUFtZZO2p/tf
Nbc24J2zf2peoZ8MK+7WQqummYlOnz+FyDkA9EybeNMcS5C+xi/PAgMBAAGjggHdMIIB2TAOBgNV
HQ8BAf8EBAMCBaAwgaMGCCsGAQUFBwEBBIGWMIGTME4GCCsGAQUFBzAChkJodHRwOi8vc2VjdXJl
Lmdsb2JhbHNpZ24uY29tL2NhY2VydC9nc2djY3IzcGVyc29uYWxzaWduMmNhMjAyMC5jcnQwQQYI
KwYBBQUHMAGGNWh0dHA6Ly9vY3NwLmdsb2JhbHNpZ24uY29tL2dzZ2NjcjNwZXJzb25hbHNpZ24y
Y2EyMDIwME0GA1UdIARGMEQwQgYKKwYBBAGgMgEoCjA0MDIGCCsGAQUFBwIBFiZodHRwczovL3d3
dy5nbG9iYWxzaWduLmNvbS9yZXBvc2l0b3J5LzAJBgNVHRMEAjAAMEkGA1UdHwRCMEAwPqA8oDqG
OGh0dHA6Ly9jcmwuZ2xvYmFsc2lnbi5jb20vZ3NnY2NyM3BlcnNvbmFsc2lnbjJjYTIwMjAuY3Js
MCcGA1UdEQQgMB6BHGFyZW5kLnZhbnNwcmllbEBicm9hZGNvbS5jb20wEwYDVR0lBAwwCgYIKwYB
BQUHAwQwHwYDVR0jBBgwFoAUljPR5lgXWzR1ioFWZNW+SN6hj88wHQYDVR0OBBYEFIikAXd8CEtv
ZbDflDRnf3tuStPuMA0GCSqGSIb3DQEBCwUAA4IBAQCdS5XCYx6k2GGZui9DlFsFm75khkqAU7rT
zBX04sJU1+B1wtgmWTVIzW7ugdtDZ4gzaV0S9xRhpDErjJaltxPbCylb1DEsLj+AIvBR34caW6ZG
sQk444t0HPb29HnWYj+OllIGMbdJWr0/P95ZrKk2bP24ub3ZP/8SyzrohfIba9WZKMq6g2nTLZE3
BtkeSGJx/8dy0h8YmRn+adOrxKXHxhSL8BNn8wsmIZyYWe6fRcBtO3Ks2DOLyHCdkoFlN8x9VUQF
N2ulEgqCbRKkx+qNirW86eF138lr1gRxzclu/38ko//MmkAYR/+hP3WnBll7zbpIt0jc9wyFkSqH
p8a1MYICbTCCAmkCAQEwazBbMQswCQYDVQQGEwJCRTEZMBcGA1UEChMQR2xvYmFsU2lnbiBudi1z
YTExMC8GA1UEAxMoR2xvYmFsU2lnbiBHQ0MgUjMgUGVyc29uYWxTaWduIDIgQ0EgMjAyMAIMTv1t
bpIzNUky46LXMA0GCWCGSAFlAwQCAQUAoIHUMC8GCSqGSIb3DQEJBDEiBCDFLA8NstOIuU2X1jxb
4WKV/M/XRPx3FjGAThbyraj3JTAYBgkqhkiG9w0BCQMxCwYJKoZIhvcNAQcBMBwGCSqGSIb3DQEJ
BTEPFw0yMzAyMTEyMDE1MjZaMGkGCSqGSIb3DQEJDzFcMFowCwYJYIZIAWUDBAEqMAsGCWCGSAFl
AwQBFjALBglghkgBZQMEAQIwCgYIKoZIhvcNAwcwCwYJKoZIhvcNAQEKMAsGCSqGSIb3DQEBBzAL
BglghkgBZQMEAgEwDQYJKoZIhvcNAQEBBQAEggEAZk9jUQDjYcRtF1Wdy70XaZkPQKMFo7NiJJ2E
FKV9p+hsFa5hppCiBuADGJNKo3AEp6piqu9trx8LP6Wckog7RNvJ7nunklj9aLBphWHbND4pSI4M
uj3xj6ozfCO32tU8dZXZ86hRk7ZXnesEvmHlMf6gmeFSMdaXg6lqe+5B8/51fTmnSmFKgRic7gJF
vr6wRlcsXh1qviP7RCJGlKOB8yMHjAXXJgXruAIR31LUFZMyBN4KikxnoAGJNs/RFqOi37omsK34
bA4gg3PVXFUKfhQkB1fKjJaUH9w/HUDn+KTDsarraNKJJI03pS8VqUS9yjxwfu+O+OBIvBw2Gi1M
Rw==
--0000000000004df4d905f47246bf--
