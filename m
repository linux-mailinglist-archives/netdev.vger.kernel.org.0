Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9DB72214FC8
	for <lists+netdev@lfdr.de>; Sun,  5 Jul 2020 23:11:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728534AbgGEVLM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Jul 2020 17:11:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727785AbgGEVLM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 Jul 2020 17:11:12 -0400
Received: from mail-pl1-x641.google.com (mail-pl1-x641.google.com [IPv6:2607:f8b0:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F304BC061794
        for <netdev@vger.kernel.org>; Sun,  5 Jul 2020 14:11:11 -0700 (PDT)
Received: by mail-pl1-x641.google.com with SMTP id f2so14536766plr.8
        for <netdev@vger.kernel.org>; Sun, 05 Jul 2020 14:11:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=urUt6Po8JmdyNcHkJKl0Ja7CCzzRnnce1PZhJubqZYU=;
        b=iwyOoJI3lGTgxiQBabeyWlqtXLvjY/wO903W96T6TESC37afJYYCy+cMy6egi4epAh
         sDeFx7/O2AhYlr/+NoQCr1J24uMYR7tKqzT0HS+SN3n3P2AkowwMQ+zlMfI8VamlkO7u
         FXp2h2o+Cf+Nf5cNAY7L7KWVmhdMdBmucq80FaRqjmt0wc48RVTizijsz8/23m40PHC8
         rhfkygcGucJoUMViEOS45/m8xp6JnkN58UDHfGF8do8Aqz1APOVCZ8T+SV75hJhevPsR
         ajF31UKfUmyq26GYCvtHy8vhRYQPkcTSTZOy9Fod0pZzJNHcs2CiGddpNdWS8AYnCmyF
         AZMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=urUt6Po8JmdyNcHkJKl0Ja7CCzzRnnce1PZhJubqZYU=;
        b=pyaD5g+tfEUfCDTnmEV3JKpJgLR8KRm6fhvFOlVQXeRqd72Pu60HQ1BueUTWhJ1hBg
         nX+/pyLmrOJwokhcWFWyBscPn6tgMSVDqqKPilmjb3MkAjC6n8xoKVMyXKIwYS/ffmVl
         Tz0LSL0XzvbK2MxVcki+B2R9umJUetGXh8PID+8VU8cq0HtLkm7gEzszseMbsfRssMcJ
         6QNABKrWiea+EbHHJThlivmQLDDNXJOhIL/Nvo4vBKi+Zypl3cZAW6GxTaz3Q+2VIb06
         cEEpZRTl2GhvrJaLe/61iFo6NCyKP4nU3x/RhzYXnvdpaxTnqnab3N1OLy1Ub4olkQFI
         y4Cw==
X-Gm-Message-State: AOAM530LqFFmOzpCzqfzWVgh0HR0lq3dbvsjVoCy7ggijoFxWxH40SKz
        4hn3NQYBB3vne9d6ElEvSlQ=
X-Google-Smtp-Source: ABdhPJyZqz0M5qwlsDdGeM3iidOK4qzoswsQm3KnSHmY0t2UMeCL8oWRTget/RQOHGmCJoe7TcO5iQ==
X-Received: by 2002:a17:90a:7b84:: with SMTP id z4mr32917752pjc.106.1593983471523;
        Sun, 05 Jul 2020 14:11:11 -0700 (PDT)
Received: from ?IPv6:2001:470:67:5b9:5dec:e971:4cde:a128? ([2001:470:67:5b9:5dec:e971:4cde:a128])
        by smtp.gmail.com with ESMTPSA id h9sm15962377pjs.50.2020.07.05.14.11.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 05 Jul 2020 14:11:10 -0700 (PDT)
Subject: Re: [PATCH v3 net-next 1/6] net: dsa: felix: clarify the intention of
 writes to MII_BMCR
To:     Vladimir Oltean <olteanv@gmail.com>, davem@davemloft.net,
        netdev@vger.kernel.org
Cc:     andrew@lunn.ch, vivien.didelot@gmail.com, claudiu.manoil@nxp.com,
        alexandru.marginean@nxp.com, ioana.ciornei@nxp.com,
        linux@armlinux.org.uk
References: <20200705161626.3797968-1-olteanv@gmail.com>
 <20200705161626.3797968-2-olteanv@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <f4d6c69c-868a-deaf-333b-c2534aca8485@gmail.com>
Date:   Sun, 5 Jul 2020 14:11:08 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Firefox/68.0 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200705161626.3797968-2-olteanv@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/5/2020 9:16 AM, Vladimir Oltean wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> The driver appears to write to BMCR_SPEED and BMCR_DUPLEX, fields which
> are read-only, since they are actually configured through the
> vendor-specific IF_MODE (0x14) register.
> 
> But the reason we're writing back the read-only values of MII_BMCR is to
> alter these writable fields:
> 
> BMCR_RESET
> BMCR_LOOPBACK
> BMCR_ANENABLE
> BMCR_PDOWN
> BMCR_ISOLATE
> BMCR_ANRESTART
> 
> In particular, the only field which is really relevant to this driver is
> BMCR_ANENABLE. Clarify that intention by spelling it out, using
> phy_set_bits and phy_clear_bits.
> 
> The driver also made a few writes to BMCR_RESET and BMCR_ANRESTART which
> are unnecessary and may temporarily disrupt the link to the PHY. Remove
> them.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
