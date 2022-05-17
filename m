Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CEFDF529781
	for <lists+netdev@lfdr.de>; Tue, 17 May 2022 04:54:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233942AbiEQCyC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 May 2022 22:54:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229622AbiEQCx6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 May 2022 22:53:58 -0400
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4654D45512;
        Mon, 16 May 2022 19:53:57 -0700 (PDT)
Received: by mail-pf1-x42e.google.com with SMTP id v11so15713165pff.6;
        Mon, 16 May 2022 19:53:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=sQrtKVm2TgfC/Z0d0IoghgZQfJs0ardDjmW5CHPL6EE=;
        b=cQpxDR8lehFXIKNPRXTM/OLuNmbHg9eDM/0jzSpm1xD2/lBUjgACnWKegEl2+yRY0l
         FLuh2jJWso0fdjAP3yO87QLgQi675iH+V9Ux9LhlluyaZWtVK5INm8ImRLyiqwmBVkS1
         wqPmJHL54qe4RnQKkkmNIIwo3ffkmFctXK8zp0+scyIOK/0XGrKerDm3HF7spyNiGW23
         zUK/vtwxUnmyfoVTFjQIEChInhNFGC6hrMg/grBD3hxtU1e4hz06PEiqIGnAdXHDSH2n
         4PqgDpEPLHazJrBCY47IcNInSlvMk55BhKQiqLBJ2ZqMTxGRTXWrCeY5Re4fU1cIgNd8
         A7KA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=sQrtKVm2TgfC/Z0d0IoghgZQfJs0ardDjmW5CHPL6EE=;
        b=SZP1B5gj7j7lOLKH8/oOjZYe9PchSvps2eVQxh6hBV6Ex95VwId4HP/7fBACS6TPrU
         YZnW0D4Ur5FL7sF/s4mvyxnimdv6nrdKFxS2G+tzYgeuVRffJCeYHpSgT19NlvzzbEW1
         4rrpuFH8DwiiGmbPS9fmm816zIf5JrvrcWeIOsf8lHv9bIbGyLv/r0eCNvAEyLTAx3ax
         HvsCtQ8Uy80of0bimGy9bUDiWS4sQ7nHXkjhYC/W0kcC5h26vXFLozGWfTk/sXpxR07S
         Z6WPkkprJzRhAFc0TFjTSsQcGGAT3lmmnmQ5phuu6mnHEqdB8M4dPvsuL4ZgzRw8UaO3
         9ydQ==
X-Gm-Message-State: AOAM530YEFUn6UNe5a2o9s+IZhf9tLihbtbscrbtL4J3HhY5gJyfdJnl
        BS2jEGpRVKeFvVAMRjvKp5o=
X-Google-Smtp-Source: ABdhPJyXEmwguzhcfnSm2V0f+bBLPdlPhV/moJjoaPR4N1kij5Ek607f8Vjk/e7oa4mOWMhmW/FNNw==
X-Received: by 2002:a63:1347:0:b0:3f2:8963:ca0a with SMTP id 7-20020a631347000000b003f28963ca0amr2556632pgt.424.1652756036723;
        Mon, 16 May 2022 19:53:56 -0700 (PDT)
Received: from [192.168.1.3] (ip72-194-116-95.oc.oc.cox.net. [72.194.116.95])
        by smtp.gmail.com with ESMTPSA id jg10-20020a17090326ca00b0015eb6d49679sm4987102plb.62.2022.05.16.19.53.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 16 May 2022 19:53:56 -0700 (PDT)
Message-ID: <7af2f8f7-665b-d78d-7747-be6c840194b9@gmail.com>
Date:   Mon, 16 May 2022 19:53:54 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
Subject: Re: [RFC Patch net-next v2 1/9] net: dsa: microchip: ksz8795: update
 the port_cnt value in ksz_chip_data
Content-Language: en-US
To:     Arun Ramadoss <arun.ramadoss@microchip.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Cc:     Russell King <linux@armlinux.org.uk>,
        Woojung Huh <woojung.huh@microchip.com>,
        UNGLinuxDriver@microchip.com, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Oleksij Rempel <linux@rempel-privat.de>,
        Marek Vasut <marex@denx.de>,
        Michael Grzeschik <m.grzeschik@pengutronix.de>,
        Eric Dumazet <edumazet@google.com>
References: <20220513102219.30399-1-arun.ramadoss@microchip.com>
 <20220513102219.30399-2-arun.ramadoss@microchip.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20220513102219.30399-2-arun.ramadoss@microchip.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/13/2022 3:22 AM, Arun Ramadoss wrote:
> The port_cnt value in the structure is not used in the switch_init.
> Instead it uses the fls(chip->cpu_port), this is due to one of port in
> the ksz8794 unavailable. The cpu_port for the 8794 is 0x10, fls(0x10) =
> 5, hence updating it directly in the ksz_chip_data structure in order to
> same with all the other switches in ksz8795.c and ksz9477.c files.
> 
> Signed-off-by: Arun Ramadoss <arun.ramadoss@microchip.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
