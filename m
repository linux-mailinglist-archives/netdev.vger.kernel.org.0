Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4805854FFAB
	for <lists+netdev@lfdr.de>; Sat, 18 Jun 2022 00:03:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344496AbiFQWDx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jun 2022 18:03:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235469AbiFQWDt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Jun 2022 18:03:49 -0400
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E43C2AC47;
        Fri, 17 Jun 2022 15:03:49 -0700 (PDT)
Received: by mail-pl1-x62c.google.com with SMTP id d13so4912230plh.13;
        Fri, 17 Jun 2022 15:03:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=feKpGkuywKAtf9xorq52WEpaYro1ySAtBsqG9zDe8uM=;
        b=QeXajl5NvYHI3U7g071MCmzFwu/KGzTYNogwMcCRZed4XcN6UQOJR6rz1eXPIqvHxG
         JPOqhmQx8Q4N2sRzfk2qqjHR81UabefWyfOcNNbubTfxJmwsN5M38eCfLu0kRUgGIKnj
         QozJhsgwrnex9f9CKv/PEynGYiHkRedY9mEzjAif+dzslmXZrhR53PPzMJAf4G1mfHEC
         ySbHrkTrr4gceW/+cHiesJSlqLZMvgmI81x4cDgu60Q7Bj95/Ig8M47cLfi7EX1x+140
         g7Y2EFIo4/RxN7513Lun8a/3YVIUt9RJ0O8Drx6tCdiPaItj+y6ZhQ/7qzvdxf9oEjZG
         Eufg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=feKpGkuywKAtf9xorq52WEpaYro1ySAtBsqG9zDe8uM=;
        b=MWmwHwX68QlEb+0qEFiUl4YNlOaf+NVYlhoo5FMmIDZBiPMxVB/YugWzo6eZjYLxDC
         aY7b5QjjQABu5EGkqIgJ3qzoR6tUvQziP/BnqwcGK2GxlSZ+sMhFS0jTtubWIS7sGugr
         lR+0kceZeM2K5xaeKkF0iHVE+mDm7v/1owkAEudkEMRMqytOLBnofHNuzE0BWY6ol1gN
         pTENwUrt8sRYTHWC4vyqZWiqE+pxui5izz63NzLqcBwSBJO4wQOBRHgtUovXG4THgFC7
         s3yD08KuvJ5dJzXojnVMemQ01N8luujesL0YkiM63Vk8ujSmHoyz5iheev3acAFiSoIX
         posw==
X-Gm-Message-State: AJIora/EMx2//1FidlJcEaBvAIN5x7ttQV8mbdOb8zYaBVTVtfKR8toc
        rr+AM9ISHKp1lI5Rt6tT4BU=
X-Google-Smtp-Source: AGRyM1vDU/fcRlB/iTrABf0ot4xnmqyivS7UPXjxpBsWmky43N1sA4WQP5qvWwsVllfTwWDQo9fNQg==
X-Received: by 2002:a17:90b:4d90:b0:1e8:951b:40c8 with SMTP id oj16-20020a17090b4d9000b001e8951b40c8mr13001544pjb.130.1655503428866;
        Fri, 17 Jun 2022 15:03:48 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id gp5-20020a17090adf0500b001ec84b0f199sm339080pjb.1.2022.06.17.15.03.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 17 Jun 2022 15:03:48 -0700 (PDT)
Message-ID: <edbbc05f-6aa5-be29-6cc3-2895851db717@gmail.com>
Date:   Fri, 17 Jun 2022 15:03:44 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: [Patch net-next 06/11] net: dsa: microchip: move the port mirror
 to ksz_common
Content-Language: en-US
To:     Arun Ramadoss <arun.ramadoss@microchip.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Cc:     Woojung Huh <woojung.huh@microchip.com>,
        UNGLinuxDriver@microchip.com, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Russell King <linux@armlinux.org.uk>
References: <20220617084255.19376-1-arun.ramadoss@microchip.com>
 <20220617084255.19376-7-arun.ramadoss@microchip.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20220617084255.19376-7-arun.ramadoss@microchip.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/17/22 01:42, Arun Ramadoss wrote:
> This patch updates the common port mirror add/del dsa_switch_ops in
> ksz_common.c. The individual switches implementation is executed based
> on the ksz_dev_ops function pointers.
> 
> Signed-off-by: Arun Ramadoss <arun.ramadoss@microchip.com>
> Reviewed-by: Vladimir Oltean <olteanv@gmail.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
