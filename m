Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8C3255E6A8F
	for <lists+netdev@lfdr.de>; Thu, 22 Sep 2022 20:20:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229835AbiIVSUK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Sep 2022 14:20:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229482AbiIVSUJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Sep 2022 14:20:09 -0400
Received: from mail-qv1-xf36.google.com (mail-qv1-xf36.google.com [IPv6:2607:f8b0:4864:20::f36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9C947C1FE
        for <netdev@vger.kernel.org>; Thu, 22 Sep 2022 11:20:07 -0700 (PDT)
Received: by mail-qv1-xf36.google.com with SMTP id l14so7415959qvq.8
        for <netdev@vger.kernel.org>; Thu, 22 Sep 2022 11:20:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date;
        bh=9VCmbbwKYqPF1B4hKj6t9vzERsFh0U8CjuzzNUkxleM=;
        b=XW+U1d7QYi6ZRi12IgdvWI63LRVwIC4kP6LdHj3ZEMbLlzZ/ROsu2qo7HAERkRNMK2
         8pw7UjXAN3Thq6eCn7siterRZHB2BUosZh4FixWdsgDjiI2qBTW9dchJr66BgzeKDbV/
         j5W6DEHncLpzDf5IZnOypIe5qhsUXYqMfAHUEsbr18qXaGrnumWZ6q+hopGxsMFKJG28
         W/1YyM6OFSahePtutDOdfh6zKg7SHRPRoor4mrw6JS6UjSVVFvQR/kfbitoxYaaiNEk6
         S1/G4zZCW9WPRHixkQCbd8f0HAhAfZpxnpKwYBE5IUsbaFy03hP+p4lEV+YSoK/st1IA
         fU7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=9VCmbbwKYqPF1B4hKj6t9vzERsFh0U8CjuzzNUkxleM=;
        b=D/6VUtdr/4/mjOUM52t/EuKh8rkpe2/O93K3CCcNMC42bHHq/LYkdemaXHpdHrq4ZV
         grqwFiPt5bcUL1EMTjMVf4aa3Q3NJTwT4HlhOehZ+eWizaJwiukyOzL67YLFN6wWKBCU
         uKNmqPRMLSdZ5hRaXMKj0OyYxyMyDA4LvmOio9CNE9sl11goUczw2SbVaoKBlv9vT6aO
         xrt1dXKHJfVPn065bhuirWtaNt+86Qx6TMHGjPUTX9FPYz0vcTfJSrQAaCObZsDSgUP4
         RhUAGW7b/ZZbzczaBoDdmRb2kN6O4Aa5xgNDtu2bueSUYZwaiVV20IwkEkQV6rOyXG8w
         lXHw==
X-Gm-Message-State: ACrzQf3knpgTylkSKzyf2uOL9sjc8uu5LFjKqs237yGllVx/uDRnMmDK
        f6mTojVF+QLR6yM7T+HSA3c=
X-Google-Smtp-Source: AMsMyM67y80jLoqJ2H7fWTxON6XiyvBaJkhW/ijqSRqE1psFEHJA+uYJhpAnEX7xLbWnzgyQN2zdBw==
X-Received: by 2002:ad4:5cec:0:b0:4ac:96fc:24e3 with SMTP id iv12-20020ad45cec000000b004ac96fc24e3mr3743415qvb.95.1663870806715;
        Thu, 22 Sep 2022 11:20:06 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id n18-20020a05622a041200b0035a71a41645sm4114622qtx.37.2022.09.22.11.20.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 22 Sep 2022 11:20:06 -0700 (PDT)
Message-ID: <f4511b75-c696-60a1-4861-9cda96531268@gmail.com>
Date:   Thu, 22 Sep 2022 11:20:02 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH net-next 02/18] net: dsa: bcm_sf2: remove unnecessary
 platform_set_drvdata()
Content-Language: en-US
To:     Yang Yingliang <yangyingliang@huawei.com>, netdev@vger.kernel.org
Cc:     andrew@lunn.ch, vivien.didelot@gmail.com, olteanv@gmail.com,
        kurt@linutronix.de, hauke@hauke-m.de, Woojung.Huh@microchip.com,
        sean.wang@mediatek.com, linus.walleij@linaro.org,
        clement.leger@bootlin.com, george.mccollister@gmail.com
References: <20220921140524.3831101-1-yangyingliang@huawei.com>
 <20220921140524.3831101-3-yangyingliang@huawei.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20220921140524.3831101-3-yangyingliang@huawei.com>
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

On 9/21/22 07:05, Yang Yingliang wrote:
> Remove unnecessary platform_set_drvdata() in ->remove(), the driver_data
> will be set to NULL in device_unbind_cleanup() after calling ->remove().
> 
> Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
