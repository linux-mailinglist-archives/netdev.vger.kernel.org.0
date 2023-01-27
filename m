Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8059E67EEA0
	for <lists+netdev@lfdr.de>; Fri, 27 Jan 2023 20:44:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232466AbjA0Toh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Jan 2023 14:44:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231274AbjA0TnW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Jan 2023 14:43:22 -0500
Received: from mail-qt1-x829.google.com (mail-qt1-x829.google.com [IPv6:2607:f8b0:4864:20::829])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 765D52311F;
        Fri, 27 Jan 2023 11:43:03 -0800 (PST)
Received: by mail-qt1-x829.google.com with SMTP id x17so4945320qto.10;
        Fri, 27 Jan 2023 11:43:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=L9FPwiiMhc30oqaohzhFldZtxeOBDInyiYiR9raaWYc=;
        b=QlSdjsmameYp5PgFRQTxLBEO0p9lKVzYdwpBM5KuFTpnzMHYH6HiH4/8K61im9NZUY
         vHegDoQw/cTPH5Daj0RjDSV7FEnffR37OJsco0k9B4leV1e+AfQBAXVMOOHhrdRpBl2w
         i9Q2foZrjhECGRo/7bkj7Wi4tbtzoawDhRiIctS36r7VdOfUFPYggrn5rsRdAxR/p76A
         JJkE33zrCZDsydBHvTUMXEy+hQ8ajf/E4moyyhQ5GUwxF3B1QN1HtiF22+Ux11fjYe2b
         8qW/mCncMyKIWSs+wTYQLleg9I7kbwWNFzHwIxKBx1c94zwkX6iatNzlXp36ydB+bTzI
         fCcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=L9FPwiiMhc30oqaohzhFldZtxeOBDInyiYiR9raaWYc=;
        b=ClLnvETF9XLegXVgwEDldn+x7LeBA8N1iMqtVzcQdfqeStXLh5ZvgEHSzxWPRObkcH
         AKbrW7EGBquuoQWHimOpTquDD7qyzmIdCE1yE3S3FCMv1p0cJPJmUcbMCnDHdr+RNLxS
         tcnuR1soZDynSzdk0mc1se1VSicKF7tjuuebffOq8nRFD4vKM/iHOz/+SXZ3YjC1Na+p
         NuiTy71cCiq4GbeBYNv8P13tWv02nIYgsPsTiBQG35I8+Ayx+zXHCQRbdY1vEPTn8Vyn
         4E9lrbJJg0hm+f6fVJRJrDM4+J0G03uOUs+ryUKjKQIz+aAqo2QgBeGET8GNKOIL1obP
         ZplA==
X-Gm-Message-State: AO0yUKVv97ybNbzS/NhJOZBQklqtU9DiQZuCFvElRNi0QcfYKwHfOhPz
        SzHvm7kuhoU1GNJpngtnkzo=
X-Google-Smtp-Source: AK7set+cqcAmbN8apB4Fe2yUXDKTl1+mC88UtDYWmuP9yDrGSZFotAPuWYdyRlZB7PY6V6IKA3nv/g==
X-Received: by 2002:a05:622a:1443:b0:3b8:2615:8b8a with SMTP id v3-20020a05622a144300b003b826158b8amr4995259qtx.44.1674848514814;
        Fri, 27 Jan 2023 11:41:54 -0800 (PST)
Received: from [192.168.1.3] (ip72-194-116-95.oc.oc.cox.net. [72.194.116.95])
        by smtp.gmail.com with ESMTPSA id 199-20020a3703d0000000b0071b158849e5sm18026qkd.46.2023.01.27.11.41.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 27 Jan 2023 11:41:54 -0800 (PST)
Message-ID: <eb552d62-b5ff-9688-ad04-b5b87bd5b8af@gmail.com>
Date:   Fri, 27 Jan 2023 11:41:51 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.0
Subject: Re: [PATCH v5 net-next 08/13] net: dsa: felix: add functionality when
 not all ports are supported
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
 <20230127193559.1001051-9-colin.foster@in-advantage.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20230127193559.1001051-9-colin.foster@in-advantage.com>
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
> When the Felix driver would probe the ports and verify functionality, it
> would fail if it hit single port mode that wasn't supported by the driver.
> 
> The initial case for the VSC7512 driver will have physical ports that
> exist, but aren't supported by the driver implementation. Add the
> OCELOT_PORT_MODE_NONE macro to handle this scenario, and allow the Felix
> driver to continue with all the ports that are currently functional.
> 
> Signed-off-by: Colin Foster <colin.foster@in-advantage.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
