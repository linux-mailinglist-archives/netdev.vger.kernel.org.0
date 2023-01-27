Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 43C0767EE70
	for <lists+netdev@lfdr.de>; Fri, 27 Jan 2023 20:41:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231352AbjA0Tln (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Jan 2023 14:41:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229908AbjA0Tlm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Jan 2023 14:41:42 -0500
Received: from mail-qt1-x82b.google.com (mail-qt1-x82b.google.com [IPv6:2607:f8b0:4864:20::82b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90FE6DBEA;
        Fri, 27 Jan 2023 11:41:14 -0800 (PST)
Received: by mail-qt1-x82b.google.com with SMTP id q15so5003413qtn.0;
        Fri, 27 Jan 2023 11:41:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Tie7P8DpWVuLMjQ05PFQFoqxbFyJhXbe0tq79aNlVHc=;
        b=ihrjdm9OC16yFFyWeePT0TRmevtzAE8AkrxT5JjRYbw2KBMouT0QIsvZOlwj9xlF/O
         TXLoYrsby1wav6KdpyeDH3fMJ+Im9MTJPHhzwEZoW6tdPpPTCa2sPq422r5JZrqNYMJ1
         /A1L2bKwSxn4CPTOnKEU6NXyzzdDu24IjgxzVbMS+L+uYG5Bcg0pKrg/5qXxEWiuMAia
         vffdUbtcNsLvtKrlK4k+jcwRwHNdA8Lw5naABJfruZOqGKC8i603wB1dFg+AwO1TudBg
         hRMFIt5PYGst7e+ep5PnmbaJMN+bQmW3H7kQk9yN8FS3aXz8K9H46JTxNwFfjubGd7N0
         ozSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Tie7P8DpWVuLMjQ05PFQFoqxbFyJhXbe0tq79aNlVHc=;
        b=Ksr4Af37xZ++BeNkmFyEmmOT7YzsN1mUIa0ezevHvXMeGRcwM08m0EBi8tTy5wRPNq
         AeKn+S4rTcSba4KhV3lFE7WRM8dg8mujJwZUM73+tTN9WuGBVSvByVzk5lz3n6V+qkYI
         Ys0rWqV5/3oL/DRE/1Bc8/AtCiPq7ilUqQ/eudp/lKRADiy7QftRNgWKuviptrfJMiEc
         usAf8Qz+iUOZTLPtmeSO1/ffwMkO/lAMG4S03CeaW94MWmTfLz2pad7uWcjOoxZ49ztZ
         dnnYIsXZE/BKFEse3HLAHi57kxrnCRGL8glXwAFRDrG9UIdKH5uKXdIIUkqJvxyrCa5m
         fGoQ==
X-Gm-Message-State: AFqh2koSqi0PZpCJnPsb4BSauhlNNKWVvGGvAiPGjW2BXq33UJk+mk5k
        QbDe+6OBGiU/hEVyCZKZJww=
X-Google-Smtp-Source: AMrXdXseVuSIixnld/BKH87fSqTycVCSeEtcwnb5kCMqIbpauSSGWuC7wNW9jWBlj1betMg434qPNg==
X-Received: by 2002:a05:622a:2483:b0:3a8:20e5:49bc with SMTP id cn3-20020a05622a248300b003a820e549bcmr67081993qtb.41.1674848400053;
        Fri, 27 Jan 2023 11:40:00 -0800 (PST)
Received: from [192.168.1.3] (ip72-194-116-95.oc.oc.cox.net. [72.194.116.95])
        by smtp.gmail.com with ESMTPSA id i25-20020ac860d9000000b003b54a8fd02dsm3151745qtm.87.2023.01.27.11.39.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 27 Jan 2023 11:39:59 -0800 (PST)
Message-ID: <5f033009-fcb2-702f-be98-507b421dd35f@gmail.com>
Date:   Fri, 27 Jan 2023 11:39:56 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.0
Subject: Re: [PATCH v5 net-next 06/13] net: dsa: felix: add configurable
 device quirks
Content-Language: en-US
To:     Colin Foster <colin.foster@in-advantage.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org
Cc:     Russell King <linux@armlinux.org.uk>,
        Richard Cochran <richardcochran@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>, UNGLinuxDriver@microchip.com,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, Lee Jones <lee@kernel.org>
References: <20230127193559.1001051-1-colin.foster@in-advantage.com>
 <20230127193559.1001051-7-colin.foster@in-advantage.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20230127193559.1001051-7-colin.foster@in-advantage.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 1/27/2023 11:35 AM, Colin Foster wrote:
> The define FELIX_MAC_QUIRKS was used directly in the felix.c shared driver.
> Other devices (VSC7512 for example) don't require the same quirks, so they
> need to be configured on a per-device basis.
> 
> Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
> Reviewed-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
