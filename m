Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A73A5529792
	for <lists+netdev@lfdr.de>; Tue, 17 May 2022 04:58:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239450AbiEQC6c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 May 2022 22:58:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235124AbiEQC6a (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 May 2022 22:58:30 -0400
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D31A457AC;
        Mon, 16 May 2022 19:58:29 -0700 (PDT)
Received: by mail-pl1-x631.google.com with SMTP id c9so16198552plh.2;
        Mon, 16 May 2022 19:58:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=faLUuWqqFMb/U0g6qB84DT9xyabIYZyBOuIxQwZ6/H8=;
        b=CFJg9TarOseEIQHcWL88LUiSUemdZ01+D0pWlzIZe734DP8AzoQ6rPqL1HtPwazTz0
         SR5NCXFuXLiAfbsAiaMgu03WX4BcU0KwL8ZHMft667Wa1ppJGv2ftMfaVdEWb9hEgg5p
         HjK91xL7w0mkChKAWkoduTwYGO/EfQHpe1Uor/hLwuwlQNqD3ZCbLlHDpNzhqWqEgzie
         /VhPxzImUtevN7D41S/BsXJQeHdW4Fx54atSuYF4PyNjMqBJv+x2O2XLF0BI1MX42g8K
         nvan3fUSy2mwoGJeaQuQ/er3IgKGx1LaD+JPA25cbM2nXEbO23YMjCD/FIaDsglJMwXT
         p+4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=faLUuWqqFMb/U0g6qB84DT9xyabIYZyBOuIxQwZ6/H8=;
        b=J4q7jgCAJbcdKFeDLWI00nCDbtlyOeqrI5xi+DCfBJSC3/d5pOHeN50Cq4cBkahNIL
         mAtX4Yk3xR4/WGvsavupDmffXSaJYqsXGT7SLAWFHHg9jflmm3Yhc+OCpyTzlAS7NtGV
         Cc75hJqeKh5kOOBLLhB1OftdT+ZsWDmFr6kMNivqrztDiMJbPpgtwvAmWIJb7YHVKp/e
         7CKDVkmwZZbZcMCzW3r27pZCKzA+dQZW7UXplg0YHnMW7r6edt9RL1ypDOW9yH6SMcun
         uV6WB6FTux+CidkzC+Wi5xN+JDEC4NZ2QBU+GyLrIGoBhyuJ9g9hAoc4gpZQAslWzjWH
         +2Hg==
X-Gm-Message-State: AOAM532CveVTqpgYeq7498lAHpt6E55Ttz76gqTkJJXgE3kFFptUVGXn
        9Pxd7kUP9t+U7HfcRhg5VBQ=
X-Google-Smtp-Source: ABdhPJyMmQGt8Tz9eL0rHITDniA5qSyOWKKYaVlss/7zliTtFwkc+mChQGx4M66Cf1KB50R9wGSz5Q==
X-Received: by 2002:a17:90a:9282:b0:1dc:4a1b:ea55 with SMTP id n2-20020a17090a928200b001dc4a1bea55mr22523656pjo.24.1652756308607;
        Mon, 16 May 2022 19:58:28 -0700 (PDT)
Received: from [192.168.1.3] (ip72-194-116-95.oc.oc.cox.net. [72.194.116.95])
        by smtp.gmail.com with ESMTPSA id q16-20020a170902edd000b0015f3d8759e4sm7709213plk.167.2022.05.16.19.58.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 16 May 2022 19:58:28 -0700 (PDT)
Message-ID: <e701d41b-0ad3-1f96-14ee-12fb26c127b0@gmail.com>
Date:   Mon, 16 May 2022 19:58:26 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
Subject: Re: [RFC Patch net-next v2 9/9] net: dsa: microchip: remove unused
 members in ksz_device
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
 <20220513102219.30399-10-arun.ramadoss@microchip.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20220513102219.30399-10-arun.ramadoss@microchip.com>
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
> The name, regs_size and overrides members in struct ksz_device are
> unused. Hence remove it.
> And host_mask is used in only place of ksz8795.c file, which can be
> replaced by dev->info->cpu_ports
> 
> Signed-off-by: Arun Ramadoss <arun.ramadoss@microchip.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
