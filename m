Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8FA7C50D5E5
	for <lists+netdev@lfdr.de>; Mon, 25 Apr 2022 01:01:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239848AbiDXXEk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 Apr 2022 19:04:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233081AbiDXXEj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 24 Apr 2022 19:04:39 -0400
Received: from mail-pg1-x530.google.com (mail-pg1-x530.google.com [IPv6:2607:f8b0:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0163434B98;
        Sun, 24 Apr 2022 16:01:37 -0700 (PDT)
Received: by mail-pg1-x530.google.com with SMTP id q19so11940161pgm.6;
        Sun, 24 Apr 2022 16:01:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=s1BNXjd8cb+tHinFYr/exe+lPULhk8THSbaXt5aXW98=;
        b=ZEMy8WIbmX6koudQDZSOTIz/ULGDtpdyBocskD+NrIYVa7dxqthaXnl8dsS/WYR/5t
         89YD7+ZPOy0ocXbyU2Xko7OM+d3YSyvjHZRaZhoYHrTEvKX9FB1W5gToeSt4kY2asOR9
         QOs++We4m4SPkr6rBYWA2eTys//pGzydIeJUGXYny1hdrVuO1KIFlJih6HPAId9taQQd
         4cLVQq+y5Uujrpi8XoomSyx6GXaggCvTTZZiFQdiHyoJjbNs572zRsUHqPpTfSkA4TU6
         GCkkXY7LQ29y709+vmATdC+ojuYugXfz+WSd0ZMLeNds2ier1gG7BX0YHwOVQUv6C4rX
         ZiyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=s1BNXjd8cb+tHinFYr/exe+lPULhk8THSbaXt5aXW98=;
        b=6Xk0y2E05VN7CQEWJeP417Bbj94hLTrtbOzbE+iSNj6nIeJLkbklzU+xZhplL8nfGM
         iWdy342Sv8hB2DVhu33dSkJIg5wpqT4x/gB0LlN31+rN3mgjm1F64WOwrH6Xw5kAvicp
         k1ybeDZg+rF+BR4acbRLPtLPEPtqThA9V8lmq4ref/8W4+L+9NC71XaSdxL/eeH76ay4
         iG9yB0sKM9T1NzG6jFgX2p1lGZrZurH7hhcsuEwKT4QJeQOh3CM4UxcgR9nq7Ofox/0V
         xCiOU870d+EVsgFmYZdAzreGxxoYO/DjiB9VKkDoM60GztYCehupjKj8BzNYUJy4bEhV
         IGnA==
X-Gm-Message-State: AOAM5328n/pi4kAFjOSmMy/ijYSMA3QXHmZeItfVRltUqJeNRe64zI6K
        MZm7t6hrNHHTFTTKTXTz+LA=
X-Google-Smtp-Source: ABdhPJx+inVB7C8Y1knalNuPog1W48QrwaNzqTXZLC71TUI/pGy7qIgItp22YUYsXYl/gQfGesmReQ==
X-Received: by 2002:aa7:8385:0:b0:4f6:ef47:e943 with SMTP id u5-20020aa78385000000b004f6ef47e943mr16239456pfm.38.1650841297462;
        Sun, 24 Apr 2022 16:01:37 -0700 (PDT)
Received: from ?IPV6:2600:8802:b00:4a48:e8c2:61e6:29d3:3011? ([2600:8802:b00:4a48:e8c2:61e6:29d3:3011])
        by smtp.gmail.com with ESMTPSA id g12-20020a056a001a0c00b004e1307b249csm9555884pfv.69.2022.04.24.16.01.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 24 Apr 2022 16:01:35 -0700 (PDT)
Message-ID: <7316bb36-a5b6-b34a-1299-98605ce9d2c2@gmail.com>
Date:   Sun, 24 Apr 2022 16:01:34 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
Subject: Re: [Patch net-next] net: dsa: ksz: added the generic
 port_stp_state_set function
Content-Language: en-US
To:     Arun Ramadoss <arun.ramadoss@microchip.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Cc:     paolo Abeni <pabeni@redhat.com>, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Vladimir Oltean <olteanv@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>, UNGLinuxDriver@microchip.com,
        Woojung Huh <woojung.huh@microchip.com>
References: <20220424112831.11504-1-arun.ramadoss@microchip.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20220424112831.11504-1-arun.ramadoss@microchip.com>
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



On 4/24/2022 4:28 AM, Arun Ramadoss wrote:
> The ksz8795 and ksz9477 uses the same algorithm for the
> port_stp_state_set function except the register address is different. So
> moved the algorithm to the ksz_common.c and used the dev_ops for
> register read and write. This function can also used for the lan937x
> part. Hence making it generic for all the parts.
> 
> Signed-off-by: Arun Ramadoss <arun.ramadoss@microchip.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
