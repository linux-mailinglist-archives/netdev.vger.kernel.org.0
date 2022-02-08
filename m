Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 41AC94ACF73
	for <lists+netdev@lfdr.de>; Tue,  8 Feb 2022 04:03:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345987AbiBHDDN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Feb 2022 22:03:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235819AbiBHDDN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Feb 2022 22:03:13 -0500
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7D60C06109E;
        Mon,  7 Feb 2022 19:03:12 -0800 (PST)
Received: by mail-pl1-x62d.google.com with SMTP id 10so4788360plj.1;
        Mon, 07 Feb 2022 19:03:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=0+mBN1AmLET/4AWuwi279kZh4WBQoV2qr8xQgbK7dyw=;
        b=iTR3btbEUnM+VlxH6jri6OtRajozWOPjq3m/KyhRRZ68cv8qz9WnrCWUvXJtvSoKnN
         qne93/BcNauuIj2qYJAfjIu8X3q6+EzPxp7Qow1iJo3ZTBhwyOrAAgq++gx+LqcYe4fI
         GrQB4jkb2SmRCLLyRYJEXV45Is1RaKU9UwhuF80/hoPqIz7YZCsIGnH5Ge+28/hGlW3G
         Twz/jliaTZ/TBRLMo9ouWDFiyAxChKszBQWikrsHvWchIDsqe5NlqmF5bC9rVXtyRdt7
         4weqXPYzWJCLOqKV1veCQjFuIXkGVvT6gpQHnXKE5uJtEDViyHyh2haNCKyGUVRMDqMh
         ZqHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=0+mBN1AmLET/4AWuwi279kZh4WBQoV2qr8xQgbK7dyw=;
        b=7FllE6HqyNvfHZwk9nKn1wD7Wiq3QCSwAjXDgtBR6MxEU7yeSEyKfQmiXFNPK5weQF
         CfqKwfqAtSF/VJF1IayEGzrsGpj49JhP1NOybxREvICrjsFSGgedYe36hMNb2L4dlgNA
         G16rKM8oqb/lfykG3OWghyeBIE8r/l8lEY5F2vXwwxKTBMyt3aaSHDDLlneu6UP7XRrU
         l7JayoWjVrHsycFfX9AMJFJ8rw87/R8AhI5Tgq0zo37X07KqJIyjCjFXa9YB7v766Tns
         g3AZWcjH1v2mEihnOlCG1bkQDXtY1Kf8ieVRK1cFBlTke0AvaUYTEiQJgudvUKVQj/0r
         79oQ==
X-Gm-Message-State: AOAM531pYjO8r61tUzdGuW44LgmQ7lyp9gParyaeBnKHhO0jH0swIXRC
        tSW/mNpmiQjECdKXPBxj1Yk=
X-Google-Smtp-Source: ABdhPJyv8GenpLh00FFuo/gsVJ9piqXeOgNLBsSWk61QagXTM00iwCs/02YmMz0xT5j0o75fyhD8pQ==
X-Received: by 2002:a17:903:2412:: with SMTP id e18mr2486323plo.74.1644289392151;
        Mon, 07 Feb 2022 19:03:12 -0800 (PST)
Received: from [192.168.1.3] (ip72-194-116-95.oc.oc.cox.net. [72.194.116.95])
        by smtp.gmail.com with ESMTPSA id k22sm13887682pfu.210.2022.02.07.19.03.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 07 Feb 2022 19:03:11 -0800 (PST)
Message-ID: <5e913295-bace-f097-05fc-aa910b5d4f4c@gmail.com>
Date:   Mon, 7 Feb 2022 19:03:09 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.1
Subject: Re: [PATCH v8 net-next 07/10] net: dsa: microchip: add support for
 ethtool port counters
Content-Language: en-US
To:     Prasanna Vengateshan <prasanna.vengateshan@microchip.com>,
        andrew@lunn.ch, netdev@vger.kernel.org, olteanv@gmail.com,
        robh+dt@kernel.org
Cc:     UNGLinuxDriver@microchip.com, woojung.huh@microchip.com,
        hkallweit1@gmail.com, linux@armlinux.org.uk, davem@davemloft.net,
        kuba@kernel.org, linux-kernel@vger.kernel.org,
        vivien.didelot@gmail.com, devicetree@vger.kernel.org
References: <20220207172204.589190-1-prasanna.vengateshan@microchip.com>
 <20220207172204.589190-8-prasanna.vengateshan@microchip.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20220207172204.589190-8-prasanna.vengateshan@microchip.com>
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
> Added support for get_eth_**_stats() (phy/mac/ctrl) and
> get_stats64()
> 
> Reused the KSZ common APIs for get_ethtool_stats() & get_sset_count()
> along with relevant lan937x hooks for KSZ common layer and added
> support for get_strings()
> 
> Signed-off-by: Prasanna Vengateshan <prasanna.vengateshan@microchip.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
