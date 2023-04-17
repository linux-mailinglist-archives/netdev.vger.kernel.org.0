Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8E3356E493D
	for <lists+netdev@lfdr.de>; Mon, 17 Apr 2023 15:04:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231389AbjDQNEC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Apr 2023 09:04:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230143AbjDQNDn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Apr 2023 09:03:43 -0400
Received: from mail-qt1-x833.google.com (mail-qt1-x833.google.com [IPv6:2607:f8b0:4864:20::833])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D190211B8F;
        Mon, 17 Apr 2023 06:00:43 -0700 (PDT)
Received: by mail-qt1-x833.google.com with SMTP id l11so25473482qtj.4;
        Mon, 17 Apr 2023 06:00:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681736365; x=1684328365;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=CyYBTz03mfBLsJW8tiSqcSJkgsMmOf2d9JitR3jDZRQ=;
        b=r+VRtoi03bmQ5p20OJ90kKWilYyIpAzVZvNdW9lzekBxS3Mrby3BBBEewCAElenD9j
         mfolNc6N5M0XJk4Xpalmp8DZibj7JUdMj9xzAn3yMfU8xRcz2uitanFH4aLjlZ6qg2L5
         R9NIbbFDkSIL7mj7HqETvoHCnD8OPBrTqmJI8bKqLMrRoz5ptF8WgBy0ET4d5VekxSJx
         hb6Y9k2ffYpR9FySnyFy9aTSxIX9mNydYMEGtRb+5DmFaJQ8eejwBkf5524VIz3POitV
         BQNHc55vrH7w5hziTwj2LcscPiHJRGC7HAXKcvW6+e6t+UMzqelBX+hr4pKkeMEy+o+g
         w6Kw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681736365; x=1684328365;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=CyYBTz03mfBLsJW8tiSqcSJkgsMmOf2d9JitR3jDZRQ=;
        b=SgDfbS3Gcw3rBhvNnTzdF9FOO6AkCFy35fF9yYZig9xHKFGnPwCBZlqGtF05t0+HIP
         ynWKONmruEwZYte62g1qWrHm4rb+5WvEbyz1rBJN+hJkbh40U2MyBRl2ngD8gZ1gnHo6
         mDpLbfpyLytH/j0WXg1OJiYtX9FHYH42vT2w5+COaPgtjphW1EfPfANtD+Xiblt1Azhk
         l+hC6la1KOks8mDsvSYM6sE+kiZiTNk9cz9dj01/6VG622/3PbJwYxnwkIoOT5+oillr
         s1EFShx9pBGZz7XNK2RpYNnJCABh1+FJhj+OiW8IKeurcVSsF6heCxJK9oMzxcSwloce
         E8Bg==
X-Gm-Message-State: AAQBX9fKCpn5Z5YJJ4rXcOQrOno8KjoVZGAhtFPDdAq/ZKD662BLfVYO
        srYH8eZxbX3NT1M86egJYr8=
X-Google-Smtp-Source: AKy350bJ3sUiNQ+coMBpfLT9WdwtF6WidiVq9lfTADsSJCkXLEc/ADKRro0sVhf1ZIKipDUbp4F3SQ==
X-Received: by 2002:ac8:5b01:0:b0:3e3:86d4:5df0 with SMTP id m1-20020ac85b01000000b003e386d45df0mr21939463qtw.55.1681736364763;
        Mon, 17 Apr 2023 05:59:24 -0700 (PDT)
Received: from [192.168.1.105] (ip72-194-116-95.oc.oc.cox.net. [72.194.116.95])
        by smtp.gmail.com with ESMTPSA id t13-20020a05620a0b0d00b007426e664cdcsm3101839qkg.133.2023.04.17.05.59.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 17 Apr 2023 05:59:24 -0700 (PDT)
Message-ID: <4f09dad9-eb49-4a26-7237-79b1ec171486@gmail.com>
Date:   Mon, 17 Apr 2023 05:59:21 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH net-next 3/7] net: mscc: ocelot: optimize ocelot_mm_irq()
Content-Language: en-US
To:     Vladimir Oltean <vladimir.oltean@nxp.com>, netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        linux-kernel@vger.kernel.org
References: <20230415170551.3939607-1-vladimir.oltean@nxp.com>
 <20230415170551.3939607-4-vladimir.oltean@nxp.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20230415170551.3939607-4-vladimir.oltean@nxp.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 4/15/2023 10:05 AM, Vladimir Oltean wrote:
> The MAC Merge IRQ of all ports is shared with the PTP TX timestamp IRQ
> of all ports, which means that currently, when a PTP TX timestamp is
> generated, felix_irq_handler() also polls for the MAC Merge layer status
> of all ports, looking for changes. This makes the kernel do more work,
> and under certain circumstances may make ptp4l require a
> tx_timestamp_timeout argument higher than before.
> 
> Changes to the MAC Merge layer status are only to be expected under
> certain conditions - its TX direction needs to be enabled - so we can
> check early if that is the case, and omit register access otherwise.
> 
> Make ocelot_mm_update_port_status() skip register access if
> mm->tx_enabled is unset, and also call it once more, outside IRQ
> context, from ocelot_port_set_mm(), when mm->tx_enabled transitions from
> true to false, because an IRQ is also expected in that case.
> 
> Also, a port may have its MAC Merge layer enabled but it may not have
> generated the interrupt. In that case, there's no point in writing to
> DEV_MM_STATUS to acknowledge that IRQ. We can reduce the number of
> register writes per port with MM enabled by keeping an "ack" variable
> which writes the "write-one-to-clear" bits. Those are 3 in number:
> PRMPT_ACTIVE_STICKY, UNEXP_RX_PFRM_STICKY and UNEXP_TX_PFRM_STICKY.
> The other fields in DEV_MM_STATUS are read-only and it doesn't matter
> what is written to them, so writing zero is just fine.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
