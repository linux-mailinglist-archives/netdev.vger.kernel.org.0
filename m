Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4D6E85895CF
	for <lists+netdev@lfdr.de>; Thu,  4 Aug 2022 04:05:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237163AbiHDCFI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Aug 2022 22:05:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232234AbiHDCFG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Aug 2022 22:05:06 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B7C35E31C;
        Wed,  3 Aug 2022 19:05:05 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id s5-20020a17090a13c500b001f4da9ffe5fso3806586pjf.5;
        Wed, 03 Aug 2022 19:05:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc;
        bh=5PkQwpT4/LgjhF8X0urr/pwTWSIL7+ANFY1f/pmpTJU=;
        b=jWGD5QJJ8n/1zL067iXAtkoER/WC1w5FoYPiTlvlWo2wmdHXoVQ8h4qrNwf5JI9DUs
         MWJEQTWaPTIEjEyFEk0u1FujXSbyE3bUp4HaLss93XeNzjVmkaB2Xs/ctazEhbYHfl9v
         NQP37O5yssnQcQsCXzo8CVp60WRVY+s8WLojLGMjeegJbRHBwR56ThBRGD73CrwVyCPU
         3UWU/6rxBdih1Fx35BVKe/5IW15CM13kVYzEy0TiJL8dKiQfCfejxe1UjdPmV9ibo9nF
         opFVpVRhmLCheLDwYoeP18Ze0V4dKs1fMptzNiLGGCGjt8+ThZuNOm+fhYNRHAevxwQG
         itbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc;
        bh=5PkQwpT4/LgjhF8X0urr/pwTWSIL7+ANFY1f/pmpTJU=;
        b=ZeGvH/jiORzX0e9ul05Dwt7ewUVP0ev9XST3W7vNBE9r1arTpjTibM/rRnYJyZ6ntm
         TuL3DLFZLp6M0MvuXxsrRevHcDvWI3A2E6+1hz8/LJJxgbyTo12SJE+cImVJR+WkbKS4
         26UJRlJN54NBjhY+BCKBlptd7Q7N/oL+ee1vnNKQECyUDhLSrYpM5y7rt4BZLir8yInq
         z5oKiSDC6kD1vAwymr6EBUd20ykGGfIPMYGk1Z8Lr8FVKm1MUNjoDICoXYeXRI/4XAxh
         Z+DoqlbObjCU8T8oLbYjNamzsO/i0mKI6o/t3V+rnOm8MXY540tLv53e0mYnJxxH28Kt
         yY4g==
X-Gm-Message-State: ACgBeo2ntyw4g9z7rj5P5d0dZqtBH7RtFahR6Cwv90mRHiDpLUB33sTM
        pHfkgVQLwsw/Xsj7MyqFwh0=
X-Google-Smtp-Source: AA6agR46SZDBR0veQLRuhCFSNz0kLfZfrvSVoV8tW22SArV+txrqjzRZC/sefkOdpaVCU6qcQtJ7SA==
X-Received: by 2002:a17:902:d711:b0:16d:1665:1162 with SMTP id w17-20020a170902d71100b0016d16651162mr28695888ply.5.1659578704402;
        Wed, 03 Aug 2022 19:05:04 -0700 (PDT)
Received: from ?IPV6:2600:8802:b00:4a48:4c10:50a3:f8c8:88ac? ([2600:8802:b00:4a48:4c10:50a3:f8c8:88ac])
        by smtp.gmail.com with ESMTPSA id y3-20020a17090a390300b001f3244768d4sm2270051pjb.13.2022.08.03.19.05.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 03 Aug 2022 19:05:03 -0700 (PDT)
Message-ID: <0c6b64f3-9ece-4fe7-0db7-36e2eae0698d@gmail.com>
Date:   Wed, 3 Aug 2022 19:05:02 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.1.0
Subject: Re: [Patch RFC net-next 3/4] net: dsa: microchip: common ksz pvid get
 and set function
Content-Language: en-US
To:     Arun Ramadoss <arun.ramadoss@microchip.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Cc:     Woojung Huh <woojung.huh@microchip.com>,
        UNGLinuxDriver@microchip.com, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Russell King <linux@armlinux.org.uk>
References: <20220729151733.6032-1-arun.ramadoss@microchip.com>
 <20220729151733.6032-4-arun.ramadoss@microchip.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20220729151733.6032-4-arun.ramadoss@microchip.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/29/2022 8:17 AM, Arun Ramadoss wrote:
> Add the helper function for getting and setting the pvid which will be
> common for all ksz switches
> 
> Signed-off-by: Arun Ramadoss <arun.ramadoss@microchip.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
--
Florian
