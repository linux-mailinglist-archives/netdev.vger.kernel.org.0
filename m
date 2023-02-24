Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DA5DC6A1FF3
	for <lists+netdev@lfdr.de>; Fri, 24 Feb 2023 17:46:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229757AbjBXQqW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Feb 2023 11:46:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229662AbjBXQqV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Feb 2023 11:46:21 -0500
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB1F02BF17
        for <netdev@vger.kernel.org>; Fri, 24 Feb 2023 08:46:20 -0800 (PST)
Received: by mail-pl1-x62c.google.com with SMTP id u14so81086ple.7
        for <netdev@vger.kernel.org>; Fri, 24 Feb 2023 08:46:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=zFHKgmov83yJl95cSLR3AMRl1I5n8rJYMMIEWny8aB0=;
        b=Gu6xSyl/tPLw9XqYtCMhx0bY35SKkXrOxpE+eL+O5x9XUUgrj9iloPQ2MKxfcNBZ8Q
         sWHtFrNbGCU529xiziOidFA4ku/02fM1wLVnzmg9D2yCb/7t7HwXLqZbclpoKsWkfzuF
         5E/dzu8O8Paqjf805bqGInqN6aV1DO3LvHMo9l6dN5Px9kf8S+KN2V6pD35Wyk5kqDew
         keZ94DeMRK581zWt2mNbuCaxv2rmUqfSeVSBqiHCRiL+ub8xPUH2dfuolY1tGxySTja7
         ydRKzonv3V5cmF6RvYJ2Bz8930XfKhAefGp+i58c9PXTESelc0/cPhj59PHYp2M6/A7D
         zK5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=zFHKgmov83yJl95cSLR3AMRl1I5n8rJYMMIEWny8aB0=;
        b=td0FdLm0P18Pb7j/F1NEadCustFvjoxXp0+qiEWVJSgE9tQgl8VtSM01RBqa/DXc+j
         mFMk+fnX7SNmu7CQExu4vzqc9XO77NHk4mKNk6pF4CvhzPonfTTgzZ6nL1lu/eD7MCQ/
         psvEkZRlkpUhhHuFKbRfd95K92/zL0F37QCUZh6HiCg8ar0jjfdhFMWsU8qeBDp4AWST
         fh14+refMZ48xWVRoqOdanH2ATpFgj8XcPUEGh3QC3bd7VbmHdYWjOrNP6QoxTHUdi5O
         3uKOC+vUO0VZ2UgGUVfa1YZuHj1UamzsaocoDYm4qpKczX4Di7UwL5U4OhkhyN5ZOJ3O
         OmLQ==
X-Gm-Message-State: AO0yUKWpPWihJuzCrsya6xpnZE1OQqGX1XKRBjJP+ERoPsaMWElaDxVh
        2mGJCSxo1XkqNZBv9KuIS1rtSNaQBns=
X-Google-Smtp-Source: AK7set8Jfn4woSU/Qh5YUtTj7oR8HwyX4eB9ijT+ZbhcM2wL2VEUicbAnJbhcCsTCTr9lphsvPiWgg==
X-Received: by 2002:a17:90a:194c:b0:237:47b0:3ea8 with SMTP id 12-20020a17090a194c00b0023747b03ea8mr9589223pjh.41.1677257180092;
        Fri, 24 Feb 2023 08:46:20 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id h1-20020a17090adb8100b002341ae23ad7sm6699993pjv.1.2023.02.24.08.46.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 24 Feb 2023 08:46:19 -0800 (PST)
Message-ID: <98baf6c1-957e-f422-5033-8a5ccfcde451@gmail.com>
Date:   Fri, 24 Feb 2023 08:46:16 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH net] net: dsa: ocelot_ext: remove unnecessary phylink.h
 include
Content-Language: en-US
To:     "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com
Cc:     Colin Foster <colin.foster@in-advantage.com>,
        Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org
References: <E1pVbBE-00CiJn-NK@rmk-PC.armlinux.org.uk>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <E1pVbBE-00CiJn-NK@rmk-PC.armlinux.org.uk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/24/23 08:44, Russell King (Oracle) wrote:
> During review of ocelot_ext, it created a private phylink instance
> that wasn't necessary. This was removed for subsequent postings,
> but the include file seems to have been left behind. Remove it.
> 
> Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian

