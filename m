Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CA15750D5FA
	for <lists+netdev@lfdr.de>; Mon, 25 Apr 2022 01:43:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239907AbiDXXcZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 Apr 2022 19:32:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233814AbiDXXcY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 24 Apr 2022 19:32:24 -0400
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9A236FA3C
        for <netdev@vger.kernel.org>; Sun, 24 Apr 2022 16:29:22 -0700 (PDT)
Received: by mail-pl1-x62a.google.com with SMTP id n18so23275078plg.5
        for <netdev@vger.kernel.org>; Sun, 24 Apr 2022 16:29:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=Xxt7noOFsIghmKsywfr9vzVHQI9XGxdBhk4i+2voOIg=;
        b=mvYfCsavZ2jy90Ss+VthjSkscM1Sugk20JxlIeuVHpQ1AuUpHvJpejOjX+Et0geshh
         6hXOMmHv9Fe+tNFle+34l2hYA9/9czR3PWrPKw78oZlhC4mS7jk6OcQSVYLARTw0paJr
         QTao15vFDY4hJNgW53FNSXy+C1lwa65HjrEjan6TesoqniBFxtGCB6l7rBJPjUrh1jdI
         Ws7avXB3aVfmWDzxg/OMSK8F1hNTTWAtNAqSsD5S62sLoQveJfZ3pu0kKNWh/DxiHxQG
         /+BGycHX4ibS+VgbHwfj9Mm4BprynOtA90zxLVrkI3f0InXen5295QbwuGZJ4xQxflSQ
         52dw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=Xxt7noOFsIghmKsywfr9vzVHQI9XGxdBhk4i+2voOIg=;
        b=ctBw/qVfUt0xFofolob3QfGkflDRvgM6RK1bup+tEVYsEhbb5KJ/XsjaFJBaw0HlF2
         uMffFa0QEmUXovGjZEheI2z/SyeflExajPiRMRw20il4o17XJ4Jf8UfDmj6yQtbJBDCm
         A71ACPOnZsfnLTxvIb0qlfwrPi+HlK+/uL+psL/cFIJacQdpUN/jfVT/k5rUZ5vh4H8Q
         BeFnyAiZprFLNCh5mG2SLxv2gmoJWM2eYkFZ+9fO2s+hHYz2vtdHnvSXRKJh4ULcp1fH
         FpfRz1EKkh17xJT1rvqOvKuZQToaomIf/SO0qbIiCxmhp+KAKjwJmfGTqi59khq09ONw
         9mCQ==
X-Gm-Message-State: AOAM531ivfYH5Jbih8HF4VFseQ8V1zrJGKWLyDVB9b6vA2uQcIz+aXJc
        3SjmrBHSv0nl+t20O65UvaI=
X-Google-Smtp-Source: ABdhPJzQwJq2Vt69g8o332MpJ44QQ/DSKqwIi6tLB4ChphaXzGES9dvfnZV997LwE7B2R+2LE3uhTg==
X-Received: by 2002:a17:90a:730c:b0:1d9:3f5:9a00 with SMTP id m12-20020a17090a730c00b001d903f59a00mr12592811pjk.109.1650842962299;
        Sun, 24 Apr 2022 16:29:22 -0700 (PDT)
Received: from [192.168.1.3] (ip72-194-116-95.oc.oc.cox.net. [72.194.116.95])
        by smtp.gmail.com with ESMTPSA id p64-20020a622943000000b004fdd5c07d0bsm8985801pfp.63.2022.04.24.16.29.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 24 Apr 2022 16:29:21 -0700 (PDT)
Message-ID: <f7fc9072-bb70-eb5e-91e0-5268ac98bd68@gmail.com>
Date:   Sun, 24 Apr 2022 16:29:20 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
Subject: Re: [PATCH net-next v1 3/4] net: phy: broadcom: Hook up the PTP PHY
 functions
Content-Language: en-US
To:     Jonathan Lemon <jonathan.lemon@gmail.com>,
        bcm-kernel-feedback-list@broadcom.com, andrew@lunn.ch,
        hkallweit1@gmail.com, linux@armlinux.org.uk,
        richardcochran@gmail.com
Cc:     netdev@vger.kernel.org, kernel-team@fb.com
References: <20220424022356.587949-1-jonathan.lemon@gmail.com>
 <20220424022356.587949-4-jonathan.lemon@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20220424022356.587949-4-jonathan.lemon@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 4/23/2022 7:23 PM, Jonathan Lemon wrote:
> Add 'struct bcm_ptp_private' to bcm54xx_phy_priv which points to
> an optional PTP structure attached to the PHY.  This is allocated
> on probe, if PHY PTP support is configured, and if the PHY has a
> PTP supported by the driver.
> 
> Signed-off-by: Jonathan Lemon <jonathan.lemon@gmail.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
