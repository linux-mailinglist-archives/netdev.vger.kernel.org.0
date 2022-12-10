Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B0DFD648B8E
	for <lists+netdev@lfdr.de>; Sat, 10 Dec 2022 01:10:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229821AbiLJAKd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Dec 2022 19:10:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229470AbiLJAKc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Dec 2022 19:10:32 -0500
Received: from mail-qv1-xf2d.google.com (mail-qv1-xf2d.google.com [IPv6:2607:f8b0:4864:20::f2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 608DE12D01;
        Fri,  9 Dec 2022 16:10:31 -0800 (PST)
Received: by mail-qv1-xf2d.google.com with SMTP id s14so4144118qvo.11;
        Fri, 09 Dec 2022 16:10:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=83yKsDDpGa+B1Yd9NVuHHt+5qk4/fmovDh0eIAQ7bps=;
        b=QFyRFap5zjKKrJKxWJeJfM0E1Lg9UOAMu58abHfgowtIE1hcv4or4BR+spy+YhkStm
         V69D9dl6n2t6lTMS0cgHQH4oVA6ggeU6l0WaZ7fMxcoAP244Leymu7omg+SAQ22sTeOJ
         gwEI04wsqUCa6J6FI+iKGR+z/OwsnUb8IGcDBShPqRCGCQeCIt3C9aziFnJT8Z9cqBZ5
         IyPSnWwdm/HbPhpADy+wc9Q8YTDWw7B9OgFUPytmXCHsLgBzTR9/oumxLJXZLxJzB6g1
         rCWuJay5czOhGhAVcV0F2vn/f7HdZHyCwFd024ZCDzDv8UBNeDqZsb02R2s5vrIqINNb
         UvdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=83yKsDDpGa+B1Yd9NVuHHt+5qk4/fmovDh0eIAQ7bps=;
        b=TQ3GRfq7nEJt7mE2fcTlaBlc1Ni8ThYw8tDRvZ8SkGr1xVDsvS2qXqJWecNKHVY7VC
         /rqQKPtC3VrA2sySdrFz1EMPUNDC84ZVC4GTR4AQotBeORN4LTHbx5J7D3Aw4eusv+nX
         zcYHoIApHgZBuea5nNEMOPC41oNUEDs01y953X94/HrF9jymdyQBqMtTa8w02Pfk/wSg
         aYGlOUQvm1xq3VdwKK8KqO27DHhd+n3R64kRQ3k5vc6qUnTFPTg9gZnai0YiqzYzxMg9
         Jfxd8KhY5ecUrCeA04zmlluJOrjf2aZenzGfDU4Q4fQfJUPGOXTu6lGgFIt+CFWGFmYY
         Rd3w==
X-Gm-Message-State: ANoB5pmkHoJaWZ5+ucwX5l7ZxjYS+FovqxZS2jBsFpQdcW+8LjvHeDB5
        TluIBiPoIi35c/1UahSGhtkWkdMjzSt+Dw==
X-Google-Smtp-Source: AA0mqf7KMKvowTK05+W8GvJbHY9krYjCC5Fh7SkVTQtQ5V5o9iJq9Rtge9BiITN+kc8CJHOrRbw1Lw==
X-Received: by 2002:ad4:43cb:0:b0:4bb:69e5:920f with SMTP id o11-20020ad443cb000000b004bb69e5920fmr8575765qvs.14.1670631030412;
        Fri, 09 Dec 2022 16:10:30 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id br20-20020a05620a461400b006faf76e7c9asm955715qkb.115.2022.12.09.16.10.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 09 Dec 2022 16:10:29 -0800 (PST)
Message-ID: <fe85438d-8774-505f-4ac2-0df1c3368f6f@gmail.com>
Date:   Fri, 9 Dec 2022 16:10:20 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [Patch net-next v3 01/13] net: dsa: microchip: ptp: add the posix
 clock support
Content-Language: en-US
To:     Arun Ramadoss <arun.ramadoss@microchip.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Cc:     woojung.huh@microchip.com, UNGLinuxDriver@microchip.com,
        andrew@lunn.ch, vivien.didelot@gmail.com, olteanv@gmail.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, linux@armlinux.org.uk,
        Tristram.Ha@microchip.com, richardcochran@gmail.com,
        ceggers@arri.de
References: <20221209072437.18373-1-arun.ramadoss@microchip.com>
 <20221209072437.18373-2-arun.ramadoss@microchip.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20221209072437.18373-2-arun.ramadoss@microchip.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/8/22 23:24, Arun Ramadoss wrote:
> From: Christian Eggers <ceggers@arri.de>
> 
> This patch implement routines (adjfine, adjtime, gettime and settime)
> for manipulating the chip's PTP clock. It registers the ptp caps
> to posix clock register.
> 
> Signed-off-by: Christian Eggers <ceggers@arri.de>
> Co-developed-by: Arun Ramadoss <arun.ramadoss@microchip.com>
> Signed-off-by: Arun Ramadoss <arun.ramadoss@microchip.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian

