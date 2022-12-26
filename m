Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4C7A5656029
	for <lists+netdev@lfdr.de>; Mon, 26 Dec 2022 06:38:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229574AbiLZFic (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Dec 2022 00:38:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229725AbiLZFia (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Dec 2022 00:38:30 -0500
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E33B51158;
        Sun, 25 Dec 2022 21:38:29 -0800 (PST)
Received: by mail-pl1-x636.google.com with SMTP id m4so9961067pls.4;
        Sun, 25 Dec 2022 21:38:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=C9UL5PzFOOGW4/NCRSzTRf0U1wfV3DdpEx4KSO+HqV4=;
        b=Ruzz8jmDDMvJyMambUI6owQOEDgIGVFL7OewuvmMVabMGrnAwOCtUyodNkAaBXsqb+
         V9D6e2mw943AA69TuwlgpQQhVB0QcoT1I8sIFNz+US8UT1U1JsaNfB7M/UvAJjI1YffN
         P9srBdlYtTomMk7qrEkY2WCqmM2Aa675VU5hizW8kAN49bsLsc7l18frz+XJxNKsfeke
         yFh83PY+9ENCo5asaQIjvqj/kJ9YBgTr3c/whyWM/dx0OhViITS6EPHdV7tBsMo72E8S
         d0Q8+FAXBDjgWottuPkoW7cskiUXVKJCuesjIDlWYIgWZtZHzco+7f5j3ECn3bJACwaG
         A+Ow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=C9UL5PzFOOGW4/NCRSzTRf0U1wfV3DdpEx4KSO+HqV4=;
        b=wrhpNZIwwAmjC6bFHgux0Ayr2cNBGCKMcmrJcfPTvth+Y5wnfsymXtp8f326fb4aJl
         4g1lkVKiARJVBbSp25zrNWxQF8kKxlNj71KTjw94Y7TdD1RoL7m6EbWa4zrWcHA1SWMz
         2g5RpR8eufvAQ0OCEgv4fAmJr5r0U2CLC97w8+zv+Iut/8UYSpRcE2jwlTHZiBaJcaWa
         Tp07Fj8LfWrsUI61d5fpOzV5tzYWw7T/JFvo8mC14tWA5odh0kmWuXrvxl7ddDcGi7mv
         yj0wnrnJo9/wUx/HsJPMuM6IzacUFAdyVaqLvhHYo+9UHUBalHmCKomZ6I6hQ5Ith3Vp
         kn4Q==
X-Gm-Message-State: AFqh2kr/jU9HoiS/jbpwE19g0QsvQo/6iKg8qK68u10fm+ZZHGXERPcy
        XriTgpEJxC+cOAJEbNHd6IsHfwSl6oGrbQ==
X-Google-Smtp-Source: AMrXdXsY7fkJLqpkE1ZS9Dod0OqjlWbnIPwfvf11NYO3D7lWgMgMmEXgePMSPSXAru23psAVF/X8AA==
X-Received: by 2002:a17:902:b418:b0:191:1fc4:5c14 with SMTP id x24-20020a170902b41800b001911fc45c14mr17985443plr.49.1672033109273;
        Sun, 25 Dec 2022 21:38:29 -0800 (PST)
Received: from [192.168.1.5] ([110.77.216.213])
        by smtp.googlemail.com with ESMTPSA id t6-20020a170902e84600b00188ea79fae0sm6199995plg.48.2022.12.25.21.38.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 25 Dec 2022 21:38:28 -0800 (PST)
Message-ID: <859a548e-299a-fbd4-1f48-44347eedef0f@gmail.com>
Date:   Mon, 26 Dec 2022 12:38:25 +0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH 1/3] USB: serial: option: Add generic MDM9207
 configurations
Content-Language: en-US
To:     Matthew Garrett <mjg59@srcf.ucam.org>
Cc:     johan@kernel.org, bjorn@mork.no, netdev@vger.kernel.org,
        linux-usb@vger.kernel.org, Matthew Garrett <mgarrett@aurora.tech>
References: <20221225205224.270787-1-mjg59@srcf.ucam.org>
 <20221225205224.270787-2-mjg59@srcf.ucam.org>
 <10cff30a-719d-f6b0-419c-36c552f4bc4b@gmail.com>
 <20221226020823.GA10889@srcf.ucam.org> <20221226024307.GA12011@srcf.ucam.org>
From:   Lars Melin <larsm17@gmail.com>
In-Reply-To: <20221226024307.GA12011@srcf.ucam.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/26/2022 09:43, Matthew Garrett wrote:
> On Mon, Dec 26, 2022 at 02:08:23AM +0000, Matthew Garrett wrote:
> 
> Ah, it looks like the qcmdm driver is actually just an alias for the
> serial interface, so including that here seems reasonable. I've only
> included devices I can verify, but if you like I can just turn the whole
> .inf data into IDs here?

Yes the WIN qcmdm driver is a serial driver but with dial-up support, in 
linux we use the option driver and ModemManager will handle the dial-up.
So for your v2 of the patch you only need to remove the blacklisting of 
interfaces #1 and #3 respectively and all should be good.






