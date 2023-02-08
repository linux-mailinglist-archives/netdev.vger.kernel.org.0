Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 91D7D68F482
	for <lists+netdev@lfdr.de>; Wed,  8 Feb 2023 18:28:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230475AbjBHR21 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Feb 2023 12:28:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230040AbjBHR2Y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Feb 2023 12:28:24 -0500
Received: from mail-qt1-x82a.google.com (mail-qt1-x82a.google.com [IPv6:2607:f8b0:4864:20::82a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C7662385F;
        Wed,  8 Feb 2023 09:28:01 -0800 (PST)
Received: by mail-qt1-x82a.google.com with SMTP id w3so21597240qts.7;
        Wed, 08 Feb 2023 09:28:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=R4hp0TaP328AOQEknDitR5oTvP+vmL+qudenojc4O4M=;
        b=fOmXpaFJ08QmufFCIlQp/EzdBBvL73RGDtmzx3KuHuWEtzvfFL8VlnCNmVkLc7zxoM
         9ONhUt6Pzu8q2/RCrB8PPsBq2Ms/xfqq+CyqGzOqGmJbkRaAmiC3ZvpM/YbdyRBmmObj
         p/eFaLzIOTEc07ESzGQ8FfdN6hkK6Qc2JtxUCBoEagFFI2NpN51dtndz494htn/Zdqcw
         giUH2dJN5d4UKrxbkrzk7d1a2yRWj+giz57SHS/BSjl/ODInM7Cbmc3zOlv3nBhWbv4q
         7yOlGfCCkLZ5fZ5pQvUXzwVTP0xOkF4jLViUs9DeOL3lr/IkBKBIYVKbWIgBGAhucN6I
         rkdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=R4hp0TaP328AOQEknDitR5oTvP+vmL+qudenojc4O4M=;
        b=sJeY9Hd5sF8am0Hv+NQM9qCgAKtvN27Ld7lvoJ9X+oYfhHzhgrebab/Zb9IEMs9t/x
         VArFQp8zq85ZbwaOAM9OjrR1c+glDNKTf0B+od0uRL3sO0M0NWbj66qliIkkclWaJbJU
         3swz3HQQF2PkzoGWGy16kaKYU4qApskelIhil0awJos37H7jUR59exRyl1TRW6QRO74W
         JndUeGTyYP5vTwT6fip0qFy4ykJ41V6fultSqOyyy8VfwO2Lig7hVZvHG1ha571dfSTc
         Z3nIN24fIaXy4jPpDjWOBObN34n4UCaWl+8jJllSJEU7+gyVLNbQglSXZ984rpI3HIYU
         UbSw==
X-Gm-Message-State: AO0yUKWTspFCyIqnNDqzt696cXu5ntGPJnLJVDZD1MDiEu8cskTGV52w
        Z8JbccF1l1CNmN8D0FlPetU=
X-Google-Smtp-Source: AK7set8ZWUNNGxnBWs+gOL/fUpPKHvWP3GCQxwG0JfTyVYu1PisBpksNGemUXpTtmE3MVI0XR95aGw==
X-Received: by 2002:ac8:5b85:0:b0:3b9:c074:6e3c with SMTP id a5-20020ac85b85000000b003b9c0746e3cmr15323899qta.43.1675877279772;
        Wed, 08 Feb 2023 09:27:59 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id f11-20020ac8014b000000b003b86d5c4fbbsm11836204qtg.1.2023.02.08.09.27.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 08 Feb 2023 09:27:59 -0800 (PST)
Message-ID: <d7a0be3a-85b8-b6c4-12b7-e86515d0062b@gmail.com>
Date:   Wed, 8 Feb 2023 09:27:55 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH net-next v3 2/3] net: dsa: rzn1-a5psw: add support for
 .port_bridge_flags
Content-Language: en-US
To:     =?UTF-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <clement.leger@bootlin.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Herve Codina <herve.codina@bootlin.com>,
        =?UTF-8?Q?Miqu=c3=a8l_Raynal?= <miquel.raynal@bootlin.com>,
        Milan Stevanovic <milan.stevanovic@se.com>,
        Jimmy Lalande <jimmy.lalande@se.com>,
        Pascal Eberhard <pascal.eberhard@se.com>,
        Arun Ramadoss <Arun.Ramadoss@microchip.com>,
        linux-renesas-soc@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20230208161749.331965-1-clement.leger@bootlin.com>
 <20230208161749.331965-3-clement.leger@bootlin.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20230208161749.331965-3-clement.leger@bootlin.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/8/23 08:17, Clément Léger wrote:
> When running vlan test (bridge_vlan_aware/unaware.sh), there were some
> failure due to the lack .port_bridge_flag function to disable port
> flooding. Implement this operation for BR_LEARNING, BR_FLOOD,
> BR_MCAST_FLOOD and BR_BCAST_FLOOD.
> 
> Signed-off-by: Clément Léger <clement.leger@bootlin.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian

