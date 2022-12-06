Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 97568644B25
	for <lists+netdev@lfdr.de>; Tue,  6 Dec 2022 19:20:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229819AbiLFST7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Dec 2022 13:19:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229822AbiLFSTr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Dec 2022 13:19:47 -0500
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0A93B7F9
        for <netdev@vger.kernel.org>; Tue,  6 Dec 2022 10:19:46 -0800 (PST)
Received: by mail-pj1-x1032.google.com with SMTP id b11so15241026pjp.2
        for <netdev@vger.kernel.org>; Tue, 06 Dec 2022 10:19:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=mime-version:subject:user-agent:references:in-reply-to:message-id
         :date:cc:to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=b/z0Rb+C0sxyg9neH+odBjSqOSqcc+cpLiYcYsH34Lc=;
        b=TsweV9E0v8K9+vTa4dge624bnVUIPhwLaralTVBWZYxlnjbFJtj8Fwx3tZSF799uQ6
         O9jvLo2dgaFA8Vqzn1unFLhD7tU/9EqGLiheZ0DiBHnjDnk08x+zF8tP33IJ6eda4EgE
         Unzgxc/T/M5NOKuCkzVVZxRQQA1l/5WhXjVEY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:subject:user-agent:references:in-reply-to:message-id
         :date:cc:to:from:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=b/z0Rb+C0sxyg9neH+odBjSqOSqcc+cpLiYcYsH34Lc=;
        b=J+zNr9I4oQWf4q/IjfY22l+M1SGFBoI6b4fZbrAeu0Gz0ivXF+M94DxQsw76gyjKJ3
         m3Xbz/qVgYr70U1w8i2lvQpVEqLAHmlsNZbezd4lScG2/4X2Z/yAjju6+10iy1H4iWy5
         Upd6EaJRHHPe0tt4h8VpLWOve9Y3eSn9W2dSaONjT/Lahhqr+xR8RZ8ySyxu64jXkm4H
         YhmINy7NsjrIUwblLlotvAvnKptLSxLmFqLYdIQVb16GJ5nM6ibC/y1gs/z2L9nd+1OI
         ZC4FF8GuO95WHWn1rRm+fMdYYKgJt/f/ginazdN7KqZNMV40rxXLc01JFw55h9HjJPcl
         z1Nw==
X-Gm-Message-State: ANoB5plKKwTVmTlGrzjjgyJGtrcj9MOd5+lZzNJ4kyOSEWQrqiOs8ZEA
        owQgOs95qfGQA+omDtSOb+FVvj3DU8OI0uBaLqo=
X-Google-Smtp-Source: AA0mqf49jcJyVboO+FFu4CdGEXj1OUeh9B3nBloKVWiBokj13rudzyWR/VHcd+bDDsx7bzKUoZZtLA==
X-Received: by 2002:a17:902:dacd:b0:189:6889:c309 with SMTP id q13-20020a170902dacd00b001896889c309mr54175119plx.3.1670350786288;
        Tue, 06 Dec 2022 10:19:46 -0800 (PST)
Received: from [192.168.178.38] (f215227.upc-f.chello.nl. [80.56.215.227])
        by smtp.gmail.com with ESMTPSA id fa13-20020a17090af0cd00b00218abadb6a8sm11118786pjb.49.2022.12.06.10.19.41
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 06 Dec 2022 10:19:45 -0800 (PST)
From:   Arend Van Spriel <arend.vanspriel@broadcom.com>
To:     Bitterblue Smith <rtl8821cerfe2@gmail.com>,
        JunASAKA <JunASAKA@zzy040330.moe>, <Jes.Sorensen@gmail.com>
CC:     <kvalo@kernel.org>, <davem@davemloft.net>, <edumazet@google.com>,
        <kuba@kernel.org>, <pabeni@redhat.com>,
        <linux-wireless@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Date:   Tue, 06 Dec 2022 19:19:39 +0100
Message-ID: <184e8aa3278.279b.9b12b7fc0a3841636cfb5e919b41b954@broadcom.com>
In-Reply-To: <184e897cf70.279b.9b12b7fc0a3841636cfb5e919b41b954@broadcom.com>
References: <20221129043442.14717-1-JunASAKA@zzy040330.moe>
 <9dc328a1-1d76-6b8b-041e-d20479f4ff56@gmail.com>
 <184e897cf70.279b.9b12b7fc0a3841636cfb5e919b41b954@broadcom.com>
User-Agent: AquaMail/1.40.1 (build: 104001224)
Subject: Re: [PATCH] drivers: rewrite and remove a superfluous parameter.
MIME-Version: 1.0
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="00000000000049ec2405ef2cd952"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--00000000000049ec2405ef2cd952
Content-Type: text/plain; format=flowed; charset="us-ascii"
Content-Transfer-Encoding: 8bit

On December 6, 2022 6:59:36 PM Arend Van Spriel 
<arend.vanspriel@broadcom.com> wrote:

> On November 29, 2022 3:06:37 PM Bitterblue Smith <rtl8821cerfe2@gmail.com>
> wrote:
>
>> On 29/11/2022 06:34, JunASAKA wrote:
>>> I noticed there is a superfluous "*hdr" parameter in rtl8xxxu module
>>> when I am trying to fix some bugs for the rtl8192eu wifi dongle. This
>>> parameter can be removed and then gained from the skb object to make the
>>> function more beautiful.
>>>
>>> Signed-off-by: JunASAKA <JunASAKA@zzy040330.moe>
>>> ---
>>> drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c | 5 +++--
>>> 1 file changed, 3 insertions(+), 2 deletions(-)
>>>
>>> diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
>>> b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
>>> index ac641a56efb0..4c3d97e8e51f 100644
>>> --- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
>>> +++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
>>> @@ -4767,9 +4767,10 @@ static u32 rtl8xxxu_80211_to_rtl_queue(u32 queue)
>>> return rtlqueue;
>>> }
>>>
>>> -static u32 rtl8xxxu_queue_select(struct ieee80211_hdr *hdr, struct sk_buff
>>> *skb)
>>> +static u32 rtl8xxxu_queue_select(struct sk_buff *skb)
>>> {
>>> u32 queue;
>>> + struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)skb->data;
>>>
>>> if (ieee80211_is_mgmt(hdr->frame_control))
>>> queue = TXDESC_QUEUE_MGNT;
>>> @@ -5118,7 +5119,7 @@ static void rtl8xxxu_tx(struct ieee80211_hw *hw,
>>> if (control && control->sta)
>>> sta = control->sta;
>>>
>>> - queue = rtl8xxxu_queue_select(hdr, skb);
>>> + queue = rtl8xxxu_queue_select(skb);
>>>
>>> tx_desc = skb_push(skb, tx_desc_size);
>>
>> See the recent discussion about this here:
>> https://lore.kernel.org/linux-wireless/acd30174-4541-7343-e49a-badd199f4151@gmail.com/
>> https://lore.kernel.org/linux-wireless/2af44c28-1c12-46b9-85b9-011560bf7f7e@gmail.com/
>
> Not sure why I looked but I did. You may want to look at rtl8xxxu_tx()
> which is the .tx callback that mac80211 uses and the first statement in
> there is also assuming skb->data points to the 802.11 header.

Here the documentation of the .tx callback:

@tx: Handler that 802.11 module calls for each transmitted frame.
 * skb contains the buffer *starting from the IEEE 802.11 header*.
 * The low-level driver should send the frame out based on
 * configuration in the TX control data. This handler should,
 * preferably, never fail and stop queues appropriately.
 * Must be atomic.

I don't see any pushes or pulls before the queue select so that would mean 
mac80211 is not complying to the described behavior.

Regards,
Arend

>
> Regards,
> Arend
>>




--00000000000049ec2405ef2cd952
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
bpIzNUky46LXMA0GCWCGSAFlAwQCAQUAoIHUMC8GCSqGSIb3DQEJBDEiBCBlSFpOXydLUwTPKe/9
tpt/z6MfbWOhBDyzHtXWpinWwTAYBgkqhkiG9w0BCQMxCwYJKoZIhvcNAQcBMBwGCSqGSIb3DQEJ
BTEPFw0yMjEyMDYxODE5NDZaMGkGCSqGSIb3DQEJDzFcMFowCwYJYIZIAWUDBAEqMAsGCWCGSAFl
AwQBFjALBglghkgBZQMEAQIwCgYIKoZIhvcNAwcwCwYJKoZIhvcNAQEKMAsGCSqGSIb3DQEBBzAL
BglghkgBZQMEAgEwDQYJKoZIhvcNAQEBBQAEggEA6944+6OQPpdSrm/tQp+NJi1U1fuCaFAz3+Xb
OoiqiLSKPUtYrm8aOiCpuzgx1volHxJ7BLNOBx3RJveL9/fu8EorjutG01vqyR0FGNhGJwVRUDTz
mVb8PscEz0T2w9tbO6HvYKe+fMy9dO6vXrBlGL5nnoeTni2tFvT33/2U98r1Vap00SL/mi5HTPnz
DrQviNIDL2srzpOShhX0l0k0Q6MBgxfscS8+uCTbgQEx5YkAabZbzrxI1tNW/+qYb+uriUhPH+0J
VeJAjRQ8rPc2uRkqUyvrbPl1tRtlhTT26rxxjbByrg3LSshQhtG7JvGSO+ZIjoJG0kFcyE3YQsrx
2A==
--00000000000049ec2405ef2cd952--
