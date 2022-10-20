Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9421D606211
	for <lists+netdev@lfdr.de>; Thu, 20 Oct 2022 15:45:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229501AbiJTNpg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Oct 2022 09:45:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229777AbiJTNpa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Oct 2022 09:45:30 -0400
Received: from mail-wm1-x333.google.com (mail-wm1-x333.google.com [IPv6:2a00:1450:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B432F88A39;
        Thu, 20 Oct 2022 06:45:25 -0700 (PDT)
Received: by mail-wm1-x333.google.com with SMTP id 186-20020a1c02c3000000b003c6c154d528so2361772wmc.4;
        Thu, 20 Oct 2022 06:45:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6To4dqhauA/lNuhZyK3fZtVSZbHxlKTu7B0L5LEK/Yo=;
        b=CzlLc1mjdc+QchcuDhLaaelFcrROLlu4x7FS9NFybcqcK8EAFZrjWi+DWHJDza4G1H
         TrPzzWUKo19v67l4zT/DWiI0XmYlpYMtvQ267/VC+YcLsrHYOWFMN+c+AEr8X4sgdlj9
         1cRPsuBYg8n80NtO+MHCXVFk+Rt4mZTVpn6WwjXmmIVFYPDmmAzraV69k4NuhpUXlxIz
         3jDaU9QZypNNSM4/mZ5N0NYcEdE1wPjYWfG48XNJCe8tEJFW/CpK840/X4+AXfJCNEDc
         OjIELKUFc3GprMUa5OeukbxTWzQeCE9DT+A+sMaj2o/7ip3hHcDMieTwC9dG3eRLRpMJ
         ZIvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=6To4dqhauA/lNuhZyK3fZtVSZbHxlKTu7B0L5LEK/Yo=;
        b=bhoo2i3HpNjWk4Eaa+Bt+Mb40NMWK2sISpetQJDBgYwGQLfMNkP+19KKhgjsQYLMLS
         Cn6v9M09Kl5+Z4UA9ZNkwk5wKdgXMsdS/6eM//aLkQr0rdjIAvX21JyCUCF/IElWgO0n
         7GZIwCE7BeeWfBuRFC52jX5hsuLvDQEEZ647dsfS4ECHf/bU8pIV8LOO/aAjAfMeDjfp
         WuhifzaSOUJ4L8ZCmJmFLUNGSpci1yKUC7/sOqBGVqUKcDsCw8CAFd6omstDRi3QlR4l
         htjf0/xRlIHl43ADuJUDfcdd3N2cikgGB5mWF3Pmwo2bnlwJjC7wQRMZZpM8fzEhr98J
         ElXw==
X-Gm-Message-State: ACrzQf1fOH7l+kYwjvFzmrYtEH+GVqPMlR/6cYrV7rmr1PT1aphUm+si
        W93m/qbY5XwA2/bS4dB3SSM=
X-Google-Smtp-Source: AMsMyM76T/qopuD0DaE6ZJN9tzIHPuUatWBeKmIGrdkD0rnWEouWSaE+JVHoBokPUiZ7yvTzg/L6Zw==
X-Received: by 2002:a1c:2743:0:b0:3b3:4066:fa61 with SMTP id n64-20020a1c2743000000b003b34066fa61mr31145675wmn.79.1666273524099;
        Thu, 20 Oct 2022 06:45:24 -0700 (PDT)
Received: from [192.168.0.210] (cpc154979-craw9-2-0-cust193.16-3.cable.virginm.net. [80.193.200.194])
        by smtp.googlemail.com with ESMTPSA id k33-20020a05600c1ca100b003c6cd82596esm3110001wms.43.2022.10.20.06.45.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 20 Oct 2022 06:45:23 -0700 (PDT)
Message-ID: <01410678-ab7d-1733-8d5a-e06d1a4b6c9e@gmail.com>
Date:   Thu, 20 Oct 2022 14:45:22 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.1
Content-Language: en-US
To:     =?UTF-8?Q?Tomislav_Po=c5=beega?= <pozega.tomislav@gmail.com>
Cc:     Stanislaw Gruszka <stf_xl@wp.pl>,
        Helmut Schaa <helmut.schaa@googlemail.com>,
        Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
From:   "Colin King (gmail)" <colin.i.king@gmail.com>
Subject: re: wifi: rt2x00: add TX LOFT calibration for MT7620
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

I noticed a signed / unsigned comparison warning when building 
linux-next with clang. I believe it was introduced in the following commit:

commit dab902fe1d29dc0fa1dccc8d13dc89ffbf633881
Author: Tomislav Požega <pozega.tomislav@gmail.com>
Date:   Sat Sep 17 21:28:43 2022 +0100

     wifi: rt2x00: add TX LOFT calibration for MT7620


The warning is as follows:

drivers/net/wireless/ralink/rt2x00/rt2800lib.c:9472:15: warning: result 
of comparison of constant -7 with expression of type 'char' is always 
false [-Wtautological-constant-out-of-range-compare]
         gerr = (gerr < -0x07) ? -0x07 : (gerr > 0x05) ? 0x05 : gerr;
                 ~~~~ ^ ~~~~~
drivers/net/wireless/ralink/rt2x00/rt2800lib.c:9476:15: warning: result 
of comparison of constant -31 with expression of type 'char' is always 
false [-Wtautological-constant-out-of-range-compare]
         perr = (perr < -0x1f) ? -0x1f : (perr > 0x1d) ? 0x1d : perr;
                 ~~~~ ^ ~~~~~

The variables gerr and perr are declared as a char, which in this case 
seems to be defaulting to signed on the clang build for x86-64 and hence 
this warning. I suspect making it signed char will do the trick, but I 
wanted to flag this up in-case there were some other issues with making 
them signed.

Colin
