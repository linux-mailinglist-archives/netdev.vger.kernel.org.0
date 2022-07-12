Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5D2A4572634
	for <lists+netdev@lfdr.de>; Tue, 12 Jul 2022 21:44:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234558AbiGLToq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jul 2022 15:44:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234522AbiGLToe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Jul 2022 15:44:34 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11966A8502;
        Tue, 12 Jul 2022 12:30:03 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id o5-20020a17090a3d4500b001ef76490983so9541117pjf.2;
        Tue, 12 Jul 2022 12:30:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=gOuGCRXwXiKyEi+q6f/kQQx9V+X4ZNqMLyhvYkRh6Dg=;
        b=U5wwcc01n56/WMcID8mlSqCHdRYXvlMU0BnIcGzbNLWScZAFtQrxqVsYkF6u75+b8R
         oHoSdOu6eg1JJVjPSBTYJU/BzlyV5NexFEYX+iMbyAoyRRNFeqBH5Bi4edWOmdmucMtN
         68Ig+F1bPClhb8t/5UWST7RlS/9T10HG8dPGs7cLQCr7faHzbsx/EDfWJMd5oqvIcJHh
         wBKQB5hU2Zu1aDQ4r1aD3xrujbHAdDrRwNcvq2ya5Okdg/kJigzw2xx9j4QqO4kaRX0B
         YmCHk1sDNfGkkipfqPlETC6Pro9uDsJpHzzFXELSUS0ikWxu3aIIWHUFb68/WdII6wp5
         Y04g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=gOuGCRXwXiKyEi+q6f/kQQx9V+X4ZNqMLyhvYkRh6Dg=;
        b=dV6ywInQEgPrIMWEulsnchuYaId9JNZCidrFXwD6calHKaPmF4RLAkbUcQETA+4uYL
         K7DMDx97HN+VhGR38h57OvGM83meTdJt9j/FFM+4nokq0ClTk/ikDlstUEYlLCIKTFXL
         ohXHJT/bE6a8GIM8zbYe/XUTunEjsf3LPSye0snPHlPFyb2xL8yBy66hGBppSTCTJhOZ
         yzSwqx+wvG1AtysSstJMn3vn5sdXUPhrbDvP/3BGIrPKUj94LKoFWESW+EWBDoZgygky
         qQnzF56li5nMwhDdhkpXx0ZIKjI2XJmMQHJO4UAA9BK8R0Ngx09+lUdCowupPASzorf8
         wV+Q==
X-Gm-Message-State: AJIora/YQP3ZmFhzdHwnFNlRih65cHLO96/ovO/xW3pdFZM4N3mJfs1s
        3m+D0Ws9EPeQaSkAGJliX2HwDeJ4+eA=
X-Google-Smtp-Source: AGRyM1sqZciOWjaiqOg8mSRtp60vBzpnGxY8KjIXuMkQA6I4VvZHJnQIzCvWvf6wdGWSgdFJ0QX02w==
X-Received: by 2002:a17:903:11c6:b0:167:90e5:59ac with SMTP id q6-20020a17090311c600b0016790e559acmr25790396plh.143.1657654202526;
        Tue, 12 Jul 2022 12:30:02 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id bf19-20020a656d13000000b004168945bdf4sm2605870pgb.66.2022.07.12.12.30.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 12 Jul 2022 12:30:02 -0700 (PDT)
Message-ID: <b3c1d411-34c5-197c-5643-6fe4c4ee3723@gmail.com>
Date:   Tue, 12 Jul 2022 12:30:00 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: [PATCH stable 4.14 v3] net: dsa: bcm_sf2: force pause link
 settings
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, Doug Berger <opendmb@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org,
        olteanv@gmail.com, andrew@lunn.ch
References: <20220708001405.1743251-1-f.fainelli@gmail.com>
 <20220708001405.1743251-2-f.fainelli@gmail.com> <Ys3JIVVpKvEts/Am@kroah.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <Ys3JIVVpKvEts/Am@kroah.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/12/22 12:18, Greg Kroah-Hartman wrote:
> On Thu, Jul 07, 2022 at 05:14:05PM -0700, Florian Fainelli wrote:
>> From: Doug Berger <opendmb@gmail.com>
>>
>> commit 7c97bc0128b2eecc703106112679a69d446d1a12 upstream
>>
>> The pause settings reported by the PHY should also be applied to the
>> GMII port status override otherwise the switch will not generate pause
>> frames towards the link partner despite the advertisement saying
>> otherwise.
>>
>> Fixes: 246d7f773c13 ("net: dsa: add Broadcom SF2 switch driver")
>> Signed-off-by: Doug Berger <opendmb@gmail.com>
>> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
>> Link: https://lore.kernel.org/r/20220623030204.1966851-1-f.fainelli@gmail.com
>> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
>> ---
>> Changes in v3:
>>
>> - gate the flow control enabling to links that are auto-negotiated and
>>    in full duplex
>>
> 
> Are these versions better / ok now?

Vladimir "soft" acked it when posting the v3 to v2 incremental diff here:

https://lore.kernel.org/stable/20220707221537.atc4b2k7fifhvaej@skbuf/

so yes, these are good now. Thanks and sorry for the noise.
-- 
Florian
