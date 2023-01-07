Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 06D9C660FA4
	for <lists+netdev@lfdr.de>; Sat,  7 Jan 2023 15:53:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231809AbjAGOxg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 Jan 2023 09:53:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230298AbjAGOxe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 7 Jan 2023 09:53:34 -0500
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 130EE3D5F0;
        Sat,  7 Jan 2023 06:53:33 -0800 (PST)
Received: by mail-ej1-x635.google.com with SMTP id qk9so9687305ejc.3;
        Sat, 07 Jan 2023 06:53:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=W0kQdEWzRpszG8s93+6SCtv6ZFhZz1XMPwhp4yY8Nt0=;
        b=o7+jcXXYD57KsUrkWZfu+BXXBBmYh1iSJ/u+jLNtUeOKvgEtEXAberPDm73JjJFy6/
         vjuA0udOQUwPKFKZ+tejxT3baUhHQigvpA7lUYksVrw6fL1dS6ecMFOhmDNqJvD8LI7G
         aa8/57IOiiFb3HWXbjMgEjDfP5VGA8dv2ZpQ9fPPnH5AehjUrRZufTQMcZzQRQf3yB0P
         bABgyCIl6zmiimkYNNuWYdY/A92Zh971B6dnbRzPWqEvzd6PKlp8v2xgxb5prxHtC3tV
         E4KxJs9QZzHwnmquy39yTQaKlD8Vg17Mr7+6Tgtev3u/PxV1lqzh1jsg/mbU9bEmBt2X
         4yOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=W0kQdEWzRpszG8s93+6SCtv6ZFhZz1XMPwhp4yY8Nt0=;
        b=yObUyWfkUkk4/GYnDa9NgWYlkvsSGVbrGQq2WkSohYHgWBPUpyRlB4b4qa27HzBr/i
         aO1kzEpC25pWO3UrQIyKqqYBhzzC4OaBFQ+cJbgz/eKRm9qbKBZhBKcl2l5oPZpBqZZd
         r8srqPgcOSh1lcU2pkZ1J9goII8505r8ZNZ1+FZvPMjcjWpGgWOnF2lhgEnNC60CtYv5
         aYjJNaM0xHWswZDGb0Q0vab7F23chn9x9UGZYzGSjVJ+Pp3PzOtdKoLs0tmG5FaGM3LE
         aPSOUOxzttC6OOep+ZN//cukGFVA1tXRTNWgBM2gUnrLdG4jK6V7ZRHfWdjTdYqYUAIq
         fIyg==
X-Gm-Message-State: AFqh2kqrLuUdXtLueiclJMoKJr1rH0YqJVHMS9g3TZ3TDJcZUpN/2Wcx
        V3xWh00ddhtHtr8uUN+C5fE=
X-Google-Smtp-Source: AMrXdXus3hVj1/+R5sPy7RVf+N6SWVxEiqYjmF7uGL7atpt8Vbkp9zi2N/QrBORdjW68/z6WHa0brA==
X-Received: by 2002:a17:906:c0ce:b0:7c1:6151:34c0 with SMTP id bn14-20020a170906c0ce00b007c1615134c0mr46524675ejb.6.1673103211624;
        Sat, 07 Jan 2023 06:53:31 -0800 (PST)
Received: from [192.168.1.50] ([79.119.240.114])
        by smtp.gmail.com with ESMTPSA id b6-20020a17090630c600b007c0d0dad9c6sm1513827ejb.108.2023.01.07.06.53.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 07 Jan 2023 06:53:31 -0800 (PST)
Message-ID: <85019785-dc58-0826-8362-cd2deca6a32e@gmail.com>
Date:   Sat, 7 Jan 2023 16:53:29 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.3
Subject: Re: [RFC PATCH v1 19/19] rtw88: Add support for the SDIO based
 RTL8821CS chipset
To:     Larry Finger <Larry.Finger@lwfinger.net>,
        Chris Morgan <macroalpha82@gmail.com>,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Cc:     linux-wireless@vger.kernel.org,
        Yan-Hsuan Chuang <tony0620emma@gmail.com>,
        Kalle Valo <kvalo@kernel.org>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-mmc@vger.kernel.org, Nitin Gupta <nitin.gupta981@gmail.com>,
        Neo Jou <neojou@gmail.com>, Pkshih <pkshih@realtek.com>,
        Jernej Skrabec <jernej.skrabec@gmail.com>
References: <20221227233020.284266-1-martin.blumenstingl@googlemail.com>
 <20221227233020.284266-20-martin.blumenstingl@googlemail.com>
 <63b4b3e1.050a0220.791fb.767c@mx.google.com>
 <0acf173d-a425-dcca-ad2f-f0f0f13a9f5e@gmail.com>
 <2b839329-7816-722d-cb57-649fc5bf8816@lwfinger.net>
Content-Language: en-US
From:   Bitterblue Smith <rtl8821cerfe2@gmail.com>
In-Reply-To: <2b839329-7816-722d-cb57-649fc5bf8816@lwfinger.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 04/01/2023 22:14, Larry Finger wrote:
> On 1/4/23 13:59, Bitterblue Smith wrote:
>> I tested with https://github.com/lwfinger/rtw88/ which should have the
>> same code as wireless-next currently.
> 
> I just rechecked. My repo was missing some changes from wireless-next. It now matches.
> 
> Larry
> 
> 
Did you mean to push some commits? The latest one is still from December.
