Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AFCE9A611A
	for <lists+netdev@lfdr.de>; Tue,  3 Sep 2019 08:13:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726946AbfICGNu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Sep 2019 02:13:50 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:40632 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725878AbfICGNu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Sep 2019 02:13:50 -0400
Received: by mail-wr1-f67.google.com with SMTP id c3so16018099wrd.7;
        Mon, 02 Sep 2019 23:13:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=empVtvEx6pDVT5ENsHzRlwPA+mxpcVViT9/7IGzqxCw=;
        b=gL4pS1x54DZxWW4miqt/kKn4qepS4++BA54/8kpLBWo9AlDViATDSEXs0aEo8Wcwd0
         ZRQG0G8cIvW2ujXNywia/By2NMJszN59oMV2SvpYMKbvYKj+eppXvb0CEUCwtabtpUbK
         +uRIEY2CFkW4RxGHECWa/RINC/EYWtF7BvIq3yA+VaHejuiq+GbmYpq4WFGZZJMx5nUQ
         LBvPSbFQNIpGTAp/SH18T5q552YhV3/bU7Jr/KkGuYY1yd+g05EPULKG/xTYp+Rdwm2Q
         3RPS+rLQ/woRMl36TpeGOU0PKVk5Ir/BE1baoWQjdHwiMoTyMkOKu2KIl5yCN0ajBObC
         abZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=empVtvEx6pDVT5ENsHzRlwPA+mxpcVViT9/7IGzqxCw=;
        b=Y0UiqejEYPMA7XXvVG9ojOU5XifMYqkeRbABsryL6YrP/DwabhqVxcw0fiazkaV0Oz
         FuSZ3AERVWCWJdI2mw4XVmYFL6ONDL4iJJif360rIWoqf9nMRDc9i2Lhhm0kaknb/2DV
         jWPKyYWSfXI1CKGApfd6Wbqn36UARrG3cTxnanjYgn/7e4KkU1VRC5EXZTUYCzvKveQC
         hH1A/UeEbcT52RSTABhjcN6fj4thnBKOMFj+jG43jEn3yrkYGnpZUL/GSryQkSzOWy4O
         AIe36xkO3t7Klq8msv+hJLiAx9Nb2jxkRqPXgLB5V7Vwe5lWHne24snqBH3XB4Uh2Xpk
         jrwg==
X-Gm-Message-State: APjAAAVbzVAjVyV26NTMCOuuxR77s9Imxdor/+G4ZWO2P6SDNsygs2B2
        tJy/tG6M5vDZEy744rcBHiLVM5Sc
X-Google-Smtp-Source: APXvYqyidkaIBWeokEwUvUdm2z7JJtEyzifdyUQL8jBcD3bXgJ/UVJN5NyXFOagfYKiXbYwVWT0g0Q==
X-Received: by 2002:a5d:428c:: with SMTP id k12mr6012125wrq.196.1567491227920;
        Mon, 02 Sep 2019 23:13:47 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f04:7c00:f018:f11c:b684:4652? (p200300EA8F047C00F018F11CB6844652.dip0.t-ipconnect.de. [2003:ea:8f04:7c00:f018:f11c:b684:4652])
        by smtp.googlemail.com with ESMTPSA id l20sm16190210wrb.61.2019.09.02.23.13.46
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 02 Sep 2019 23:13:47 -0700 (PDT)
Subject: Re: [PATCH net-next] r8152: modify rtl8152_set_speed function
To:     Hayes Wang <hayeswang@realtek.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Cc:     nic_swsd <nic_swsd@realtek.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <1394712342-15778-326-Taiwan-albertk@realtek.com>
 <280e6a3d-c6c3-ef32-a65d-19566190a1d3@gmail.com>
 <0835B3720019904CB8F7AA43166CEEB2F18DAB41@RTITMBSVM03.realtek.com.tw>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <aa9513ff-3cef-4b9f-ecbd-1310660a911c@gmail.com>
Date:   Tue, 3 Sep 2019 08:13:42 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <0835B3720019904CB8F7AA43166CEEB2F18DAB41@RTITMBSVM03.realtek.com.tw>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 03.09.2019 05:16, Hayes Wang wrote:
> Heiner Kallweit [mailto:hkallweit1@gmail.com]
>> Sent: Tuesday, September 03, 2019 2:37 AM
> [...]
>> Seeing all this code it might be a good idea to switch this driver
>> to phylib, similar to what I did with r8169 some time ago.
> 
> It is too complex to be completed for me at the moment.
> If this patch is unacceptable, I would submit other
> patches first. Thanks.
> 
My remark isn't directly related to your patch and wasn't
meant as an immediate ToDo. It's just a hint, because I think
using phylib could help to significantly simplify the driver.

> Best Regards,
> Hayes
> 
> 
Heiner
