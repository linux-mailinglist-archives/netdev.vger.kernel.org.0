Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DE74B624482
	for <lists+netdev@lfdr.de>; Thu, 10 Nov 2022 15:42:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229926AbiKJOmo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Nov 2022 09:42:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229566AbiKJOmn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Nov 2022 09:42:43 -0500
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF0E71DF2F;
        Thu, 10 Nov 2022 06:42:42 -0800 (PST)
Received: by mail-pl1-x636.google.com with SMTP id p21so1538431plr.7;
        Thu, 10 Nov 2022 06:42:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=7yLIZFkTSqc8JisdFlEIXj5iNq4P/8xCE6V2QPliCmE=;
        b=NF63hqIqdANdi411wVuVc/puJ88O1f4afrnaM2GxMcVxtLCFt3EBio24NSIWPGuECs
         bRUdxJY3MEe8TS+pNTU9C/y9ui7VcKnH7qd4Ti/MPwwag68fyQw3W7ah3jnSvWefZsN2
         C6jkHAFLf2IDLC1QTUzsGtLvOk8Hh7x0B8zi1GkirbiqnsxgyKjEezUjMAYqaviPNwSD
         xttVONhrARgA8EisuZvKEkI6G6zNe7ABRx6qLGdCZGbvimmtgnMRf1XyPRIlCSjK1qQw
         lMQQYU4AJr7jAKjF3xVkZ2MIdbKWZDDnh1uLO6ne5UHATqw9j0v0oEHHeZLUa7wk/sWx
         bu2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=7yLIZFkTSqc8JisdFlEIXj5iNq4P/8xCE6V2QPliCmE=;
        b=KNN7wSz8cf7evqv00xA/XRs4B3fVsHtE67gWcOOkKy/LUej4n7QdsjyZ8n8DbmRci7
         YfiCXmIDj7xrpS3JlqODiOjPVO5+9320FMf083tpExfg1itPgYqa3DymBIpD00KPI6i1
         iXUlhrymmBioirDf1QhLrY64K8UvFNXXb0NGtX4SAchE97459tAk8SP08FqoHypHxYEr
         sMaQDYAowkBjltHq/GE+vQmC9YtJJFDGuBcqi0s6yEvc0EHeg8bmGdgtn8T7W/Q/CFim
         hMGDTl+y/tg+Q24Ph5+QV6E+Fc3bVIbjSfo4OJD3LYU+v2+h0iUF/hvviKENdO3ENKdS
         QUlg==
X-Gm-Message-State: ACrzQf1v9M2MrUJUZ5QLoyfdYB3fiOHB7iTC+aOSJVInLsCI8/4yymkW
        7yQKir60/ehQ34NknLGLtk8qykC+aBQ=
X-Google-Smtp-Source: AMsMyM4GbwfWDTqDxsNtDlPRgCCm76wEiJdoPpKhw21r0AGo5eIYnud0jkFRUtaYqDQgJKeTXZo0Ug==
X-Received: by 2002:a17:903:22c7:b0:187:190d:da89 with SMTP id y7-20020a17090322c700b00187190dda89mr59358479plg.68.1668091362174;
        Thu, 10 Nov 2022 06:42:42 -0800 (PST)
Received: from ?IPV6:2600:8802:b00:4a48:c0ce:1fc9:9b4c:5c3d? ([2600:8802:b00:4a48:c0ce:1fc9:9b4c:5c3d])
        by smtp.gmail.com with ESMTPSA id b16-20020a170902d51000b0017a0f40fa19sm11384710plg.191.2022.11.10.06.42.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 10 Nov 2022 06:42:41 -0800 (PST)
Message-ID: <7472ad25-2d54-1e00-cc27-8f593cba9011@gmail.com>
Date:   Thu, 10 Nov 2022 06:42:41 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH net-next v4 2/4] net: dsa: microchip: do not store max MTU
 for all ports
Content-Language: en-US
To:     Oleksij Rempel <o.rempel@pengutronix.de>,
        Woojung Huh <woojung.huh@microchip.com>,
        UNGLinuxDriver@microchip.com, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     kernel@pengutronix.de, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Arun.Ramadoss@microchip.com
References: <20221110122225.1283326-1-o.rempel@pengutronix.de>
 <20221110122225.1283326-3-o.rempel@pengutronix.de>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20221110122225.1283326-3-o.rempel@pengutronix.de>
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



On 11/10/2022 4:22 AM, Oleksij Rempel wrote:
> If we have global MTU configuration, it is enough to configure it on CPU
> port only.
> 
> Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
