Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A11164BF0D0
	for <lists+netdev@lfdr.de>; Tue, 22 Feb 2022 05:11:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239232AbiBVDvZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Feb 2022 22:51:25 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:60808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234555AbiBVDvY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Feb 2022 22:51:24 -0500
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3100C24BD7
        for <netdev@vger.kernel.org>; Mon, 21 Feb 2022 19:51:00 -0800 (PST)
Received: by mail-pj1-x1033.google.com with SMTP id m1-20020a17090a668100b001bc023c6f34so1079837pjj.3
        for <netdev@vger.kernel.org>; Mon, 21 Feb 2022 19:51:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=zmZFBZRaK2OOKjvVbBEdzqptELV3TTxl4FWkf3floPE=;
        b=l/uQC8UePEQQ/tASGb4X8vtLCzMWLXO4eavSdI5TIaecEJlcuuidK93DAF1WzGiDQK
         +kkVKUdAWSd+st7IE5I8CLfh7bsc5q80GhNGouMpwxMU+EDcSptveJEYAd8+4pdaT75U
         h17Ckt5SJz+wyD45901HbHJBB+YXBpYS9ThlpDYAdx2Q1hcQJML/vMRtGv7eakQmGdxT
         cc+04W7rK+DPx37Zlx7XUcFmqKSOa2txcsF6WMvfs46t0TVinO1WAPek1pk/mbaDMj/Z
         RO9GSA6c3gWf6ml4tj+93aeIbs+cs+7B8cSMjfDS40VLXL3W0IhGpsNNFQKHk6ZtCKyx
         xawA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=zmZFBZRaK2OOKjvVbBEdzqptELV3TTxl4FWkf3floPE=;
        b=kCsto859Ms5XhEvW4eELgBjZs01bMbKTRg40bVY2HbbUyvosz5/l4FoBWisYS1lSjb
         dxy59azRnL78yfWooTEgfP1QF3TSYW9qnxadbvaqUsdcwDfv7CCeC/Kfmj8QiVQ7yxDX
         EgpBjFe+DlakyX6DxTaplPnfeyMLVxUoIh/V6eVhlpFvyn/193z0/8FI48dbcafvJhb4
         tRcopHHRmxC5fa6GeS49Y0/6x69K5n92baodt6SFShhnKPy8wnEQmR8FQB0kw8xC/GWe
         vW5ftzYc0x+sloM4wX8jQcwiDF6xNtO7FN8pqsM29HOkW/1LfyL39kxBO1tiOwta7ZB3
         6ukQ==
X-Gm-Message-State: AOAM532G49UkIN2nj+Xkr1Cms67uVd1pYAoCyVlhSRbWCFTOGMsaqzfi
        VbJYXkg90x3/UWL4nTIkdQk=
X-Google-Smtp-Source: ABdhPJyT6Y2r2+OQzHN6m2zUcW8seUy8VkjZuQZntbh7cdtaU+XZdrhA71df6GVd05Sac1tBcmv0oA==
X-Received: by 2002:a17:90a:2d6:b0:1b8:cd70:697d with SMTP id d22-20020a17090a02d600b001b8cd70697dmr2139332pjd.78.1645501859725;
        Mon, 21 Feb 2022 19:50:59 -0800 (PST)
Received: from [192.168.1.3] (ip72-194-116-95.oc.oc.cox.net. [72.194.116.95])
        by smtp.gmail.com with ESMTPSA id d13sm14166092pfj.205.2022.02.21.19.50.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 21 Feb 2022 19:50:58 -0800 (PST)
Message-ID: <76558b81-a5ea-ad23-07a5-d6f9ebfe9956@gmail.com>
Date:   Mon, 21 Feb 2022 19:50:56 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.0
Subject: Re: [PATCH v4 net-next 08/11] net: dsa: remove "ds" and "port" from
 struct dsa_switchdev_event_work
Content-Language: en-US
To:     Vladimir Oltean <vladimir.oltean@nxp.com>, netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Ansuel Smith <ansuelsmth@gmail.com>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com, Jiri Pirko <jiri@resnulli.us>,
        Ivan Vecera <ivecera@redhat.com>
References: <20220221212337.2034956-1-vladimir.oltean@nxp.com>
 <20220221212337.2034956-9-vladimir.oltean@nxp.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20220221212337.2034956-9-vladimir.oltean@nxp.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2/21/2022 1:23 PM, Vladimir Oltean wrote:
> By construction, the struct net_device *dev passed to
> dsa_slave_switchdev_event_work() via struct dsa_switchdev_event_work
> is always a DSA slave device.
> 
> Therefore, it is redundant to pass struct dsa_switch and int port
> information in the deferred work structure. This can be retrieved at all
> times from the provided struct net_device via dsa_slave_to_port().
> 
> For the same reason, we can drop the dsa_is_user_port() check in
> dsa_fdb_offload_notify().
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
