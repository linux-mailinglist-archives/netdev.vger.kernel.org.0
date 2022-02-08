Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 876374ACF49
	for <lists+netdev@lfdr.de>; Tue,  8 Feb 2022 03:58:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346271AbiBHC6J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Feb 2022 21:58:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231955AbiBHC6I (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Feb 2022 21:58:08 -0500
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6EF8EC061355;
        Mon,  7 Feb 2022 18:58:07 -0800 (PST)
Received: by mail-pj1-x1034.google.com with SMTP id ki18-20020a17090ae91200b001b8be87e9abso633956pjb.1;
        Mon, 07 Feb 2022 18:58:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=PsxFbDSNZpcmTWdPPUN2ubBjBHt1BmUNOa7pdHIl9Mw=;
        b=cxhN56UzIkk3/riQammDVj5UrW9BJKAVVSVT6UpMhgozg62JaDp3AuntV6fGmwm+3j
         HOKlesYtObZSWCYqKAKGp7/GhfJ9tLbTB3uDszoNc7CFDPMPKpQXo/mGMnYEk1v3RDmX
         wvi+BnLW4OciI1cJ0vy3SRACodDXXmqMRVqXnaMkdFVumYKC22KeuwYiklrIKcPAMcA5
         rqvf4YOzzmrN9rCdoU+FcvwmHoGpoSMO9Asmo7OgOHfFjQQG3lLMofCxVy+HmbzbFQj1
         2EKuBmjuq8lYKnApBnK1FNbWFf96MWrDguEEbZecsy7D2a1iEpQujrdatUKn4VLT5hX+
         XsiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=PsxFbDSNZpcmTWdPPUN2ubBjBHt1BmUNOa7pdHIl9Mw=;
        b=Rsc5I0swD8W2d1NJc7lsAv/TlWI6Eyvq3KPqUU8HIP0sS7FrZnmiNIQitVURl5Ob5w
         CQ62eBh+cbJPsVF9lvvbPRCmpJ0rIMX+RGP95vk4bjNZor/U0U93c6J+L8SPAUbaeYTM
         AZyDpOtkK0hzFeOcpurBGJOlKvyM+7D6ik/rqKRKaHUwOW+R/DFeM1iOrHVjJ1aBMbwN
         9y+Mwb0wwGlF4RhtnWlnO3joI7BOT3UXkQ5xtImjSDa+leKWRnoLRiL5TSHBNJg+0Rtu
         Eqi2FeNoy9PTVboB1b4xV8qv9wj0vX8EF4o+7vIPXznmBU+/uT/M4f8X8pXU1+qZWPW1
         XRQQ==
X-Gm-Message-State: AOAM531l/sn4f/l/oXLjFUaqpQVV1eCNmGpbOHHnAZoEDcnZJFEWk6wg
        CGxwDuakoW6rBTNsoz5kWnQ=
X-Google-Smtp-Source: ABdhPJyUI4ouCTpVRF2nnm+Plx9CMBupCNydX9ZAikZ8jgpIdAx7sIl4oCxweW4CCKAnp4QLqLeH2A==
X-Received: by 2002:a17:902:6a81:: with SMTP id n1mr2232499plk.105.1644289086915;
        Mon, 07 Feb 2022 18:58:06 -0800 (PST)
Received: from [192.168.1.3] (ip72-194-116-95.oc.oc.cox.net. [72.194.116.95])
        by smtp.gmail.com with ESMTPSA id j14sm13855391pfj.218.2022.02.07.18.58.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 07 Feb 2022 18:58:05 -0800 (PST)
Message-ID: <a25c41ac-22fe-2142-5939-44d5fa288b79@gmail.com>
Date:   Mon, 7 Feb 2022 18:58:04 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.1
Subject: Re: [PATCH v8 net-next 08/10] net: dsa: microchip: add support for
 port mirror operations
Content-Language: en-US
To:     Prasanna Vengateshan <prasanna.vengateshan@microchip.com>,
        andrew@lunn.ch, netdev@vger.kernel.org, olteanv@gmail.com,
        robh+dt@kernel.org
Cc:     UNGLinuxDriver@microchip.com, woojung.huh@microchip.com,
        hkallweit1@gmail.com, linux@armlinux.org.uk, davem@davemloft.net,
        kuba@kernel.org, linux-kernel@vger.kernel.org,
        vivien.didelot@gmail.com, devicetree@vger.kernel.org
References: <20220207172204.589190-1-prasanna.vengateshan@microchip.com>
 <20220207172204.589190-9-prasanna.vengateshan@microchip.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20220207172204.589190-9-prasanna.vengateshan@microchip.com>
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



On 2/7/2022 9:22 AM, Prasanna Vengateshan wrote:
> Added support for port_mirror_add() and port_mirror_del operations
> 
> Sniffing is limited to one port & alert the user if any new
> sniffing port is selected
> 
> Signed-off-by: Prasanna Vengateshan <prasanna.vengateshan@microchip.com>
> Reviewed-by: Vladimir Oltean <olteanv@gmail.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
