Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D858235A5A
	for <lists+netdev@lfdr.de>; Sun,  2 Aug 2020 22:18:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727053AbgHBUSZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Aug 2020 16:18:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725910AbgHBUSZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 Aug 2020 16:18:25 -0400
Received: from mail-pj1-x1041.google.com (mail-pj1-x1041.google.com [IPv6:2607:f8b0:4864:20::1041])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55D54C06174A
        for <netdev@vger.kernel.org>; Sun,  2 Aug 2020 13:18:25 -0700 (PDT)
Received: by mail-pj1-x1041.google.com with SMTP id d4so368984pjx.5
        for <netdev@vger.kernel.org>; Sun, 02 Aug 2020 13:18:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=dNu/XYP6HDro95lenbTg7qxMzOWRMwaBg/c5gzzjhHw=;
        b=P3VymAVBQH5vD2fSXLlhCJX6YBgwP31rwZyqiHFAU4BQgxxrT/5A7ck+BQ6vd4GyIC
         AFFi7gPq7/h3jDgLH+pfkieHn53XdcQ/JErvEd7zzix28c6Rifb7SuLwtiA3yqb2VxeV
         q8hubn9ONAvW3z7cdd82U8okICMR5bOUpYUVg3pTT4uRliZm87VPf2eC1onZBAwmht4Y
         nFOHCbK+akqfavp0GJYHBnyaJWg1WmEwi/M65EtIGjrK7Hflcn97D2NxXukQYcQ2G6zc
         ktXo5Qm5HMrFPqbhGBpqH0/pb3jTFl2BOaFGAGYU5yczKxogBIGr9loA05o/0oPtLCIZ
         wRIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=dNu/XYP6HDro95lenbTg7qxMzOWRMwaBg/c5gzzjhHw=;
        b=puELd8cM8Sz/8wS5TDp57D5CP43irWi5l/zItyDC+PzkIwn8GDgZ8S7Z2U2GQSlHnI
         kbT99Jqib7nVLBkMq63Tyg3kTEJOAh5IxfY3K7DMJWzVRsjS3OBIxqw++Ta3FVfJFWi5
         kcsGdEE2r3ELk2w1uXfmApe3Kzhom4Vx40IwAXe80Bq1HJeo7rJzQD+v+Rdw7rf0Ntyb
         iEouo1SUh6tm/YhgBZgRced51RSlBqWe3ooyW074dudEhv1hRemYnTWBirKYkdFD9Qor
         K7WZFzUzcWs50j6Qj8NVUAQ5PnxbhlEfdGQid03b6P7MxGT6miwHNx6G2wyEy4KI5Z4I
         wdHA==
X-Gm-Message-State: AOAM530ldgDpJV+JTrcVzn26T9HbpeOiFRhMCAgtOr6tBip/qZeh9K/r
        OHu+CnYZ1zitXzPwEk9Pjsw=
X-Google-Smtp-Source: ABdhPJw0zweurMQ/DCP3/1UuSve5AWBdZb1jRbrZWf6rBF9NKfF30bqyzRY2HNNaapHhR8GyyAGyyw==
X-Received: by 2002:a17:90a:2c0d:: with SMTP id m13mr14808844pjd.170.1596399504922;
        Sun, 02 Aug 2020 13:18:24 -0700 (PDT)
Received: from [192.168.1.3] (ip68-111-84-250.oc.oc.cox.net. [68.111.84.250])
        by smtp.gmail.com with ESMTPSA id u66sm17688462pfb.191.2020.08.02.13.18.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 02 Aug 2020 13:18:24 -0700 (PDT)
Subject: Re: [PATCH v2 3/4 net-next] net: mdiobus: add reset-post-delay-us
 handling
To:     Bruno Thomsen <bruno.thomsen@gmail.com>,
        netdev <netdev@vger.kernel.org>
Cc:     Andrew Lunn <andrew@lunn.ch>, Fabio Estevam <festevam@gmail.com>,
        Russell King - ARM Linux <linux@armlinux.org.uk>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Lars Alex Pedersen <laa@kamstrup.com>,
        Bruno Thomsen <bth@kamstrup.com>
References: <20200730195749.4922-1-bruno.thomsen@gmail.com>
 <20200730195749.4922-4-bruno.thomsen@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <a45a29c4-7295-5482-b034-2bb911a5d36f@gmail.com>
Date:   Sun, 2 Aug 2020 13:18:23 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Firefox/68.0 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200730195749.4922-4-bruno.thomsen@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/30/2020 12:57 PM, Bruno Thomsen wrote:
> Load new "reset-post-delay-us" value from MDIO properties,
> and if configured to a greater then zero delay do a
> flexible sleeping delay after MDIO bus reset deassert.
> This allows devices to exit reset state before start
> bus communication.
> 
> Signed-off-by: Bruno Thomsen <bruno.thomsen@gmail.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
