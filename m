Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 90DA9287D81
	for <lists+netdev@lfdr.de>; Thu,  8 Oct 2020 22:54:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728833AbgJHUyY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Oct 2020 16:54:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725882AbgJHUyY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Oct 2020 16:54:24 -0400
Received: from mail-ed1-x543.google.com (mail-ed1-x543.google.com [IPv6:2a00:1450:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7305C0613D2
        for <netdev@vger.kernel.org>; Thu,  8 Oct 2020 13:54:23 -0700 (PDT)
Received: by mail-ed1-x543.google.com with SMTP id 33so7171325edq.13
        for <netdev@vger.kernel.org>; Thu, 08 Oct 2020 13:54:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=N3Jho3iwITPtL0KLezyuFs3CjfZDF/9f1vMr3Rswfa0=;
        b=gHmJSsTQWm1jSBMnlT6CXBwQxeK/ACOixsjgLkN4E8UzUDixWXD1R+CuKadq+FLVq2
         fdpHp5PMoU2JZgE35Am/0cApYGqBEJ9Y4rCebT3eHxIJDOI6Wpfg0edi4LUv1kMbC4eQ
         3iq0U2MNzUec0l7QOoYjj0D3En2exkKYWDyDrUEdhSQpzmfFKpfSLDHWNI43tMiEFLwh
         1eCLiyvhgEa4T+LQFgJwtTzv65Oqsa2lPVcdx4q6VaNfVUmOFmS92Ee37lkXy8u4drox
         2yxa2AdnlDWpOUdAEim0gHGuSCUAu/T+LANYgB7QYbvUuxx5ZlvCIpl+LOQzTu53yDeN
         V1Kw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=N3Jho3iwITPtL0KLezyuFs3CjfZDF/9f1vMr3Rswfa0=;
        b=JTpMHFnuPKsrXaUwFzaHeLgCLuFGnrUADv/RVWxSb3Tv5u0grnzY4EqFGG7ZBbaclL
         O4YxzPk3dItsEsPYDCtMxtdL+mHHOmWSySKJ0DIMkyM0zq9b3zKFKrgDWMcoXCkY1R8e
         O+MAVtQ57c0naZXTgnUOmq8sYJBdV5L+3oQWYu5xrLc9nIkOcCk3Jx/jBM3/BtX4voyD
         20N9DBzO9bezuXQuhCs0f7sarAT3B6ynmO26QcB+i6JsHg1iir/wH6BY9/ZhPZvns4IS
         JEsVNPzWp+MEFfwOs3gG3JFs+d/4bSOUpKW3+CJRjz0IgAVkyA2kLFYETDFJHU91h6Bq
         qVjA==
X-Gm-Message-State: AOAM533FVvB73rjuDZCiaDsDJjuJGUpa5yK7zazfK6eVPftJSgV7U/El
        8uIUJE4BKV73zSdjIfwRagaZxthvDLsDfw==
X-Google-Smtp-Source: ABdhPJwiLfgrRrau+S7tXVF5TC8OYVnoKDgKqjfCA8c5hq+DOTAXcq9HzngFCehGjCVO4L9ezM4jYQ==
X-Received: by 2002:a50:d987:: with SMTP id w7mr11026091edj.113.1602190462344;
        Thu, 08 Oct 2020 13:54:22 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f00:6a00:28bc:8b04:587d:85d4? (p200300ea8f006a0028bc8b04587d85d4.dip0.t-ipconnect.de. [2003:ea:8f00:6a00:28bc:8b04:587d:85d4])
        by smtp.googlemail.com with ESMTPSA id bu23sm4792682edb.69.2020.10.08.13.54.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 08 Oct 2020 13:54:21 -0700 (PDT)
Subject: Re: [Bug 209423] WARN_ON_ONCE() at rtl8169_tso_csum_v2()
To:     Eric Dumazet <eric.dumazet@gmail.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <bug-209423-201211-atteo0d1ZY@https.bugzilla.kernel.org/>
 <80adc922-f667-a1ab-35a6-02bf1acfd5a1@gmail.com>
 <CANn89i+ZC5y_n_kQTm4WCWZsYaph4E2vtC9k_caE6dkuQrXdPQ@mail.gmail.com>
 <733a6e54-f03c-0076-1bdc-9b0d4ec1038c@gmail.com>
 <CANn89iJ2zqH=_fvJQ8dhG4nBVnKNB7SjHnHDLv+0iR7UwgxTsw@mail.gmail.com>
 <b6ff841a-320c-5592-1c2b-650e18dfe3e0@gmail.com>
 <CANn89iJ2KxQKZmT2ShVZRTjdgyYkF_2ZWBraTZE4TJVtUKh--Q@mail.gmail.com>
 <9e4b2b1f-c2d9-dbd0-c7ce-49007ddd7af2@gmail.com>
 <CANn89iJwwDCkdmFFAkXav+HNJQEEKZsp8PKvEuHc4gNJ=4iCoQ@mail.gmail.com>
 <77541223-8eaf-512c-1930-558e8d23eb33@gmail.com>
 <CANn89i+dtetSScxtSRWX8BEgcW_uJ7vzvb+8sW57b7DJ3r=fXQ@mail.gmail.com>
 <dbad301f-7ee8-c861-294c-2c0fac33810a@gmail.com>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <186242a7-4e63-dccc-0879-1069823f079a@gmail.com>
Date:   Thu, 8 Oct 2020 22:54:17 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.1
MIME-Version: 1.0
In-Reply-To: <dbad301f-7ee8-c861-294c-2c0fac33810a@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 08.10.2020 21:07, Eric Dumazet wrote:
> 
> 
> On 10/8/20 8:50 PM, Eric Dumazet wrote:
>>
>>
>> OK, it would be nice to know what is the input interface
>>
>> if4 -> look at "ip link | grep 4:"
>>
>> Then identifying the driver that built such a strange packet (32000
>> bytes allocated in skb->head)
>>
>> ethtool -i ifname
>>
> 
> According to https://bugzilla.kernel.org/show_bug.cgi?id=209423
> 
> iif4 is the tun200 interface used by openvpn.
> 
> So this might be a tun bug, or lack of proper SKB_GSO_DODGY validation
> in our stack for buggy/malicious packets.
> 
> 

Following old commit sounds like it might be related:
622e0ca1cd4d ("gro: Fix bogus gso_size on the first fraglist entry")

This code however was removed later in 58025e46ea2d ("net: gro: remove
obsolete code from skb_gro_receive()")
