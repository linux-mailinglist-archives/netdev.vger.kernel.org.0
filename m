Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C0512605404
	for <lists+netdev@lfdr.de>; Thu, 20 Oct 2022 01:37:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231777AbiJSXhQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Oct 2022 19:37:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231226AbiJSXhO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Oct 2022 19:37:14 -0400
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF9781CF56D;
        Wed, 19 Oct 2022 16:37:06 -0700 (PDT)
Received: by mail-pg1-x531.google.com with SMTP id 78so17645796pgb.13;
        Wed, 19 Oct 2022 16:37:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=gxwOkr2sbt9Ku+GvYa22/rMbCgAwd24FdOiu35P0uoQ=;
        b=UChISMd5pGB+Lk2wNEmXVXniV1uLC7k9QCxzp0KUZvDW1L9LoGRcN3C2mMO6eDpDyd
         V3TdshPC8loYHwC6xjqPXb0EfaLCRg9zOESW5GW993HLlblfgUbSdMUUBMDFhJEyUm02
         NdKz/Kbt7BBzFiKsgv8WntzkwqXw0DnwF0LQSJlSv6v8j8KEQksaq5sVOL9vFxeW53Iq
         ftCZ5wjG7GUXkZeqlXly6YfA8nwYqJdUDMjzcQ858IUpBbgNQd5o8R8CNRcxYVXMwYOu
         25cxRtfF/uTOy5RhBPpzyjHkGu3jziSYUJGiZQObkIzbknueOtH9gTyVmHT9Txelsn5S
         Ce0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=gxwOkr2sbt9Ku+GvYa22/rMbCgAwd24FdOiu35P0uoQ=;
        b=MADaUitMiZbqkGTKXbRRAcohQM1v8PbZO7LzbXfh2UjkIZd+Rd6SmL8HvCdgzB0xKF
         1uP2DoUFo5k8Ye9a3fs/koLa1EWSoDWwYCJO7ADvru0oHwx7DMRGVmfCs8SmBOV4C7zd
         8+3cj4hpX/Y8Iy69/sdhwTZ6Qh60frPPoaDvfINEd8SJyp51rJ8ZUxxjQXIz3woe8ePd
         qZOomJFaefZUVJ9Ea0A+08FC48vSfG2AIqz16GaPeLh44C6Au+V8lZxKaKcNYdj3U2xZ
         PRZlRdx/s8K1y8pdI5VCFmwJnKrWuzT9pnkRAONviSUEekg5Scb0IO10sXAGtWlTrKCr
         C71w==
X-Gm-Message-State: ACrzQf1hKewFm0Fgcq2UMZf7ZDggmG7vydnmljqBiC9jHzZTTV1LZOd0
        4+r+A4tBCr9SEcccqzbiZx8=
X-Google-Smtp-Source: AMsMyM6IU1c1qFj+JI+Nm1xFEY3GU6JEIXtMZwAwJW2xtOzKCj8Ctdr+CWOGP2AOMcfWmW1radJQ6A==
X-Received: by 2002:a63:6986:0:b0:43c:8417:8dac with SMTP id e128-20020a636986000000b0043c84178dacmr9252828pgc.286.1666222625634;
        Wed, 19 Oct 2022 16:37:05 -0700 (PDT)
Received: from ?IPV6:2600:8802:b00:4a48:8d6a:5f0b:fdeb:b03? ([2600:8802:b00:4a48:8d6a:5f0b:fdeb:b03])
        by smtp.gmail.com with ESMTPSA id l8-20020a170903120800b0016c09a0ef87sm11500031plh.255.2022.10.19.16.37.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 19 Oct 2022 16:37:04 -0700 (PDT)
Message-ID: <527fe1c9-fcaf-af0f-1b5b-aee46afe56f9@gmail.com>
Date:   Wed, 19 Oct 2022 16:37:03 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.3
Subject: Re: [PATCH v2] net: macb: Specify PHY PM management done by MAC
Content-Language: en-US
To:     Sergiu Moga <sergiu.moga@microchip.com>,
        nicolas.ferre@microchip.com, claudiu.beznea@microchip.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, linux@armlinux.org.uk,
        tudor.ambarus@microchip.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20221019120929.63098-1-sergiu.moga@microchip.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20221019120929.63098-1-sergiu.moga@microchip.com>
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



On 10/19/2022 5:09 AM, Sergiu Moga wrote:
> The `macb_resume`/`macb_suspend` methods already call the
> `phylink_start`/`phylink_stop` methods during their execution so
> explicitly say that the PM of the PHY is done by MAC by using the
> `mac_managed_pm` flag of the `struct phylink_config`.
> 
> This also fixes the warning message issued during resume:
> WARNING: CPU: 0 PID: 237 at drivers/net/phy/phy_device.c:323 mdio_bus_phy_resume+0x144/0x148
> 
> Depends-on: 96de900ae78e ("net: phylink: add mac_managed_pm in phylink_config structure")
> Fixes: 744d23c71af3 ("net: phy: Warn about incorrect mdio_bus_phy_resume() state")
> Signed-off-by: Sergiu Moga <sergiu.moga@microchip.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>

Makes me realize we need to do the same in DSA, I will cook a patch soon.
-- 
Florian
