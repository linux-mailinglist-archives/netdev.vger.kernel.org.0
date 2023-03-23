Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 98E076C7141
	for <lists+netdev@lfdr.de>; Thu, 23 Mar 2023 20:45:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230122AbjCWTpv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Mar 2023 15:45:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229794AbjCWTpu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Mar 2023 15:45:50 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 744CA4C0D;
        Thu, 23 Mar 2023 12:45:49 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id q102so7927790pjq.3;
        Thu, 23 Mar 2023 12:45:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679600749;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=scGhH/8uMpMaiyxf6GoFDh2Y2DKNOkTn17AsfyY10OM=;
        b=fMbn2LmQu4CTtlM4zsVbm2a1p7G3o6gcJLnk6l8nYC1+Ots11dkQOZfG3dVaqtI21I
         ifEUmcIHvdakrLAIMUgtMzTEE7sTYB14MJTWBrnuD3CNIFGXoqnPlWzdilSPpgp++lk5
         ywkmvTXkacMJmCGYTXJRaKL/6X1gFAGzpFE+A3SqMr2c/18cOzeGqE+HOGiGFfVgEv1t
         7v4HNq4OZFumPziXo5NE0WdeGnHVu7UXv0L3q7Fm8mVO+IXCZ2vNIN6CkstbCUK9TZUu
         grvdaYKheha9ysDajXIW2+Z5wLeYTJGEUFgjmbDOmNjCEGQbjoMS2XNghTnNCTeRgyEW
         4ztw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679600749;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=scGhH/8uMpMaiyxf6GoFDh2Y2DKNOkTn17AsfyY10OM=;
        b=aiboe9Xkha9U8f+Umg9E3nW9mq4bO71sbzxbfHdwDtRN1EB+p08XP/k6kAzZgWUbjL
         EI6E+pSRwGdbEYWomXZN2sc/+9fiagId9Ob+HQ0647yg0eDdjKZ9DwZbdkVlBwHk53aR
         bi5VjDf/ns66xhExGAVL4x/1pKCquByppTeBQZbzTGC9pZPc/VZQ5utS+w4zb/MkM9Ur
         zVxUZmwFzO23+HwYs7hSTEVkXXVQBPUJD/DZGDeUve8+oFSYBON6ChzwCpWfguw7IGbp
         aoEUMwqVdGg2mYl3TVNZpD7DIZD+zPWROyf8I/OE/QliHTkJbpBO8p4ViGT5U9hqkCPa
         7kWQ==
X-Gm-Message-State: AAQBX9f8oULaxbjjM241XwFVPZDSxboFRENsjZLnzYxE2sZYok0FNCz0
        L6CeI2BoU3OjtNRG4ZBk1Dk=
X-Google-Smtp-Source: AKy350YvYQ/UpGJbJCoZnsEa7m98HRS33ViA5R5mVJSltZjV2+3Uz3gIcPCkij0Y/zQHmdgwoP1/zQ==
X-Received: by 2002:a17:90a:190f:b0:233:c301:32b3 with SMTP id 15-20020a17090a190f00b00233c30132b3mr224053pjg.3.1679600748701;
        Thu, 23 Mar 2023 12:45:48 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id y2-20020a17090a474200b0023377b98c7csm1590010pjg.38.2023.03.23.12.45.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 23 Mar 2023 12:45:48 -0700 (PDT)
Message-ID: <b8bdf893-8ed3-f13d-a92c-040f6ceabaae@gmail.com>
Date:   Thu, 23 Mar 2023 12:45:16 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH 0/1] net: dsa: b53: mmap: add dsa switch ops
Content-Language: en-US
To:     =?UTF-8?Q?=c3=81lvaro_Fern=c3=a1ndez_Rojas?= <noltari@gmail.com>
Cc:     jonas.gorski@gmail.com, andrew@lunn.ch, olteanv@gmail.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, linux@armlinux.org.uk, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20230323170238.210687-1-noltari@gmail.com>
 <95eb709c-a91f-4390-30b2-9e81e4534e20@gmail.com>
 <CAKR-sGd2oi9jpAG=X1n5JgnC0RR1u1w9vkrDsfeTB7u5OhWXug@mail.gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <CAKR-sGd2oi9jpAG=X1n5JgnC0RR1u1w9vkrDsfeTB7u5OhWXug@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/23/23 12:42, Álvaro Fernández Rojas wrote:
> El jue, 23 mar 2023 a las 19:19, Florian Fainelli
> (<f.fainelli@gmail.com>) escribió:
>>
>> On 3/23/23 10:02, Álvaro Fernández Rojas wrote:
>>> B53 MMAP switches have a MDIO Mux bus controller which should be used instead
>>> of the default phy_read/phy_write ops used in the rest of the B53 controllers.
>>> Therefore, in order to use the proper MDIO Mux bus controller we need to
>>> replicate the default B53 DSA switch ops removing the phy_read/phy_write
>>> entries.
>>
>> Did you try to implement b53_mmap_ops::phy_read16/phy_write16 and have
>> them return -EIO such that you do not fallback to the else path:
> 
> Actually I tried -EINVAL and it didn't work, but I've just tried -EIO
> and it works!
> Many thanks for the suggestion!
> 
> I will send another patch adding phy_read/write ops and returning
> -EIO, so please ignore this patch and sorry for the noise, but it took
> a while until we reached a good solution for this :(...

No worries, -EIO works because it is treated specially through the PHY 
library to indicate a read error occurred, whereas the other return 
codes do not necessarily produce that effect.

Thanks for your persistence!
-- 
Florian

